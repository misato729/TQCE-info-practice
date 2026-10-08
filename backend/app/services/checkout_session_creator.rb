class CheckoutSessionCreator
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class AlreadyActiveError < Error; end
  class SessionInProgressError < Error; end

  Result = Data.define(:session_id, :checkout_url)

  def initialize(user:, client: nil)
    @user = user
    @client = client
  end

  def call
    raise ConfigurationError, "有料会員の販売設定が完了していません" unless PaidMembership.enabled?

    User.transaction do
      user.lock!
      raise AlreadyActiveError, "すでに有料コンテンツを利用できます" if user.paid_content_access?
      validate_price!

      pending_payment = user.payments.pending.order(created_at: :desc).first
      if pending_payment
        pending_result = pending_session_result(pending_payment)
        next pending_result if pending_result
      end

      session = create_stripe_session
      save_payment!(session)
      Result.new(session_id: session.id, checkout_url: session.url)
    rescue ActiveRecord::RecordNotUnique
      raise SessionInProgressError, "未完了の決済があります"
    end
  end

  private

  attr_reader :user

  def client
    @client ||= PaidMembership.stripe_client
  end

  def validate_price!
    price = client.v1.prices.retrieve(ENV.fetch("STRIPE_PRICE_ID"))
    valid = price.active &&
      price.currency == PaidMembership::CURRENCY &&
      price.unit_amount == PaidMembership::AMOUNT &&
      price.type == "one_time"
    raise ConfigurationError, "Stripe Priceの設定が販売条件と一致しません" unless valid
  end

  def create_stripe_session
    session = client.v1.checkout.sessions.create(
      {
        payment_method_types: ["card"],
        mode: "payment",
        locale: "ja",
        line_items: [{ price: ENV.fetch("STRIPE_PRICE_ID"), quantity: 1 }],
        client_reference_id: user.id.to_s,
        customer_email: user.email,
        consent_collection: { terms_of_service: "required" },
        custom_text: {
          submit: {
            message: "「模擬試験6以降の利用資格」を500円（税込）で買い切る契約です。月額課金や自動更新はありません。決済完了後に利用資格を提供し、提供開始後の利用者都合による返金は原則として受け付けません。",
          },
        },
        metadata: {
          user_id: user.id.to_s,
          purchase_type: "paid_membership",
          stripe_price_id: ENV.fetch("STRIPE_PRICE_ID"),
        },
        payment_intent_data: {
          metadata: {
            user_id: user.id.to_s,
            purchase_type: "paid_membership",
            stripe_price_id: ENV.fetch("STRIPE_PRICE_ID"),
          },
        },
        success_url: "#{PaidMembership.frontend_url}/premium/complete",
        cancel_url: "#{PaidMembership.frontend_url}/premium?canceled=1",
      },
      { idempotency_key: "paid-membership-user-#{user.id}-#{SecureRandom.uuid}" },
    )

    unless session.status == "open" && session.url.present? && session.livemode == PaidMembership.livemode?
      expire_session(session.id) if session.status == "open"
      raise ConfigurationError, "Stripe Checkout Sessionの設定を確認できません"
    end

    session
  end

  def pending_session_result(payment)
    session = client.v1.checkout.sessions.retrieve(payment.stripe_checkout_session_id)
    unless session.livemode == PaidMembership.livemode?
      raise ConfigurationError, "Stripe Checkout Sessionの実行モードが一致しません"
    end

    if session.status == "open" && session.url.present?
      return Result.new(session_id: session.id, checkout_url: session.url)
    end

    if session.status == "expired"
      payment.update!(status: "expired")
      return nil
    end

    raise SessionInProgressError, "決済完了通知を確認しています"
  end

  def save_payment!(session)
    user.payments.create!(
      stripe_checkout_session_id: session.id,
      stripe_price_id: ENV.fetch("STRIPE_PRICE_ID"),
      amount: PaidMembership::AMOUNT,
      currency: PaidMembership::CURRENCY,
      status: "pending",
    )
  rescue StandardError
    expire_session(session.id)
    raise
  end

  def expire_session(session_id)
    client.v1.checkout.sessions.expire(session_id)
  rescue Stripe::StripeError
    Rails.logger.error("Failed to expire Stripe Checkout Session after local failure")
  end
end

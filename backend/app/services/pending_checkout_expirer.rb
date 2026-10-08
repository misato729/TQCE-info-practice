class PendingCheckoutExpirer
  class Error < StandardError; end
  class PaymentProcessingError < Error; end
  class EnvironmentMismatchError < Error; end

  def initialize(user:, client: nil)
    @user = user
    @client = client
  end

  def call
    user.payments.pending.lock.order(:id).each do |payment|
      session = client.v1.checkout.sessions.retrieve(payment.stripe_checkout_session_id)
      unless session.livemode == PaidMembership.livemode?
        raise EnvironmentMismatchError, "Stripe Checkout Sessionの実行モードが一致しません"
      end

      case session.status
      when "open"
        expired_session = client.v1.checkout.sessions.expire(session.id)
        unless expired_session.status == "expired"
          raise PaymentProcessingError, "決済画面を終了できませんでした"
        end
        payment.update!(status: "expired")
      when "expired"
        payment.update!(status: "expired")
      else
        raise PaymentProcessingError, "決済完了通知を確認しています"
      end
    end
  end

  private

  attr_reader :user

  def client
    @client ||= PaidMembership.stripe_client
  end
end

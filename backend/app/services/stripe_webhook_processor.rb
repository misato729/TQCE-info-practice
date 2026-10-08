class StripeWebhookProcessor
  class Error < StandardError; end
  class EnvironmentMismatchError < Error; end
  class EventMismatchError < Error; end
  class PaymentNotReadyError < Error; end

  SUPPORTED_EVENT_TYPES = %w[
    checkout.session.completed
    checkout.session.expired
    refund.created
    refund.updated
    refund.failed
    charge.dispute.created
    charge.dispute.closed
  ].freeze

  def initialize(event:, client: nil)
    @event = event
    @client = client
  end

  def call
    unless event.livemode == PaidMembership.livemode?
      raise EnvironmentMismatchError, "Stripeイベントの実行モードが一致しません"
    end

    duplicate = false
    StripeWebhookEvent.transaction do
      if StripeWebhookEvent.exists?(stripe_event_id: event.id)
        duplicate = true
        next
      end

      process_event if SUPPORTED_EVENT_TYPES.include?(event.type)
      StripeWebhookEvent.create!(
        stripe_event_id: event.id,
        event_type: event.type,
        livemode: event.livemode,
        processed_at: Time.current,
      )
    end

    duplicate ? :duplicate : :processed
  rescue ActiveRecord::RecordNotUnique
    raise unless StripeWebhookEvent.exists?(stripe_event_id: event.id)

    :duplicate
  end

  private

  attr_reader :event

  def client
    @client ||= PaidMembership.stripe_client
  end

  def process_event
    case event.type
    when "checkout.session.completed"
      complete_checkout(event.data.object, completed_at: stripe_time(event.created))
    when "checkout.session.expired"
      expire_checkout(event.data.object)
    when "refund.created", "refund.updated"
      process_refund(event.data.object)
    when "refund.failed"
      record_failed_refund(event.data.object, failed_at: stripe_time(event.created))
    when "charge.dispute.created"
      create_dispute(event.data.object)
    when "charge.dispute.closed"
      close_dispute(event.data.object, closed_at: stripe_time(event.created))
    end
  end

  def complete_checkout(session, completed_at:)
    payment = Payment.lock.find_by!(stripe_checkout_session_id: session.id)
    return unless payment.status == "pending"

    payment_intent_id = stripe_id(session.payment_intent)
    metadata = session.metadata || {}
    valid = session.mode == "payment" &&
      session.payment_status == "paid" &&
      session.amount_total == payment.amount &&
      session.currency == payment.currency &&
      session.client_reference_id == payment.user_id.to_s &&
      metadata["user_id"] == payment.user_id.to_s &&
      metadata["purchase_type"] == "paid_membership" &&
      metadata["stripe_price_id"] == payment.stripe_price_id &&
      payment_intent_id.present? &&
      session.livemode == PaidMembership.livemode?
    raise EventMismatchError, "Checkout Sessionの決済情報が一致しません" unless valid
    raise EventMismatchError, "購入者アカウントが存在しません" unless payment.user

    payment.update!(
      status: "paid",
      stripe_payment_intent_id: payment_intent_id,
      paid_at: completed_at,
    )
    activate_membership(payment, completed_at)
  end

  def expire_checkout(session)
    payment = Payment.lock.find_by(stripe_checkout_session_id: session.id)
    return unless payment&.status == "pending"

    payment.update!(status: "expired")
  end

  def process_refund(refund)
    return unless refund.status == "succeeded"

    payment_intent_id = stripe_id(refund.payment_intent)
    charge_id = stripe_id(refund.charge)
    payment = find_payment(payment_intent_id:, charge_id:)
    return unless payment

    charge_id ||= payment.stripe_charge_id
    raise EventMismatchError, "返金対象のChargeを確認できません" if charge_id.blank?

    charge = client.v1.charges.retrieve(charge_id)
    charge_payment_intent_id = stripe_id(charge.payment_intent)
    valid = charge.currency == payment.currency &&
      charge.amount == payment.amount &&
      charge.amount_refunded.between?(0, payment.amount) &&
      (payment.stripe_payment_intent_id.blank? || charge_payment_intent_id == payment.stripe_payment_intent_id)
    raise EventMismatchError, "返金対象の決済情報が一致しません" unless valid
    return if charge.amount_refunded.zero?

    attributes = {
      stripe_charge_id: charge.id,
      refunded_amount: charge.amount_refunded,
      status: charge.amount_refunded == payment.amount ? "refunded" : "partially_refunded",
    }
    attributes[:refunded_at] = Time.current if charge.amount_refunded == payment.amount
    payment.update!(attributes)
    revoke_membership(payment, "refund") if charge.amount_refunded == payment.amount
  end

  def create_dispute(dispute)
    payment = find_payment(
      payment_intent_id: stripe_id(dispute.payment_intent),
      charge_id: stripe_id(dispute.charge),
    )
    return unless payment

    valid = dispute.currency == payment.currency &&
      dispute.amount.to_i.positive? &&
      dispute.amount <= payment.amount
    raise EventMismatchError, "異議申立て対象の決済情報が一致しません" unless valid

    attributes = {
      status: "disputed",
      stripe_charge_id: stripe_id(dispute.charge) || payment.stripe_charge_id,
      stripe_dispute_id: dispute.id,
    }
    unless payment.stripe_dispute_id == dispute.id && payment.dispute_closed_at.present?
      attributes[:dispute_status] = dispute.status
      attributes[:dispute_closed_at] = nil
    end
    payment.update!(attributes)
    revoke_membership(payment, "dispute")
  end

  def close_dispute(dispute, closed_at:)
    payment = find_payment(
      payment_intent_id: stripe_id(dispute.payment_intent),
      charge_id: stripe_id(dispute.charge),
    )
    return unless payment

    valid = dispute.currency == payment.currency &&
      dispute.amount.to_i.positive? &&
      dispute.amount <= payment.amount &&
      dispute.status.present?
    raise EventMismatchError, "異議申立て対象の決済情報が一致しません" unless valid

    payment.update!(
      status: "disputed",
      stripe_charge_id: stripe_id(dispute.charge) || payment.stripe_charge_id,
      stripe_dispute_id: dispute.id,
      dispute_status: dispute.status,
      dispute_closed_at: closed_at,
    )
    revoke_membership(payment, "dispute")
  end

  def record_failed_refund(refund, failed_at:)
    unless refund.status == "failed"
      raise EventMismatchError, "返金失敗イベントの状態が一致しません"
    end

    payment = find_payment(
      payment_intent_id: stripe_id(refund.payment_intent),
      charge_id: stripe_id(refund.charge),
    )
    return unless payment

    payment.update!(
      stripe_charge_id: stripe_id(refund.charge) || payment.stripe_charge_id,
      last_refund_failure_reason: refund.failure_reason,
      last_refund_failed_at: failed_at,
    )
  end

  def find_payment(payment_intent_id:, charge_id:)
    scope = Payment.lock
    payment = scope.find_by(stripe_payment_intent_id: payment_intent_id) if payment_intent_id.present?
    payment ||= scope.find_by(stripe_charge_id: charge_id) if charge_id.present?
    return payment if payment

    if payment_intent_id.blank? && charge_id.present?
      charge = client.v1.charges.retrieve(charge_id)
      payment_intent_id = stripe_id(charge.payment_intent)
      payment = scope.find_by(stripe_payment_intent_id: payment_intent_id) if payment_intent_id.present?
      return payment if payment
    end

    return nil if payment_intent_id.blank?

    payment_intent = client.v1.payment_intents.retrieve(payment_intent_id)
    metadata = payment_intent.metadata || {}
    return nil unless metadata["purchase_type"] == "paid_membership"

    relevant = payment_intent.currency == PaidMembership::CURRENCY &&
      payment_intent.amount == PaidMembership::AMOUNT &&
      metadata["user_id"].present? &&
      metadata["stripe_price_id"].present?
    raise EventMismatchError, "PaymentIntentの決済情報が一致しません" unless relevant

    raise PaymentNotReadyError, "Checkout Sessionの完了通知を待っています"
  end

  def activate_membership(payment, activated_at)
    membership = Membership.find_or_initialize_by(user: payment.user)
    membership.assign_attributes(
      source_payment: payment,
      status: "active",
      activated_at: activated_at,
      revoked_at: nil,
      revocation_reason: nil,
    )
    membership.save!
  end

  def revoke_membership(payment, reason)
    membership = Membership.lock.find_by(user_id: payment.user_id)
    return unless membership&.source_payment_id == payment.id

    membership.update!(
      status: "revoked",
      revoked_at: Time.current,
      revocation_reason: reason,
    )
  end

  def stripe_id(value)
    value.respond_to?(:id) ? value.id : value
  end

  def stripe_time(value)
    value.present? ? Time.zone.at(value) : Time.current
  end
end

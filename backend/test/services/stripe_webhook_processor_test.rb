require "test_helper"

class StripeWebhookProcessorTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @payment = Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_test_123",
      stripe_price_id: "price_test",
      amount: 500,
      currency: "jpy",
      status: "pending",
    )
  end

  test "支払済みCheckoutイベントだけで資格を付与し再送を重複処理しない" do
    event = checkout_event("evt_checkout")

    assert_equal :processed, StripeWebhookProcessor.new(event: event).call
    assert_equal "paid", @payment.reload.status
    assert_equal "pi_test_123", @payment.stripe_payment_intent_id
    assert_in_delta event.created, @payment.paid_at.to_i, 1
    assert_equal "active", @user.reload.membership.status

    assert_no_difference -> { StripeWebhookEvent.count } do
      assert_equal :duplicate, StripeWebhookProcessor.new(event: event).call
    end
  end

  test "金額が一致しないCheckoutイベントでは資格を付与しない" do
    event = checkout_event("evt_bad_amount", amount_total: 499)

    assert_raises(StripeWebhookProcessor::EventMismatchError) do
      StripeWebhookProcessor.new(event: event).call
    end

    assert_equal "pending", @payment.reload.status
    assert_nil @user.reload.membership
    assert_not StripeWebhookEvent.exists?(stripe_event_id: "evt_bad_amount")
  end

  test "Event ID以外の決済重複をWebhook重複として扱わない" do
    other_user = User.create!(
      name: "別の学習ユーザー",
      email: "other@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    Payment.create!(
      user: other_user,
      stripe_checkout_session_id: "cs_other",
      stripe_payment_intent_id: "pi_test_123",
      stripe_price_id: "price_test",
      status: "paid",
      paid_at: Time.current,
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      StripeWebhookProcessor.new(event: checkout_event("evt_conflicting_payment_intent")).call
    end

    assert_equal "pending", @payment.reload.status
    assert_not StripeWebhookEvent.exists?(stripe_event_id: "evt_conflicting_payment_intent")
  end

  test "全額返金で決済と資格を失効する" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    charge = TestObject.new(
      id: "ch_test_123",
      currency: "jpy",
      amount: 500,
      amount_refunded: 500,
      payment_intent: "pi_test_123",
    )
    charges = Object.new
    charges.define_singleton_method(:retrieve) { |_id| charge }
    client = TestObject.new(v1: TestObject.new(charges: charges))
    refund = TestObject.new(status: "succeeded", payment_intent: "pi_test_123", charge: "ch_test_123")
    event = stripe_event("evt_refund", "refund.updated", refund)

    StripeWebhookProcessor.new(event: event, client: client).call

    assert_equal "refunded", @payment.reload.status
    assert_equal 500, @payment.refunded_amount
    assert_equal "revoked", @user.reload.membership.status
    assert_equal "refund", @user.membership.revocation_reason
  end

  test "異議申立てで資格を失効する" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    dispute = dispute_object

    StripeWebhookProcessor.new(
      event: stripe_event("evt_dispute", "charge.dispute.created", dispute),
    ).call

    assert_equal "disputed", @payment.reload.status
    assert_equal "du_test_123", @payment.stripe_dispute_id
    assert_equal "needs_response", @payment.dispute_status
    assert_equal "revoked", @user.reload.membership.status
    assert_equal "dispute", @user.membership.revocation_reason
  end

  test "異議申立てにPaymentIntentがなくてもChargeから決済を照合して資格を失効する" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    charge = TestObject.new(id: "ch_test_123", payment_intent: "pi_test_123")
    charges = Object.new
    charges.define_singleton_method(:retrieve) { |_id| charge }
    client = TestObject.new(v1: TestObject.new(charges: charges))
    dispute = dispute_object(payment_intent: nil)

    StripeWebhookProcessor.new(
      event: stripe_event("evt_dispute_without_pi", "charge.dispute.created", dispute),
      client: client,
    ).call

    assert_equal "ch_test_123", @payment.reload.stripe_charge_id
    assert_equal "disputed", @payment.status
    assert_equal "revoked", @user.reload.membership.status
  end

  test "異議申立て終了結果を記録し資格は自動で再開しない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    StripeWebhookProcessor.new(
      event: stripe_event("evt_dispute", "charge.dispute.created", dispute_object),
    ).call
    closed_event = stripe_event(
      "evt_dispute_closed",
      "charge.dispute.closed",
      dispute_object(status: "won"),
    )

    StripeWebhookProcessor.new(event: closed_event).call

    assert_equal "disputed", @payment.reload.status
    assert_equal "won", @payment.dispute_status
    assert_in_delta closed_event.created, @payment.dispute_closed_at.to_i, 1
    assert_equal "revoked", @user.reload.membership.status
  end

  test "異議申立て終了後に作成イベントが遅着しても終了結果を巻き戻さない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    closed_event = stripe_event(
      "evt_dispute_closed",
      "charge.dispute.closed",
      dispute_object(status: "won"),
    )
    StripeWebhookProcessor.new(event: closed_event).call

    StripeWebhookProcessor.new(
      event: stripe_event("evt_dispute_late_created", "charge.dispute.created", dispute_object),
    ).call

    assert_equal "won", @payment.reload.dispute_status
    assert_in_delta closed_event.created, @payment.dispute_closed_at.to_i, 1
    assert_equal "revoked", @user.reload.membership.status
  end

  test "返金失敗を決済へ記録する" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    refund = TestObject.new(
      status: "failed",
      payment_intent: "pi_test_123",
      charge: "ch_test_123",
      failure_reason: "expired_or_canceled_card",
    )
    failed_event = stripe_event("evt_refund_failed", "refund.failed", refund)

    StripeWebhookProcessor.new(event: failed_event, client: refund_client(refund_charge(amount_refunded: 0))).call

    assert_equal "paid", @payment.reload.status
    assert_equal "expired_or_canceled_card", @payment.last_refund_failure_reason
    assert_in_delta failed_event.created, @payment.last_refund_failed_at.to_i, 1
    assert_equal "active", @user.reload.membership.status
  end

  test "成立後に返金が失敗した場合は最新の返金額を照合し元の購入資格を戻す" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    @user.membership.update!(status: "revoked", revoked_at: Time.current, revocation_reason: "refund")
    activated_at = @user.membership.activated_at
    event = failed_refund_event

    StripeWebhookProcessor.new(event: event, client: refund_client(refund_charge(amount_refunded: 0))).call

    assert_equal "paid", @payment.reload.status
    assert_equal 0, @payment.refunded_amount
    assert_nil @payment.refunded_at
    assert_equal "active", @user.reload.membership.status
    assert_equal activated_at, @user.membership.activated_at
    assert_nil @user.membership.revoked_at
    assert_nil @user.membership.revocation_reason
    assert_no_difference -> { StripeWebhookEvent.count } do
      assert_equal :duplicate, StripeWebhookProcessor.new(event: event).call
    end
  end

  test "失敗した返金以外に全額返金が成立している場合は資格を戻さない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    @user.membership.update!(status: "revoked", revoked_at: Time.current, revocation_reason: "refund")

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 500))).call

    assert_equal "refunded", @payment.reload.status
    assert_equal 500, @payment.refunded_amount
    assert_equal "revoked", @user.reload.membership.status
  end

  test "返金失敗時も紛争により失効した資格は自動で戻さない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    StripeWebhookProcessor.new(event: stripe_event("evt_dispute", "charge.dispute.created", dispute_object)).call
    @payment.update!(refunded_amount: 500, refunded_at: Time.current)

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 0))).call

    assert_equal "disputed", @payment.reload.status
    assert_equal 0, @payment.refunded_amount
    assert_equal "revoked", @user.reload.membership.status
    assert_equal "dispute", @user.membership.revocation_reason
  end

  test "返金失敗後に部分返金が残る場合は成立した返金額だけを記録する" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    @user.membership.update!(status: "revoked", revoked_at: Time.current, revocation_reason: "refund")

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 200))).call

    assert_equal "partially_refunded", @payment.reload.status
    assert_equal 200, @payment.refunded_amount
    assert_nil @payment.refunded_at
    assert_equal "active", @user.reload.membership.status
  end

  test "返金済み状態でも紛争履歴がある資格は返金失敗だけで戻さない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    StripeWebhookProcessor.new(event: stripe_event("evt_dispute", "charge.dispute.created", dispute_object)).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    @user.membership.update!(revocation_reason: "refund")

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 0))).call

    assert_equal "disputed", @payment.reload.status
    assert_equal "du_test_123", @payment.stripe_dispute_id
    assert_equal "revoked", @user.reload.membership.status
    assert_equal "dispute", @user.membership.revocation_reason
  end

  test "Stripeに未反映の紛争がある場合も返金失敗だけで資格を戻さない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    @user.membership.update!(status: "revoked", revoked_at: Time.current, revocation_reason: "refund")

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 0, disputed: true))).call

    assert_equal "disputed", @payment.reload.status
    assert_equal 0, @payment.refunded_amount
    assert_equal "revoked", @user.reload.membership.status
  end

  test "古い決済の返金失敗は別の決済へ切り替わった資格を変更しない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    @payment.update!(status: "refunded", refunded_amount: 500, refunded_at: Time.current)
    other = @user.payments.create!(stripe_checkout_session_id: "cs_other", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    @user.membership.update!(source_payment: other, status: "revoked", revoked_at: Time.current, revocation_reason: "refund")

    StripeWebhookProcessor.new(event: failed_refund_event, client: refund_client(refund_charge(amount_refunded: 0))).call

    assert_equal "paid", @payment.reload.status
    assert_equal other.id, @user.reload.membership.source_payment_id
    assert_equal "revoked", @user.membership.status
  end

  test "返金失敗のCharge照合が一致しなければ記録も資格も変更しない" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    event = failed_refund_event
    charge = refund_charge(amount_refunded: 0, payment_intent: "pi_other")

    assert_raises(StripeWebhookProcessor::EventMismatchError) do
      StripeWebhookProcessor.new(event: event, client: refund_client(charge)).call
    end

    assert_equal "paid", @payment.reload.status
    assert_nil @payment.last_refund_failed_at
    assert_equal "active", @user.reload.membership.status
    assert_not StripeWebhookEvent.exists?(stripe_event_id: event.id)
  end

  test "返金失敗の照合通信が失敗しても処理済みにせず再試行できる" do
    StripeWebhookProcessor.new(event: checkout_event("evt_checkout")).call
    event = failed_refund_event
    charges = Object.new
    charges.define_singleton_method(:retrieve) { |_id| raise Stripe::APIConnectionError, "connection failed" }
    client = TestObject.new(v1: TestObject.new(charges: charges))

    assert_raises(Stripe::APIConnectionError) do
      StripeWebhookProcessor.new(event: event, client: client).call
    end

    assert_nil @payment.reload.last_refund_failed_at
    assert_not StripeWebhookEvent.exists?(stripe_event_id: event.id)
    assert_equal :processed, StripeWebhookProcessor.new(event: event, client: refund_client(refund_charge(amount_refunded: 0))).call
    assert @payment.reload.last_refund_failed_at
  end

  test "返金が決済完了通知より先に届いた場合は処理を確定せず再送を待つ" do
    payment_intent = TestObject.new(
      id: "pi_test_123",
      currency: "jpy",
      amount: 500,
      metadata: {
        "user_id" => @user.id.to_s,
        "purchase_type" => "paid_membership",
        "stripe_price_id" => "price_test",
      },
    )
    payment_intents = Object.new
    payment_intents.define_singleton_method(:retrieve) { |_id| payment_intent }
    client = TestObject.new(v1: TestObject.new(payment_intents: payment_intents))
    refund = TestObject.new(status: "succeeded", payment_intent: "pi_test_123", charge: "ch_test_123")
    event = stripe_event("evt_refund_early", "refund.updated", refund)

    assert_raises(StripeWebhookProcessor::PaymentNotReadyError) do
      StripeWebhookProcessor.new(event: event, client: client).call
    end

    assert_equal "pending", @payment.reload.status
    assert_not StripeWebhookEvent.exists?(stripe_event_id: "evt_refund_early")
  end

  test "本サービス以外の返金イベントは処理済みとして無視する" do
    payment_intent = TestObject.new(
      id: "pi_other",
      currency: "jpy",
      amount: 500,
      metadata: { "purchase_type" => "other_product" },
    )
    payment_intents = Object.new
    payment_intents.define_singleton_method(:retrieve) { |_id| payment_intent }
    client = TestObject.new(v1: TestObject.new(payment_intents: payment_intents))
    refund = TestObject.new(status: "succeeded", payment_intent: "pi_other", charge: "ch_other")
    event = stripe_event("evt_refund_other", "refund.updated", refund)

    assert_equal :processed, StripeWebhookProcessor.new(event: event, client: client).call
    assert StripeWebhookEvent.exists?(stripe_event_id: "evt_refund_other")
    assert_equal "pending", @payment.reload.status
  end

  test "実行モードが違うイベントを拒否する" do
    event = checkout_event("evt_live")
    event.livemode = true

    assert_raises(StripeWebhookProcessor::EnvironmentMismatchError) do
      StripeWebhookProcessor.new(event: event).call
    end
  end

  private

  def failed_refund_event
    stripe_event("evt_refund_failed", "refund.failed", TestObject.new(
      status: "failed", payment_intent: "pi_test_123", charge: "ch_test_123",
      failure_reason: "expired_or_canceled_card",
    ))
  end

  def refund_charge(amount_refunded:, disputed: false, payment_intent: "pi_test_123")
    TestObject.new(id: "ch_test_123", currency: "jpy", amount: 500,
      amount_refunded: amount_refunded, payment_intent: payment_intent, disputed: disputed)
  end

  def refund_client(charge)
    charges = Object.new
    charges.define_singleton_method(:retrieve) { |_id| charge }
    TestObject.new(v1: TestObject.new(charges: charges))
  end

  def checkout_event(id, amount_total: 500)
    session = TestObject.new(
      id: "cs_test_123",
      mode: "payment",
      payment_status: "paid",
      amount_total: amount_total,
      currency: "jpy",
      client_reference_id: @user.id.to_s,
      metadata: {
        "user_id" => @user.id.to_s,
        "purchase_type" => "paid_membership",
        "stripe_price_id" => "price_test",
      },
      payment_intent: "pi_test_123",
      livemode: false,
      created: Time.current.to_i,
    )
    stripe_event(id, "checkout.session.completed", session)
  end

  def dispute_object(payment_intent: "pi_test_123", status: "needs_response")
    TestObject.new(
      id: "du_test_123",
      payment_intent: payment_intent,
      charge: "ch_test_123",
      amount: 500,
      currency: "jpy",
      status: status,
    )
  end

  def stripe_event(id, type, object)
    TestObject.new(
      id: id,
      type: type,
      livemode: false,
      created: Time.current.to_i,
      data: TestObject.new(object: object),
    )
  end
end

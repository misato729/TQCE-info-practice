require "test_helper"
require "openssl"

class Api::V1::StripeWebhooksTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @payment = Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_test_webhook",
      stripe_price_id: "price_test",
      amount: 500,
      currency: "jpy",
      status: "pending",
    )
  end

  test "署名済みの未加工Webhook本文を処理する" do
    payload = JSON.generate(event_payload)
    secret = "whsec_test_example"

    with_env("STRIPE_WEBHOOK_SECRET" => secret, "STRIPE_LIVEMODE" => "false") do
      post api_v1_webhooks_stripe_path,
        params: payload,
        headers: {
          "CONTENT_TYPE" => "application/json",
          "Stripe-Signature" => signature_header(payload, secret),
        }
    end

    assert_response :success
    assert_equal "paid", @payment.reload.status
    assert_equal "active", @user.reload.membership.status
  end

  test "署名不正なら状態を更新しない" do
    payload = JSON.generate(event_payload)

    with_env("STRIPE_WEBHOOK_SECRET" => "whsec_test_example") do
      post api_v1_webhooks_stripe_path,
        params: payload,
        headers: { "CONTENT_TYPE" => "application/json", "Stripe-Signature" => "invalid" }
    end

    assert_response :bad_request
    assert_equal "pending", @payment.reload.status
    assert_nil @user.reload.membership
  end

  private

  def event_payload
    {
      id: "evt_webhook_test",
      object: "event",
      type: "checkout.session.completed",
      livemode: false,
      created: Time.current.to_i,
      data: {
        object: {
          id: "cs_test_webhook",
          object: "checkout.session",
          mode: "payment",
          payment_status: "paid",
          amount_total: 500,
          currency: "jpy",
          client_reference_id: @user.id.to_s,
          metadata: {
            user_id: @user.id.to_s,
            purchase_type: "paid_membership",
            stripe_price_id: "price_test",
          },
          payment_intent: "pi_webhook_test",
          livemode: false,
          created: Time.current.to_i,
        },
      },
    }
  end

  def signature_header(payload, secret)
    timestamp = Time.current.to_i
    signature = OpenSSL::HMAC.hexdigest("SHA256", secret, "#{timestamp}.#{payload}")
    "t=#{timestamp},v1=#{signature}"
  end
end

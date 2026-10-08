require "test_helper"

class PendingCheckoutExpirerTest < ActiveSupport::TestCase
  class FakeSessionService
    attr_reader :expired_id
    attr_accessor :session

    def retrieve(_session_id)
      session
    end

    def expire(session_id)
      @expired_id = session_id
      TestObject.new(id: session_id, status: "expired")
    end
  end

  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @payment = Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_pending",
      stripe_price_id: "price_test",
      status: "pending",
    )
    @sessions = FakeSessionService.new
    checkout = TestObject.new(sessions: @sessions)
    @client = TestObject.new(v1: TestObject.new(checkout: checkout))
  end

  test "開いているCheckout Sessionを失効させる" do
    @sessions.session = TestObject.new(id: "cs_pending", status: "open", livemode: false)

    PendingCheckoutExpirer.new(user: @user, client: @client).call

    assert_equal "cs_pending", @sessions.expired_id
    assert_equal "expired", @payment.reload.status
  end

  test "決済完了確認中は失効扱いにしない" do
    @sessions.session = TestObject.new(id: "cs_pending", status: "complete", livemode: false)

    assert_raises(PendingCheckoutExpirer::PaymentProcessingError) do
      PendingCheckoutExpirer.new(user: @user, client: @client).call
    end

    assert_equal "pending", @payment.reload.status
  end
end

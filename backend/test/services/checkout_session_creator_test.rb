require "test_helper"

class CheckoutSessionCreatorTest < ActiveSupport::TestCase
  class FakePriceService
    attr_reader :retrieved_id
    attr_accessor :price

    def initialize
      @price = TestObject.new(active: true, currency: "jpy", unit_amount: 500, type: "one_time")
    end

    def retrieve(id)
      @retrieved_id = id
      price
    end
  end

  class FakeSessionService
    attr_reader :params, :options
    attr_accessor :retrieved_session

    def create(params, options)
      @params = params
      @options = options
      TestObject.new(id: "cs_test_123", url: "https://checkout.stripe.com/example", status: "open", livemode: false)
    end

    def expire(_session_id); end

    def retrieve(_session_id)
      retrieved_session
    end
  end

  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @prices = FakePriceService.new
    @sessions = FakeSessionService.new
    checkout = TestObject.new(sessions: @sessions)
    @client = TestObject.new(v1: TestObject.new(prices: @prices, checkout: checkout))
  end

  test "固定Priceを検証して買い切りのCheckout Sessionを作成する" do
    with_payment_env do
      result = CheckoutSessionCreator.new(user: @user, client: @client).call

      assert_equal "cs_test_123", result.session_id
      assert_equal "price_test", @prices.retrieved_id
      assert_equal "payment", @sessions.params.fetch(:mode)
      assert_equal "ja", @sessions.params.fetch(:locale)
      assert_equal ["card"], @sessions.params.fetch(:payment_method_types)
      assert_equal "required", @sessions.params.dig(:consent_collection, :terms_of_service)
      assert_includes @sessions.params.dig(:custom_text, :submit, :message), "模擬試験6以降の利用資格"
      assert_equal @user.id.to_s, @sessions.params.fetch(:client_reference_id)
      assert_equal [{ price: "price_test", quantity: 1 }], @sessions.params.fetch(:line_items)
      assert_equal "https://example.test/premium/complete", @sessions.params.fetch(:success_url)
      assert_equal "https://example.test/premium?canceled=1", @sessions.params.fetch(:cancel_url)
      assert_equal "paid_membership", @sessions.params.dig(:payment_intent_data, :metadata, :purchase_type)
      assert_match(
        /\Apaid-membership-user-#{@user.id}-[0-9a-f-]{36}\z/,
        @sessions.options.fetch(:idempotency_key),
      )

      payment = Payment.find_by!(stripe_checkout_session_id: "cs_test_123")
      assert_equal @user, payment.user
      assert_equal "pending", payment.status
      assert_equal 500, payment.amount
    end
  end

  test "販売設定が無効ならStripeへ接続しない" do
    with_env("PAID_MEMBERSHIP_ENABLED" => "false") do
      assert_raises(CheckoutSessionCreator::ConfigurationError) do
        CheckoutSessionCreator.new(user: @user, client: @client).call
      end
    end
    assert_nil @prices.retrieved_id
  end

  test "Stripe Priceの金額が500円でなければSessionを作成しない" do
    @prices.price = TestObject.new(active: true, currency: "jpy", unit_amount: 499, type: "one_time")

    with_payment_env do
      assert_raises(CheckoutSessionCreator::ConfigurationError) do
        CheckoutSessionCreator.new(user: @user, client: @client).call
      end
    end

    assert_nil @sessions.params
    assert_not Payment.exists?(user: @user)
  end

  test "未完了のCheckout Sessionが開いていれば同じURLを返す" do
    Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_existing",
      stripe_price_id: "price_test",
      status: "pending",
    )
    @sessions.retrieved_session = TestObject.new(
      id: "cs_existing",
      url: "https://checkout.stripe.com/existing",
      status: "open",
      livemode: false,
    )

    with_payment_env do
      assert_no_difference -> { Payment.count } do
        result = CheckoutSessionCreator.new(user: @user, client: @client).call
        assert_equal "cs_existing", result.session_id
        assert_equal "https://checkout.stripe.com/existing", result.checkout_url
      end
    end
  end

  test "有効な資格がある場合は重複購入を拒否する" do
    payment = Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_paid",
      stripe_price_id: "price_test",
      status: "paid",
      paid_at: Time.current,
    )
    Membership.create!(user: @user, source_payment: payment, status: "active", activated_at: Time.current)

    with_payment_env do
      assert_raises(CheckoutSessionCreator::AlreadyActiveError) do
        CheckoutSessionCreator.new(user: @user, client: @client).call
      end
    end
  end

  private

  def with_payment_env(&block)
    with_env(
      "PAID_MEMBERSHIP_ENABLED" => "true",
      "STRIPE_SECRET_KEY" => "sk_test_example",
      "STRIPE_WEBHOOK_SECRET" => "whsec_example",
      "STRIPE_PRICE_ID" => "price_test",
      "FRONTEND_URL" => "https://example.test",
      "STRIPE_LIVEMODE" => "false",
      "NUXT_PUBLIC_SELLER_NAME" => "テスト販売者",
      "NUXT_PUBLIC_SELLER_REPRESENTATIVE" => "テスト責任者",
      "NUXT_PUBLIC_SELLER_ADDRESS" => "東京都テスト区",
      "NUXT_PUBLIC_SELLER_PHONE" => "00-0000-0000",
      "NUXT_PUBLIC_SELLER_EMAIL" => "seller@example.test",
      &block
    )
  end
end

require "test_helper"

class Api::V1::PaymentsTest < ActionDispatch::IntegrationTest
  test "公開販売設定は秘密情報を含めず初期状態で無効" do
    with_env(
      "PAID_MEMBERSHIP_ENABLED" => "false",
      "STRIPE_SECRET_KEY" => "secret-must-not-appear",
      "STRIPE_WEBHOOK_SECRET" => "webhook-must-not-appear",
      "STRIPE_PRICE_ID" => "price-must-not-appear",
    ) do
      get api_v1_payments_config_path
    end

    assert_response :success
    data = response.parsed_body.fetch("data")
    assert_not data.fetch("enabled")
    assert_equal 500, data.fetch("amount")
    assert_equal "jpy", data.fetch("currency")
    assert_not_includes response.body, "must-not-appear"
  end

  test "公開販売設定から特定商取引法表示用の販売者情報を取得できる" do
    with_env(
      "NUXT_PUBLIC_SELLER_NAME" => "テスト販売者",
      "NUXT_PUBLIC_SELLER_REPRESENTATIVE" => "テスト責任者",
      "NUXT_PUBLIC_SELLER_ADDRESS" => "東京都テスト区",
      "NUXT_PUBLIC_SELLER_PHONE" => "00-0000-0000",
      "NUXT_PUBLIC_SELLER_EMAIL" => "seller@example.test",
    ) do
      get api_v1_payments_config_path
    end

    assert_response :success
    seller = response.parsed_body.dig("data", "seller")
    assert_equal "テスト販売者", seller.fetch("name")
    assert_equal "テスト責任者", seller.fetch("representative")
    assert_equal "東京都テスト区", seller.fetch("address")
    assert_equal "00-0000-0000", seller.fetch("phone")
    assert_equal "seller@example.test", seller.fetch("email")
  end

  test "Checkout Session作成にはログインが必要" do
    post api_v1_payments_checkout_sessions_path, params: {}, as: :json

    assert_response :unauthorized
  end

  test "請求時開示では公開APIに住所と電話番号の実値を含めない" do
    with_env("PAID_MEMBERSHIP_ENABLED" => "false", "SELLER_CONTACT_DISCLOSURE_MODE" => "on_request",
      "SELLER_CONTACT_DISCLOSURE_READY" => "true", "NUXT_PUBLIC_SELLER_NAME" => "テスト販売者",
      "NUXT_PUBLIC_SELLER_REPRESENTATIVE" => "テスト責任者", "NUXT_PUBLIC_SELLER_EMAIL" => "seller@example.invalid",
      "NUXT_PUBLIC_SELLER_ADDRESS" => "private-synthetic-address", "NUXT_PUBLIC_SELLER_PHONE" => "private-synthetic-phone") do
      get api_v1_payments_config_path
    end
    assert_response :success
    data = response.parsed_body.fetch("data")
    assert_not data.fetch("enabled")
    assert_equal "on_request", data.dig("seller", "contact_disclosure_mode")
    assert_equal true, data.dig("seller", "contact_disclosure_ready")
    assert_equal "", data.dig("seller", "address")
    assert_equal "", data.dig("seller", "phone")
    assert_equal "seller@example.invalid", data.dig("seller", "email")
    assert_not_includes response.body, "private-synthetic"
  end

  test "開示体制が未確認なら販売フラグが有効でも販売を開始しない" do
    with_env("PAID_MEMBERSHIP_ENABLED" => "true", "SELLER_CONTACT_DISCLOSURE_MODE" => "on_request",
      "SELLER_CONTACT_DISCLOSURE_READY" => "false") do
      get api_v1_payments_config_path
    end
    assert_response :success
    assert_not response.parsed_body.dig("data", "enabled")
    assert_equal false, response.parsed_body.dig("data", "seller", "contact_disclosure_ready")
  end

  test "販売開始フラグが有効でも販売者情報が不足していれば販売を無効にする" do
    with_env(
      "PAID_MEMBERSHIP_ENABLED" => "true",
      "STRIPE_SECRET_KEY" => "sk_test_example",
      "STRIPE_WEBHOOK_SECRET" => "whsec_example",
      "STRIPE_PRICE_ID" => "price_test",
      "FRONTEND_URL" => "https://example.test",
      "NUXT_PUBLIC_SELLER_NAME" => "テスト販売者",
      "NUXT_PUBLIC_SELLER_REPRESENTATIVE" => "テスト責任者",
      "NUXT_PUBLIC_SELLER_ADDRESS" => "東京都テスト区",
      "NUXT_PUBLIC_SELLER_PHONE" => nil,
      "NUXT_PUBLIC_SELLER_EMAIL" => "seller@example.test",
    ) do
      get api_v1_payments_config_path
    end

    assert_response :success
    assert_not response.parsed_body.dig("data", "enabled")
  end

  test "必須設定がない場合はログイン中でも販売を開始しない" do
    user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    with_env("PAID_MEMBERSHIP_ENABLED" => "false") do
      post api_v1_payments_checkout_sessions_path,
        params: {},
        headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" },
        as: :json
    end

    assert_response :service_unavailable
    assert_equal "payment_unavailable", response.parsed_body.dig("error", "code")
  end
end

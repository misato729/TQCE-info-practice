require "test_helper"

class Api::V1::MeTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
  end

  test "無料会員の利用資格を返す" do
    get api_v1_me_path, headers: @headers

    assert_response :success
    assert_not response.parsed_body.dig("data", "paid_content_access")
    assert_equal "free", response.parsed_body.dig("data", "membership", "status")
  end

  test "現在のパスワード確認後にアカウントを削除し決済との関連を外す" do
    payment = Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_delete",
      stripe_price_id: "price_test",
      status: "paid",
      paid_at: Time.current,
    )
    Membership.create!(user: @user, source_payment: payment, status: "active", activated_at: Time.current)

    assert_difference -> { User.count }, -1 do
      delete api_v1_me_path,
        params: { current_password: "password123" },
        headers: @headers,
        as: :json
    end

    assert_response :no_content
    assert_nil payment.reload.user_id
    assert_not Membership.exists?(user_id: @user.id)
  end

  test "現在のパスワードが違う場合は削除しない" do
    assert_no_difference -> { User.count } do
      delete api_v1_me_path,
        params: { current_password: "incorrect" },
        headers: @headers,
        as: :json
    end

    assert_response :unprocessable_content
  end

  test "決済完了確認中はアカウントを削除しない" do
    Payment.create!(
      user: @user,
      stripe_checkout_session_id: "cs_pending_delete",
      stripe_price_id: "price_test",
      status: "pending",
    )
    expirer = Object.new
    expirer.define_singleton_method(:call) do
      raise PendingCheckoutExpirer::PaymentProcessingError
    end

    original_constructor = PendingCheckoutExpirer.method(:new)
    PendingCheckoutExpirer.define_singleton_method(:new) { |**_arguments| expirer }
    begin
      assert_no_difference -> { User.count } do
        delete api_v1_me_path,
          params: { current_password: "password123" },
          headers: @headers,
          as: :json
      end
    ensure
      PendingCheckoutExpirer.define_singleton_method(:new, original_constructor)
    end

    assert_response :conflict
    assert_equal "checkout_session_in_progress", response.parsed_body.dig("error", "code")
  end
end

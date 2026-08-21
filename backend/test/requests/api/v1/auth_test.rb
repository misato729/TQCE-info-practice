require "test_helper"

class Api::V1::AuthTest < ActionDispatch::IntegrationTest
  test "会員登録してアクセストークンを取得できる" do
    post "/api/v1/auth/signup", params: {
      name: "学習ユーザー",
      email: " User@Example.com ",
      password: "password123",
      password_confirmation: "password123",
    }, as: :json

    assert_response :created
    assert response.parsed_body.dig("data", "access_token").present?
    assert_equal "user@example.com", response.parsed_body.dig("data", "user", "email")
    assert User.find_by(email: "user@example.com").authenticate("password123")
  end

  test "登録済みユーザーがログインできる" do
    User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    post "/api/v1/auth/login", params: {
      email: "user@example.com",
      password: "password123",
    }, as: :json

    assert_response :success
    assert response.parsed_body.dig("data", "access_token").present?
  end

  test "同じメールアドレスでは重複登録できない" do
    User.create!(
      name: "登録済みユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    assert_no_difference "User.count" do
      post "/api/v1/auth/signup", params: {
        name: "別のユーザー",
        email: "USER@example.com",
        password: "password123",
        password_confirmation: "password123",
      }, as: :json
    end

    assert_response :unprocessable_content
    assert_equal "validation_error", response.parsed_body.dig("error", "code")
    assert response.parsed_body.dig("error", "details", "email").present?
  end

  test "確認用パスワードが一致しない場合は登録できない" do
    assert_no_difference "User.count" do
      post "/api/v1/auth/signup", params: {
        name: "学習ユーザー",
        email: "user@example.com",
        password: "password123",
        password_confirmation: "different123",
      }, as: :json
    end

    assert_response :unprocessable_content
    assert response.parsed_body.dig("error", "details", "password_confirmation").present?
  end

  test "不正なパスワードではログインできない" do
    User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    post "/api/v1/auth/login", params: {
      email: "user@example.com",
      password: "incorrect",
    }, as: :json

    assert_response :unauthorized
  end
end

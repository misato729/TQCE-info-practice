require "test_helper"
require_relative "../../../support/method_replacement"

class Api::V1::RateLimitsTest < ActionDispatch::IntegrationTest
  include MethodReplacement

  test "login throttling returns the standard error and a bounded retry time" do
    ApiRateLimiter::RULES.fetch(:login).fetch(:limit).times do
      post "/api/v1/auth/login", params: { email: "qa@example.invalid", password: "invalid-password" }, as: :json
      assert_response :unauthorized
    end
    post "/api/v1/auth/login", params: {}, as: :json
    assert_response :too_many_requests
    assert_equal "rate_limit_exceeded", response.parsed_body.dig("error", "code")
    assert_operator response.headers.fetch("Retry-After").to_i, :>, 0
    assert_operator response.headers.fetch("Retry-After").to_i, :<=, 300
    assert_equal "no-store", response.headers.fetch("Cache-Control")
    assert_not_includes response.body, "qa@example.invalid"
  end

  test "signup attempts are limited before writing accounts" do
    10.times do
      post "/api/v1/auth/signup", params: {}, as: :json
      assert_response :unprocessable_content
    end
    assert_no_difference "User.count" do
      post "/api/v1/auth/signup", params: { name: "QA", email: "qa@example.invalid", password: "password123", password_confirmation: "password123" }, as: :json
    end
    assert_response :too_many_requests
  end

  test "forwarded headers cannot change the direct-client quota outside Fly" do
    with_env("FLY_APP_NAME" => nil) do
      31.times do |n|
        post "/api/v1/auth/login", params: {}, headers: { "X-Forwarded-For" => "192.0.2.#{n}", "Fly-Client-IP" => "198.51.100.#{n}" }, as: :json
      end
    end
    assert_response :too_many_requests
    assert_equal 1, ApiRateLimitBucket.count
  end

  test "Fly uses the edge-client address and keeps distinct clients independent" do
    with_env("FLY_APP_NAME" => "test-app") do
      31.times { post "/api/v1/auth/login", params: {}, headers: { "Fly-Client-IP" => "192.0.2.1" }, as: :json }
      assert_response :too_many_requests
      post "/api/v1/auth/login", params: {}, headers: { "Fly-Client-IP" => "192.0.2.2" }, as: :json
      assert_response :unauthorized
    end
  end

  test "answers are throttled before loading a question and public reads are untouched" do
    limit = ApiRateLimiter::Result.new(allowed: false, retry_after: 20)
    with_method_replacement(ApiRateLimiter, :call, ->(scope:, subject:) { assert_equal :answer, scope; limit }) do
      post "/api/v1/questions/0/answer", params: {}, as: :json
      assert_response :too_many_requests
    end
    with_method_replacement(ApiRateLimiter, :call, ->(**) { flunk "public reads must not consume quotas" }) do
      get "/api/v1/health"
      assert_response :success
      get "/api/v1/payments/config"
      assert_response :success
      get "/api/v1/questions/0"
      assert_response :not_found
    end
  end

  test "checkout has independent IP and account limits and never invokes Stripe when limited" do
    user = User.create!(name: "QA", email: "qa@example.invalid", password: "password123", password_confirmation: "password123")
    calls = []
    limiter = lambda do |scope:, subject:|
      calls << [scope, subject]
      ApiRateLimiter::Result.new(allowed: scope == :checkout_ip, retry_after: 30)
    end
    with_method_replacement(ApiRateLimiter, :call, limiter) do
      with_method_replacement(CheckoutSessionCreator, :new, ->(**) { flunk "limited checkout must not call Stripe" }) do
        post "/api/v1/payments/checkout_sessions", params: {}, headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" }, as: :json
      end
    end
    assert_response :too_many_requests
    assert_equal %i[checkout_ip checkout_user], calls.map(&:first)
    assert_equal user.id.to_s, calls.last.last
  end

  test "rate-limit storage failure fails closed without affecting the error envelope" do
    with_method_replacement(ApiRateLimiter, :call, ->(**) { raise ApiRateLimiter::Unavailable }) do
      post "/api/v1/auth/login", params: {}, as: :json
    end
    assert_response :service_unavailable
    assert_equal "rate_limiter_unavailable", response.parsed_body.dig("error", "code")
    assert_equal "60", response.headers.fetch("Retry-After")
  end

  test "Stripe webhook requests do not use application rate limits" do
    with_env("STRIPE_WEBHOOK_SECRET" => "whsec_test") do
      with_method_replacement(ApiRateLimiter, :call, ->(**) { flunk "Stripe retries must not consume application quotas" }) do
        post "/api/v1/webhooks/stripe", params: "{}", headers: { "Content-Type" => "application/json", "Stripe-Signature" => "invalid" }
      end
    end
    assert_response :bad_request
  end
end

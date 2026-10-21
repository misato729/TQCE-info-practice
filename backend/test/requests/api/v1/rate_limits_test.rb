require "test_helper"
require_relative "../../../support/method_replacement"

class Api::V1::RateLimitsTest < ActionDispatch::IntegrationTest
  include MethodReplacement

  test "a small group on one IP can log in, answer and read their own history" do
    question = Question.create!(exam_number: 1, question_number: 1,
      major_category_code: "teacher_education", category_code: "education_system",
      publication_status: "published", content_blocks: [{ type: "text", text: "Shared IP test" }],
      explanation_blocks: [{ type: "text", text: "Explanation" }])
    choices = %w[ア イ ウ エ].map.with_index do |label, index|
      question.question_choices.create!(choice_label: label, display_order: index + 1,
        is_correct: index.zero?, content_blocks: [{ type: "text", text: "Choice #{label}" }])
    end

    with_env("FLY_APP_NAME" => "test-app") do
      3.times do |index|
        user = User.create!(name: "Shared IP user #{index}", email: "shared-ip-#{index}@example.invalid", password: "password123")
        post "/api/v1/auth/login", params: { email: user.email, password: "password123" },
          headers: { "Fly-Client-IP" => "192.0.2.50" }, as: :json
        assert_response :ok
        headers = { "Fly-Client-IP" => "192.0.2.50", "Authorization" => "Bearer #{response.parsed_body.dig('data', 'access_token')}" }

        post answer_api_v1_question_path(question), params: { selected_choice_id: choices.first.id }, headers: headers, as: :json
        assert_response :ok
        assert response.parsed_body.dig("data", "is_correct")

        get api_v1_answer_histories_path, headers: headers
        assert_response :ok
        assert_equal 1, response.parsed_body.fetch("data").size
        assert_equal user.id, AnswerHistory.find(response.parsed_body.dig("data", 0, "id")).user_id
        get "/api/v1/health", headers: { "Fly-Client-IP" => "192.0.2.50" }
        assert_response :ok
      end
    end

    assert_equal [3, 3], ApiRateLimitBucket.order(:request_count).pluck(:request_count)
  end

  test "shared-IP learners can use the answer quota without mixing histories and recover after the window" do
    question = Question.create!(exam_number: 1, question_number: 1,
      major_category_code: "teacher_education", category_code: "education_system",
      publication_status: "published", content_blocks: [{ type: "text", text: "Shared IP quota test" }],
      explanation_blocks: [{ type: "text", text: "Explanation" }])
    choice = question.question_choices.create!(choice_label: "ア", display_order: 1,
      is_correct: true, content_blocks: [{ type: "text", text: "Choice" }])
    %w[イ ウ エ].each.with_index(2) do |label, order|
      question.question_choices.create!(choice_label: label, display_order: order,
        is_correct: false, content_blocks: [{ type: "text", text: "Choice" }])
    end
    users = 10.times.map { |index| User.create!(name: "Learner #{index}", email: "quota-#{index}@example.invalid", password: "password123") }
    tokens = []

    with_env("FLY_APP_NAME" => "test-app") do
      travel_to Time.utc(2026, 10, 21, 0, 0, 10) do
        users.each do |user|
          post "/api/v1/auth/login", params: { email: user.email, password: "password123" },
            headers: { "Fly-Client-IP" => "192.0.2.60" }, as: :json
          assert_response :ok
          tokens << response.parsed_body.dig("data", "access_token")
        end
        120.times do |index|
          post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id },
            headers: { "Fly-Client-IP" => "192.0.2.60", "Authorization" => "Bearer #{tokens[index % 10]}" }, as: :json
          assert_response :ok
        end
        tokens.each_with_index do |token, index|
          get api_v1_answer_histories_path,
            headers: { "Fly-Client-IP" => "192.0.2.60", "Authorization" => "Bearer #{token}" }
          assert_response :ok
          assert_equal 12, response.parsed_body.fetch("data").size
          assert_equal 12, users[index].answer_histories.count
          assert_equal users[index].answer_histories.pluck(:id).sort, response.parsed_body.fetch("data").map { |item| item.fetch("id") }.sort
        end
        assert_no_difference "AnswerHistory.count" do
          post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id },
            headers: { "Fly-Client-IP" => "192.0.2.60", "Authorization" => "Bearer #{tokens.first}" }, as: :json
        end
        assert_response :too_many_requests
        assert_equal "50", response.headers.fetch("Retry-After")
        get "/api/v1/health", headers: { "Fly-Client-IP" => "192.0.2.60" }
        assert_response :ok
        post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id },
          headers: { "Fly-Client-IP" => "192.0.2.61", "Authorization" => "Bearer #{tokens.first}" }, as: :json
        assert_response :ok
      end
      travel_to Time.utc(2026, 10, 21, 0, 1, 0) do
        post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id },
          headers: { "Fly-Client-IP" => "192.0.2.60", "Authorization" => "Bearer #{tokens.first}" }, as: :json
        assert_response :ok
      end
    end
    assert_equal 122, AnswerHistory.count
  end

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

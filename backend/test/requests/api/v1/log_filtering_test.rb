require "test_helper"
require "stringio"

class Api::V1::LogFilteringTest < ActionDispatch::IntegrationTest
  test "sensitive parameters are filtered recursively without changing request values" do
    parameters = {
      "password" => "test-only-password",
      "password_confirmation" => "test-only-confirmation",
      "current_password" => "test-only-current-password",
      "email" => "private-person@example.invalid",
      "name" => "Private person",
      "credentials" => [{
        "access_token" => "test-only-access-token",
        "refresh_token" => "test-only-refresh-token",
        "client_secret" => "test-only-client-secret",
        "api_key" => "test-only-api-key",
        "sentry_error_dsn" => "test-only-notification-destination",
        "Authorization" => "Bearer test-only-authorization",
        "email" => "nested-person@example.invalid",
        "name" => "Nested person",
      }],
      "exam_number" => 1,
    }
    original = parameters.deep_dup
    filtered = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(parameters)

    %w[password password_confirmation current_password email name].each do |key|
      assert_equal "[FILTERED]", filtered.fetch(key)
    end
    filtered.fetch("credentials").first.each_value do |value|
      assert_equal "[FILTERED]", value
    end
    assert_equal 1, filtered.fetch("exam_number")
    assert_equal original, parameters
  end

  test "request environment filters authorization and cookie headers" do
    request = ActionDispatch::TestRequest.create(
      "HTTP_AUTHORIZATION" => "Bearer test-only-header-token",
      "HTTP_COOKIE" => "session=test-only-session-cookie",
      "HTTP_ACCEPT" => "application/json",
    )

    assert_equal "[FILTERED]", request.filtered_env.fetch("HTTP_AUTHORIZATION")
    assert_equal "[FILTERED]", request.filtered_env.fetch("HTTP_COOKIE")
    assert_equal "application/json", request.filtered_env.fetch("HTTP_ACCEPT")
    assert_equal "Bearer test-only-header-token", request.authorization
  end

  test "request paths redact sensitive query values while preserving other parameters" do
    request = ActionDispatch::TestRequest.create(
      "PATH_INFO" => "/api/v1/health",
      "QUERY_STRING" => "access_token=test-only-query-token&password=test-only-query-password&email=private-person%40example.invalid&name=Private+person&exam_number=1",
    )

    assert_includes request.filtered_path, "access_token=[FILTERED]"
    assert_includes request.filtered_path, "password=[FILTERED]"
    assert_includes request.filtered_path, "email=[FILTERED]"
    assert_includes request.filtered_path, "name=[FILTERED]"
    assert_includes request.filtered_path, "exam_number=1"
    refute_includes request.filtered_path, "test-only-query-token"
    refute_includes request.filtered_path, "test-only-query-password"
    refute_includes request.filtered_path, "private-person"
    refute_includes request.filtered_path, "Private"
  end

  test "signup and login logs redact personal data and credentials while authentication still works" do
    password = "test-only-log-password-123"
    confirmation = "test-only-log-confirmation-456"
    log_output = StringIO.new
    logger = ActiveSupport::Logger.new(log_output)
    logger.level = Logger::INFO
    original_logger = ActionController::Base.logger
    ActionController::Base.logger = logger

    post "/api/v1/auth/signup", params: {
      name: "ログ保護テスト",
      email: "log-filter@example.invalid",
      password: password,
      password_confirmation: confirmation,
    }, as: :json
    assert_response :unprocessable_content

    post "/api/v1/auth/signup", params: {
      name: "ログ保護テスト",
      email: "log-filter@example.invalid",
      password: password,
      password_confirmation: password,
    }, as: :json
    assert_response :created
    token = response.parsed_body.dig("data", "access_token")
    assert token.present?
    assert_equal "ログ保護テスト", response.parsed_body.dig("data", "user", "name")
    assert_equal "log-filter@example.invalid", response.parsed_body.dig("data", "user", "email")

    post "/api/v1/auth/login", params: {
      email: "log-filter@example.invalid", password: confirmation,
    }, as: :json
    assert_response :unauthorized

    post "/api/v1/auth/login", params: {
      email: "log-filter@example.invalid", password: password,
    }, as: :json
    assert_response :success

    assert_includes log_output.string, "Parameters:"
    assert_includes log_output.string, "[FILTERED]"
    refute_includes log_output.string, "log-filter@example.invalid"
    refute_includes log_output.string, "ログ保護テスト"
    refute_includes log_output.string, password
    refute_includes log_output.string, confirmation
    refute_includes log_output.string, token
  ensure
    ActionController::Base.logger = original_logger
  end
end

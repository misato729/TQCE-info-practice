require "test_helper"
require_relative "../../../support/method_replacement"
require "stringio"

class Api::V1::ErrorNotificationsTest < ActionDispatch::IntegrationTest
  include MethodReplacement

  test "real webhook failures are observed without forwarding payloads or affecting retry semantics" do
    calls = []
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true", "STRIPE_WEBHOOK_SECRET" => "whsec_fake") do
      with_method_replacement(ApiErrorNotifier, :call, ->(**attributes) { calls << attributes; :failed }) do
        with_method_replacement(Stripe::Webhook, :construct_event, TestObject.new(id: "evt_test")) do
          with_method_replacement(StripeWebhookProcessor, :new, ->(**) { raise StripeWebhookProcessor::PaymentNotReadyError }) do
            post "/api/v1/webhooks/stripe", params: '{"private":"must-not-send"}',
              headers: { "Content-Type" => "application/json", "Stripe-Signature" => "must-not-send" }
          end
        end
      end
    end
    assert_response :internal_server_error
    assert_equal "webhook_processing_failed", response.parsed_body.dig("error", "code")
    assert_equal [{ controller: "Api::V1::Webhooks::StripeController", status: 500, exception_class: nil }], calls
    assert_equal 0, StripeWebhookEvent.count
  end

  test "the opt-in subscriber observes unexpected exceptions without request details" do
    calls = []
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true") do
      with_method_replacement(ApiErrorNotifier, :call, ->(**attributes) { calls << attributes; :sent }) do
        with_method_replacement(User, :find_by, ->(**) { raise StandardError, "private-error-details" }) do
          post "/api/v1/auth/login", params: { email: "private@example.invalid", password: "must-not-send" }, as: :json
        end
      end
    end
    assert_response :internal_server_error
    assert_equal 1, calls.length
    assert_equal "StandardError", calls.first.fetch(:exception_class)
    assert_equal %i[controller exception_class status], calls.first.keys.sort
    assert_not_includes calls.to_json, "private"
    assert_not_includes calls.to_json, "must-not-send"
  end

  test "a real notifier transport failure preserves the webhook failure response and retryability" do
    attempts = 0
    output = StringIO.new
    notifier = ApiErrorNotifier.new(environment: {
      "ERROR_NOTIFICATIONS_ENABLED" => "true",
      "SENTRY_ERROR_DSN" => "https://#{'a' * 32}@o123.ingest.us.sentry.io/456",
      "ERROR_NOTIFICATION_ENVIRONMENT" => "verification",
    }, http_factory: ->(*) { attempts += 1; raise Net::ReadTimeout, "private-transport-details" },
      gate: ApiErrorNotifier::Gate.new)

    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true", "STRIPE_WEBHOOK_SECRET" => "whsec_fake") do
      with_method_replacement(Rails, :logger, ActiveSupport::Logger.new(output)) do
        with_method_replacement(ApiErrorNotifier, :new, ->(*) { notifier }) do
          with_method_replacement(Stripe::Webhook, :construct_event, TestObject.new(id: "evt_test")) do
            with_method_replacement(StripeWebhookProcessor, :new, ->(**) { raise StripeWebhookProcessor::PaymentNotReadyError }) do
              assert_no_difference ["StripeWebhookEvent.count", "Payment.count", "Membership.count"] do
                post "/api/v1/webhooks/stripe", params: "{}",
                  headers: { "Content-Type" => "application/json", "Stripe-Signature" => "test-only-signature" }
              end
            end
          end
        end
      end
    end

    assert_response :internal_server_error
    assert_equal "webhook_processing_failed", response.parsed_body.dig("error", "code")
    assert_equal 1, attempts
    assert_includes output.string, "API error notification delivery failed"
    assert_not_includes output.string, "private-transport-details"
  end

  test "an unexpected notification subscriber failure does not turn a successful API response into an error" do
    output = StringIO.new
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true") do
      with_method_replacement(Rails, :logger, ActiveSupport::Logger.new(output)) do
        with_method_replacement(ApiErrorNotifier, :call, ->(**) { raise StandardError, "private-notification-details" }) do
          get "/api/v1/health"
        end
      end
    end

    assert_response :ok
    assert_equal "ok", response.parsed_body.fetch("status")
    assert_includes output.string, "API error notification subscriber failed"
    assert_not_includes output.string, "private-notification-details"
  end

  test "only explicit sales-off and missing-webhook configuration mark a 503 as expected" do
    user = User.create!(name: "Notification test", email: "expected-503@example.invalid", password: "password123")
    calls = []
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true", "PAID_MEMBERSHIP_ENABLED" => "false", "STRIPE_WEBHOOK_SECRET" => nil) do
      with_method_replacement(ApiErrorNotifier, :call, ->(**attributes) { calls << attributes; :ignored }) do
        with_method_replacement(PaidMembership, :stripe_client, -> { flunk "Sales-off checks must not contact Stripe" }) do
          post "/api/v1/payments/checkout_sessions", headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" }, as: :json
          assert_response :service_unavailable
          assert_equal "payment_unavailable", response.parsed_body.dig("error", "code")
          post "/api/v1/webhooks/stripe", params: "{}", headers: { "Content-Type" => "application/json" }
          assert_response :service_unavailable
          assert_equal "webhook_unavailable", response.parsed_body.dig("error", "code")
        end
      end
    end
    assert_equal 2, calls.length
    assert calls.all? { |attributes| attributes[:expected_unavailability] == true && attributes[:status] == 503 }
    assert_empty Payment.all
  end

  test "checkout rate-limit storage failures still reach the real error notifier" do
    user = User.create!(name: "Notification test", email: "unexpected-503@example.invalid", password: "password123")
    attempts = 0
    notifier = ApiErrorNotifier.new(environment: {
      "ERROR_NOTIFICATIONS_ENABLED" => "true",
      "SENTRY_ERROR_DSN" => "https://#{'a' * 32}@o123.ingest.us.sentry.io/456",
      "ERROR_NOTIFICATION_ENVIRONMENT" => "verification",
    }, http_factory: ->(*) { attempts += 1; raise Net::ReadTimeout, "test-only-transport-error" },
      gate: ApiErrorNotifier::Gate.new)
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true") do
      with_method_replacement(ApiErrorNotifier, :new, ->(*) { notifier }) do
        with_method_replacement(ApiRateLimiter, :call, ->(**) { raise ApiRateLimiter::Unavailable }) do
          assert_no_difference "Payment.count" do
            post "/api/v1/payments/checkout_sessions", headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" }, as: :json
          end
        end
      end
    end
    assert_response :service_unavailable
    assert_equal "rate_limiter_unavailable", response.parsed_body.dig("error", "code")
    assert_equal 1, attempts
  end

  test "configuration failures with sales requested are not marked as an intentional shutdown" do
    user = User.create!(name: "Configuration test", email: "configuration-503@example.invalid", password: "password123")
    calls = []
    creator = TestObject.new
    creator.define_singleton_method(:call) { raise CheckoutSessionCreator::ConfigurationError }
    with_env("ERROR_NOTIFICATIONS_ENABLED" => "true", "PAID_MEMBERSHIP_ENABLED" => "true") do
      with_method_replacement(ApiErrorNotifier, :call, ->(**attributes) { calls << attributes; :sent }) do
        with_method_replacement(CheckoutSessionCreator, :new, ->(**) { creator }) do
          post "/api/v1/payments/checkout_sessions", headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" }, as: :json
        end
      end
    end
    assert_response :service_unavailable
    assert_equal 1, calls.length
    assert_equal 503, calls.first.fetch(:status)
    refute calls.first.key?(:expected_unavailability)
  end
end

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
end

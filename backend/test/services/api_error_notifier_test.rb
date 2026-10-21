require "test_helper"
require_relative "../support/method_replacement"
require "stringio"

class ApiErrorNotifierTest < ActiveSupport::TestCase
  include MethodReplacement

  class FakeHttp
    attr_accessor :use_ssl, :verify_mode, :open_timeout, :read_timeout,
      :write_timeout, :ssl_timeout, :max_retries, :code, :failure
    attr_reader :requests

    def initialize
      @requests = []
      @code = "200"
    end

    def start
      yield self
    end

    def request(request)
      @requests << request
      raise @failure if @failure

      TestObject.new(code: @code)
    end
  end

  setup do
    @http = FakeHttp.new
    @environment = {
      "ERROR_NOTIFICATIONS_ENABLED" => "true",
      "SENTRY_ERROR_DSN" => "https://#{'a' * 32}@o123.ingest.us.sentry.io/456",
      "ERROR_NOTIFICATION_ENVIRONMENT" => "verification",
    }
    @notifier = ApiErrorNotifier.new(environment: @environment,
      http_factory: ->(host, port) { assert_equal "o123.ingest.us.sentry.io", host; assert_equal 443, port; @http },
      gate: ApiErrorNotifier::Gate.new)
  end

  test "notifications are opt-in and ignored requests never reach the network" do
    @environment["ERROR_NOTIFICATIONS_ENABLED"] = "false"
    assert_equal :disabled, notify
    @environment["ERROR_NOTIFICATIONS_ENABLED"] = "true"
    [200, 400, 401, 403, 404, 409, 422, 429].each { |status| assert_equal :ignored, notify(status: status) }
    assert_equal :ignored, notify(controller: "StatusController")
    assert_empty @http.requests
  end

  test "intentional sales-off or unconfigured webhook responses are not incidents" do
    assert_equal :ignored, notify(controller: "Api::V1::Payments::CheckoutSessionsController", status: 503)
    assert_equal :ignored, notify(controller: "Api::V1::Webhooks::StripeController", status: 503)
    assert_empty @http.requests
  end

  test "the event contains only the five explicitly allowed fields and fixed messages" do
    assert_equal :sent, notify(controller: "Api::V1::Webhooks::StripeController")
    request = @http.requests.fetch(0)
    header, item, payload = request.body.lines.map { |line| JSON.parse(line) }
    assert_equal %w[environment event_id level message timestamp], payload.keys.sort
    assert_equal "TQCE Stripe webhook processing failure", payload.fetch("message")
    assert_equal "verification", payload.fetch("environment")
    assert_equal "error", payload.fetch("level")
    assert_match(/\A[a-f0-9]{32}\z/, payload.fetch("event_id"))
    assert_equal header.fetch("event_id"), payload.fetch("event_id")
    assert_equal "event", item.fetch("type")
    assert_equal request.body.lines.fetch(2).strip.bytesize, item.fetch("length")
    assert_equal "/api/456/envelope/", request.path
    assert @http.use_ssl
    assert_equal OpenSSL::SSL::VERIFY_PEER, @http.verify_mode
    assert_equal [1, 1, 1, 1, 0], [@http.open_timeout, @http.read_timeout, @http.write_timeout, @http.ssl_timeout, @http.max_retries]
  end

  test "Stripe API errors and unknown controller exceptions use fixed categories" do
    assert_equal :sent, notify(controller: "Api::V1::Payments::CheckoutSessionsController", status: 502)
    assert_equal :sent, notify(status: nil, exception_class: "StandardError")
    assert_equal :ignored, notify(status: nil, exception_class: "ActiveRecord::RecordNotFound")
    assert_equal ["TQCE Stripe API connection failure", "TQCE API server failure"],
      @http.requests.map { |request| JSON.parse(request.body.lines.fetch(2)).fetch("message") }
  end

  test "deduplication is bounded per category and does not depend on the database" do
    with_method_replacement(ApiRateLimitBucket, :upsert_all, ->(*) { flunk "DB outages must not disable notifications" }) do
      assert_equal :sent, notify
      assert_equal :throttled, notify
      assert_equal :sent, notify(controller: "Api::V1::Webhooks::StripeController")
    end
    assert_equal 2, @http.requests.length
    gate = ApiErrorNotifier::Gate.new
    assert gate.allow?(:api, now: 100)
    assert_not gate.allow?(:api, now: 3699)
    assert gate.allow?(:api, now: 3700)
  end

  test "invalid or redirected destinations and arbitrary environments never leak credentials" do
    ["http://example.invalid/", "https://#{'a' * 32}@example.invalid/456",
      "#{@environment.fetch('SENTRY_ERROR_DSN')}?secret=value",
      "https://#{'a' * 32}:password@o123.ingest.us.sentry.io/456"].each do |dsn|
      @environment["SENTRY_ERROR_DSN"] = dsn
      assert_equal :failed, notify
    end
    assert_empty @http.requests
    @environment["SENTRY_ERROR_DSN"] = "https://#{'a' * 32}@o123.ingest.us.sentry.io/456"
    @environment["ERROR_NOTIFICATION_ENVIRONMENT"] = "person@example.invalid"
    assert_equal :failed, notify
    assert_empty @http.requests
  end

  test "delivery failures are contained and only a fixed safe message is logged" do
    @http.failure = IOError.new("sensitive connection and payload details")
    output = StringIO.new
    logger = ActiveSupport::Logger.new(output)
    with_method_replacement(Rails, :logger, logger) { assert_equal :failed, notify }
    assert_includes output.string, "API error notification delivery failed"
    assert_not_includes output.string, "sensitive"
    assert_not_includes output.string, @environment.fetch("SENTRY_ERROR_DSN")
  end

  test "non-success HTTP responses are not reported as delivered or followed" do
    %w[302 400 401 403 429 500 503].each do |code|
      @http.code = code
      notifier = ApiErrorNotifier.new(environment: @environment,
        http_factory: ->(*) { @http }, gate: ApiErrorNotifier::Gate.new)
      assert_equal :failed, notifier.call(controller: "Api::V1::AuthController", status: 500)
    end
    assert_equal 7, @http.requests.length
    assert_equal 0, @http.max_retries
  end

  test "delivery timeouts and TLS or DNS failures keep exception details out of logs" do
    failures = [Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout,
      OpenSSL::SSL::SSLError, SocketError]
    output = StringIO.new
    failures.each do |failure|
      @http.failure = failure.new("private-transport-details")
      notifier = ApiErrorNotifier.new(environment: @environment,
        http_factory: ->(*) { @http }, gate: ApiErrorNotifier::Gate.new)
      with_method_replacement(Rails, :logger, ActiveSupport::Logger.new(output)) do
        assert_equal :failed, notifier.call(controller: "Api::V1::AuthController", status: 500)
      end
    end
    assert_equal failures.length, @http.requests.length
    assert_equal failures.length, output.string.scan("API error notification delivery failed").length
    assert_not_includes output.string, "private-transport-details"
    assert_not_includes output.string, @environment.fetch("SENTRY_ERROR_DSN")
  end

  test "concurrent requests only reserve one delivery per environment and category" do
    gate = ApiErrorNotifier::Gate.new
    results = Array.new(8) { Thread.new { gate.allow?(["verification", :api], now: 100) } }.map(&:value)
    assert_equal 1, results.count(true)
    assert_equal 7, results.count(false)
    assert gate.allow?(["production", :api], now: 100)
    assert gate.allow?(["verification", :stripe_webhook], now: 100)
  end

  private

  def notify(**overrides)
    @notifier.call(**{ controller: "Api::V1::AuthController", status: 500 }.merge(overrides))
  end
end

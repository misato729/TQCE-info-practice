require "json"
require "net/http"
require "openssl"
require "securerandom"
require "uri"

class ApiErrorNotifier
  MESSAGES = {
    api: "TQCE API server failure",
    stripe_api: "TQCE Stripe API connection failure",
    stripe_webhook: "TQCE Stripe webhook processing failure",
  }.freeze

  class Gate
    def initialize
      @mutex = Mutex.new
      @last_sent = {}
    end

    def allow?(key, now: Process.clock_gettime(Process::CLOCK_MONOTONIC))
      @mutex.synchronize do
        return false if @last_sent.key?(key) && now - @last_sent.fetch(key) < 3600

        @last_sent[key] = now
        true
      end
    end
  end

  GATE = Gate.new

  def self.call(**attributes)
    new.call(**attributes)
  end

  def initialize(environment: ENV, http_factory: ->(host, port) { Net::HTTP.new(host, port, nil) }, gate: GATE)
    @environment = environment
    @http_factory = http_factory
    @gate = gate
  end

  def call(controller:, status:, exception_class: nil, expected_unavailability: false)
    return :disabled unless @environment["ERROR_NOTIFICATIONS_ENABLED"] == "true"
    return :ignored unless controller.to_s.start_with?("Api::V1::")

    status ||= ActionDispatch::ExceptionWrapper.status_code_for_exception(exception_class) if exception_class
    return :ignored unless status.to_i >= 500
    if status.to_i == 503 && expected_unavailability == true &&
        %w[Api::V1::Webhooks::StripeController Api::V1::Payments::CheckoutSessionsController].include?(controller)
      return :ignored
    end
    category = category_for(controller, status.to_i)
    return :ignored unless category

    dsn = URI(@environment.fetch("SENTRY_ERROR_DSN", ""))
    unless dsn.is_a?(URI::HTTPS) && dsn.port == 443 &&
        dsn.host&.match?(/\Ao\d+\.ingest(?:\.[a-z]+)?\.sentry\.io\z/) &&
        dsn.user&.match?(/\A[a-f0-9]{32}\z/i) && dsn.password.nil? &&
        dsn.path.match?(/\A\/\d+\z/) && dsn.query.nil? && dsn.fragment.nil?
      return failed
    end
    environment = @environment.fetch("ERROR_NOTIFICATION_ENVIRONMENT", Rails.env.production? ? "production" : "verification")
    return failed unless %w[production verification].include?(environment)
    return :throttled unless @gate.allow?([environment, category])

    id = SecureRandom.hex(16)
    timestamp = Time.current.utc.iso8601
    # Construct a new allowlisted payload; never serialize a request or exception.
    payload = JSON.generate(event_id: id, timestamp: timestamp, environment: environment,
      level: "error", message: MESSAGES.fetch(category))
    request = Net::HTTP::Post.new("/api#{dsn.path}/envelope/",
      "Content-Type" => "application/x-sentry-envelope",
      "X-Sentry-Auth" => "Sentry sentry_version=7, sentry_key=#{dsn.user}")
    request.body = [JSON.generate(event_id: id, sent_at: timestamp),
      JSON.generate(type: "event", length: payload.bytesize), payload, ""].join("\n")
    http = @http_factory.call(dsn.host, dsn.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.open_timeout = http.read_timeout = http.write_timeout = http.ssl_timeout = 1
    http.max_retries = 0
    response = http.start { |connection| connection.request(request) }
    response.code.to_i.between?(200, 299) ? :sent : failed
  rescue StandardError
    failed
  end

  private

  def category_for(controller, status)
    return :api if status == 503

    case controller
    when "Api::V1::Webhooks::StripeController"
      :stripe_webhook
    when "Api::V1::Payments::CheckoutSessionsController"
      :stripe_api
    else
      :api
    end
  end

  def failed
    Rails.logger.error("API error notification delivery failed")
    :failed
  rescue StandardError
    :failed
  end
end

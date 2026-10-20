require "test_helper"
require_relative "../../lib/cors_policy"

class CorsPolicyTest < ActiveSupport::TestCase
  SITE = "https://johokyonin-lab.netlify.app"

  test "production allows only explicit origins and fails closed when unset" do
    assert_empty CorsPolicy.origins(environment: "production", configured: "")
    assert_equal [SITE], CorsPolicy.origins(environment: "production", configured: " #{SITE},#{SITE} ")
  end

  test "development alone adds localhost defaults" do
    assert_equal CorsPolicy::DEVELOPMENT_ORIGINS, CorsPolicy.origins(environment: "development", configured: "")
    assert_empty CorsPolicy.origins(environment: "test", configured: "")
  end

  test "production rejects http wildcards paths and credentials without exposing values" do
    ["http://localhost:3000", "https://*.netlify.app", "#{SITE}/", "#{SITE}/path", "#{SITE}?secret=private", "https://user:private@example.com", "not a URI"].each do |origin|
      error = assert_raises(ArgumentError) { CorsPolicy.origins(environment: "production", configured: origin) }
      assert_not_includes error.message, "private"
    end
  end

  test "previews require explicit names" do
    preview = "https://deploy-preview-1--johokyonin-lab.netlify.app"
    assert_equal [SITE, preview], CorsPolicy.origins(environment: "production", configured: "#{SITE},#{preview}")
  end

  test "production middleware allows authenticated preflights and rejects other origins headers and methods" do
    cors = middleware
    %w[GET POST PUT PATCH DELETE HEAD].each do |method|
      status, headers, = cors.call(preflight(origin: SITE, method: method))
      assert_equal 200, status
      assert_equal SITE, headers["access-control-allow-origin"]
      assert_equal "300", headers["access-control-max-age"]
      assert_nil headers["access-control-allow-credentials"]
    end

    ["http://localhost:3000", "https://luminous-piroshki-d94b2b.netlify.app", "https://tqce-info-practice.vercel.app", "https://another.vercel.app", "#{SITE}.attacker.invalid", "null"].each do |origin|
      _status, headers, = cors.call(preflight(origin: origin))
      assert_nil headers["access-control-allow-origin"], origin
    end
    _status, headers, = cors.call(preflight(origin: SITE, method: "TRACE"))
    assert_nil headers["access-control-allow-origin"]
    _status, headers, = cors.call(preflight(origin: SITE, headers: "X-Unapproved"))
    assert_nil headers["access-control-allow-origin"]
  end

  test "cors headers apply to API errors but not backend screens" do
    cors = middleware(status: 401)
    _status, headers, = cors.call(Rack::MockRequest.env_for("/api/v1/me", "HTTP_ORIGIN" => SITE))
    assert_equal SITE, headers["access-control-allow-origin"]
    _status, headers, = cors.call(Rack::MockRequest.env_for("/", "HTTP_ORIGIN" => SITE))
    assert_nil headers["access-control-allow-origin"]
  end

  test "allowed origins can read the retry time on limited responses" do
    _status, headers, = middleware(status: 429).call(Rack::MockRequest.env_for("/api/v1/auth/login", "HTTP_ORIGIN" => SITE))
    assert_includes headers.fetch("access-control-expose-headers").downcase.split(/,\s*/), "retry-after"
  end

  private

  def middleware(status: 200)
    app = ->(_env) { [status, { "content-type" => "application/json" }, ["{}"]] }
    origins = CorsPolicy.origins(environment: "production", configured: SITE)
    Rack::Cors.new(app) do
      allow do
        origins(*origins)
        resource "/api/v1/*", headers: CorsPolicy::HEADERS, methods: CorsPolicy::METHODS,
          expose: ["Retry-After"], credentials: false, max_age: 300
      end
    end
  end

  def preflight(origin:, method: "POST", headers: "Authorization, Content-Type")
    Rack::MockRequest.env_for("/api/v1/auth/login", method: "OPTIONS",
      "HTTP_ORIGIN" => origin,
      "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => method,
      "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => headers)
  end
end

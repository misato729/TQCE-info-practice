class ApplicationController < ActionController::API
  before_action :authenticate_backend_screen

  private

  def authenticate_backend_screen
    return if request.path.start_with?("/api/")
    return unless backend_basic_auth_enabled?

    auth = Rack::Auth::Basic::Request.new(request.env)
    return if auth.provided? && auth.basic? && auth.credentials &&
      secure_compare(auth.credentials.first, ENV.fetch("BACKEND_BASIC_AUTH_USER")) &&
      secure_compare(auth.credentials.second, ENV.fetch("BACKEND_BASIC_AUTH_PASSWORD"))

    response.headers["WWW-Authenticate"] = 'Basic realm="TQCE Backend"'
    render plain: "HTTP Basic: Access denied.\n", status: :unauthorized
  end

  def backend_basic_auth_enabled?
    ENV["BACKEND_BASIC_AUTH_USER"].present? &&
      ENV["BACKEND_BASIC_AUTH_PASSWORD"].present?
  end

  def secure_compare(value, expected)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(value.to_s),
      Digest::SHA256.hexdigest(expected.to_s)
    )
  end
end

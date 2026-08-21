class ApplicationController < ActionController::API
  before_action :authenticate_backend_screen
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  attr_reader :current_user

  private

  def render_not_found
    render_error(:not_found, "対象が見つかりません", :not_found)
  end

  def render_error(code, message, status, details: nil)
    error = { code: code, message: message }
    error[:details] = details if details.present?
    render json: { error: error }, status: status
  end

  def authenticate_optional_user!
    return if request.authorization.blank?

    authenticate_user!
  end

  def authenticate_user!
    token = request.authorization.to_s.match(/\ABearer (.+)\z/)&.captures&.first
    payload = AuthToken.verify(token) if token.present?
    @current_user = User.find_by(id: payload[:user_id]) if payload.present?

    return if @current_user && @current_user.role == payload[:role]

    render_error(:unauthorized, "ログインが必要です", :unauthorized)
  end

  def authenticate_backend_screen
    return if request.path.start_with?("/api/")
    return unless backend_basic_auth_enabled?

    auth = Rack::Auth::Basic::Request.new(request.env)
    return if auth.provided? && auth.basic? && auth.credentials &&
      secure_compare(auth.credentials.first, backend_basic_auth_user) &&
      secure_compare(auth.credentials.second, backend_basic_auth_password)

    response.headers["WWW-Authenticate"] = 'Basic realm="TQCE Backend"'
    render plain: "HTTP Basic: Access denied.\n", status: :unauthorized
  end

  def backend_basic_auth_enabled?
    backend_basic_auth_user.present? && backend_basic_auth_password.present?
  end

  def backend_basic_auth_user
    ENV["BACKEND_BASIC_AUTH_USER"].presence || ENV["NUXT_BASIC_AUTH_USER"]
  end

  def backend_basic_auth_password
    ENV["BACKEND_BASIC_AUTH_PASSWORD"].presence || ENV["NUXT_BASIC_AUTH_PASSWORD"]
  end

  def secure_compare(value, expected)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(value.to_s),
      Digest::SHA256.hexdigest(expected.to_s)
    )
  end
end

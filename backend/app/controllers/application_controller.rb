require "ipaddr"

class ApplicationController < ActionController::API
  before_action :authenticate_backend_screen
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  attr_reader :current_user

  private

  def throttle_request!(scope, subject: rate_limit_client_address)
    result = ApiRateLimiter.call(scope: scope, subject: subject)
    return if result.allowed

    response.headers["Retry-After"] = result.retry_after.to_s
    response.headers["Cache-Control"] = "no-store"
    render_error(:rate_limit_exceeded, "操作が集中しています。しばらく待ってからお試しください", :too_many_requests)
  rescue ApiRateLimiter::Unavailable
    Rails.logger.error("API rate limiter unavailable")
    response.headers["Retry-After"] = "60"
    response.headers["Cache-Control"] = "no-store"
    render_error(:rate_limiter_unavailable, "一時的に操作できません。しばらく待ってからお試しください", :service_unavailable)
  end

  def rate_limit_client_address
    address = request.get_header("REMOTE_ADDR")
    address = request.get_header("HTTP_FLY_CLIENT_IP").presence || address if ENV["FLY_APP_NAME"].present?
    IPAddr.new(address.to_s).native.to_s
  rescue IPAddr::Error
    "unknown"
  end

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

  def authenticate_admin!
    authenticate_user!
    return if performed?
    return if current_user.role == "admin"

    render_error(:forbidden, "管理者権限が必要です", :forbidden)
  end

  def authorize_exam_access!(exam_number)
    return true if exam_number <= PaidMembership::FREE_EXAM_MAX
    return true if current_user&.paid_content_access?

    if current_user
      render_error(:paid_membership_required, "この模擬試験の利用には有料会員資格が必要です", :forbidden)
    else
      render_error(:unauthorized, "この模擬試験を利用するにはログインが必要です", :unauthorized)
    end
    false
  end

  def accessible_question_scope(scope)
    return scope if current_user&.paid_content_access?

    scope.where(exam_number: ..PaidMembership::FREE_EXAM_MAX)
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

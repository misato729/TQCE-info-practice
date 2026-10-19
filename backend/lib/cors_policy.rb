require "uri"

module CorsPolicy
  DEVELOPMENT_ORIGINS = %w[http://localhost:3000 http://127.0.0.1:3000].freeze
  METHODS = %i[get post put patch delete options head].freeze
  HEADERS = %w[Authorization Content-Type].freeze

  module_function

  def origins(environment:, configured:)
    explicit = configured.to_s.split(",").map(&:strip).reject(&:empty?).map do |origin|
      uri = URI.parse(origin)
      schemes = environment.to_s == "production" ? %w[https] : %w[http https]
      unless schemes.include?(uri.scheme) && uri.host && !uri.userinfo &&
          uri.path.to_s.empty? && !uri.query && !uri.fragment && !origin.include?("*")
        raise ArgumentError, "CORS_ORIGINS must contain exact origins without paths or credentials (HTTPS in production)"
      end
      origin
    rescue URI::InvalidURIError
      raise ArgumentError, "CORS_ORIGINS contains an invalid origin"
    end

    defaults = environment.to_s == "development" ? DEVELOPMENT_ORIGINS : []
    (defaults + explicit).uniq
  end
end

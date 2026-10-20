require_relative "../../lib/cors_policy"

allowed_origins = CorsPolicy.origins(
  environment: Rails.env,
  configured: ENV.fetch("CORS_ORIGINS", ""),
)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  unless allowed_origins.empty?
    allow do
      origins(*allowed_origins)

      resource "/api/v1/*",
        headers: CorsPolicy::HEADERS,
        expose: ["Retry-After"],
        methods: CorsPolicy::METHODS,
        credentials: false,
        max_age: 300
    end
  end
end

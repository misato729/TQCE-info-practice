configured_origins = ENV.fetch("CORS_ORIGINS", "")
  .split(",")
  .map(&:strip)
  .reject(&:empty?)

allowed_origins = [
  "http://localhost:3000",
  "http://127.0.0.1:3000",
  "https://tqce-info-practice.vercel.app",
  %r{\Ahttps://[a-z0-9-]+\.vercel\.app\z}
] + configured_origins

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end

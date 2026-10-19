require "uri"

module PaidMembership
  FREE_EXAM_MAX = 5
  AMOUNT = 500
  CURRENCY = "jpy"
  REQUIRED_SETTINGS = %w[
    STRIPE_SECRET_KEY STRIPE_WEBHOOK_SECRET STRIPE_PRICE_ID FRONTEND_URL
    NUXT_PUBLIC_SELLER_NAME NUXT_PUBLIC_SELLER_REPRESENTATIVE
    NUXT_PUBLIC_SELLER_ADDRESS NUXT_PUBLIC_SELLER_PHONE NUXT_PUBLIC_SELLER_EMAIL
  ].freeze

  module_function

  def enabled?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("PAID_MEMBERSHIP_ENABLED", "false")) && configured?
  end

  def configured?
    configuration_issues.empty?
  end

  def configuration_issues(environment: Rails.env)
    issues = REQUIRED_SETTINGS.filter_map { |name| "missing:#{name}" if ENV[name].blank? }
    if ENV["STRIPE_SECRET_KEY"].present?
      mode = livemode? ? "live" : "test"
      issues << "stripe_key_mode_mismatch" unless ENV["STRIPE_SECRET_KEY"].match?(/\A(?:sk|rk)_#{mode}_/)
    end
    issues << "invalid_frontend_origin" if ENV["FRONTEND_URL"].present? && !valid_frontend_origin?(environment)
    issues << "production_requires_live_mode" if environment.to_s == "production" && !livemode?
    issues
  end

  def valid_frontend_origin?(environment)
    uri = URI.parse(ENV["FRONTEND_URL"].to_s)
    secure = uri.scheme == "https"
    local = environment.to_s != "production" && uri.scheme == "http" && %w[localhost 127.0.0.1].include?(uri.host)
    (secure || local) && uri.host.present? && !uri.userinfo &&
      ["", "/"].include?(uri.path.to_s) && !uri.query && !uri.fragment
  rescue URI::InvalidURIError
    false
  end

  def livemode?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("STRIPE_LIVEMODE", "false"))
  end

  def frontend_url
    ENV.fetch("FRONTEND_URL", "http://localhost:3000").delete_suffix("/")
  end

  def seller_information
    {
      name: ENV["NUXT_PUBLIC_SELLER_NAME"].to_s,
      representative: ENV["NUXT_PUBLIC_SELLER_REPRESENTATIVE"].to_s,
      address: ENV["NUXT_PUBLIC_SELLER_ADDRESS"].to_s,
      phone: ENV["NUXT_PUBLIC_SELLER_PHONE"].to_s,
      email: ENV["NUXT_PUBLIC_SELLER_EMAIL"].to_s,
    }
  end

  def stripe_client
    Stripe::StripeClient.new(ENV.fetch("STRIPE_SECRET_KEY"))
  end
end

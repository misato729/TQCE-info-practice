require "uri"

module PaidMembership
  FREE_EXAM_MAX = 5
  AMOUNT = 500
  CURRENCY = "jpy"
  REQUIRED_SETTINGS = %w[
    STRIPE_SECRET_KEY STRIPE_WEBHOOK_SECRET STRIPE_PRICE_ID FRONTEND_URL
    NUXT_PUBLIC_SELLER_NAME NUXT_PUBLIC_SELLER_REPRESENTATIVE
    NUXT_PUBLIC_SELLER_EMAIL
  ].freeze
  SELLER_CONTACT_SETTINGS = %w[NUXT_PUBLIC_SELLER_ADDRESS NUXT_PUBLIC_SELLER_PHONE].freeze
  SELLER_CONTACT_DISCLOSURE_MODES = %w[public on_request].freeze

  module_function

  def enabled?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("PAID_MEMBERSHIP_ENABLED", "false")) && configured?
  end

  def configured?
    configuration_issues.empty?
  end

  def configuration_issues(environment: Rails.env)
    issues = REQUIRED_SETTINGS.filter_map { |name| "missing:#{name}" if ENV[name].blank? }
    case seller_contact_disclosure_mode
    when "public"
      issues.concat(SELLER_CONTACT_SETTINGS.filter_map { |name| "missing:#{name}" if ENV[name].blank? })
    when "on_request"
      issues << "seller_contact_disclosure_not_ready" unless seller_contact_disclosure_ready?
    else
      issues << "invalid_seller_contact_disclosure_mode"
    end
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
    public_contacts = seller_contact_disclosure_mode == "public"
    {
      name: ENV["NUXT_PUBLIC_SELLER_NAME"].to_s,
      representative: ENV["NUXT_PUBLIC_SELLER_REPRESENTATIVE"].to_s,
      address: public_contacts ? ENV["NUXT_PUBLIC_SELLER_ADDRESS"].to_s : "",
      phone: public_contacts ? ENV["NUXT_PUBLIC_SELLER_PHONE"].to_s : "",
      email: ENV["NUXT_PUBLIC_SELLER_EMAIL"].to_s,
      contact_disclosure_mode: SELLER_CONTACT_DISCLOSURE_MODES.include?(seller_contact_disclosure_mode) ? seller_contact_disclosure_mode : "unconfigured",
      contact_disclosure_ready: seller_contact_disclosure_ready?,
    }
  end

  def seller_contact_disclosure_mode
    ENV.fetch("SELLER_CONTACT_DISCLOSURE_MODE", "public")
  end

  def seller_contact_disclosure_ready?
    seller_contact_disclosure_mode == "on_request" && ENV["SELLER_CONTACT_DISCLOSURE_READY"] == "true"
  end

  def stripe_client
    Stripe::StripeClient.new(ENV.fetch("STRIPE_SECRET_KEY"))
  end
end

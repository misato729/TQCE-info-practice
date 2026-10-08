module PaidMembership
  FREE_EXAM_MAX = 5
  AMOUNT = 500
  CURRENCY = "jpy"

  module_function

  def enabled?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("PAID_MEMBERSHIP_ENABLED", "false")) && configured?
  end

  def configured?
    %w[
      STRIPE_SECRET_KEY
      STRIPE_WEBHOOK_SECRET
      STRIPE_PRICE_ID
      FRONTEND_URL
      NUXT_PUBLIC_SELLER_NAME
      NUXT_PUBLIC_SELLER_REPRESENTATIVE
      NUXT_PUBLIC_SELLER_ADDRESS
      NUXT_PUBLIC_SELLER_PHONE
      NUXT_PUBLIC_SELLER_EMAIL
    ].all? do |name|
      ENV[name].present?
    end
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

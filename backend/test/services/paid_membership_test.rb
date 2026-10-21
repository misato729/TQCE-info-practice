require "test_helper"

class PaidMembershipTest < ActiveSupport::TestCase
  test "public contact disclosure still requires an address and phone" do
    with_env(seller_environment.merge("SELLER_CONTACT_DISCLOSURE_MODE" => "public",
      "NUXT_PUBLIC_SELLER_ADDRESS" => nil, "NUXT_PUBLIC_SELLER_PHONE" => nil)) do
      assert_includes PaidMembership.configuration_issues, "missing:NUXT_PUBLIC_SELLER_ADDRESS"
      assert_includes PaidMembership.configuration_issues, "missing:NUXT_PUBLIC_SELLER_PHONE"
      assert_not PaidMembership.enabled?
    end
  end

  test "on-request contacts require explicit readiness and do not enable sales on their own" do
    with_env(seller_environment.merge("SELLER_CONTACT_DISCLOSURE_MODE" => "on_request",
      "NUXT_PUBLIC_SELLER_ADDRESS" => nil, "NUXT_PUBLIC_SELLER_PHONE" => nil)) do
      [nil, "false", "TRUE", "1"].each do |ready|
        with_env("SELLER_CONTACT_DISCLOSURE_READY" => ready) do
          assert_includes PaidMembership.configuration_issues, "seller_contact_disclosure_not_ready"
          assert_not PaidMembership.enabled?
        end
      end
      with_env("SELLER_CONTACT_DISCLOSURE_READY" => "true") do
        assert_empty PaidMembership.configuration_issues
        assert_not PaidMembership.enabled?
        with_env("PAID_MEMBERSHIP_ENABLED" => "true") { assert PaidMembership.enabled? }
      end
    end
  end

  test "on-request disclosure never returns private contacts even if old variables remain" do
    with_env(seller_environment.merge("SELLER_CONTACT_DISCLOSURE_MODE" => "on_request",
      "SELLER_CONTACT_DISCLOSURE_READY" => "true")) do
      seller = PaidMembership.seller_information
      assert_equal "", seller.fetch(:address)
      assert_equal "", seller.fetch(:phone)
      assert_equal "on_request", seller.fetch(:contact_disclosure_mode)
      assert_equal true, seller.fetch(:contact_disclosure_ready)
      assert_not_includes seller.to_json, "private-contact"
    end
  end

  test "invalid mode cannot enable sales or leak contacts or its raw setting" do
    with_env(seller_environment.merge("PAID_MEMBERSHIP_ENABLED" => "true",
      "SELLER_CONTACT_DISCLOSURE_MODE" => "private-contact-invalid-mode", "SELLER_CONTACT_DISCLOSURE_READY" => "true")) do
      assert_includes PaidMembership.configuration_issues, "invalid_seller_contact_disclosure_mode"
      assert_not PaidMembership.enabled?
      seller = PaidMembership.seller_information
      assert_equal "unconfigured", seller.fetch(:contact_disclosure_mode)
      assert_equal false, seller.fetch(:contact_disclosure_ready)
      assert_not_includes seller.to_json, "private-contact"
    end
  end

  test "on-request disclosure does not waive seller identity or the email contact" do
    %w[NUXT_PUBLIC_SELLER_NAME NUXT_PUBLIC_SELLER_REPRESENTATIVE NUXT_PUBLIC_SELLER_EMAIL].each do |setting|
      with_env(seller_environment.merge("PAID_MEMBERSHIP_ENABLED" => "true",
        "SELLER_CONTACT_DISCLOSURE_MODE" => "on_request", "SELLER_CONTACT_DISCLOSURE_READY" => "true", setting => nil)) do
        assert_includes PaidMembership.configuration_issues, "missing:#{setting}"
        assert_not PaidMembership.enabled?
      end
    end
  end

  private

  def seller_environment
    {
      "PAID_MEMBERSHIP_ENABLED" => "false", "STRIPE_LIVEMODE" => "false",
      "STRIPE_SECRET_KEY" => "sk_test_synthetic", "STRIPE_WEBHOOK_SECRET" => "whsec_synthetic",
      "STRIPE_PRICE_ID" => "price_synthetic", "FRONTEND_URL" => "https://example.invalid",
      "NUXT_PUBLIC_SELLER_NAME" => "Synthetic seller", "NUXT_PUBLIC_SELLER_REPRESENTATIVE" => "Synthetic representative",
      "NUXT_PUBLIC_SELLER_ADDRESS" => "private-contact-address", "NUXT_PUBLIC_SELLER_PHONE" => "private-contact-phone",
      "NUXT_PUBLIC_SELLER_EMAIL" => "seller@example.invalid", "SELLER_CONTACT_DISCLOSURE_MODE" => "public",
      "SELLER_CONTACT_DISCLOSURE_READY" => "false",
    }
  end
end

require "test_helper"

class VerificationAccessGrantTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "Verification", email: "verification@example.com", password: "password123")
  end

  test "verification access expires without a payment or paid membership" do
    grant = create_grant
    assert grant.active?
    assert @user.paid_content_access?
    assert_nil @user.membership
    assert_empty @user.payments

    travel_to(grant.expires_at, with_usec: true) do
      assert_not grant.active?
      assert_not @user.paid_content_access?
    end
  end

  test "revocation immediately removes verification access" do
    grant = create_grant
    grant.update!(revoked_at: Time.current)
    assert_not grant.active?
    assert_not @user.paid_content_access?
  end

  test "audit information and a limited expiration are required" do
    grant = VerificationAccessGrant.new(user: @user)
    assert_not grant.valid?
    assert grant.errors[:reason].present?
    assert grant.errors[:granted_by].present?
    assert grant.errors[:expires_at].present?
    grant.assign_attributes(reason: "QA", granted_by: "Owner", expires_at: 8.days.from_now)
    assert_not grant.valid?
    grant.expires_at = 1.minute.ago
    assert_not grant.valid?
  end

  test "database also rejects a grant longer than seven days" do
    assert_raises ActiveRecord::StatementInvalid do
      VerificationAccessGrant.transaction(requires_new: true) do
        VerificationAccessGrant.insert_all!([{
          user_id: @user.id, reason: "QA", granted_by: "Owner",
          created_at: Time.current, updated_at: Time.current, expires_at: 8.days.from_now,
        }])
      end
    end
  end

  test "an expired grant does not revoke a genuine paid membership" do
    grant = create_grant
    payment = Payment.create!(user: @user, stripe_checkout_session_id: "cs_grant_test", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    @user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    travel_to(grant.expires_at + 1.second) { assert @user.paid_content_access? }
  end

  test "account deletion removes its verification grant" do
    create_grant
    assert_difference("VerificationAccessGrant.count", -1) { @user.destroy! }
  end

  private

  def create_grant
    @user.create_verification_access_grant!(reason: "Netlify QA", granted_by: "Owner approval", expires_at: 1.day.from_now)
  end
end

require "test_helper"

class OperationsSnapshotTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  teardown do
    @user&.destroy!
    Payment.where(id: @payment_ids || []).delete_all
    StripeWebhookEvent.where(id: @event_id).delete_all if @event_id
  end

  test "reports counts without exposing personal data or settings" do
    @user = User.create!(name: "Private person", email: "audit-private@example.invalid", password: "private-password")
    pending = Payment.create!(user: @user, stripe_checkout_session_id: "cs_private_pending",
      stripe_price_id: "price_private", status: "pending", created_at: 25.hours.ago)
    disputed = Payment.create!(user: @user, stripe_checkout_session_id: "cs_private_disputed",
      stripe_price_id: "price_private", status: "disputed", last_refund_failed_at: Time.current)
    @payment_ids = [pending.id, disputed.id]
    Membership.create!(user: @user, source_payment: disputed, status: "active", activated_at: Time.current)
    event = StripeWebhookEvent.create!(stripe_event_id: "evt_private", event_type: "refund.failed", livemode: false, processed_at: Time.current)
    @event_id = event.id

    with_env("PAID_MEMBERSHIP_ENABLED" => "false", "STRIPE_SECRET_KEY" => "private-secret", "FRONTEND_URL" => "https://host.invalid/?token=private") do
      report = OperationsSnapshot.call
      assert_not report.fetch(:sales_enabled)
      assert_equal 1, report.dig(:counts, :stale_pending_checkouts)
      assert_equal 1, report.dig(:counts, :refund_failures_last_day)
      assert_equal 1, report.dig(:counts, :disputed_payments)
      assert_equal 1, report.dig(:counts, :active_memberships_with_revoked_payment)
      assert_equal 1, report.dig(:counts, :processed_webhooks_last_day)
      assert_equal 4, report.fetch(:warnings).length
      assert_not_includes JSON.generate(report), "private"
    end
    assert_equal "pending", pending.reload.status
    assert_equal "active", @user.membership.reload.status
  end

  test "database rejects writes during the audit" do
    original_pending = Payment.method(:pending)
    write = -> { User.create!(name: "Not saved", email: "not-saved@example.invalid", password: "password123") }
    Payment.define_singleton_method(:pending, write)
    assert_no_difference("User.count") do
      assert_raises(ActiveRecord::StatementInvalid) { OperationsSnapshot.call }
    end
  ensure
    Payment.define_singleton_method(:pending, original_pending)
  end
end

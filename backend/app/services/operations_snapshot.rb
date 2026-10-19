class OperationsSnapshot
  STALE_CHECKOUT_AGE = 24.hours

  def self.call(now: Time.current)
    # This report deliberately contains counts and setting names, never record IDs or secret values.
    ActiveRecord::Base.transaction(isolation: :repeatable_read) do
      ActiveRecord::Base.connection.execute("SET TRANSACTION READ ONLY")
      counts = {
        stale_pending_checkouts: Payment.pending.where("created_at < ?", now - STALE_CHECKOUT_AGE).count,
        refund_failures_last_day: Payment.where("last_refund_failed_at >= ?", now - 1.day).count,
        disputed_payments: Payment.where(status: "disputed").count,
        active_memberships_with_revoked_payment: Membership.where(status: "active")
          .joins(:source_payment).where(payments: { status: %w[refunded disputed expired pending] }).count,
        processed_webhooks_last_day: StripeWebhookEvent.where("processed_at >= ?", now - 1.day).count,
      }
      warnings = counts.except(:processed_webhooks_last_day).filter_map { |name, count| name.to_s if count.positive? }
      {
        checked_at: now.iso8601,
        environment: Rails.env.to_s,
        sales_enabled: PaidMembership.enabled?,
        payment_configuration_issues: PaidMembership.configuration_issues,
        counts: counts,
        warnings: warnings,
      }
    end
  end
end

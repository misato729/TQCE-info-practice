class AddStripeAuditFieldsToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :stripe_dispute_id, :string
    add_column :payments, :dispute_status, :string, limit: 30
    add_column :payments, :dispute_closed_at, :datetime
    add_column :payments, :last_refund_failure_reason, :string, limit: 100
    add_column :payments, :last_refund_failed_at, :datetime

    add_index :payments,
      :stripe_dispute_id,
      unique: true,
      where: "stripe_dispute_id IS NOT NULL"
  end
end

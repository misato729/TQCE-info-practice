class CreatePaidMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :question, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :favorites, [:user_id, :question_id], unique: true
    add_index :favorites, [:user_id, :created_at]

    create_table :payments do |t|
      t.references :user, null: true, foreign_key: { on_delete: :nullify }
      t.string :stripe_checkout_session_id, null: false
      t.string :stripe_payment_intent_id
      t.string :stripe_charge_id
      t.string :stripe_price_id, null: false
      t.integer :amount, null: false, default: 500
      t.integer :refunded_amount, null: false, default: 0
      t.string :currency, limit: 3, null: false, default: "jpy"
      t.string :status, limit: 30, null: false, default: "pending"
      t.datetime :paid_at
      t.datetime :refunded_at
      t.timestamps
    end

    add_index :payments, :stripe_checkout_session_id, unique: true
    add_index :payments, :stripe_payment_intent_id, unique: true, where: "stripe_payment_intent_id IS NOT NULL"
    add_index :payments, :stripe_charge_id, unique: true, where: "stripe_charge_id IS NOT NULL"
    add_index :payments, :user_id, unique: true, where: "status = 'pending' AND user_id IS NOT NULL", name: "index_payments_one_pending_per_user"
    add_index :payments, [:user_id, :created_at]
    add_index :payments, [:status, :updated_at]
    add_check_constraint :payments,
      "status IN ('pending', 'paid', 'expired', 'partially_refunded', 'refunded', 'disputed')",
      name: "payments_status_valid"
    add_check_constraint :payments, "amount > 0", name: "payments_amount_positive"
    add_check_constraint :payments,
      "refunded_amount >= 0 AND refunded_amount <= amount",
      name: "payments_refunded_amount_range"
    add_check_constraint :payments, "currency = 'jpy'", name: "payments_currency_valid"

    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: { unique: true }
      t.references :source_payment, null: false, foreign_key: { to_table: :payments }, index: { unique: true }
      t.string :status, limit: 20, null: false, default: "active"
      t.datetime :activated_at, null: false
      t.datetime :revoked_at
      t.string :revocation_reason, limit: 30
      t.timestamps
    end

    add_check_constraint :memberships,
      "status IN ('active', 'revoked')",
      name: "memberships_status_valid"

    create_table :stripe_webhook_events do |t|
      t.string :stripe_event_id, null: false
      t.string :event_type, null: false
      t.boolean :livemode, null: false
      t.datetime :processed_at, null: false
      t.timestamps
    end

    add_index :stripe_webhook_events, :stripe_event_id, unique: true
    add_index :stripe_webhook_events, [:event_type, :processed_at]
  end
end

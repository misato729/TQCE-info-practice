class Payment < ApplicationRecord
  STATUSES = %w[pending paid expired partially_refunded refunded disputed].freeze

  belongs_to :user, optional: true
  has_one :membership, foreign_key: :source_payment_id, dependent: :restrict_with_exception, inverse_of: :source_payment

  validates :stripe_checkout_session_id, :stripe_price_id, presence: true
  validates :stripe_checkout_session_id, uniqueness: true
  validates :stripe_payment_intent_id, uniqueness: true, allow_nil: true
  validates :stripe_charge_id, uniqueness: true, allow_nil: true
  validates :stripe_dispute_id, uniqueness: true, allow_nil: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :refunded_amount,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :amount }
  validates :currency, inclusion: { in: [PaidMembership::CURRENCY] }
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
end

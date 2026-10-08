class Membership < ApplicationRecord
  STATUSES = %w[active revoked].freeze

  belongs_to :user
  belongs_to :source_payment, class_name: "Payment", inverse_of: :membership

  validates :user_id, :source_payment_id, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :activated_at, presence: true
end

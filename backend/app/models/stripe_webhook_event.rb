class StripeWebhookEvent < ApplicationRecord
  validates :stripe_event_id, :event_type, :processed_at, presence: true
  validates :stripe_event_id, uniqueness: true
  validates :livemode, inclusion: { in: [true, false] }
end

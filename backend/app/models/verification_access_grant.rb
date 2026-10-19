class VerificationAccessGrant < ApplicationRecord
  MAX_DURATION = 7.days

  belongs_to :user

  validates :user_id, uniqueness: true
  validates :reason, presence: true, length: { maximum: 255 }
  validates :granted_by, presence: true, length: { maximum: 100 }
  validates :expires_at, presence: true
  validate :limited_duration

  def active?
    revoked_at.nil? && expires_at.present? && expires_at > Time.current
  end

  private

  def limited_duration
    return unless expires_at

    issued_at = created_at || Time.current
    unless expires_at > issued_at && expires_at <= issued_at + MAX_DURATION
      errors.add(:expires_at, "は付与日時から7日以内にしてください")
    end
  end
end

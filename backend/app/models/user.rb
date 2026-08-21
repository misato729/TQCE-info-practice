class User < ApplicationRecord
  has_secure_password

  has_many :answer_histories, dependent: :destroy

  before_validation :normalize_email

  validates :name, presence: true, length: { maximum: 100 }
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :role, inclusion: { in: MasterData.values(MasterData::USER_ROLES) }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end

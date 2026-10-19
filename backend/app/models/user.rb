class User < ApplicationRecord
  has_secure_password

  has_many :answer_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :payments, dependent: :nullify
  has_one :membership, dependent: :destroy
  has_one :verification_access_grant, dependent: :destroy

  before_validation :normalize_email

  validates :name, presence: true, length: { maximum: 100 }
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :role, inclusion: { in: MasterData.values(MasterData::USER_ROLES) }

  def paid_content_access?
    role == "admin" || membership&.status == "active" || verification_access_grant&.active? || false
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end

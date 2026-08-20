class Question < ApplicationRecord
  has_many :question_choices, -> { order(:display_order) }, dependent: :destroy, inverse_of: :question

  scope :published, -> { where(publication_status: "published") }

  validates :exam_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :question_number,
    numericality: { only_integer: true, in: 1..20 },
    uniqueness: { scope: :exam_number }
  validates :major_category_code, inclusion: { in: MasterData.values(MasterData::MAJOR_CATEGORIES) }
  validates :category_code, inclusion: { in: MasterData.values(MasterData::CATEGORIES) }
  validates :publication_status, inclusion: { in: MasterData.values(MasterData::PUBLICATION_STATUSES) }
  validate :category_belongs_to_major_category
  validate :content_blocks_are_arrays

  private

  def category_belongs_to_major_category
    category = MasterData::CATEGORIES.find { |item| item[:value] == category_code }
    return if category.nil? || category[:major_category_value] == major_category_code

    errors.add(:category_code, "は大分類と一致していません")
  end

  def content_blocks_are_arrays
    errors.add(:content_blocks, "は配列で指定してください") unless content_blocks.is_a?(Array)
    errors.add(:explanation_blocks, "は配列で指定してください") unless explanation_blocks.is_a?(Array)
  end
end

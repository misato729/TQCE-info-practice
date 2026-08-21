class QuestionChoice < ApplicationRecord
  belongs_to :question, inverse_of: :question_choices
  has_many :answer_histories, foreign_key: :selected_choice_id, dependent: :restrict_with_error

  validates :choice_label, presence: true, uniqueness: { scope: :question_id }
  validates :display_order,
    numericality: { only_integer: true, in: 1..4 },
    uniqueness: { scope: :question_id }
  validate :content_blocks_are_an_array

  private

  def content_blocks_are_an_array
    errors.add(:content_blocks, "は配列で指定してください") unless content_blocks.is_a?(Array)
  end
end

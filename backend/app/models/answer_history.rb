class AnswerHistory < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :selected_choice, class_name: "QuestionChoice"

  validates :is_correct, inclusion: { in: [true, false] }
  validate :selected_choice_belongs_to_question

  private

  def selected_choice_belongs_to_question
    return if question.nil? || selected_choice.nil? || selected_choice.question_id == question_id

    errors.add(:selected_choice, "は対象問題の選択肢を指定してください")
  end
end

class QuestionSeedState < ApplicationRecord
  validates :exam_number, uniqueness: { scope: :question_number }
end

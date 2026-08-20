module Api
  module V1
    class ExamsController < ApplicationController
      def index
        question_numbers_by_exam = Question.published
          .order(:exam_number, :question_number)
          .pluck(:exam_number, :question_number)
          .group_by(&:first)

        exams = question_numbers_by_exam.map do |exam_number, questions|
          {
            exam_number: exam_number,
            question_numbers: questions.map(&:second),
          }
        end

        render json: { data: exams }
      end
    end
  end
end

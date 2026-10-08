module Api
  module V1
    class ExamsController < ApplicationController
      before_action :authenticate_optional_user!

      def index
        question_numbers_by_exam = Question.published
          .order(:exam_number, :question_number)
          .pluck(:exam_number, :question_number)
          .group_by(&:first)

        exams = question_numbers_by_exam.map do |exam_number, questions|
          {
            exam_number: exam_number,
            question_numbers: questions.map(&:second),
            published_question_count: questions.length,
            access: exam_number <= PaidMembership::FREE_EXAM_MAX || current_user&.paid_content_access? ?
              "available" : "paid_membership_required",
          }
        end

        render json: { data: exams }
      end
    end
  end
end

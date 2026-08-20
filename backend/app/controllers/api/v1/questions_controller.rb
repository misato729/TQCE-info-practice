module Api
  module V1
    class QuestionsController < ApplicationController
      before_action :set_question, only: %i[show answer]

      def show
        render json: { data: serialize_question(@question) }
      end

      def next
        question = next_question
        return if performed?

        raise ActiveRecord::RecordNotFound unless question

        render json: { data: serialize_question(question) }
      end

      def answer
        selected_choice = @question.question_choices.find_by(id: params[:selected_choice_id])
        unless selected_choice
          return render_error(
            :validation_error,
            "選択肢を確認してください",
            :unprocessable_content,
            details: { selected_choice_id: ["この問題の選択肢を指定してください"] },
          )
        end

        correct_choice = @question.question_choices.find_by!(is_correct: true)

        render json: {
          data: {
            question_id: @question.id,
            selected_choice_id: selected_choice.id,
            is_correct: selected_choice.id == correct_choice.id,
            correct_choice: serialize_choice(correct_choice),
            explanation_blocks: @question.explanation_blocks,
            source_text: @question.source_text,
            answer_history_id: nil,
          },
        }
      end

      private

      def set_question
        @question = Question.published.includes(:question_choices).find(params[:id])
      end

      def next_question
        scope = Question.published.includes(:question_choices)

        if params[:exam_number].present?
          exam_number = positive_integer_param(:exam_number)
          return unless exam_number

          scope = scope.where(exam_number: exam_number)

          if params[:after_question_number].present?
            after_question_number = non_negative_integer_param(:after_question_number)
            return unless after_question_number

            scope = scope.where("question_number > ?", after_question_number)
          end

          return scope.order(:question_number).first
        end

        if params[:after_question_number].present?
          render_error(:bad_request, "exam_numberを指定してください", :bad_request)
          return
        end

        ordered_scope = scope.order(:exam_number, :question_number)
        return ordered_scope.first if params[:exclude_question_id].blank?

        excluded = positive_integer_param(:exclude_question_id)
        return unless excluded

        ordered_scope.where.not(id: excluded).first || ordered_scope.first
      end

      def positive_integer_param(name)
        value = Integer(params[name], exception: false)
        return value if value&.positive?

        render_error(:bad_request, "#{name}を正しく指定してください", :bad_request)
        nil
      end

      def non_negative_integer_param(name)
        value = Integer(params[name], exception: false)
        return value if value && value >= 0

        render_error(:bad_request, "#{name}を正しく指定してください", :bad_request)
        nil
      end

      def serialize_question(question)
        {
          id: question.id,
          exam_number: question.exam_number,
          question_number: question.question_number,
          content_blocks: question.content_blocks,
          major_category_code: question.major_category_code,
          category_code: question.category_code,
          choices: question.question_choices.map { |choice| serialize_choice(choice) },
        }
      end

      def serialize_choice(choice)
        {
          id: choice.id,
          choice_label: choice.choice_label,
          content_blocks: choice.content_blocks,
          display_order: choice.display_order,
        }
      end
    end
  end
end

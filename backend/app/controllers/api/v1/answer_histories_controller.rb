module Api
  module V1
    class AnswerHistoriesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_answer_history, only: :show

      def index
        page = positive_integer_param(:page, default: 1)
        per_page = positive_integer_param(:per_page, default: 20, maximum: 100)
        return if performed?

        scope = current_user.answer_histories
          .includes(:question, :selected_choice)
          .order(created_at: :desc, id: :desc)
        total_count = scope.count
        histories = scope.offset((page - 1) * per_page).limit(per_page)

        render json: {
          data: histories.map { |history| serialize_history(history) },
          meta: {
            current_page: page,
            per_page: per_page,
            total_count: total_count,
            total_pages: (total_count.to_f / per_page).ceil,
          },
        }
      end

      def show
        correct_choice = @answer_history.question.question_choices.find_by!(is_correct: true)

        render json: {
          data: serialize_history(@answer_history).merge(
            correct_choice: serialize_choice(correct_choice),
            explanation_blocks: @answer_history.question.explanation_blocks,
            source_text: @answer_history.question.source_text,
          ),
        }
      end

      private

      def set_answer_history
        @answer_history = current_user.answer_histories
          .includes(question: :question_choices)
          .find(params[:id])
      end

      def positive_integer_param(name, default:, maximum: nil)
        raw_value = params[name].presence || default
        value = Integer(raw_value, exception: false)
        valid = value&.positive? && (maximum.nil? || value <= maximum)
        return value if valid

        render_error(:bad_request, "#{name}を正しく指定してください", :bad_request)
        nil
      end

      def serialize_history(history)
        {
          id: history.id,
          question: {
            id: history.question.id,
            exam_number: history.question.exam_number,
            question_number: history.question.question_number,
            body_excerpt: excerpt_from(history.question.content_blocks),
            major_category_code: history.question.major_category_code,
            category_code: history.question.category_code,
          },
          selected_choice: {
            id: history.selected_choice.id,
            choice_label: history.selected_choice.choice_label,
            body_excerpt: excerpt_from(history.selected_choice.content_blocks),
          },
          is_correct: history.is_correct,
          answered_at: history.created_at.iso8601,
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

      def excerpt_from(blocks)
        block = blocks.find { |item| %w[text quote fill_in_text fill_in_quote].include?(item["type"] || item[:type]) }
        text = block && (block["text"] || block[:text])
        return text.gsub(/\{\{([^{}]+)\}\}/, '\\1').squish.truncate(120) if text.present?

        choice_block = blocks.find { |item| (item["type"] || item[:type]) == "fill_in_choice" }
        cells = choice_block && (choice_block["cells"] || choice_block[:cells])
        Array(cells).join(" / ").truncate(120)
      end
    end
  end
end

module Api
  module V1
    class FavoritesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_question, only: %i[create destroy]

      def index
        favorites = current_user.favorites
          .joins(:question)
          .merge(Question.published)
          .includes(:question)
          .order(created_at: :desc, id: :desc)

        render json: { data: favorites.map { |favorite| serialize_favorite(favorite) } }
      end

      def create
        return unless authorize_exam_access!(@question.exam_number)

        favorite = current_user.favorites.find_or_create_by!(question: @question)
        render json: { data: serialize_favorite(favorite) }, status: :created
      end

      def destroy
        current_user.favorites.where(question: @question).destroy_all
        head :no_content
      end

      private

      def set_question
        @question = Question.published.find(params[:question_id])
      end

      def serialize_favorite(favorite)
        question = favorite.question
        base = {
          id: favorite.id,
          question: {
            id: question.id,
            exam_number: question.exam_number,
            question_number: question.question_number,
          },
          created_at: favorite.created_at.iso8601,
        }

        unless question.exam_number <= PaidMembership::FREE_EXAM_MAX || current_user.paid_content_access?
          return base.merge(locked: true)
        end

        base.merge(
          locked: false,
          question: base[:question].merge(
            body_excerpt: excerpt_from(question.content_blocks),
            major_category_code: question.major_category_code,
            category_code: question.category_code,
          ),
        )
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

module Api
  module V1
    module Admin
      class QuestionsController < ApplicationController
        class InvalidQuestionPayload < StandardError
          attr_reader :details

          def initialize(message, details = {})
            super(message)
            @details = details
          end
        end

        before_action :authenticate_admin!
        before_action :set_question, only: %i[show update destroy]

        rescue_from InvalidQuestionPayload, with: :render_invalid_payload

        def index
          questions = filtered_questions.order(:exam_number, :question_number, :id)
          total_count = questions.count
          page = positive_integer(params[:page], 1)
          per_page = [positive_integer(params[:per_page], 20), 100].min
          total_pages = [(total_count.to_f / per_page).ceil, 1].max
          page = total_pages if page > total_pages
          questions = questions.offset((page - 1) * per_page).limit(per_page)

          render json: {
            data: questions.map { |question| serialize_summary(question) },
            meta: {
              current_page: page,
              per_page: per_page,
              total_count: total_count,
              total_pages: total_pages,
            },
          }
        end

        def show
          render json: { data: serialize_question(@question) }
        end

        def create
          question = Question.new
          save_question!(question, status: :created)
        end

        def update
          save_question!(@question, status: :ok)
        end

        def destroy
          @question.destroy!
          head :no_content
        end

        private

        def set_question
          @question = Question.includes(:question_choices).find(params[:id])
        end

        def filtered_questions
          scope = Question.all
          scope = scope.where(exam_number: params[:exam_number]) if params[:exam_number].present?
          scope = scope.where(major_category_code: params[:major_category_code]) if params[:major_category_code].present?
          scope = scope.where(category_code: params[:category_code]) if params[:category_code].present?
          scope = scope.where(publication_status: params[:publication_status]) if params[:publication_status].present?

          if params[:keyword].present?
            escaped_keyword = ActiveRecord::Base.sanitize_sql_like(params[:keyword].to_s.strip)
            scope = scope.where("content_blocks::text ILIKE ?", "%#{escaped_keyword}%")
          end

          scope
        end

        def positive_integer(value, fallback)
          integer = Integer(value, exception: false)
          integer&.positive? ? integer : fallback
        end

        def save_question!(question, status:)
          attributes = sanitized_question_attributes

          Question.transaction do
            question.assign_attributes(attributes.except(:choices))
            question.save!
            sync_choices!(question, attributes[:choices])
          end

          render json: { data: serialize_question(question.reload) }, status: status
        rescue ActiveRecord::RecordInvalid => error
          render_error(
            :validation_error,
            "入力内容を確認してください",
            :unprocessable_content,
            details: error.record.errors.to_hash,
          )
        end

        def sanitized_question_attributes
          source = params.require(:question)
          content_blocks = sanitize_blocks(source[:content_blocks], context: :question)
          explanation_blocks = sanitize_blocks(source[:explanation_blocks], context: :explanation)
          choices = sanitize_choices(source[:choices])

          {
            exam_number: source[:exam_number],
            question_number: source[:question_number],
            major_category_code: source[:major_category_code].to_s,
            category_code: source[:category_code].to_s,
            publication_status: source[:publication_status].to_s,
            source_text: source[:source_text].presence,
            content_blocks: content_blocks,
            explanation_blocks: explanation_blocks,
            choices: choices,
          }
        end

        def sanitize_choices(raw_choices)
          choices = Array(raw_choices)
          unless choices.size == 4
            raise InvalidQuestionPayload.new("選択肢は4件入力してください", choices: ["は4件必要です"])
          end

          sanitized = choices.each_with_index.map do |choice, index|
            choice = parameter_hash(choice)
            {
              id: positive_integer(choice[:id], nil),
              choice_label: choice[:choice_label].to_s,
              content_blocks: sanitize_blocks(choice[:content_blocks], context: :choice),
              is_correct: ActiveModel::Type::Boolean.new.cast(choice[:is_correct]),
              display_order: index + 1,
            }
          end

          unless sanitized.count { |choice| choice[:is_correct] } == 1
            raise InvalidQuestionPayload.new("正答を1件選択してください", choices: ["正答は1件必要です"])
          end

          sanitized
        end

        def sanitize_blocks(raw_blocks, context:)
          blocks = Array(raw_blocks)
          if blocks.empty?
            raise InvalidQuestionPayload.new("表示ブロックを1件以上入力してください", content_blocks: ["は1件以上必要です"])
          end

          blocks.map { |block| sanitize_block(parameter_hash(block), context: context) }
        end

        def sanitize_block(block, context:)
          type = block[:type].to_s
          allowed_types = {
            question: %w[text quote table code code_group fill_in_text fill_in_quote],
            explanation: %w[text quote table code],
            choice: %w[text table fill_in_choice],
          }.fetch(context)

          unless allowed_types.include?(type)
            raise InvalidQuestionPayload.new("表示ブロックの種類が正しくありません", content_blocks: ["#{type}は使用できません"])
          end

          case type
          when "text", "fill_in_text", "fill_in_quote"
            { type: type, text: block[:text].to_s }
          when "quote"
            { type: type, text: block[:text].to_s, source: block[:source].to_s.presence }.compact
          when "table"
            headers = Array(block[:headers]).map(&:to_s)
            rows = Array(block[:rows]).map { |row| Array(row).map(&:to_s) }
            if headers.empty? || rows.empty? || rows.any? { |row| row.size != headers.size }
              raise InvalidQuestionPayload.new("表の列数を確認してください", content_blocks: ["見出しと各行の列数を揃えてください"])
            end
            { type: type, headers: headers, rows: rows }
          when "code"
            { type: type, title: block[:title].to_s.presence, code: block[:code].to_s }.compact
          when "code_group"
            items = Array(block[:items]).map do |item|
              item = parameter_hash(item)
              { title: item[:title].to_s, code: item[:code].to_s }
            end
            if items.size < 2
              raise InvalidQuestionPayload.new("比較するプログラムを2件以上入力してください")
            end
            { type: type, items: items }
          when "fill_in_choice"
            { type: type, cells: Array(block[:cells]).map(&:to_s) }
          end
        end

        def sync_choices!(question, choices)
          question.question_choices.update_all(is_correct: false)
          retained_ids = []

          choices.each do |attributes|
            choice = if attributes[:id]
              question.question_choices.find_by(id: attributes[:id])
            end
            choice ||= question.question_choices.find_or_initialize_by(choice_label: attributes[:choice_label])
            choice.assign_attributes(attributes.except(:id))
            choice.save!
            retained_ids << choice.id
          end

          question.question_choices.where.not(id: retained_ids).destroy_all
        end

        def parameter_hash(value)
          hash = value.respond_to?(:to_unsafe_h) ? value.to_unsafe_h : value.to_h
          hash.with_indifferent_access
        end

        def serialize_summary(question)
          {
            id: question.id,
            exam_number: question.exam_number,
            question_number: question.question_number,
            summary: question_summary(question),
            major_category_code: question.major_category_code,
            category_code: question.category_code,
            publication_status: question.publication_status,
            updated_at: question.updated_at.iso8601,
          }
        end

        def question_summary(question)
          text = question.content_blocks.filter_map do |block|
            block["text"] if %w[text quote fill_in_text fill_in_quote].include?(block["type"])
          end.join(" ").squish
          text.presence || "表・プログラムを含む問題"
        end

        def serialize_question(question)
          {
            id: question.id,
            exam_number: question.exam_number,
            question_number: question.question_number,
            content_blocks: question.content_blocks,
            major_category_code: question.major_category_code,
            category_code: question.category_code,
            explanation_blocks: question.explanation_blocks,
            source_text: question.source_text,
            publication_status: question.publication_status,
            choices: question.question_choices.map do |choice|
              {
                id: choice.id,
                choice_label: choice.choice_label,
                content_blocks: choice.content_blocks,
                is_correct: choice.is_correct,
                display_order: choice.display_order,
              }
            end,
            created_at: question.created_at.iso8601,
            updated_at: question.updated_at.iso8601,
          }
        end

        def render_invalid_payload(error)
          render_error(
            :validation_error,
            error.message,
            :unprocessable_content,
            details: error.details,
          )
        end
      end
    end
  end
end

require "digest"

class QuestionPayload
  FIELDS = %w[exam_number question_number major_category_code category_code content_blocks explanation_blocks source_text].freeze

  def self.from_record(question)
    question.attributes.slice(*FIELDS).merge(
      "choices" => question.question_choices.reload.map do |choice|
        choice.attributes.slice("choice_label", "content_blocks", "is_correct", "display_order")
      end,
    )
  end

  def self.from_seed(exam_number, attributes)
    attributes = attributes.deep_stringify_keys
    attributes.slice(*FIELDS).merge("exam_number" => exam_number, "choices" => attributes.fetch("choices").each_with_index.map do |choice, index|
      { "choice_label" => choice.fetch("label"), "content_blocks" => choice.fetch("content_blocks"),
        "is_correct" => choice.fetch("correct", false), "display_order" => index + 1 }
    end)
  end

  def self.digest(payload)
    Digest::SHA256.hexdigest(JSON.generate(canonical(payload)))
  end

  def self.canonical(value)
    case value
    when Hash then value.stringify_keys.sort.to_h.transform_values { |item| canonical(item) }
    when Array then value.map { |item| canonical(item) }
    else value
    end
  end
end

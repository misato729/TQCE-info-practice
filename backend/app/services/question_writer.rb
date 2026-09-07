require "uri"

# Admin and seed writes share validation, locking and history invalidation.
class QuestionWriter
  LABELS = %w[ア イ ウ エ].freeze

  def self.transaction(&block)
    Question.transaction do
      # Serialize question writes (including creation and seed tombstones).
      Question.connection.execute("SELECT pg_advisory_xact_lock(71514345)")
      block.call
    end
  end

  def self.save!(question, attributes)
    transaction do
      question.lock! if question.persisted?
      before = QuestionPayload.from_record(question) if question.persisted?
      attributes = attributes.deep_symbolize_keys
      choices = attributes.fetch(:choices).map { |choice| choice.merge(content_blocks: choice.fetch(:content_blocks).as_json) }
      if question.persisted? && QuestionSeedState.exists?(exam_number: question.exam_number, question_number: question.question_number) &&
          (attributes[:exam_number].to_i != question.exam_number || attributes[:question_number].to_i != question.question_number)
        invalid!(question, "seed管理中の試験ナンバー・問番号は変更できません")
      end
      question.assign_attributes(attributes.except(:choices))
      validate_choices!(question, choices)
      validate_publication!(question, choices) if question.publication_status == "published"
      question.save!
      after = question.attributes.slice(*QuestionPayload::FIELDS).merge("choices" => choices.map do |choice|
        choice.slice(:choice_label, :content_blocks, :is_correct, :display_order).deep_stringify_keys
      end)
      if before && QuestionPayload.digest(before) != QuestionPayload.digest(after)
        question.answer_histories.destroy_all
      end
      question.question_choices.update_all(is_correct: false)
      choices.each do |attributes|
        choice = question.question_choices.find_or_initialize_by(choice_label: attributes.fetch(:choice_label))
        choice.assign_attributes(attributes.except(:id))
        choice.save!
      end
      unless question.question_choices.count == 4 && question.question_choices.where(is_correct: true).count == 1
        invalid!(question, "選択肢は4件、正答は1件必要です")
      end
      question.reload
    end
  end

  def self.destroy!(question)
    transaction do
      question.lock!
      state = QuestionSeedState.find_or_initialize_by(exam_number: question.exam_number, question_number: question.question_number)
      state.update!(deleted: true)
      question.destroy!
    end
  end

  def self.validate_choices!(question, choices)
    unless choices.size == 4 && choices.map { |c| c[:choice_label] } == LABELS &&
        choices.map { |c| c[:display_order] } == [1, 2, 3, 4] && choices.count { |c| c[:is_correct] == true } == 1
      invalid!(question, "選択肢はア・イ・ウ・エの順で各1件、正答は1件必要です")
    end
    ids = choices.filter_map { |c| c[:id] }
    invalid!(question, "選択肢IDが重複しています") if ids.uniq.size != ids.size
    choices.each do |choice|
      next unless choice[:id]
      unless question.persisted? && question.question_choices.exists?(id: choice[:id], choice_label: choice[:choice_label])
        invalid!(question, "選択肢IDと問題・ラベルが一致しません")
      end
    end
  end

  def self.validate_publication!(question, choices)
    validate_blocks!(question, question.content_blocks, :question)
    validate_blocks!(question, question.explanation_blocks, :explanation)
    choices.each { |choice| validate_blocks!(question, choice[:content_blocks], :choice) }
    sources = question.source_text.to_s.lines.map(&:strip).reject(&:empty?)
    unless sources.any? && sources.all? { |line| valid_source?(line) }
      invalid!(question, "公開する問題には「資料名 | https://...」形式の出典が必要です")
    end
    labels = question.content_blocks.flat_map { |b| b["text"].to_s.scan(/\{\{([^}]+)\}\}/).flatten }.uniq.sort
    fill_choices = choices.map { |choice| choice[:content_blocks].select { |b| b["type"] == "fill_in_choice" } }
    if labels.any? || fill_choices.any?(&:any?)
      unless labels.any? && labels == %w[① ② ③ ④ ⑤ ⑥].first(labels.size) &&
          fill_choices.all? { |blocks| blocks.size == 1 && blocks.first["cells"].size == labels.size }
        invalid!(question, "空欄ラベルと全選択肢のセル数を一致させてください")
      end
    end
  end

  def self.validate_blocks!(question, blocks, context)
    allowed = { question: %w[text quote table code code_group fill_in_text fill_in_quote],
                explanation: %w[text quote table code], choice: %w[text table fill_in_choice] }.fetch(context)
    valid = blocks.is_a?(Array) && blocks.any? && blocks.all? do |block|
      next false unless block.is_a?(Hash) && allowed.include?(block["type"])
      case block["type"]
      when "text", "quote", "fill_in_text", "fill_in_quote" then block["text"].is_a?(String) && block["text"].present?
      when "code" then block["code"].is_a?(String) && block["code"].present?
      when "fill_in_choice" then block["cells"].is_a?(Array) && block["cells"].any? && block["cells"].all? { |v| v.is_a?(String) && v.present? }
      when "code_group"
        block["items"].is_a?(Array) && block["items"].size >= 2 && block["items"].all? { |b| b.is_a?(Hash) && b["code"].is_a?(String) && b["code"].present? }
      when "table"
        headers, rows = block.values_at("headers", "rows")
        headers.is_a?(Array) && headers.any? && headers.all? { |v| v.is_a?(String) } &&
          rows.is_a?(Array) && rows.any? && rows.all? { |row| row.is_a?(Array) && row.size == headers.size && row.all? { |v| v.is_a?(String) } } &&
          headers.any?(&:present?) && rows.flatten.any?(&:present?)
      end
    end
    invalid!(question, "公開する問題の本文・解説・選択肢に空または不正な表示ブロックがあります") unless valid
  end

  def self.valid_source?(line)
    match = line.match(/\A.+\s\|\s(https:\/\/\S+)\z/)
    return false unless match
    uri = URI.parse(match[1])
    uri.is_a?(URI::HTTPS) && uri.host.present? && uri.userinfo.nil?
  rescue URI::InvalidURIError
    false
  end

  def self.invalid!(question, message)
    question.errors.add(:base, message)
    raise ActiveRecord::RecordInvalid, question
  end
end

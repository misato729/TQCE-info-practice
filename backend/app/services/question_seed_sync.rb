class QuestionSeedSync
  class Conflict < StandardError; end

  def self.collect
    previous = Thread.current[:question_seed_entries]
    Thread.current[:question_seed_entries] = []
    yield
    Thread.current[:question_seed_entries]
  ensure
    Thread.current[:question_seed_entries] = previous
  end

  def self.import(exam_number:, questions:, publication_status:)
    entries = questions.map { |attributes| { exam_number: exam_number, attributes: attributes, publication_status: publication_status } }
    if Thread.current[:question_seed_entries]
      Thread.current[:question_seed_entries].concat(entries)
    else
      QuestionWriter.transaction { entries.each { |entry| call(**entry) } }
    end
  end

  def self.preview(entry)
    payload = QuestionPayload.from_seed(entry.fetch(:exam_number), entry.fetch(:attributes))
    question = Question.new(payload.except("choices").merge("publication_status" => entry.fetch(:publication_status)))
    question.question_choices.build(payload.fetch("choices"))
    question
  end

  def self.call(exam_number:, attributes:, publication_status:)
    QuestionWriter.transaction do
      key = { exam_number: exam_number, question_number: attributes.fetch(:question_number) }
      state = QuestionSeedState.find_or_initialize_by(key)
      return :deleted if state.deleted?
      question = Question.find_or_initialize_by(key)
      question.lock! if question.persisted?
      payload = QuestionPayload.from_seed(exam_number, attributes)
      preview = preview(exam_number: exam_number, attributes: attributes, publication_status: publication_status)
      QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
      QuestionWriter.validate_publication!(preview, payload.fetch("choices").map { |c| c.symbolize_keys }) if publication_status == "published"
      digest = QuestionPayload.digest(payload)
      if state.new_record? && question.persisted?
        baseline = JSON.parse(File.read(Rails.root.join("db/seeds/legacy_digests_20260907.json")))
        state.seed_digest = baseline["#{exam_number}-#{key[:question_number]}"]
        state.seed_publication_status = exam_number <= 10 ? "published" : "draft" if state.seed_digest
      end
      current_digest = QuestionPayload.digest(QuestionPayload.from_record(question)) if question.persisted?
      if question.persisted? && state.seed_digest != digest && current_digest != state.seed_digest && current_digest != digest
        raise Conflict, "模試#{exam_number} 問#{key[:question_number]}: 管理画面とseedの変更が競合しています。DBを上書きせず停止しました。"
      end
      # A missing question with an existing state was deliberately removed.
      if !question.persisted? && state.persisted?
        state.update!(deleted: true)
        return :deleted
      end
      status = if question.persisted? && question.publication_status != state.seed_publication_status
        question.publication_status
      else
        publication_status
      end
      if !question.persisted? || state.seed_digest != digest || status != question.publication_status
        write_payload = question.persisted? && state.seed_digest == digest ? QuestionPayload.from_record(question) : payload
        QuestionWriter.save!(question, write_payload.merge("publication_status" => status))
      end
      state.update!(seed_digest: digest, seed_publication_status: publication_status)
      :synced
    end
  end
end

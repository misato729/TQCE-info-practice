require "json"
require "tempfile"

# An explicit, question-only transfer for a new database, never a deployment seed.
# Full database backups remain necessary for users, histories and payments.
class QuestionArchive
  class Error < StandardError; end

  FORMAT = "tqce-question-archive".freeze
  VERSION = 1
  IMPORT_CONFIRMATION = "IMPORT_INTO_EMPTY_DATABASE".freeze
  MAX_BYTES = 64 * 1024 * 1024
  QUESTION_FIELDS = (QuestionPayload::FIELDS + %w[publication_status choices]).freeze
  CHOICE_FIELDS = %w[choice_label content_blocks is_correct display_order].freeze
  DOCUMENT_FIELDS = %w[format version question_count choice_count sha256 questions].freeze
  BLOCK_FIELDS = {
    "text" => %w[type text], "quote" => %w[type text source],
    "fill_in_text" => %w[type text], "fill_in_quote" => %w[type text],
    "table" => %w[type headers rows], "code" => %w[type title code],
    "code_group" => %w[type items], "fill_in_choice" => %w[type cells],
  }.freeze
  BLOCK_TYPES = {
    question: %w[text quote fill_in_text fill_in_quote table code code_group],
    explanation: %w[text quote table code], choice: %w[text table fill_in_choice],
  }.freeze

  def self.export!(path:)
    destination = explicit_path(path)
    raise Error, "出力先ファイルは既に存在します" if File.exist?(destination) || File.symlink?(destination)
    raise Error, "出力先のディレクトリを先に用意してください" unless File.directory?(File.dirname(destination))
    raise Error, "書き出しは既存トランザクションの外で実行してください" if Question.connection.transaction_open?

    document = Question.transaction(isolation: :repeatable_read) do
      Question.connection.execute("SET TRANSACTION READ ONLY")
      questions = Question.includes(:question_choices).order(:exam_number, :question_number).map do |question|
        question.attributes.slice(*(QUESTION_FIELDS - ["choices"])).merge(
          "choices" => question.question_choices.map { |choice| choice.attributes.slice(*CHOICE_FIELDS) },
        )
      end
      validate_questions!(questions)
      payload = {
        "format" => FORMAT, "version" => VERSION,
        "question_count" => questions.size,
        "choice_count" => questions.sum { |question| question.fetch("choices").size },
        "questions" => questions,
      }
      payload.merge("sha256" => QuestionPayload.digest(payload))
    end
    encoded = JSON.pretty_generate(document) + "\n"
    raise Error, "アーカイブのサイズ上限を超えています" if encoded.bytesize > MAX_BYTES

    # The temporary file is on the same filesystem. link() publishes a complete
    # file atomically and refuses an existing destination even after a race.
    Tempfile.create([".tqce-questions-", ".tmp"], File.dirname(destination)) do |file|
      file.binmode
      file.chmod(0o600)
      file.write(encoded)
      file.flush
      file.fsync
      File.link(file.path, destination)
    end
    summary(document)
  rescue Errno::EEXIST
    raise Error, "出力先ファイルは既に存在します"
  rescue SystemCallError, IOError
    raise Error, "アーカイブの書き出しに失敗しました。出力先と権限を確認してください"
  end

  def self.import!(path:, confirmation:)
    unless confirmation == IMPORT_CONFIRMATION
      raise Error, "空のDBへ取り込む明示的な確認が必要です"
    end
    document = read_document(explicit_path(path))
    validate_document!(document)

    QuestionWriter.transaction do
      # Also exclude direct inserts that do not use the writer's advisory lock.
      Question.connection.execute("LOCK TABLE questions, question_choices IN SHARE ROW EXCLUSIVE MODE")
      unless Question.count.zero? && QuestionChoice.count.zero?
        raise Error, "問題と選択肢が両方空のDBだけに取り込めます。既存データは上書きしません"
      end
      imported = document.fetch("questions").map do |attributes|
        QuestionWriter.save!(Question.new, attributes, require_complete_exam: false)
      rescue ActiveRecord::RecordInvalid
        raise Error, "取り込む問題の本文・選択肢・分類・出典・公開状態を確認してください"
      end
      imported.select { |question| question.publication_status == "published" }.group_by(&:exam_number).each_value do |questions|
        QuestionWriter.validate_complete_exam!(questions.first)
      rescue ActiveRecord::RecordInvalid
        raise Error, "公開する模擬試験には問1〜20の登録が必要です"
      end
    end
    summary(document)
  end

  def self.explicit_path(path)
    raise Error, "ファイルのパスを明示してください" unless path.is_a?(String) && path.present? && !path.include?("\0")

    File.expand_path(path)
  end
  private_class_method :explicit_path

  def self.read_document(path)
    raise Error, "取込元には通常のJSONファイルを指定してください" unless File.lstat(path).file?

    content = File.open(path, "rb") { |file| file.read(MAX_BYTES + 1) }
    raise Error, "アーカイブのサイズ上限を超えています" if content.bytesize > MAX_BYTES

    JSON.parse(content)
  rescue JSON::ParserError, EncodingError
    raise Error, "アーカイブのJSON形式を確認してください"
  rescue SystemCallError, IOError
    raise Error, "アーカイブを読み取れません。入力元と権限を確認してください"
  end
  private_class_method :read_document

  def self.validate_document!(document)
    exact_keys!(document, DOCUMENT_FIELDS)
    unless document["format"] == FORMAT && document["version"].is_a?(Integer) && document["version"] == VERSION
      raise Error, "未対応のアーカイブ形式又はバージョンです"
    end
    questions = document.fetch("questions")
    validate_questions!(questions)
    unless document["question_count"].is_a?(Integer) && document["choice_count"].is_a?(Integer) &&
        document["question_count"] == questions.size &&
        document["choice_count"] == questions.sum { |question| question.fetch("choices").size }
      raise Error, "アーカイブの件数が一致しません"
    end
    unless document["sha256"].is_a?(String) && document["sha256"].match?(/\A[0-9a-f]{64}\z/) &&
        document["sha256"] == QuestionPayload.digest(document.except("sha256"))
      raise Error, "アーカイブの照合値が一致しません"
    end
  end
  private_class_method :validate_document!

  def self.validate_questions!(questions)
    raise Error, "問題は配列で指定してください" unless questions.is_a?(Array)

    keys = []
    questions.each do |question|
      exact_keys!(question, QUESTION_FIELDS)
      unless question["exam_number"].is_a?(Integer) && question["exam_number"].positive? &&
          question["question_number"].is_a?(Integer) && (1..20).cover?(question["question_number"]) &&
          %w[major_category_code category_code publication_status].all? { |key| question[key].is_a?(String) } &&
          (question["source_text"].nil? || question["source_text"].is_a?(String))
        raise Error, "問題の番号・分類・出典・公開状態の形式が不正です"
      end
      keys << question.values_at("exam_number", "question_number")
      validate_blocks!(question["content_blocks"], :question)
      validate_blocks!(question["explanation_blocks"], :explanation)
      choices = question["choices"]
      unless choices.is_a?(Array) && choices.size == 4
        raise Error, "各問題には4件の選択肢が必要です"
      end
      choices.each do |choice|
        exact_keys!(choice, CHOICE_FIELDS)
        unless choice["choice_label"].is_a?(String) && [true, false].include?(choice["is_correct"]) && choice["display_order"].is_a?(Integer)
          raise Error, "選択肢のラベル・正答・表示順の形式が不正です"
        end
        validate_blocks!(choice["content_blocks"], :choice)
      end
      QuestionWriter.validate_choices!(Question.new, choices.map(&:deep_symbolize_keys))
    rescue ActiveRecord::RecordInvalid
      raise Error, "選択肢はア・イ・ウ・エの順で各1件、正答は1件必要です"
    end
    raise Error, "試験ナンバーと問番号が重複しています" unless keys.uniq.size == keys.size
  end
  private_class_method :validate_questions!

  def self.validate_blocks!(blocks, context)
    raise Error, "表示ブロックは配列で指定してください" unless blocks.is_a?(Array)

    blocks.each do |block|
      unless block.is_a?(Hash) && BLOCK_TYPES.fetch(context).include?(block["type"])
        raise Error, "表示ブロックの種類が不正です"
      end
      allowed = BLOCK_FIELDS.fetch(block.fetch("type"))
      unless (block.keys - allowed).empty?
        raise Error, "アーカイブに未対応の属性が含まれています"
      end
      valid = case block["type"]
      when "text", "quote", "fill_in_text", "fill_in_quote"
        block["text"].is_a?(String) && (!block.key?("source") || block["source"].nil? || block["source"].is_a?(String))
      when "code"
        block["code"].is_a?(String) && (!block.key?("title") || block["title"].nil? || block["title"].is_a?(String))
      when "table"
        block["headers"].is_a?(Array) && block["headers"].all? { |value| value.is_a?(String) } &&
          block["rows"].is_a?(Array) && block["rows"].all? { |row| row.is_a?(Array) && row.size == block["headers"].size && row.all? { |value| value.is_a?(String) } }
      when "fill_in_choice"
        block["cells"].is_a?(Array) && block["cells"].all? { |value| value.is_a?(String) }
      when "code_group"
        block["items"].is_a?(Array) && block["items"].all? do |item|
          item.is_a?(Hash) && (item.keys - %w[title code]).empty? && item["code"].is_a?(String) &&
            (!item.key?("title") || item["title"].nil? || item["title"].is_a?(String))
        end
      end
      raise Error, "表示ブロックの内容の形式が不正です" unless valid
    end
  end
  private_class_method :validate_blocks!

  def self.exact_keys!(value, keys)
    unless value.is_a?(Hash) && value.keys.sort == keys.sort
      raise Error, "アーカイブの属性が不足しているか、未対応の属性が含まれています"
    end
  end
  private_class_method :exact_keys!

  def self.summary(document)
    document.slice("format", "version", "question_count", "choice_count", "sha256").symbolize_keys
  end
  private_class_method :summary
end

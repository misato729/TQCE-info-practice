require "test_helper"
require "tmpdir"
require "fileutils"

class QuestionArchiveTest < ActiveSupport::TestCase
  # Export must open a real top-level repeatable-read, read-only transaction.
  self.use_transactional_tests = false

  setup do
    @existing_question_ids = Question.pluck(:id)
    assert_empty @existing_question_ids, "Use the isolated, empty test database"
    @directory = Dir.mktmpdir("tqce-question-archive-test-")
    File.chmod(0o700, @directory)
    @path = File.join(@directory, "questions.json")
  end

  teardown do
    Question.where.not(id: @existing_question_ids || []).find_each { |question| QuestionWriter.destroy!(question) }
    FileUtils.remove_entry(@directory) if @directory && File.directory?(@directory)
  end

  test "exports current content only without ids or unrelated data and refuses overwrite" do
    question = create_question(1, publication_status: "draft")
    before = question.attributes
    choices_before = question.question_choices.map(&:attributes)
    result = QuestionArchive.export!(path: @path)
    document = JSON.parse(File.read(@path))
    assert_equal 1, result.fetch(:question_count)
    assert_equal 4, result.fetch(:choice_count)
    assert_equal 0o600, File.stat(@path).mode & 0o777
    assert_equal result.fetch(:sha256), QuestionPayload.digest(document.except("sha256"))
    assert_equal QuestionArchive::QUESTION_FIELDS.sort, document.fetch("questions").sole.keys.sort
    assert document.fetch("questions").sole.fetch("choices").all? { |choice| choice.keys.sort == QuestionArchive::CHOICE_FIELDS.sort }
    assert_equal "draft", document.fetch("questions").sole.fetch("publication_status")
    assert_equal before, question.reload.attributes
    assert_equal choices_before, question.question_choices.reload.map(&:attributes)
    original = File.binread(@path)
    assert_raises(QuestionArchive::Error) { QuestionArchive.export!(path: @path) }
    assert_equal original, File.binread(@path)
    assert_equal ["questions.json"], Dir.children(@directory)
    repeated = QuestionArchive.export!(path: File.join(@directory, "questions-again.json"))
    assert_equal result, repeated
    assert_equal original, File.binread(File.join(@directory, "questions-again.json"))
  end

  test "export uses a repeatable read read only snapshot" do
    observed = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_name, _start, _finish, _id, payload|
      next unless payload[:sql].include?("SELECT") && payload[:sql].include?("questions")

      connection = Question.connection
      observed << [connection.select_value("SHOW transaction_isolation"), connection.select_value("SHOW transaction_read_only")]
    end
    QuestionArchive.export!(path: @path)
    assert observed.any?
    assert observed.all? { |isolation, read_only| isolation == "repeatable read" && read_only == "on" }
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
  end

  test "imports a complete published set and preserves content and publication status" do
    questions = (1..20).map { |number| attributes(number, publication_status: number == 20 ? "private" : "published") }
    write_archive(questions)
    report = QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION)
    assert_equal 20, report.fetch(:question_count)
    assert_equal 80, QuestionChoice.count
    assert_equal 19, Question.published.count
    assert_equal "private", Question.find_by!(exam_number: 91, question_number: 20).publication_status
    assert_equal questions, Question.order(:question_number).map { |question| QuestionPayload.from_record(question).merge("publication_status" => question.publication_status) }
  end

  test "requires confirmation and never overwrites existing questions" do
    write_archive([attributes(1, publication_status: "draft")])
    assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: nil) }
    assert_equal 0, Question.count
    question = create_question(2, publication_status: "draft")
    before = QuestionPayload.from_record(question)
    assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION) }
    assert_equal before, QuestionPayload.from_record(question.reload)
    assert_equal 1, Question.count
    assert_equal 4, QuestionChoice.count
  end

  test "checks checksum counts duplicate numbers and four choices before importing" do
    base = document([attributes(1, publication_status: "draft")])
    invalid = []
    invalid << base.deep_dup.tap { |data| data["sha256"] = "0" * 64 }
    invalid << base.deep_dup.tap { |data| data["question_count"] = 2; sign(data) }
    invalid << base.deep_dup.tap { |data| data["question_count"] = 1.0; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"] << data["questions"].first.deep_dup; data["question_count"] = 2; data["choice_count"] = 8; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"].first["choices"].pop; data["choice_count"] = 3; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"].first["choices"][1]["is_correct"] = true; sign(data) }
    invalid.each do |data|
      File.write(@path, JSON.generate(data))
      assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION) }
      assert_equal 0, Question.count
      assert_equal 0, QuestionChoice.count
    end
  end

  test "publication validation and incomplete published sets roll back every imported row" do
    invalid_content = [attributes(1, publication_status: "draft"), attributes(2).merge("source_text" => "出典なし")]
    [invalid_content, [attributes(1)]].each do |questions|
      write_archive(questions)
      assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION) }
      assert_equal 0, Question.count
      assert_equal 0, QuestionChoice.count
    end
  end

  test "rejects unknown fields including nested attributes and unsupported versions" do
    base = document([attributes(1, publication_status: "draft")])
    invalid = []
    invalid << base.deep_dup.tap { |data| data["version"] = 2; sign(data) }
    invalid << base.deep_dup.tap { |data| data["version"] = 1.0; sign(data) }
    invalid << base.deep_dup.tap { |data| data["users"] = []; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"].first["id"] = 999; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"].first["choices"].first["user_id"] = 999; sign(data) }
    invalid << base.deep_dup.tap { |data| data["questions"].first["content_blocks"].first["access_token"] = "test-only"; sign(data) }
    invalid.each do |data|
      File.write(@path, JSON.generate(data))
      assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION) }
      assert_equal 0, Question.count
    end
  end

  test "requires explicit paths and rejects invalid json without including its contents in the error" do
    assert_raises(QuestionArchive::Error) { QuestionArchive.export!(path: nil) }
    File.write(@path, "not-json-private-value")
    error = assert_raises(QuestionArchive::Error) { QuestionArchive.import!(path: @path, confirmation: QuestionArchive::IMPORT_CONFIRMATION) }
    assert_not_includes error.message, "not-json-private-value"
  end

  private

  def attributes(number, publication_status: "published")
    {
      "exam_number" => 91, "question_number" => number,
      "major_category_code" => "teacher_education", "category_code" => "education_foundations",
      "publication_status" => publication_status,
      "content_blocks" => [{ "type" => "text", "text" => "確認用の問題#{number}" }],
      "explanation_blocks" => [{ "type" => "text", "text" => "確認用の解説" }],
      "source_text" => "確認用資料 | https://example.invalid/archive",
      "choices" => %w[ア イ ウ エ].map.with_index do |label, index|
        { "choice_label" => label, "display_order" => index + 1, "is_correct" => index.zero?,
          "content_blocks" => [{ "type" => "text", "text" => "確認用の選択肢#{label}" }] }
      end,
    }
  end

  def create_question(number, publication_status: "published")
    QuestionWriter.save!(Question.new, attributes(number, publication_status: publication_status))
  end

  def document(questions)
    payload = { "format" => QuestionArchive::FORMAT, "version" => QuestionArchive::VERSION,
      "question_count" => questions.size, "choice_count" => questions.sum { |question| question.fetch("choices").size }, "questions" => questions }
    sign(payload)
  end

  def sign(payload)
    payload["sha256"] = QuestionPayload.digest(payload.except("sha256"))
    payload
  end

  def write_archive(questions)
    File.write(@path, JSON.generate(document(questions)))
  end
end

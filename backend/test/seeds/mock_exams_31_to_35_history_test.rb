require "test_helper"

class MockExams31To35HistoryTest < ActionDispatch::IntegrationTest
  EXAMS = (31..35).to_a.freeze
  NUMBERS = [1, 2].freeze
  LABELS = %w[ア イ ウ エ].freeze
  ANSWERS = { 31 => %w[イ エ], 32 => %w[ウ ア], 33 => %w[エ イ], 34 => %w[ア ウ], 35 => %w[ウ エ] }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_31_to_35_approved_history_drafts.json"))).freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    # Keep the original ten-question approval snapshot independent of later
    # additions. Legal questions 31-3..5 have their own approval/source tests.
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認十問の本文四択正答全解説出典分類をseedから独立した草案snapshotと照合する" do
    assert_equal 10, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    # This digest identifies the independent approved document at capture time.
    # Later verification notes must not rebase this fixture from current seeds.
    assert_equal "632142afc20e61c70076af16bbcdb35ab789f044d2708abacc3a1590f72445f3", APPROVED.fetch("sha256")
    assert_equal "document/模試31〜35_問1〜2草案_2026-10-14.md", APPROVED.fetch("source_path")

    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      draft = APPROVED.fetch("sections").fetch(id)
      answer_line = draft.match(/^正答：([アイウエ])$/)
      assert answer_line, id
      head = draft[0...answer_line.begin(0)]
      tail = draft[answer_line.end(0)..]
      choice_start = head.index(/^[アイウエ]　/)
      assert choice_start, id

      expected_body = head[0...choice_start].strip.split(/\n{2,}/)
      assert_equal expected_body, question.fetch(:content_blocks).map { |block| block.fetch(:text) }, id
      assert question[:content_blocks].all? { |block| block[:type] == "text" }, id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert_equal "education_foundations", question.fetch(:category_code), id
      assert_equal "draft", entry.fetch(:publication_status), id
      assert_equal LABELS, question.fetch(:choices).map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question[:choices].count { |choice| choice.fetch(:correct) }, id
      assert_equal answer_line[1], answer(question).fetch(:label), id

      expected_choices = head[choice_start..].scan(/^([アイウエ])　([^\n]+)/)
      assert_equal expected_choices, question[:choices].map { |choice| [choice[:label], choice[:content_blocks].first.fetch(:text)] }, id
      assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "text" }, id

      explanation, source_tail = tail.split(/^#### 出典$/, 2)
      expected_explanation = explanation.sub(/^#### 解説\n/, "").strip.split(/\n{2,}/).flat_map do |paragraph|
        paragraph.start_with?("- ") ? paragraph.lines.map { |line| line.sub(/\A- /, "").strip } : paragraph
      end
      assert_equal expected_explanation, question.fetch(:explanation_blocks).map { |block| block.fetch(:text) }, id
      assert question[:explanation_blocks].all? { |block| block[:type] == "text" }, id
      LABELS.each { |label| assert expected_explanation.any? { |text| text.start_with?("#{label}：") }, id }

      source_paragraph = source_tail.strip.split(/\n{2,}/).first
      expected_sources = source_paragraph.scan(/^- \[(.+)\]\((https:\/\/\S+)\)$/).map { |title, url| "#{title} | #{url}" }.join("\n")
      assert_not_empty expected_sources, id
      assert_equal expected_sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id

      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
      assert_equal "draft", preview.publication_status, id
    end
  end

  test "模試34問1の①から④は出来事の列挙と順序選択として保持する" do
    question = @questions.fetch("34-1")
    assert_equal 5, question.fetch(:content_blocks).size
    statements = question[:content_blocks].drop(1).map { |block| block.fetch(:text) }
    assert_equal %w[① ② ③ ④], statements.map { |text| text[/\A([①②③④])　/, 1] }
    assert_no_match(/\{\{|【[①②③④]】|昭和\d+年|1[89]\d{2}年/, statements.join("\n"))
    question.fetch(:choices).each do |choice|
      assert_equal %w[① ② ③ ④], choice[:content_blocks].first[:text].scan(/[①②③④]/).sort
    end
    assert_equal "② → ① → ④ → ③", answer(question)[:content_blocks].first[:text]
    assert_equal 5, question.fetch(:explanation_blocks).size
    assert_includes question[:explanation_blocks].first[:text], "1945（昭和20）年"
    assert_includes question[:explanation_blocks].first[:text], "1969（昭和44）年度"
    assert_not question[:content_blocks].any? { |block| %w[fill_in_text fill_in_quote quote].include?(block[:type]) }
  end

  test "暫定正答順と肯定七問否定二問年代整序一問の配分を維持する" do
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
    end
    assert_equal %w[33-1 33-2], @questions.select { |_id, question| question[:content_blocks].first[:text].include?("適切でないもの") }.keys
    assert_equal ["34-1"], @questions.select { |_id, question| question[:content_blocks].first[:text].include?("起こった時期が早いもの") }.keys
    assert_equal 7, @questions.count { |_id, question| question[:content_blocks].first[:text].include?("最も適切なもの") }
    assert_equal({ "ア" => 2, "イ" => 2, "ウ" => 3, "エ" => 3 }, @questions.values.map { |question| answer(question)[:label] }.tally)
  end

  test "既出六十問との題材重複は許容し本文四択の完全同一だけを機械的に拒否する" do
    previous = QuestionSeedSync.collect { (1..30).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    assert_equal 60, previous.size
    old_fingerprints = previous.map { |entry| fingerprint(entry) }
    new_fingerprints = @entries.map { |entry| fingerprint(entry) }
    assert_equal 10, new_fingerprints.uniq.size
    assert_empty old_fingerprints & new_fingerprints
    # Similar people, institutions and descriptions are intentionally accepted
    # for exam 31 onward. Substantive differences are documented for human
    # review; no similarity percentage is treated as a correctness criterion.
  end

  test "十問だけを下書き保存し一般APIと回答APIには出さず再実行してIDを保持する" do
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    scope = Question.where(exam_number: EXAMS)
    assert_equal 10, scope.count
    assert_equal 10, scope.where(publication_status: "draft").count
    assert_equal 0, scope.published.count
    ids = scope.order(:exam_number, :question_number).pluck(:id)
    choices = QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
    assert_equal 40, choices.size
    assert_equal 10, QuestionChoice.where(question_id: ids, is_correct: true).count
    EXAMS.each { |exam| assert_equal NUMBERS, scope.where(exam_number: exam).order(:question_number).pluck(:question_number), exam }

    get "/api/v1/exams"
    assert_response :success
    assert_empty response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam.fetch("exam_number")) }
    scope.each do |question|
      get "/api/v1/questions/#{question.id}"
      assert_response :not_found
      assert_not response.parsed_body.key?("data")
      post "/api/v1/questions/#{question.id}/answer", params: { selected_choice_id: question.question_choices.first.id }
      assert_response :not_found
      assert_not response.parsed_body.key?("data")
    end
    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
      QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    end
    assert_equal ids, scope.order(:exam_number, :question_number).pluck(:id)
    assert_equal choices, QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(question)
    question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def fingerprint(entry)
    question = entry.fetch(:attributes)
    [question[:content_blocks], question[:choices].map { |choice| choice[:content_blocks] }].to_json.gsub(/[[:space:]　]+/, "")
  end
end

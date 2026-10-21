require "test_helper"

class MockExams26To30HistoryTest < ActiveSupport::TestCase
  EXAMS = (26..30).to_a.freeze
  NUMBERS = [1, 2].freeze
  LABELS = %w[ア イ ウ エ].freeze
  ENUMERATION_KEYS = %w[27-1 27-2 30-1].freeze
  ANSWERS = { 26 => %w[ウ エ], 27 => %w[イ ウ], 28 => %w[ア イ], 29 => %w[エ ア], 30 => %w[エ ウ] }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_history_drafts.json"))).freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認十問の本文列挙四択正答全解説出典分類を独立草案snapshotと照合する" do
    assert_equal 10, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    assert_equal "e1c917138e21196d3eea83ae97e73c3fcd28c533153ded5fe82139898d0c95aa", APPROVED.fetch("sha256")
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      draft = APPROVED.fetch("sections").fetch(id)
      head, tail = draft.split(/^正答：[アイウエ].*$/, 2)
      choice_start = head.index(/^\| 選択肢 \|/) || head.index(/^[アイウエ]　/)
      assert choice_start, id
      assert_equal normalize(head[0...choice_start]), normalize(question[:content_blocks].map { |block| block.fetch(:text) }.join("\n")), id
      assert question[:content_blocks].all? { |block| block[:type] == "text" }, id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert_equal "education_foundations", question.fetch(:category_code), id
      assert_equal LABELS, question[:choices].map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question[:choices].count { |choice| choice.fetch(:correct) }, id
      assert_equal draft[/^正答：([アイウエ])/, 1], answer(question).fetch(:label), id
      if id == "27-2"
        rows = head[choice_start..].lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], *choice[:content_blocks].first.fetch(:rows).first] }, id
        question[:choices].each do |choice|
          assert_equal 1, choice[:content_blocks].size, id
          assert_equal "table", choice[:content_blocks].first[:type], id
          assert_equal %w[① ② ③ ④], choice[:content_blocks].first[:headers], id
          assert_equal 1, choice[:content_blocks].first[:rows].size, id
          assert_equal 4, choice[:content_blocks].first[:rows].first.size, id
        end
        rows.map { |row| row.drop(1) }.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, id }
      else
        rows = head[choice_start..].scan(/^([アイウエ])　([^\n]+)/).map { |label, text| [label, normalize(text)] }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first.fetch(:text))] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "text" }, id
      end
      explanation, source_tail = tail.split(/^出典：/, 2)
      expected_explanation = explanation.strip.sub(/\A解説：/, "").gsub(/^- /, "")
      assert_equal normalize(expected_explanation), normalize(question[:explanation_blocks].map { |block| block.fetch(:text) }.join("\n")), id
      expected_sources = source_tail.split(/^確認記録：/, 2).first.lines.grep(/^- /).map { |line| line.sub(/^- /, "").strip }.join("\n")
      if id == "29-2"
        # Keep the approved snapshot and its original digest unchanged. The
        # publication review independently checked Mizuta's PDF pages 7–8
        # (printed pages 81–82), which explicitly support the character-
        # formation institute and worker children's education. Supplement
        # only the citation locator; question, options and explanations stay
        # exactly as approved.
        old_locator = "76〜78頁 | https://www.tuins.ac.jp/"
        assert_includes expected_sources, old_locator
        expected_sources = expected_sources.sub(old_locator, "76〜78・81〜82頁 | https://www.tuins.ac.jp/")
      end
      assert_equal expected_sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      LABELS.each { |label| assert_match(/#{label}：/, expected_explanation, id) }
      assert question[:explanation_blocks].all? { |block| block[:type] == "text" }, id
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
  end

  test "年代整序と人物組合せの①から④は原文列挙として保持し穴埋めに変換しない" do
    ENUMERATION_KEYS.each do |id|
      question = @questions.fetch(id)
      body = question[:content_blocks].map { |block| block.fetch(:text) }.join("\n")
      assert_equal %w[① ② ③ ④], body.lines.filter_map { |line| line[/\A([①②③④])　/, 1] }, id
      assert_no_match(/\{\{|【[①②③④]】/, body, id)
      assert_not question[:content_blocks].any? { |block| %w[fill_in_text fill_in_quote quote].include?(block[:type]) }, id
      assert_not question[:choices].any? { |choice| choice[:content_blocks].any? { |block| block[:type] == "fill_in_choice" } }, id
    end
    %w[27-1 30-1].each do |id|
      question = @questions.fetch(id)
      statements = question[:content_blocks].map { |block| block[:text] }.join("\n").lines.grep(/^[①②③④]　/).join
      assert_no_match(/明治\d+年|大正\d+年|昭和\d+年|平成\d+年|1[89]\d{2}年/, statements, id)
      question[:choices].each do |choice|
        assert_equal %w[① ② ③ ④], choice[:content_blocks].first[:text].scan(/[①②③④]/).sort, id
      end
    end
    assert_equal %w[エレン・ケイ モンテッソーリ フレイレ スペンサー], answer(@questions.fetch("27-2"))[:content_blocks].first[:rows].first
    assert_equal "④ → ③ → ① → ②", answer(@questions.fetch("27-1"))[:content_blocks].first[:text]
    assert_equal "① → ④ → ② → ③", answer(@questions.fetch("30-1"))[:content_blocks].first[:text]
  end

  test "承認正答順と肯定否定年代整序人物組合せの配分を維持する" do
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
    end
    assert_equal ["29-1"], @questions.select { |_id, question| question[:content_blocks].first[:text].include?("適切でないもの") }.keys
    assert_equal %w[27-1 30-1], @questions.select { |_id, question| question[:content_blocks].first[:text].include?("起こった時期が早いもの") }.keys
    assert_equal ["27-2"], @questions.select { |_id, question| question[:choices].first[:content_blocks].first[:type] == "table" }.keys
  end

  test "既存五十問と承認十問の本文選択肢に完全重複がない" do
    previous = QuestionSeedSync.collect { (1..25).each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
      .select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    assert_equal 50, previous.size
    fingerprints = (previous + @entries).map do |entry|
      question = entry.fetch(:attributes)
      normalize([question[:content_blocks], question[:choices].map { |choice| choice[:content_blocks] }].to_json)
    end
    assert_equal 60, fingerprints.uniq.size
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(question)
    question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def normalize(text)
    text.to_s.gsub(/[[:space:]　]+/, "")
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end
end

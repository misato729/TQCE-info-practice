require "test_helper"

class MockExamsQuestion11RevisionTest < ActionDispatch::IntegrationTest
  ANSWERS = { 2 => "イ", 4 => "エ", 5 => "ア", 11 => "イ", 12 => "エ" }.freeze
  BLANKS = %w[① ② ③].freeze
  OFFICIAL = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_question_11_official_pages.json"))).freeze
  THREE_TYPES = JSON.parse(File.read(Rails.root.join("test/fixtures/self_contained_official_excerpts.json"))).fetch("excerpts").fetch("5-11").freeze

  setup do
    @entries = QuestionSeedSync.collect do
      ANSWERS.each_key { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end.select { |entry| entry.fetch(:attributes).fetch(:question_number) == 11 }
    @questions = @entries.to_h { |entry| [entry.fetch(:exam_number), entry.fetch(:attributes)] }
  end

  test "五問の四択一正答と正答位置を保ち各列の語句を二対二にする" do
    assert_equal ANSWERS.keys, @questions.keys
    @questions.each do |exam, question|
      choices = question.fetch(:choices)
      assert_equal %w[ア イ ウ エ], choices.map { |choice| choice.fetch(:label) }, exam
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, exam
      assert_equal ANSWERS.fetch(exam), answer(exam).fetch(:label), exam
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, exam
      labels = quote(exam).scan(/\{\{([①②③])\}\}/).flatten.uniq
      assert_equal BLANKS.first([2, 5].include?(exam) ? 2 : 3), labels, exam
      assert_equal [labels.first, labels.last], question[:content_blocks].first[:text].scan(/\{\{([①②③])\}\}/).flatten, exam
      choices.each { |choice| assert_equal labels.size, cells(choice).size, exam }
      labels.size.times do |column|
        assert_equal [2, 2], choices.map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{exam}-11 列#{column + 1}"
      end
      cells(answer(exam)).each { |term| assert_not_includes quote(exam), term, exam }
    end
  end

  test "四原文穴埋めは正答だけが独立した公式原典の連続範囲に一致する" do
    [2, 5, 11, 12].each do |exam|
      original = exam == 5 ? normalized(THREE_TYPES) : official_excerpt(exam)
      assert_includes @questions.fetch(exam)[:content_blocks].first[:text], "からの抜粋である。", exam
      @questions.fetch(exam)[:choices].each do |choice|
        restored = quote(exam).gsub(/\{\{([①②③])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
        assert_equal choice.fetch(:correct), normalized(restored) == original, "#{exam}-11 #{choice[:label]}"
      end
    end
  end

  test "編集記述の時間軸と二つの層の対応は公式原典から判定できる" do
    original = normalized(official_page(21)).gsub(/（→[^）]+）/, "")
    assert_includes @questions.fetch(4)[:content_blocks].first[:text], "示された内容に基づく記述"
    assert_not_includes @questions.fetch(4)[:content_blocks].first[:text], "からの抜粋である。"
    @questions.fetch(4)[:choices].each do |choice|
      first, second, axis = cells(choice)
      statement = "日常の生徒指導を基盤とする#{first}と組織的・計画的な#{second}は、積極的な先手型の常態的・先行的（#{axis}）生徒指導"
      assert_equal choice.fetch(:correct), original.include?(normalized(statement)), choice[:label]
    end
  end

  test "模試二は説明を伴う二視点を問い模試五は分類名を残して対象を比較する" do
    assert_operator quote(2).length, :>=, 400
    assert_includes quote(2), "相手の立場に立って考え"
    assert_includes quote(2), "自ら考え、選択し、決定する"
    BLANKS.first(2).each { |label| assert_equal 2, quote(2).scan("{{#{label}}}").size }
    assert_includes @questions.fetch(2)[:source_text], "#page=17"
    assert_includes quote(5), "② 課題予防的生徒指導"
    assert_includes quote(5), "全ての児童生徒を対象とした{{①}}"
    assert_includes quote(5), "一部の児童生徒を対象とした{{②}}"
  end

  test "各誤答の解説で指摘する空欄番号が選択肢の実際の誤りと一致する" do
    @questions.each do |exam, question|
      question[:choices].reject { |choice| choice[:correct] }.each do |choice|
        explanation = question[:explanation_blocks].find { |block| block[:text].start_with?("#{choice[:label]}：") }
        assert explanation, "#{exam}-11 #{choice[:label]}"
        first_sentence = explanation[:text].split("。", 2).first
        wrong_labels = cells(choice).each_index.filter_map { |column| BLANKS[column] if cells(choice)[column] != cells(answer(exam))[column] }
        assert_equal wrong_labels, first_sentence.scan(/[①②③]/), "#{exam}-11 #{choice[:label]}"
      end
    end
  end

  test "五問の取得と回答APIで二空欄と三空欄を扱い回答前に正答を公開しない" do
    @entries.each { |entry| QuestionSeedSync.call(**entry) }
    user = User.create!(name: "問十一検証", email: "question-11-revision@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    @questions.each do |exam, expected|
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 10 }, headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal [exam, 11], data.values_at("exam_number", "question_number")
      assert_equal expected[:content_blocks].as_json, data.fetch("content_blocks")
      assert_equal expected[:choices].map { |choice| choice[:content_blocks].as_json }, data.fetch("choices").map { |choice| choice.fetch("content_blocks") }
      assert_not data.key?("explanation_blocks")
      data.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }
      question = Question.find_by!(exam_number: exam, question_number: 11)
      correct = question.question_choices.find_by!(is_correct: true)
      post answer_api_v1_question_path(question), params: { selected_choice_id: correct.id }, headers: headers, as: :json
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
    end
  end

  private

  def answer(exam)
    @questions.fetch(exam).fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def quote(exam)
    @questions.fetch(exam).fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  end

  def normalized(text)
    text.gsub(/[[:space:]　]+/, "")
  end

  def official_page(number)
    OFFICIAL.fetch("pages").fetch(number.to_s)
      .sub(/\A第1 章 生徒指導の基礎 \d+\n/, "")
      .sub(/\n\[\*\d+\].*\z/m, "")
      .gsub(/\[\*\d+\]/, "")
  end

  def official_excerpt(exam)
    location = OFFICIAL.fetch("locations").fetch("#{exam}-11")
    text = normalized(location.fetch("pdf_pages").map { |page| official_page(page) }.join("\n"))
    start_at = text.index(normalized(location.fetch("start")))
    end_at = text.index(normalized(location.fetch("end")), start_at)
    text[start_at...end_at]
  end
end

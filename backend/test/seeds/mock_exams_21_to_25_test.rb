require "test_helper"

class MockExams21To25Test < ActionDispatch::IntegrationTest
  EXAM_NUMBERS = (21..25).to_a.freeze
  QUESTION_NUMBERS = (6..10).to_a.freeze
  ALL_QUESTION_NUMBERS = (1..15).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANK_LABELS = %w[① ② ③ ④].freeze
  EXPECTED_ANSWERS = {
    21 => %w[ウ ア エ イ ア],
    22 => %w[エ ウ ア ウ イ],
    23 => %w[イ エ ウ ア エ],
    24 => %w[ア イ イ ウ エ],
    25 => %w[ウ エ イ ア ウ],
  }.freeze
  QUESTION_7_CATEGORIES = {
    21 => "student_guidance_career", 22 => "special_support_education",
    23 => "special_support_education", 24 => "curriculum_organization",
    25 => "student_guidance_career",
  }.freeze
  CATEGORIES = {
    6 => "curriculum_organization", 8 => "integrated_inquiry",
    9 => "moral_education", 10 => "special_activities",
  }.freeze
  REPEATED_BLANKS = {
    "21-10" => { "④" => 2 },
    "22-7" => { "①" => 2 },
    "22-8" => { "②" => 2 },
    "23-6" => { "③" => 2 },
    "23-8" => { "①" => 3 },
    "23-9" => { "①" => 2 },
    "23-10" => { "②" => 2 },
    "24-8" => { "①" => 2 },
  }.freeze

  # Raw official PDF pages are independent of the seed's answers. Only the
  # recorded excerpt boundaries, page headers, whitespace and ruby are handled
  # below; no originals are reconstructed from correct choice cells.
  ORIGINAL_FIXTURE = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_curriculum_pages.json", __dir__))).freeze

  setup do
    load_partial_seeds
  end

  test "承認済み問6から問10の五セット二十五問を下書きとして保存する" do
    assert_equal 25, partial_questions.count
    assert_equal 25, partial_questions.where(publication_status: "draft").count
    assert_equal 0, partial_questions.published.count
    assert_equal 75, QuestionSeedState.where(exam_number: EXAM_NUMBERS).count

    EXAM_NUMBERS.each do |exam|
      questions = partial_questions.where(exam_number: exam).order(:question_number)
      assert_equal QUESTION_NUMBERS, questions.pluck(:question_number)
      assert_equal EXPECTED_ANSWERS.fetch(exam), questions.map { |question| correct_choice(question).choice_label }

      questions.each do |question|
        key = key_for(question)
        assert_equal "teacher_education", question.major_category_code, key
        category = question.question_number == 7 ? QUESTION_7_CATEGORIES.fetch(exam) : CATEGORIES.fetch(question.question_number)
        assert_equal category, question.category_code, key
        assert_equal "draft", question.publication_status, key
        assert_equal LABELS, question.question_choices.pluck(:choice_label), key
        assert_equal [1, 2, 3, 4], question.question_choices.pluck(:display_order), key
        assert_equal 4, question.question_choices.count, key
        assert_equal 1, question.question_choices.where(is_correct: true).count, key
        assert_equal 4, question.question_choices.map(&:content_blocks).uniq.size, key
        assert question.content_blocks.present?, key
        assert question.explanation_blocks.present?, key
        assert question.source_text.present?, key
        question.source_text.lines.each do |line|
          assert_match(/\A.+ \| https:\/\/www\.mext\.go\.jp\/\S+#page=\d+\z/, line.strip, key)
        end
      end
    end
  end

  test "全二十五問の本文と選択肢と解説は公開前検査にも適合する" do
    partial_questions.each do |question|
      choices = QuestionPayload.from_record(question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_publication!(question, choices)
      assert_equal "draft", question.reload.publication_status
      explanation = question.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
      question.question_choices.reject(&:is_correct?).each do |choice|
        assert_match(/#{choice.choice_label}(?:は|：|・)/, explanation, key_for(question))
      end
    end
  end

  test "通常の試験抜粋枠と四空欄を使用し模試22問7だけ三空欄にする" do
    partial_questions.each do |question|
      key = key_for(question)
      prompt = question.content_blocks.first
      expected_size = key == "22-7" ? 3 : 4
      assert_equal "fill_in_text", prompt.fetch("type"), key
      assert_match(/\A次の文章は，.+の「.+」からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[③④]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/, prompt.fetch("text"), key)
      assert_equal ["①", BLANK_LABELS.fetch(expected_size - 1)], blank_labels(prompt.fetch("text")), key
      quotes = question.content_blocks.select { |block| block["type"] == "fill_in_quote" }
      assert_equal 1, quotes.size, key
      assert_not question.content_blocks.any? { |block| block["type"] == "quote" }, key
      assert_equal BLANK_LABELS.first(expected_size), blank_labels(quote(question)), key
      assert_no_match(/【[①②③④]】/, quote(question), key)

      question.question_choices.each do |choice|
        assert_equal [{ "type" => "fill_in_choice", "cells" => cells(choice) }], choice.content_blocks, key
        assert_equal expected_size, cells(choice).size, key
      end
      expected_size.times do |column|
        counts = question.question_choices.map { |choice| cells(choice).fetch(column) }.tally.values.sort
        assert_equal [2, 2], counts, "#{key}の第#{column + 1}列の語句頻度"
      end
    end
  end

  test "再登場する正答語句も同じラベルで伏せ原文の列挙番号とは区別する" do
    partial_questions.each do |question|
      answer_cells = cells(correct_choice(question))
      answer_cells.each { |cell| assert_not_includes quote(question), cell, "#{key_for(question)}の正答語句露出" }
    end
    REPEATED_BLANKS.each do |key, counts|
      exam, number = key.split("-").map(&:to_i)
      question = partial_questions.find_by!(exam_number: exam, question_number: number)
      counts.each { |label, count| assert_equal count, quote(question).scan("{{#{label}}}").size, "#{key}の#{label}" }
    end

    inquiry = partial_questions.find_by!(exam_number: 21, question_number: 8)
    %w[① ② ③ ④].each do |label|
      assert_includes quote(inquiry).gsub(/\{\{[①②③④]\}\}/, ""), label
      assert_includes quote(inquiry), "{{#{label}}}"
    end
  end

  test "道徳教育の二段落を原文の位置で区切り空欄の説明は実際の枠表示に合わせる" do
    moral = partial_questions.find_by!(exam_number: 24, question_number: 9)
    assert_match(/\A学校における道徳教育は，/, quote(moral))
    assert_includes quote(moral), "適切な指導を行うこと。\n\n道徳教育は，"
    assert_equal 2, quote(moral).split("\n\n").size

    inquiry = partial_questions.find_by!(exam_number: 21, question_number: 8)
    explanation = inquiry.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
    assert_includes explanation, "枠で囲まれた番号が空欄である。"
    assert_no_match(/【[①②③④]】/, explanation)
    assert_no_match(/\{\{[①②③④]\}\}/, explanation)
  end

  test "問6と問7の章款を固定し問9の款名と問8及び問10の本体解説配分を維持する" do
    EXAM_NUMBERS.each do |exam|
      question_6 = partial_questions.find_by!(exam_number: exam, question_number: 6)
      assert_includes question_6.content_blocks.first.fetch("text"), "第1章 総則 第3款 教育課程の実施と学習評価"
      assert_includes question_6.source_text, "第1章第3款"
      question_7 = partial_questions.find_by!(exam_number: exam, question_number: 7)
      assert_includes question_7.content_blocks.first.fetch("text"), "第1章 総則 第5款 生徒の発達の支援"
      assert_includes question_7.source_text, "第1章第5款"

      (6..8).each do |number|
        prompt = partial_questions.find_by!(exam_number: exam, question_number: number).content_blocks.first.fetch("text")
        heading = prompt[/の「(.+)」からの抜粋である。/, 1]
        assert_not_nil heading
        assert_no_match(/\s(?:\([0-9]+\)|（[0-9]+）|[ア-ン])\z/, heading)
      end
      prompt_9 = partial_questions.find_by!(exam_number: exam, question_number: 9).content_blocks.first.fetch("text")
      expected_heading = [22, 24, 25].include?(exam) ? "第1款 高等学校教育の基本と教育課程の役割" : "第7款 道徳教育に関する配慮事項"
      assert_includes prompt_9, "第1章 総則 #{expected_heading}」からの抜粋である。"
    end

    { 8 => [22, 24], 10 => [22, 24] }.each do |number, main_exams|
      questions = partial_questions.where(question_number: number).order(:exam_number).to_a
      assert_equal main_exams, questions.reject { |question| question.content_blocks.first.fetch("text").include?("解説") }.map(&:exam_number)
      assert_equal 3, questions.count { |question| question.content_blocks.first.fetch("text").include?("解説") }
    end
  end

  test "正答の復元だけが独立して保持した公式PDFの連続範囲に一致する" do
    assert_equal partial_questions.map { |question| key_for(question) }.sort, ORIGINAL_FIXTURE.fetch("locations").keys.sort
    partial_questions.each do |question|
      key = key_for(question)
      original = official_excerpt(key)
      assert_operator original.length, :>=, 100, key
      question.question_choices.each do |choice|
        restored = restore(question, choice)
        assert_equal choice.is_correct?, normalized(restored) == original, "#{key} #{choice.choice_label}の原文一致"
      end
      location = ORIGINAL_FIXTURE.fetch("locations").fetch(key)
      url = ORIGINAL_FIXTURE.fetch("sources").fetch(location.fetch("source"))
      assert_includes question.source_text, "#{url}#page=#{location.fetch('pdf_pages').first}", key
    end
  end

  test "未提示の項番や図の参照を抜粋途中と末尾及び選択肢にも残さない" do
    partial_questions.each do |question|
      key = key_for(question)
      assert_no_match(/\A(?:その中で|その際|このような生徒の姿|このことは|具体的には)/, quote(question), key)
      choice_text = question.question_choices.flat_map { |choice| cells(choice) }.join("\n")
      assert_no_match(/第[１1２2]款の[２2３3]の|第[１1]の目標|内容の[（(][0-9０-９]+[）)]|〔指導項目〕|図[0-9０-９]+|図[１1]参照|次の図|→[0-9]+\.[0-9]+\./, quote(question) + choice_text, key)
    end
    assert_includes quote(partial_questions.find_by!(exam_number: 21, question_number: 10)), "ホームルーム活動の内容「（2）"
    assert_includes quote(partial_questions.find_by!(exam_number: 21, question_number: 10)), "内容「（3）"
    assert_includes quote(partial_questions.find_by!(exam_number: 23, question_number: 9)), "道徳教育の目標を踏まえ"
    assert_includes quote(partial_questions.find_by!(exam_number: 25, question_number: 6)), "情報活用能力の育成を図るため"
  end

  test "seed収集時にも必須空欄の欠落と選択肢セルの不一致を拒否する" do
    marker = "questions.each do |question|\n"
    EXAM_NUMBERS.each do |exam|
      seed_path = Rails.root.join("db/seeds/mock_exam_#{exam}.rb")
      source = File.read(seed_path)
      assert_includes source, marker
      QUESTION_NUMBERS.each do |number|
        mutations = [
          <<~RUBY,
            questions.find { |question| question.fetch(:question_number) == #{number} }.fetch(:content_blocks).each do |block|
              block[:text] = block.fetch(:text).gsub(/[{][{][①②③④][}][}]/, "語句") if block[:type] == "fill_in_quote"
            end
          RUBY
          <<~RUBY,
            questions.find { |question| question.fetch(:question_number) == #{number} }.fetch(:choices).first.fetch(:content_blocks).first.fetch(:cells).pop
          RUBY
        ]
        mutations.each do |mutation|
          assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
            assert_raises(RuntimeError, "#{exam}-#{number}の不正な穴埋めデータ") do
              QuestionSeedSync.collect { eval(source.sub(marker, mutation + marker), binding, seed_path.to_s) }
            end
          end
        end
      end
    end
  end

  test "既存二十セットと同じ抜粋及び空欄の組合せを繰り返さない" do
    entries = QuestionSeedSync.collect do
      (1..20).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    existing = entries.select { |entry| QUESTION_NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }.map do |entry|
      attributes = entry.fetch(:attributes)
      text = attributes.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }.map { |block| block.fetch(:text) }.join("\n")
      answer_cells = attributes.fetch(:choices).find { |choice| choice[:correct] }.fetch(:content_blocks).first[:cells]
      [normalized(text), answer_cells]
    end
    added = partial_questions.map { |question| [normalized(quote(question)), cells(correct_choice(question))] }
    assert_equal 25, added.uniq.size
    assert_empty existing & added
  end

  test "作成中セットは管理者でも一般向け一覧と問題取得と回答APIに出ない" do
    headers = admin_headers
    get api_v1_exams_path, headers: headers
    assert_response :success
    assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAM_NUMBERS

    EXAM_NUMBERS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }, headers: headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
    partial_questions.each do |question|
      get api_v1_question_path(question), headers: headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: correct_choice(question).id }, headers: headers, as: :json
      end
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
  end

  test "管理APIでは下書き二十五問の本文と四択と正答と解説と出典を確認できる" do
    headers = admin_headers
    EXAM_NUMBERS.each do |exam|
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "draft" }, headers: headers
      assert_response :success
      assert_equal 15, response.parsed_body.dig("meta", "total_count")
      assert_equal ALL_QUESTION_NUMBERS, response.parsed_body.fetch("data").map { |question| question.fetch("question_number") }
    end
    partial_questions.each do |question|
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal "draft", body.fetch("publication_status")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      assert_equal question.explanation_blocks, body.fetch("explanation_blocks")
      assert_equal question.source_text, body.fetch("source_text")
      assert_equal LABELS, body.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, body.fetch("choices").count { |choice| choice.fetch("is_correct") }
    end
  end

  test "公開後の取得形式も回答前に正答解説出典を返さず回答時にだけ開示する" do
    # Publishing here is isolated to the test transaction; actual seed entries
    # and their synchronization status stay draft.
    headers = admin_headers
    partial_questions.each do |question|
      question.update!(publication_status: "published")
      get api_v1_question_path(question), headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      assert_equal LABELS, body.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_no_public_answers(body)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: correct_choice(question).id }, headers: headers, as: :json
      end
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal correct_choice(question).choice_label, response.parsed_body.dig("data", "correct_choice", "choice_label")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "seedを二回再実行しても件数とIDと内容と同期状態及び既存問題の履歴を変えない" do
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    existing_questions = Question.where(exam_number: 1)
    existing = existing_questions.order(:question_number).first!
    user = User.create!(name: "seed保護検証", email: "mock-21-25-reseed@example.com", password: "password123", password_confirmation: "password123")
    user.answer_histories.create!(question: existing, selected_choice: correct_choice(existing), is_correct: true)
    user.favorites.create!(question: existing)
    added = partial_questions.find_by!(exam_number: 25, question_number: 10)
    user.answer_histories.create!(question: added, selected_choice: correct_choice(added), is_correct: true)

    before_added = persistence_snapshot(partial_questions)
    before_existing = persistence_snapshot(existing_questions)
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "Favorite.count", "QuestionSeedState.count"] do
        load_partial_seeds
      end
      assert_equal before_added, persistence_snapshot(partial_questions)
      assert_equal before_existing, persistence_snapshot(existing_questions)
    end
  end

  test "変更のない再実行は管理画面での訂正と非公開化と削除を維持する" do
    edited = partial_questions.find_by!(exam_number: 21, question_number: 6)
    payload = QuestionPayload.from_record(edited).merge("publication_status" => "draft")
    payload["explanation_blocks"] = [{ "type" => "text", "text" => "管理画面で補足した解説" }]
    QuestionWriter.save!(edited, payload)
    hidden = partial_questions.find_by!(exam_number: 22, question_number: 7)
    hidden.update!(publication_status: "private")
    removed = partial_questions.find_by!(exam_number: 23, question_number: 8)
    QuestionWriter.destroy!(removed)
    before = persistence_snapshot(partial_questions)

    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
        load_partial_seeds
      end
      assert_equal before, persistence_snapshot(partial_questions)
      assert_equal "管理画面で補足した解説", edited.reload.explanation_blocks.first.fetch("text")
      assert_equal "private", hidden.reload.publication_status
      assert_not Question.exists?(exam_number: 23, question_number: 8)
      assert QuestionSeedState.find_by!(exam_number: 23, question_number: 8).deleted?
    end
  end

  private

  def partial_questions
    Question.where(exam_number: EXAM_NUMBERS, question_number: QUESTION_NUMBERS)
  end

  def load_partial_seeds
    entries = QuestionSeedSync.collect do
      EXAM_NUMBERS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    assert_equal 75, entries.size
    assert entries.all? { |entry| entry.fetch(:publication_status) == "draft" }
    QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def key_for(question)
    "#{question.exam_number}-#{question.question_number}"
  end

  def quote(question)
    question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
  end

  def cells(choice)
    choice.content_blocks.first.fetch("cells")
  end

  def correct_choice(question)
    question.question_choices.find_by!(is_correct: true)
  end

  def blank_labels(text)
    text.scan(/\{\{([①②③④])\}\}/).flatten.uniq
  end

  def restore(question, choice)
    quote(question).gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANK_LABELS.index(Regexp.last_match(1))) }
  end

  def normalized(text)
    text.gsub(/[\s　\p{Cc}]/, "").gsub("涵かん養", "涵養").gsub("拓ひらく", "拓く")
  end

  def official_excerpt(key)
    location = ORIGINAL_FIXTURE.fetch("locations").fetch(key)
    pages = ORIGINAL_FIXTURE.fetch("pages").fetch(location.fetch("source"))
    text = location.fetch("pdf_pages").map do |page|
      # The printed running header is not part of a paragraph crossing pages.
      pages.fetch(page.to_s).sub(/\A\s*総則\s*\n[ \t]*\d+[ \t]*\n/, "")
    end.join("\n")
    original = normalized(text)
    start_text = normalized(location.fetch("start"))
    end_text = normalized(location.fetch("end"))
    start_at = original.index(start_text)
    assert_not_nil start_at, "#{key}の原典開始境界"
    end_at = original.index(end_text, start_at)
    assert_not_nil end_at, "#{key}の原典終了境界"
    original[start_at...(end_at + end_text.length)]
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "seed管理検証", email: "mock-21-25-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    end
  end

  def assert_no_public_answers(value)
    case value
    when Hash
      %w[correct_choice is_correct explanation_blocks source_text].each { |key| assert_not value.key?(key) }
      value.each_value { |item| assert_no_public_answers(item) }
    when Array
      value.each { |item| assert_no_public_answers(item) }
    end
  end

  def persistence_snapshot(scope)
    question_ids = scope.order(:id).pluck(:id)
    exam_numbers = scope.distinct.pluck(:exam_number)
    {
      questions: scope.order(:id).map(&:attributes),
      choices: QuestionChoice.where(question_id: question_ids).order(:id).map(&:attributes),
      seed_states: QuestionSeedState.where(exam_number: exam_numbers).order(:id).map(&:attributes),
      histories: AnswerHistory.where(question_id: question_ids).order(:id).map(&:attributes),
      favorites: Favorite.where(question_id: question_ids).order(:id).map(&:attributes),
    }
  end
end

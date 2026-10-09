require "test_helper"

class MockExams21To25GuidancePsychologyReportTest < ActionDispatch::IntegrationTest
  EXAMS = (21..25).to_a.freeze
  NUMBERS = (11..15).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③].freeze
  CATEGORIES = { 11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology", 15 => "education_system" }.freeze
  ANSWERS = { 21 => %w[ウ ウ イ エ ア], 22 => %w[エ ア エ ウ イ],
    23 => %w[ア エ ア イ エ], 24 => %w[イ イ ウ ア ウ], 25 => %w[エ ウ イ エ ア] }.freeze
  APPROVED = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_guidance_psychology_report_approved.json", __dir__))).freeze
  ORIGINALS = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_guidance_report_pages.json", __dir__))).freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @added = @entries.select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
  end

  test "承認済み二十五問の本文四択正答解説出典を独立した草案と照合する" do
    assert_equal 75, @entries.size
    assert_equal 25, @added.size
    expected = APPROVED.fetch("questions").to_h { |question| ["#{question['exam']}-#{question.dig('attributes', 'question_number')}", question.fetch("attributes")] }
    @added.each do |entry|
      key = key_for(entry)
      attributes = entry.fetch(:attributes)
      assert_equal expected.fetch(key), attributes.deep_stringify_keys, key
      assert_equal "draft", entry.fetch(:publication_status), key
      assert_equal "teacher_education", attributes.fetch(:major_category_code), key
      assert_equal CATEGORIES.fetch(attributes[:question_number]), attributes.fetch(:category_code), key
      assert_equal LABELS, attributes.fetch(:choices).map { |choice| choice[:label] }, key
      assert_equal 1, attributes[:choices].count { |choice| choice[:correct] }, key
      assert_equal 4, attributes[:choices].map { |choice| choice[:content_blocks] }.uniq.size, key
      explanation_labels = attributes[:explanation_blocks].filter_map { |block| block[:text][/\A([アイウエ])：/, 1] }
      assert_equal LABELS, explanation_labels.sort_by { |label| LABELS.index(label) }, key
      attributes[:source_text].lines.each { |line| assert_match(/\A.+ \| https:\/\/\S+\z/, line.strip, key) }
      assert_not attributes[:content_blocks].any? { |block| block[:type] == "quote" }, key
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], attributes).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_publication!(preview, choices)
    end
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal (1..15).to_a, entries.map { |entry| entry[:attributes][:question_number] }
      assert_equal ANSWERS.fetch(exam), entries.last(5).map { |entry| correct_choice(entry)[:label] }
      assert entries.map { |entry| correct_choice(entry)[:label] }.tally.values.all? { |count| count <= 5 }
    end
  end

  test "既存の問一から問十の五十問を一切変更しない" do
    existing = @entries.reject { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }
    actual = existing.to_h do |entry|
      [key_for(entry), QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes]))]
    end
    assert_equal APPROVED.fetch("existing_1_to_10_digests"), actual
  end

  test "四問の生徒指導抜粋と一問の答申抜粋は正答だけが公式PDFの連続範囲に一致する" do
    %w[21-11 22-11 23-11 25-11 24-15].each do |key|
      entry = entry_for(key)
      original = official_excerpt(key)
      assert_operator original.length, :>=, 180, key
      entry[:attributes][:choices].each do |choice|
        restored = quote(entry).gsub(/\{\{([①②③])\}\}/) { choice[:content_blocks].first[:cells].fetch(BLANKS.index(Regexp.last_match(1))) }
        assert_equal choice[:correct], normalized(restored) == original, "#{key} #{choice[:label]}"
      end
    end
    assert_equal normalized(quote(entry_for("24-11"))), official_excerpt("24-11")
    ORIGINALS.fetch("locations").each do |key, location|
      source = ORIGINALS.fetch("sources").fetch(location.fetch("source"))
      assert_includes entry_for(key)[:attributes][:source_text], "#{source}#page=#{location['pdf_pages'].first}", key
    end
  end

  test "問十一の四原文穴埋めと一編集表及び問十五の四正誤一穴埋めを維持する" do
    guidance = @added.select { |entry| entry[:attributes][:question_number] == 11 }
    assert_equal 4, guidance.count { |entry| quote(entry).include?("{{①}}") }
    assert_equal [24], guidance.select { |entry| entry[:attributes][:content_blocks].any? { |block| block[:type] == "table" } }.map { |entry| entry[:exam_number] }
    guidance.each do |entry|
      key = key_for(entry)
      assert_includes prompt(entry), "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。", key
      assert_operator quote(entry).length, :>=, 180, key
      count = correct_choice(entry)[:content_blocks].first[:cells].size
      assert_includes [2, 3], count, key
      if entry[:exam_number] != 24
        assert_equal BLANKS.first(count), quote(entry).scan(/\{\{([①②③])\}\}/).flatten.uniq, key
        assert_equal [BLANKS.first, BLANKS[count - 1]], prompt(entry).scan(/\{\{([①②③])\}\}/).flatten.uniq, key
      end
      assert entry[:attributes][:choices].all? { |choice| choice[:content_blocks].first[:cells].size == count }, key
      count.times do |column|
        assert_equal [2, 2], entry[:attributes][:choices].map { |choice| choice[:content_blocks].first[:cells][column] }.tally.values.sort, key
      end
      correct_choice(entry)[:content_blocks].first[:cells].each { |cell| assert_not_includes quote(entry), cell, key }
    end
    reports = @added.select { |entry| entry[:attributes][:question_number] == 15 }
    assert_equal [24], reports.select { |entry| entry[:attributes][:content_blocks].first[:type] == "fill_in_text" }.map { |entry| entry[:exam_number] }
    assert_equal 4, reports.count { |entry| entry[:attributes][:content_blocks].first[:type] == "text" }
    reports.each do |entry|
      assert_includes prompt(entry), "（答申）」 （令和3年1月26日中央教育審議会）"
    end
  end

  test "模試二十四の抜粋本文と編集表を区別し表内の三空欄と原典の方法の対応を保つ" do
    entry = entry_for("24-11")
    blocks = entry[:attributes][:content_blocks]
    assert_equal %w[fill_in_text fill_in_quote text text table], blocks.map { |block| block[:type] }
    table = blocks.last
    assert_equal %w[区分 方法 説明], table[:headers]
    assert_equal %w[早期発見 早期発見 早期対応], table[:rows].map(&:first)
    assert_equal %w[【①】 【②】 【③】], table[:rows].map { |row| row[1] }
    assert_not_includes table[:rows].flatten.join, "{{"
    assert_equal BLANKS, prompt(entry).scan(/\{\{([①②③])\}\}/).flatten.uniq
    assert_includes blocks[2][:text], "SCはスクールカウンセラー"
    assert_includes blocks[3][:text], "原典に掲載された表そのものではない"
    assert_equal %w[質問紙調査 作品の活用 個別の支援計画], correct_choice(entry)[:content_blocks].first[:cells]
    page_83 = normalized(ORIGINALS.dig("pages", "guidance", "86"))
    page_84 = normalized(ORIGINALS.dig("pages", "guidance", "87"))
    assert_includes page_83, normalized("「質問紙調査」は、観察や面接などで見落とした児童生徒のSOSを把握するために有効な方法")
    assert_includes page_83, normalized("児童生徒の日記、作文、絵などは、そのときの心理状態、自尊感情の有り様、発達の課題")
    assert_includes page_84, normalized("アセスメントに基づくプランニングを行い、具体的な支援策を明示するために作成されるものです。")
    assert_includes entry[:attributes][:explanation_blocks].last[:text], "個別の教育支援計画"
  end

  test "問十二は発達障害二問その他三問で問十三は青年期四問その他一問とする" do
    assert_includes prompt(entry_for("22-12")), "学習障害（LD）"
    assert_includes prompt(entry_for("24-12")), "注意欠如・多動性障害（ADHD）"
    assert_includes prompt(entry_for("21-12")), "知的障害"
    assert_includes prompt(entry_for("23-12")), "聴覚障害"
    assert_includes prompt(entry_for("25-12")), "肢体不自由"
    (21..24).each { |exam| assert_includes prompt(entry_for("#{exam}-13")), "青年" if exam != 24 }
    assert_includes prompt(entry_for("24-13")), "フロイトとエリクソン"
    assert_includes prompt(entry_for("25-13")), "ピアジェの道徳判断"
    assert_not_includes prompt(entry_for("25-13")), "青年期"
    [12, 13, 14].each do |number|
      questions = @added.select { |entry| entry[:attributes][:question_number] == number }
      assert_equal [24], questions.select { |entry| prompt(entry).include?("適切でないもの") }.map { |entry| entry[:exam_number] }
      assert questions.all? { |entry| entry[:attributes][:content_blocks].map { |block| block[:type] } == ["text"] }
    end
    %w[強化スケジュール ワーキングメモリ 学習目標 学習方法 診断的評価].each_with_index do |topic, index|
      assert_includes prompt(entry_for("#{21 + index}-14")), topic
    end
  end

  test "本文と表の必須空欄欠落及び選択肢セル不足をseed収集時に拒否する" do
    %w[21-11 22-11 23-11 24-11 25-11 24-15].each do |key|
      exam, number = key.split("-").map(&:to_i)
      path = Rails.root.join("db/seeds/mock_exam_#{exam}.rb")
      source = File.read(path)
      mutations = [
        "questions.find { |question| question[:question_number] == #{number} }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③][}][}]/, '語句') if block[:type] == 'fill_in_quote'; block[:rows] = block[:rows].map { |row| row.map { |cell| cell.gsub(/【[①②③]】/, '語句') } } if block[:type] == 'table' }\n",
        "questions.find { |question| question[:question_number] == #{number} }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError, key) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "二十五問は管理APIで全内容を取得でき一般APIと回答APIには公開されない" do
    save_entries
    assert_equal 75, Question.where(exam_number: EXAMS, publication_status: "draft").count
    headers = admin_headers
    get api_v1_exams_path, headers: headers
    assert_response :success
    assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
    EXAMS.each do |exam|
      get "/api/v1/admin/questions", params: { exam_number: exam }, headers: headers
      assert_response :success
      assert_equal 15, response.parsed_body.dig("meta", "total_count")
      assert_equal (1..15).to_a, response.parsed_body.fetch("data").map { |question| question.fetch("question_number") }
    end
    @added.each do |entry|
      question = record_for(entry)
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal "draft", data.fetch("publication_status")
      assert_equal question.content_blocks, data.fetch("content_blocks")
      assert_equal question.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal question.source_text, data.fetch("source_text")
      assert_equal LABELS, data.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
      get api_v1_question_path(question), headers: headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      end
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
  end

  test "公開をテスト内に限定し回答前の秘匿と回答後の全解説を検査する" do
    save_entries
    @added.each do |entry|
      question = record_for(entry)
      question.update!(publication_status: "published")
      get api_v1_question_path(question), headers: admin_headers
      assert_response :success
      assert_equal question.content_blocks, response.parsed_body.dig("data", "content_blocks")
      assert_no_public_answers(response.parsed_body)
      answer = question.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: answer.id }, headers: admin_headers, as: :json
      end
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal answer.choice_label, response.parsed_body.dig("data", "correct_choice", "choice_label")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "二回の再実行で既存問題と追加問題のID内容履歴お気に入りを維持する" do
    save_entries
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    user = User.create!(name: "追加問題検証", email: "guidance-21-25-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 11], [21, 1], [24, 11], [24, 15]].each do |exam, number|
      question = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: question)
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
      assert_equal before, snapshot
    end
  end

  private

  def key_for(entry)
    "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  end

  def entry_for(key)
    @added.find { |entry| key_for(entry) == key } || raise(KeyError, key)
  end

  def prompt(entry)
    entry[:attributes][:content_blocks].first[:text]
  end

  def quote(entry)
    entry[:attributes][:content_blocks].find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  end

  def correct_choice(entry)
    entry[:attributes][:choices].find { |choice| choice[:correct] }
  end

  def normalized(text)
    text.gsub(/[\s　\p{Cc}]/, "")
  end

  def official_excerpt(key)
    location = ORIGINALS.fetch("locations").fetch(key)
    pages = ORIGINALS.fetch("pages").fetch(location.fetch("source"))
    text = location.fetch("pdf_pages").map do |page|
      body = pages.fetch(page.to_s).sub(/\A第\d+ 章[^\n]*\n/, "")
      footer = location.fetch("exclude_footnotes_from", {})[page.to_s]
      body = body.split(footer).first if footer
      body
    end.join("\n")
    location.fetch("omitted_reference_marks", []).each { |mark| text = text.gsub(mark, "") }
    text = normalized(text)
    first = text.index(normalized(location.fetch("start")))
    assert_not_nil first, "#{key} 原典の開始境界"
    last = text.index(normalized(location.fetch("end")), first)
    assert_not_nil last, "#{key} 原典の終了境界"
    text[first...(last + normalized(location.fetch("end")).length)]
  end

  def save_entries
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def record_for(entry)
    Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
  end

  def admin_headers
    @admin_headers ||= begin
      user = User.create!(name: "追加問題管理検証", email: "guidance-21-25-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
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

  def snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h do |model|
      [model.name, model.order(:id).map(&:attributes)]
    end
  end
end

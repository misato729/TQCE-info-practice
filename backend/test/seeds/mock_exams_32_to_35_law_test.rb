require "test_helper"
require_relative "../support/history_revision_20261017"
require "digest"

class MockExams32To35LawTest < ActionDispatch::IntegrationTest
  EXAMS = (32..35).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  SCHOOL_PROMPT = "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  TEACHER_PROMPT = "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  EXPECTED_ANSWERS = { 32 => %w[イ エ ア], 33 => %w[エ エ イ], 34 => %w[エ ウ エ], 35 => %w[イ ア エ] }.freeze

  setup do
    @all = QuestionSeedSync.collect { (1..35).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
    @entries = @all.select { |entry| (31..35).cover?(entry[:exam_number]) }
    @added = @entries.select { |entry| EXAMS.include?(entry[:exam_number]) && (3..5).cover?(entry[:attributes][:question_number]) }
    @data = @added.to_h { |entry| [key(entry), entry[:attributes]] }
    @candidates = (3..5).map { |number| JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_32_to_35_law_q#{number}_candidates.json"))) }
  end

  test "承認省略の一回限りの依頼に基づく十二問を作問正本と照合し全セットを完成させる" do
    assert_equal 700, @all.size
    assert_equal 100, @entries.size
    assert_equal 12, @added.size
    assert_equal @data.keys.sort, @candidates.flat_map { |snapshot| snapshot.fetch("questions").keys }.sort
    @candidates.each do |snapshot|
      snapshot.fetch("questions").each { |id, question| assert_equal question.deep_symbolize_keys, @data.fetch(id), id }
      assert snapshot.fetch("originals").present?
      assert snapshot.fetch("notes").present?
    end
    (31..35).each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ["published"], entries.map { |entry| entry[:publication_status] }.uniq, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry[:attributes])[:label] }.tally, exam
    end
    @added.each do |entry|
      id, question = key(entry), entry[:attributes]
      assert_equal "teacher_education", question[:major_category_code], id
      assert_equal "education_system", question[:category_code], id
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id
      assert_equal 4, question[:choices].map { |choice| choice[:content_blocks] }.uniq.size, id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      assert_includes question[:source_text], "laws.e-gov.go.jp", id
      explanation = question[:explanation_blocks].map { |block| block[:text] }.join
      LABELS.each { |label| assert_match(/#{label}(?:：|は|を選ぶ)/, explanation, "#{id} #{label}") }
      payload = QuestionPayload.from_seed(entry[:exam_number], question)
      preview = QuestionSeedSync.preview(entry)
      QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:symbolize_keys))
      QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
    end
    EXAMS.each do |exam|
      actual = (3..5).map { |number| correct(@data.fetch("#{exam}-#{number}"))[:label] }
      assert_equal EXPECTED_ANSWERS.fetch(exam), actual, exam
    end
  end

  test "十問の原文穴埋めは独立原典の連続抜粋に正答だけが一致し各列二対二を維持する" do
    originals = @candidates.reduce({}) do |all, snapshot|
      all.merge(snapshot["original_fragments"] || snapshot.fetch("originals").fetch("original_fragments"))
    end
    assert_equal 10, originals.size
    originals.each do |id, raw|
      question = @data.fetch(id)
      quotes = question[:content_blocks].select { |block| block[:type] == "fill_in_quote" }
      assert_equal(id == "34-4" ? 2 : 1, quotes.size, id)
      quotes.each { |block| assert_match(/\A第\d+条/, block[:text], id) }
      text = quotes.map { |block| block[:text].sub(/\A第\d+条(?:第\d+項(?:[・〜]第\d+項)?)?[[:space:]　]*/, "") }.join("\n\n")
      assert_equal BLANKS, text.scan(/\{\{([^{}]+)\}\}/).flatten.uniq, id
      assert_equal 4, correct(question)[:content_blocks].first[:cells].size, id
      matches = question[:choices].select do |choice|
        row = choice[:content_blocks].first[:cells]
        restored = text.gsub(/\{\{([^{}]+)\}\}/) { row.fetch(BLANKS.index(Regexp.last_match(1))) }
        equal = normalize(restored) == normalize(raw)
        assert_equal choice[:correct], equal, "#{id} #{choice[:label]}"
        equal
      end
      assert_equal [correct(question)[:label]], matches.map { |choice| choice[:label] }, id
      question[:choices].map { |choice| choice[:content_blocks].first[:cells] }.transpose.each do |column|
        assert_equal [2, 2], column.tally.values.sort, id
      end
      visible = question[:content_blocks].map { |block| block[:text] }.join
      correct(question)[:content_blocks].first[:cells].each { |term| assert_not_includes visible, term, "#{id} 正答の再掲" }
    end
    EXAMS.each do |exam|
      assert_equal SCHOOL_PROMPT, @data.fetch("#{exam}-4")[:content_blocks].first[:text]
      expected = exam == 32 ? TEACHER_PROMPT.sub("教育公務員特例法", "地方公務員法").sub("昭和24年法律第1号", "昭和25年法律第261号") : TEACHER_PROMPT
      assert_equal expected, @data.fetch("#{exam}-5")[:content_blocks].first[:text]
    end
  end

  test "問三の形式と問五の法令配分を既存三十一も含む五セットで維持する" do
    questions = @entries.select { |entry| entry[:attributes][:question_number] == 3 }
    assert_equal [32, 34], questions.select { |entry| entry[:attributes][:content_blocks].first[:type] == "fill_in_text" }.map { |entry| entry[:exam_number] }
    assert_includes @data.fetch("33-3")[:content_blocks].first[:text], "適切でない"
    count = @data.fetch("35-3")
    assert_match(/個数|いくつ|幾つ/, count[:content_blocks].first[:text])
    assert_equal "イ", correct(count)[:label]
    teacher = @entries.select { |entry| entry[:attributes][:question_number] == 5 && entry[:attributes][:source_text].include?("教育公務員特例法") }
    assert_equal [31, 33, 34, 35], teacher.map { |entry| entry[:exam_number] }
  end

  test "既存六百八十八問の本文正答出典分類と選択肢を改稿しない" do
    before = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_32_to_35_law_existing_688_digests.json")))
    assert_equal 688, before.size
    unchanged = @all.reject { |entry| @data.key?(key(entry)) }
    assert_equal before.keys.sort, unchanged.map { |entry| key(entry) }.sort
    unchanged.each { |entry| assert_equal before.fetch(key(entry)), HistoryRevision20261017.historical_payload_digest(key(entry), entry[:exam_number], entry[:attributes]), key(entry) }
  end

  test "全百問は公開APIへ出し正答解説は回答まで秘匿する" do
    save(@entries)
    assert_equal 100, Question.where(exam_number: 31..35, publication_status: "published").count
    user = User.create!(name: "法令完成確認", email: "law3235-paid@example.com", password: "password123", password_confirmation: "password123")
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_law3235", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    get api_v1_exams_path, headers: headers
    assert_response :success
    exams = response.parsed_body.fetch("data").select { |exam| (31..35).cover?(exam["exam_number"]) }
    assert_equal (31..35).to_a, exams.map { |exam| exam["exam_number"] }
    exams.each { |exam| assert_equal (1..20).to_a, exam.fetch("question_numbers") }
    Question.where(exam_number: 31..35).each do |question|
      get api_v1_question_path(question), headers: headers
      assert_response :success
      assert_equal question.content_blocks, response.parsed_body.dig("data", "content_blocks")
      hidden(response.parsed_body)
    end
    @added.each do |entry|
      question = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      choice = question.question_choices.find_by!(is_correct: true)
      post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id }, headers: headers, as: :json
      assert_response :success
      assert_equal true, response.parsed_body.dig("data", "is_correct")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "十二問追加と公開切替は既存ID回答履歴お気に入りを保持し再同期で不変になる" do
    previous = @entries.reject { |entry| @data.key?(key(entry)) }.map { |entry| EXAMS.include?(entry[:exam_number]) ? entry.merge(publication_status: "draft") : entry }
    save(previous)
    assert_equal 88, Question.count
    user = User.create!(name: "保持確認", email: "law3235-preserve@example.com", password: "password123", password_confirmation: "password123")
    question = Question.find_by!(exam_number: 31, question_number: 1)
    user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    user.favorites.create!(question: question)
    records = Question.order(:id).map { |record| [record.id, QuestionPayload.from_record(record), record.question_choices.order(:display_order).pluck(:id)] }
    history, favorites = AnswerHistory.order(:id).map(&:attributes), Favorite.order(:id).map(&:attributes)
    assert_difference ["Question.count", "QuestionSeedState.count"], 12 do
      assert_difference "QuestionChoice.count", 48 do
        assert_no_difference(["AnswerHistory.count", "Favorite.count"]) { save(@entries) }
      end
    end
    records.each do |id, payload, choices|
      record = Question.find(id)
      assert_equal payload, QuestionPayload.from_record(record)
      assert_equal choices, record.question_choices.order(:display_order).pluck(:id)
    end
    snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].map { |model| model.order(:id).map(&:attributes) }
    save(@entries)
    assert_equal snapshot, [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].map { |model| model.order(:id).map(&:attributes) }
    assert_equal history, AnswerHistory.order(:id).map(&:attributes)
    assert_equal favorites, Favorite.order(:id).map(&:attributes)
  end

  private

  def key(entry) = "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  def correct(question) = question.fetch(:choices).find { |choice| choice[:correct] }
  def normalize(text) = text.gsub(/[[:space:]　]+/, "")
  def save(entries) = QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }

  def hidden(value)
    if value.is_a?(Hash)
      assert_empty value.keys & %w[is_correct correct_choice explanation_blocks source_text]
      value.each_value { |child| hidden(child) }
    elsif value.is_a?(Array)
      value.each { |child| hidden(child) }
    end
  end
end

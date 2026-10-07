require "test_helper"

class MockExams16To20Question20Test < ActionDispatch::IntegrationTest
  EXPECTED_ANSWERS = { 16 => "エ", 17 => "ア", 18 => "イ", 19 => "ウ", 20 => "イ" }.freeze

  setup do
    @entries = QuestionSeedSync.collect do
      (16..20).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end.select { |entry| entry.fetch(:attributes).fetch(:question_number) == 20 }
    synchronize_question_20
  end

  test "承認済み五問は四択一正答と全選択肢の解説及び出典を持つ下書きである" do
    assert_equal 5, questions.count
    questions.each do |question|
      assert_equal "draft", question.publication_status
      assert_equal "information", question.major_category_code
      assert_equal "information_specialized", question.category_code
      choices = question.question_choices.order(:display_order)
      assert_equal %w[ア イ ウ エ], choices.map(&:choice_label)
      assert_equal 1, choices.count(&:is_correct?)
      assert_equal EXPECTED_ANSWERS.fetch(question.exam_number), choices.find(&:is_correct?).choice_label
      explanation = question.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
      choices.each { |choice| assert_includes explanation, "#{choice.choice_label}：" }
      question.source_text.lines.each { |line| assert_match(/\A.+ \| https:\/\/\S+\z/, line.strip) }
      payload = QuestionPayload.from_record(question)
      QuestionWriter.validate_publication!(question, payload.fetch("choices").map(&:symbolize_keys))
      assert_equal "draft", question.reload.publication_status
    end
  end

  test "下書き五問を一般APIから表示及び回答できず管理APIから確認できる" do
    admin = User.create!(name: "問20下書き検証", email: "draft-q20-check@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    questions.each do |question|
      get next_api_v1_questions_path, params: { exam_number: question.exam_number, after_question_number: 19 }
      assert_response :not_found
      get api_v1_question_path(question)
      assert_response :not_found
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, as: :json
      end
      assert_response :not_found
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, data.fetch("content_blocks")
      assert_equal question.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal question.source_text, data.fetch("source_text")
      assert_equal "draft", data.fetch("publication_status")
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
    end
  end

  test "再実行で五問と選択肢のID及び回答履歴を保持する" do
    question = questions.first
    user = User.create!(name: "問20再実行", email: "repeat-draft-q20@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    ids = questions.pluck(:id)
    choice_ids = QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
    payloads = questions.map { |q| QuestionPayload.digest(QuestionPayload.from_record(q)) }
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
        synchronize_question_20
      end
    end
    assert_equal ids, questions.pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: ids).order(:id).pluck(:id)
    assert_equal payloads, questions.map { |q| QuestionPayload.digest(QuestionPayload.from_record(q)) }
    assert AnswerHistory.exists?(history.id)
  end

  test "同一顧客の異なる購入を重複扱いしないこと及び尺度の解釈を確認する" do
    cleaning = questions.find_by!(exam_number: 16)
    assert_includes cleaning.content_blocks.first.fetch("text"), "1行は1回の購入"
    assert_includes cleaning.content_blocks.first.fetch("text"), "適切でないもの"
    assert_includes cleaning.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text"), "顧客番号をキー"
    explanation = cleaning.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
    assert_includes explanation, "売上総額が過少"
    scale = questions.find_by!(exam_number: 17)
    correct = scale.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text")
    assert_includes correct, "比例尺度"
    assert_equal 2, 40.fdiv(20)
    assert_in_delta 2, (40.fdiv(60)) / (20.fdiv(60)), 1e-12
    assert_includes correct, "単位を秒から分"
  end

  test "相関係数の三変換を独立に計算し選択肢の一意性と各列の配分を確認する" do
    question = questions.find_by!(exam_number: 18)
    x, y = [157, 159, 161, 163], [69, 67, 73, 71]
    original = correlation(x, y)
    results = [correlation(y, x), correlation(x.map { |value| value.fdiv(100) }, y), correlation(x, y.map { |value| 100 - value })]
    assert_in_delta 0.60, original, 1e-12
    [0.60, 0.60, -0.60].zip(results).each { |expected, actual| assert_in_delta expected, actual, 1e-12 }
    rows = question.question_choices.map { |choice| choice.content_blocks.first.fetch("rows").first }
    question.question_choices.zip(rows).each do |choice, cells|
      numbers = cells.map { |cell| cell.tr("−", "-").to_f }
      matches = numbers.zip(results).all? { |value, expected| (value - expected).abs < 1e-12 }
      assert_equal choice.is_correct?, matches
    end
    rows.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort }
  end

  test "表示されたデータから最大値変更の代表値及び二群の分散を検算する" do
    representative = questions.find_by!(exam_number: 19)
    text = representative.content_blocks.filter_map { |block| block["text"] }.join("\n")
    before = text[/2，4，4，6，8，10，12，18/].split("，").map(&:to_f)
    after = before.map { |value| value == 18 ? 34 : value }
    assert_equal [8, 10], [mean(before), mean(after)]
    assert_equal [7, 7], [median(before), median(after)]
    assert_equal [4, 4], [mode(before), mode(after)]
    distribution = questions.find_by!(exam_number: 20)
    text = distribution.content_blocks.filter_map { |block| block["text"] }.join("\n")
    a = text[/データA：([^\n]+)/, 1].split("，").map(&:to_f)
    b = text[/データB：([^\n]+)/, 1].split("，").map(&:to_f)
    assert_equal [4, 5], [a.size, b.size]
    assert_equal [5, 5, 5, 5], [mean(a), mean(b), median(a), median(b)]
    assert_equal [1, 4], [variance(a), variance(b)]
    assert_equal [1, 2], [Math.sqrt(variance(a)), Math.sqrt(variance(b))]
    assert_includes text, "データの個数で割った"
  end

  test "既存十五問及び追加五問内に完全重複はない" do
    existing = QuestionSeedSync.collect do
      (1..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end.select { |entry| entry.fetch(:attributes).fetch(:question_number) == 20 }
    all_texts = (existing + @entries).map { |entry| entry.fetch(:attributes).fetch(:content_blocks).to_json.gsub(/[\s　]/, "") }
    assert_equal 20, all_texts.size
    assert_equal 20, all_texts.uniq.size
  end

  private

  def questions
    Question.where(exam_number: 16..20, question_number: 20).order(:exam_number)
  end

  def synchronize_question_20
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def mean(values)
    values.sum.fdiv(values.size)
  end

  def variance(values)
    average = mean(values)
    mean(values.map { |value| (value - average)**2 })
  end

  def median(values)
    sorted = values.sort
    size = values.size
    size.odd? ? sorted[size / 2] : mean(sorted[(size / 2 - 1), 2])
  end

  def mode(values)
    values.tally.max_by { |_value, count| count }.first
  end

  def correlation(x, y)
    mx, my = mean(x), mean(y)
    numerator = x.zip(y).sum { |a, b| (a - mx) * (b - my) }
    denominator = Math.sqrt(x.sum { |value| (value - mx)**2 } * y.sum { |value| (value - my)**2 })
    numerator / denominator
  end
end

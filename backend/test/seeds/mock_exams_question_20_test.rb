require "test_helper"

class MockExamsQuestion20Test < ActionDispatch::IntegrationTest
  EXPECTED_ANSWERS = %w[イ ア イ イ ア エ ウ ア イ ア イ イ ア ウ エ].freeze

  setup do
    @entries = QuestionSeedSync.collect do
      (1..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @question_20_entries = @entries.select { |entry| entry.fetch(:attributes).fetch(:question_number) == 20 }
    synchronize_question_20
  end

  test "十五問が公開され四択一正答と日本語の原典出典と全選択肢の解説を持つ" do
    assert_equal 15, questions.count
    questions.each do |question|
      assert_equal "published", question.publication_status
      assert_equal "information", question.major_category_code
      assert_equal "information_specialized", question.category_code
      choices = question.question_choices.order(:display_order)
      assert_equal %w[ア イ ウ エ], choices.map(&:choice_label)
      assert_equal 1, choices.count(&:is_correct?)
      assert_equal EXPECTED_ANSWERS.fetch(question.exam_number - 1), choices.find(&:is_correct?).choice_label
      assert question.content_blocks.present?
      assert question.explanation_blocks.present?
      explanation = question.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
      choices.each { |choice| assert_includes explanation, choice.choice_label, "模試#{question.exam_number}の解説" }
      question.source_text.lines.each do |line|
        assert_match(/\A.+ \| https:\/\/(www\.mext\.go\.jp|www\.stat\.go\.jp)\/.+\z/, line.strip)
      end
    end
  end

  test "各セットの正答配分五件ずつと二十問の構成を維持する" do
    @entries.group_by { |entry| entry.fetch(:exam_number) }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry.fetch(:attributes).fetch(:question_number) }.sort
      answers = entries.map do |entry|
        entry.fetch(:attributes).fetch(:choices).find { |choice| choice.fetch(:correct) }.fetch(:label)
      end
      assert_equal({ "ア" => 5, "イ" => 5, "ウ" => 5, "エ" => 5 }, answers.tally, "模試#{exam}の正答配分")
    end
  end

  test "有料会員が十五問を取得し回答後だけに正答解説出典を返す" do
    headers = paid_user_headers("question20-paid@example.com")
    questions.each do |question|
      get next_api_v1_questions_path, params: { exam_number: question.exam_number, after_question_number: 19 }, headers: headers
      assert_response :success
      position = response.parsed_body.fetch("data")
      assert_equal [question.exam_number, 20], position.values_at("exam_number", "question_number")
      assert_equal question.content_blocks, position.fetch("content_blocks")
      get api_v1_question_path(question), headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      %w[correct_choice explanation_blocks source_text].each { |key| assert_not body.key?(key) }
      assert_equal 4, body.fetch("choices").size
      body.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }

      correct = question.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: correct.id }, headers: headers, as: :json
      end
      assert_response :success
      answer = response.parsed_body.fetch("data")
      assert_equal true, answer.fetch("is_correct")
      assert_equal question.explanation_blocks, answer.fetch("explanation_blocks")
      assert_equal question.source_text, answer.fetch("source_text")
    end
  end

  def paid_user_headers(email)
    user = User.create!(name: "有料会員", email: email, password: "password123", password_confirmation: "password123")
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end

  test "変更のない再実行は十五問のIDと選択肢IDと回答履歴を保持する" do
    question = questions.find_by!(exam_number: 1)
    user = User.create!(name: "問20検証", email: "question20-check@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    question_ids = questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)

    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count"] do
        synchronize_question_20
      end
    end
    assert_equal question_ids, questions.order(:id).pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)
    assert AnswerHistory.exists?(history.id)
  end

  test "四分位範囲の境界とU字型データの相関係数を検算する" do
    outlier = questions.find_by!(exam_number: 1)
    values = outlier.content_blocks.find { |block| block["type"] == "table" }.fetch("rows").flatten.map(&:to_f)
    q1, q3 = 18.0, 30.0
    lower, upper = q1 - 1.5 * (q3 - q1), q3 + 1.5 * (q3 - q1)
    assert_equal [0, 48], [lower, upper]
    assert_equal [52], values.select { |value| value < lower || value > upper }

    nonlinear = questions.find_by!(exam_number: 7)
    table = nonlinear.content_blocks.find { |block| block["type"] == "table" }
    x = table.fetch("headers").drop(1).map(&:to_f)
    y = table.fetch("rows").first.drop(1).map(&:to_f)
    assert_equal x.map { |value| value**2 }, y
    assert_equal 0, correlation(x, y)
    assert_operator correlation(x.map(&:abs), y), :>, 0
  end

  test "層別の割合が人数と一致し全体の割合が単純平均と異なる" do
    question = questions.find_by!(exam_number: 3)
    table = question.content_blocks.find { |block| block["type"] == "table" }
    groups = table.fetch("rows").map do |row|
      row.drop(1).map do |cell|
        passed, count, rate = cell.scan(/\d+/).map(&:to_f)
        assert_equal rate, passed / count * 100
        [passed, count, rate]
      end
    end
    assert groups.first(2).all? { |group| group[0].last > group[1].last }
    assert groups.last[0].last < groups.last[1].last
    2.times do |column|
      assert_equal groups.last[column].first(2), [0, 1].map { |i| groups.first(2).sum { |row| row[column][i] } }
      refute_equal groups.last[column].last, groups.first(2).sum { |row| row[column].last }.fdiv(2)
    end
  end

  test "尺度組合せの各列を多数決で解ける配置にしない" do
    question = questions.find_by!(exam_number: 6)
    values = question.question_choices.order(:display_order).map do |choice|
      choice.content_blocks.first.fetch("text").split(" ／ ").map { |cell| cell.split.last }
    end
    expected = %w[名義尺度 順序尺度 間隔尺度 比例尺度 間隔尺度]
    question.question_choices.order(:display_order).zip(values).each do |choice, cells|
      assert_equal choice.is_correct?, cells == expected
    end
    values.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort }

    quartiles = questions.find_by!(exam_number: 11)
    rows = quartiles.question_choices.map { |choice| choice.content_blocks.first.fetch("rows").first }
    rows.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort }
  end

  test "提示された相関係数の符号と強さ及び身長の単位換算を検算する" do
    relationship = questions.find_by!(exam_number: 4)
    rows = relationship.content_blocks.find { |block| block["type"] == "table" }.fetch("rows")
    coefficients = rows.map { |row| row.last.tr("−", "-").to_f }
    assert_operator coefficients.first, :>, 0
    assert_operator coefficients.last, :<, 0
    assert_operator coefficients.last.abs, :>, coefficients.first.abs
    relationship.question_choices.each do |choice|
      text = choice.content_blocks.first.fetch("text")
      direction_correct = text.start_with?("Aではxが大きいほどyも大きい傾向があり、Bではxが大きいほどyが小さい傾向がある。")
      strength_correct = text.end_with?("直線的な関係はBの方が強い。")
      assert_equal choice.is_correct?, direction_correct && strength_correct
    end

    cleaning = questions.find_by!(exam_number: 5)
    records = cleaning.content_blocks.find { |block| block["type"] == "table" }.fetch("rows").map(&:last)
    centimeters = records.map do |record|
      value, unit = record.split
      value.to_f * (unit == "m" ? 100 : 1)
    end
    assert_equal [164, 168, 172], centimeters
    correct = cleaning.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text")
    assert_includes correct, "164、168、172"
    assert_equal [1.64, 1.68, 1.72], centimeters.map { |value| value / 100 }
    refute_equal centimeters[1], records[1].to_f.round * 100
  end

  test "回帰の予測値と全数集計の全校割合を表示された値から検算する" do
    regression = questions.find_by!(exam_number: 9)
    prompt = regression.content_blocks.first.fetch("text")
    coefficients = prompt.match(/ŷ = (\d+) \+ (\d+\.\d+)x/).captures.map(&:to_f)
    prediction = ->(value) { coefficients[0] + coefficients[1] * value }
    assert_equal [205, 290, 332.5], [10, 20, 25].map { |value| prediction.call(value) }
    assert_equal 42.5, prediction.call(25) - prediction.call(20)
    refute_equal prediction.call(20), prediction.call(10) * 2
    assert_includes regression.explanation_blocks.find { |block| block["type"] == "code" }.fetch("code"), "332.5 - 290 = 42.5"

    survey = questions.find_by!(exam_number: 10)
    rows = survey.content_blocks.find { |block| block["type"] == "table" }.fetch("rows")
    counts = rows.first(3).map { |row| row[1].to_i }
    rates = rows.first(3).map { |row| row[2].to_f }
    agreed = counts.zip(rates).map { |count, rate| count * rate / 100 }
    assert_equal [180, 180, 80], agreed
    assert_equal counts.sum, rows.last[1].delete(",").to_i
    percentage = agreed.sum.fdiv(counts.sum) * 100
    assert_equal 44, percentage
    survey.question_choices.each do |choice|
      assert_equal choice.is_correct?, choice.content_blocks.first.fetch("text").to_f == percentage
    end
  end

  private

  def questions
    Question.where(exam_number: 1..15, question_number: 20).order(:exam_number)
  end

  def synchronize_question_20
    QuestionWriter.transaction { @question_20_entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def correlation(x, y)
    mean_x, mean_y = x.sum.fdiv(x.size), y.sum.fdiv(y.size)
    numerator = x.zip(y).sum { |a, b| (a - mean_x) * (b - mean_y) }
    denominator = Math.sqrt(x.sum { |a| (a - mean_x)**2 } * y.sum { |b| (b - mean_y)**2 })
    numerator / denominator
  end
end

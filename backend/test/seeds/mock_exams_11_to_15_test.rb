require "test_helper"

class MockExams11To15Test < ActionDispatch::IntegrationTest
  EXPECTED_ANSWERS = {
    11 => %w[ウ イ エ],
    12 => %w[エ ア ウ],
    13 => %w[イ エ ア],
    14 => %w[ア ウ イ],
    15 => %w[イ イ ウ],
  }.freeze

  setup do
    load_partial_seeds
  end

  test "承認済みの問1から問5だけを下書きで保存する" do
    assert_equal 25, partial_questions.count
    assert_equal 0, partial_questions.published.count

    (11..15).each do |exam|
      questions = partial_questions.where(exam_number: exam).order(:question_number)
      assert_equal (1..5).to_a, questions.pluck(:question_number)
      assert_equal EXPECTED_ANSWERS.fetch(exam), questions.where(question_number: 3..5).map { |q| q.question_choices.find_by!(is_correct: true).choice_label }

      questions.each do |question|
        assert_equal "draft", question.publication_status
        assert_equal "teacher_education", question.major_category_code
        assert_equal question.question_number <= 2 ? "education_foundations" : "education_system", question.category_code
        assert_equal %w[ア イ ウ エ], question.question_choices.pluck(:choice_label)
        assert_equal 1, question.question_choices.where(is_correct: true).count
        assert question.content_blocks.present?
        assert question.explanation_blocks.present?
        assert question.source_text.lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
      end
    end
  end

  test "法令の指定体裁と四空欄の対応及び出題配分を保持する" do
    fills = partial_questions.where(question_number: 3..5).select do |question|
      question.content_blocks.any? { |block| block["type"] == "fill_in_quote" }
    end
    assert_equal 12, fills.size

    fills.each do |question|
      excerpt = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      assert_match(/\A第\d+条/, excerpt)
      assert_equal %w[① ② ③ ④], excerpt.scan(/\{\{([①②③④])\}\}/).flatten.uniq
      question.question_choices.each do |choice|
        assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
        assert_equal 4, choice.content_blocks.first.fetch("cells").size
      end

      next if question.question_number == 3

      law_title = if question.question_number == 4
        "「学校教育法」（昭和22年法律第26号）"
      elsif question.exam_number == 14
        "「地方公務員法」 （昭和25年法律第261号）"
      else
        "「教育公務員特例法」 （昭和24年法律第1号）"
      end
      expected_prompt = "次の各文は，#{law_title}の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
      assert_equal expected_prompt, question.content_blocks.first.fetch("text")
    end

    question_3_prompts = partial_questions.where(question_number: 3).map { |q| q.content_blocks.first.fetch("text") }
    assert_equal 2, question_3_prompts.count { |text| text.include?("空欄") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("うち，正しいものを") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("適切でないもの") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("正しいものが幾つあるか") }
  end

  test "再実行で問題や選択肢を増やさず変更のない回答履歴を保持する" do
    question = partial_questions.find_by!(exam_number: 11, question_number: 3)
    user = User.create!(name: "seed検証", email: "seed-check@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    question_ids = partial_questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)

    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count"] do
      load_partial_seeds
    end
    assert_equal question_ids, partial_questions.order(:id).pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)
    assert AnswerHistory.exists?(history.id)

    question.update!(content_blocks: [{ type: "text", text: "変更前の文面" }])
    load_partial_seeds
    assert AnswerHistory.exists?(history.id)
    assert_equal "変更前の文面", question.reload.content_blocks.first.fetch("text")
  end

  test "下書き問題を一般向け一覧と問題取得及び回答APIへ公開しない" do
    get api_v1_exams_path
    assert_response :success
    assert_empty response.parsed_body.fetch("data").select { |exam| (11..15).cover?(exam.fetch("exam_number")) }

    (11..15).each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }
      assert_response :not_found
    end

    partial_questions.where(question_number: 3..5).each do |question|
      get api_v1_question_path(question)
      assert_response :not_found
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, as: :json
      end
      assert_response :not_found
    end
  end

  private

  def partial_questions
    Question.where(exam_number: 11..15)
  end

  def load_partial_seeds
    (11..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
  end
end

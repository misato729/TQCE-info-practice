require "test_helper"

class Api::V1::QuestionsTest < ActionDispatch::IntegrationTest
  setup do
    @question = Question.create!(
      exam_number: 1,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_law",
      publication_status: "published",
      content_blocks: [{ type: "text", text: "問題文" }],
      explanation_blocks: [{ type: "text", text: "解説" }],
      source_text: "根拠資料",
    )
    @choices = %w[ア イ ウ エ].map.with_index do |label, index|
      @question.question_choices.create!(
        choice_label: label,
        content_blocks: [{ type: "text", text: "選択肢#{label}" }],
        is_correct: index == 2,
        display_order: index + 1,
      )
    end
  end

  test "公開問題は正答と解説を含めず取得できる" do
    get api_v1_question_path(@question)

    assert_response :success
    body = response.parsed_body.fetch("data")
    assert_equal @question.id, body.fetch("id")
    assert_equal 4, body.fetch("choices").size
    assert_not body.key?("difficulty")
    assert_not body.key?("explanation_blocks")
    assert_not body.fetch("choices").first.key?("is_correct")
  end

  test "回答をサーバー側で採点して解説を返す" do
    post answer_api_v1_question_path(@question), params: { selected_choice_id: @choices.third.id }, as: :json

    assert_response :success
    body = response.parsed_body.fetch("data")
    assert body.fetch("is_correct")
    assert_equal "ウ", body.dig("correct_choice", "choice_label")
    assert_equal "解説", body.dig("explanation_blocks", 0, "text")
    assert_nil body.fetch("answer_history_id")
  end

  test "別の問題の選択肢は回答に使えない" do
    another_question = Question.create!(
      exam_number: 2,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_law",
      publication_status: "published",
      content_blocks: [],
      explanation_blocks: [],
    )
    another_choice = another_question.question_choices.create!(
      choice_label: "ア",
      content_blocks: [],
      is_correct: true,
      display_order: 1,
    )

    post answer_api_v1_question_path(@question), params: { selected_choice_id: another_choice.id }, as: :json

    assert_response 422
    assert_equal "validation_error", response.parsed_body.dig("error", "code")
  end

  test "同じ試験セットの次の問番号を取得できる" do
    next_question = Question.create!(
      exam_number: 1,
      question_number: 3,
      major_category_code: "information",
      category_code: "algorithm",
      publication_status: "published",
      content_blocks: [],
      explanation_blocks: [],
    )

    get next_api_v1_questions_path, params: { exam_number: 1, after_question_number: 1 }

    assert_response :success
    assert_equal next_question.id, response.parsed_body.dig("data", "id")
  end

  test "非公開問題は取得できない" do
    @question.update!(publication_status: "private")

    get api_v1_question_path(@question)

    assert_response :not_found
  end
end

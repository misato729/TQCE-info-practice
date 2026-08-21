require "test_helper"

class Api::V1::Admin::QuestionsTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      name: "管理者",
      email: "admin@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "admin",
    )
    @user = User.create!(
      name: "一般ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "user",
    )
    @headers = {
      "Authorization" => "Bearer #{AuthToken.issue(@admin)}",
      "Content-Type" => "application/json",
    }
    @question = create_question(exam_number: 1, question_number: 1)
  end

  test "admin lists and filters questions" do
    create_question(exam_number: 2, question_number: 1, publication_status: "published")

    get "/api/v1/admin/questions", params: { exam_number: 2, publication_status: "published" }, headers: @headers

    assert_response :success
    body = response.parsed_body
    assert_equal 1, body["data"].length
    assert_equal 2, body.dig("data", 0, "exam_number")
    assert_equal 1, body.dig("meta", "total_count")
  end

  test "admin views question with correct answer" do
    get "/api/v1/admin/questions/#{@question.id}", headers: @headers

    assert_response :success
    body = response.parsed_body.fetch("data")
    assert_equal 4, body.fetch("choices").length
    assert_equal 1, body.fetch("choices").count { |choice| choice["is_correct"] }
    assert_equal "問題文", body.dig("content_blocks", 0, "text")
  end

  test "admin creates updates and deletes a question" do
    post "/api/v1/admin/questions", params: { question: question_payload(exam_number: 1, question_number: 2) }.to_json, headers: @headers

    assert_response :created
    question_id = response.parsed_body.dig("data", "id")
    assert_equal 4, Question.find(question_id).question_choices.count

    payload = question_payload(exam_number: 1, question_number: 2)
    payload[:publication_status] = "published"
    payload[:choices][1][:is_correct] = false
    payload[:choices][2][:is_correct] = true
    payload[:choices].each_with_index do |choice, index|
      choice[:id] = Question.find(question_id).question_choices[index].id
    end
    patch "/api/v1/admin/questions/#{question_id}", params: { question: payload }.to_json, headers: @headers

    assert_response :success
    assert_equal "published", Question.find(question_id).publication_status
    assert_equal "ウ", Question.find(question_id).question_choices.find_by!(is_correct: true).choice_label

    delete "/api/v1/admin/questions/#{question_id}", headers: @headers

    assert_response :no_content
    assert_not Question.exists?(question_id)
  end

  test "non-admin is forbidden" do
    headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
    get "/api/v1/admin/questions", headers: headers

    assert_response :forbidden
  end

  test "unauthenticated request is rejected" do
    get "/api/v1/admin/questions"

    assert_response :unauthorized
  end

  test "question requires four choices and one correct answer" do
    payload = question_payload(exam_number: 1, question_number: 2)
    payload[:choices] = payload[:choices].first(3)

    post "/api/v1/admin/questions", params: { question: payload }.to_json, headers: @headers

    assert_response :unprocessable_content
    assert_equal "validation_error", response.parsed_body.dig("error", "code")
  end

  private

  def create_question(exam_number:, question_number:, publication_status: "draft")
    question = Question.create!(
      exam_number: exam_number,
      question_number: question_number,
      major_category_code: "teacher_education",
      category_code: "education_history",
      content_blocks: [{ type: "text", text: "問題文" }],
      explanation_blocks: [{ type: "text", text: "解答解説" }],
      source_text: "根拠資料",
      publication_status: publication_status,
    )
    %w[ア イ ウ エ].each_with_index do |label, index|
      question.question_choices.create!(
        choice_label: label,
        content_blocks: [{ type: "text", text: "選択肢#{index + 1}" }],
        is_correct: index == 1,
        display_order: index + 1,
      )
    end
    question
  end

  def question_payload(exam_number:, question_number:)
    {
      exam_number: exam_number,
      question_number: question_number,
      major_category_code: "teacher_education",
      category_code: "education_history",
      content_blocks: [{ type: "text", text: "新しい問題文" }],
      explanation_blocks: [{ type: "text", text: "新しい解答解説" }],
      source_text: "根拠資料",
      publication_status: "draft",
      choices: %w[ア イ ウ エ].each_with_index.map do |label, index|
        {
          choice_label: label,
          content_blocks: [{ type: "text", text: "選択肢#{index + 1}" }],
          is_correct: index == 1,
          display_order: index + 1,
        }
      end,
    }
  end
end

require "test_helper"

class Api::V1::ExamsTest < ActionDispatch::IntegrationTest
  test "公開問題が存在する模擬試験だけを問題番号とともに返す" do
    create_question(exam_number: 1, question_number: 3, publication_status: "published")
    create_question(exam_number: 1, question_number: 1, publication_status: "published")
    create_question(exam_number: 2, question_number: 1, publication_status: "private")
    create_question(exam_number: 3, question_number: 2, publication_status: "published")

    get api_v1_exams_path

    assert_response :success
    assert_equal(
      [
        { "exam_number" => 1, "question_numbers" => [1, 3] },
        { "exam_number" => 3, "question_numbers" => [2] },
      ],
      response.parsed_body.fetch("data"),
    )
  end

  test "公開中の模擬試験がなければ空配列を返す" do
    create_question(exam_number: 1, question_number: 1, publication_status: "private")

    get api_v1_exams_path

    assert_response :success
    assert_equal [], response.parsed_body.fetch("data")
  end

  private

  def create_question(exam_number:, question_number:, publication_status:)
    Question.create!(
      exam_number: exam_number,
      question_number: question_number,
      major_category_code: "teacher_education",
      category_code: "education_system",
      publication_status: publication_status,
      content_blocks: [{ type: "text", text: "問題文" }],
      explanation_blocks: [{ type: "text", text: "解説" }],
    )
  end
end

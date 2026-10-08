require "test_helper"

class Api::V1::FavoritesTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )
    @headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
    @free_question = create_question(1)
    @premium_question = create_question(6)
  end

  test "無料問題をお気に入り登録して一覧取得と解除ができる" do
    put api_v1_question_favorite_path(@free_question), headers: @headers
    assert_response :created
    assert Favorite.exists?(user: @user, question: @free_question)

    get api_v1_favorites_path, headers: @headers
    assert_response :success
    assert_not response.parsed_body.dig("data", 0, "locked")

    delete "/api/v1/questions/#{@free_question.id}/favorite", headers: @headers
    assert_response :no_content
    assert_not Favorite.exists?(user: @user, question: @free_question)
  end

  test "無料会員は有料問題を新規登録できず既存項目もロック表示する" do
    Favorite.create!(user: @user, question: @premium_question)

    put api_v1_question_favorite_path(@premium_question), headers: @headers
    assert_response :forbidden

    get api_v1_favorites_path, headers: @headers
    item = response.parsed_body.fetch("data").find { |entry| entry.dig("question", "id") == @premium_question.id }
    assert item.fetch("locked")
    assert_not item.fetch("question").key?("body_excerpt")
  end

  private

  def create_question(exam_number)
    Question.create!(
      exam_number: exam_number,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_system",
      publication_status: "published",
      content_blocks: [{ type: "text", text: "問題文" }],
      explanation_blocks: [{ type: "text", text: "解説" }],
    )
  end
end

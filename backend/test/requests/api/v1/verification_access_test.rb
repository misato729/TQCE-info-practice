require "test_helper"

class Api::V1::VerificationAccessTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Verification", email: "verification@example.com", password: "password123")
    @grant = @user.create_verification_access_grant!(reason: "Netlify QA", granted_by: "Owner approval", expires_at: 1.hour.from_now)
    @headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
    @question = Question.create!(
      exam_number: 6, question_number: 1, major_category_code: "teacher_education", category_code: "education_system",
      publication_status: "published", content_blocks: [{ type: "text", text: "Question" }],
      explanation_blocks: [{ type: "text", text: "Explanation" }], source_text: "Source",
    )
    @choices = %w[A B C D].each_with_index.map do |_label, index|
      @question.question_choices.create!(
        choice_label: %w[ア イ ウ エ][index], content_blocks: [{ type: "text", text: "Choice #{index}" }],
        is_correct: index.zero?, display_order: index + 1,
      )
    end
  end

  test "login and user payload distinguish verification access from a purchase" do
    post "/api/v1/auth/login", params: { email: @user.email, password: "password123" }, as: :json
    assert_response :success
    payload = response.parsed_body.dig("data", "user")
    assert payload["paid_content_access"]
    assert_equal "user", payload["role"]
    assert_equal "free", payload.dig("membership", "status")
    assert_nil payload.dig("membership", "purchased_at")
    assert_equal @grant.expires_at.iso8601, payload.dig("verification_access", "expires_at")
    assert_not payload.fetch("verification_access").key?("reason")

    get api_v1_me_path, headers: @headers
    assert_response :success
    assert response.parsed_body.dig("data", "paid_content_access")
  end

  test "verification user can solve premium questions and sync favorites but cannot administer" do
    get api_v1_question_path(@question), headers: @headers
    assert_response :success
    assert_not response.parsed_body.fetch("data").key?("explanation_blocks")
    assert_not response.parsed_body.fetch("data").fetch("choices").any? { |choice| choice.key?("is_correct") }

    assert_difference("AnswerHistory.count", 1) do
      post answer_api_v1_question_path(@question), params: { selected_choice_id: @choices.first.id }, headers: @headers, as: :json
      assert_response :success
    end
    history_id = response.parsed_body.dig("data", "answer_history_id")
    get api_v1_answer_history_path(history_id), headers: @headers
    assert_response :success

    put api_v1_question_favorite_path(@question), headers: @headers
    assert_response :created
    get api_v1_me_path, headers: @headers
    assert_equal [{ "id" => @question.id, "exam_number" => 6, "question_number" => 1 }], response.parsed_body.dig("data", "favorite_questions")
    get api_v1_favorites_path, headers: @headers
    assert_response :success
    delete api_v1_question_favorite_path(@question), headers: @headers
    assert_response :no_content

    get api_v1_admin_questions_path, headers: @headers
    assert_response :forbidden
    assert_empty @user.payments
    assert_nil @user.membership
  end

  test "expiration rejects access with the same token and retains favorites and history" do
    Favorite.create!(user: @user, question: @question)
    history = AnswerHistory.create!(user: @user, question: @question, selected_choice: @choices.first, is_correct: true)

    travel_to(@grant.expires_at, with_usec: true) do
      get api_v1_question_path(@question), headers: @headers
      assert_response :forbidden
      get api_v1_favorites_path, headers: @headers
      assert_response :forbidden
      get api_v1_answer_history_path(history), headers: @headers
      assert_response :forbidden
      get api_v1_me_path, headers: @headers
      assert_not response.parsed_body.dig("data", "paid_content_access")
      assert_nil response.parsed_body.dig("data", "verification_access")
      assert_empty response.parsed_body.dig("data", "favorite_questions")
      assert_equal 1, @user.favorites.count
      assert_equal 1, @user.answer_histories.count
    end
  end

  test "revocation rejects premium questions and favorites" do
    @grant.update!(revoked_at: Time.current)
    get api_v1_question_path(@question), headers: @headers
    assert_response :forbidden
    put api_v1_question_favorite_path(@question), headers: @headers
    assert_response :forbidden
  end

  test "signup cannot self assign verification or admin privileges" do
    post "/api/v1/auth/signup", params: {
      name: "Unprivileged", email: "unprivileged@example.com", password: "password123", password_confirmation: "password123",
      role: "admin", verification_access: { expires_at: 1.day.from_now.iso8601 },
    }, as: :json
    assert_response :created
    payload = response.parsed_body.dig("data", "user")
    assert_equal "user", payload["role"]
    assert_not payload["paid_content_access"]
    assert_nil payload["verification_access"]
  end
end

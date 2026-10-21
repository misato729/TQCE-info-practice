require "test_helper"
require_relative "../../../support/method_replacement"

class Api::V1::LearningWorkflowTest < ActionDispatch::IntegrationTest
  include MethodReplacement

  test "sales-off learning keeps history favorites and permissions consistent across one complete API workflow" do
    free_question = create_question(1)
    premium_question = create_question(6)
    with_env("PAID_MEMBERSHIP_ENABLED" => "false", "ERROR_NOTIFICATIONS_ENABLED" => "false") do
      with_method_replacement(PaidMembership, :stripe_client, -> { flunk "The sales-off workflow must never contact Stripe" }) do
        post "/api/v1/auth/signup", params: { name: "Workflow learner", email: "workflow@example.invalid",
          password: "password123", password_confirmation: "password123" }, as: :json
        assert_response :created
        user = User.find(response.parsed_body.dig("data", "user", "id"))
        headers = { "Authorization" => "Bearer #{response.parsed_body.dig('data', 'access_token')}" }

        get api_v1_question_path(free_question), headers: headers
        assert_response :ok
        refute response.parsed_body.fetch("data").key?("explanation_blocks")
        assert response.parsed_body.dig("data", "choices").none? { |choice| choice.key?("is_correct") }
        post answer_api_v1_question_path(free_question), params: { selected_choice_id: free_question.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
        assert_response :ok
        assert response.parsed_body.dig("data", "is_correct")
        history_id = response.parsed_body.dig("data", "answer_history_id")
        assert_equal user.id, AnswerHistory.find(history_id).user_id
        get api_v1_answer_histories_path, headers: headers
        assert_response :ok
        assert_equal [history_id], response.parsed_body.fetch("data").map { |item| item.fetch("id") }
        get "/api/v1/answer_histories/#{history_id}", headers: headers
        assert_response :ok
        assert response.parsed_body.dig("data", "explanation_blocks").present?

        get api_v1_question_path(premium_question), headers: headers
        assert_response :forbidden
        put api_v1_question_favorite_path(free_question), headers: headers, as: :json
        assert_response :forbidden
        get "/api/v1/admin/questions", headers: headers
        assert_response :forbidden

        VerificationAccessGrant.create!(user: user, reason: "Synthetic workflow check", granted_by: "local-test", expires_at: 1.day.from_now)
        post "/api/v1/auth/login", params: { email: user.email, password: "password123" }, as: :json
        assert_response :ok
        assert response.parsed_body.dig("data", "user", "paid_content_access")
        headers = { "Authorization" => "Bearer #{response.parsed_body.dig('data', 'access_token')}" }
        get api_v1_question_path(premium_question), headers: headers
        assert_response :ok
        put api_v1_question_favorite_path(premium_question), headers: headers, as: :json
        assert_response :created
        get "/api/v1/me", headers: headers
        assert_response :ok
        assert_equal [premium_question.id], response.parsed_body.dig("data", "favorite_questions").map { |item| item.fetch("id") }
        get "/api/v1/favorites", headers: headers
        assert_response :ok
        assert_equal [premium_question.id], response.parsed_body.fetch("data").map { |item| item.dig("question", "id") }
        delete api_v1_question_favorite_path(premium_question), headers: headers
        assert_response :no_content
        get "/api/v1/me", headers: headers
        assert_response :ok
        assert_empty response.parsed_body.dig("data", "favorite_questions")

        assert_no_difference ["Payment.count", "Membership.count"] do
          post "/api/v1/payments/checkout_sessions", headers: headers, as: :json
        end
        assert_response :service_unavailable
        assert_equal "payment_unavailable", response.parsed_body.dig("error", "code")
        get "/api/v1/answer_histories"
        assert_response :unauthorized
        get "/api/v1/favorites"
        assert_response :unauthorized
      end
    end
  end

  private

  def create_question(exam_number)
    question = Question.create!(exam_number: exam_number, question_number: 1,
      major_category_code: "teacher_education", category_code: "education_system", publication_status: "published",
      content_blocks: [{ type: "text", text: "Synthetic workflow question" }],
      explanation_blocks: [{ type: "text", text: "Synthetic explanation" }])
    %w[ア イ ウ エ].each.with_index(1) do |label, order|
      question.question_choices.create!(choice_label: label, display_order: order,
        is_correct: order == 1, content_blocks: [{ type: "text", text: "Choice" }])
    end
    question
  end
end

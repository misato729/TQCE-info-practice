require "test_helper"

class Api::V1::AnswerHistoriesTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user("user@example.com")
    @other_user = create_user("other@example.com")
    @question = Question.create!(
      exam_number: 1,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_law",
      publication_status: "published",
      content_blocks: [{ type: "text", text: "教育基本法について正しいものを選びなさい。" }],
      explanation_blocks: [{ type: "text", text: "解説本文" }],
      source_text: "教育基本法第1条",
    )
    @choices = %w[ア イ ウ エ].map.with_index do |label, index|
      @question.question_choices.create!(
        choice_label: label,
        content_blocks: [{ type: "text", text: "選択肢#{label}" }],
        is_correct: index == 2,
        display_order: index + 1,
      )
    end
    @older_history = create_history(@user, @choices.first, 2.minutes.ago)
    @newer_history = create_history(@user, @choices.third, 1.minute.ago)
    create_history(@other_user, @choices.second, Time.current)
  end

  test "本人の回答履歴だけを新しい順に取得できる" do
    get api_v1_answer_histories_path, headers: authorization_header(@user)

    assert_response :success
    body = response.parsed_body
    assert_equal [@newer_history.id, @older_history.id], body.fetch("data").map { |item| item.fetch("id") }
    assert_equal 2, body.dig("meta", "total_count")
    assert_equal "教育基本法について正しいものを選びなさい。", body.dig("data", 0, "question", "body_excerpt")
  end

  test "回答履歴詳細で解説と正答を取得できる" do
    get api_v1_answer_history_path(@older_history), headers: authorization_header(@user)

    assert_response :success
    body = response.parsed_body.fetch("data")
    assert_equal "ウ", body.dig("correct_choice", "choice_label")
    assert_equal "解説本文", body.dig("explanation_blocks", 0, "text")
    assert_equal "教育基本法第1条", body.fetch("source_text")
  end

  test "別ユーザーの回答履歴は取得できない" do
    get api_v1_answer_history_path(@older_history), headers: authorization_header(@other_user)

    assert_response :not_found
  end

  test "未ログインでは回答履歴を取得できない" do
    get api_v1_answer_histories_path

    assert_response :unauthorized
  end

  test "問題削除時は回答履歴と選択肢も削除する" do
    assert_difference -> { AnswerHistory.count }, -3 do
      assert_difference -> { QuestionChoice.count }, -4 do
        @question.destroy!
      end
    end
  end

  private

  def create_user(email)
    User.create!(
      name: "学習ユーザー",
      email: email,
      password: "password123",
      password_confirmation: "password123",
    )
  end

  def create_history(user, choice, created_at)
    AnswerHistory.create!(
      user: user,
      question: @question,
      selected_choice: choice,
      is_correct: choice.is_correct,
      created_at: created_at,
      updated_at: created_at,
    )
  end

  def authorization_header(user)
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end
end

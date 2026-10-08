require "test_helper"

class Api::V1::QuestionsTest < ActionDispatch::IntegrationTest
  setup do
    @question = Question.create!(
      exam_number: 1,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_system",
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

  test "ログイン中の回答は履歴として保存する" do
    user = User.create!(
      name: "学習ユーザー",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    assert_difference -> { AnswerHistory.count }, 1 do
      post answer_api_v1_question_path(@question),
        params: { selected_choice_id: @choices.first.id },
        headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" },
        as: :json
    end

    assert_response :success
    history = AnswerHistory.last
    assert_equal user, history.user
    assert_equal @question, history.question
    assert_equal @choices.first, history.selected_choice
    assert_not history.is_correct
    assert_equal history.id, response.parsed_body.dig("data", "answer_history_id")
  end

  test "不正なアクセストークン付きの回答は匿名扱いにしない" do
    assert_no_difference -> { AnswerHistory.count } do
      post answer_api_v1_question_path(@question),
        params: { selected_choice_id: @choices.first.id },
        headers: { "Authorization" => "Bearer invalid-token" },
        as: :json
    end

    assert_response :unauthorized
  end

  test "別の問題の選択肢は回答に使えない" do
    another_question = Question.create!(
      exam_number: 2,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_system",
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
      category_code: "information_specialized",
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

  test "模擬試験6以降は未ログインでは取得できない" do
    premium_question = create_question(exam_number: 6)

    get api_v1_question_path(premium_question)

    assert_response :unauthorized
  end

  test "模擬試験6以降は無料会員では取得も回答もできない" do
    premium_question = create_question(exam_number: 6)
    user = create_user("free@example.com")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }

    get api_v1_question_path(premium_question), headers: headers
    assert_response :forbidden
    assert_equal "paid_membership_required", response.parsed_body.dig("error", "code")

    post answer_api_v1_question_path(premium_question),
      params: { selected_choice_id: premium_question.question_choices.first.id },
      headers: headers,
      as: :json
    assert_response :forbidden
  end

  test "有料会員は模擬試験6以降を取得できる" do
    premium_question = create_question(exam_number: 6)
    user = create_user("paid@example.com")
    payment = create_paid_payment(user)
    Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)

    get api_v1_question_path(premium_question),
      headers: { "Authorization" => "Bearer #{AuthToken.issue(user)}" }

    assert_response :success
    assert_equal premium_question.id, response.parsed_body.dig("data", "id")
  end

  test "試験指定なしの次問題取得は無料権限の範囲だけを候補にする" do
    premium_question = create_question(exam_number: 6)
    @question.destroy!

    get next_api_v1_questions_path

    assert_response :not_found
    assert premium_question.persisted?
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

  def create_question(exam_number:)
    question = Question.create!(
      exam_number: exam_number,
      question_number: 1,
      major_category_code: "teacher_education",
      category_code: "education_system",
      publication_status: "published",
      content_blocks: [{ type: "text", text: "有料問題" }],
      explanation_blocks: [{ type: "text", text: "解説" }],
    )
    %w[ア イ ウ エ].each_with_index do |label, index|
      question.question_choices.create!(
        choice_label: label,
        content_blocks: [{ type: "text", text: label }],
        is_correct: index.zero?,
        display_order: index + 1,
      )
    end
    question
  end

  def create_paid_payment(user)
    Payment.create!(
      user: user,
      stripe_checkout_session_id: "cs_#{user.id}",
      stripe_payment_intent_id: "pi_#{user.id}",
      stripe_price_id: "price_test",
      amount: 500,
      currency: "jpy",
      status: "paid",
      paid_at: Time.current,
    )
  end
end

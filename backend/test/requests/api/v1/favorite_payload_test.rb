require "test_helper"

class Api::V1::FavoritePayloadTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Payload user", email: "payload@example.invalid", password: "password123")
    @headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
  end

  test "プレミアム会員のログインとmeへ全件の公開問題の位置だけを同梱する" do
    payment = Payment.create!(user: @user, stripe_checkout_session_id: "cs_payload", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: @user, source_payment: payment, status: "active", activated_at: Time.current)
    questions = (0..100).map { |index| question(index) }
    questions.each { |item| Favorite.create!(user: @user, question: item) }
    Favorite.create!(user: @user, question: question(101, "private"))
    Favorite.create!(user: @user, question: question(102, "draft"))
    other = User.create!(name: "Other", email: "other-payload@example.invalid", password: "password123")
    Favorite.create!(user: other, question: question(103))
    expected = questions.map { |item| item.attributes.slice("id", "exam_number", "question_number") }

    post "/api/v1/auth/login", params: { email: @user.email, password: "password123" }, as: :json
    assert_response :ok
    assert_equal expected, response.parsed_body.dig("data", "user", "favorite_questions")

    queries = []
    capture = ->(*args) { queries << args.last[:sql] if args.last[:sql].match?(/FROM "favorites"/i) }
    ActiveSupport::Notifications.subscribed(capture, "sql.active_record") do
      get api_v1_me_path, headers: @headers
    end
    assert_response :ok
    assert_equal 1, queries.size
    assert_equal expected, response.parsed_body.dig("data", "favorite_questions")
    assert_equal 101, response.parsed_body.dig("data", "favorite_questions").size
  end

  test "無料会員の返却と問題取得ではお気に入りを照会しない" do
    item = question(0)
    Favorite.create!(user: @user, question: item)
    queries = []
    capture = ->(*args) { queries << args.last[:sql] if args.last[:sql].match?(/FROM "favorites"/i) }
    ActiveSupport::Notifications.subscribed(capture, "sql.active_record") do
      get api_v1_me_path, headers: @headers
      assert_response :ok
      assert_equal [], response.parsed_body.dig("data", "favorite_questions")
      get api_v1_question_path(item), headers: @headers
      assert_response :ok
      assert_equal false, response.parsed_body.dig("data", "is_favorite")
    end
    assert_empty queries
    assert Favorite.exists?(user: @user, question: item)
  end

  test "管理者へ同梱し失効後は空の一覧とする" do
    item = question(0)
    Favorite.create!(user: @user, question: item)
    @user.update!(role: "admin")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(@user)}" }
    get api_v1_me_path, headers: headers
    assert_response :ok
    assert_equal [item.attributes.slice("id", "exam_number", "question_number")], response.parsed_body.dig("data", "favorite_questions")
    @user.update!(role: "user")
    get api_v1_me_path, headers: @headers
    assert_response :ok
    assert_equal [], response.parsed_body.dig("data", "favorite_questions")
    assert Favorite.exists?(user: @user, question: item)
  end

  test "新規登録には空の一覧を返し未ログインではmeを返さない" do
    post "/api/v1/auth/signup", params: { name: "New", email: "new-payload@example.invalid", password: "password123", password_confirmation: "password123" }, as: :json
    assert_response :created
    assert_equal [], response.parsed_body.dig("data", "user", "favorite_questions")
    get api_v1_me_path
    assert_response :unauthorized
  end

  private

  def question(index, status = "published")
    Question.create!(exam_number: index / 20 + 1, question_number: index % 20 + 1,
      major_category_code: "teacher_education", category_code: "education_system", publication_status: status,
      content_blocks: [{ type: "text", text: "Question" }], explanation_blocks: [{ type: "text", text: "Explanation" }])
  end
end

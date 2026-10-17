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
    payment = Payment.create!(user: @user, stripe_checkout_session_id: "cs_favorites", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: @user, source_payment: payment, status: "active", activated_at: Time.current)
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
    assert_equal({ "current_page" => 1, "per_page" => 20, "total_count" => 1, "total_pages" => 1 }, response.parsed_body.fetch("meta"))

    delete "/api/v1/questions/#{@free_question.id}/favorite", headers: @headers
    assert_response :no_content
    assert_not Favorite.exists?(user: @user, question: @free_question)
  end

  test "登録済みの問題は200で同じお気に入りを返す" do
    put api_v1_question_favorite_path(@free_question), headers: @headers
    assert_response :created
    favorite_id = response.parsed_body.dig("data", "id")

    assert_no_difference "Favorite.count" do
      put api_v1_question_favorite_path(@free_question), headers: @headers
      assert_response :ok
      assert_equal favorite_id, response.parsed_body.dig("data", "id")
    end
  end

  test "本人の公開問題だけを新しい順にページ分割する" do
    timestamp = Time.current
    favorites = (1..20).map do |number|
      question = number == 1 ? @free_question : create_question(1, question_number: number)
      Favorite.create!(user: @user, question: question, created_at: timestamp)
    end
    favorites << Favorite.create!(user: @user, question: create_question(2), created_at: timestamp)
    Favorite.create!(user: @user, question: create_question(3, publication_status: "private"))
    other_user = User.create!(name: "別ユーザー", email: "other@example.com", password: "password123")
    Favorite.create!(user: other_user, question: @free_question)

    get api_v1_favorites_path, headers: @headers
    assert_response :ok
    assert_equal favorites.reverse.first(20).map(&:id), response.parsed_body.fetch("data").map { |item| item.fetch("id") }
    assert_equal 21, response.parsed_body.dig("meta", "total_count")
    assert_equal 2, response.parsed_body.dig("meta", "total_pages")

    get api_v1_favorites_path, params: { page: 2 }, headers: @headers
    assert_response :ok
    assert_equal [favorites.first.id], response.parsed_body.fetch("data").map { |item| item.fetch("id") }
    assert_equal 2, response.parsed_body.dig("meta", "current_page")

    get api_v1_favorites_path, params: { page: 3, per_page: 10 }, headers: @headers
    assert_response :ok
    assert_equal 10, response.parsed_body.dig("meta", "per_page")
    assert_equal 3, response.parsed_body.dig("meta", "total_pages")

    get api_v1_favorites_path, params: { page: 4 }, headers: @headers
    assert_response :ok
    assert_empty response.parsed_body.fetch("data")
  end

  test "空の一覧でもページ情報を返す" do
    get api_v1_favorites_path, headers: @headers
    assert_response :ok
    assert_empty response.parsed_body.fetch("data")
    assert_equal 0, response.parsed_body.dig("meta", "total_count")
    assert_equal 0, response.parsed_body.dig("meta", "total_pages")
  end

  test "不正なページ指定は400になる" do
    [{ page: 0 }, { page: -1 }, { page: "abc" }, { per_page: 0 }, { per_page: 101 }, { per_page: "1.5" }].each do |query|
      get api_v1_favorites_path, params: query, headers: @headers
      assert_response :bad_request
      assert_equal "bad_request", response.parsed_body.dig("error", "code")
    end
    get api_v1_favorites_path, params: { per_page: 100 }, headers: @headers
    assert_response :ok
  end

  test "未ログインでは一覧取得も登録もできない" do
    get api_v1_favorites_path
    assert_response :unauthorized
    put api_v1_question_favorite_path(@free_question)
    assert_response :unauthorized
  end

  test "資格失効時は無料問題を含む全操作を拒否し既存データを保持する" do
    @user.membership.update!(status: "revoked")
    Favorite.create!(user: @user, question: @free_question)
    Favorite.create!(user: @user, question: @premium_question)

    assert_no_difference "Favorite.count" do
      get api_v1_favorites_path, headers: @headers
      assert_response :forbidden
      assert_equal "paid_membership_required", response.parsed_body.dig("error", "code")
      [@free_question, @premium_question].each do |question|
        put api_v1_question_favorite_path(question), headers: @headers
        assert_response :forbidden
        delete api_v1_question_favorite_path(question), headers: @headers
        assert_response :forbidden
      end
    end

    @user.membership.update!(status: "active")
    get api_v1_favorites_path, headers: @headers
    assert_response :ok
    assert_equal 2, response.parsed_body.fetch("data").size
  end

  test "購入歴のない無料会員も全操作を拒否し管理者は購入せず利用できる" do
    free_user = User.create!(name: "無料ユーザー", email: "free@example.com", password: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(free_user)}" }
    get api_v1_favorites_path, headers: headers
    assert_response :forbidden
    put api_v1_question_favorite_path(@free_question), headers: headers
    assert_response :forbidden
    delete api_v1_question_favorite_path(@free_question), headers: headers
    assert_response :forbidden

    free_user.update!(role: "admin")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(free_user)}" }
    put api_v1_question_favorite_path(@premium_question), headers: headers
    assert_response :created
    get api_v1_favorites_path, headers: headers
    assert_response :ok
    delete api_v1_question_favorite_path(@premium_question), headers: headers
    assert_response :no_content
  end

  private

  def create_question(exam_number, question_number: 1, publication_status: "published")
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

require "test_helper"

class MockExams26To30PublicationTest < ActionDispatch::IntegrationTest
  EXAMS = (26..30).to_a.freeze
  NUMBERS = (1..20).to_a.freeze
  PREVIOUS_DRAFT_NUMBERS = ((3..15).to_a + [19, 20]).freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") }
    end
  end

  test "承認済み五セットは二十問各四択一正答各位置五件で公開する" do
    assert_equal 100, @entries.size
    assert_equal 100, @entries.map { |entry| [entry[:exam_number], entry[:attributes][:question_number]] }.uniq.size
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry.fetch(:exam_number) == exam }
      assert_equal NUMBERS, entries.map { |entry| entry.fetch(:attributes).fetch(:question_number) }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct_choice(entry).fetch(:label) }.tally, exam
      entries.each do |entry|
        attributes = entry.fetch(:attributes)
        id = key(entry)
        assert_equal "published", entry.fetch(:publication_status), id
        assert_equal LABELS, attributes.fetch(:choices).map { |choice| choice.fetch(:label) }, id
        assert_equal 1, attributes.fetch(:choices).count { |choice| choice.fetch(:correct) }, id
        assert attributes.fetch(:content_blocks).present?, id
        assert attributes.fetch(:explanation_blocks).present?, id
        assert attributes.fetch(:source_text).lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
        assert_equal attributes.fetch(:question_number) <= 15 ? "teacher_education" : "information", attributes.fetch(:major_category_code), id
        if [1, 2].include?(attributes.fetch(:question_number))
          assert_equal "education_foundations", attributes.fetch(:category_code), id
        end
        preview = QuestionSeedSync.preview(entry)
        choices = QuestionPayload.from_seed(entry[:exam_number], attributes).fetch("choices").map(&:symbolize_keys)
        QuestionWriter.validate_choices!(preview, choices)
        QuestionWriter.validate_publication!(preview, choices)
      end
    end
  end

  test "完成seedから必要な問を欠落させるとDB書込み前に拒否する" do
    EXAMS.each do |exam|
      path = Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb")
      source = File.read(path)
      assert_includes source, "unless questions.map"
      [1, 2, 16, 17, 18].each do |number|
        mutation = "questions.reject! { |question| question[:question_number] == #{number} }\n"
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
          assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
            QuestionSeedSync.collect { eval(source.sub("unless questions.map", mutation + "unless questions.map"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "全百問の公開導線は有料認可を維持し回答前秘匿と全四択の判定及び解説出典を返す" do
    save_entries(@entries)
    assert_equal 100, Question.where(exam_number: EXAMS, publication_status: "published").count
    assert_equal 400, QuestionChoice.joins(:question).where(questions: { exam_number: EXAMS }).count
    paid = user_headers("paid", paid: true)
    free = user_headers("free")
    admin = user_headers("admin", role: "admin")

    [[nil, "paid_membership_required"], [free, "paid_membership_required"], [paid, "available"], [admin, "available"]].each do |headers, access|
      get api_v1_exams_path, headers: headers
      assert_response :success
      assert_no_public_answers(response.parsed_body)
      data = response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam.fetch("exam_number")) }
      assert_equal EXAMS, data.map { |exam| exam.fetch("exam_number") }
      data.each do |exam|
        assert_equal 20, exam.fetch("published_question_count")
        assert_equal NUMBERS, exam.fetch("question_numbers")
        assert_equal access, exam.fetch("access")
      end
    end

    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 16)
      [[nil, :unauthorized], [free, :forbidden]].each do |headers, status|
        get api_v1_question_path(record), headers: headers
        assert_response status
        assert_no_public_answers(response.parsed_body)
        assert_equal "paid_membership_required", response.parsed_body.dig("error", "code") if status == :forbidden
        get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 15 }, headers: headers
        assert_response status
        assert_no_public_answers(response.parsed_body)
        assert_no_difference "AnswerHistory.count" do
          post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.first.id }, headers: headers, as: :json
        end
        assert_response status
        assert_no_public_answers(response.parsed_body)
      end
      [paid, admin].each do |headers|
        get api_v1_question_path(record), headers: headers
        assert_response :success
        assert_equal record.content_blocks, response.parsed_body.dig("data", "content_blocks")
        assert_no_public_answers(response.parsed_body)
        get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 15 }, headers: headers
        assert_response :success
        assert_equal [exam, 16], response.parsed_body.fetch("data").values_at("exam_number", "question_number")
        assert_no_public_answers(response.parsed_body)
      end
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "published" }, headers: admin
      assert_response :success
      assert_equal 20, response.parsed_body.dig("meta", "total_count")
      assert_equal NUMBERS, response.parsed_body.fetch("data").map { |question| question.fetch("question_number") }
    end

    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      # Verify every choice, not request volume. Keep real limiter behavior but
      # reset this isolated test's temporary counters for each question.
      ApiRateLimitBucket.delete_all
      get next_api_v1_questions_path, params: { exam_number: record.exam_number, after_question_number: record.question_number - 1 }, headers: paid
      assert_response :success
      assert_equal [record.exam_number, record.question_number], response.parsed_body.fetch("data").values_at("exam_number", "question_number"), key(entry)
      assert_no_public_answers(response.parsed_body)
      get api_v1_question_path(record), headers: paid
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal record.content_blocks, data.fetch("content_blocks"), key(entry)
      assert_equal LABELS, data.fetch("choices").map { |choice| choice.fetch("choice_label") }, key(entry)
      assert_equal record.question_choices.map(&:content_blocks), data.fetch("choices").map { |choice| choice.fetch("content_blocks") }, key(entry)
      assert_no_public_answers(response.parsed_body)
      correct = record.question_choices.find_by!(is_correct: true)
      record.question_choices.each do |choice|
        assert_difference "AnswerHistory.count", 1 do
          post answer_api_v1_question_path(record), params: { selected_choice_id: choice.id }, headers: paid, as: :json
        end
        assert_response :success
        answer = response.parsed_body.fetch("data")
        assert_equal choice.id, answer.fetch("selected_choice_id"), key(entry)
        assert_equal choice.id == correct.id, answer.fetch("is_correct"), "#{key(entry)} #{choice.choice_label}"
        assert_equal correct.id, answer.dig("correct_choice", "id"), key(entry)
        assert_equal correct.choice_label, answer.dig("correct_choice", "choice_label"), key(entry)
        assert_equal record.explanation_blocks, answer.fetch("explanation_blocks"), key(entry)
        assert_equal record.source_text, answer.fetch("source_text"), key(entry)
        assert AnswerHistory.exists?(id: answer.fetch("answer_history_id"), question_id: record.id, selected_choice_id: choice.id), key(entry)
      end
    end
    assert_equal 400, AnswerHistory.count
    EXAMS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 20 }, headers: paid
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
  end

  test "既存七十五問の公開切替は内容ID履歴お気に入りを保持し二回同期も管理訂正非公開削除も上書きしない" do
    previous = @entries.select { |entry| PREVIOUS_DRAFT_NUMBERS.include?(entry[:attributes][:question_number]) }
      .map { |entry| entry.merge(publication_status: "draft") }
    save_entries(previous)
    load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_1.rb")
    assert_equal 75, Question.where(exam_number: EXAMS, publication_status: "draft").count
    user = User.create!(name: "公開切替保持確認", email: "mock26-publication-preserve@example.com", password: "password123", password_confirmation: "password123")
    [[1, 1], [26, 3], [26, 19], [30, 20]].each do |exam, number|
      record = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
    end
    original_questions = Question.where(exam_number: 1).order(:id).map(&:attributes)
    original_choices = QuestionChoice.joins(:question).where(questions: { exam_number: 1 }).order(:id).map(&:attributes)
    old_records = previous.to_h do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      [key(entry), { id: record.id, payload: QuestionPayload.from_record(record), choices: record.question_choices.pluck(:id), created_at: record.created_at }]
    end
    old_states = QuestionSeedState.where(exam_number: EXAMS).to_h do |state|
      ["#{state.exam_number}-#{state.question_number}", state.attributes.except("seed_publication_status", "updated_at")]
    end
    old_histories = AnswerHistory.order(:id).map(&:attributes)
    old_favorites = Favorite.order(:id).map(&:attributes)
    assert_difference ["Question.count", "QuestionSeedState.count"], 25 do
      assert_difference "QuestionChoice.count", 100 do
        assert_no_difference ["AnswerHistory.count", "Favorite.count"] do
          save_entries(@entries)
        end
      end
    end
    assert_equal 100, Question.where(exam_number: EXAMS, publication_status: "published").count
    old_records.each do |id, old|
      exam, number = id.split("-").map(&:to_i)
      record = Question.find_by!(exam_number: exam, question_number: number)
      assert_equal old.fetch(:id), record.id, id
      assert_equal old.fetch(:payload), QuestionPayload.from_record(record), id
      assert_equal old.fetch(:choices), record.question_choices.pluck(:id), id
      assert_equal old.fetch(:created_at), record.created_at, id
      state = QuestionSeedState.find_by!(exam_number: exam, question_number: number)
      assert_equal old_states.fetch(id), state.attributes.except("seed_publication_status", "updated_at"), id
      assert_equal "published", state.seed_publication_status, id
    end
    assert_equal original_questions, Question.where(exam_number: 1).order(:id).map(&:attributes)
    assert_equal original_choices, QuestionChoice.joins(:question).where(questions: { exam_number: 1 }).order(:id).map(&:attributes)
    assert_equal old_histories, AnswerHistory.order(:id).map(&:attributes)
    assert_equal old_favorites, Favorite.order(:id).map(&:attributes)
    unchanged = snapshot
    2.times do
      save_entries(@entries)
      assert_equal unchanged, snapshot
    end

    edited = Question.find_by!(exam_number: 26, question_number: 1)
    QuestionWriter.save!(edited, QuestionPayload.from_record(edited).merge("content_blocks" => [{ "type" => "text", "text" => "管理画面で訂正した文面" }], "publication_status" => "published"))
    hidden = Question.find_by!(exam_number: 27, question_number: 1)
    hidden.update!(publication_status: "private")
    removed = Question.find_by!(exam_number: 28, question_number: 1)
    QuestionWriter.destroy!(removed)
    # Historical catalog tests recreate the retired deletion bookkeeping.
    # The current application writer deliberately does not update seed state.
    QuestionSeedState.find_by!(exam_number: 28, question_number: 1).update!(deleted: true)
    managed = snapshot
    2.times do
      save_entries(@entries)
      assert_equal managed, snapshot
    end
    assert_equal "管理画面で訂正した文面", edited.reload.content_blocks.first.fetch("text")
    assert_equal "private", hidden.reload.publication_status
    assert_not Question.exists?(exam_number: 28, question_number: 1)
    assert QuestionSeedState.find_by!(exam_number: 28, question_number: 1).deleted?
    assert_equal old_histories, AnswerHistory.order(:id).map(&:attributes)
    assert_equal old_favorites, Favorite.order(:id).map(&:attributes)
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def correct_choice(entry)
    entry.fetch(:attributes).fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def save_entries(entries)
    QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def user_headers(label, paid: false, role: "user")
    user = User.create!(name: "公開確認#{label}", email: "mock26-publication-#{label}@example.com", role: role, password: "password123", password_confirmation: "password123")
    if paid
      payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_mock26_publication_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
      user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    end
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end

  def assert_no_public_answers(value)
    case value
    when Hash
      assert_empty value.keys & %w[is_correct correct_choice explanation_blocks source_text]
      value.each_value { |child| assert_no_public_answers(child) }
    when Array
      value.each { |child| assert_no_public_answers(child) }
    end
  end

  def snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  end
end

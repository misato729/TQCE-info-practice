require "test_helper"

class QuestionUpdatesTest < ActiveSupport::TestCase
  setup do
    @attributes = {
      exam_number: 90, question_number: 1, major_category_code: "teacher_education", category_code: "education_foundations",
      publication_status: "published",
      content_blocks: [{ type: "text", text: "問題" }], explanation_blocks: [{ type: "text", text: "解説" }],
      source_text: "資料 | https://example.invalid/source",
      choices: %w[ア イ ウ エ].map.with_index do |label, index|
        { choice_label: label, is_correct: index.zero?, display_order: index + 1,
          content_blocks: [{ type: "text", text: "選択肢#{label}" }] }
      end,
    }
    @question = QuestionWriter.save!(Question.new, @attributes)
  end

  test "no-op db seed preserves database content visibility histories and favorites" do
    admin_save(content_blocks: [{ type: "text", text: "管理者訂正" }], publication_status: "private")
    history = make_history
    Favorite.create!(user: history.user, question: @question)
    before = snapshot

    2.times { load Rails.root.join("db/seeds.rb") }

    assert_equal before, snapshot
    assert_equal "管理者訂正", @question.reload.content_blocks.first["text"]
    assert_equal "private", @question.publication_status
  end

  test "admin content updates retain the currently selected publication status" do
    admin_save(publication_status: "private")
    admin_save(explanation_blocks: [{ type: "text", text: "新解説" }])

    assert_equal "新解説", @question.reload.explanation_blocks.first["text"]
    assert_equal "private", @question.publication_status
  end

  test "visibility-only edits retain content histories question ids choice ids and favorites" do
    admin_save(content_blocks: [{ type: "text", text: "管理者訂正" }])
    history = make_history
    favorite = Favorite.create!(user: history.user, question: @question)
    id = @question.id
    choice_ids = @question.question_choices.pluck(:id)
    history_before = history.attributes
    favorite_before = favorite.attributes

    %w[private draft].each do |status|
      admin_save(publication_status: status)

      assert_equal id, @question.reload.id
      assert_equal choice_ids, @question.question_choices.pluck(:id)
      assert_equal "管理者訂正", @question.content_blocks.first["text"]
      assert_equal status, @question.publication_status
      assert_equal history_before, history.reload.attributes
      assert_equal favorite_before, favorite.reload.attributes
    end
  end

  test "database edits remain canonical after repeated no-op seed executions" do
    admin_save(content_blocks: [{ type: "text", text: "最初の管理者訂正" }])
    load Rails.root.join("db/seeds.rb")
    admin_save(content_blocks: [{ type: "text", text: "次の管理者訂正" }])
    load Rails.root.join("db/seeds.rb")

    assert_equal "次の管理者訂正", @question.reload.content_blocks.first["text"]
    assert_equal 1, Question.where(exam_number: 90, question_number: 1).count
  end

  test "deleted questions are not recreated and unrelated records are retained" do
    history = make_history
    favorite = Favorite.create!(user: history.user, question: @question)
    other = QuestionWriter.save!(Question.new, @attributes.deep_dup.merge(question_number: 2))
    other_history = history.user.answer_histories.create!(question: other,
      selected_choice: other.question_choices.find_by!(is_correct: true), is_correct: true)
    other_favorite = Favorite.create!(user: history.user, question: other)
    other_before = [other.attributes, other.question_choices.map(&:attributes), other_history.attributes, other_favorite.attributes]
    question_id = @question.id
    choice_ids = @question.question_choices.pluck(:id)

    QuestionWriter.destroy!(@question)
    2.times { load Rails.root.join("db/seeds.rb") }

    assert_not Question.exists?(question_id)
    assert_not Question.exists?(exam_number: 90, question_number: 1)
    assert_not QuestionChoice.where(id: choice_ids).exists?
    assert_not AnswerHistory.exists?(history.id)
    assert_not Favorite.exists?(favorite.id)
    assert_equal other_before, [other.reload.attributes, other.question_choices.reload.map(&:attributes),
      other_history.reload.attributes, other_favorite.reload.attributes]
  end

  test "material admin edits invalidate histories but retain question choice ids and favorites" do
    history = make_history
    favorite = Favorite.create!(user: history.user, question: @question)
    id = @question.id
    choice_ids = @question.question_choices.pluck(:id)
    favorite_before = favorite.attributes
    admin_save(publication_status: "private")
    assert AnswerHistory.exists?(history.id)
    changes = [
      { content_blocks: [{ type: "text", text: "別問題" }] },
      { explanation_blocks: [{ type: "text", text: "別解説" }] },
      { source_text: "別資料 | https://example.invalid/other" },
      { category_code: "education_system" },
    ]
    changes.each do |change|
      history = make_history
      admin_save(**change)

      assert_not AnswerHistory.exists?(history.id)
      assert_equal id, @question.reload.id
      assert_equal choice_ids, @question.question_choices.pluck(:id)
      assert_equal favorite_before, favorite.reload.attributes
    end
  end

  test "choice edits invalidate histories while unchanged admin saves preserve them" do
    history = make_history
    choice_ids = @question.question_choices.pluck(:id)
    2.times { admin_save }
    assert AnswerHistory.exists?(history.id)

    attrs = admin_attributes
    attrs["choices"][0]["content_blocks"] = [{ "type" => "text", "text" => "訂正した選択肢" }]
    QuestionWriter.save!(@question, attrs)
    assert_not AnswerHistory.exists?(history.id)
    history = make_history
    attrs = admin_attributes
    attrs["choices"].each { |choice| choice["is_correct"] = choice["choice_label"] == "ウ" }
    QuestionWriter.save!(@question, attrs)

    assert_not AnswerHistory.exists?(history.id)
    assert_equal choice_ids, @question.question_choices.pluck(:id)
    assert_equal "ウ", @question.question_choices.find_by!(is_correct: true).choice_label
  end

  test "invalid published edits roll back content choices histories and favorites" do
    history = make_history
    Favorite.create!(user: history.user, question: @question)
    before = snapshot
    invalid = [
      { content_blocks: [{ type: "text", text: " " }] },
      { explanation_blocks: [] },
      { source_text: "出典なし" },
      { source_text: "資料 | https://user:password@example.invalid/" },
    ]
    invalid.each do |change|
      assert_raises(ActiveRecord::RecordInvalid) { admin_save(**change) }
      @question.reload
      assert_equal before, snapshot
    end
  end

  test "draft content can be incomplete but choices must remain structurally valid" do
    admin_save(publication_status: "draft", content_blocks: [{ type: "text", text: "" }], source_text: nil)
    assert_equal "draft", @question.reload.publication_status
    assert_raises(ActiveRecord::RecordInvalid) { admin_save(publication_status: "published") }
    @question.reload
    attrs = admin_attributes
    attrs["choices"].pop
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    assert_equal 4, @question.reload.question_choices.count
  end

  test "duplicate labels and ids and foreign ids are rejected" do
    attrs = admin_attributes
    attrs["choices"].each { |choice| choice["choice_label"] = "ア" }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs = admin_attributes
    attrs["choices"].each { |choice| choice["id"] = @question.question_choices.first.id }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs = admin_attributes
    attrs["choices"][0]["id"] = -1
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
  end

  test "fill in labels and cells must agree" do
    attrs = admin_attributes
    attrs["content_blocks"] = [{ "type" => "fill_in_quote", "text" => "本文{{①}}、{{②}}。" }]
    attrs["choices"].each { |choice| choice["content_blocks"] = [{ "type" => "fill_in_choice", "cells" => ["語句"] }] }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs["choices"].each { |choice| choice["content_blocks"][0]["cells"] = ["語句", "別語"] }
    QuestionWriter.save!(@question, attrs)
    assert_equal "published", @question.publication_status
  end

  test "renumbering keeps record identity and favorites and invalidates previous histories" do
    # The physical historical table remains during the rolling transition.
    # Its existing rows must not constrain or be modified by the new writer.
    legacy_state = QuestionSeedState.create!(exam_number: 90, question_number: 1,
      seed_digest: QuestionPayload.digest(QuestionPayload.from_record(@question)), seed_publication_status: "published")
    state_before = legacy_state.attributes
    history = make_history
    favorite = Favorite.create!(user: history.user, question: @question)
    id = @question.id
    choice_ids = @question.question_choices.pluck(:id)
    favorite_before = favorite.attributes

    admin_save(exam_number: 91, question_number: 2, publication_status: "draft")

    assert_equal id, @question.reload.id
    assert_equal 91, @question.exam_number
    assert_equal 2, @question.question_number
    assert_equal choice_ids, @question.question_choices.pluck(:id)
    assert_equal favorite_before, favorite.reload.attributes
    assert_not AnswerHistory.exists?(history.id)
    assert_equal state_before, legacy_state.reload.attributes
    assert_no_difference("QuestionSeedState.count") { QuestionWriter.destroy!(@question) }
    assert_equal state_before, legacy_state.reload.attributes
    assert_not Question.exists?(exam_number: 90, question_number: 1)
  end

  test "a failed admin edit rolls back preceding edits in the same transaction" do
    other = QuestionWriter.save!(Question.new, @attributes.deep_dup.merge(question_number: 2))
    history = make_history
    Favorite.create!(user: history.user, question: @question)
    before = snapshot
    invalid = QuestionPayload.from_record(other).merge("publication_status" => "published", "source_text" => "出典なし")

    assert_raises(ActiveRecord::RecordInvalid) do
      QuestionWriter.transaction do
        admin_save(explanation_blocks: [{ type: "text", text: "ロールバックされる解説" }])
        QuestionWriter.save!(other, invalid)
      end
    end

    assert_equal before, snapshot
    assert_equal "解説", @question.reload.explanation_blocks.first["text"]
    assert AnswerHistory.exists?(history.id)
  end

  test "moving to an occupied position rejects the change without losing existing data" do
    QuestionWriter.save!(Question.new, @attributes.deep_dup.merge(question_number: 2))
    history = make_history
    Favorite.create!(user: history.user, question: @question)
    before = snapshot

    assert_raises(ActiveRecord::RecordInvalid) { admin_save(question_number: 2) }

    assert_equal before, snapshot
    assert_equal 1, @question.reload.question_number
  end

  private

  def admin_attributes
    QuestionPayload.from_record(@question).merge("publication_status" => @question.publication_status)
  end

  def admin_save(**changes)
    QuestionWriter.save!(@question, admin_attributes.merge(changes.stringify_keys))
  end

  def make_history
    user = User.find_or_create_by!(email: "update-check@example.invalid") { |record| record.name = "検証"; record.password = "test-only-password" }
    user.answer_histories.create!(question: @question, selected_choice: @question.question_choices.find_by!(is_correct: true), is_correct: true)
  end

  def snapshot
    [Question, QuestionChoice, AnswerHistory, Favorite, User].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  end
end

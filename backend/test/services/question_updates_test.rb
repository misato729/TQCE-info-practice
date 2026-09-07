require "test_helper"

class QuestionUpdatesTest < ActiveSupport::TestCase
  setup do
    @seed = {
      question_number: 1, major_category_code: "teacher_education", category_code: "education_foundations",
      content_blocks: [{ type: "text", text: "問題" }], explanation_blocks: [{ type: "text", text: "解説" }],
      source_text: "資料 | https://example.invalid/source",
      choices: %w[ア イ ウ エ].map.with_index { |label, i| { label: label, correct: i.zero?, content_blocks: [{ type: "text", text: "選択肢#{label}" }] } },
    }
    sync
    @question = Question.find_by!(exam_number: 90, question_number: 1)
  end

  test "unchanged seeds retain manual content and visibility" do
    admin_save(content_blocks: [{ type: "text", text: "管理者訂正" }], publication_status: "private")
    assert_no_difference(["Question.count", "QuestionChoice.count"]) { 2.times { sync } }
    assert_equal "管理者訂正", @question.reload.content_blocks.first["text"]
    assert_equal "private", @question.publication_status
  end

  test "seed content updates preserve a manually changed publication status" do
    admin_save(publication_status: "private")
    @seed[:explanation_blocks] = [{ type: "text", text: "新解説" }]
    sync
    assert_equal "新解説", @question.reload.explanation_blocks.first["text"]
    assert_equal "private", @question.publication_status
  end

  test "seed visibility-only updates preserve manual content and histories" do
    admin_save(content_blocks: [{ type: "text", text: "管理者訂正" }])
    history = make_history
    QuestionSeedSync.call(exam_number: 90, attributes: @seed, publication_status: "private")
    assert_equal "管理者訂正", @question.reload.content_blocks.first["text"]
    assert_equal "private", @question.publication_status
    assert AnswerHistory.exists?(history.id)
  end

  test "concurrent admin and seed changes fail without overwriting either" do
    admin_save(content_blocks: [{ type: "text", text: "管理者訂正" }])
    previous_digest = QuestionSeedState.find_by!(exam_number: 90).seed_digest
    @seed[:content_blocks] = [{ type: "text", text: "seed訂正" }]
    assert_raises(QuestionSeedSync::Conflict) { sync }
    assert_equal "管理者訂正", @question.reload.content_blocks.first["text"]
    assert_equal previous_digest, QuestionSeedState.find_by!(exam_number: 90).seed_digest
  end

  test "deleted questions are not recreated by changed or unchanged seeds" do
    QuestionWriter.destroy!(@question)
    sync
    @seed[:content_blocks] = [{ type: "text", text: "seed訂正" }]
    sync
    assert_not Question.exists?(exam_number: 90, question_number: 1)
  end

  test "material changes through either writer invalidate histories but status only does not" do
    history = make_history
    admin_save(publication_status: "private")
    assert AnswerHistory.exists?(history.id)
    changes = [
      { content_blocks: [{ type: "text", text: "別問題" }] },
      { explanation_blocks: [{ type: "text", text: "別解説" }] },
      { source_text: "別資料 | https://example.invalid/other" },
    ]
    changes.each do |change|
      history = make_history
      admin_save(**change)
      assert_not AnswerHistory.exists?(history.id)
    end
    history = make_history
    attrs = admin_attributes
    attrs["choices"].each { |c| c["is_correct"] = c["choice_label"] == "イ" }
    QuestionWriter.save!(@question, attrs)
    assert_not AnswerHistory.exists?(history.id)
  end

  test "choice-only seed changes invalidate histories and unchanged reruns preserve them" do
    history = make_history
    sync
    assert AnswerHistory.exists?(history.id)
    @seed[:choices][0][:content_blocks] = [{ type: "text", text: "訂正した選択肢" }]
    sync
    assert_not AnswerHistory.exists?(history.id)
    history = make_history
    @seed[:choices].each { |c| c[:correct] = c[:label] == "ウ" }
    sync
    assert_not AnswerHistory.exists?(history.id)
  end

  test "invalid published writes roll back content choices and histories" do
    history = make_history
    invalid = [
      { content_blocks: [{ type: "text", text: " " }] },
      { explanation_blocks: [] },
      { source_text: "出典なし" },
      { source_text: "資料 | https://user:password@example.invalid/" },
    ]
    invalid.each do |change|
      assert_raises(ActiveRecord::RecordInvalid) { admin_save(**change) }
      @question.reload
      assert_equal "問題", @question.content_blocks.first["text"]
      assert_equal 4, @question.question_choices.count
      assert AnswerHistory.exists?(history.id)
    end
  end

  test "draft content can be incomplete but choices must remain structurally valid" do
    admin_save(publication_status: "draft", content_blocks: [{ type: "text", text: "" }], source_text: nil)
    assert_equal "draft", @question.reload.publication_status
    assert_raises(ActiveRecord::RecordInvalid) { admin_save(publication_status: "published") }
  end

  test "duplicate labels and ids and foreign ids are rejected" do
    attrs = admin_attributes
    attrs["choices"].each { |c| c["choice_label"] = "ア" }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs = admin_attributes
    attrs["choices"].each { |c| c["id"] = @question.question_choices.first.id }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs = admin_attributes
    attrs["choices"][0]["id"] = -1
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
  end

  test "fill in labels and cells must agree" do
    attrs = admin_attributes
    attrs["content_blocks"] = [{ "type" => "fill_in_quote", "text" => "本文{{①}}、{{②}}。" }]
    attrs["choices"].each { |c| c["content_blocks"] = [{ "type" => "fill_in_choice", "cells" => ["語句"] }] }
    assert_raises(ActiveRecord::RecordInvalid) { QuestionWriter.save!(@question, attrs) }
    @question.reload
    attrs["choices"].each { |c| c["content_blocks"][0]["cells"] = ["語句", "別語"] }
    QuestionWriter.save!(@question, attrs)
    assert_equal "published", @question.publication_status
  end

  test "legacy bootstrap preserves existing edits and detects a subsequent seed conflict" do
    entries = QuestionSeedSync.collect { load Rails.root.join("db/seeds/mock_exam_11.rb") }
    entry = entries.first
    payload = QuestionPayload.from_seed(11, entry.fetch(:attributes)).merge("publication_status" => "draft")
    question = QuestionWriter.save!(Question.new, payload)
    payload["content_blocks"] = [{ "type" => "text", "text" => "移行前の管理者訂正" }]
    QuestionWriter.save!(question, payload)
    QuestionSeedSync.call(**entry)
    assert_equal "移行前の管理者訂正", question.reload.content_blocks.first["text"]
    modified = entry.deep_dup
    modified[:attributes][:content_blocks] = [{ type: "text", text: "別のseed訂正" }]
    assert_raises(QuestionSeedSync::Conflict) { QuestionSeedSync.call(**modified) }
  end

  test "a conflict rolls back preceding updates in the same seed transaction" do
    other = @seed.deep_dup.merge(question_number: 2)
    QuestionSeedSync.call(exam_number: 90, attributes: other, publication_status: "published")
    question = Question.find_by!(exam_number: 90, question_number: 2)
    attributes = QuestionPayload.from_record(question).merge("publication_status" => "published", "content_blocks" => [{ "type" => "text", "text" => "管理者訂正" }])
    QuestionWriter.save!(question, attributes)
    @seed[:explanation_blocks] = [{ type: "text", text: "ロールバックされる解説" }]
    other[:explanation_blocks] = [{ type: "text", text: "競合する解説" }]
    assert_raises(QuestionSeedSync::Conflict) do
      QuestionWriter.transaction do
        sync
        QuestionSeedSync.call(exam_number: 90, attributes: other, publication_status: "published")
      end
    end
    assert_equal "解説", @question.reload.explanation_blocks.first["text"]
  end

  private

  def sync
    QuestionSeedSync.call(exam_number: 90, attributes: @seed, publication_status: "published")
  end

  def admin_attributes
    QuestionPayload.from_record(@question).merge("publication_status" => @question.publication_status)
  end

  def admin_save(**changes)
    QuestionWriter.save!(@question, admin_attributes.merge(changes.stringify_keys))
  end

  def make_history
    user = User.find_or_create_by!(email: "update-check@example.invalid") { |u| u.name = "検証"; u.password = "test-only-password" }
    user.answer_histories.create!(question: @question, selected_choice: @question.question_choices.find_by!(is_correct: true), is_correct: true)
  end
end

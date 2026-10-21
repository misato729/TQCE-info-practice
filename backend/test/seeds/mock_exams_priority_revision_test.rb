require "test_helper"
require_relative "../support/priority_revision_20261017"

class MockExamsPriorityRevisionTest < ActionDispatch::IntegrationTest
  DATA = PriorityRevision20261017::DATA
  LABELS = %w[ア イ ウ エ].freeze
  PRIORITY = {
    4 => [5, 9], 5 => [11, 38], 6 => [5], 8 => [8, 10, 11, 14, 16, 25],
    9 => [10, 13, 15, 24], 10 => [8], 11 => [1, 7, 9], 12 => (1..10).to_a,
    13 => [4, 7, 8], 14 => [1, 2, 3, 4, 5, 7, 10], 15 => [1, 2, 5, 7, 10],
    16 => [1, 6, 9, 11, 12, 13, 14, 15], 17 => [3, 4, 7, 11, 12, 13, 14, 15],
    18 => [2, 3, 5, 6, 7, 8, 11, 12, 13, 14, 15],
  }.flat_map { |question, exams| exams.map { |exam| "#{exam}-#{question}" } }.sort.freeze
  RELATED = %w[1-3 2-3 1-4 2-4 3-4 1-5 3-5 2-7 1-10 6-13 15-13 9-14 1-13 2-13 3-13 5-13 3-16 2-17 1-19 3-19].freeze

  setup do
    @all = QuestionSeedSync.collect { (1..50).each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
      .map { |entry| ImprovementRevision20261017.historical_entry(entry) }
    @entries = @all.select { |entry| DATA.fetch("previous_entries").key?(key(entry)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "優先七十一問と明示した関連訂正以外を変更しない" do
    assert_equal "c518558a7eb7e6a90e6e287a20ea3034670a45463d01b83cc4beaecd5ef09cea",
      Digest::SHA256.file(Rails.root.join("test/fixtures/priority_revision_20261017.json")).hexdigest,
      "承認記録を自動再生成して未知の改変を取り込まない"
    assert_equal 1000, @all.size
    assert_equal 71, PRIORITY.size
    assert_equal PRIORITY, DATA.fetch("priority_keys").sort
    assert_equal (PRIORITY + RELATED).uniq.sort, @questions.keys.sort
    assert_equal @questions.keys.sort, DATA.fetch("revised_payload_digests").keys.sort
    @entries.each do |entry|
      id = key(entry)
      assert_equal DATA.fetch("revised_payload_digests").fetch(id), digest(entry), id
      assert_not_equal DATA.fetch("previous_payload_digests").fetch(id), digest(entry), id
      old = DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys
      fields = entry.fetch(:attributes).keys.select { |field| old.fetch(field) != entry[:attributes].fetch(field) }.map(&:to_s).sort
      assert_equal DATA.fetch("changed_fields").fetch(id).sort, fields, id
      assert_empty(fields - %w[content_blocks choices explanation_blocks source_text], id)
      if RELATED.include?(id) && !%w[2-17].include?(id)
        assert_equal old.fetch(:content_blocks), entry[:attributes].fetch(:content_blocks), id
        assert_equal old.fetch(:choices), entry[:attributes].fetch(:choices), id
      end
    end
    outside = @all.reject { |entry| @questions.key?(key(entry)) }
    assert_equal DATA.fetch("unchanged_count"), outside.size
    input = outside.map { |entry| [key(entry), digest(entry)] }.sort.map { |id, value| "#{id}|#{value}" }.join("\n")
    assert_equal DATA.fetch("unchanged_digest"), Digest::SHA256.hexdigest(input)
  end

  test "正答位置分類公開状態四択一正答全肢解説と五十セットの配分を維持する" do
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      old_entry = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      old = old_entry.fetch(:attributes)
      assert_equal old_entry.fetch(:publication_status), entry.fetch(:publication_status), id
      assert_equal old.slice(:question_number, :major_category_code, :category_code), question.slice(:question_number, :major_category_code, :category_code), id
      assert_equal correct(old).fetch(:label), correct(question).fetch(:label), id
      assert_equal LABELS, question.fetch(:choices).map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question.fetch(:choices).count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, question.fetch(:choices).map { |choice| choice.fetch(:content_blocks) }.uniq.size, id
      explanation = question.fetch(:explanation_blocks).filter_map { |block| block[:text] }.join("\n")
      LABELS.each { |label| assert_match(/#{label}(?:：|は|の|が)/, explanation, "#{id}: #{label}の説明") }
      assert question.fetch(:source_text).lines.all? { |line| QuestionWriter.valid_source?(line.strip) }, id
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    @all.group_by { |entry| entry.fetch(:exam_number) }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry[:attributes])[:label] }.tally, exam
    end
  end

  test "穴埋めは候補の出現頻度だけで正答を一意にしない" do
    PRIORITY.each do |id|
      question = @questions.fetch(id)
      next unless correct(question).fetch(:content_blocks).first[:type] == "fill_in_choice" || id == "7-15"
      rows = question.fetch(:choices).map { |choice| choice_cells(choice) }
      answer = choice_cells(correct(question))
      # Every value in a column has equal frequency (2:2 or 1:1:1:1).
      # This protects against the earlier all-unique-distractors majority trick.
      rows.transpose.each_with_index do |column, index|
        assert_equal 1, column.tally.values.uniq.size, "#{id}: 列#{index + 1} #{column.tally}"
        assert column.include?(answer[index]), id
      end
      assert_equal rows.size, rows.uniq.size, id
    end
    %w[1-16 12-17].each do |id|
      visible = text(@questions.fetch(id)[:content_blocks])
      choice_cells(correct(@questions.fetch(id))).each { |term| assert_not_includes visible, term, "#{id} 再掲による答えの露出" }
    end
    assert_operator text(@questions.fetch("1-16")[:content_blocks]).scan("{{②}}").size, :>=, 2
    assert_operator text(@questions.fetch("12-17")[:content_blocks]).scan("{{①}}").size, :>=, 2
  end

  test "歴史的承認への委譲は既知の現行照合値だけに限定する" do
    id = "5-4"
    current = @questions.fetch(id)
    assert_equal DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys,
      PriorityRevision20261017.historical_attributes(id, current)
    changed = current.deep_dup
    changed[:source_text] += "\n無断の再変更"
    assert_raises(RuntimeError) { PriorityRevision20261017.historical_attributes(id, changed) }
    outside = @all.find { |entry| key(entry) == "50-20" }.fetch(:attributes)
    assert_same outside, PriorityRevision20261017.historical_attributes("50-20", outside)
  end

  test "独立レビューで容易と判定した列を同時適用しても中心の判断が残る" do
    @questions.fetch("5-4").fetch(:choices).each do |choice|
      cells = choice_cells(choice)
      mandatory = ["校長", cells[0], "教諭", cells[1]]
      optional = [cells[2], "主幹教諭", "指導教諭", "主務教諭", "養護教諭", "栄養教諭", "養護助教諭", "実習助手", cells[3]]
      assert_empty mandatory & optional, "5-4 #{choice[:label]}: 後項の列挙だけで前項の誤答を除去させない"
    end
    {
      "8-8" => [[0, 1, 3], %w[イ ウ]],
      "25-8" => [[0, 2, 3], %w[イ エ]],
      "8-10" => [[0, 2, 3], %w[ア エ]],
      "11-5" => [[2, 3], %w[ア エ]],
      "38-5" => [[1, 2], %w[ア エ]],
      "5-18" => [[1, 2], %w[ア エ]],
    }.each do |id, (columns, labels)|
      question = @questions.fetch(id)
      easy = choice_cells(correct(question)).values_at(*columns)
      candidates = question.fetch(:choices).select { |choice| choice_cells(choice).values_at(*columns) == easy }
      assert_equal labels, candidates.map { |choice| choice.fetch(:label) }, id
    end
    assert_includes text(@questions.fetch("7-11")[:content_blocks]), "いじめ防止対策推進法を指す"
  end

  test "対象更新だけが履歴を無効化し問題ID選択肢IDお気に入りと再実行を保持する" do
    old = DATA.fetch("previous_entries").values.map(&:deep_symbolize_keys)
    untouched = @all.find { |entry| key(entry) == "50-20" }
    sync(old + [untouched])
    user = User.create!(name: "優先改稿検証", email: "priority-revision@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    records = Question.order(:id).to_a
    records.each do |record|
      Favorite.create!(user: user, question: record)
      choice = record.question_choices.find_by!(is_correct: true)
      AnswerHistory.create!(user: user, question: record, selected_choice: choice, is_correct: true)
    end
    ids = records.to_h { |record| [record.id, record.question_choices.order(:display_order).pluck(:id)] }
    assert_difference("AnswerHistory.count", -@entries.size) { sync(@entries) }
    assert_equal 1, AnswerHistory.count
    assert_equal Question.find_by!(exam_number: 50, question_number: 20).id, AnswerHistory.first.question_id
    assert_equal records.size, Favorite.count
    assert_equal ids, Question.order(:id).to_h { |record| [record.id, record.question_choices.order(:display_order).pluck(:id)] }
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      get api_v1_question_path(record), headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_equal record.question_choices.order(:display_order).map(&:content_blocks), data.fetch("choices").map { |choice| choice.fetch("content_blocks") }
      assert_not data.key?("explanation_blocks")
      assert_not data.key?("source_text")
      data.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }
      post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal record.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
    end
    before = snapshot
    2.times do
      assert_no_difference(["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"]) { sync(@entries) }
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  def digest(entry) = QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes]))
  def correct(question) = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  def choice_cells(choice)
    block = choice.fetch(:content_blocks).first
    block[:cells] || block.fetch(:text).split(/\s*／\s*/).map { |cell| cell.sub(/\A[①②③④⑤]：/, "") }
  end
  def text(blocks) = blocks.filter_map { |block| block[:text] }.join("\n")
  def sync(entries) = QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
end

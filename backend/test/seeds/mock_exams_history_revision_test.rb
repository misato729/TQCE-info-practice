require "test_helper"
require_relative "../support/history_revision_20261017"

class MockExamsHistoryRevisionTest < ActionDispatch::IntegrationTest
  DATA = HistoryRevision20261017::DATA
  KEYS = %w[1-2 2-2 5-2 7-1 7-2 8-1 8-2 9-1 9-2 10-1 10-2 12-1 12-2 13-1 13-2 14-2 15-2 41-2 45-2 47-2 49-2].freeze
  PRIORITY = %w[7-1 8-1 9-1 10-1 13-1 2-2 7-2 8-2 9-2 10-2 41-2 45-2 47-2 49-2].freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    @all = QuestionSeedSync.collect do
      (1..50).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @entries = @all.select { |entry| KEYS.include?(key(entry)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "改稿十四問と関連訂正七問以外の九百七十九問を独立した変更前照合値で保護する" do
    assert_equal 1000, @all.size
    assert_equal KEYS.sort, DATA.fetch("previous_entries").keys.sort
    assert_equal KEYS.sort, DATA.fetch("revised_payload_digests").keys.sort
    assert_equal KEYS.sort, @entries.map { |entry| key(entry) }.sort
    assert_equal PRIORITY.sort, DATA.fetch("priority_keys").sort
    outside = @all.reject { |entry| KEYS.include?(key(entry)) }
    assert_equal 979, outside.size
    # Later approved Q3..19 changes are checked independently, without rebasing
    # this original history-only approval or exempting unknown current edits.
    digest_input = outside.map do |entry|
      [key(entry), PriorityRevision20261017.historical_payload_digest(key(entry), entry[:exam_number], entry[:attributes])]
    end.sort.map { |id, digest| "#{id}|#{digest}" }.join("\n")
    assert_equal DATA.fetch("unchanged_979_digest"), Digest::SHA256.hexdigest(digest_input)
    @entries.each do |entry|
      id = key(entry)
      previous = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      assert_not_equal payload_digest(previous), payload_digest(entry), id
      assert_equal DATA.fetch("revised_payload_digests").fetch(id), payload_digest(entry), id
    end
  end

  test "正答位置形式分類公開状態全肢解説及び五十セットの正答配分を維持する" do
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      previous = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      original = previous.fetch(:attributes)
      assert_equal previous.fetch(:publication_status), entry.fetch(:publication_status), id
      assert_equal original.slice(:question_number, :major_category_code, :category_code), question.slice(:question_number, :major_category_code, :category_code), id
      assert_equal original.fetch(:content_blocks).map { |block| block.fetch(:type) }, question.fetch(:content_blocks).map { |block| block.fetch(:type) }, id
      assert_equal correct(original).fetch(:label), correct(question).fetch(:label), id
      assert_equal LABELS, question.fetch(:choices).map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question.fetch(:choices).count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, question.fetch(:choices).map { |choice| choice.fetch(:content_blocks) }.uniq.size, id
      explanation = text(question.fetch(:explanation_blocks))
      LABELS.each { |label| assert_match(/#{label}(?:：|は|の|が)/, explanation, "#{id} #{label}の説明") }
      assert question.fetch(:source_text).lines.all? { |line| QuestionWriter.valid_source?(line.strip) }, id
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry.fetch(:exam_number), question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    @all.group_by { |entry| entry.fetch(:exam_number) }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry.fetch(:attributes).fetch(:question_number) }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry.fetch(:attributes)).fetch(:label) }.tally, exam
    end
  end

  test "優先十四問の選択肢を実質改稿し出典訂正六問の設問と四択は維持する" do
    PRIORITY.each do |id|
      old = DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys
      assert_not_equal old.fetch(:choices), @questions.fetch(id).fetch(:choices), id
    end
    # 5-2 additionally narrows an ambiguous Rousseau option; do not mistake
    # that authorized precision edit for an unrelated change to source-only work.
    %w[1-2 12-1 12-2 13-2 14-2 15-2].each do |id|
      old = DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys
      assert_equal old.fetch(:content_blocks), @questions.fetch(id).fetch(:content_blocks), id
      assert_equal old.fetch(:choices), @questions.fetch(id).fetch(:choices), id
    end
  end

  test "旧承認比較への委譲は今回の二十一問だけに限定し再変更を見逃さない" do
    id = "41-2"
    current = @questions.fetch(id)
    assert_equal DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys,
      HistoryRevision20261017.historical_attributes(id, current)
    mutation = current.deep_dup
    mutation[:source_text] += "\n無断の再変更"
    assert_raises(RuntimeError) { HistoryRevision20261017.historical_attributes(id, mutation) }
    outside = @all.find { |entry| key(entry) == "50-2" }.fetch(:attributes)
    assert_same outside, HistoryRevision20261017.historical_attributes("50-2", outside)
  end

  test "教授段階とルソーの読書を精密化し架空の出典題名を再導入しない" do
    assert_includes text(@questions.fetch("1-2").fetch(:explanation_blocks)), "ヘルバルト本人"
    rousseau = @questions.fetch("5-2")
    assert_not_includes text(rousseau.fetch(:choices).first.fetch(:content_blocks)), "青年期までは"
    assert_includes text(rousseau.fetch(:explanation_blocks)), "12〜15歳"
    assert_includes text(rousseau.fetch(:choices).first.fetch(:content_blocks)), "ロビンソン・クルーソー"
    {
      "8-2" => "情意的学習法の理論とその試み",
      "12-1" => "伊藤仁斎・東涯の諸稿本に関する総合研究",
      "12-2" => "ルソー・『エミール』・革命",
      "13-2" => "モンテッソーリ教育思想の誕生",
      "14-2" => "野外教育の『教育特性』についての理論的解明の試み",
      "15-2" => "キルパトリック教育理論におけるプロジェクト法の位置",
    }.each { |id, title| assert_includes @questions.fetch(id).fetch(:source_text), title, id }
    assert_includes @questions.fetch("15-2").fetch(:source_text), "カリキュラムにおける学習活動と学習経験に関する研究"
  end

  test "回答前APIから正答と解説を返さず回答後に改稿解説を返し再seedで履歴とIDを保持する" do
    sync_targets
    user = User.create!(name: "教育史改稿検証", email: "history-revision@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      Favorite.create!(user: user, question: record)
      get api_v1_question_path(record), headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_equal record.question_choices.map(&:content_blocks), data.fetch("choices").map { |choice| choice.fetch("content_blocks") }
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
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        sync_targets
      end
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  def correct(question) = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  def payload_digest(entry) = QuestionPayload.digest(QuestionPayload.from_seed(entry.fetch(:exam_number), entry.fetch(:attributes)))
  def text(blocks) = blocks.map { |block| block[:text] }.join("\n")
  def sync_targets = QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
end

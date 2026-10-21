require "test_helper"
require_relative "../support/final_review_20261018"

class MockExamsFinalReviewTest < ActionDispatch::IntegrationTest
  DATA = FinalReview20261018::DATA
  FIXTURE_SHA256 = "4ca3f951250a191c08bc452e7e02ed8de7273df9c614d216f82418dcb31ea9ee".freeze
  SOURCE_PATH = Rails.root.join("test/fixtures/final_review_20261018_sources.json")
  SOURCES = JSON.parse(File.read(SOURCE_PATH)).freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④ ⑤ ⑥].freeze

  setup do
    # These are the actual current seeds, not historical comparison projections.
    @all = QuestionSeedSync.collect { (1..50).each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
    @entries = @all.select { |entry| DATA.fetch("previous_entries").key?(key(entry)) }
    @questions = @all.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "二十六候補の判断と追加五訂正を固定し対象外九百七十四問を保護する" do
    assert_equal FIXTURE_SHA256, Digest::SHA256.file(Rails.root.join("test/fixtures/final_review_20261018.json")).hexdigest
    assert_equal "d71764e", DATA.fetch("baseline_commit")
    assert_equal "2ac9f4577bb8b284e557122b2718c6aea0810896d6887bdbe8389f266ad2f62f", DATA.fetch("baseline_capture_sha256")
    assert_equal 26, DATA.fetch("candidate_keys").uniq.size
    assert_equal %w[1-2 33-2 45-1 48-2 5-2].sort, DATA.fetch("maintained_candidate_keys").sort
    expected = (DATA.fetch("candidate_keys") - DATA.fetch("maintained_candidate_keys") + DATA.fetch("source_only_keys") + DATA.fetch("context_expansion_keys")).sort
    assert_equal 26, expected.size
    assert_equal expected, @entries.map { |entry| key(entry) }.sort
    assert_equal expected, DATA.fetch("revised_payload_digests").keys.sort
    assert_equal 1000, @all.size
    @entries.each do |entry|
      id = key(entry)
      previous = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      assert_equal DATA.fetch("previous_payload_digests").fetch(id), digest(previous), id
      assert_equal DATA.fetch("revised_payload_digests").fetch(id), digest(entry), id
      assert_not_equal digest(previous), digest(entry), id
      actual_fields = entry.fetch(:attributes).keys.select { |field| entry[:attributes][field] != previous[:attributes][field] }.map(&:to_s).sort
      assert_equal DATA.fetch("changed_fields").fetch(id), actual_fields, id
      assert_empty actual_fields - %w[content_blocks choices explanation_blocks source_text], id
    end
    outside = @all.reject { |entry| expected.include?(key(entry)) }
    assert_equal 974, outside.size
    assert_equal outside.size, DATA.fetch("unchanged_count")
    input = outside.map { |entry| [key(entry), digest(entry)] }.sort.map { |id, value| "#{id}|#{value}" }.join("\n")
    assert_equal DATA.fetch("unchanged_digest"), Digest::SHA256.hexdigest(input)
  end

  test "正答位置分類公開状態四択全肢解説と各セット五件ずつの配分を保つ" do
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      previous = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      assert_equal previous[:publication_status], entry[:publication_status], id
      fields = %i[question_number major_category_code category_code]
      assert_equal previous[:attributes].slice(*fields), question.slice(*fields), id
      assert_equal correct(previous[:attributes])[:label], correct(question)[:label], id
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id
      assert_equal 4, question[:choices].map { |choice| choice[:content_blocks] }.uniq.size, id
      LABELS.each { |label| assert_match(/#{label}(?:：|は|の|が)/, text(question[:explanation_blocks]), id) }
      assert question[:source_text].lines.all? { |line| QuestionWriter.valid_source?(line.strip) }, id
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    @all.group_by { |entry| entry[:exam_number] }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert entries.all? { |entry| entry[:publication_status] == "published" }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry[:attributes])[:label] }.tally, exam
    end
    DATA.fetch("source_only_keys").each { |id| assert_equal ["source_text"], DATA.fetch("changed_fields").fetch(id), id }
    assert_not_includes text(@questions.fetch("37-2")[:choices][1][:content_blocks]), "衝動からの逸脱"
    assert_includes text(correct(@questions.fetch("37-2"))[:content_blocks]), "自らの力を有害に使わないように配慮する養育"
    assert_includes @questions.fetch("18-13")[:source_text], "『対人関係論』"
    assert_not_includes @questions.fetch("6-2")[:source_text], "Resume%20on%20Rousseau"
    assert_includes @questions.fetch("19-2")[:source_text], "wakayama-u.repo.nii.ac.jp/record/2003014"
  end

  test "指示語の前段を連続して補い四候補のうち正答だけが独立原典全文に一致する" do
    assert_equal "376f1b3fd73007c05699ee1e4024538876645318a118eae22fdd5432149bf71c", Digest::SHA256.file(SOURCE_PATH).hexdigest
    assert_includes SOURCES.fetch("provenance"), "Not generated by restoring"
    source = SOURCES.fetch("questions").fetch("10-15")
    assert_equal 8, source.fetch("pdf_page")
    assert_equal 3, source.fetch("printed_page")
    assert_equal "https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf", source.fetch("source_url")
    assert_equal "5affb870ae87af1c6272b15b008fea88547ccc50141e20e38fd13bb128f9f39c", source.fetch("sha256")
    question = @questions.fetch("10-15")
    quote = question[:content_blocks].find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
    assert quote.start_with?("○ 人工知能（AI）"), "指示語の先行文脈を再び切り落とさない"
    assert_equal 2, quote.scan(/^○/).size
    assert_equal BLANKS.first(4), quote.scan(/\{\{([^}]+)\}\}/).flatten.uniq
    assert normalize(source.fetch("page_text")).include?(normalize(source.fetch("excerpt")))
    question[:choices].each do |choice|
      cells = choice[:content_blocks].sole.fetch(:cells)
      replacements = BLANKS.zip(cells).to_h
      restored = quote.gsub(/\{\{([^}]+)\}\}/) { replacements.fetch(Regexp.last_match(1)) }
      assert_equal choice[:correct], normalize(source.fetch("page_text")).include?(normalize(restored)), choice[:label]
    end
    rows = question[:choices].map { |choice| choice[:content_blocks].sole.fetch(:cells) }
    rows.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort }
  end

  test "歴史比較の委譲は固定された現行又は正確な変更前記録だけを受け付ける" do
    @entries.each do |entry|
      id, current = key(entry), entry[:attributes]
      previous = DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys
      assert_equal previous, FinalReview20261018.historical_attributes(id, current), id
      assert_same previous, FinalReview20261018.historical_attributes(id, previous), id
      mutation = current.deep_dup
      mutation[:source_text] += "\n未確認の再変更"
      assert_raises(RuntimeError) { FinalReview20261018.historical_attributes(id, mutation) }
    end
    outside = @questions.fetch("50-20")
    assert_same outside, FinalReview20261018.historical_attributes("50-20", outside)
  end

  test "対象履歴だけを無効化しIDお気に入りと回答前秘匿と再実行の不変性を確認する" do
    old = DATA.fetch("previous_entries").values.map(&:deep_symbolize_keys)
    untouched = @all.find { |entry| key(entry) == "50-20" }
    sync(old + [untouched])
    user = User.create!(name: "残件検証", email: "final-review@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    Question.order(:id).each do |record|
      Favorite.create!(user: user, question: record)
      AnswerHistory.create!(user: user, question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
    end
    ids = Question.order(:id).to_h { |record| [record.id, record.question_choices.order(:display_order).pluck(:id)] }
    favorites_before = Favorite.order(:id).map(&:attributes)
    untouched_record = Question.find_by!(exam_number: 50, question_number: 20)
    histories_before = AnswerHistory.where(question_id: untouched_record.id).order(:id).map(&:attributes)
    assert_difference("AnswerHistory.count", -@entries.size) { sync(@entries) }
    assert_equal 1, AnswerHistory.count
    assert_equal Question.find_by!(exam_number: 50, question_number: 20).id, AnswerHistory.first.question_id
    assert_equal ids.size, Favorite.count
    assert_equal favorites_before, Favorite.order(:id).map(&:attributes)
    assert_equal histories_before, AnswerHistory.where(question_id: untouched_record.id).order(:id).map(&:attributes)
    assert_equal ids, Question.order(:id).to_h { |record| [record.id, record.question_choices.order(:display_order).pluck(:id)] }
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      get api_v1_question_path(record), headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_not data.key?("explanation_blocks")
      assert_not data.key?("source_text")
      data.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }
      post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal record.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal record.source_text, response.parsed_body.dig("data", "source_text")
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        sync(@entries)
      end
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  def digest(entry) = QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes]))
  def correct(question) = question[:choices].find { |choice| choice[:correct] }
  def text(blocks) = blocks.filter_map { |block| block[:text] }.join("\n")
  def normalize(value) = value.unicode_normalize(:nfkc).gsub(/[[:space:]]+/, "")
  def sync(entries) = QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
end

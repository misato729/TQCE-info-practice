require "test_helper"
require_relative "../support/improvement_revision_20261017"

class MockExamsImprovementRevisionTest < ActionDispatch::IntegrationTest
  DATA = ImprovementRevision20261017::DATA
  FIXTURE_SHA256 = "ae68f7fecb10a42ce1cfacefec574cd296ecafc02eaa4a30b30a51d3940f5b58".freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    @all = QuestionSeedSync.collect { (1..50).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
      .map { |entry| FinalReview20261018.historical_entry(entry) }
    @entries = @all.select { |entry| DATA.fetch("previous_entries").key?(key(entry)) }
  end

  test "九十三候補の判断と変更対象以外の全問題を固定する" do
    assert_equal FIXTURE_SHA256, Digest::SHA256.file(Rails.root.join("test/fixtures/improvement_revision_20261017.json")).hexdigest
    assert_equal "a3c3edd", DATA.fetch("baseline_commit")
    assert_equal 93, DATA.fetch("candidate_keys").size
    assert_equal 93, DATA.fetch("candidate_keys").uniq.size
    assert_equal 1000, @all.size
    changed = DATA.fetch("previous_entries").keys.sort
    assert changed.any?, "対象0件を検証成功としない"
    assert_empty changed - DATA.fetch("candidate_keys")
    assert_equal changed, @entries.map { |entry| key(entry) }.sort
    assert_equal changed, DATA.fetch("revised_payload_digests").keys.sort
    @entries.each do |entry|
      id, current = key(entry), entry.fetch(:attributes)
      old_entry = DATA.fetch("previous_entries").fetch(id).deep_symbolize_keys
      old = old_entry.fetch(:attributes)
      assert_equal DATA.fetch("previous_payload_digests").fetch(id), digest(old_entry), "#{id}: 独立保存した変更前属性とダイジェスト"
      fields = current.keys.select { |field| current.fetch(field) != old.fetch(field) }.map(&:to_s).sort
      assert_equal DATA.fetch("changed_fields").fetch(id).sort, fields, id
      assert_empty fields - %w[content_blocks choices explanation_blocks source_text], id
      assert_equal DATA.fetch("revised_payload_digests").fetch(id), digest(entry), id
      assert_not_equal DATA.fetch("previous_payload_digests").fetch(id), digest(entry), id
    end
    outside = @all.reject { |entry| changed.include?(key(entry)) }
    assert_equal DATA.fetch("unchanged_count"), outside.size
    input = outside.map { |entry| [key(entry), digest(entry)] }.sort.map { |id, value| "#{id}|#{value}" }.join("\n")
    assert_equal DATA.fetch("unchanged_digest"), Digest::SHA256.hexdigest(input)
  end

  test "正答位置分類公開状態と全肢解説を保ち必要以上に形式を変えない" do
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
      assert question.fetch(:source_text).lines.all? { |line| QuestionWriter.valid_source?(line.strip) }, id
      explanation = question.fetch(:explanation_blocks).filter_map { |block| block[:text] }.join("\n")
      LABELS.each { |label| assert_match(/#{label}(?:：|は|の|が)/, explanation, "#{id} #{label}の説明") }
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
      if DATA.fetch("changed_fields").fetch(id).include?("choices") && choices.first[:content_blocks].first["type"] == "fill_in_choice"
        rows = choices.map { |choice| choice[:content_blocks].first.fetch("cells") }
        rows.transpose.each { |column| assert_equal 1, column.tally.values.uniq.size, "#{id}: #{column.tally}" }
      end
    end
    @all.group_by { |entry| entry.fetch(:exam_number) }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry[:attributes])[:label] }.tally, exam
    end
  end

  test "過去承認への委譲は固定された現行内容に限り未知の再変更を拒否する" do
    entry = @entries.first
    id = key(entry)
    assert_equal DATA.fetch("previous_entries").fetch(id).fetch("attributes").deep_symbolize_keys,
      ImprovementRevision20261017.historical_attributes(id, entry.fetch(:attributes))
    changed = entry.fetch(:attributes).deep_dup
    changed[:source_text] += "\n未承認の再変更"
    assert_raises(RuntimeError) { ImprovementRevision20261017.historical_attributes(id, changed) }
    outside = @all.find { |row| !DATA.fetch("previous_entries").key?(key(row)) }
    assert_same outside.fetch(:attributes), ImprovementRevision20261017.historical_attributes(key(outside), outside.fetch(:attributes))
  end

  test "容易な列の交差や初期五セットの資料偏りを再発させない" do
    questions = @all.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
    {
      "1-4" => [[0, 1], %w[イ エ]],
      "19-3" => [[2, 3], %w[ア エ]],
      "41-3" => [[1, 3], %w[ア ウ]],
      "39-5" => [[0, 1], %w[ア イ]],
      "6-11" => [[1, 2], %w[ア ウ]],
      "4-16" => [[0], %w[ウ エ]],
      "4-18" => [[2], %w[ア エ]],
      "9-18" => [[1, 2], %w[イ ウ]],
    }.each do |id, (columns, labels)|
      question = questions.fetch(id)
      answer = correct(question)[:content_blocks].first.fetch(:cells).values_at(*columns)
      remaining = question[:choices].select { |choice| choice[:content_blocks].first.fetch(:cells).values_at(*columns) == answer }
      assert_equal labels, remaining.map { |choice| choice[:label] }, id
    end
    [8, 10].each do |number|
      counts = (1..5).map { |exam| questions.fetch("#{exam}-#{number}")[:content_blocks].first[:text].include?("解説") ? "解説" : "本体" }.tally
      assert_equal({ "本体" => 3, "解説" => 2 }, counts, "初期五セット問#{number}")
    end
    assert_includes questions.fetch("2-9")[:source_text], "第1章第7款2"
    assert_includes questions.fetch("4-9")[:source_text], "第1章第1款2(2)"
    assert_includes questions.fetch("7-9")[:source_text], "参照先を内容名へ展開し、原典に基づき編集・空欄化して作成"
    assert_not_includes questions.fetch("7-9")[:source_text], "原文を抜粋"
    assert questions.fetch("10-11")[:content_blocks].first[:text].start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
  end

  test "探索比較と四分位数の中心判断を易しい条件だけで回避できない" do
    algorithm = @all.find { |entry| key(entry) == "12-19" }.fetch(:attributes)
    data = [8, 3, 6, 1, 9, 4, 7]
    search_a = lambda do |target|
      count = 0
      position = -1
      data.each_with_index do |value, index|
        count += 1
        if value == target
          position = index
          break
        end
      end
      [position, count]
    end
    search_b = lambda do |target|
      work = data + [target]
      index = 0
      count = 0
      loop do
        count += 1
        break if work[index] == target
        index += 1
      end
      [index < data.size ? index : -1, count]
    end
    assert_equal [5, 6], search_a.call(4)
    assert_equal [5, 6], search_b.call(4)
    assert_equal [-1, 7], search_a.call(5)
    assert_equal [-1, 8], search_b.call(5)
    assert_equal 4, data.sum { |target| search_a.call(target).last }.fdiv(data.size)
    assert_equal 4, data.sum { |target| search_b.call(target).last }.fdiv(data.size)
    without_false_third = algorithm[:choices].reject { |choice| choice[:content_blocks].first[:text].include?("③") }
    assert_equal %w[ア イ], without_false_third.map { |choice| choice[:label] }
    assert_equal "①と②", correct(algorithm)[:content_blocks].first[:text]

    statistics = @all.find { |entry| key(entry) == "11-20" }.fetch(:attributes)
    table = statistics[:content_blocks].find { |block| block[:type] == "table" }
    values = table[:headers].drop(1).map(&:to_i).zip(table[:rows].first.drop(1).map(&:to_i)).flat_map { |value, count| [value] * count }
    median = ->(items) { (items[(items.size - 1) / 2] + items[items.size / 2]).fdiv(2) }
    expected = [median.call(values), median.call(values.first(6)), median.call(values.last(6)), values.tally.max_by(&:last).first]
    assert_equal [1.5, 1, 2.5, 1], expected
    rows = statistics[:choices].map { |choice| [choice[:label], choice[:content_blocks].first[:rows].first.map(&:to_f)] }
    assert_equal [["イ", expected]], rows.select { |_, row| row == expected }
    assert_equal %w[ア イ], rows.select { |_, row| row.values_at(0, 3) == expected.values_at(0, 3) }.map(&:first)
  end

  test "対象だけの履歴無効化とIDお気に入りAPI再実行を確認する" do
    untouched = @all.find { |entry| key(entry) == "50-20" }
    old = DATA.fetch("previous_entries").values.map(&:deep_symbolize_keys)
    sync(old + [untouched])
    user = User.create!(name: "改善候補検証", email: "improvement-check@example.com", role: "admin", password: "password123", password_confirmation: "password123")
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
      assert_no_difference(["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"]) { sync(@entries) }
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  def digest(entry) = QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes]))
  def correct(question) = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  def sync(entries) = QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
end

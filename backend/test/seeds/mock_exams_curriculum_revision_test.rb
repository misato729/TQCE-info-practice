require "test_helper"
require "digest"

class MockExamsCurriculumRevisionTest < ActionDispatch::IntegrationTest
  ANSWERS = { "1-9" => "ア", "3-9" => "ア", "4-6" => "エ", "5-7" => "ウ",
    "7-10" => "ウ", "8-9" => "ア", "25-10" => "ウ" }.freeze
  BLANKS = %w[① ② ③ ④].freeze
  LABELS = %w[ア イ ウ エ].freeze
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_curriculum_revision_sources.json"))).freeze

  setup do
    @all_entries = QuestionSeedSync.collect do
      (1..30).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @entries = @all_entries.select { |entry| ANSWERS.key?(key(entry)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認された七問だけを改稿し対象外五百八問を維持する" do
    assert_equal 515, @all_entries.size
    assert_equal ANSWERS.keys.sort, @questions.keys.sort
    assert_equal ANSWERS.keys.sort, ORIGINALS.fetch("previous_attribute_digests").keys.sort
    assert_equal ANSWERS.keys.sort, ORIGINALS.fetch("previous_payload_digests").keys.sort
    unchanged = @all_entries.reject { |entry| ANSWERS.key?(key(entry)) }.map do |entry|
      [key(entry), Digest::SHA256.hexdigest(JSON.generate(entry.fetch(:attributes)))]
    end.sort.map { |id, digest| "#{id}|#{digest}" }.join("\n")
    assert_equal ORIGINALS.fetch("unchanged_508_attribute_digest"), Digest::SHA256.hexdigest(unchanged)
    @questions.each do |id, attributes|
      assert_not_equal ORIGINALS.fetch("previous_attribute_digests").fetch(id), Digest::SHA256.hexdigest(JSON.generate(attributes)), id
    end
  end

  test "四択一正答空欄列数正答位置と完成済み各セット五件ずつを維持する" do
    @questions.each do |id, attributes|
      choices = attributes.fetch(:choices)
      assert_equal LABELS, choices.map { |choice| choice.fetch(:label) }, id
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, id
      assert_equal ANSWERS.fetch(id), answer(id).fetch(:label), id
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, id
      labels = quote(id).scan(/\{\{([①②③④])\}\}/).flatten.uniq
      assert_equal BLANKS.first(%w[1-9 3-9].include?(id) ? 3 : 4), labels, id
      choices.each { |choice| assert_equal labels.size, cells(choice).size, id }
      assert_equal [labels.first, labels.last], attributes[:content_blocks].first[:text].scan(/\{\{([①②③④])\}\}/).flatten.uniq, id
      assert attributes[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
    end
    @all_entries.select { |entry| entry[:exam_number] <= 25 }.group_by { |entry| entry[:exam_number] }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| entry[:attributes][:choices].find { |choice| choice[:correct] }[:label] }.tally, exam
    end
  end

  test "正答だけが独立公式PDFの連続した原文に一致し中略を含めない" do
    @questions.each do |id, attributes|
      assert_includes attributes[:content_blocks].first[:text], "からの抜粋である。", id
      assert_no_match(/中略|示された内容に基づく記述/, quote(id), id)
      original = official_excerpt(id)
      attributes[:choices].each do |choice|
        assert_equal choice.fetch(:correct), normalized(restore(id, choice)) == original, "#{id} #{choice[:label]}"
      end
    end
  end

  test "六問の導入本文補足へ答えを残さず各列を二対二にする" do
    @questions.except("8-9").each do |id, attributes|
      visible = attributes[:content_blocks].map { |block| block[:text] }.join("\n")
      cells(answer(id)).each { |term| assert_not_includes visible, term, id }
      cells(answer(id)).size.times do |column|
        assert_equal [2, 2], attributes[:choices].map { |choice| cells(choice)[column] }.tally.values.sort, "#{id} 列#{column + 1}"
      end
    end
    assert_not_includes @questions.fetch("4-6")[:content_blocks].first[:text], "主体的・対話的で深い学び"
    assert_equal 2, quote("7-10").scan("{{①}}").size
    assert_equal 2, quote("7-10").scan("{{③}}").size
    %w[② ③ ④].each { |label| assert_equal 2, quote("5-7").scan("{{#{label}}}").size }
  end

  test "計画の再掲へ全誤答を代入しても同じ計画名を並列に重複させない" do
    @questions.fetch("5-7")[:choices].each do |choice|
      assert_not_equal cells(choice)[1], cells(choice)[3], choice[:label]
      assert_no_match(/(個別の(?:教育支援|指導)計画)や\1/, restore("5-7", choice), choice[:label])
    end
  end

  test "道徳の二問は対象列挙と目標補足を残し名称だけを空欄にしない" do
    assert_includes quote("1-9"), "総合的な探究の時間及び特別活動"
    assert_includes quote("1-9"), "それぞれの特質に応じて"
    assert_includes quote("3-9"), "道徳教育推進教師"
    assert_not_includes cells(answer("3-9")), "道徳教育推進教師"
    supplement = @questions.fetch("3-9")[:content_blocks].find { |block| block[:type] == "text" }.fetch(:text)
    assert_includes supplement, "基盤となる道徳性を養う"
    assert_includes @questions.fetch("3-9")[:source_text], "参照先補足"
  end

  test "模試八の問九は出典のみを後段へ訂正する" do
    attributes = @questions.fetch("8-9")
    assert_includes attributes[:source_text], "第7款1後段"
    assert_includes attributes[:source_text], "#page=34"
    original_source = "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款1前段 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf"
    previous = attributes.merge(source_text: original_source)
    assert_equal ORIGINALS.fetch("previous_attribute_digests").fetch("8-9"), Digest::SHA256.hexdigest(JSON.generate(previous))
  end

  test "模試二十五の問十は同語反復や評価の矛盾を生む旧空欄を使わない" do
    assert_equal ["生徒の努力や意欲", "多面的・総合的", "ポートフォリオ的な教材", "学習評価の参考資料"], cells(answer("25-10"))
    assert_includes quote("25-10"), "結果だけでなく活動の過程"
    assert_includes quote("25-10"), "自己評価や相互評価は学習活動であり"
    @questions.fetch("25-10")[:choices].each do |choice|
      assert_not_includes cells(choice), "活動の結果"
      assert_not_includes cells(choice), "学習評価"
    end
    # Even correct identification of effort and portfolios leaves ア / ウ;
    # the evaluation perspective and use of the material still need judgment.
    familiar = cells(answer("25-10")).values_at(0, 2)
    assert_equal %w[ア ウ], @questions.fetch("25-10")[:choices].select { |choice| cells(choice).values_at(0, 2) == familiar }.map { |choice| choice[:label] }
  end

  test "各改稿の誤答を説明し七問取得APIは正答解説を回答前に返さない" do
    @questions.except("8-9").each do |id, attributes|
      explanation = attributes[:explanation_blocks].map { |block| block[:text] }.join("\n")
      LABELS.each { |label| assert_match(/#{label}(?:：|は|が|の)/, explanation, id) }
    end
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    user = User.create!(name: "指導要領改稿検証", email: "curriculum-revision@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
    @entries.each do |entry|
      id = key(entry)
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      get api_v1_question_path(record), headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal record.content_blocks, data.fetch("content_blocks"), id
      assert_equal record.question_choices.map(&:content_blocks), data.fetch("choices").map { |choice| choice.fetch("content_blocks") }, id
      assert_not data.key?("explanation_blocks"), id
      data.fetch("choices").each { |choice| assert_not choice.key?("is_correct"), id }
      post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct"), id
      assert_equal record.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks"), id
    end
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(id)
    @questions.fetch(id)[:choices].find { |choice| choice[:correct] }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def quote(id)
    @questions.fetch(id)[:content_blocks].find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  end

  def restore(id, choice)
    quote(id).gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
  end

  def normalized(text)
    text.unicode_normalize(:nfkc).gsub(/、|，/, ",").gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
  end

  def official_excerpt(id)
    location = ORIGINALS.fetch("locations").fetch(id)
    pages = ORIGINALS.fetch("sources").fetch(location.fetch("source")).fetch("pages")
    text = location.fetch("pdf_pages").map do |number|
      pages.fetch(number.to_s).lines.reject { |line| line.strip.match?(/\A(?:\d+|総則|特別活動)\z/) }.join
    end.join("\n")
    text = normalized(text)
    start_at = text.index(normalized(location.fetch("start")))
    assert start_at, "#{id} 原典の開始位置"
    end_marker = normalized(location.fetch("end"))
    end_at = text.index(end_marker, start_at)
    assert end_at, "#{id} 原典の終了位置"
    text[start_at...end_at + end_marker.length]
  end
end

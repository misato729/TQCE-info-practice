require "test_helper"
require_relative "../support/history_revision_20261017"
require "digest"

class MockExams26To30PsychologyReportTest < ActionDispatch::IntegrationTest
  EXAMS = (26..30).to_a.freeze
  NUMBERS = (12..15).to_a.freeze
  PARTIAL_NUMBERS = ((3..15).to_a + [19, 20]).freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③].freeze
  CATEGORIES = { 12 => "special_support_education", 13 => "educational_psychology",
    14 => "educational_psychology", 15 => "education_system" }.freeze
  ANSWERS = { 26 => %w[ウ ア エ イ], 27 => %w[イ ウ ア ア],
    28 => %w[エ イ ア エ], 29 => %w[イ エ ウ ウ], 30 => %w[ア ウ イ イ] }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_psychology_report_drafts.json"))).freeze
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_report_sources.json"))).freeze
  REPORT_TITLE = "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）".freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") }
    end.select { |entry| PARTIAL_NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @added = @entries.select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @questions = @added.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認草案二十問の本文四択正答全解説出典分類を独立snapshotと照合する" do
    assert_equal 75, @entries.size
    assert_equal 20, @added.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    @added.each do |entry|
      id = key(entry)
      question = HistoryRevision20261017.historical_attributes(id, entry.fetch(:attributes))
      approved = APPROVED.fetch("sections").fetch(id)
      head, tail = approved.split(/^正答：[アイウエ].*$/, 2)
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert_equal CATEGORIES.fetch(question[:question_number]), question.fetch(:category_code), id
      assert_equal approved[/^正答：([アイウエ])/, 1], answer(question).fetch(:label), id
      if id == "28-15"
        prompt = head.lines.find { |line| line.start_with?("次の文章は") }
        assert_equal normalize(prompt), normalize(question[:content_blocks].first.fetch(:text)), id
        assert_equal %w[fill_in_text fill_in_quote], question[:content_blocks].map { |block| block.fetch(:type) }, id
        expected_quote = head.lines.grep(/^>/).map { |line| line.sub(/^> ?/, "") }.join
        assert_equal normalize(expected_quote), normalize(quote(question)), id
        expected_choices = head.lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
        assert_equal expected_choices, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
      else
        first_choice = head.index(/^[アイウエ]　/)
        assert first_choice, "#{id} 草案の選択肢開始境界"
        paragraphs = head[0...first_choice].strip.split(/\n\n+/)
        assert_equal paragraphs.map { |text| normalize(text) }, question[:content_blocks].map { |block| normalize(block.fetch(:text)) }, id
        assert question[:content_blocks].all? { |block| block[:type] == "text" }, id
        expected_choices = head[first_choice..].scan(/^([アイウエ])　([^\n]+)/).map { |label, text| [label, normalize(text)] }
        assert_equal expected_choices, question[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first.fetch(:text))] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "text" }, id
      end
      explanations, sources = tail.split(/^出典：/, 2)
      expected_explanations = explanations.lines.grep(/^- [アイウエ]：/).map { |line| normalize(line.delete_prefix("- ")) }
      assert_equal expected_explanations, question[:explanation_blocks].map { |block| normalize(block.fetch(:text)) }, id
      assert_equal LABELS, question[:explanation_blocks].map { |block| block.fetch(:text)[/\A([アイウエ])：/, 1] }, id
      assert question[:explanation_blocks].all? { |block| block[:type] == "text" }, id
      if question[:question_number] == 15
        expected_sources = sources.split("source_text：\n", 2).last.strip
        assert_equal expected_sources, question.fetch(:source_text), id
      else
        # Draft links sometimes put page details outside the Markdown link.
        # Preserve every title, section, page, note and URL; only source-title
        # punctuation at that boundary is an explicit presentation conversion.
        expected_sources = draft_sources(sources)
        actual_sources = question.fetch(:source_text).lines.map(&:strip)
        assert_equal expected_sources.size, actual_sources.size, id
        expected_sources.zip(actual_sources).each do |expected, actual|
          expected_title, expected_url = expected.split(" | ", 2)
          actual_title, actual_url = actual.split(" | ", 2)
          assert_equal expected_url, actual_url, id
          assert_equal source_title_normalize(expected_title), source_title_normalize(actual_title), id
        end
      end
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      assert_not question[:content_blocks].any? { |block| block[:type] == "quote" }, id
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal PARTIAL_NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.select { |entry| NUMBERS.include?(entry[:attributes][:question_number]) }.map { |entry| answer(entry[:attributes])[:label] }, exam
      assert entries.map { |entry| answer(entry[:attributes])[:label] }.tally.values.all? { |count| count <= 5 }, exam
    end
    APPROVED.fetch("documents").each_value { |document| assert_match(/\A[0-9a-f]{64}\z/, document.fetch("sha256")) }
  end

  test "新規二十問以外の既存五百四十五問と問三から十一の固定内容を維持する" do
    entries = QuestionSeedSync.collect { (1..30).each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
    previous = APPROVED.fetch("existing_545_payload_digests")
    assert_equal 545, previous.size
    # Later additions are checked independently. Retain exactly the historical
    # 545-question key set and its original, never-rebased payload hashes.
    unchanged = entries.select { |entry| previous.key?(key(entry)) }
    assert_equal previous.keys.sort, unchanged.map { |entry| key(entry) }.sort
    unchanged.each do |entry|
      assert_equal previous.fetch(key(entry)), HistoryRevision20261017.historical_payload_digest(key(entry), entry[:exam_number], entry[:attributes]), key(entry)
    end
    EXAMS.each do |exam|
      assert_equal (3..11).to_a, unchanged.select { |entry| entry[:exam_number] == exam }.map { |entry| entry[:attributes][:question_number] }, exam
    end
  end

  test "四択一正答肯定と否定の混在及び障害と青年期の分野配分を維持する" do
    @questions.each do |id, question|
      assert_equal LABELS, question[:choices].map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question[:choices].count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, question[:choices].map { |choice| choice.fetch(:content_blocks) }.uniq.size, id
    end
    { "26-12" => "自閉症スペクトラム障害（ASD）", "29-12" => "学習障害（LD）",
      "27-12" => "視覚障害", "28-12" => "構音障害", "30-12" => "情緒障害" }.each do |id, topic|
      assert_includes prompt(@questions.fetch(id)), topic, id
    end
    assert_equal [26, 29], EXAMS.select { |exam| prompt(@questions.fetch("#{exam}-12")).match?(/（ASD）|（LD）/) }
    assert_equal [26, 27, 28, 29], EXAMS.select { |exam| prompt(@questions.fetch("#{exam}-13")).include?("青年期") }
    assert_includes prompt(@questions.fetch("30-13")), "コールバーグ"
    assert_not_includes prompt(@questions.fetch("30-13")), "青年期"
    { 12 => [30], 13 => [27], 14 => [29] }.each do |number, negative_exams|
      assert_equal negative_exams, EXAMS.select { |exam| prompt(@questions.fetch("#{exam}-#{number}")).include?("適切でないもの") }, number
    end
    assert_includes @questions.fetch("29-12")[:content_blocks].map { |block| block[:text] }.join, "関係機関と連携して"
  end

  test "問十四は授業ケースでなく学習理論の定義と概念の比較を直接問う" do
    topics = { 26 => "シェイピング", 27 => "適性処遇交互作用", 28 => "記憶の過程", 29 => "処理水準説", 30 => "学習性無力感" }
    topics.each do |exam, topic|
      question = @questions.fetch("#{exam}-14")
      assert_equal ["text"], question[:content_blocks].map { |block| block[:type] }, exam
      assert_includes prompt(question), topic, exam
      assert_no_match(/状況[ＡＢAB]|教師が|授業場面|あるクラス/, prompt(question), exam)
    end
    assert_includes @questions.fetch("27-14")[:choices].find { |choice| choice[:label] == "エ" }[:content_blocks].first[:text], "一つの指導方法"
    assert_includes @questions.fetch("29-14")[:choices].find { |choice| choice[:label] == "ウ" }[:content_blocks].first[:text], "時間の長さ"
    assert_includes @questions.fetch("30-14")[:explanation_blocks].last[:text], "セルフ・ハンディキャッピング"
  end

  test "問十五の四正誤一原文穴埋めと指定資料名を維持する" do
    reports = @questions.select { |id, _question| id.end_with?("-15") }
    assert_equal ["28-15"], reports.select { |_id, question| question[:content_blocks].first[:type] == "fill_in_text" }.keys
    assert_equal 4, reports.count { |_id, question| question[:content_blocks].first[:type] == "text" }
    assert_equal ["29-15"], reports.select { |_id, question| prompt(question).include?("適切でないもの") }.keys
    reports.each { |id, question| assert_includes prompt(question), REPORT_TITLE, id }
    assert_includes @questions.fetch("26-15")[:explanation_blocks].last[:text], "下位"
    assert_includes @questions.fetch("29-15")[:explanation_blocks][2][:text], "共有している"
    assert_includes @questions.fetch("29-15")[:explanation_blocks].last[:text], "2021年"
  end

  test "模試二十八の答申抜粋は独立公式PDFの連続二箇条全文に正答だけが一致する" do
    question = @questions.fetch("28-15")
    location = ORIGINALS.fetch("locations").fetch("28-15")
    document = ORIGINALS.fetch("documents").fetch(location.fetch("document"))
    assert_equal [31], location.fetch("pdf_pages")
    assert_equal [26], location.fetch("printed_pages")
    assert_equal "5affb870ae87af1c6272b15b008fea88547ccc50141e20e38fd13bb128f9f39c", document.fetch("pdf_sha256")
    assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\//, document.fetch("url"))
    original = source_normalize(location.fetch("source_fragment"))
    assert_includes source_normalize(document.fetch("pages").fetch("31")), original
    assert_operator original.length, :>=, 250
    assert_includes question[:source_text], "#{document.fetch('url')}#page=31"
    assert_includes question[:source_text], "本文26頁"
    assert_equal 2, quote(question).scan(/(?:\A|\n)・/).size
    assert_no_match(/中略|示された内容に基づく記述/, quote(question))
    question[:choices].each do |choice|
      restored = quote(question).gsub(/\{\{([①②③])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
      assert_equal choice.fetch(:correct), source_normalize(restored) == original, choice[:label]
    end
  end

  test "模試二十八の三空欄と全選択肢セル各列二対二及び正答語句非再掲を維持する" do
    question = @questions.fetch("28-15")
    assert_equal BLANKS, quote(question).scan(/\{\{([①②③])\}\}/).flatten.uniq
    assert_equal %w[① ③], prompt(question).scan(/\{\{([①②③])\}\}/).flatten.uniq
    question[:choices].each do |choice|
      assert_equal 1, choice[:content_blocks].size
      assert_equal "fill_in_choice", choice[:content_blocks].first[:type]
      assert_equal 3, cells(choice).size
    end
    3.times { |column| assert_equal [2, 2], question[:choices].map { |choice| cells(choice)[column] }.tally.values.sort }
    visible = question[:content_blocks].map { |block| block[:text] }.join
    cells(answer(question)).each { |term| assert_not_includes visible, term }
  end

  test "必須空欄の全消去とセル不足を模試二十八の投入前に拒否する" do
    path = Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_28.rb")
    source = File.read(path)
    mutations = [
      "questions.find { |question| question[:question_number] == 15 }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③][}][}]/, '語句') if block[:type] == 'fill_in_quote' }\n",
      "questions.find { |question| question[:question_number] == 15 }[:choices].first[:content_blocks].first[:cells].pop\n",
    ]
    assert_includes source, "questions.each do |question|\n"
    mutations.each do |mutation|
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
        assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
          QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
        end
      end
    end
  end

  test "未完五セットは管理取得だけ可能で一般一覧next取得回答へ公開しない" do
    save_entries
    assert_equal 75, Question.where(exam_number: EXAMS, publication_status: "draft").count
    headers = admin_headers
    [nil, headers].each do |request_headers|
      get api_v1_exams_path, headers: request_headers
      assert_response :success
      assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
    end
    EXAMS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }, headers: headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "draft" }, headers: headers
      assert_response :success
      assert_equal 15, response.parsed_body.dig("meta", "total_count")
      assert_equal PARTIAL_NUMBERS, response.parsed_body.fetch("data").map { |record| record.fetch("question_number") }
    end
    @added.each do |entry|
      record = record_for(entry)
      get "/api/v1/admin/questions/#{record.id}", headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal "draft", data.fetch("publication_status")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_equal record.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal record.source_text, data.fetch("source_text")
      assert_equal LABELS, data.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
      [nil, headers].each do |request_headers|
        get api_v1_question_path(record), headers: request_headers
        assert_response :not_found
        assert_no_public_answers(response.parsed_body)
      end
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      end
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
  end

  test "公開をテスト内に限定し回答前の正答秘匿と回答後の全解説出典を検査する" do
    save_entries
    @added.each do |entry|
      record = record_for(entry)
      record.update!(publication_status: "published")
      get api_v1_question_path(record), headers: admin_headers
      assert_response :success
      assert_equal record.content_blocks, response.parsed_body.dig("data", "content_blocks")
      assert_no_public_answers(response.parsed_body)
      correct = record.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(record), params: { selected_choice_id: correct.id }, headers: admin_headers, as: :json
      end
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal correct.choice_label, response.parsed_body.dig("data", "correct_choice", "choice_label")
      assert_equal record.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal record.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "再同期二回で既存及び追加問題のID内容履歴お気に入り公開状態を変えない" do
    save_entries
    load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_1.rb")
    user = User.create!(name: "心理答申再同期確認", email: "mock26-psychology-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 12], [26, 3], [26, 12], [28, 15], [30, 14]].each do |exam, number|
      record = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
      assert_equal before, snapshot
    end
  end

  test "十五問のみの未完セットの管理API公開操作を不足で拒否する" do
    save_entries
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 12)
      before = snapshot
      patch "/api/v1/admin/questions/#{record.id}", params: { question: QuestionPayload.from_record(record).merge("publication_status" => "published") }, headers: admin_headers, as: :json
      assert_response :unprocessable_content
      assert_includes response.parsed_body.dig("error", "message"), "問1〜20の登録が必要"
      assert_equal "draft", record.reload.publication_status
      assert_equal before, snapshot
    end
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(question)
    question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def prompt(question)
    question.fetch(:content_blocks).first.fetch(:text)
  end

  def quote(question)
    question.fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  end

  def normalize(text)
    text.to_s.gsub(/\{\{([①②③])\}\}|【([①②③])】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]+/, "")
  end

  def source_normalize(text)
    text.unicode_normalize(:nfkc).gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
  end

  def source_title_normalize(text)
    # Source title metadata is not a quoted passage. Markdown-boundary commas
    # and its terminal sentence punctuation may be removed during conversion.
    normalize(text).gsub(/[，、。]/, "")
  end

  def draft_sources(sources)
    sources.strip.lines.filter_map do |line|
      line = line.strip.delete_prefix("- ")
      if line.match?(/\A.+ \[公式PDF\]\(https:\/\/[^)]+\)\z/)
        title, url = line.match(/\A(.+) \[公式PDF\]\((https:\/\/[^)]+)\)\z/).captures
        "#{title} | #{url}"
      elsif line.match?(/\A\[.+\]\(https:\/\/[^)]+\)/)
        title, url, detail = line.match(/\A\[(.+)\]\((https:\/\/[^)]+)\)(.*)\z/).captures
        "#{title}#{detail} | #{url}"
      end
    end
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def save_entries
    # Explicitly recreate the incomplete draft stage for unpublished API and
    # incomplete-publication guard tests, even after the set is completed.
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry.merge(publication_status: "draft")) } }
  end

  def record_for(entry)
    Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "心理答申管理確認", email: "mock26-psychology-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    end
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

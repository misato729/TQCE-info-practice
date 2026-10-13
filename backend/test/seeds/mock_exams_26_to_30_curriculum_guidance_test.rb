require "test_helper"
require "digest"

class MockExams26To30CurriculumGuidanceTest < ActionDispatch::IntegrationTest
  EXAMS = (26..30).to_a.freeze
  NUMBERS = (6..11).to_a.freeze
  PARTIAL_NUMBERS = ((3..15).to_a + [19, 20]).freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  ANSWERS = {
    26 => %w[ウ ア エ イ ウ イ], 27 => %w[エ ウ ア エ イ エ],
    28 => %w[ア イ ウ ア エ エ], 29 => %w[イ エ イ ウ ア ア],
    30 => %w[ウ ア エ イ エ ウ],
  }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_curriculum_guidance_drafts.json"))).freeze
  CURRICULUM = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_curriculum_sources.json"))).freeze
  GUIDANCE = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_guidance_sources.json"))).freeze
  Q7_CATEGORIES = {
    26 => "career_education", 27 => "curriculum_organization", 28 => "student_guidance_career",
    29 => "student_guidance_career", 30 => "special_support_education",
  }.freeze
  CATEGORIES = { 6 => "curriculum_organization", 8 => "integrated_inquiry", 9 => "moral_education",
    10 => "special_activities", 11 => "student_guidance_career" }.freeze

  setup do
    @partial_entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end.select { |entry| PARTIAL_NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @entries = @partial_entries.select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認草案三十問の本文補足表四択正答全解説出典分類を独立snapshotと照合する" do
    assert_equal 30, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry.fetch(:exam_number) == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
      assert_equal PARTIAL_NUMBERS, @partial_entries.select { |entry| entry[:exam_number] == exam }.map { |entry| entry[:attributes][:question_number] }, exam
    end
    @entries.each do |entry|
      id = key(entry)
      question = entry.fetch(:attributes)
      approved = APPROVED.fetch("sections").fetch(id)
      head, tail = approved.split(/^正答：[アイウエ].*$/, 2)
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      category = question[:question_number] == 7 ? Q7_CATEGORIES.fetch(entry[:exam_number]) : CATEGORIES.fetch(question[:question_number])
      assert_equal category, question.fetch(:category_code), id
      assert_equal approved[/^正答：([アイウエ])/, 1], answer(question).fetch(:label), id
      expected_prompt = head.lines.find { |line| line.start_with?("次の文章は") }
      if id == "30-11"
        # Table cells use display-only 【①】 labels, so the existing writer and
        # choice-column UI need every machine-readable label in the prompt.
        # Keep the approved snapshot unchanged and declare this conversion.
        expected_prompt = expected_prompt.sub("表中の空欄 【①】 ～ 【③】", "表中の空欄 【①】・【②】・【③】")
      end
      assert_equal normalize(expected_prompt), normalize(question[:content_blocks].first.fetch(:text)), id
      assert_equal "fill_in_text", question[:content_blocks].first.fetch(:type), id
      layout = case id
      when "30-9" then %w[fill_in_text text fill_in_quote]
      when "26-11", "27-11", "29-11" then %w[fill_in_text fill_in_quote text]
      when "30-11" then %w[fill_in_text fill_in_quote text table]
      else %w[fill_in_text fill_in_quote]
      end
      assert_equal layout, question[:content_blocks].map { |block| block.fetch(:type) }, id
      assert_equal 1, quote_blocks(question).size, id
      assert_equal normalize(head.lines.grep(/^>/).map { |line| line.sub(/^> ?/, "") }.join), normalize(quote(question)), id
      assert_equal head.lines.grep(/\A(?:注：|参考：|以下の表は)/).map { |line| normalize(line) },
        question[:content_blocks].select { |block| block[:type] == "text" }.map { |block| normalize(block[:text]) }, id
      table_rows = head.lines.grep(/^\|/).reject { |line| line.match?(/^\| (?:選択肢|[アイウエ]) \|/) || line.include?("---") }
      if id == "30-11"
        table = question[:content_blocks].find { |block| block[:type] == "table" }
        expected = table_rows.map { |line| markdown_row(line) }
        assert_equal expected.first, table.fetch(:headers), id
        assert_equal expected.drop(1), table.fetch(:rows), id
        assert_equal %w[【①】 【②】 【③】], table[:rows].map(&:first), id
        assert_not table[:rows].flatten.any? { |cell| cell.include?("{{") }, id
      else
        assert_empty question[:content_blocks].select { |block| block[:type] == "table" }, id
      end
      expected_choices = head.lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
      assert_equal expected_choices, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
      explanation, source_line = tail.split(/^出典：/, 2)
      expected_explanations = explanation.lines.grep(/^- [アイウエ]：/).map { |line| normalize(line.sub(/^- /, "")) }
      assert_equal expected_explanations, question[:explanation_blocks].map { |block| normalize(block.fetch(:text)) }, id
      sources = source_line.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/).map { |title, url| "#{title} | #{url}" }.join("\n")
      assert_equal sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      preview = QuestionSeedSync.preview(entry)
      payload = QuestionPayload.from_seed(entry[:exam_number], question)
      QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
      QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
    end
  end

  test "原文穴埋め二十九問は正答だけが独立公式原典の連続範囲に含まれる" do
    assert_equal 25, CURRICULUM.fetch("locations").size
    assert_equal 5, GUIDANCE.fetch("locations").size
    @questions.except("30-11").each do |id, question|
      original = source_fragment(id)
      assert_operator original.length, :>=, 100, id
      assert_includes question[:content_blocks].first[:text], "からの抜粋である。", id
      assert_no_match(/中略|示された内容に基づく記述/, quote(question), id)
      question[:choices].each do |choice|
        assert_equal choice.fetch(:correct), original.include?(source_normalize(restore(question, choice))), "#{id} #{choice[:label]}"
      end
    end
    assert_includes source_fragment("30-11"), source_normalize(quote(@questions.fetch("30-11")))
    [CURRICULUM, GUIDANCE].each do |fixture|
      fixture.fetch("documents").each do |name, document|
        assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\//, document.fetch("url"), name)
        assert_match(/\A[0-9a-f]{64}\z/, document.fetch("pdf_sha256"), name)
        assert document.fetch("pages").any?, name
      end
      fixture.fetch("locations").each do |id, location|
        document = fixture.fetch("documents").fetch(location.fetch("document"))
        location.fetch("pdf_pages").each { |page| assert document.fetch("pages").key?(page.to_s), id }
        assert location.fetch("notes").present?, id
      end
    end
  end

  test "四択一正答空欄列数二対二と本文補足への正答露出防止を維持する" do
    @questions.each do |id, question|
      choices = question.fetch(:choices)
      assert_equal LABELS, choices.map { |choice| choice.fetch(:label) }, id
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, id
      labels = id == "30-11" ? question[:content_blocks].find { |block| block[:type] == "table" }[:rows].flat_map { |row| row.join.scan(/【([①②③④])】/).flatten }.uniq : quote(question).scan(/\{\{([①②③④])\}\}/).flatten.uniq
      count = ["27-6", "28-8", "30-10"].include?(id) || id.end_with?("-11") ? 3 : 4
      assert_equal BLANKS.first(count), labels, id
      prompt_labels = id == "30-11" ? labels : [labels.first, labels.last]
      assert_equal prompt_labels, question[:content_blocks].first[:text].scan(/\{\{([①②③④])\}\}/).flatten.uniq, id
      choices.each do |choice|
        assert_equal 1, choice[:content_blocks].size, id
        assert_equal "fill_in_choice", choice[:content_blocks].first[:type], id
        assert_equal count, cells(choice).size, id
      end
      count.times do |column|
        assert_equal [2, 2], choices.map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{id} 列#{column + 1}"
      end
      visible = question[:content_blocks].map { |block| block[:type] == "table" ? [block[:headers], block[:rows]].flatten.join : block[:text] }.join
      cells(answer(question)).each { |term| assert_not_includes visible, term, "#{id} 導入・本文・補足・編集表への正答露出" }
      assert_not question[:content_blocks].any? { |block| block[:type] == "quote" }, id
      question[:content_blocks].select { |block| block[:type] == "text" }.each do |block|
        assert_no_match(/\{\{[^{}]+\}\}/, block.fetch(:text), "#{id} 通常textに未処理の空欄記法を残さない")
      end
    end
    { "26-10" => { "①" => 3, "②" => 3, "③" => 2 }, "26-11" => { "①" => 2, "②" => 2 },
      "28-10" => { "②" => 2, "③" => 2, "④" => 2 }, "29-11" => { "③" => 2 },
      "30-7" => { "②" => 2 }, "30-8" => { "②" => 2 } }.each do |id, repeats|
      repeats.each { |label, count| assert_equal count, quote(@questions.fetch(id)).scan("{{#{label}}}").size, "#{id} #{label}" }
    end
  end

  test "問六の範囲問七の内容分類問八問十の二対三と問十一の四対一を維持する" do
    @questions.each do |id, question|
      case question.fetch(:question_number)
      when 6
        assert_includes question[:content_blocks].first[:text], "第1章 総則 第3款 教育課程の実施と学習評価", id
        assert_match(/第3款/, question[:source_text], id)
      when 7
        assert_includes question[:content_blocks].first[:text], "第1章 総則 第5款 生徒の発達の支援", id
        assert_match(/第5款/, question[:source_text], id)
      when 11
        assert question[:content_blocks].first[:text].start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。"), id
      end
      if [6, 7, 8].include?(question[:question_number])
        heading = question[:content_blocks].first[:text][/の「(.+)」からの抜粋/, 1]
        assert heading, id
        assert_no_match(/(?:\([0-9]+\)|（[0-9]+）|[アイウエ])\z/, heading, id)
      end
    end
    { 8 => [26, 28], 10 => [27, 29] }.each do |number, body_exams|
      entries = @entries.select { |entry| entry[:attributes][:question_number] == number }
      assert_equal body_exams, entries.select { |entry| !entry[:attributes][:content_blocks].first[:text].include?("解説") }.map { |entry| entry[:exam_number] }, number
      assert_equal 3, entries.count { |entry| entry[:attributes][:content_blocks].first[:text].include?("解説") }, number
    end
    assert_equal 4, @questions.select { |id, question| id.end_with?("-11") && quote(question).include?("{{①}}") }.size
    question = @questions.fetch("30-11")
    assert_not quote(question).include?("{{")
    assert_includes question[:content_blocks].find { |block| block[:type] == "text" }[:text], "原典に掲載された表そのものではない"
    assert_includes quote(question), "学級・ホームルーム担任一人だけでは解決を図ることが困難"
  end

  test "編集した役割表は独立原典の職名と対象行動対応を保持する" do
    location = GUIDANCE.fetch("locations").fetch("30-11")
    roles = location.fetch("role_passages")
    expected = ["養護教諭", "教育相談コーディネーター", "特別支援教育コーディネーター"]
    assert_equal expected, cells(answer(@questions.fetch("30-11")))
    { "養護教諭" => ["健康", "保健室"], "教育相談コーディネーター" => ["カウンセリング", "即時的", "連携"],
      "特別支援教育コーディネーター" => ["発達障害", "校内委員会", "連絡", "保護者"] }.each do |role, terms|
      text = source_normalize(roles.fetch(role))
      terms.each { |term| assert_includes text, term, role }
    end
    question = @questions.fetch("30-11")
    assert_equal %w[イ ウ], question[:choices].select { |choice| cells(choice).values_at(0, 2) == expected.values_at(0, 2) }.map { |choice| choice[:label] }
    explanation = question[:explanation_blocks].map { |block| block[:text] }.join
    assert_includes explanation, "スクールカウンセラーも教職員"
    assert_not_includes explanation, "スクールカウンセラーは教職員ではない"
    supplement = @questions.fetch("30-9")[:content_blocks].find { |block| block[:type] == "text" }[:text]
    assert_includes supplement, "基盤となる道徳性を養う"
    assert_includes @questions.fetch("30-9")[:source_text], "参照先"
  end

  test "必須空欄の全消去と選択肢セル不足を三十問すべて投入前に拒否する" do
    @entries.each do |entry|
      path = Rails.root.join("db/seeds/mock_exam_#{entry[:exam_number]}.rb")
      source = File.read(path)
      number = entry[:attributes][:question_number]
      mutations = [
        "questions.find { |question| question[:question_number] == #{number} }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③④][}][}]/, \"語句\") if block[:type] == \"fill_in_quote\"; block[:rows] = block[:rows].map { |row| row.map { |cell| cell.gsub(/【[①②③④]】/, \"語句\") } } if block[:type] == \"table\" }\n",
        "questions.find { |question| question[:question_number] == #{number} }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      assert_includes source, "questions.each do |question|\n", key(entry)
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "未完五セットの十五問は管理取得のみ可能で一般一覧next取得回答へ公開しない" do
    save_partial_entries
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
    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
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

  test "二回再同期でID本文四択公開状態seed状態既存履歴お気に入りを変えない" do
    save_partial_entries
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    user = User.create!(name: "指導要領再同期確認", email: "mock26-curriculum-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 1], [26, 3], [26, 6], [30, 11]].each do |exam, number|
      record = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: record)
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_partial_entries
      end
      assert_equal before, snapshot
    end
  end

  test "十五問のみ登録された未完セットを公開する管理操作は不足を返して拒否する" do
    save_partial_entries
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 6)
      before = snapshot
      patch "/api/v1/admin/questions/#{record.id}", params: { question: QuestionPayload.from_record(record).merge("publication_status" => "published") }, headers: admin_headers, as: :json
      assert_response :unprocessable_content
      assert_includes response.parsed_body.dig("error", "message"), "問1〜20の登録が必要"
      assert_equal "draft", record.reload.publication_status
      assert_equal before, snapshot
    end
  end

  test "今回追加した三十問を除く既存五百十五問の変更前hashを全件維持する" do
    entries = QuestionSeedSync.collect { (1..30).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
    previous = APPROVED.fetch("existing_515_payload_digests")
    assert_equal 515, previous.size
    # Keep the original comparison keys and hashes fixed; later approved
    # additions have independent fixtures and are outside this historical set.
    unchanged = entries.select { |entry| previous.key?(key(entry)) }
    assert_equal previous.keys.sort, unchanged.map { |entry| key(entry) }.sort
    unchanged.each do |entry|
      assert_equal previous.fetch(key(entry)), QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes])), key(entry)
    end
    entries.select { |entry| entry[:exam_number] <= 25 }.group_by { |entry| entry[:exam_number] }.each do |exam, questions|
      assert_equal (1..20).to_a, questions.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, questions.map { |entry| answer(entry[:attributes])[:label] }.tally, exam
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

  def quote_blocks(question)
    question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  end

  def quote(question)
    quote_blocks(question).map { |block| block.fetch(:text) }.join("\n")
  end

  def normalize(text)
    text.to_s.gsub(/\{\{([①②③④])\}\}|【([①②③④])】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]+/, "")
  end

  def source_normalize(text)
    # Source fixtures retain independent original paragraphs. PDF extraction
    # spacing and the explicitly omitted footnote reference symbols are not
    # substantive changes. Do not silently strip words or clause references.
    text.gsub(/\[\*\d+\]/, "").unicode_normalize(:nfkc).gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
  end

  def source_fragment(id)
    fixture = id.end_with?("-11") ? GUIDANCE : CURRICULUM
    source_normalize(fixture.fetch("locations").fetch(id).fetch("source_fragment"))
  end

  def restore(question, choice)
    quote(question).gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def save_partial_entries
    # Preserve regression coverage for the incomplete draft stage, independently
    # of the publication state of today's complete seed files.
    QuestionWriter.transaction { @partial_entries.each { |entry| QuestionSeedSync.call(**entry.merge(publication_status: "draft")) } }
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "指導要領管理確認", email: "mock26-curriculum-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
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

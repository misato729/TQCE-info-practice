require "test_helper"
require_relative "../support/history_revision_20261017"
require "digest"

class MockExams41To50CompletionTest < ActionDispatch::IntegrationTest
  EXAMS = (41..50).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_41_to_50_approved.json"))).fetch("documents").freeze
  APPROVAL_HASHES = %w[
    cbbb10660b6af6852c1d34ef8f527939b0433680a65647e4c39fb063ad0210fc
    d5e32010189ed8a8da34fc4210ba4623f6f9f137cb71ef55d10200521654a2f7
  ].freeze
  LEGAL_INTROS = {
    "学校教育法" => "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
    "教育公務員特例法" => "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
    "地方公務員法" => "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
  }.freeze

  setup do
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
    @approved_sections = APPROVED.flat_map { |document| document.fetch("sections").to_a }.to_h
  end

  test "二百問八百択の完成公開と各試験の正答五件ずつを検査する" do
    assert_equal "bfd1100ffdeb9cd54048573e7ec174acd22d6fe20e7e4062ff1135728ba0702f",
      Digest::SHA256.file(Rails.root.join("test/fixtures/mock_exams_41_to_50_approved.json")).hexdigest,
      "独立した承認raw保存をseedの実装結果から作り直さない"
    expected = EXAMS.flat_map { |exam| (1..20).map { |number| "#{exam}-#{number}" } }
    assert_equal 200, @entries.size
    assert_equal expected.sort, @questions.keys.sort
    assert_equal expected.sort, @approved_sections.keys.sort
    assert_equal 800, @questions.values.sum { |question| question.fetch(:choices).size }
    assert_equal APPROVAL_HASHES, APPROVED.map { |document| document.fetch("sha256") }
    assert_equal ["document/模試41〜45_全20問草案_2026-10-17.md", "document/模試46〜50_全20問草案_2026-10-17.md"], APPROVED.map { |document| document.fetch("source_path") }
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry.fetch(:exam_number) == exam }
      assert_equal (1..20).to_a, entries.map { |entry| entry.fetch(:attributes).fetch(:question_number) }, exam
      assert_equal ["published"], entries.map { |entry| entry.fetch(:publication_status) }.uniq, exam
      answers = entries.map { |entry| correct(entry.fetch(:attributes)).fetch(:label) }
      assert_equal LABELS.to_h { |label| [label, 5] }, answers.tally, exam
      answers.each_cons(3) { |three| assert_operator three.uniq.size, :>, 1, "#{exam} 周期の手掛かりになる三連続" }
    end
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      assert_equal LABELS, question.fetch(:choices).map { |choice| choice.fetch(:label) }, id
      assert_equal 1, question.fetch(:choices).count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, question.fetch(:choices).map { |choice| choice.fetch(:content_blocks) }.uniq.size, id
      assert question.fetch(:source_text).lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      raw = @approved_sections.fetch(id)
      category_code = raw[/^分類：(?:教職教養|情報科特有)／(\d\.\d)/, 1]
      category = MasterData::CATEGORIES.find { |item| item.fetch(:label).start_with?("#{category_code} ") }
      assert category, id
      assert_equal category.fetch(:value), question.fetch(:category_code), id
      assert_equal question.fetch(:question_number) <= 15 ? "teacher_education" : "information", question.fetch(:major_category_code), id
      LABELS.each { |label| assert question.fetch(:explanation_blocks).any? { |block| block[:text]&.start_with?("#{label}：") }, "#{id} 全肢解説#{label}" }
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry.fetch(:exam_number), question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
  end

  test "独立した承認Markdown保存二百問から全本文四択正答全解説と出典を照合する" do
    @approved_sections.each do |id, raw|
      question = HistoryRevision20261017.historical_attributes(id, @questions.fetch(id))
      head, tail = raw.split(/^正答：[アイウエ]\s*$/, 2)
      assert head && tail, id
      assert_equal raw[/^正答：([アイウエ])$/, 1], correct(question).fetch(:label), id
      head = head.sub(/^分類：[^\n]*\n+/, "").sub(/^### 問題\s*\n+/, "")
      body, choices = split_choices(head, id)
      assert_equal normalized(body), normalized(block_text(question.fetch(:content_blocks))), "#{id} 全本文"
      assert_equal markdown_codes(body), question.fetch(:content_blocks).select { |block| block[:type] == "code" }.map { |block| block.fetch(:code) }, "#{id} コード字下げ"
      assert_equal markdown_tables(body), actual_tables(question.fetch(:content_blocks)), "#{id} 本文表"
      assert_choices_match(question, choices, id)

      source_match = tail.match(/^(?:###\s*)?出典[^\n]*/)
      assert source_match, id
      explanation = tail[0...source_match.begin(0)].sub(/\A\s*(?:### 解説|解説：)\s*\n/, "").strip
      source_area = tail[source_match.begin(0)..]
      explanation_blocks = question.fetch(:explanation_blocks)
      # Source-attribution and editing notes may follow the four explanations;
      # the entire approved explanation itself must still be present in order.
      actual = normalized(block_text(explanation_blocks))
      assert actual.start_with?(normalized(explanation)), "#{id} 全解説の欠落又は順序変更"
      assert_equal markdown_codes(explanation), explanation_blocks.select { |block| block[:type] == "code" }.map { |block| block.fetch(:code) }, "#{id} 解説コード字下げ"
      assert_equal markdown_tables(explanation), actual_tables(explanation_blocks), "#{id} 途中経過表"
      assert_equal expected_sources(source_area), question.fetch(:source_text), "#{id} 全出典"
      # Authoring audits and nearby-question comparisons are not student text.
      assert_no_match(/照合・メタ読み点検：|近い既存問題：|近接差：|追跡量・検算記録：/, block_text(question.fetch(:content_blocks)), id)
    end
  end

  test "承認出典五十三行の同資料略称だけを正式資料名へ展開しURLと章節を保持する" do
    changed = []
    @approved_sections.each do |id, raw|
      tail = raw.split(/^正答：[アイウエ]\s*$/, 2).last
      at = tail.index(/^(?:###\s*)?出典[^\n]*/)
      original = raw_sources(tail[at..]).lines.map(&:strip)
      expanded = HistoryRevision20261017.historical_attributes(id, @questions.fetch(id)).fetch(:source_text).lines.map(&:strip)
      assert_equal original.size, expanded.size, id
      original.zip(expanded).each do |before, after|
        assert_equal before.split(" | ", 2).last, after.split(" | ", 2).last, "#{id} URL保持"
        assert_equal expand_source_title(before), after, "#{id} 書誌展開の許可範囲"
        changed << [id, before, after] unless before == after
      end
    end
    assert_equal 53, changed.size
  end

  test "必須空欄と編集表とコードの空欄を区別し未知ラベルも見落とさない" do
    @questions.each do |id, question|
      number = question.fetch(:question_number)
      content = question.fetch(:content_blocks)
      assert content.none? { |block| block[:type] == "quote" }, "#{id} 試験抜粋はfill_in_quote"
      tables = actual_tables(content)
      tables.each { |table| assert_no_match(/\{\{/, table.values.flatten.join, "#{id} 表は【】表示") }
      next unless fill_choice?(question)

      count = cells(question.fetch(:choices).first).size
      assert_equal "fill_in_text", content.first.fetch(:type), id
      intro_labels = content.first.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten
      expected_labels = BLANKS.first(count)
      if [4, 5].include?(number)
        approved_intro = @approved_sections.fetch(id).lines.find { |line| line.start_with?("次の各文は") }.strip
        law_name = number == 4 ? "学校教育法" : approved_intro.include?("教育公務員特例法") ? "教育公務員特例法" : "地方公務員法"
        assert_equal LEGAL_INTROS.fetch(law_name), approved_intro, "#{id} 承認済みの固定導入"
        assert_equal LEGAL_INTROS.fetch(law_name), content.first.fetch(:text), "#{id} 法令穴埋めの固定導入"
        assert_empty intro_labels, "#{id} 導入の丸数字へ空欄枠を追加しない"
      else
        assert_equal [expected_labels.first, expected_labels.last].uniq, intro_labels.uniq, id
      end
      quote_blocks = content.select { |block| block[:type] == "fill_in_quote" }
      labels = quote_blocks.flat_map { |block| block.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten }.uniq
      if %w[45-11 50-11].include?(id)
        assert_empty labels, id
        assert_equal 1, quote_blocks.size, id
        labels = tables.flat_map { |table| table.values.flatten.join.scan(/【([^】]+)】/).flatten }.uniq
      elsif id == "42-19"
        assert_empty quote_blocks, id
        labels = content.select { |block| block[:type] == "code" }.flat_map { |block| block.fetch(:code).scan(/【([^】]+)】/).flatten }.uniq
      else
        assert_equal 1, quote_blocks.size, id
      end
      # Repeated labels retain their source positions; the first occurrence of
      # each label need not be numerical order (for example 47-7).
      assert_equal expected_labels.sort, labels.sort, id
      question.fetch(:choices).each { |choice| assert_equal count, cells(choice).size, id }
      question.fetch(:choices).map { |choice| cells(choice) }.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, id }
      assert_equal 4, count, id if [4, 5].include?(number)
      assert (2..3).cover?(count), id if number == 11
    end
    EXAMS.each do |exam|
      (6..10).each { |number| assert fill_choice?(@questions.fetch("#{exam}-#{number}")), "#{exam}-#{number}" }
      [4, 5].each { |number| assert_match(/\A第\d+条/, quote(@questions.fetch("#{exam}-#{number}")), "#{exam}-#{number} 条番号") }
    end
    # Mutation checks exercise each distinct presentation: ordinary quotation,
    # edited figure/table, and a code question with two replacement cells.
    %w[41-4 41-6 41-11 45-11 46-4 46-11 50-11 42-19].each do |id|
      entry = @entries.find { |item| key(item) == id }
      %w[⑤ foo].each do |label|
        invalid = Marshal.load(Marshal.dump(entry))
        invalid[:attributes][:content_blocks].first[:text] += "{{#{label}}}"
        assert_invalid_publication(invalid, "#{id} #{label}")
      end
      invalid = Marshal.load(Marshal.dump(entry))
      invalid[:attributes][:choices].first[:content_blocks].first[:cells].pop
      assert_invalid_publication(invalid, "#{id} セル不足")
      invalid = Marshal.load(Marshal.dump(entry))
      invalid[:attributes][:content_blocks].each do |block|
        block[:text] = block[:text].gsub(/\{\{[^{}]+\}\}/, "語句") if block[:type] == "fill_in_quote"
        block[:rows]&.each { |row| row.map! { |cell| cell.gsub(/【[^】]+】/, "語句") } } if block[:type] == "table"
        block[:code] = block[:code].gsub(/【[^】]+】/, "語句") if block[:type] == "code"
      end
      # Introductory labels alone must not make a blank-free quote/table valid.
      assert_invalid_seed(invalid, "#{id} 本文空欄全消去")
    end
    %w[41-4 41-5 46-4 46-5 49-5].each do |id|
      entry = @entries.find { |item| key(item) == id }
      invalid = Marshal.load(Marshal.dump(entry))
      invalid[:attributes][:content_blocks].first[:text].gsub!(/①|④/) { |label| "{{#{label}}}" }
      assert_invalid_seed(invalid, "#{id} 固定導入への空欄枠追加")
    end
  end

  test "五セットごとの形式比率と原典範囲及び情報三範囲の項目順を維持する" do
    [41..45, 46..50].each do |batch|
      entries = batch.map { |exam| @questions.fetch("#{exam}-3") }
      assert_includes [2, 3], entries.count { |question| fill_choice?(question) }
      assert entries.any? { |question| block_text(question[:content_blocks]).match?(/適切でない|正しくない/) }
      assert entries.any? { |question| block_text(question[:content_blocks]).include?("正しいものはいくつ") }
      assert entries.any? { |question| !fill_choice?(question) && !block_text(question[:content_blocks]).match?(/正しいものはいくつ|適切でない|正しくない/) }
      assert_equal 4, batch.count { |exam| @questions.fetch("#{exam}-5")[:source_text].include?("教育公務員特例法") }
      assert_equal 4, batch.count { |exam| quote(@questions.fetch("#{exam}-11")).include?("{{") }
      assert_equal 1, batch.count { |exam| fill_choice?(@questions.fetch("#{exam}-15")) }
      [8, 10].each do |number|
        assert_includes [2, 3], batch.count { |exam| @questions.fetch("#{exam}-#{number}")[:content_blocks].first[:text].include?("解説") }
      end
    end
    EXAMS.each do |exam|
      curriculum = @questions.fetch("#{exam}-6")
      [curriculum[:content_blocks].first[:text], curriculum[:source_text]].each { |text| assert_match(/第[1１]章.*第[3３]款/, text, exam) }
      guidance = @questions.fetch("#{exam}-11")
      assert guidance[:content_blocks].first[:text].start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。"), exam
      ranges = (16..18).map do |number|
        question = @questions.fetch("#{exam}-#{number}")
        range = information_range(question[:content_blocks].first[:text])
        if range <= 2
          assert_includes question[:source_text], "20230120-mxt_kyoiku02-100002604_03.pdf"
        else
          assert_includes question[:source_text], "1407073_11_1_2.pdf"
          assert_includes question[:source_text], range == 3 ? "第1部" : "第2部"
        end
        range
      end
      assert_equal 3, ranges.uniq.size, exam
      assert_equal ranges.sort, ranges, exam
    end
  end

  test "有料会員が全二百問を取得回答でき回答前は解答を秘匿し再seedもID履歴を保つ" do
    save_entries
    assert_equal 200, Question.where(exam_number: EXAMS, publication_status: "published").count
    user, paid = user_headers("paid", paid: true)
    _, admin = user_headers("admin", admin: true)
    _, free = user_headers("free")
    [paid, admin].each do |headers|
      get api_v1_exams_path, headers: headers
      assert_response :success
      visible = response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam.fetch("exam_number")) }
      assert_equal EXAMS, visible.map { |exam| exam.fetch("exam_number") }
      visible.each { |exam| assert_equal (1..20).to_a, exam.fetch("question_numbers"); assert_equal 20, exam.fetch("published_question_count") }
      assert_no_public_answers(response.parsed_body)
    end
    records = Question.where(exam_number: EXAMS).order(:exam_number, :question_number)
    records.each do |question|
      # Content/authorization coverage is not a load test. Limits themselves
      # are covered separately; keep counters local to each question here.
      ApiRateLimitBucket.delete_all
      get api_v1_question_path(question), headers: paid
      assert_response :success
      assert_equal question.content_blocks, response.parsed_body.dig("data", "content_blocks")
      assert_no_public_answers(response.parsed_body)
      assert_difference("AnswerHistory.count", 1) do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.find_by!(is_correct: true).id }, headers: paid, as: :json
      end
      assert_response :success
      assert_equal true, response.parsed_body.dig("data", "is_correct")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
      user.favorites.create!(question: question) if question.question_number == 11
    end
    EXAMS.each do |exam|
      question = records.find { |item| item.exam_number == exam && item.question_number == 11 }
      get api_v1_question_path(question), headers: admin
      assert_response :success
      assert_no_public_answers(response.parsed_body)
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 18 }, headers: paid
      assert_response :success
      assert_equal [exam, 19], response.parsed_body.fetch("data").values_at("exam_number", "question_number")
      assert_no_public_answers(response.parsed_body)
      [nil, free].each do |headers|
        get api_v1_question_path(question), headers: headers
        assert_response headers ? :forbidden : :unauthorized
        assert_no_public_answers(response.parsed_body)
        assert_no_difference("AnswerHistory.count") do
          post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, headers: headers, as: :json
        end
        assert_response headers ? :forbidden : :unauthorized
        assert_no_public_answers(response.parsed_body)
      end
    end
    assert_equal 200, AnswerHistory.count
    assert_equal 10, Favorite.count
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
      assert_equal before, snapshot
    end
  end

  private

  def key(entry) = "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  def correct(question) = question.fetch(:choices).find { |choice| choice.fetch(:correct) }
  def quote(question) = question.fetch(:content_blocks).find { |block| block.fetch(:type) == "fill_in_quote" }.fetch(:text)
  def cells(choice) = choice.fetch(:content_blocks).first.fetch(:cells)
  def fill_choice?(question) = question.fetch(:choices).all? { |choice| choice.fetch(:content_blocks).first.fetch(:type) == "fill_in_choice" }
  def markdown_row(line) = line.strip.split("|", -1)[1...-1].map { |cell| cell.strip.delete("`") }
  def markdown_codes(text) = text.scan(/```[^\n]*\n(.*?)\n```/m).flatten

  def markdown_tables(text)
    text.scan(/(?:^\|[^\n]*\|[ \t]*\n){2,}/).map do |table|
      rows = table.lines.select { |line| line.start_with?("|") }
        .reject { |line| line.match?(/\A\|[\s:|\-]+\|\s*\z/) }.map { |line| markdown_row(line) }
      { headers: rows.shift, rows: rows }
    end
  end

  def actual_tables(blocks) = blocks.select { |block| block[:type] == "table" }.map { |block| block.slice(:headers, :rows) }

  def block_text(blocks)
    blocks.map { |block| block[:type] == "table" ? (block.fetch(:headers) + block.fetch(:rows).flatten).join("\n") : block[:text] || block[:code] }.join("\n")
  end

  def normalized(text)
    text.lines.reject { |line| line.match?(/\A\s*```/) || line.match?(/\A\|[\s:|\-]+\|\s*\z/) || line.match?(/\A(?:###\s*(?:問題|解説)|解説：)\s*\z/) }
      .map { |line| line.sub(/\A> ?/, "").sub(/\A- /, "").delete("|`") }.join
      .gsub(/\{\{([^{}]+)\}\}|【([^】]+)】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]/, "")
  end

  def split_choices(head, id)
    tables = head.to_enum(:scan, /(?:^\|[^\n]*\|[ \t]*\n){2,}/).map { Regexp.last_match }
    table = tables.find { |match| match[0].match?(/^\|\s*ア\s*\|/) }
    at = table&.begin(0) || head.index(/^[アイウエ]　/)
    assert at, "#{id} 四択位置"
    [head[0...at], head[at..]]
  end

  def assert_choices_match(question, markdown, id)
    rows = markdown.lines.grep(/^\|\s*[アイウエ]\s*\|/).map { |line| markdown_row(line) }
    if rows.any?
      header = markdown_tables(markdown).first.fetch(:headers).drop(1)
      rows.zip(question.fetch(:choices)).each do |(label, *values), choice|
        assert_equal label, choice.fetch(:label), id
        if choice.fetch(:content_blocks).first.fetch(:type) == "fill_in_choice"
          assert_equal values, cells(choice), "#{id} #{label} 全セル"
        else
          text = values.size == 1 ? values.first : header.zip(values).map { |name, value| "#{name}：#{value}" }.join("／")
          assert_equal normalized(text), normalized(block_text(choice.fetch(:content_blocks))), "#{id} #{label} 表選択肢"
        end
      end
    else
      expected = markdown.scan(/^([アイウエ])　(.+)$/).map { |label, text| [label, normalized(text)] }
      assert_equal expected, question.fetch(:choices).map { |choice| [choice.fetch(:label), normalized(block_text(choice.fetch(:content_blocks)))] }, "#{id} 四択全文"
    end
  end

  def expected_sources(source_area)
    raw_sources(source_area).lines.map { |line| expand_source_title(line.strip) }.join("\n")
  end

  def raw_sources(source_area)
    explicit = source_area.match(/`source_text`[^\n]*\n+```(?:text)?\n(.*?)\n```/m)
    return explicit[1].strip if explicit

    lines = source_area.lines
    lines.shift if lines.first.start_with?("###")
    lines[0] = lines[0].sub(/\A出典：/, "") if lines.first
    lines.shift while lines.first&.strip == ""
    link_lines = []
    lines.each do |line|
      next if line.strip.empty?
      break unless line.match?(/\[[^\]\n]+\]\(https:\/\//)
      link_lines << line
    end
    link_lines.join.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/).map { |title, url| "#{title} | #{url}" }.join("\n")
  end

  def expand_source_title(line)
    title, url = line.split(" | ", 2)
    replacement = title
    information = "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』"
    report = "中央教育審議会「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」"
    textbook = "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』"
    if url.include?("/1407073_11_1_2.pdf")
      replacement = title.sub(/\A同解説 /, "#{information} ")
      # 49-18: this reference repeats the preceding citation's exact section.
      replacement = "#{information} 第2部 第2章 第8節 第2 #{title.delete_prefix('同')}" if title.start_with?("同2（")
    elsif url.include?("/20210126-mxt_syoto02-000012321_2-4.pdf")
      replacement = title.sub(/\A同答申 /, "#{report} ")
    elsif url.match?(%r{/20200722-mxt_jogai02-100013300_00[56]\.pdf})
      replacement = title.sub(/\A文部科学省 (?:情報Ⅰ)?同教材 /, "#{textbook} ")
      replacement = "#{textbook} 第3章 #{title}" if title.start_with?("学習")
      replacement = "#{textbook} 第3章 #{title.delete_prefix('同')}" if title.start_with?("同学習")
    elsif title.start_with?("同法")
      law = { "322AC0000000026" => "学校教育法", "324AC0000000001" => "教育公務員特例法" }
        .find { |id, _name| url.include?("/law/#{id}") }&.last
      replacement = "e-Gov法令検索「#{law}」 #{title.delete_prefix('同法')}" if law
    end
    "#{replacement} | #{url}"
  end

  def information_range(intro)
    return 3 if intro.match?(/解説\s*情報編/) && intro.include?("第1部")
    return 4 if intro.match?(/解説\s*情報編/) && intro.include?("第2部")
    return 1 if intro.match?(/第2章.*第10節/)
    return 2 if intro.match?(/第3章.*第7節/)
    flunk "情報範囲が問題文にない：#{intro}"
  end

  def assert_invalid_publication(entry, message)
    assert_raises(ActiveRecord::RecordInvalid, RuntimeError, message) do
      question = QuestionSeedSync.preview(entry)
      QuestionWriter.validate_publication!(question, QuestionPayload.from_seed(entry[:exam_number], entry[:attributes]).fetch("choices").map(&:symbolize_keys))
    end
  end

  def assert_invalid_seed(entry, message)
    path = Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{entry.fetch(:exam_number)}.rb")
    source = File.read(path)
    insertion = "questions.each do |question|\n"
    assert_includes source, insertion, message
    mutation = "questions.find { |question| question[:question_number] == #{entry.fetch(:attributes).fetch(:question_number)} }[:content_blocks] = #{entry.fetch(:attributes).fetch(:content_blocks).inspect}\n"
    assert_raises(ActiveRecord::RecordInvalid, RuntimeError, message) do
      QuestionSeedSync.collect { eval(source.sub(insertion, mutation + insertion), binding, path.to_s) }
    end
  end

  def save_entries = QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }

  def user_headers(label, paid: false, admin: false)
    user = User.create!(name: "千問完成確認#{label}", email: "mock41-50-#{label}@example.com", role: admin ? "admin" : "user", password: "password123", password_confirmation: "password123")
    if paid
      payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_mock41_50_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
      user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    end
    [user, { "Authorization" => "Bearer #{AuthToken.issue(user)}" }]
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
end

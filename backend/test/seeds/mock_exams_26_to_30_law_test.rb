require "test_helper"
require_relative "../support/history_revision_20261017"
require "digest"

class MockExams26To30LawTest < ActionDispatch::IntegrationTest
  EXAMS = (26..30).to_a.freeze
  NUMBERS = [3, 4, 5].freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  ANSWERS = { 26 => %w[イ エ ア], 27 => %w[エ ア イ], 28 => %w[ウ イ エ], 29 => %w[ア ウ イ], 30 => %w[イ ア エ] }.freeze
  LAW_DATA = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_law_data.json"))).freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_26_to_30_approved_law_drafts.json"))).fetch("sections").freeze
  # Captured before this implementation, from the unchanged 500 published seeds.
  EXISTING_500_DIGEST = "16ed7729864c39b37c88f1080b39de6e7a47591aa0c1eebe18d25172539b8b17".freeze
  # Preserve the historical 500-question aggregate, replacing only the seven
  # later approved curriculum revisions with their independently captured old
  # hashes. Their current content is checked against official source pages.
  CURRICULUM_REVISION_BASELINE = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_curriculum_revision_sources.json"))).fetch("previous_payload_digests").freeze
  SCHOOL_PROMPT = "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  SPECIAL_PROMPT = "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end.select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認された十五問の本文補足四択正答全解説出典を独立草案snapshotと照合する" do
    assert_equal 15, @entries.size
    assert_equal APPROVED.keys.sort, @questions.keys.sort
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry.fetch(:exam_number) == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
    end
    @entries.each do |entry|
      id = key(entry)
      attributes = entry.fetch(:attributes)
      assert_equal "teacher_education", attributes.fetch(:major_category_code), id
      assert_equal "education_system", attributes.fetch(:category_code), id
      assert_equal LABELS, attributes.fetch(:choices).map { |choice| choice.fetch(:label) }, id
      assert_equal 1, attributes.fetch(:choices).count { |choice| choice.fetch(:correct) }, id
      preview = QuestionSeedSync.preview(entry)
      payload = QuestionPayload.from_seed(entry[:exam_number], attributes)
      QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))

      approved = APPROVED.fetch(id)
      head, tail = approved.split(/^正答：[アイウエ].*$/, 2)
      assert_equal answer(attributes).fetch(:label), approved[/^正答：([アイウエ])/, 1], id
      if cloze?(attributes)
        body = head.split(/^\|/).first.lines.map { |line| line.sub(/^> ?/, "") }.join
        assert_equal normalize(body), normalize(body_text(attributes)), id
        rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| line.split("|")[1...-1].map(&:strip) }
        assert_equal attributes[:choices].map { |choice| [choice[:label], *cells(choice)] }, rows, id
      else
        first_choice = head.index(/^[アイウエ][　 ]/)
        assert first_choice, "#{id} 草案の選択肢"
        assert_equal normalize(head[0...first_choice]), normalize(body_text(attributes)), id
        pairs = head[first_choice..].split(/^([アイウエ])[　 ]/).drop(1).each_slice(2).map { |label, text| [label, normalize(text)] }
        assert_equal attributes[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first.fetch(:text))] }, pairs, id
      end
      explanation, source_line = tail.split(/^出典：/, 2)
      explanation = explanation.strip.sub(/\A解説：\s*/, "").gsub(/^- /, "")
      assert_equal normalize(explanation), normalize(attributes[:explanation_blocks].map { |block| block.fetch(:text) }.join), id
      sources = source_line.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/).map do |title, url|
        # The draft abbreviates the second school-law source to its article.
        # Expand the title explicitly to keep each API source self-contained.
        title = "学校教育法#{title}" if attributes[:question_number] == 4 && title.start_with?("第")
        "#{title} | #{url}"
      end.join("\n")
      assert_equal sources, attributes.fetch(:source_text), id
      assert attributes[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
    end
  end

  test "十二原文穴埋めは正答のみ独立取得した施行版本文全体に一致する" do
    assert_equal 12, LAW_DATA.fetch("cloze_locations").size
    assert_equal LAW_DATA.fetch("cloze_locations").keys.sort, @questions.select { |_id, attributes| cloze?(attributes) }.keys.sort
    LAW_DATA.fetch("cloze_locations").each do |id, parts|
      attributes = @questions.fetch(id)
      original = parts.map { |part| law_part(part) }.join
      quotes = quote_blocks(attributes)
      assert_equal BLANKS, quotes.flat_map { |block| block[:text].scan(/\{\{([①②③④])\}\}/).flatten }.uniq, id
      attributes.fetch(:choices).each do |choice|
        assert_equal 4, cells(choice).size, id
        restored = quotes.map do |block|
          strip_numbers(block[:text].gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) })
        end.join
        assert_equal choice.fetch(:correct), normalize(restored) == normalize(original), "#{id} #{choice[:label]}"
      end
      4.times do |column|
        assert_equal [2, 2], attributes[:choices].map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{id} 列#{column + 1}"
      end
      cells(answer(attributes)).each { |term| assert_not_includes body_text(attributes), term, "#{id} 本文・補足への正答露出" }
    end
    expected_versions = {
      "education" => ["418AC0000000120_20061222_000000000000000", "2006-12-22"],
      "school" => ["322AC0000000026_20260617_508AC0000000037", "2026-06-17"],
      "special" => ["324AC0000000001_20260401_507AC0000000068", "2026-04-01"],
      "local" => ["325AC0000000261_20250601_504AC0000000068", "2025-06-01"],
    }
    expected_versions.each do |name, (revision, enforcement_date)|
      law = LAW_DATA.fetch("laws").fetch(name)
      assert_equal revision, law.dig("revision_info", "law_revision_id"), name
      assert_equal enforcement_date, law.dig("revision_info", "amendment_enforcement_date"), name
      # The API's status is relative to its latest registered revision, not the
      # date of this draft. Future school-law revisions are not applicable yet.
      assert_equal name == "school" ? "PreviousEnforced" : "CurrentEnforced", law.dig("revision_info", "current_revision_status"), name
      assert_operator enforcement_date, :<=, law.fetch("retrieved_on"), name
      assert_equal "2026-10-12", law.fetch("retrieved_on"), name
      assert_match(/\A[0-9a-f]{64}\z/, law.fetch("source_response_sha256"), name)
    end
    assert_equal 2, quote_blocks(@questions.fetch("28-4")).size
    assert_equal "第54条第1項・第2項", quote_blocks(@questions.fetch("28-4")).first[:text].lines.first.strip
    assert_equal "第59条", quote_blocks(@questions.fetch("28-4")).last[:text].lines.first.strip
  end

  test "指定導入条番号形式配分及び同一語句の再登場を維持する" do
    assert_equal [27, 29], @entries.select { |entry| entry[:attributes][:question_number] == 3 && cloze?(entry[:attributes]) }.map { |entry| entry[:exam_number] }
    assert_includes @questions.fetch("26-3")[:content_blocks].first[:text], "正しいものを"
    assert_includes @questions.fetch("28-3")[:content_blocks].first[:text], "適切でないものを"
    assert_includes @questions.fetch("30-3")[:content_blocks].first[:text], "正しいものが幾つあるか"
    assert_equal 4, @entries.count { |entry| entry[:attributes][:question_number] == 5 && body_text(entry[:attributes]).include?("教育公務員特例法") }
    assert_equal 1, @entries.count { |entry| entry[:attributes][:question_number] == 5 && body_text(entry[:attributes]).include?("地方公務員法") }
    @entries.select { |entry| [4, 5].include?(entry[:attributes][:question_number]) }.each do |entry|
      attributes = entry.fetch(:attributes)
      assert_equal "fill_in_text", attributes[:content_blocks].first[:type], key(entry)
      expected = entry[:attributes][:question_number] == 4 ? SCHOOL_PROMPT : SPECIAL_PROMPT
      expected = expected.sub("教育公務員特例法", "地方公務員法").sub("昭和24年法律第1号", "昭和25年法律第261号") if key(entry) == "28-5"
      assert_equal expected, attributes[:content_blocks].first[:text], key(entry)
      assert quote_blocks(attributes).all? { |block| block[:text].match?(/\A第\d+条(?:の\d+)?/) }, key(entry)
      assert_not attributes[:content_blocks].any? { |block| block[:type] == "quote" }, key(entry)
    end
    { "27-3" => { "①" => 2 }, "29-4" => { "③" => 2 }, "26-5" => { "①" => 2 }, "27-5" => { "①" => 3, "②" => 7 }, "28-5" => { "②" => 2 } }.each do |id, repeated|
      text = quote_blocks(@questions.fetch(id)).map { |block| block[:text] }.join
      repeated.each { |label, count| assert_equal count, text.scan("{{#{label}}}").size, "#{id} #{label}" }
    end
  end

  test "個数問題の並列規定を存在しない必要条件へ変えた誤り及び補足根拠を保持する" do
    question = @questions.fetch("30-3")
    text = body_text(question)
    assert_includes text, "身分の尊重及び待遇の適正が確保されていることを要件として"
    assert_equal "イ", answer(question)[:label]
    assert_equal %w[三つ 二つ 一つ なし], question[:choices].map { |choice| choice[:content_blocks].first[:text] }
    original = law_part(["education", "9", ["2"]])
    assert_includes original, "その身分は尊重され、待遇の適正が期せられるとともに、養成と研修の充実が図られなければならない。"
    assert_not_includes original, "要件"
    assert_includes question[:explanation_blocks].map { |block| block[:text] }.join, "前者の確保を後者の法的要件とする規定ではない"
    assert_includes law_part(["education", "14", ["2"]]), "法律に定める学校は、特定の政党"
    assert_includes law_part(["education", "15", ["2"]]), "国及び地方公共団体が設置する学校"
    assert_includes law_part(["special", "22_3", ["1"]]), "職責、経験及び適性に応じて向上を図るべき"
    assert_includes law_part(["special", "26", ["1"]]), "主務教諭"
    assert_includes law_part(["special", "22_4", ["2"]]), "研修実施者実施研修"
    assert_includes law_part(["school", "62", ["1"]]), "第三十四条"
  end

  test "必須空欄の全消去とセル不足を十二問すべてで投入前に拒否する" do
    @entries.select { |entry| cloze?(entry[:attributes]) }.each do |entry|
      exam = entry.fetch(:exam_number)
      number = entry[:attributes][:question_number]
      path = Rails.root.join("db/seeds/mock_exam_#{exam}.rb")
      source = File.read(path)
      mutations = [
        "questions.find { |question| question[:question_number] == #{number} }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③④][}][}]/, \"語句\") if block[:type] == \"fill_in_quote\" }\n",
        "questions.find { |question| question[:question_number] == #{number} }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      mutations.each do |mutation|
        assert source.include?("questions.each do |question|\n")
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "十五問は管理取得でき管理者が利用する一般一覧next取得回答にも公開されない" do
    save_entries
    assert_equal 15, Question.where(exam_number: EXAMS, question_number: NUMBERS, publication_status: "draft").count
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
      assert_equal 3, response.parsed_body.dig("meta", "total_count")
      assert_equal NUMBERS, response.parsed_body.fetch("data").map { |record| record.fetch("question_number") }
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
      get api_v1_question_path(record), headers: headers
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(record), params: { selected_choice_id: record.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      end
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
  end

  test "再同期二回でID本文選択肢公開状態seed状態既存履歴お気に入りを変えない" do
    save_entries
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    user = User.create!(name: "法令再同期確認", email: "mock26-law-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 1], [26, 3]].each do |exam, number|
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

  test "十五問のみ登録された未完セットの公開を管理APIが拒否する" do
    save_entries
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 3)
      payload = QuestionPayload.from_record(record).merge("publication_status" => "published")
      before = snapshot
      patch "/api/v1/admin/questions/#{record.id}", params: { question: payload }, headers: admin_headers, as: :json
      assert_response :unprocessable_content
      assert_equal "validation_error", response.parsed_body.dig("error", "code")
      assert_includes response.parsed_body.dig("error", "message"), "問1〜20の登録が必要"
      assert_equal "draft", record.reload.publication_status
      assert_equal before, snapshot
    end
  end

  test "既存五百問の旧照合値を保ち承認済み改稿七問は原典検査へ委譲する" do
    existing = QuestionSeedSync.collect do
      (1..25).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    assert_equal 500, existing.size
    digest_input = existing.map do |entry|
      id = key(entry)
      digest = HistoryRevision20261017.historical_payload_digest(id, entry[:exam_number], entry[:attributes])
      [id, CURRICULUM_REVISION_BASELINE.fetch(id, digest)]
    end.sort.map { |id, digest| "#{id}|#{digest}" }.join("\n")
    assert_equal EXISTING_500_DIGEST, Digest::SHA256.hexdigest(digest_input)
  end

  private

  def key(entry)
    "#{entry.fetch(:exam_number)}-#{entry.fetch(:attributes).fetch(:question_number)}"
  end

  def answer(attributes)
    attributes.fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def cloze?(attributes)
    attributes.fetch(:choices).first.fetch(:content_blocks).first[:type] == "fill_in_choice"
  end

  def quote_blocks(attributes)
    attributes.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  end

  def body_text(attributes)
    attributes.fetch(:content_blocks).map { |block| block.fetch(:text) }.join("\n")
  end

  def normalize(text)
    text.gsub(/\{\{([①②③④])\}\}|【([①②③④])】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[\s　\p{Cc}]/, "")
  end

  def strip_numbers(text)
    text.lines.map do |line|
      next "" if line.strip.match?(/\A第\d+条(?:の\d+)?(?:第\d+項)?(?:・第\d+項)?\z/)
      line.sub(/\A第\d+条(?:の\d+)?(?:第\d+項)?[　 \t]*/, "").sub(/\A[0-9０-９]+[　 \t]+/, "")
    end.join
  end

  def law_part(part)
    law, article, paragraphs = part
    values = LAW_DATA.fetch("laws").fetch(law).fetch("articles").fetch(article)
    paragraphs.map { |paragraph| values.fetch(paragraph) }.join
  end

  def save_entries
    # Reconstruct the original incomplete, unpublished stage explicitly. The
    # approved content stays under test after later questions complete the set.
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry.merge(publication_status: "draft")) } }
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "法令管理確認", email: "mock26-law-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
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

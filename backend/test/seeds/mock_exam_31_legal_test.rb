require "test_helper"
require "digest"

class MockExam31LegalTest < ActionDispatch::IntegrationTest
  NUMBERS = [3, 4, 5].freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exam_31_approved_legal_drafts.json"))).freeze
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exam_31_legal_originals.json"))).freeze
  ANSWERS = %w[ア ウ イ].freeze

  setup do
    @entries = QuestionSeedSync.collect { load Rails.root.join("db/seeds/mock_exam_31.rb") }
      .select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
      .map { |entry| entry.merge(publication_status: "draft") } # Historical three-question draft test, independent of the completed set.
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認三問の本文四択正答全解説出典分類をseedと独立した草案snapshotで保持する" do
    assert_equal 3, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    assert_equal "document/模試31_問3〜5草案_2026-10-14.md", APPROVED.fetch("source_path")
    # Capture-time document digest, not regenerated from a modified seed.
    assert_equal "5c91fd8bb0a31652f83fd724731706a4b5b4f28ddbecac467c31013cb79ff637", APPROVED.fetch("sha256")
    assert_equal "a949068053fc4ff39ad1fac0736ead72225082521f4ea802a841d42c8931289f",
      Digest::SHA256.file(Rails.root.join("test/fixtures/mock_exam_31_approved_legal_drafts.json")).hexdigest
    assert_equal NUMBERS, @entries.map { |entry| entry[:attributes][:question_number] }
    assert_equal ANSWERS, @entries.map { |entry| answer(entry[:attributes])[:label] }
    category = MasterData::CATEGORIES.find { |item| item[:value] == "education_system" }
    assert category
    assert_equal "teacher_education", category.fetch(:major_category_value)

    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      draft = APPROVED.fetch("sections").fetch(id)
      head, tail = draft.split(/^正答：[アイウエ]$/, 2)
      assert_equal draft[/^正答：([アイウエ])$/, 1], answer(question).fetch(:label), id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert_equal "education_system", question.fetch(:category_code), id
      assert_equal "draft", entry.fetch(:publication_status), id
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id

      if id == "31-3"
        choice_start = head.index(/^[アイウエ]　/)
        assert choice_start, id
        assert_equal [{ type: "text", text: head[0...choice_start].strip }], question.fetch(:content_blocks), id
        pairs = head[choice_start..].scan(/^([アイウエ])　([^\n]+)/)
        assert_equal pairs, question[:choices].map { |choice| [choice[:label], choice[:content_blocks].first[:text]] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "text" }, id
      else
        expected_quote = head.lines.grep(/^>/).map { |line| line.sub(/\A> ?/, "") }.join.strip
          .gsub(/【([①②③④])】/, '{{\1}}')
        expected_body = [
          { type: "fill_in_text", text: head.split(/\n{2,}/).first.strip },
          { type: "fill_in_quote", text: expected_quote },
        ]
        assert_equal expected_body, question.fetch(:content_blocks), id
        rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| line.split("|")[1...-1].map(&:strip) }
        assert_equal rows, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
        assert question[:choices].all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "fill_in_choice" }, id
      end

      explanation, source_tail = tail.split(/^出典：/, 2)
      expected_explanation = explanation.strip.sub(/\A### 解説\n/, "").strip.split(/\n{2,}/).flat_map do |paragraph|
        paragraph.start_with?("- ") ? paragraph.lines.map { |line| line.sub(/\A- /, "").strip } : paragraph
      end
      assert_equal expected_explanation.map { |text| { type: "text", text: text } }, question.fetch(:explanation_blocks), id
      LABELS.each { |label| assert expected_explanation.any? { |text| text.start_with?("#{label}：") }, id }
      expected_sources = source_tail.split(/\n{2,}/).first.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/)
        .map { |title, url| "#{title} | #{url}" }.join("\n")
      assert_not_empty expected_sources, id
      assert_equal expected_sources, question.fetch(:source_text), id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id

      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
      assert_equal "draft", preview.publication_status, id
    end
  end

  test "原文固定fixtureの施行版本則条項と連続二段落に正答だけが完全復元一致する" do
    assert_equal "173a5c4fdcf80a3aec6e5403c80a0edf7738c00dac89940600bcb3bc73584564",
      Digest::SHA256.file(Rails.root.join("test/fixtures/mock_exam_31_legal_originals.json")).hexdigest
    versions = {
      "education" => ["418AC0000000120_20061222_000000000000000", "2006-12-22"],
      "school" => ["322AC0000000026_20260617_508AC0000000037", "2026-06-17"],
      "special" => ["324AC0000000001_20260401_507AC0000000068", "2026-04-01"],
    }
    versions.each do |name, (version, date)|
      law = ORIGINALS.fetch("laws").fetch(name)
      assert_equal version, law.dig("revision_info", "law_revision_id"), name
      assert_equal date, law.dig("revision_info", "amendment_enforcement_date"), name
      assert_equal "2026-10-14", law.fetch("retrieved_on"), name
      assert_match(/\A[0-9a-f]{64}\z/, law.fetch("source_response_sha256"), name)
      # API revision status is relative to registered versions. School-law
      # future versions do not change the version applicable on this date.
      assert_equal(name == "school" ? "PreviousEnforced" : "CurrentEnforced", law.dig("revision_info", "current_revision_status"), name)
    end
    assert_equal({ "31-4" => [["school", "37", %w[9 10]]], "31-5" => [["special", "22", %w[1 2]]] }, ORIGINALS.fetch("cloze_locations"))

    ORIGINALS.fetch("cloze_locations").each do |id, locations|
      question = @questions.fetch(id)
      quote = quote_text(question)
      assert_equal(id == "31-4" ? "第37条第9項・第10項" : "第22条第1項・第2項", quote.lines.first.strip, id)
      assert_equal BLANKS, quote.scan(/\{\{([①②③④])\}\}/).flatten, id
      expected_paragraphs = locations.flat_map { |law, article, numbers| numbers.map { |number| original(law, article, number) } }
      assert_equal 2, expected_paragraphs.size, id
      matching = question.fetch(:choices).select do |choice|
        assert_equal 4, cells(choice).size, "#{id} #{choice[:label]}"
        restored = restore(quote, choice)
        # Remove only the explicit article heading and ParagraphNum display
        # tokens; preserve sentences and their consecutive paragraph order.
        paragraphs = restored.split(/\n{2,}/).drop(1).map { |paragraph| paragraph.sub(/\A[0-9０-９]+[　 \t]+/, "") }
        equal = paragraphs == expected_paragraphs
        assert_equal choice.fetch(:correct), equal, "#{id} #{choice[:label]}"
        equal
      end
      assert_equal [answer(question).fetch(:label)], matching.map { |choice| choice.fetch(:label) }, id
      4.times do |column|
        assert_equal [2, 2], question[:choices].map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{id} 列#{column + 1}"
      end
      # The law title in the prompt necessarily contains 教育公務員. Check
      # disclosure inside the excerpt, not this source-identifying title.
      cells(answer(question)).each { |term| assert_not_includes quote, term, "#{id} 抜粋本文への正答語の再掲" }
    end
  end

  test "正誤肢の義務と努力義務策定主体及び特例法の異なる対象を原典で区別する" do
    assert_includes original("education", "16", "2"), "国は、全国的な教育の機会均等と教育水準の維持向上を図るため"
    assert_includes original("education", "16", "3"), "施策を策定し、実施しなければならない。"
    assert_includes original("education", "17", "2"), "基本的な計画を定めるよう努めなければならない。"
    assert original("education", "17", "1").start_with?("政府は、")
    assert_includes original("education", "16", "4"), "必要な財政上の措置を講じなければならない。"
    third = @questions.fetch("31-3")
    assert_includes third[:content_blocks].first[:text], "正しいものを"
    assert_equal "ア", answer(third)[:label]
    assert_includes third[:choices][1][:content_blocks].first[:text], "ともに義務として定められている"
    assert_includes third[:choices][2][:content_blocks].first[:text], "文部科学大臣が定め"
    assert_includes third[:choices][3][:content_blocks].first[:text], "講ずるよう努めなければならない"
    assert_includes original("school", "37", "7"), "校務を整理し"
    assert_includes original("school", "62", "1"), "第三十七条第四項から第十八項まで及び第二十項"
    assert_includes original("school", "62", "1"), "高等学校に準用する"
    assert_includes original("special", "2", "1"), "校長（園長を含む。以下同じ。）、教員及び部局長並びに教育委員会の専門的教育職員"
    assert original("special", "22", "1").start_with?("教育公務員には、")
    assert original("special", "22", "2").start_with?("教員は、")
    assert_includes original("special", "22", "3"), "任命権者"
    assert_includes @questions.fetch("31-5")[:explanation_blocks].last[:text], "教員も研修機会の対象"
  end

  test "二つの条文穴埋めの必須空欄全消去セル不足条番号欠落を投入前に拒否する" do
    path = Rails.root.join("db/seeds/mock_exam_31.rb")
    source = File.read(path)
    insertion = "questions.each do |question|\n"
    assert_includes source, insertion
    [4, 5].each do |number|
      target = "questions.find { |question| question[:question_number] == #{number} }"
      mutations = [
        "#{target}[:content_blocks].last[:text] = #{target}[:content_blocks].last[:text].gsub(/[{][{][①②③④][}][}]/, \"語句\")\n",
        "#{target}[:choices].first[:content_blocks].first[:cells].pop\n",
        "#{target}[:content_blocks].last[:text] = #{target}[:content_blocks].last[:text].sub(/\\A第[^\\n]+\\n+/, \"\")\n",
      ]
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError) do
            QuestionSeedSync.collect { eval(source.sub(insertion, mutation + insertion), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "三問のみ下書き保存し未ログイン管理者の一般API取得回答にも公開しない" do
    save_entries
    scope = Question.where(exam_number: 31)
    assert_equal NUMBERS, scope.order(:question_number).pluck(:question_number)
    assert_equal 3, scope.where(publication_status: "draft").count
    assert_equal 0, scope.published.count
    assert_equal 12, QuestionChoice.where(question_id: scope.select(:id)).count
    assert_equal 3, QuestionChoice.where(question_id: scope.select(:id), is_correct: true).count
    [nil, admin_headers].each do |headers|
      get "/api/v1/exams", headers: headers
      assert_response :success
      assert_not response.parsed_body.fetch("data").any? { |exam| exam.fetch("exam_number") == 31 }
      scope.each do |record|
        get "/api/v1/questions/#{record.id}", headers: headers
        assert_response :not_found
        assert_not response.parsed_body.key?("data")
        assert_no_difference "AnswerHistory.count" do
          post "/api/v1/questions/#{record.id}/answer", params: { selected_choice_id: record.question_choices.first.id }, headers: headers, as: :json
        end
        assert_response :not_found
        assert_not response.parsed_body.key?("data")
      end
    end
  end

  test "三問の二回再同期でID本文選択肢seed状態履歴お気に入りを保持する" do
    save_entries
    user = User.create!(name: "模試31法令検証", email: "mock31-law-reseed@example.com", password: "password123", password_confirmation: "password123")
    record = Question.find_by!(exam_number: 31, question_number: 3)
    user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
    user.favorites.create!(question: record)
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
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

  def quote_text(question)
    question.fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  end

  def restore(quote, choice)
    quote.gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
  end

  def original(law, article, number)
    ORIGINALS.fetch("laws").fetch(law).fetch("articles").fetch(article).fetch(number)
  end

  def save_entries
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "模試31法令管理検証", email: "mock31-law-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    end
  end

  def snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  end
end

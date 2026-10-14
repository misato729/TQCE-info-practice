require "test_helper"
require "digest"

class MockExams31To35CurriculumTest < ActionDispatch::IntegrationTest
  EXAMS = (31..35).to_a.freeze
  NUMBERS = (6..10).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  ANSWERS = {
    31 => %w[ウ ア エ イ ア], 32 => %w[イ エ ア ウ エ],
    33 => %w[エ ウ イ ア ウ], 34 => %w[ア イ ウ エ イ],
    35 => %w[ウ エ ア イ エ],
  }.freeze
  CATEGORIES = {
    6 => "curriculum_organization", 8 => "integrated_inquiry",
    9 => "moral_education", 10 => "special_activities",
  }.freeze
  Q7_CATEGORIES = {
    31 => "career_education", 32 => "student_guidance_career",
    33 => "special_support_education", 34 => "special_support_education",
    35 => "student_guidance_career",
  }.freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_31_to_35_approved_curriculum_drafts.json"))).freeze
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_31_to_35_curriculum_sources.json"))).freeze

  setup do
    @partial_entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @entries = @partial_entries.select { |entry| NUMBERS.include?(entry.fetch(:attributes).fetch(:question_number)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "承認二十五問の本文補足四択正答全解説出典分類を独立snapshotから比較する" do
    assert_equal 25, @entries.size
    assert_equal APPROVED.fetch("sections").keys.sort, @questions.keys.sort
    assert_equal "document/模試31〜35_問6〜10草案_2026-10-14.md", APPROVED.fetch("source_path")
    assert_equal "f642f9b41ebff2c60fbefc61d196bdc639a789531f16de24339e157caefbabc3", APPROVED.fetch("sha256")
    assert_equal "7ccda139578d4c5f1e80223f08cad097ad5df9bdeceb50579176026d76b104fa",
      Digest::SHA256.file(Rails.root.join("test/fixtures/mock_exams_31_to_35_approved_curriculum_drafts.json")).hexdigest
    @entries.each do |entry|
      id, question = key(entry), entry.fetch(:attributes)
      approved = APPROVED.fetch("sections").fetch(id)
      head, tail = approved.split(/^正答：[アイウエ]$/, 2)
      assert head && tail, id
      assert_equal approved[/^正答：([アイウエ])$/, 1], answer(question).fetch(:label), id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      category = question[:question_number] == 7 ? Q7_CATEGORIES.fetch(entry[:exam_number]) : CATEGORIES.fetch(question[:question_number])
      assert_equal category, question.fetch(:category_code), id
      assert_equal "draft", entry.fetch(:publication_status), id

      prompt = head.lines.find { |line| line.start_with?("次の文章は") }
      assert_equal normalize(prompt), normalize(question[:content_blocks].first.fetch(:text)), id
      assert_equal "fill_in_text", question[:content_blocks].first.fetch(:type), id
      expected_types = id == "34-9" ? %w[fill_in_text text fill_in_quote] : %w[fill_in_text fill_in_quote]
      assert_equal expected_types, question[:content_blocks].map { |block| block.fetch(:type) }, id
      assert_equal 1, quote_blocks(question).size, id
      expected_quote = head.lines.grep(/^>/).map { |line| line.sub(/^> ?/, "") }.join
      assert_equal normalize(expected_quote), normalize(quote(question)), id
      expected_supplements = head.lines.grep(/^参考（/).map { |line| normalize(line) }
      assert_equal expected_supplements, question[:content_blocks].select { |block| block[:type] == "text" }.map { |block| normalize(block[:text]) }, id

      rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
      assert_equal rows, question[:choices].map { |choice| [choice[:label], *cells(choice)] }, id
      explanation, source_tail = tail.split(/^出典：/, 2)
      assert source_tail, id
      expected_explanations = explanation.strip.split(/\n{2,}/).flat_map do |paragraph|
        paragraph.start_with?("- ") ? paragraph.lines.map { |line| line.sub(/\A- /, "").strip } : paragraph
      end
      # Existing explanation blocks use a label followed by ：. The approved
      # Q9 drafts used アは etc., and prefixed the summary with 解説：. Declare
      # these presentation-only conversions without changing their wording.
      expected_explanations.map! { |text| text.sub(/\A解説：/, "").sub(/\A([アイウエ])は/, '\1：') }
      assert_equal expected_explanations.map { |text| normalize(text) }, question[:explanation_blocks].map { |block| normalize(block.fetch(:text)) }, id
      assert question[:explanation_blocks].all? { |block| block[:type] == "text" }, id
      LABELS.each do |label|
        assert expected_explanations.any? { |text| text.match?(/\A#{label}(?:：|は)/) }, "#{id} #{label}の説明"
      end
      # Source links include the separately labelled references for three Q9s.
      # Stop at authoring records, not at the first paragraph after 出典.
      source_part = source_tail.split(/^(?:作問・照合記録：|原典位置・連続性：|近い既存問題：)/, 2).first
      expected_sources = source_part.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/)
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

  test "独立原典の連続する抜粋に正答だけが一致し百行の誤答を全文代入して区別する" do
    assert_equal 25, ORIGINALS.fetch("locations").size
    assert_equal @questions.keys.sort, ORIGINALS.fetch("locations").keys.sort
    ORIGINALS.fetch("documents").each do |name, document|
      assert_match(/\Ahttps:\/\/www\.mext\.go\.jp\/content\//, document.fetch("url"), name)
      assert_match(/\A[0-9a-f]{64}\z/, document.fetch("pdf_sha256"), name)
      assert document.fetch("pages").any?, name
    end
    @questions.each do |id, question|
      location = ORIGINALS.fetch("locations").fetch(id)
      document = ORIGINALS.fetch("documents").fetch(location.fetch("document"))
      location.fetch("pdf_pages").each { |page| assert document.fetch("pages").key?(page.to_s), id }
      assert location.fetch("notes").present?, id
      original = source_normalize(location.fetch("source_fragment"))
      assert_includes source_normalize(original_pages(location)), original, "#{id} 独立RAW頁の連続部分"
      assert_operator original.length, :>=, 100, id
      assert_includes question[:content_blocks].first[:text], "からの抜粋である。", id
      assert_no_match(/中略|示された内容に基づく記述/, quote(question), id)
      matches = question[:choices].select do |choice|
        equal = original == source_normalize(restore(question, choice))
        assert_equal choice.fetch(:correct), equal, "#{id} #{choice[:label]} 原文連続一致"
        equal
      end
      assert_equal [answer(question)[:label]], matches.map { |choice| choice[:label] }, id
      assert_includes question[:source_text], "#page=#{location.fetch("pdf_pages").first}", id
    end
  end

  test "四空欄と四セル正答一件各列二対二及び導入本文補足の正答再掲防止を保つ" do
    @questions.each do |id, question|
      choices = question.fetch(:choices)
      assert_equal LABELS, choices.map { |choice| choice.fetch(:label) }, id
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, id
      assert_equal 4, choices.map { |choice| cells(choice) }.uniq.size, id
      assert_equal BLANKS, quote(question).scan(/\{\{([①②③④])\}\}/).flatten.uniq, id
      assert_equal %w[① ④], question[:content_blocks].first[:text].scan(/\{\{([①②③④])\}\}/).flatten, id
      choices.each do |choice|
        assert_equal [{ type: "fill_in_choice", cells: cells(choice) }], choice.fetch(:content_blocks), id
        assert_equal 4, cells(choice).size, id
        assert cells(choice).all?(&:present?), id
      end
      4.times do |column|
        assert_equal [2, 2], choices.map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{id} 列#{column + 1}"
      end
      visible = question[:content_blocks].map { |block| block.fetch(:text) }.join
      cells(answer(question)).each { |term| assert_not_includes visible, term, "#{id} 正答の再掲" }
      assert_not question[:content_blocks].any? { |block| %w[quote table].include?(block[:type]) }, id
    end
    {
      "31-8" => { "①" => 2, "③" => 2 }, "31-9" => { "①" => 2 },
      "33-10" => { "①" => 2 }, "34-7" => { "③" => 2 }, "34-9" => { "①" => 2 },
    }.each do |id, repeats|
      repeats.each { |label, count| assert_equal count, quote(@questions.fetch(id)).scan("{{#{label}}}").size, "#{id} #{label}" }
    end
  end

  test "範囲導入見出し問七分類と本体解説の配分及び暫定正答を維持する" do
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ANSWERS.fetch(exam), entries.map { |entry| answer(entry[:attributes])[:label] }, exam
      partial = @partial_entries.select { |entry| entry[:exam_number] == exam }
      expected_numbers = exam == 31 ? (1..10).to_a : [1, 2, 6, 7, 8, 9, 10]
      assert_equal expected_numbers, partial.map { |entry| entry[:attributes][:question_number] }, exam
      assert partial.all? { |entry| entry[:publication_status] == "draft" }, exam
      assert partial.map { |entry| answer(entry[:attributes])[:label] }.tally.values.all? { |count| count <= 5 }, exam
    end
    @questions.each do |id, question|
      number = question.fetch(:question_number)
      prompt = question[:content_blocks].first[:text]
      if [6, 7].include?(number)
        scope = number == 6 ? "第3款 教育課程の実施と学習評価" : "第5款 生徒の発達の支援"
        assert_includes prompt, "第1章 総則 #{scope}", id
        assert_includes question[:source_text], number == 6 ? "第3款" : "第5款", id
      end
      if [6, 7, 8].include?(number)
        heading = prompt[/の「(.+)」からの抜粋/, 1]
        assert heading, id
        assert_no_match(/(?:\([0-9]+\)|（[0-9]+）|[アイウエ])\z/, heading, id)
      end
      if number == 9 && prompt.include?("第1款")
        assert_includes prompt, "の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋", id
      end
      assert_no_match(/\A(?:内容の|〔指導項目〕の|その中で|その際|このような|具体的には)/, quote(question), id)
      assert_no_match(/図[0-9０-９]+(?:参照|を参照)|次の図|第[１２３123]の目標/, quote(question), id)
    end
    { 8 => [31, 33, 35], 10 => [32, 34] }.each do |number, body_exams|
      entries = @entries.select { |entry| entry[:attributes][:question_number] == number }
      actual = entries.reject { |entry| entry[:attributes][:content_blocks].first[:text].include?("解説") }.map { |entry| entry[:exam_number] }
      assert_equal body_exams, actual, number
      assert_equal 5 - body_exams.size, entries.count { |entry| entry[:attributes][:content_blocks].first[:text].include?("解説") }, number
    end
  end

  test "補足した参照先は原文抜粋から区別し原文の列挙番号を空欄と混同しない" do
    question = @questions.fetch("34-9")
    supplement = question[:content_blocks].find { |block| block[:type] == "text" }.fetch(:text)
    assert supplement.start_with?("参考（参照先の内容説明。以下の抜粋とは別の補足）：")
    assert_includes supplement, "第１款の２の（2）に示す道徳教育の目標"
    assert_includes supplement, "基盤となる道徳性を養う"
    assert_includes supplement, "各教科に属する科目，総合的な探究の時間及び特別活動"
    assert_not_includes quote(question), "参照先の内容説明"
    assert_equal 2, question[:source_text].lines.size
    references = ORIGINALS.fetch("locations").fetch("34-9").fetch("references")
    assert references.any? { |reference| reference.fetch("pdf_pages").include?(21) }
    references.each do |reference|
      assert_includes source_normalize(original_pages(reference)), source_normalize(reference.fetch("source_fragment"))
    end
    reference_text = references.map { |reference| source_normalize(reference.fetch("source_fragment")) }.join
    assert_includes reference_text, source_normalize("人間としての在り方生き方を考え，主体的な判断の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養う")

    inquiry = quote(@questions.fetch("34-8"))
    assert_includes inquiry, "①探究において{{①}}"
    assert_includes inquiry, "②探究において適切に{{②}}"
    assert_includes inquiry, "④{{③}}を視野に入れながら"
    assert_includes inquiry, "②{{④}}つつ"
    assert_equal 2, inquiry.scan(/(?<!\{)①(?!\})/).size
    assert_equal 2, inquiry.scan(/(?<!\{)②(?!\})/).size
    assert_includes quote(@questions.fetch("31-10")), "③　「自己実現」"
  end

  test "二十五問の必須空欄全消去セル不足ラベル増加未知ラベルを投入前に拒否する" do
    @entries.each do |entry|
      path = Rails.root.join("db/seeds/mock_exam_#{entry[:exam_number]}.rb")
      source = File.read(path)
      target = "questions.find { |question| question[:question_number] == #{entry[:attributes][:question_number]} }"
      insertion = "questions.each do |question|\n"
      assert_includes source, insertion, key(entry)
      mutations = [
        "#{target}[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③④][}][}]/, \"語句\") if block[:type] == \"fill_in_quote\" }\n",
        "#{target}[:choices].first[:content_blocks].first[:cells].pop\n",
        "#{target}[:content_blocks].find { |block| block[:type] == \"fill_in_quote\" }[:text] += \"{{⑤}}\"\n",
        "#{target}[:content_blocks].find { |block| block[:type] == \"fill_in_quote\" }[:text] += \"{{foo}}\"\n",
      ]
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError, ActiveRecord::RecordInvalid) do
            QuestionSeedSync.collect { eval(source.sub(insertion, mutation + insertion), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "三十八問を下書き保存し管理取得できても一般取得一覧next回答に公開しない" do
    save_entries
    scope = Question.where(exam_number: EXAMS)
    assert_equal 38, scope.count
    assert_equal 38, scope.where(publication_status: "draft").count
    assert_equal 0, scope.published.count
    assert_equal 152, QuestionChoice.where(question_id: scope.select(:id)).count
    assert_equal 38, QuestionChoice.where(question_id: scope.select(:id), is_correct: true).count
    [nil, admin_headers].each do |headers|
      get "/api/v1/exams", headers: headers
      assert_response :success
      assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
      EXAMS.each do |exam|
        get "/api/v1/questions/next", params: { exam_number: exam }, headers: headers
        # Exam entitlement runs before lookup for this route. Guests must
        # authenticate; admins pass entitlement but still cannot read drafts.
        assert_response(headers ? :not_found : :unauthorized)
        assert_no_public_answers(response.parsed_body)
      end
      @entries.each do |entry|
        record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
        get "/api/v1/questions/#{record.id}", headers: headers
        assert_response :not_found
        assert_no_public_answers(response.parsed_body)
        assert_no_difference "AnswerHistory.count" do
          post "/api/v1/questions/#{record.id}/answer", params: { selected_choice_id: record.question_choices.first.id }, headers: headers, as: :json
        end
        assert_response :not_found
        assert_no_public_answers(response.parsed_body)
      end
    end
    free_user = User.create!(name: "未購入の下書き確認", email: "mock31-curriculum-free@example.com", password: "password123", password_confirmation: "password123")
    free_headers = { "Authorization" => "Bearer #{AuthToken.issue(free_user)}" }
    EXAMS.each do |exam|
      get "/api/v1/questions/next", params: { exam_number: exam }, headers: free_headers
      assert_response :forbidden
      assert_no_public_answers(response.parsed_body)
    end
    @entries.each do |entry|
      record = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      get "/api/v1/admin/questions/#{record.id}", headers: admin_headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal "draft", data.fetch("publication_status")
      assert_equal record.content_blocks, data.fetch("content_blocks")
      assert_equal record.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal record.source_text, data.fetch("source_text")
      assert_equal LABELS, data.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
    end
  end

  test "二回再同期で既存の履歴お気に入りを含めID本文選択肢公開状態を保持する" do
    save_entries
    user = User.create!(name: "指導要領31再同期確認", email: "mock31-curriculum-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[31, 1], [31, 4], [31, 6], [34, 8], [34, 9]].each do |exam, number|
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
    EXAMS.each do |exam|
      record = Question.find_by!(exam_number: exam, question_number: 6)
      patch "/api/v1/admin/questions/#{record.id}", params: { question: QuestionPayload.from_record(record).merge("publication_status" => "published") }, headers: admin_headers, as: :json
      assert_response :unprocessable_content
      assert_includes response.parsed_body.dig("error", "message"), "問1〜20の登録が必要"
      assert_equal "draft", record.reload.publication_status
      assert_equal before, snapshot
    end
  end

  test "追加二十五問以外の既存六百十三問の承認前payloadを固定hashで保持する" do
    previous = APPROVED.fetch("existing_613_payload_digests")
    assert_equal 613, previous.size
    entries = QuestionSeedSync.collect { (1..35).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") } }
    unchanged = entries.select { |entry| previous.key?(key(entry)) }
    assert_equal previous.keys.sort, unchanged.map { |entry| key(entry) }.sort
    unchanged.each do |entry|
      assert_equal previous.fetch(key(entry)), QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes])), key(entry)
    end
    additions = entries.reject { |entry| previous.key?(key(entry)) }
    assert_equal @questions.keys.sort, additions.map { |entry| key(entry) }.sort
    assert_equal 638, entries.size
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
    # Preserve source words, punctuation and references; ignore only extraction
    # spacing and full/half-width display variation, including paragraph nums.
    text.unicode_normalize(:nfkc).gsub(/[[:space:]\u0000-\u001f\u007f]+/, "")
  end

  def original_pages(location)
    document = ORIGINALS.fetch("documents").fetch(location.fetch("document"))
    location.fetch("pdf_pages").map do |page|
      text = document.fetch("pages").fetch(page.to_s).dup
      if location.fetch("document") == "curriculum"
        # Fixed page furniture is explicitly recorded in the independent
        # fixture notes. Never remove body words or clause references here.
        text = text.sub(/\n29\s*\z/, "") if page == 31
        text = text.sub(/\A総 則\n２\n30\n/, "") if page == 32
        text = text.sub(/\A総 則\n/, "") if page == 33
        text = text.gsub(/^ひら\n/, "") if page == 21
      end
      text
    end.join
  end

  def restore(question, choice)
    quote(question).gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def save_entries
    QuestionWriter.transaction { @partial_entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "指導要領31管理確認", email: "mock31-curriculum-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
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

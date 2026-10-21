require "test_helper"
require_relative "../support/improvement_revision_20261017"
require "digest"

class MockExams36To40CompletionTest < ActionDispatch::IntegrationTest
  EXAMS = (36..40).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  APPROVED = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_36_to_40_approved_completion.json"))).freeze
  CATEGORIES = {
    11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology",
    15 => "education_system", 19 => "information_specialized", 20 => "information_specialized",
  }.freeze
  INFORMATION_CATEGORIES = {
    36 => %w[information_specialized information_education information_specialized],
    37 => %w[information_specialized information_education information_specialized],
    38 => %w[information_specialized information_education information_specialized],
    39 => %w[information_education information_specialized information_education],
    40 => %w[information_specialized information_education information_specialized],
  }.freeze
  INFORMATION_RANGES = {
    36 => [1, 2, 3], 37 => [1, 2, 4], 38 => [1, 3, 4],
    39 => [2, 3, 4], 40 => [1, 2, 3],
  }.freeze

  setup do
    # Collect only these five sets. Saving is limited to the database/API tests.
    @entries = QuestionSeedSync.collect { EXAMS.each { |exam| load Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{exam}.rb") } }
    @new_entries = @entries.select { |entry| (11..20).cover?(entry[:attributes][:question_number]) }
    @questions = @new_entries.to_h { |entry| [key(entry), entry[:attributes]] }
  end

  test "百問完成と公開状態四択正答分類出典及び各肢五件を検査する" do
    assert_equal 100, @entries.size
    assert_equal 50, @new_entries.size
    assert_equal 100, @entries.map { |entry| key(entry) }.uniq.size
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal (1..20).to_a, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal ["published"], entries.map { |entry| entry[:publication_status] }.uniq, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| correct(entry[:attributes])[:label] }.tally, exam
    end
    @entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id
      assert_equal 4, question[:choices].map { |choice| choice[:content_blocks] }.uniq.size, id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      payload = QuestionPayload.from_seed(entry[:exam_number], question)
      preview = QuestionSeedSync.preview(entry)
      choices = payload.fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices)
    end
    @new_entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      number = question[:question_number]
      assert_equal number <= 15 ? "teacher_education" : "information", question[:major_category_code], id
      category = (16..18).cover?(number) ? INFORMATION_CATEGORIES.fetch(entry[:exam_number])[number - 16] : CATEGORIES.fetch(number)
      assert_equal category, question[:category_code], id
      LABELS.each { |label| assert question[:explanation_blocks].any? { |block| block[:text]&.start_with?("#{label}：") }, "#{id} 全肢解説#{label}" }
    end
  end

  test "承認統合Markdownの独立raw五十問と全可視本文四択正答解説出典を照合する" do
    assert_equal "document/模試36〜40_問11〜20草案_2026-10-17.md", APPROVED.fetch("source_path")
    assert_equal "0b2305b999c05808333269861ce7dd2eaa607cb10890cb47bc3538f349b26b1b", APPROVED.fetch("sha256")
    assert_equal @questions.keys.sort, APPROVED.fetch("sections").keys.sort
    APPROVED.fetch("sections").each do |id, raw|
      question = ImprovementRevision20261017.historical_attributes(id, @questions.fetch(id))
      head, tail = raw.split(/^正答：[アイウエ]\s*$/, 2)
      assert head && tail, id
      assert_equal raw[/^正答：([アイウエ])$/, 1], correct(question)[:label], id
      head = head.sub(/\A## 模試\d+・問\d+\n+/, "")
      choice_at = head.index(/^\| 選択肢 \|/) || head.index(/^[アイウエ]　/)
      assert choice_at, id
      body, choice_area = head[0...choice_at], head[choice_at..]
      assert_equal normalized_markdown(body), normalized_markdown(block_text(question[:content_blocks])), "#{id} 全本文"
      assert_equal markdown_codes(body), question[:content_blocks].select { |block| block[:type] == "code" }.map { |block| block[:code] }, "#{id} コード字下げ"
      assert_equal markdown_tables(body), actual_tables(question[:content_blocks]), "#{id} 本文表"

      rows = choice_area.lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
      expected_choices = if rows.any?
        rows.map do |label, *cells|
          blocks = id == "39-17" ? [{ type: "text", text: cells.fetch(0) }] : [{ type: "fill_in_choice", cells: cells }]
          [label, blocks]
        end
      else
        choice_area.scan(/^([アイウエ])　(.+)$/).map { |label, text| [label, [{ type: "text", text: text.delete("`") }]] }
      end
      assert_equal expected_choices, question[:choices].map { |choice| [choice[:label], choice[:content_blocks]] }, "#{id} 四択全文"

      source_at = tail.index(/^出典：/)
      assert source_at, id
      explanation = tail[0...source_at].sub(/\A\s*(?:### 解説|解説：)\s*\n/, "")
      source_area = tail[source_at..].sub(/\n---\s*\z/, "").strip
      sources = source_area.scan(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/)
      assert sources.any?, id
      assert_equal sources.map { |title, url| "#{title} | #{url}" }.join("\n"), question[:source_text], "#{id} 全出典"

      # Attribution/editing notes following source links move into the final
      # explanation block, rather than being lost or made part of a source URL.
      note = source_note(source_area)
      actual_explanation = question[:explanation_blocks].dup
      if note.present?
        assert_equal normalized_markdown(note), normalized_markdown(actual_explanation.pop.fetch(:text)), "#{id} 出典後の加工注記"
      end
      assert_equal normalized_markdown(explanation), normalized_markdown(block_text(actual_explanation)), "#{id} 全解説"
      assert_equal markdown_codes(explanation), actual_explanation.select { |block| block[:type] == "code" }.map { |block| block[:code] }, "#{id} 解説コード字下げ"
      assert_equal markdown_tables(explanation), actual_tables(actual_explanation), "#{id} 途中経過表"
    end
  end

  test "問十一四穴一表と問十五四正誤一穴及び本文表コードの空欄表記を区別する" do
    guidance = @new_entries.select { |entry| entry[:attributes][:question_number] == 11 }
    assert_equal 4, guidance.count { |entry| quote(entry[:attributes]).match?(/\{\{/) }
    assert_equal [40], guidance.select { |entry| entry[:attributes][:content_blocks].any? { |block| block[:type] == "table" } }.map { |entry| entry[:exam_number] }
    reports = @new_entries.select { |entry| entry[:attributes][:question_number] == 15 }
    assert_equal [38], reports.select { |entry| fill_choice?(entry[:attributes]) }.map { |entry| entry[:exam_number] }
    @new_entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      if fill_choice?(question)
        count = cells(question[:choices].first).size
        assert_equal "fill_in_text", question[:content_blocks].first[:type], id
        assert_equal 1, question[:content_blocks].count { |block| block[:type] == "fill_in_quote" }, id
        labels = if id == "40-11"
          assert_no_match(/\{\{/, quote(question), id)
          question[:content_blocks].select { |block| block[:type] == "table" }.flat_map { |block| (block[:headers] + block[:rows].flatten).join.scan(/【([^】]+)】/).flatten }.uniq
        else
          quote(question).scan(/\{\{([^{}]+)\}\}/).flatten.uniq
        end
        assert_equal BLANKS.first(count), labels, id
        assert (2..3).cover?(count), id if question[:question_number] == 11
        question[:choices].each { |choice| assert_equal count, cells(choice).size, id }
        question[:choices].map { |choice| cells(choice) }.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, id }
        actual_tables(question[:content_blocks]).each { |table| assert_no_match(/\{\{/, table.values.flatten.join, id) }
      elsif question[:question_number] == 19
        assert question[:choices].all? { |choice| choice[:content_blocks].first[:type] == "text" }, id
        question[:content_blocks].select { |block| block[:type] == "code" }.each { |block| assert_no_match(/\{\{/, block[:code], id) }
      end
    end
    count_question = @questions.fetch("39-17")
    assert count_question[:choices].all? { |choice| choice[:content_blocks].first[:type] == "text" }
    assert_equal ["0個", "1個", "2個", "3個"], count_question[:choices].map { |choice| choice[:content_blocks].first[:text] }
    assert_no_match(/\{\{/, block_text(count_question[:content_blocks]))
  end

  test "情報三問は四範囲から互いに異なる三範囲を本文と出典の資料順に置く" do
    EXAMS.each do |exam|
      ranges = (16..18).map do |number|
        question = @questions.fetch("#{exam}-#{number}")
        intro = question[:content_blocks].first[:text]
        range = information_range(intro)
        source = question[:source_text]
        if range <= 2
          assert_includes source, "20230120-mxt_kyoiku02-100002604_03.pdf"
          assert_match(range == 1 ? /第2章第10節/ : /第3章第7節/, source)
        else
          assert_includes source, "1407073_11_1_2.pdf"
          assert_includes source, range == 3 ? "第1部" : "第2部"
        end
        range
      end
      assert_equal INFORMATION_RANGES.fetch(exam), ranges, exam
      assert_equal ranges.sort.uniq, ranges, exam
    end
  end

  test "必須空欄全消去セル不足及び未知第五ラベルをseed収集時に拒否する" do
    @new_entries.select { |entry| fill_choice?(entry[:attributes]) }.each do |entry|
      id = key(entry)
      path = Rails.root.join("test/fixtures/approved_question_catalog/mock_exam_#{entry[:exam_number]}.rb")
      source = File.read(path)
      insertion = "questions.each do |question|\n"
      assert_includes source, insertion, id
      target = "questions.find { |question| question[:question_number] == #{entry[:attributes][:question_number]} }"
      empty = if id == "40-11"
        "#{target}[:content_blocks].select { |block| block[:type] == 'table' }.each { |block| block[:rows].each { |row| row.map! { |cell| cell.gsub(/【[^】]+】/, '語句') } } }"
      else
        "#{target}[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][^{}]+[}][}]/, '語句') if block[:type] == 'fill_in_quote' }"
      end
      mutations = [empty, "#{target}[:choices].first[:content_blocks].first[:cells].pop",
        *%w[⑤ foo].map { |label| "#{target}[:content_blocks].find { |block| block[:type] == 'fill_in_quote' }[:text] += '{{#{label}}}'" }]
      mutations.each do |mutation|
        assert_raises(RuntimeError, ActiveRecord::RecordInvalid, id) do
          QuestionSeedSync.collect { eval(source.sub(insertion, mutation + "\n" + insertion), binding, path.to_s) }
        end
      end
    end
  end

  test "プレミアム会員と管理者は百問を取得回答でき回答前秘匿を保ち無料利用者を拒否する" do
    save_entries(@entries)
    assert_equal 100, Question.where(exam_number: EXAMS, publication_status: "published").count
    paid, admin, free = user_headers("paid", paid: true), user_headers("admin", admin: true), user_headers("free")
    [paid, admin].each do |headers|
      get api_v1_exams_path, headers: headers
      assert_response :success
      assert_no_public_answers(response.parsed_body)
      visible = response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam["exam_number"]) }
      assert_equal EXAMS, visible.map { |exam| exam["exam_number"] }
      visible.each { |exam| assert_equal (1..20).to_a, exam.fetch("question_numbers"); assert_equal 20, exam.fetch("published_question_count") }
      Question.where(exam_number: EXAMS).order(:exam_number, :question_number).each do |question|
        # Content/authorization coverage is not a load test. Limits themselves
        # are covered separately; keep counters local to each question here.
        ApiRateLimitBucket.delete_all
        get api_v1_question_path(question), headers: headers
        assert_response :success
        assert_equal question.content_blocks, response.parsed_body.dig("data", "content_blocks")
        assert_no_public_answers(response.parsed_body)
        assert_difference "AnswerHistory.count", 1 do
          post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
        end
        assert_response :success
        assert_equal true, response.parsed_body.dig("data", "is_correct")
        assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
        assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
      end
    end
    EXAMS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 18 }, headers: paid
      assert_response :success
      assert_equal [exam, 19], response.parsed_body.fetch("data").values_at("exam_number", "question_number")
      assert_no_public_answers(response.parsed_body)
    end
    [nil, free].each do |headers|
      get api_v1_exams_path, headers: headers
      assert_response :success
      locked = response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam.fetch("exam_number")) }
      assert_equal EXAMS, locked.map { |exam| exam.fetch("exam_number") }
      locked.each { |exam| assert_equal "paid_membership_required", exam.fetch("access") }
      assert_no_public_answers(response.parsed_body)
      EXAMS.each do |exam|
        question = Question.find_by!(exam_number: exam, question_number: 11)
        [api_v1_question_path(question), next_api_v1_questions_path(exam_number: exam)].each do |path|
          get path, headers: headers
          assert_response headers ? :forbidden : :unauthorized
          assert_no_public_answers(response.parsed_body)
        end
        assert_no_difference "AnswerHistory.count" do
          post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, headers: headers, as: :json
        end
        assert_response headers ? :forbidden : :unauthorized
        assert_no_public_answers(response.parsed_body)
      end
    end
  end

  test "既存五十問の公開切替と新規五十問追加及び再seedは百問のID履歴お気に入りを保つ" do
    old = @entries.select { |entry| entry[:attributes][:question_number] <= 10 }.map { |entry| entry.merge(publication_status: "draft") }
    save_entries(old)
    user = User.create!(name: "完成同期保持", email: "mock36-completion-preserve@example.com", password: "password123", password_confirmation: "password123")
    Question.order(:id).each { |record| add_history_and_favorite(user, record) }
    previous = Question.order(:id).map { |record| [record.id, QuestionPayload.from_record(record), record.question_choices.order(:display_order).pluck(:id), record.created_at] }
    histories, favorites = AnswerHistory.order(:id).map(&:attributes), Favorite.order(:id).map(&:attributes)
    assert_difference ["Question.count", "QuestionSeedState.count"], 50 do
      assert_difference "QuestionChoice.count", 200 do
        assert_no_difference ["AnswerHistory.count", "Favorite.count"] do
          save_entries(@entries)
        end
      end
    end
    previous.each do |id, payload, choice_ids, created_at|
      record = Question.find(id)
      assert_equal payload, QuestionPayload.from_record(record), id
      assert_equal choice_ids, record.question_choices.order(:display_order).pluck(:id), id
      assert_equal created_at, record.created_at, id
      assert_equal "published", record.publication_status, id
    end
    assert_equal histories, AnswerHistory.order(:id).map(&:attributes)
    assert_equal favorites, Favorite.order(:id).map(&:attributes)
    Question.where(question_number: (11..20)).order(:id).each { |record| add_history_and_favorite(user, record) }
    assert_equal 100, AnswerHistory.count
    assert_equal 100, Favorite.count
    unchanged = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries(@entries)
      end
      assert_equal unchanged, snapshot
    end
  end

  private

  def key(entry) = "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  def correct(question) = question.fetch(:choices).find { |choice| choice[:correct] }
  def cells(choice) = choice.fetch(:content_blocks).first.fetch(:cells)
  def quote(question) = question.fetch(:content_blocks).find { |block| block[:type] == "fill_in_quote" }.fetch(:text)
  def fill_choice?(question) = question[:choices].all? { |choice| choice[:content_blocks].first[:type] == "fill_in_choice" }
  def markdown_row(line) = line.strip.split("|", -1)[1...-1].map { |cell| cell.strip.delete("`") }
  def markdown_codes(text) = text.scan(/```[^\n]*\n(.*?)\n```/m).flatten

  def markdown_tables(text)
    text.scan(/(?:^\|[^\n]*\|\s*\n){2,}/).map do |table|
      rows = table.lines.select { |line| line.start_with?("|") }
        .reject { |line| line.match?(/\A\|[\s:|\-]+\|\s*\z/) }.map { |line| markdown_row(line) }
      { headers: rows.shift, rows: rows }
    end
  end

  def actual_tables(blocks) = blocks.select { |block| block[:type] == "table" }.map { |block| block.slice(:headers, :rows) }

  def block_text(blocks)
    blocks.map { |block| block[:type] == "table" ? (block[:headers] + block[:rows].flatten).join("\n") : block[:text] || block[:code] }.join("\n")
  end

  def normalized_markdown(text)
    text.lines.reject { |line| line.match?(/\A\s*```/) || line.match?(/\A\|[\s:|\-]+\|\s*\z/) }
      .map { |line| line.sub(/\A> ?/, "").sub(/\A- /, "").delete("|`") }.join
      .gsub(/\{\{([^{}]+)\}\}|【([^】]+)】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]　]/, "")
  end

  def source_note(text)
    text.sub(/\A出典：/, "").gsub(/\[([^\]\n]+)\]\((https:\/\/[^)\n]+)\)/, "")
      .lines.reject { |line| line.strip == "-" }.join.strip.sub(/\A[，、。\s]+/, "").strip
  end

  def information_range(intro)
    return 3 if intro.include?("解説 情報編") && intro.include?("第1部")
    return 4 if intro.include?("解説 情報編") && intro.include?("第2部")
    return 1 if intro.match?(/第2章.*第10節/)
    return 2 if intro.match?(/第3章.*第7節/)
    flunk "未分類の情報範囲：#{intro}"
  end

  def save_entries(entries) = QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  def snapshot = [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  def add_history_and_favorite(user, record)
    user.answer_histories.create!(question: record, selected_choice: record.question_choices.find_by!(is_correct: true), is_correct: true)
    user.favorites.create!(question: record)
  end

  def user_headers(label, paid: false, admin: false)
    user = User.create!(name: "完成確認#{label}", email: "mock36-completion-#{label}@example.com", role: admin ? "admin" : "user", password: "password123", password_confirmation: "password123")
    if paid
      payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_mock36_completion_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
      user.create_membership!(source_payment: payment, status: "active", activated_at: Time.current)
    end
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
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

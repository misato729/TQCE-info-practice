require "test_helper"
require "digest"

class MockExams31To35CompletionTest < ActionDispatch::IntegrationTest
  EXAMS = (31..35).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  PARTIAL_NUMBERS = ([1, 2] + (6..20).to_a).freeze
  CATEGORIES = {
    11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology",
    15 => "education_system", 19 => "information_specialized", 20 => "information_specialized",
  }.freeze
  INFORMATION_CATEGORIES = {
    31 => %w[information_specialized information_education information_specialized],
    32 => %w[information_specialized information_education information_specialized],
    33 => %w[information_specialized information_specialized information_specialized],
    34 => %w[information_education information_education information_specialized],
    35 => %w[information_specialized information_education information_specialized],
  }.freeze
  SNAPSHOT_HASHES = {
    "guidance" => "1d91b649b73fea27aeaf1ed174376f39f906b6ce2c759fc495d626d8246537e9",
    "psychology" => "bfe4b9a72abc6cfc231f6558fbfed4d48d2e1572abde124aff1b1dbb24a74cb5",
    "report" => "51310f670206928d14f6dd71e430599fe863fdaa4edb510fc95cec27a0138aa0",
    "information" => "c16abc3d87715a5039da0f0600995e5e206cddb5c800333b6aa496b2f5377ca4",
    "algorithm" => "54151cc102fdd876d7400a4d6bb80e0ae552e7dbf0b0358cdba4c9f6e72d7f27",
    "statistics" => "36559ff6f9c1891ba60421b140371b9b38e1efce918c04e74c48ca4284261a6b",
  }.freeze

  setup do
    @all_entries = QuestionSeedSync.collect do
      (1..35).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    # This file retains the earlier 688-question/88-target approval scenario.
    # Newly approved legal questions and current complete publication are
    # covered by MockExams32To35LawTest without rebasing these snapshots.
    @all_entries = @all_entries.reject { |entry| (32..35).cover?(entry[:exam_number]) && (3..5).cover?(entry[:attributes][:question_number]) }
      .map { |entry| (32..35).cover?(entry[:exam_number]) ? entry.merge(publication_status: "draft") : entry }
    @entries = @all_entries.select { |entry| EXAMS.include?(entry[:exam_number]) }
    @new_entries = @entries.select { |entry| entry[:attributes][:question_number] >= 11 }
    @questions = @new_entries.to_h { |entry| [key(entry), entry[:attributes]] }
  end

  test "承認五十問と完成未完成セットの四択分類公開状態を維持する" do
    assert_equal 688, @all_entries.size
    assert_equal 88, @entries.size
    assert_equal 50, @new_entries.size
    assert_equal 88, @entries.map { |entry| key(entry) }.uniq.size
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal exam == 31 ? (1..20).to_a : PARTIAL_NUMBERS, entries.map { |entry| entry[:attributes][:question_number] }, exam
      assert_equal [exam == 31 ? "published" : "draft"], entries.map { |entry| entry[:publication_status] }.uniq, exam
      counts = entries.map { |entry| correct_choice(entry[:attributes])[:label] }.tally
      exam == 31 ? assert_equal(LABELS.to_h { |label| [label, 5] }, counts) : assert(counts.values.all? { |count| count <= 5 }, exam)
    end
    @new_entries.each do |entry|
      id, question = key(entry), entry[:attributes]
      number = question[:question_number]
      assert_equal LABELS, question[:choices].map { |choice| choice[:label] }, id
      assert_equal 1, question[:choices].count { |choice| choice[:correct] }, id
      assert_equal 4, question[:choices].map { |choice| choice[:content_blocks] }.uniq.size, id
      assert_equal number <= 15 ? "teacher_education" : "information", question[:major_category_code], id
      category = (16..18).cover?(number) ? INFORMATION_CATEGORIES.fetch(entry[:exam_number])[number - 16] : CATEGORIES.fetch(number)
      assert_equal category, question[:category_code], id
      assert question[:content_blocks].present?, id
      assert question[:explanation_blocks].present?, id
      assert question[:source_text].present?, id
      assert question[:source_text].lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      explanation = block_text(question[:explanation_blocks])
      LABELS.each { |label| assert_match(/#{label}(?:：|は|を選ぶ)/, explanation, "#{id} #{label}の説明") }
      preview = QuestionSeedSync.preview(entry)
      choices = QuestionPayload.from_seed(entry[:exam_number], question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_choices!(preview, choices)
      QuestionWriter.validate_publication!(preview, choices) if entry[:publication_status] == "published"
    end
  end

  test "独立承認snapshotの本文四肢正答全解説出典を表示変換とラベル移動を明示して比較する" do
    approved_keys = []
    SNAPSHOT_HASHES.each do |name, expected_hash|
      path = Rails.root.join("test/fixtures/mock_exams_31_to_35_approved_#{name}_drafts.json")
      assert_equal expected_hash, Digest::SHA256.file(path).hexdigest, name
      snapshot = JSON.parse(File.read(path))
      assert_match(/\A[0-9a-f]{64}\z/, snapshot.fetch("sha256"), name)
      snapshot.fetch("sections").each do |id, section|
        approved_keys << id
        question = @questions.fetch(id)
        remaps = snapshot.fetch("label_remaps").fetch(id, {})
        head, tail = section.split(/^正答：[アイウエ]\s*$/, 2)
        assert head && tail, id
        expected_answer = section[/^正答：([アイウエ])/, 1]
        assert_equal remaps.fetch(expected_answer, expected_answer), correct_choice(question)[:label], id

        # Compare the complete visible body, preserving its word order. Only
        # Markdown wrappers, whitespace and the blank-display wrappers differ.
        head = head.sub(/\A分類：[^\n]*\n+/, "").sub(/\A### 問題\s*/, "")
        choice_start = head.index(/^\| 選択肢 \|/) || head.index(/^(?:- )?ア[　 ]/)
        assert choice_start, id
        expected_body = head[0...choice_start]
        actual_body = block_text(question[:content_blocks])
        if snapshot["common_notation"]
          assert_equal 1, question[:content_blocks].count { |block| block[:text] == snapshot["common_notation"] }, id
          actual_body = block_text(question[:content_blocks].reject { |block| block[:text] == snapshot["common_notation"] })
        end
        assert_equal normalized_markdown(expected_body), normalized_markdown(actual_body), "#{id} 全本文"
        code = head.scan(/```[^\n]*\n(.*?)\n```/m).flatten
        assert_equal code, question[:content_blocks].select { |block| block[:type] == "code" }.map { |block| block[:code] }, "#{id} コードと字下げ"

        rows = head[choice_start..].lines.grep(/^\| [アイウエ] \|/).map { |line| markdown_row(line) }
        expected_choices = if rows.any?
          rows.to_h do |row|
            label, *cells = row
            blocks = id == "35-20" ? [{ type: "text", text: "① #{cells[0]}，② #{cells[1]}" }] : [{ type: "fill_in_choice", cells: cells }]
            [remaps.fetch(label, label), blocks]
          end
        else
          head[choice_start..].scan(/^(?:- )?([アイウエ])[　 ](.+)$/).to_h do |label, text|
            [remaps.fetch(label, label), [{ type: "text", text: text.delete("`") }]]
          end
        end
        assert_equal LABELS.sort, expected_choices.keys.sort, id
        question[:choices].each { |choice| assert_equal expected_choices.fetch(choice[:label]), choice[:content_blocks], "#{id} #{choice[:label]}" }

        source_at = tail.index(/^(?:### )?出典/)
        assert source_at, id
        explanation = tail[0...source_at]
        expected_lines = explanation.lines.reject { |line| line.match?(/\A\s*(?:### 解説|解説：)\s*\z/) }
        expected_explanations = expected_lines.grep(/^- [アイウエ]：/).map { |line| line.sub(/\A- /, "").strip }
        if remaps.any?
          assert_equal 4, expected_explanations.size, id
          expected_explanations.each do |text|
            old_label = text[0]
            new_label = remaps.fetch(old_label, old_label)
            actual = question[:explanation_blocks].find { |block| block[:text]&.start_with?("#{new_label}：") }
            assert actual, id
            assert_equal normalized_markdown(text.sub(/\A[アイウエ]/, new_label)), normalized_markdown(actual[:text]), "#{id} 解説#{new_label}"
          end
          # Any table or supplementary explanation remains independent of labels.
          extra = expected_lines.reject { |line| line.start_with?("- ") }.join
          actual_extra = question[:explanation_blocks].reject { |block| block[:text]&.match?(/\A[アイウエ]：/) }
          assert_equal normalized_markdown(extra), normalized_markdown(block_text(actual_extra)), "#{id} 解説補足"
        else
          assert_equal normalized_markdown(expected_lines.join), normalized_markdown(block_text(question[:explanation_blocks])), "#{id} 全解説"
        end
        source_tail = tail[source_at..]
        urls = source_tail.scan(%r{https://[^\s)]+}).map { |url| url.delete_suffix("`") }.uniq
        assert urls.any?, id
        urls.each { |url| assert_includes question[:source_text], url, "#{id} 出典" }
        source_tail.lines.grep(/ \| https:\/\//).each do |line|
          explicit = line.strip.sub(/\Asource_text：\s*/, "")
          assert_includes question[:source_text].lines.map(&:strip), explicit, "#{id} 明示出典"
        end
      end
    end
    assert_equal @questions.keys.sort, approved_keys.sort
  end

  test "穴埋めと表の空欄及び非穴埋め二問の表示形式を区別する" do
    @questions.each do |id, question|
      next unless question[:choices].first[:content_blocks].first[:type] == "fill_in_choice"
      labels = question[:content_blocks].select { |block| block[:type] == "fill_in_quote" }.flat_map { |block| block[:text].scan(/\{\{([^{}]+)\}\}/).flatten }.uniq
      if id == "35-11"
        assert_empty labels
        labels = question[:content_blocks].find { |block| block[:type] == "table" }[:rows].flatten.join.scan(/【([^】]+)】/).flatten
      end
      cells = question[:choices].map { |choice| choice[:content_blocks].first[:cells] }
      assert_equal %w[① ② ③ ④].first(cells.first.size), labels, id
      assert cells.all? { |row| row.size == labels.size }, id
      assert_equal "fill_in_text", question[:content_blocks].first[:type], id
      assert_equal 1, question[:content_blocks].count { |block| block[:type] == "fill_in_quote" }, id
      cells.transpose.each { |column| assert_equal [2, 2], column.tally.values.sort, id }
    end
    assert_equal %w[text fill_in_quote], @questions.fetch("34-17")[:content_blocks].map { |block| block[:type] }
    assert_equal %w[A B C], @questions.fetch("34-17")[:content_blocks].last[:text].scan(/^([ABC])　/).flatten
    assert @questions.fetch("35-20")[:choices].all? { |choice| choice[:content_blocks].first[:type] == "text" }
    assert_no_match(/\{\{/, block_text(@questions.fetch("35-20")[:content_blocks]))
    assert_includes @questions.fetch("34-11")[:content_blocks].find { |block| block[:type] == "fill_in_quote" }[:text], "① 合意形成と目標の共通理解"
    assert_includes @questions.fetch("34-11")[:explanation_blocks].last[:text], "なお、誤答の相手と協議・連絡"
  end

  test "既存六百三十八問の内容payloadを承認baselineから変更しない" do
    baseline = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_31_to_35_existing_638_digests.json")))
    assert_equal 638, baseline.size
    entries = @all_entries.index_by { |entry| key(entry) }
    baseline.each do |id, digest|
      entry = entries.fetch(id)
      assert_equal digest, QuestionPayload.digest(QuestionPayload.from_seed(entry[:exam_number], entry[:attributes])), id
    end
    assert_equal @questions.keys.sort, (entries.keys - baseline.keys).sort
  end

  test "完成三十一の公開APIは回答前秘匿を保ち全六十八下書きを返さない" do
    save_entries(@entries)
    assert_equal 20, Question.where(exam_number: 31, publication_status: "published").count
    assert_equal 68, Question.where(exam_number: (32..35), publication_status: "draft").count
    paid = user_headers("paid", paid: true)
    get api_v1_exams_path, headers: paid
    assert_response :success
    assert_no_public_answers(response.parsed_body)
    visible = response.parsed_body.fetch("data").select { |exam| EXAMS.include?(exam["exam_number"]) }
    assert_equal [31], visible.map { |exam| exam["exam_number"] }
    assert_equal (1..20).to_a, visible.first.fetch("question_numbers")
    Question.where(exam_number: 31).order(:question_number).each do |question|
      get api_v1_question_path(question), headers: paid
      assert_response :success
      assert_equal question.content_blocks, response.parsed_body.dig("data", "content_blocks")
      assert_no_public_answers(response.parsed_body)
      get next_api_v1_questions_path, params: { exam_number: 31, after_question_number: question.question_number - 1 }, headers: paid
      assert_response :success
      assert_equal question.id, response.parsed_body.dig("data", "id")
      assert_no_public_answers(response.parsed_body)
    end
    Question.where(exam_number: (32..35)).each do |question|
      get api_v1_question_path(question), headers: paid
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, headers: paid, as: :json
      end
      assert_response :not_found
    end
    (32..35).each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }, headers: paid
      assert_response :not_found
      assert_no_public_answers(response.parsed_body)
    end
    [nil, user_headers("free")].each do |headers|
      get next_api_v1_questions_path, params: { exam_number: 31 }, headers: headers
      assert_response headers ? :forbidden : :unauthorized
      assert_no_public_answers(response.parsed_body)
    end
    Question.where(exam_number: 31, question_number: (11..20)).each do |question|
      choice = question.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: choice.id }, headers: paid, as: :json
      end
      assert_response :success
      assert_equal true, response.parsed_body.dig("data", "is_correct")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  test "追加五十問と公開切替後の再同期は既存ID選択肢履歴お気に入りを保つ" do
    previous = @entries.select { |entry| entry[:attributes][:question_number] <= 10 }.map { |entry| entry.merge(publication_status: "draft") }
    save_entries(previous)
    assert_equal 38, Question.count
    user = User.create!(name: "同期保持", email: "mock31-completion-preserve@example.com", password: "password123", password_confirmation: "password123")
    question = Question.find_by!(exam_number: 31, question_number: 1)
    user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    user.favorites.create!(question: question)
    old_questions = Question.order(:id).map { |record| [record.id, QuestionPayload.from_record(record), record.question_choices.pluck(:id), record.created_at] }
    histories = AnswerHistory.order(:id).map(&:attributes)
    favorites = Favorite.order(:id).map(&:attributes)
    assert_difference ["Question.count", "QuestionSeedState.count"], 50 do
      assert_difference "QuestionChoice.count", 200 do
        assert_no_difference ["AnswerHistory.count", "Favorite.count"] do
          save_entries(@entries)
        end
      end
    end
    old_questions.each do |id, payload, choice_ids, created_at|
      record = Question.find(id)
      assert_equal payload, QuestionPayload.from_record(record)
      assert_equal choice_ids, record.question_choices.pluck(:id)
      assert_equal created_at, record.created_at
    end
    assert_equal histories, AnswerHistory.order(:id).map(&:attributes)
    assert_equal favorites, Favorite.order(:id).map(&:attributes)
    unchanged = record_snapshot
    2.times { save_entries(@entries); assert_equal unchanged, record_snapshot }
  end

  private

  def key(entry)
    "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  end

  def correct_choice(question)
    question.fetch(:choices).find { |choice| choice[:correct] }
  end

  def markdown_row(line)
    line.strip.split("|", -1)[1...-1].map(&:strip)
  end

  def block_text(blocks)
    blocks.map do |block|
      block[:type] == "table" ? (block[:headers] + block[:rows].flatten).join("\n") : block[:text] || block[:code]
    end.join("\n")
  end

  def normalized_markdown(text)
    text.lines.reject { |line| line.match?(/\A\s*```/) || line.match?(/\A\|[\s:|\-]+\|\s*\z/) }
      .map { |line| line.sub(/\A> ?/, "").sub(/\A- /, "").delete("|`") }.join
      .gsub(/\{\{([^{}]+)\}\}|【([^】]+)】/) { Regexp.last_match(1) || Regexp.last_match(2) }.gsub(/[[:space:]]/, "")
  end

  def save_entries(entries)
    QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def user_headers(label, paid: false)
    user = User.create!(name: "完成確認#{label}", email: "mock31-completion-#{label}@example.com", password: "password123", password_confirmation: "password123")
    if paid
      payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_mock31_completion_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
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

  def record_snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h { |model| [model.name, model.order(:id).map(&:attributes)] }
  end
end

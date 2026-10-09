require "test_helper"

class MockExams21To25FoundationsAndLawTest < ActionDispatch::IntegrationTest
  EXAMS = (21..25).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  BLANKS = %w[① ② ③ ④].freeze
  ANSWERS = {
    21 => %w[エ イ エ ア ウ], 22 => %w[イ ア ウ エ イ],
    23 => %w[ア ウ ア イ エ], 24 => %w[ウ エ エ ア イ],
    25 => %w[エ ア イ ウ ア],
  }.freeze
  LAW_DATA = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_law_data.json", __dir__))).freeze
  DRAFT_FILES = %w[模試21〜25_問1〜2草案_2026-10-07.md 模試21〜25_問3〜5草案_2026-10-08.md].freeze
  APPROVED_DRAFTS = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_21_to_25_approved_drafts.json", __dir__))).fetch("files").freeze

  setup do
    @entries = QuestionSeedSync.collect do
      EXAMS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @added_entries = @entries.select { |entry| entry.fetch(:attributes).fetch(:question_number) <= 5 }
  end

  test "承認済みの草案と全二十五問の本文選択肢正答解説出典を照合する" do
    assert_equal 50, @entries.size
    assert_equal 25, @added_entries.size
    EXAMS.each do |exam|
      entries = @entries.select { |entry| entry[:exam_number] == exam }
      assert_equal (1..10).to_a, entries.map { |entry| entry[:attributes][:question_number] }
      assert_equal ANSWERS.fetch(exam), entries.first(5).map { |entry| entry[:attributes][:choices].find { |choice| choice[:correct] }[:label] }
      counts = entries.map { |entry| entry[:attributes][:choices].find { |choice| choice[:correct] }[:label] }.tally
      assert LABELS.all? { |label| (2..3).cover?(counts.fetch(label)) }
    end

    @added_entries.each do |entry|
      attributes = entry.fetch(:attributes)
      key = key_for(entry)
      assert_equal "draft", entry.fetch(:publication_status), key
      assert_equal "teacher_education", attributes.fetch(:major_category_code), key
      assert_equal attributes[:question_number] <= 2 ? "education_foundations" : "education_system", attributes.fetch(:category_code), key
      assert_equal LABELS, attributes.fetch(:choices).map { |choice| choice.fetch(:label) }, key
      assert_equal 1, attributes.fetch(:choices).count { |choice| choice.fetch(:correct) }, key
      preview = QuestionSeedSync.preview(entry)
      QuestionWriter.validate_publication!(preview, QuestionPayload.from_seed(entry[:exam_number], attributes).fetch("choices").map(&:symbolize_keys))

      approved = approved_sections.fetch(key)
      head, tail = approved.split(/^正答：[アイウエ].*$/, 2)
      assert_equal attributes[:choices].find { |choice| choice[:correct] }[:label], approved[/^正答：([アイウエ])/, 1]
      if cloze?(attributes)
        body = head.split(/^\|/).first.lines.reject { |line| line.strip == "---" }.map { |line| line.sub(/^> ?/, "") }.join
        assert_equal normalize(body), normalize(attributes[:content_blocks].map { |block| block[:text] }.join), key
        rows = head.lines.grep(/^\| [アイウエ] \|/).map { |line| line.split("|")[1...-1].map(&:strip) }
        assert_equal attributes[:choices].map { |choice| [choice[:label], *choice[:content_blocks].first[:cells]] }, rows, key
      else
        first_choice = head.index(/^[アイウエ][　 ]/)
        assert_equal normalize(head[0...first_choice]), normalize(attributes[:content_blocks].map { |block| block[:text] }.join), key
        choices = head[first_choice..].split(/^([アイウエ])[　 ]/)
        pairs = choices.drop(1).each_slice(2).map { |label, text| [label, normalize(text)] }
        assert_equal attributes[:choices].map { |choice| [choice[:label], normalize(choice[:content_blocks].first[:text])] }, pairs, key
      end
      explanation, sources = tail.split(/^出典：\s*$/, 2)
      explanation = explanation.strip.sub(/\A解説：\s*/, "").gsub(/^- /, "")
      assert_equal normalize(explanation), normalize(attributes[:explanation_blocks].map { |block| block[:text] }.join), key
      expected_sources = sources.scan(/^- \[([^\n]+)\]\((https:\/\/[^)\n]+)\)\s*$/).map { |title, url| "#{title} | #{url}" }.join("\n")
      assert_equal expected_sources, attributes.fetch(:source_text), key
    end
  end

  test "十二問の穴埋めは指定施行版の独立法令本文に正答だけが一致する" do
    assert_equal 12, LAW_DATA.fetch("cloze_locations").size
    @added_entries.select { |entry| cloze?(entry[:attributes]) }.each do |entry|
      key = key_for(entry)
      attributes = entry.fetch(:attributes)
      parts = LAW_DATA.fetch("cloze_locations").fetch(key)
      original = parts.map { |part| law_part(part) }.join
      quotes = attributes.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
      assert_equal BLANKS, quotes.flat_map { |block| block[:text].scan(/\{\{([①②③④])\}\}/).flatten }.uniq, key
      attributes.fetch(:choices).each do |choice|
        cells = choice[:content_blocks].first.fetch(:cells)
        assert_equal 4, cells.size
        restored = quotes.map do |block|
          strip_numbers(block[:text].gsub(/\{\{([①②③④])\}\}/) { cells.fetch(BLANKS.index(Regexp.last_match(1))) })
        end.join
        assert_equal choice.fetch(:correct), normalize(restored) == normalize(original), "#{key} #{choice[:label]}"
      end
      4.times do |column|
        assert_equal [2, 2], attributes[:choices].map { |choice| choice[:content_blocks].first[:cells][column] }.tally.values.sort, key
      end
      cells = attributes[:choices].find { |choice| choice[:correct] }[:content_blocks].first[:cells]
      cells.each { |cell| assert_not_includes quotes.map { |block| block[:text] }.join, cell, "#{key}の正答露出" }
    end
    assert_equal "322AC0000000026_20260617_508AC0000000037", LAW_DATA.dig("laws", "school", "revision_info", "law_revision_id")
    assert_equal "324AC0000000001_20260401_507AC0000000068", LAW_DATA.dig("laws", "special", "revision_info", "law_revision_id")
    assert_equal "325AC0000000261_20250601_504AC0000000068", LAW_DATA.dig("laws", "local", "revision_info", "law_revision_id")
  end

  test "条文選択と個数問題の各提示文及び養成研修の取り違えを原典で確認する" do
    question = @added_entries.find { |entry| key_for(entry) == "21-3" }[:attributes]
    LAW_DATA.fetch("article_choices").fetch("21-3").each do |label, part|
      text = question[:choices].find { |choice| choice[:label] == label }[:content_blocks].first[:text]
      assert_equal normalize(law_part(part)), normalize(strip_numbers(text)), label
    end
    question = @added_entries.find { |entry| key_for(entry) == "25-3" }[:attributes]
    statements = question[:content_blocks].select { |block| block[:type] == "fill_in_quote" }
    assert_equal 4, statements.size
    LAW_DATA.fetch("count_statements").fetch("25-3").each_with_index do |part, index|
      assert_equal normalize(law_part(part)), normalize(statements[index][:text].sub(/\A[①②③④]　/, ""))
    end
    assert_equal 3, LAW_DATA.fetch("count_statements").fetch("25-3").count { |part| part.first == "education" }
    assert_includes law_part(["education", "9", ["2"]]), "養成と研修の充実"
    question = @added_entries.find { |entry| key_for(entry) == "23-3" }[:attributes]
    assert_includes question[:choices].first[:content_blocks].first[:text], "研究と修養の充実"
    assert_equal "ア", question[:choices].find { |choice| choice[:correct] }[:label]
  end

  test "法令の書き出し条番号参照先及び出題形式配分を維持する" do
    cloze_3 = @added_entries.select { |entry| entry[:attributes][:question_number] == 3 && cloze?(entry[:attributes]) }
    assert_equal [22, 24], cloze_3.map { |entry| entry[:exam_number] }
    assert_equal 4, @added_entries.count { |entry| entry[:attributes][:question_number] == 5 && entry[:attributes][:content_blocks].first[:text].include?("教育公務員特例法") }
    assert_equal 1, @added_entries.count { |entry| entry[:attributes][:question_number] == 5 && entry[:attributes][:content_blocks].first[:text].include?("地方公務員法") }
    @added_entries.select { |entry| [4, 5].include?(entry[:attributes][:question_number]) }.each do |entry|
      attributes = entry[:attributes]
      assert_equal "fill_in_text", attributes[:content_blocks].first[:type]
      assert attributes[:content_blocks].select { |block| block[:type] == "fill_in_quote" }.all? { |block| block[:text].match?(/\A第\d+条(?:の\d+)?/) }
      assert_not attributes[:content_blocks].any? { |block| block[:type] == "quote" }
    end
    [["23-4", "第72条"], ["24-4", "第50条"], ["24-5", "指標"], ["25-5", "主幹教諭等"]].each do |key, text|
      note = @added_entries.find { |entry| key_for(entry) == key }[:attributes][:content_blocks].select { |block| block[:type] == "text" }.map { |block| block[:text] }.join
      assert_includes note, text
    end
  end

  test "必須空欄ゼロと選択肢セル不足を全十二問でseed収集時に拒否する" do
    @added_entries.select { |entry| cloze?(entry[:attributes]) }.each do |entry|
      exam, number = entry.values_at(:exam_number, :attributes)
      number = number[:question_number]
      path = Rails.root.join("db/seeds/mock_exam_#{exam}.rb")
      source = File.read(path)
      mutations = [
        "questions.find { |question| question[:question_number] == #{number} }[:content_blocks].each { |block| block[:text] = block[:text].gsub(/[{][{][①②③④][}][}]/, \"語句\") if block[:type] == \"fill_in_quote\" }\n",
        "questions.find { |question| question[:question_number] == #{number} }[:choices].first[:content_blocks].first[:cells].pop\n",
      ]
      mutations.each do |mutation|
        assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count"] do
          assert_raises(RuntimeError) do
            QuestionSeedSync.collect { eval(source.sub("questions.each do |question|\n", mutation + "questions.each do |question|\n"), binding, path.to_s) }
          end
        end
      end
    end
  end

  test "問一から問十の五十問は管理APIで取得でき一般APIには公開されない" do
    save_entries
    assert_equal 50, Question.where(exam_number: EXAMS, publication_status: "draft").count
    headers = admin_headers
    get api_v1_exams_path, headers: headers
    assert_response :success
    assert_empty response.parsed_body.fetch("data").map { |exam| exam.fetch("exam_number") } & EXAMS
    @added_entries.each do |entry|
      question = Question.find_by!(exam_number: entry[:exam_number], question_number: entry[:attributes][:question_number])
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      data = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, data.fetch("content_blocks")
      assert_equal question.explanation_blocks, data.fetch("explanation_blocks")
      assert_equal question.source_text, data.fetch("source_text")
      assert_equal LABELS, data.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, data.fetch("choices").count { |choice| choice.fetch("is_correct") }
      get api_v1_question_path(question), headers: headers
      assert_response :not_found
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      end
      assert_response :not_found
    end
  end

  test "二回の再実行で追加及び既存問題のID内容履歴お気に入り同期状態を維持する" do
    save_entries
    load Rails.root.join("db/seeds/mock_exam_1.rb")
    user = User.create!(name: "再実行検証", email: "foundations-reseed@example.com", password: "password123", password_confirmation: "password123")
    [[1, 1], [21, 3], [21, 6]].each do |exam, number|
      question = Question.find_by!(exam_number: exam, question_number: number)
      user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
      user.favorites.create!(question: question)
    end
    before = snapshot
    2.times do
      assert_no_difference ["Question.count", "QuestionChoice.count", "QuestionSeedState.count", "AnswerHistory.count", "Favorite.count"] do
        save_entries
      end
      assert_equal before, snapshot
    end
  end

  private

  def save_entries
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end

  def cloze?(attributes)
    attributes[:choices].first[:content_blocks].first[:type] == "fill_in_choice"
  end

  def key_for(entry)
    "#{entry[:exam_number]}-#{entry[:attributes][:question_number]}"
  end

  def normalize(text)
    text.gsub(/\{\{([①②③④])\}\}/, "【\\1】").gsub(/[\s　\p{Cc}]/, "")
  end

  def strip_numbers(text)
    text.gsub(/^第\d+条(?:の\d+)?(?:第\d+項)?[　 ]*/, "").gsub(/^[0-9０-９]+[　 ]+/, "")
  end

  def node_text(node)
    node.is_a?(String) ? node : node.fetch("children", []).map { |child| node_text(child) }.join
  end

  def law_part(part)
    law, article, paragraphs, items = part
    LAW_DATA.fetch("laws").fetch(law).fetch("articles").fetch(article).fetch("children").select do |node|
      node["tag"] == "Paragraph" && paragraphs.include?(node.dig("attr", "Num"))
    end.map do |paragraph|
      paragraph.fetch("children").select do |node|
        node["tag"] == "ParagraphSentence" || (node["tag"] == "Item" && (!items || items.include?(node.dig("attr", "Num"))))
      end.map { |node| node_text(node) }.join
    end.join
  end

  def approved_sections
    @approved_sections ||= DRAFT_FILES.each_with_object({}) do |file, result|
      exam = number = nil
      APPROVED_DRAFTS.fetch(file).each_line do |line|
        if (match = line.match(/^## 模(?:擬)?試(?:験)?(\d+)/))
          exam = match[1].to_i
          number = nil
        elsif (match = line.match(/^### 問(\d+)/))
          number = match[1].to_i
          result["#{exam}-#{number}"] = String.new if number <= 5
        elsif line.start_with?("## ")
          number = nil
        elsif exam && number && number <= 5
          result["#{exam}-#{number}"] << line
        end
      end
    end
  end

  def admin_headers
    @admin_headers ||= begin
      admin = User.create!(name: "管理取得検証", email: "foundations-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
      { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    end
  end

  def snapshot
    [Question, QuestionChoice, QuestionSeedState, AnswerHistory, Favorite].to_h do |model|
      [model.name, model.order(:id).map(&:attributes)]
    end
  end
end

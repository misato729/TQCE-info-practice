require "test_helper"
require_relative "../support/history_revision_20261017"
require "digest"

class MockExamsLawClozeRevisionTest < ActionDispatch::IntegrationTest
  ORIGINALS = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_law_cloze_revision_originals.json"))).freeze
  # Keep the historical aggregate intact. The seven subsequently approved
  # curriculum revisions are source-checked by MockExamsCurriculumRevisionTest;
  # their pre-revision values were captured independently from Git HEAD.
  CURRICULUM_REVISION_BASELINE = JSON.parse(File.read(Rails.root.join("test/fixtures/mock_exams_curriculum_revision_sources.json"))).fetch("previous_attribute_digests").freeze
  ANSWERS = ORIGINALS.fetch("answers").freeze
  BLANKS = %w[① ② ③ ④].freeze
  LABELS = %w[ア イ ウ エ].freeze

  setup do
    @all_entries = QuestionSeedSync.collect do
      (1..25).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    @entries = @all_entries.select { |entry| ANSWERS.key?(key(entry)) }
    @questions = @entries.to_h { |entry| [key(entry), entry.fetch(:attributes)] }
  end

  test "法令改稿対象外は後日承認された七問を独立検査へ委譲して旧照合値を維持する" do
    assert_equal 500, @all_entries.size
    assert_equal ANSWERS.keys.sort, @questions.keys.sort
    unchanged = @all_entries.reject { |entry| ANSWERS.key?(key(entry)) }.map do |entry|
      id = key(entry)
      digest = Digest::SHA256.hexdigest(JSON.generate(HistoryRevision20261017.historical_attributes(id, entry.fetch(:attributes))))
      [id, CURRICULUM_REVISION_BASELINE.fetch(id, digest)]
    end.sort.map { |id, digest| "#{id}|#{digest}" }.join("\n")
    assert_equal ORIGINALS.fetch("unchanged_questions_digest"), Digest::SHA256.hexdigest(unchanged)
  end

  test "正答記号四択一正答分類出典解説及び各セット五件ずつを維持する" do
    @questions.each do |id, question|
      choices = question.fetch(:choices)
      assert_equal LABELS, choices.map { |choice| choice.fetch(:label) }, id
      assert_equal 1, choices.count { |choice| choice.fetch(:correct) }, id
      assert_equal ANSWERS.fetch(id), answer(id).fetch(:label), id
      assert_equal "education_system", question.fetch(:category_code), id
      assert_equal "teacher_education", question.fetch(:major_category_code), id
      assert question.fetch(:source_text).lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }, id
      explanation = question.fetch(:explanation_blocks).map { |block| block[:text] }.join("\n")
      LABELS.each { |label| assert_match(/#{label}(?:：|は|が|の)/, explanation, "#{id} #{label}の解説") }
    end
    @all_entries.group_by { |entry| entry.fetch(:exam_number) }.each do |exam, entries|
      assert_equal (1..20).to_a, entries.map { |entry| entry.fetch(:attributes).fetch(:question_number) }, exam
      assert_equal LABELS.to_h { |label| [label, 5] }, entries.map { |entry| entry[:attributes][:choices].find { |choice| choice[:correct] }[:label] }.tally, exam
    end
  end

  test "十七穴埋めは正答だけが指定施行版の独立原典と一致する" do
    assert_equal 17, ORIGINALS.fetch("cloze_locations").size
    ORIGINALS.fetch("cloze_locations").each do |id, parts|
      original = parts.map do |law, article, paragraphs|
        paragraphs.map { |number| ORIGINALS.fetch("laws").fetch(law).fetch("articles").fetch(article).fetch(number) }.join
      end.join
      assert_equal BLANKS, quotes(id).scan(/\{\{([①②③④])\}\}/).flatten.uniq, id
      @questions.fetch(id).fetch(:choices).each do |choice|
        assert_equal 4, cells(choice).size, id
        restored = quotes(id).gsub(/\{\{([①②③④])\}\}/) { cells(choice).fetch(BLANKS.index(Regexp.last_match(1))) }
        assert_equal choice.fetch(:correct), normalize(strip_numbers(restored)) == normalize(original), "#{id} #{choice[:label]} 原文照合"
      end
    end
  end

  test "全穴埋め列を二対二にし再登場した正答も伏せる" do
    ORIGINALS.fetch("cloze_locations").each_key do |id|
      choices = @questions.fetch(id).fetch(:choices)
      4.times do |column|
        assert_equal [2, 2], choices.map { |choice| cells(choice).fetch(column) }.tally.values.sort, "#{id} 列#{column + 1}"
      end
      cells(answer(id)).each do |term|
        # Include the prompt and out-of-frame supplements, not only the quote.
        visible = @questions.fetch(id).fetch(:content_blocks).map { |block| block[:text] }.join("\n")
        # Article 12 defines 教諭等 and lists distinct compound職名. These are
        # not another occurrence of the standalone職名 教諭 asked in the blank.
        visible = visible.gsub(/助保育教諭|保育教諭|助教諭|教諭等/, "複合職名") if id == "6-5" && term == "教諭"
        assert_not_includes visible, term, "#{id} 本文への正答露出"
      end
    end
    { "4-4" => { "①" => 2, "②" => 2 }, "4-5" => { "①" => 2, "③" => 3 }, "8-4" => { "②" => 2 }, "10-5" => { "④" => 2 } }.each do |id, repetitions|
      repetitions.each { |label, count| assert_equal count, quotes(id).scan("{{#{label}}}").size, "#{id} #{label}" }
    end
  end

  test "名称と学校段階だけで一行に絞る構成をなくす" do
    assert_not_includes cells(answer("5-5")), "研修"
    assert_not_includes cells(answer("20-5")), "研修実施者"
    assert_not_includes cells(answer("20-5")), "計画書"
    assert_not_includes cells(answer("21-5")), "研修実施者"
    assert_not_includes @questions.fetch("21-5").to_json, "努めることができる"
    school_stages = cells(answer("25-4")).values_at(2, 3)
    candidates = @questions.fetch("25-4").fetch(:choices).select { |choice| cells(choice).values_at(2, 3) == school_stages }
    assert_equal 2, candidates.size
    assert_equal 2, candidates.map { |choice| cells(choice).values_at(0, 1) }.uniq.size
  end

  test "政治宗教教育の正誤を否定表現の有無だけで判別させない" do
    choices = @questions.fetch("6-3").fetch(:choices)
    choices.each do |choice|
      text = choice.fetch(:content_blocks).first.fetch(:text)
      assert_includes text, "尊重", choice.fetch(:label)
      assert_match(/禁止|してはならない/, text, choice.fetch(:label))
    end
    articles = ORIGINALS.fetch("laws").fetch("education").fetch("articles")
    assert_equal normalize(articles.fetch("15").values_at("1", "2").join), normalize(answer("6-3").fetch(:content_blocks).first.fetch(:text).gsub("また、", ""))
  end

  test "取得APIは更新本文と選択肢を返し回答前に正答解説を公開しない" do
    QuestionWriter.transaction { @entries.each { |entry| QuestionSeedSync.call(**entry) } }
    user = User.create!(name: "法令改稿確認", email: "law-revision@example.com", role: "admin", password: "password123", password_confirmation: "password123")
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
    @questions.fetch(id).fetch(:choices).find { |choice| choice.fetch(:correct) }
  end

  def cells(choice)
    choice.fetch(:content_blocks).first.fetch(:cells)
  end

  def quotes(id)
    @questions.fetch(id).fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }.map { |block| block.fetch(:text) }.join("\n")
  end

  def normalize(text)
    text.gsub(/[[:space:]　]+/, "")
  end

  def strip_numbers(text)
    text.lines.map do |line|
      line.sub(/\A第\d+条(?:の\d+)?(?:第\d+項)?[　 \t]*/, "")
        .sub(/\A[0-9０-９]+[　 \t]+/, "")
    end.join
  end
end

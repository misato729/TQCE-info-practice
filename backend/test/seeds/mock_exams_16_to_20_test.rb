require "test_helper"

class MockExams16To20Test < ActionDispatch::IntegrationTest
  EXAM_NUMBERS = (16..20).to_a.freeze
  QUESTION_NUMBERS = (1..5).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  EXPECTED_ANSWERS = {
    16 => %w[ウ ア イ エ ウ],
    17 => %w[イ エ ア ウ イ],
    18 => %w[エ イ ウ ア エ],
    19 => %w[ア ウ エ イ ア],
    20 => %w[ウ イ ア エ イ],
  }.freeze
  SCHOOL_PROMPT = "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  EDUCATION_PROMPT = "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  LOCAL_PROMPT = "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze

  # Independent official e-Gov API excerpts, retrieved on 2026-10-06.
  # These originals are not reconstructed from the seed's correct choices.
  LAW_EXCERPTS = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_16_to_20_law_excerpts.json", __dir__))).fetch("excerpts").freeze

  setup do
    load_partial_seeds
  end

  test "承認済み問1から問5だけを五セット各五問の下書きとして保存する" do
    assert_equal 25, partial_questions.count
    assert_equal 25, partial_questions.where(publication_status: "draft").count
    assert_equal 0, partial_questions.published.count
    assert_equal 25, QuestionSeedState.where(exam_number: EXAM_NUMBERS).count

    EXAM_NUMBERS.each do |exam|
      questions = partial_questions.where(exam_number: exam).order(:question_number)
      assert_equal QUESTION_NUMBERS, questions.pluck(:question_number)
      assert_equal EXPECTED_ANSWERS.fetch(exam), questions.map { |question| question.question_choices.find_by!(is_correct: true).choice_label }
      questions.each do |question|
        assert_equal "teacher_education", question.major_category_code
        assert_equal question.question_number <= 2 ? "education_foundations" : "education_system", question.category_code
        assert_equal "draft", question.publication_status
        assert_equal LABELS, question.question_choices.pluck(:choice_label)
        assert_equal 1, question.question_choices.where(is_correct: true).count
        assert question.content_blocks.present?
        assert question.explanation_blocks.present?
        assert question.source_text.lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
      end
    end
  end

  test "全二十五問の表示ブロックと出典は公開時の内容検査も通過する" do
    partial_questions.each do |question|
      choices = QuestionPayload.from_record(question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_publication!(question, choices)
      assert_equal "draft", question.reload.publication_status
      explanation = question.explanation_blocks.map { |block| block.fetch("text") }.join("\n")
      if [20, 3] == [question.exam_number, question.question_number]
        %w[① ② ③ ④].each { |label| assert_includes explanation, label }
        assert_includes explanation, "イ・ウ・エ"
      else
        LABELS.each { |label| assert_includes explanation, "#{label}：" }
      end
    end
  end

  test "問3の三種の正誤と二問の穴埋め及び問5の法令配分を維持する" do
    question_3s = partial_questions.where(question_number: 3).order(:exam_number).to_a
    assert_equal [17, 19], question_3s.select { |question| question.content_blocks.first.fetch("type") == "fill_in_text" }.map(&:exam_number)
    assert_includes question_3s[0].content_blocks.first.fetch("text"), "正しいものを一つ"
    assert_includes question_3s[2].content_blocks.first.fetch("text"), "適切でないものを一つ"
    assert_includes question_3s[4].content_blocks.first.fetch("text"), "正しいものが幾つあるか"

    question_5s = partial_questions.where(question_number: 5).order(:exam_number).to_a
    prompts = question_5s.map { |question| question.content_blocks.first.fetch("text") }
    assert_equal 4, prompts.count(EDUCATION_PROMPT)
    assert_equal 1, prompts.count(LOCAL_PROMPT)
    assert_equal LOCAL_PROMPT, question_5s[2].content_blocks.first.fetch("text")

    histories = partial_questions.where(question_number: 1..2).order(:exam_number, :question_number).to_a
    negative = histories.select { |question| question.content_blocks.first.fetch("text").include?("適切でないもの") }
    assert_equal [[18, 1], [20, 2]], negative.map { |question| [question.exam_number, question.question_number] }
  end

  test "問4と問5は指定導入文と条番号を持つ四空欄の条文問題である" do
    partial_questions.where(question_number: 4..5).each do |question|
      prompt = question.content_blocks.first
      assert_equal "fill_in_text", prompt.fetch("type")
      expected_prompt = if question.question_number == 4
        SCHOOL_PROMPT
      elsif question.exam_number == 18
        LOCAL_PROMPT
      else
        EDUCATION_PROMPT
      end
      assert_equal expected_prompt, prompt.fetch("text")
      quote = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      assert_match(/\A第\d+条/, quote)
      assert_equal %w[① ② ③ ④], quote.scan(/\{\{([①②③④])\}\}/).flatten.uniq
      question.question_choices.each do |choice|
        assert_equal 1, choice.content_blocks.size
        assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
        assert_equal 4, choice.content_blocks.first.fetch("cells").size
      end
    end
  end

  test "全十二問の穴埋めは正答だけを復元すると連続した公式原文に一致する" do
    clozes = partial_questions.to_a.select { |question| question.content_blocks.any? { |block| block["type"] == "fill_in_quote" } }
    assert_equal 12, clozes.size
    assert_equal LAW_EXCERPTS.keys.sort, clozes.map { |question| "#{question.exam_number}-#{question.question_number}" }.sort

    clozes.each do |question|
      quote = question.content_blocks.select { |block| block["type"] == "fill_in_quote" }.map { |block| block.fetch("text") }.join("\n")
      body = quote.lines.reject { |line| line.strip.match?(/\A第\d+条(?:の\d+)?(?:第\d+項)?\z/) }
        .map { |line| line.sub(/\A[0-9一二三四五六七八九十]+[　 ]/, "") }.join
      original = normalized(LAW_EXCERPTS.fetch("#{question.exam_number}-#{question.question_number}"))
      question.question_choices.each do |choice|
        cells = choice.content_blocks.first.fetch("cells")
        restored = body.gsub(/\{\{([①②③④])\}\}/) { cells.fetch(%w[① ② ③ ④].index(Regexp.last_match(1))) }
        assert_equal choice.is_correct?, normalized(restored) == original,
          "模試#{question.exam_number} 問#{question.question_number} #{choice.choice_label}の原文一致"
      end

      answer = question.question_choices.find_by!(is_correct: true)
      answer.content_blocks.first.fetch("cells").each { |cell| assert_not_includes quote, cell }
    end
  end

  test "補足を引用外に置き再登場する答えも同じ空欄番号で隠す" do
    question_17_4 = partial_questions.find_by!(exam_number: 17, question_number: 4)
    assert_equal "text", question_17_4.content_blocks[1].fetch("type")
    assert_includes question_17_4.content_blocks[1].fetch("text"), "第29条"
    assert_includes question_17_4.content_blocks[1].fetch("text"), "第21条"

    question_17_5 = partial_questions.find_by!(exam_number: 17, question_number: 5)
    quote_17_5 = question_17_5.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_includes quote_17_5, "第22条の3"
    assert_includes quote_17_5, "以下この章において「{{③}}」という。"

    question_18_4 = partial_questions.find_by!(exam_number: 18, question_number: 4)
    quote_18_4 = question_18_4.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal 2, quote_18_4.scan("{{①}}").size
    assert_equal 2, quote_18_4.scan("{{④}}").size

    question_19_4 = partial_questions.find_by!(exam_number: 19, question_number: 4)
    assert_equal "text", question_19_4.content_blocks[1].fetch("type")
    assert_includes question_19_4.content_blocks[1].fetch("text"), "第57条"
    assert_equal "特別の技能教育", question_19_4.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells")[3]

    question_19_5 = partial_questions.find_by!(exam_number: 19, question_number: 5)
    quote_19_5 = question_19_5.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal 6, quote_19_5.scan("{{①}}").size
    assert_includes quote_19_5, "当該{{①}}の属する"

    question_20_4 = partial_questions.find_by!(exam_number: 20, question_number: 4)
    quote_20_4 = question_20_4.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal 2, quote_20_4.scan("{{③}}").size
    assert_equal "拘禁刑", question_20_4.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells")[1]
  end

  test "下書きは一般向け一覧と問題取得及び回答APIに公開されない" do
    get api_v1_exams_path
    assert_response :success
    assert_empty response.parsed_body.fetch("data").select { |exam| EXAM_NUMBERS.include?(exam.fetch("exam_number")) }

    EXAM_NUMBERS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }
      assert_response :not_found
    end
    partial_questions.each do |question|
      get api_v1_question_path(question)
      assert_response :not_found
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.first.id }, as: :json
      end
      assert_response :not_found
    end
  end

  test "管理APIでは下書き二十五問の本文と四択及び正答と解説と出典を確認できる" do
    admin = User.create!(name: "seed管理検証", email: "draft-seed-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    EXAM_NUMBERS.each do |exam|
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "draft" }, headers: headers
      assert_response :success
      assert_equal 5, response.parsed_body.dig("meta", "total_count")
      assert_equal QUESTION_NUMBERS, response.parsed_body.fetch("data").map { |question| question.fetch("question_number") }
    end
    partial_questions.each do |question|
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal "draft", body.fetch("publication_status")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      assert_equal question.explanation_blocks, body.fetch("explanation_blocks")
      assert_equal question.source_text, body.fetch("source_text")
      assert_equal LABELS, body.fetch("choices").map { |choice| choice.fetch("choice_label") }
      assert_equal 1, body.fetch("choices").count { |choice| choice.fetch("is_correct") }
    end
  end

  test "seed再実行で問題と選択肢を増やさず履歴と管理画面の訂正を保持する" do
    question = partial_questions.find_by!(exam_number: 16, question_number: 1)
    user = User.create!(name: "seed再実行検証", email: "partial-seed-check@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    question_ids = partial_questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)

    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
      load_partial_seeds
    end
    assert_equal question_ids, partial_questions.order(:id).pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)
    assert AnswerHistory.exists?(history.id)

    hidden = partial_questions.find_by!(exam_number: 17, question_number: 1)
    hidden.update!(publication_status: "private")
    removed = partial_questions.find_by!(exam_number: 18, question_number: 1)
    QuestionWriter.destroy!(removed)
    question.update!(content_blocks: [{ type: "text", text: "管理画面で訂正した文面" }])
    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count"] do
      load_partial_seeds
    end
    assert_equal "管理画面で訂正した文面", question.reload.content_blocks.first.fetch("text")
    assert_equal "private", hidden.reload.publication_status
    assert_not Question.exists?(exam_number: 18, question_number: 1)
    assert QuestionSeedState.find_by!(exam_number: 18, question_number: 1).deleted?
    assert AnswerHistory.exists?(history.id)
  end

  test "メインseedは完成済み三百問と下書き二十五問を読み込み再実行できる" do
    load Rails.root.join("db/seeds.rb")
    assert_equal 325, Question.count
    assert_equal 1300, QuestionChoice.count
    assert_equal 325, QuestionChoice.where(is_correct: true).count
    assert_equal 300, Question.published.count
    assert_equal 25, partial_questions.where(publication_status: "draft").count
    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
      load Rails.root.join("db/seeds.rb")
    end
  end

  private

  def normalized(text)
    text.gsub(/[\s　]/, "")
  end

  def partial_questions
    Question.where(exam_number: EXAM_NUMBERS)
  end

  def load_partial_seeds
    entries = QuestionSeedSync.collect do
      EXAM_NUMBERS.each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    QuestionWriter.transaction { entries.each { |entry| QuestionSeedSync.call(**entry) } }
  end
end

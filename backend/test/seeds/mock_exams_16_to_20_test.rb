require "test_helper"

class MockExams16To20Test < ActionDispatch::IntegrationTest
  EXAM_NUMBERS = (16..20).to_a.freeze
  QUESTION_NUMBERS = (1..20).to_a.freeze
  LABELS = %w[ア イ ウ エ].freeze
  EXPECTED_ANSWERS = {
    16 => %w[ウ ア イ エ ウ エ イ ア ウ エ イ ア ウ イ イ エ ウ ア ア エ],
    17 => %w[イ エ ア ウ イ ウ ア エ イ ウ エ イ ア ウ エ イ ア エ ウ ア],
    18 => %w[エ イ ウ ア エ イ ウ エ ア ア ウ エ イ ア ア ウ イ ウ エ イ],
    19 => %w[ア ウ エ イ ア エ イ ウ ア エ ア ウ エ イ ウ ア イ エ イ ウ],
    20 => %w[ウ イ ア エ イ ア エ イ ウ ア エ ウ ア エ エ イ ウ ア ウ イ],
  }.freeze
  INFORMATION_CATEGORIES = {
    16 => %w[information_specialized information_specialized information_specialized],
    17 => %w[information_specialized information_specialized information_specialized],
    18 => %w[information_specialized information_specialized information_education],
    19 => %w[information_specialized information_education information_specialized],
    20 => %w[information_education information_education information_specialized],
  }.freeze
  QUESTION_7_CATEGORIES = {
    16 => "special_support_education", 17 => "career_education",
    18 => "special_support_education", 19 => "curriculum_organization",
    20 => "curriculum_organization",
  }.freeze
  SCHOOL_PROMPT = "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  EDUCATION_PROMPT = "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze
  LOCAL_PROMPT = "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。".freeze

  # Independent official e-Gov API excerpts, retrieved on 2026-10-06.
  # These originals are not reconstructed from the seed's correct choices.
  LAW_EXCERPTS = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_16_to_20_law_excerpts.json", __dir__))).fetch("excerpts").freeze
  CURRICULUM_FIXTURE = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_16_to_20_curriculum_excerpts.json", __dir__))).freeze
  CURRICULUM_EXCERPTS = CURRICULUM_FIXTURE.fetch("excerpts").freeze
  GUIDANCE_POLICY_FIXTURE = JSON.parse(File.read(File.expand_path("../fixtures/mock_exams_16_to_20_guidance_policy_excerpts.json", __dir__))).freeze
  GUIDANCE_POLICY_EXCERPTS = GUIDANCE_POLICY_FIXTURE.fetch("excerpts").freeze
  REIWA_TITLE = "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）".freeze

  setup do
    load_partial_seeds
  end

  test "承認済み全二十問を五セット各二十問として公開し正答位置各五件を維持する" do
    assert_equal 100, partial_questions.count
    assert_equal 100, partial_questions.published.count
    assert_equal 0, partial_questions.where(publication_status: "draft").count
    assert_equal 100, QuestionSeedState.where(exam_number: EXAM_NUMBERS).count

    EXAM_NUMBERS.each do |exam|
      questions = partial_questions.where(exam_number: exam).order(:question_number)
      assert_equal QUESTION_NUMBERS, questions.pluck(:question_number)
      assert_equal EXPECTED_ANSWERS.fetch(exam), questions.map { |question| question.question_choices.find_by!(is_correct: true).choice_label }
      assert_equal LABELS.to_h { |label| [label, 5] }, questions.map { |question| question.question_choices.find_by!(is_correct: true).choice_label }.tally
      questions.each do |question|
        assert_equal(question.question_number >= 16 ? "information" : "teacher_education", question.major_category_code)
        expected_category = case question.question_number
        when 1, 2 then "education_foundations"
        when 3..5 then "education_system"
        when 6 then "curriculum_organization"
        when 7 then QUESTION_7_CATEGORIES.fetch(exam)
        when 8 then "integrated_inquiry"
        when 9 then "moral_education"
        when 10 then "special_activities"
        when 11 then "student_guidance_career"
        when 12 then "special_support_education"
        when 13, 14 then "educational_psychology"
        when 15 then "education_system"
        when 16..18 then INFORMATION_CATEGORIES.fetch(exam).fetch(question.question_number - 16)
        when 19, 20 then "information_specialized"
        end
        assert_equal expected_category, question.category_code
        assert_equal "published", question.publication_status
        assert_equal LABELS, question.question_choices.pluck(:choice_label)
        assert_equal 1, question.question_choices.where(is_correct: true).count
        assert question.content_blocks.present?
        assert question.explanation_blocks.present?
        assert question.source_text.lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
      end
    end
  end

  test "全百問の表示ブロックと出典は公開時の内容検査も通過する" do
    partial_questions.each do |question|
      choices = QuestionPayload.from_record(question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_publication!(question, choices)
      assert_equal "published", question.reload.publication_status
      explanation = question.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
      if [20, 3] == [question.exam_number, question.question_number]
        %w[① ② ③ ④].each { |label| assert_includes explanation, label }
        assert_includes explanation, "イ・ウ・エ"
      elsif question.question_number <= 5
        LABELS.each { |label| assert_includes explanation, "#{label}：" }
      else
        question.question_choices.reject(&:is_correct?).each do |choice|
          assert_match(/#{choice.choice_label}(?:は|：|・)/, explanation)
        end
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
    clozes = partial_questions.where(question_number: 1..5).to_a.select { |question| question.content_blocks.any? { |block| cloze_quote?(block) } }
    assert_equal 12, clozes.size
    assert_equal LAW_EXCERPTS.keys.sort, clozes.map { |question| "#{question.exam_number}-#{question.question_number}" }.sort

    clozes.each do |question|
      quote = question.content_blocks.select { |block| cloze_quote?(block) }.map { |block| block.fetch("text") }.join("\n")
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

  test "問6から問10は原文と参照を除いた記述を区別し正答だけが独立原典と対応する" do
    clozes = partial_questions.where(question_number: 6..10).order(:exam_number, :question_number).to_a
    assert_equal 25, clozes.size
    assert_equal CURRICULUM_EXCERPTS.keys.sort, clozes.map { |question| "#{question.exam_number}-#{question.question_number}" }.sort

    clozes.each do |question|
      key = "#{question.exam_number}-#{question.question_number}"
      prompt = question.content_blocks.first
      assert_equal "fill_in_text", prompt.fetch("type")
      if key == "16-6"
        assert_match(/\A次の文は，.+の「.+」に示された内容に基づく記述である。文中の空欄 \{\{①\}\} ～ \{\{③\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/, prompt.fetch("text"))
      else
        assert_match(/\A次の文章は，.+の「.+」からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[③④]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/, prompt.fetch("text"))
      end
      quotes = question.content_blocks.select { |block| block["type"] == "fill_in_quote" }
      assert_equal 1, quotes.size
      quote = quotes.first.fetch("text")
      labels = quote.scan(/\{\{([①②③④])\}\}/).flatten.uniq
      expected_size = [[16, 6], [18, 7]].include?([question.exam_number, question.question_number]) ? 3 : 4
      assert_equal %w[① ② ③ ④].first(expected_size), labels
      # 原典fixture自体は変更せず、照合対象の境界・項番除去を明示する。
      original_text = CURRICULUM_EXCERPTS.fetch(key)
      if %w[16-6 17-6].include?(key)
        original_text = original_text.delete_prefix("第２款の２の（1）に示す")
      end
      original_text = original_text.sub("（6）に示すとおり", "") if key == "16-6"
      original = normalized(original_text)

      question.question_choices.each do |choice|
        assert_equal 1, choice.content_blocks.size
        assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
        cells = choice.content_blocks.first.fetch("cells")
        assert_equal expected_size, cells.size
        restored = quote.gsub(/\{\{([①②③④])\}\}/) { cells.fetch(labels.index(Regexp.last_match(1))) }
        assert_equal choice.is_correct?, normalized(restored) == original, "#{key} #{choice.choice_label}の原文一致"
      end

      question.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells").each do |cell|
        assert_not_includes quote, cell, "#{key}の正答語句露出"
      end
      location = CURRICULUM_FIXTURE.fetch("locations").fetch(key)
      expected_url = CURRICULUM_FIXTURE.fetch("sources").fetch(location.fetch("source"))
      assert_includes question.source_text, "#{expected_url}#page=#{location.fetch('pdf_pages').first}"
    end
  end

  test "問6と問7の出典範囲を維持し問8と問10は本体二問と解説三問に配分する" do
    EXAM_NUMBERS.each do |exam|
      question_6 = partial_questions.find_by!(exam_number: exam, question_number: 6)
      assert_includes question_6.content_blocks.first.fetch("text"), "第1章 総則 第3款 教育課程の実施と学習評価"
      assert_includes question_6.source_text, "第1章第3款"
      question_7 = partial_questions.find_by!(exam_number: exam, question_number: 7)
      assert_includes question_7.content_blocks.first.fetch("text"), "第1章 総則 第5款 生徒の発達の支援"
      assert_includes question_7.source_text, "第1章第5款"
      (6..8).each do |number|
        prompt = partial_questions.find_by!(exam_number: exam, question_number: number).content_blocks.first.fetch("text")
        heading = prompt[/の「(.+)」(?:からの抜粋|に示された内容に基づく記述)である。/, 1]
        assert_not_nil heading
        assert_no_match(/\s(?:\([0-9]+\)|[ア-ン])\z/, heading)
      end
      question_9_prompt = partial_questions.find_by!(exam_number: exam, question_number: 9).content_blocks.first.fetch("text")
      if [17, 20].include?(exam)
        assert_includes question_9_prompt, "第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。"
      else
        assert_includes question_9_prompt, "第1章 総則 第7款 道徳教育に関する配慮事項"
      end
    end

    { 8 => [16, 18], 10 => [17, 20] }.each do |number, main_exams|
      questions = partial_questions.where(question_number: number).order(:exam_number).to_a
      from_main = questions.reject { |question| question.content_blocks.first.fetch("text").include?("解説") }
      assert_equal main_exams, from_main.map(&:exam_number)
      assert_equal 3, questions.count { |question| question.content_blocks.first.fetch("text").include?("解説") }
    end
  end

  test "問6から問10の補足を引用枠の外に置き再登場する正答も伏せる" do
    question_16_6 = partial_questions.find_by!(exam_number: 16, question_number: 6)
    assert_includes question_16_6.content_blocks.first.fetch("text"), "示された内容に基づく記述"
    assert_equal %w[fill_in_text fill_in_quote], question_16_6.content_blocks.map { |block| block.fetch("type") }
    quote = question_16_6.content_blocks.last.fetch("text")
    assert_no_match(/第２款|（6）に示す/, quote)
    question_18_9 = partial_questions.find_by!(exam_number: 18, question_number: 9)
    reference = question_18_9.content_blocks.find { |block| block["type"] == "text" && block["text"].start_with?("参考：") }
    assert_includes reference.fetch("text"), "基盤となる道徳性"

    { [16, 10] => %w[① ②], [17, 8] => %w[① ②], [20, 6] => %w[② ③], [20, 8] => %w[①] }.each do |(exam, number), labels|
      quote = partial_questions.find_by!(exam_number: exam, question_number: number).content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      labels.each { |label| assert_operator quote.scan("{{#{label}}}").size, :>=, 2 }
    end
  end

  test "問6から問10に既存十五セットと同じ抜粋と空欄の実質重複はない" do
    entries = QuestionSeedSync.collect do
      (1..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    existing_signatures = entries.select { |entry| (6..10).cover?(entry.fetch(:attributes).fetch(:question_number)) }.map do |entry|
      attributes = entry.fetch(:attributes)
      quote = attributes.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }.map { |block| block.fetch(:text) }.join("\n")
      cells = attributes.fetch(:choices).find { |choice| choice[:correct] }.fetch(:content_blocks).first.fetch(:cells)
      [normalized(quote), cells]
    end
    added_signatures = partial_questions.where(question_number: 6..10).map do |question|
      quote = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      cells = question.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells")
      [normalized(quote), cells]
    end
    assert_equal 25, added_signatures.uniq.size
    assert_empty existing_signatures & added_signatures
  end

  test "問11は連続した原文の三空欄四問と原図の役割対応一問に配分する" do
    questions = partial_questions.where(question_number: 11).order(:exam_number).to_a
    assert_equal [16, 17, 18, 19], questions.select { |question| question.content_blocks.any? { |block| cloze_quote?(block) } }.map(&:exam_number)
    assert_equal [20], questions.select { |question| question.content_blocks.any? { |block| block["type"] == "table" } }.map(&:exam_number)
    questions.each do |question|
      prompt = question.content_blocks.first
      assert_equal "fill_in_text", prompt.fetch("type")
      assert_match(/\A次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。/, prompt.fetch("text"))
      quote = question.content_blocks.find { |block| %w[quote fill_in_quote].include?(block["type"]) }.fetch("text")
      assert_operator quote.length, :>=, 200
      labels = question.content_blocks.flat_map { |block| block.fetch("text", "").scan(/\{\{([①②③])\}\}/).flatten }.uniq.sort
      assert_equal %w[① ② ③], labels
      question.question_choices.each do |choice|
        assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
        assert_equal 3, choice.content_blocks.first.fetch("cells").size
      end
      3.times do |column|
        counts = question.question_choices.map { |choice| choice.content_blocks.first.fetch("cells")[column] }.tally.values.sort
        assert_equal [2, 2], counts
      end
    end

    school_rules = questions.find { |question| question.exam_number == 17 }
    quote = school_rules.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal 2, quote.scan("{{①}}").size
    assert_includes quote, "校則[*40]"
    assert_includes school_rules.content_blocks.find { |block| block["type"] == "text" }.fetch("text"), "[*40]"
  end

  test "問11及び問15の穴埋めは正答だけが独立した公式PDFの連続抜粋に一致する" do
    clozes = partial_questions.where(question_number: [11, 15]).select { |question| question.content_blocks.any? { |block| cloze_quote?(block) } }
    assert_equal %w[16-11 17-11 17-15 18-11 19-11], clozes.map { |question| "#{question.exam_number}-#{question.question_number}" }.sort
    clozes.each do |question|
      key = "#{question.exam_number}-#{question.question_number}"
      quote = question.content_blocks.find { |block| cloze_quote?(block) }.fetch("text")
      original = normalized(GUIDANCE_POLICY_EXCERPTS.fetch(key))
      question.question_choices.each do |choice|
        cells = choice.content_blocks.first.fetch("cells")
        restored = quote.gsub(/\{\{([①②③])\}\}/) { cells.fetch(%w[① ② ③].index(Regexp.last_match(1))) }
        assert_equal choice.is_correct?, normalized(restored) == original, "#{key} #{choice.choice_label}の原文一致"
      end
      question.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells").each do |cell|
        assert_not_includes quote, cell, "#{key}の正答語句露出"
      end
      location = GUIDANCE_POLICY_FIXTURE.fetch("locations").fetch(key)
      source_url = GUIDANCE_POLICY_FIXTURE.fetch("sources").fetch(location.fetch("source"))
      assert_includes question.source_text, "#{source_url}#page=#{location.fetch('pdf_pages').first}"
    end
  end

  test "模試20問11の表は図13の役割に一致し空欄番号を文字として表示する" do
    question = partial_questions.find_by!(exam_number: 20, question_number: 11)
    quote = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal normalized(GUIDANCE_POLICY_EXCERPTS.fetch("20-11")), normalized(quote)
    table = question.content_blocks.find { |block| block["type"] == "table" }
    assert_equal ["職名", "通常時", "通告時，通告後"], table.fetch("headers")
    assert_equal %w[【①】 【②】 【③】], table.fetch("rows").map(&:first)
    assert_no_match(/\{\{/, table.fetch("rows").flatten.join)
    original_rows = GUIDANCE_POLICY_FIXTURE.fetch("figure_13").fetch("rows")
    question.question_choices.each do |choice|
      cells = choice.content_blocks.first.fetch("cells")
      restored = table.fetch("rows").each_with_index.map { |row, index| [cells[index], *row.drop(1)] }
      assert_equal choice.is_correct?, restored == original_rows, "図13 #{choice.choice_label}の対応"
    end
    assert_includes question.explanation_blocks.last.fetch("text"), "排他的に限定されるという意味ではありません"
  end

  test "模試20問3と問11は空欄のない本文も通常の試験抜粋枠で表示する" do
    [3, 11].each do |number|
      question = partial_questions.find_by!(exam_number: 20, question_number: number)
      quote = question.content_blocks.second
      assert_equal "fill_in_quote", quote.fetch("type")
      assert_no_match(/\{\{/, quote.fetch("text"))
      assert_not cloze_quote?(quote)
      assert_not question.content_blocks.any? { |block| block["type"] == "quote" }
    end
    count_question = partial_questions.find_by!(exam_number: 20, question_number: 3)
    assert_equal "text", count_question.content_blocks.first.fetch("type")
    assert_equal %w[二つ 一つ 三つ なし], count_question.question_choices.order(:display_order).map { |choice| choice.content_blocks.first.fetch("text") }
  end

  test "模試20の必須穴埋めは空欄なしの試験抜粋枠と混同せず空欄ゼロを拒否する" do
    seed_path = Rails.root.join("db/seeds/mock_exam_20.rb")
    source = File.read(seed_path)
    marker = "questions.each do |question|\n"
    assert_includes source, marker

    [4, 5, *(6..10)].each do |number|
      # メモリ上だけで空欄を取り除き、DBへ保存する前のseed検査を確認する。
      mutation = <<~RUBY
        questions.find { |question| question.fetch(:question_number) == #{number} }.fetch(:content_blocks).each do |block|
          block[:text] = block.fetch(:text).gsub(/[{][{][①②③④][}][}]/, "語句") if block[:type] == "fill_in_quote"
        end
        #{marker}
      RUBY
      modified_source = source.sub(marker, mutation)
      assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
        error = assert_raises(RuntimeError) do
          QuestionSeedSync.collect { eval(modified_source, binding, seed_path.to_s) }
        end
        assert_equal "模擬試験20 問#{number}の原文穴埋めには空欄が必要です", error.message
      end
    end
  end

  test "問12の発達障害三問とその他二問及び問13の青年期四問とその他一問を維持する" do
    supports = partial_questions.where(question_number: 12).order(:exam_number).to_a
    assert_match(/学習障害（LD）/, supports[0].content_blocks.first.fetch("text"))
    assert_match(/視覚障害/, supports[1].content_blocks.first.fetch("text"))
    assert_match(/注意欠如・多動性障害（ADHD）/, supports[2].content_blocks.first.fetch("text"))
    assert_match(/言語障害/, supports[3].content_blocks.first.fetch("text"))
    assert_match(/自閉症スペクトラム障害（ASD）/, supports[4].content_blocks.first.fetch("text"))
    assert_includes supports[0].content_blocks.first.fetch("text"), "手指の細かな運動の正確さを評価"
    assert_equal "①・④", supports[0].question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text")
    assert_equal "①・③", supports[4].question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text")

    development = partial_questions.where(question_number: 13).order(:exam_number).to_a
    assert_equal [16, 17, 18, 19], development.select { |question| question.content_blocks.first.fetch("text").include?("青年期") }.map(&:exam_number)
    assert_includes development.last.content_blocks.first.fetch("text"), "ヴィゴツキー"
    assert_includes development[2].question_choices.find_by!(choice_label: "ウ").content_blocks.first.fetch("text"), "社会的責任を一定期間猶予"
    assert_includes development[2].source_text, "https://www.tohoku-gakuin.ac.jp/research/journal/bk2010/pdf/bk2010no07_02.pdf"
    assert_includes development[3].source_text, "https://fukutake.iii.u-tokyo.ac.jp/ylab/2011/09/post-328.html"
  end

  test "問13と問14は長い四選択肢で理論と概念の対応を問う" do
    partial_questions.where(question_number: 13..14).each do |question|
      assert_equal "text", question.content_blocks.first.fetch("type")
      question.question_choices.each do |choice|
        assert_equal "text", choice.content_blocks.first.fetch("type")
        assert_operator choice.content_blocks.first.fetch("text").length, :>=, 65
      end
      explanation = question.explanation_blocks.map { |block| block.fetch("text") }.join("\n")
      LABELS.each { |label| assert_includes explanation, "#{label}：" }
    end
    learning = partial_questions.where(question_number: 14).order(:exam_number).to_a
    %w[古典的条件づけ 原因帰属 メタ認知 長期記憶 認知的評価理論].each_with_index do |topic, index|
      assert_includes learning[index].content_blocks.first.fetch("text"), topic
    end
    assert_includes learning[1].content_blocks.first.fetch("text"), "当該課題に費やした努力"
    assert_includes learning[4].question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text"), "情報的側面"
  end

  test "問15は指定答申名で正誤四問と原文三空欄一問に配分する" do
    policy = partial_questions.where(question_number: 15).order(:exam_number).to_a
    policy.each { |question| assert_includes question.content_blocks.first.fetch("text"), REIWA_TITLE }
    assert_equal [17], policy.select { |question| question.content_blocks.first.fetch("type") == "fill_in_text" }.map(&:exam_number)
    assert_equal [18], policy.select { |question| question.content_blocks.first.fetch("text").include?("適切でないもの") }.map(&:exam_number)
    quote = policy[1].content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_includes quote, "①学習機会と学力の保障，②社会の形成者"
    assert_includes quote, "③安全・安心な居場所"
    assert_equal %w[① ② ③], quote.scan(/\{\{([①②③])\}\}/).flatten
    assert_operator quote.length, :>=, 450
    assert_includes policy[3].question_choices.find_by!(choice_label: "ア").content_blocks.first.fetch("text"), "構成員とは異なる学校外の協力者"
    assert_includes policy[4].question_choices.find_by!(choice_label: "ウ").content_blocks.first.fetch("text"), "ICTの効果的活用とデジタル教科書・教材の整備"
    assert_includes policy[4].question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text"), "少人数によるきめ細かな指導体制"
  end

  test "問11から問15に既存十五セット及び追加二十五問内で完全重複はない" do
    entries = QuestionSeedSync.collect do
      (1..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
    end
    existing = entries.select { |entry| (11..15).cover?(entry.fetch(:attributes).fetch(:question_number)) }.map do |entry|
      normalized(entry.fetch(:attributes).fetch(:content_blocks).to_json)
    end
    added = partial_questions.where(question_number: 11..15).map { |question| normalized(question.content_blocks.to_json) }
    assert_equal 25, added.uniq.size
    assert_empty existing & added
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

  test "完成した五セットは一般向け一覧と問題取得及び回答APIで利用できる" do
    headers = paid_user_headers("exams-16-20@example.com")
    get api_v1_exams_path, headers: headers
    assert_response :success
    assert_equal EXAM_NUMBERS, response.parsed_body.fetch("data").select { |exam| EXAM_NUMBERS.include?(exam.fetch("exam_number")) }.map { |exam| exam.fetch("exam_number") }

    EXAM_NUMBERS.each do |exam|
      get next_api_v1_questions_path, params: { exam_number: exam }, headers: headers
      assert_response :success
      assert_equal [exam, 1], response.parsed_body.fetch("data").values_at("exam_number", "question_number")
    end
    partial_questions.each do |question|
      get api_v1_question_path(question), headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      %w[correct_choice explanation_blocks source_text].each { |key| assert_not body.key?(key) }
      body.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: question.question_choices.find_by!(is_correct: true).id }, headers: headers, as: :json
      end
      assert_response :success
      assert response.parsed_body.dig("data", "is_correct")
      assert_equal question.explanation_blocks, response.parsed_body.dig("data", "explanation_blocks")
      assert_equal question.source_text, response.parsed_body.dig("data", "source_text")
    end
  end

  def paid_user_headers(email)
    user = User.create!(name: "有料会員", email: email, password: "password123", password_confirmation: "password123")
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end

  test "管理APIでは公開百問の本文と四択及び正答と解説と出典を確認できる" do
    admin = User.create!(name: "seed管理検証", email: "draft-seed-admin@example.com", role: "admin", password: "password123", password_confirmation: "password123")
    headers = { "Authorization" => "Bearer #{AuthToken.issue(admin)}" }
    EXAM_NUMBERS.each do |exam|
      get "/api/v1/admin/questions", params: { exam_number: exam, publication_status: "published" }, headers: headers
      assert_response :success
      assert_equal 20, response.parsed_body.dig("meta", "total_count")
      assert_equal QUESTION_NUMBERS, response.parsed_body.fetch("data").map { |question| question.fetch("question_number") }
    end
    partial_questions.each do |question|
      get "/api/v1/admin/questions/#{question.id}", headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal "published", body.fetch("publication_status")
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
    added = partial_questions.find_by!(exam_number: 19, question_number: 13)
    added_history = user.answer_histories.create!(question: added, selected_choice: added.question_choices.find_by!(is_correct: true), is_correct: true)
    question_ids = partial_questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)

    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
      load_partial_seeds
    end
    assert_equal question_ids, partial_questions.order(:id).pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)
    assert AnswerHistory.exists?(history.id)
    assert AnswerHistory.exists?(added_history.id)

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
    assert AnswerHistory.exists?(added_history.id)
  end

  test "メインseedは完成済み二十五セット五百問を公開し再実行できる" do
    load Rails.root.join("db/seeds.rb")
    assert_equal 500, Question.count
    assert_equal 2000, QuestionChoice.count
    assert_equal 500, QuestionChoice.where(is_correct: true).count
    assert_equal 500, Question.published.count
    assert_equal 100, Question.where(exam_number: 21..25, publication_status: "published").count
    assert_equal 0, partial_questions.where(publication_status: "draft").count
    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count", "QuestionSeedState.count"] do
      load Rails.root.join("db/seeds.rb")
    end
  end

  private

  def cloze_quote?(block)
    block["type"] == "fill_in_quote" && block.fetch("text").match?(/\{\{[①②③④⑤⑥]\}\}/)
  end

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

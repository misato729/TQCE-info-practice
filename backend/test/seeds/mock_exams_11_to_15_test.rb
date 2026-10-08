require "test_helper"

class MockExams11To15Test < ActionDispatch::IntegrationTest
  EXPECTED_LAW_ANSWERS = {
    11 => %w[ウ イ エ],
    12 => %w[エ ア ウ],
    13 => %w[イ エ ア],
    14 => %w[ア ウ イ],
    15 => %w[イ イ ウ],
  }.freeze

  EXPECTED_NEW_ANSWERS = {
    11 => %w[イ ウ ア イ エ],
    12 => %w[エ ア ウ エ ア],
    13 => %w[ア エ イ ウ ウ],
    14 => %w[イ イ エ ア エ],
    15 => %w[ウ ア エ イ ア],
  }.freeze

  EXPECTED_INFORMATION_ANSWERS = {
    11 => %w[ウ ア エ ウ イ],
    12 => %w[イ エ ウ ア イ],
    13 => %w[エ イ ア ウ ア],
    14 => %w[ウ イ ア エ ウ],
    15 => %w[ア ウ エ イ エ],
  }.freeze

  EXPECTED_GUIDELINE_ANSWERS = {
    11 => %w[ウ ア イ エ ア],
    12 => %w[エ ウ ア イ イ],
    13 => %w[イ エ ウ ア ウ],
    14 => %w[ウ イ エ エ ア],
    15 => %w[ア ウ イ ア エ],
  }.freeze

  EXPECTED_QUESTION_7_CATEGORIES = {
    11 => "career_education", 12 => "special_support_education",
    13 => "curriculum_organization", 14 => "student_guidance_career",
    15 => "educational_counseling",
  }.freeze

  EXPECTED_INFORMATION_CATEGORIES = {
    11 => %w[information_specialized information_education information_specialized],
    12 => %w[information_specialized information_education information_specialized],
    13 => %w[information_education information_specialized information_specialized],
    14 => %w[information_specialized information_specialized information_specialized],
    15 => %w[information_education information_education information_specialized],
  }.freeze

  EXPECTED_INFORMATION_SCOPES = {
    11 => [0, 1, 2], 12 => [0, 1, 3], 13 => [0, 2, 3],
    14 => [1, 2, 3], 15 => [0, 1, 2],
  }.freeze

  EXPECTED_QUESTION_NUMBERS = (1..20).to_a.freeze

  EXPECTED_CATEGORIES = {
    1 => "education_foundations", 2 => "education_foundations",
    3 => "education_system", 4 => "education_system", 5 => "education_system",
    6 => "curriculum_organization", 8 => "integrated_inquiry",
    9 => "moral_education", 10 => "special_activities",
    11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology", 15 => "education_system",
    19 => "information_specialized", 20 => "information_specialized",
  }.freeze

  setup do
    load_completed_seeds
  end

  test "完成した五セットを各二十問の公開問題として保存する" do
    assert_equal 100, completed_questions.count
    assert_equal 100, completed_questions.published.count

    (11..15).each do |exam|
      questions = completed_questions.where(exam_number: exam).order(:question_number)
      assert_equal EXPECTED_QUESTION_NUMBERS, questions.pluck(:question_number)
      assert_equal EXPECTED_LAW_ANSWERS.fetch(exam), questions.where(question_number: 3..5).map { |q| q.question_choices.find_by!(is_correct: true).choice_label }
      assert_equal EXPECTED_GUIDELINE_ANSWERS.fetch(exam), questions.where(question_number: 6..10).map { |q| q.question_choices.find_by!(is_correct: true).choice_label }
      assert_equal EXPECTED_NEW_ANSWERS.fetch(exam), questions.where(question_number: 11..15).map { |q| q.question_choices.find_by!(is_correct: true).choice_label }
      assert_equal EXPECTED_INFORMATION_ANSWERS.fetch(exam), questions.where(question_number: 16..20).map { |q| q.question_choices.find_by!(is_correct: true).choice_label }
      assert_equal({ "ア" => 5, "イ" => 5, "ウ" => 5, "エ" => 5 },
        questions.map { |q| q.question_choices.find_by!(is_correct: true).choice_label }.tally)

      questions.each do |question|
        assert_equal "published", question.publication_status
        assert_equal question.question_number >= 16 ? "information" : "teacher_education", question.major_category_code
        expected_category = if (16..18).cover?(question.question_number)
          EXPECTED_INFORMATION_CATEGORIES.fetch(exam)[question.question_number - 16]
        elsif question.question_number == 7
          EXPECTED_QUESTION_7_CATEGORIES.fetch(exam)
        else
          EXPECTED_CATEGORIES.fetch(question.question_number)
        end
        assert_equal expected_category, question.category_code
        assert_equal %w[ア イ ウ エ], question.question_choices.pluck(:choice_label)
        assert_equal 1, question.question_choices.where(is_correct: true).count
        assert question.content_blocks.present?
        assert question.explanation_blocks.present?
        assert question.source_text.lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
      end
    end
  end

  test "全百問が公開時の本文と出典及び空欄検査を通過する" do
    completed_questions.each do |question|
      choices = QuestionPayload.from_record(question).fetch("choices").map(&:symbolize_keys)
      QuestionWriter.validate_publication!(question, choices)
      assert_equal "published", question.reload.publication_status
    end
  end

  test "問6から問10は指定範囲の穴埋めで参照先展開を明示し本体と解説の配分を保つ" do
    prompt_pattern = /\A次の文章は，.+の「.+」からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[②③④⑤]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/
    based_on_pattern = /\A次の文は，.+の「.+」に示された内容に基づく記述である。文中の空欄 \{\{①\}\} ～ \{\{④\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/

    completed_questions.where(question_number: 6..10).each do |question|
      prompt = question.content_blocks.first
      assert_equal "fill_in_text", prompt.fetch("type")
      adapted = [question.exam_number, question.question_number] == [12, 7]
      assert_match adapted ? based_on_pattern : prompt_pattern, prompt.fetch("text")
      quotes = question.content_blocks.select { |block| block["type"] == "fill_in_quote" }
      assert_equal 1, quotes.size
      labels = quotes.first.fetch("text").scan(/\{\{([①②③④⑤])\}\}/).flatten.uniq
      assert_equal [15, 8] == [question.exam_number, question.question_number] ? 3 : 4, labels.size
      assert_equal %w[① ② ③ ④ ⑤].first(labels.size), labels
      question.question_choices.each do |choice|
        assert_equal [{ "type" => "fill_in_choice", "cells" => choice.content_blocks.first.fetch("cells") }], choice.content_blocks
        assert_equal labels.size, choice.content_blocks.first.fetch("cells").size
      end

      section = prompt.fetch("text")[/の「(.+)」(?:からの抜粋|に示された内容に基づく記述)である。/, 1]
      if (6..8).cover?(question.question_number)
        refute_match(/\s(?:\(\d+\)|[ア-ン])\z/, section)
      end
      case question.question_number
      when 6
        assert_includes section, "第1章 総則 第3款 教育課程の実施と学習評価"
        assert_includes question.source_text, "第1章第3款"
      when 7
        assert_includes section, "第1章 総則 第5款 生徒の発達の支援"
        assert_includes question.source_text, "第1章第5款"
        assert_includes %w[special_support_education curriculum_organization student_guidance_career educational_counseling career_education], question.category_code
      when 8
        assert_match(/総合的な探究の時間/, section + question.source_text)
      when 9
        assert_match(/第1章 総則 第(?:1款 高等学校教育の基本と教育課程の役割|7款 道徳教育に関する配慮事項)\z/, section)
        assert_match(/第1章第(?:1款|7款)/, question.source_text)
      when 10
        assert_match(/特別活動/, section + question.source_text)
      end
      assert question.source_text.lines.all? { |line| line.include?("https://www.mext.go.jp/") }
    end

    { 8 => "解説 総合的な探究の時間編", 10 => "解説 特別活動編" }.each do |number, title|
      questions = completed_questions.where(question_number: number).to_a
      assert_equal 5, questions.size
      assert_includes [2, 3], questions.count { |question| question.content_blocks.first.fetch("text").include?(title) }
      assert_includes [2, 3], questions.count { |question| !question.content_blocks.first.fetch("text").include?(title) }
    end
  end

  test "問11は長い連続抜粋四問と原典の図表一問で三空欄を保つ" do
    questions = completed_questions.where(question_number: 11).order(:exam_number).to_a
    excerpt_fills = questions.select do |question|
      question.content_blocks.any? { |block| block["type"] == "fill_in_quote" && block.fetch("text").include?("{{") }
    end
    assert_equal 4, excerpt_fills.size
    assert_equal 1, questions.count { |question| question.content_blocks.any? { |block| block["type"] == "table" } }

    questions.each do |question|
      prompt = question.content_blocks.first.fetch("text")
      assert prompt.start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
      excerpt = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      assert_operator excerpt.length, :>=, 140
      labels = question.content_blocks.flat_map { |block| block["text"].to_s.scan(/\{\{([①②③])\}\}/).flatten }.uniq.sort
      assert_equal %w[① ② ③], labels
      question.question_choices.each do |choice|
        assert_equal 3, choice.content_blocks.first.fetch("cells").size
      end
      assert_match(/生徒指導提要.+第[13]章.+\| https:\/\/www\.mext\.go\.jp\//, question.source_text)
    end

    table_question = questions.find { |question| question.exam_number == 14 }
    table = table_question.content_blocks.find { |block| block["type"] == "table" }
    assert_equal ["支援チームの形態", "連携・協働"], table.fetch("headers")
    assert_equal [
      ["［①］", "担任等と学年・各校務分掌の最小単位の連携・協働"],
      ["［②］", "ミドルリーダーのコーディネーションによる連携・協働"],
      ["［③］", "地域・関係機関等との連携・協働"],
    ], table.fetch("rows")
    assert_equal %w[機動的連携型支援チーム 校内連携型支援チーム ネットワーク型支援チーム],
      table_question.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells")
  end

  test "問12から問14の承認済みの論点と配分及び全選択肢解説を保持する" do
    topic_patterns = {
      12 => [/聴覚障害/, /自閉症スペクトラム障害/, /選択性かん黙/, /学習障害.*注意欠如/, /病弱・身体虚弱/],
      13 => [/エリクソン/, /マーシャ/, /チャム・グループ/, /レヴィン/, /ピアジェ/],
      14 => [/スキナー.*プログラム学習/, /オーズベル/, /バンデューラ.*自己効力感/, /学習の転移/, /記憶及び忘却/],
    }
    topic_patterns.each do |number, patterns|
      completed_questions.where(question_number: number).order(:exam_number).each_with_index do |question, index|
        assert_match patterns[index], question.content_blocks.first.fetch("text")
        explanation = question.explanation_blocks.map { |block| block.fetch("text") }.join("\n")
        %w[ア イ ウ エ].each { |label| assert_includes explanation, "#{label}：" }
      end
    end
  end

  test "問15は正式資料名で正誤四問と原文穴埋め一問を保存する" do
    questions = completed_questions.where(question_number: 15).order(:exam_number).to_a
    report_title = "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）"
    assert_equal 4, questions.count { |question| question.content_blocks.none? { |block| block["type"] == "fill_in_quote" } }
    assert_equal 1, questions.count { |question| question.content_blocks.any? { |block| block["type"] == "fill_in_quote" } }
    questions.each do |question|
      assert_includes question.content_blocks.first.fetch("text"), report_title
      assert_includes question.source_text, "https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf"
      explanation = question.explanation_blocks.map { |block| block.fetch("text") }.join("\n")
      %w[ア イ ウ エ].each { |label| assert_includes explanation, "#{label}：" }
    end

    fill = questions.last
    quote = fill.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
    assert_equal %w[① ② ③ ④], quote.scan(/\{\{([①②③④])\}\}/).flatten.uniq
    assert_operator quote.length, :>, 700
    assert_equal %w[総合教育会議 首長部局 自主的・自立的 学校運営や教育行政],
      fill.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("cells")
    assert_includes fill.source_text, "総論4（5）"
  end

  test "法令の指定体裁と四空欄の対応及び出題配分を保持する" do
    fills = completed_questions.where(question_number: 3..5).select do |question|
      question.content_blocks.any? { |block| block["type"] == "fill_in_quote" }
    end
    assert_equal 12, fills.size

    fills.each do |question|
      excerpt = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.fetch("text")
      assert_match(/\A第\d+条/, excerpt)
      assert_equal %w[① ② ③ ④], excerpt.scan(/\{\{([①②③④])\}\}/).flatten.uniq
      question.question_choices.each do |choice|
        assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
        assert_equal 4, choice.content_blocks.first.fetch("cells").size
      end

      next if question.question_number == 3

      law_title = if question.question_number == 4
        "「学校教育法」（昭和22年法律第26号）"
      elsif question.exam_number == 14
        "「地方公務員法」 （昭和25年法律第261号）"
      else
        "「教育公務員特例法」 （昭和24年法律第1号）"
      end
      expected_prompt = "次の各文は，#{law_title}の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
      assert_equal expected_prompt, question.content_blocks.first.fetch("text")
    end

    question_3_prompts = completed_questions.where(question_number: 3).map { |q| q.content_blocks.first.fetch("text") }
    assert_equal 2, question_3_prompts.count { |text| text.include?("空欄") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("うち，正しいものを") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("適切でないもの") }
    assert_equal 1, question_3_prompts.count { |text| text.include?("正しいものが幾つあるか") }
  end

  test "問16から問18の原典範囲を異なる三範囲にして資料順と空欄数を保持する" do
    (11..15).each do |exam|
      scopes = completed_questions.where(exam_number: exam, question_number: 16..18).order(:question_number).map do |question|
        prompt = question.content_blocks.first.fetch("text")
        assert_equal "fill_in_text", question.content_blocks.first.fetch("type")
        assert_includes prompt, "高等学校学習指導要領"
        assert_includes prompt, "文章中の空欄 {{①}} ～"
        quote = question.content_blocks.second.fetch("text")
        labels = quote.scan(/\{\{([①②③④])\}\}/).flatten
        assert_equal %w[① ② ③ ④].first(labels.size), labels
        assert_includes [3, 4], labels.size
        assert_operator quote.length, :>=, 140
        question.question_choices.each do |choice|
          assert_equal "fill_in_choice", choice.content_blocks.first.fetch("type")
          assert_equal labels.size, choice.content_blocks.first.fetch("cells").size
        end

        if prompt.include?("解説 情報編")
          assert_includes question.source_text, "高等学校学習指導要領（平成30年告示）解説 情報編"
          assert_includes question.source_text, "https://www.mext.go.jp/content/1407073_11_1_2.pdf"
          part = prompt.include?("第1部") ? 1 : 2
          assert_includes question.source_text, "第#{part}部"
          if part == 1
            assert_includes prompt, "各学科に共通する教科『情報』"
          else
            assert_includes prompt, "主として専門学科において開設される教科『情報』"
          end
          part + 1
        else
          assert_includes question.source_text, "https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf"
          assert_includes prompt, "平成30年3月30日文部科学省告示第68号"
          scope = prompt.include?("第2章 第10節") ? 0 : 1
          assert_includes question.source_text, scope == 0 ? "第2章第10節" : "第3章第7節"
          assert_match(/1 目標|3 内容の取扱い/, prompt) if scope == 1
          scope
        end
      end
      assert_equal EXPECTED_INFORMATION_SCOPES.fetch(exam), scopes
    end
  end

  test "参照先を展開した二問は原文抜粋と混同させず全誤答を解説する" do
    completed_questions.where(question_number: 16..18).each do |question|
      prompt = question.content_blocks.first.fetch("text")
      adapted = [[14, 16], [15, 16]].include?([question.exam_number, question.question_number])
      assert_equal adapted, prompt.include?("示された内容に基づく記述")
      assert_equal !adapted, prompt.include?("からの抜粋である")
      quote = question.content_blocks.second.fetch("text")
      refute_match(/内容の（\d）|〔指導項目〕の（\d）/, quote)
      explanation = question.explanation_blocks.filter_map { |block| block["text"] }.join("\n")
      question.question_choices.reject(&:is_correct?).each do |choice|
        assert_includes explanation, choice.choice_label
      end
    end
  end

  test "問19のコードと選択肢から連続圧縮と二次元交換と巡回合計を検算する" do
    compressed = completed_questions.find_by!(exam_number: 11, question_number: 19)
    data = code_array(compressed, "Data")
    assert_includes question_code(compressed), "06     もし Data[i] == Data[i-1] ならば:"
    check_choices(compressed) do |cells|
      pairs = []
      count = 1
      (1...data.size).each do |i|
        if data[i] == data[i - 1]
          count += 1
        else
          pairs << [cells[0] == "Data[i-1]" ? data[i - 1] : data[i], count]
          count = 1
        end
      end
      pairs << [data.last, cells[1].include?(", count]") ? count : 1]
      pairs == [[2, 3], [5, 2], [1, 1], [2, 2]]
    end

    transposed = completed_questions.find_by!(exam_number: 13, question_number: 19)
    matrix = code_array(transposed, "M")
    assert_includes question_code(transposed), "06         M[i][j] = M[j][i]"
    check_choices(transposed) do |cells|
      values = matrix.map(&:dup)
      values.size.times do |i|
        first = cells[0] == "0" ? 0 : i + 1
        (first...values.size).each do |j|
          temp = values[i][j]
          values[i][j] = values[j][i]
          values[j][i] = cells[1] == "temp" ? temp : values[i][j]
        end
      end
      values == matrix.transpose
    end

    circular = completed_questions.find_by!(exam_number: 14, question_number: 19)
    data = code_array(circular, "Data")
    assert_includes question_code(circular), "08     Buf[p] = Data[i]\n09     s = s + Buf[p]"
    check_choices(circular) do |cells|
      buffer, p, sum, out = [0, 0, 0], 0, 0, []
      data.each_with_index do |value, i|
        sum -= cells[0].include?("Buf[p]") ? buffer[p] : value
        buffer[p] = value
        sum += buffer[p]
        p = (p + 1) % cells[1].last.to_i
        out << sum if i >= 2
      end
      out == [8, 10, 12, 14, 16]
    end
  end

  test "問19の探索比較回数と同値を含む代入回数及びコード字下げを保持する" do
    search = completed_questions.find_by!(exam_number: 12, question_number: 19)
    data = code_array(search, "Data")
    group = search.content_blocks.find { |block| block["type"] == "code_group" }
    assert_equal ["プログラムA", "プログラムB"], group.fetch("items").map { |item| item.fetch("title") }
    assert_includes group.fetch("items").first.fetch("code"), "    もし Data[i] == key ならば:\n        pos = i\n        繰り返しを終了する\n    i = i + 1"
    assert_includes group.fetch("items").last.fetch("code"), "Workの末尾にkeyを追加する"
    assert_equal [5, 6], linear_search(data, 4, sentinel: false)
    assert_equal [5, 6], linear_search(data, 4, sentinel: true)
    assert_equal [-1, 7], linear_search(data, 5, sentinel: false)
    assert_equal [-1, 8], linear_search(data, 5, sentinel: true)
    [false, true].each do |sentinel|
      assert_equal 4, data.sum { |key| linear_search(data, key, sentinel: sentinel).last }.fdiv(data.size)
    end
    assert_equal "①と②", search.question_choices.find_by!(is_correct: true).content_blocks.first.fetch("text")

    counted = completed_questions.find_by!(exam_number: 15, question_number: 19)
    assert_includes question_code(counted), "08         もし run >= best ならば:\n09             best = run\n10             updates = updates + 1"
    assert_includes question_code(counted), "11     そうでなければ:\n12         run = 0"
    run = best = updates = 0
    code_array(counted, "Data").each do |value|
      if value.positive?
        run += 1
        if run >= best
          best = run
          updates += 1
        end
      else
        run = 0
      end
    end
    assert_equal [4, 6], [best, updates]
    check_choices(counted) { |cells| cells.map(&:to_i) == [best, updates] }
  end

  test "問20の度数表と四分位数及び予測の変数の対応を検査する" do
    quartiles = completed_questions.find_by!(exam_number: 11, question_number: 20)
    table = quartiles.content_blocks.find { |block| block["type"] == "table" }
    data = table.fetch("headers").drop(1).zip(table.fetch("rows").first.drop(1)).flat_map { |value, frequency| [value.to_i] * frequency.to_i }
    assert_equal 12, data.size
    median = ->(values) { (values[values.size / 2 - 1] + values[values.size / 2]).fdiv(2) }
    mode = data.tally.max_by(&:last).first
    statistics = [median.call(data), median.call(data.first(6)), median.call(data.last(6)), mode]
    assert_equal [1.5, 1, 2.5, 1], statistics
    check_choices(quartiles) { |cells| cells.map(&:to_f) == statistics }

    prediction = completed_questions.find_by!(exam_number: 13, question_number: 20)
    assert_includes prediction.content_blocks.first.fetch("text"), "利用者数から，その月の電力使用量を予測"
    prediction.question_choices.each do |choice|
      text = choice.content_blocks.first.fetch("text")
      roles_correct = text.start_with?("利用者数を説明変数，電力使用量を目的変数")
      avoids_causal_confusion = text.include?("観測された相関とは別に検討が必要")
      assert_equal choice.is_correct?, roles_correct && avoids_causal_confusion
    end
  end

  test "問20の具体的な分散変換とクロス表の割合及び有意水準を検算する" do
    transformation = completed_questions.find_by!(exam_number: 12, question_number: 20)
    assert_includes transformation.content_blocks.map { |block| block["text"] }.join, "データの個数で割った値"
    rows = transformation.content_blocks.find { |block| block["type"] == "table" }.fetch("rows")
    data = rows.map { |row| row.last.split("，").map(&:to_f) }
    assert_equal data.first.map { |value| value + 10 }, data.last
    statistics = data.map do |values|
      mean = values.sum.fdiv(values.size)
      variance = values.sum { |value| (value - mean)**2 }.fdiv(values.size)
      [mean, variance, Math.sqrt(variance)]
    end
    assert_equal [4, 14], statistics.map(&:first)
    assert_equal statistics.first.drop(1), statistics.last.drop(1)
    assert_in_delta 8.0 / 3, statistics.first[1]
    assert_equal "イ", transformation.question_choices.find_by!(is_correct: true).choice_label

    cross_tabulation = completed_questions.find_by!(exam_number: 14, question_number: 20)
    table = cross_tabulation.content_blocks.find { |block| block["type"] == "table" }.fetch("rows")
    total, frequent, daily, joint = table.last.last.to_f, table.first.last.to_f, table.last[1].to_f, table.first[1].to_f
    first_rate = joint / frequent * 100
    second_rate = table[1][1].to_f / table[1].last.to_f * 100
    daily_rate = daily / total * 100
    reverse_rate = joint / daily * 100
    assert_equal [60, 10, 30, 80], [first_rate, second_rate, daily_rate, reverse_rate]
    correct_rates = { "ア" => [daily_rate, first_rate], "イ" => [first_rate, second_rate],
      "ウ" => [first_rate, second_rate], "エ" => [reverse_rate, frequent / total * 100] }
    cross_tabulation.question_choices.each do |choice|
      values = choice.content_blocks.first.fetch("text").scan(/(\d+)%/).flatten.map(&:to_f)
      assert_equal choice.is_correct?, values == correct_rates.fetch(choice.choice_label)
    end

    hypothesis = completed_questions.find_by!(exam_number: 15, question_number: 20)
    p_value = hypothesis.content_blocks.first.fetch("text")[/p値）として(\d+\.\d+)/, 1].to_f
    assert_equal 0.04, p_value
    assert_equal [true, false], [0.05, 0.01].map { |level| p_value <= level }
    answer = hypothesis.question_choices.find_by!(is_correct: true)
    assert_equal "エ", answer.choice_label
    assert_includes answer.content_blocks.first.fetch("text"), "母平均が等しいと証明したことを意味しない"
  end

  test "再実行で問題や選択肢を増やさず変更のない回答履歴を保持する" do
    question = completed_questions.find_by!(exam_number: 11, question_number: 3)
    user = User.create!(name: "seed検証", email: "seed-check@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)
    question_ids = completed_questions.order(:id).pluck(:id)
    choice_ids = QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)

    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count"] do
      load_completed_seeds
    end
    assert_equal question_ids, completed_questions.order(:id).pluck(:id)
    assert_equal choice_ids, QuestionChoice.where(question_id: question_ids).order(:id).pluck(:id)
    assert AnswerHistory.exists?(history.id)

    question.update!(content_blocks: [{ type: "text", text: "変更前の文面" }])
    load_completed_seeds
    assert AnswerHistory.exists?(history.id)
    assert_equal "変更前の文面", question.reload.content_blocks.first.fetch("text")
  end

  test "全五セットを一般向け一覧と問番号順の問題取得へ公開し回答前に正答を開示しない" do
    headers = paid_user_headers("exams-11-15-view@example.com")
    get api_v1_exams_path, headers: headers
    assert_response :success
    exams = response.parsed_body.fetch("data").select { |exam| (11..15).cover?(exam.fetch("exam_number")) }
    assert_equal (11..15).to_a, exams.map { |exam| exam.fetch("exam_number") }
    exams.each { |exam| assert_equal (1..20).to_a, exam.fetch("question_numbers") }

    (11..15).each do |exam|
      (1..20).each do |number|
        params = { exam_number: exam }
        params[:after_question_number] = number - 1 if number > 1
        get next_api_v1_questions_path, params: params, headers: headers
        assert_response :success
        body = response.parsed_body.fetch("data")
        assert_equal [exam, number], body.values_at("exam_number", "question_number")
        assert_answer_hidden(body)
      end
      get next_api_v1_questions_path, params: { exam_number: exam, after_question_number: 20 }, headers: headers
      assert_response :not_found
    end

    completed_questions.each do |question|
      get api_v1_question_path(question), headers: headers
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal question.content_blocks, body.fetch("content_blocks")
      assert_answer_hidden(body)
      assert_equal %w[ア イ ウ エ], body.fetch("choices").map { |choice| choice.fetch("choice_label") }
    end
  end

  test "公開した全百問を有料会員が採点でき回答後に解説と出典を返す" do
    headers = paid_user_headers("exams-11-15-answer@example.com")
    completed_questions.each do |question|
      answer = question.question_choices.find_by!(is_correct: true)
      assert_difference "AnswerHistory.count", 1 do
        post answer_api_v1_question_path(question), params: { selected_choice_id: answer.id }, headers: headers, as: :json
      end
      assert_response :success
      body = response.parsed_body.fetch("data")
      assert_equal true, body.fetch("is_correct")
      assert_equal answer.id, body.dig("correct_choice", "id")
      assert_equal question.explanation_blocks, body.fetch("explanation_blocks")
      assert_equal question.source_text, body.fetch("source_text")
      assert body.fetch("answer_history_id").present?
    end
  end

  def paid_user_headers(email)
    user = User.create!(name: "有料会員", email: email, password: "password123", password_confirmation: "password123")
    payment = Payment.create!(user: user, stripe_checkout_session_id: "cs_#{user.id}", stripe_price_id: "price_test", status: "paid", paid_at: Time.current)
    Membership.create!(user: user, source_payment: payment, status: "active", activated_at: Time.current)
    { "Authorization" => "Bearer #{AuthToken.issue(user)}" }
  end

  test "旧seedと同じ下書き状態からの公開切替は回答履歴を消さない" do
    question = completed_questions.find_by!(exam_number: 11, question_number: 3)
    state = QuestionSeedState.find_by!(exam_number: 11, question_number: 3)
    question.update!(publication_status: "draft")
    state.update!(seed_publication_status: "draft")
    user = User.create!(name: "公開検証", email: "publication-check@example.com", password: "password123", password_confirmation: "password123")
    history = user.answer_histories.create!(question: question, selected_choice: question.question_choices.find_by!(is_correct: true), is_correct: true)

    assert_no_difference ["Question.count", "QuestionChoice.count", "AnswerHistory.count"] do
      load_completed_seeds
    end
    assert_equal "published", question.reload.publication_status
    assert_equal "published", state.reload.seed_publication_status
    assert AnswerHistory.exists?(history.id)
  end

  test "管理側で非公開化又は削除した問題は公開seed再実行で復活させない" do
    hidden = completed_questions.find_by!(exam_number: 11, question_number: 6)
    removed = completed_questions.find_by!(exam_number: 12, question_number: 10)
    hidden.update!(publication_status: "private")
    QuestionWriter.destroy!(removed)

    assert_no_difference ["Question.count", "QuestionChoice.count"] do
      load_completed_seeds
    end
    assert_equal "private", hidden.reload.publication_status
    assert_not Question.exists?(exam_number: 12, question_number: 10)
    assert_equal true, QuestionSeedState.find_by!(exam_number: 12, question_number: 10).deleted?
    [hidden, removed].each do |question|
      get api_v1_question_path(question)
      assert_response :not_found
      assert_no_difference "AnswerHistory.count" do
        post answer_api_v1_question_path(question), params: { selected_choice_id: 0 }, as: :json
      end
      assert_response :not_found
    end
  end

  private

  def assert_answer_hidden(body)
    %w[is_correct correct_choice explanation_blocks source_text].each { |field| assert_not body.key?(field) }
    assert_equal 4, body.fetch("choices").size
    body.fetch("choices").each { |choice| assert_not choice.key?("is_correct") }
  end

  def question_code(question)
    question.content_blocks.find { |block| block["type"] == "code" }.fetch("code")
  end

  def code_array(question, name)
    JSON.parse(question_code(question)[/#{name} = (\[[^\n]+\])/, 1])
  end

  def check_choices(question)
    question.question_choices.each do |choice|
      cells = choice.content_blocks.first.fetch("rows").first
      assert_equal choice.is_correct?, yield(cells), "模試#{question.exam_number} 問#{question.question_number} #{choice.choice_label}"
    end
  end

  def linear_search(data, key, sentinel:)
    values = sentinel ? data + [key] : data
    count = 0
    values.each_with_index do |value, index|
      count += 1
      return [index < data.size ? index : -1, count] if value == key
    end
    [-1, count]
  end

  def completed_questions
    Question.where(exam_number: 11..15)
  end

  def load_completed_seeds
    (11..15).each { |exam| load Rails.root.join("db/seeds/mock_exam_#{exam}.rb") }
  end
end

%w[
  mock_exam_1.rb
  mock_exam_2.rb
  mock_exam_3.rb
  mock_exam_4.rb
  mock_exam_5.rb
  mock_exam_6.rb
  mock_exam_7.rb
  mock_exam_8.rb
  mock_exam_9.rb
  mock_exam_10.rb
].each do |seed_file|
  load Rails.root.join("db/seeds", seed_file).to_s
end

standard_expected_categories = [
  "education_foundations",
  "education_foundations",
  "education_system",
  "education_system",
  "education_system",
  "curriculum_organization",
  "curriculum_organization",
  "integrated_inquiry",
  "moral_education",
  "special_activities",
  "student_guidance_career",
  "special_support_education",
  "educational_psychology",
  "educational_psychology",
  "education_system",
  "information_education",
  "information_education",
  "information_education",
  "information_specialized",
  "information_specialized",
].freeze

expected_categories_by_exam = {
  1 => standard_expected_categories.dup.tap { |categories| categories[6] = "student_guidance_career" }.freeze,
  2 => standard_expected_categories.dup.tap { |categories| categories[6] = "career_education" }.freeze,
  3 => standard_expected_categories.dup.tap { |categories| categories[6] = "special_support_education" }.freeze,
  4 => [
    "education_foundations",
    "education_foundations",
    "education_system",
    "education_system",
    "education_system",
    "curriculum_organization",
    "educational_counseling",
    "integrated_inquiry",
    "moral_education",
    "special_activities",
    "student_guidance_career",
    "special_support_education",
    "educational_psychology",
    "educational_psychology",
    "education_system",
    "information_specialized",
    "information_education",
    "information_education",
    "information_specialized",
    "information_specialized",
  ].freeze,
  5 => [
    "education_foundations",
    "education_foundations",
    "education_system",
    "education_system",
    "education_system",
    "curriculum_organization",
    "special_support_education",
    "integrated_inquiry",
    "moral_education",
    "special_activities",
    "student_guidance_career",
    "special_support_education",
    "educational_psychology",
    "educational_psychology",
    "education_system",
    "information_education",
    "information_education",
    "information_education",
    "information_specialized",
    "information_specialized",
  ].freeze,
}.freeze

standard_fill_in_prompt_pattern = /\A次の文章は，.+の「.+」からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[②③④⑤]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/
based_on_fill_in_prompt_pattern = /\A次の文は，.+の「.+」に示された内容に基づく記述である。文中の空欄 \{\{①\}\} ～ \{\{[②③④⑤]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/
school_education_act_prompt = "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
education_personnel_act_prompt = "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
local_public_service_act_prompt = "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
student_guidance_prompt_pattern = /\A次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[②③④⑤]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/
reiwa_answer_title = "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）"

(1..5).each do |exam_number|
  exam_questions = Question.where(exam_number: exam_number).includes(:question_choices).order(:question_number).to_a

  unless exam_questions.map(&:question_number) == (1..20).to_a
    raise "模擬試験#{exam_number}は問1から問20までの20問で構成してください"
  end

  unless exam_questions.map(&:category_code) == expected_categories_by_exam.fetch(exam_number)
    raise "模擬試験#{exam_number}の出題分野または問題順が不正です"
  end

  unless (6..10).all? { |question_number| exam_questions[question_number - 1].content_blocks.any? { |block| block["type"] == "fill_in_text" } }
    raise "模擬試験#{exam_number}の問6から問10は全て抜粋穴埋め問題にしてください"
  end

  question_6 = exam_questions[5]
  question_6_prompt = question_6.content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
  unless question_6_prompt.include?("第3款 教育課程の実施と学習評価") && question_6.source_text.include?("第1章第3款")
    raise "模擬試験#{exam_number}の問6は第1章総則第3款から出題してください"
  end

  question_4_prompt = exam_questions[3].content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
  unless question_4_prompt == school_education_act_prompt
    raise "模擬試験#{exam_number}の問4は学校教育法の指定体裁による4空欄問題にしてください"
  end

  question_5_prompt = exam_questions[4].content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
  unless [education_personnel_act_prompt, local_public_service_act_prompt].include?(question_5_prompt)
    raise "模擬試験#{exam_number}の問5は教育公務員特例法又は地方公務員法の指定体裁にしてください"
  end

  [exam_questions[3], exam_questions[4]].each do |question|
    quote_text = question.content_blocks.find { |block| block["type"] == "fill_in_quote" }.to_h["text"].to_s
    unless quote_text.match?(/\A第\d+条/)
      raise "模擬試験#{exam_number}の問#{question.question_number}は抜粋枠の冒頭に条番号を表示してください"
    end

    blank_labels = question.content_blocks
      .select { |block| block["type"] == "fill_in_quote" }
      .flat_map { |block| block["text"].to_s.scan(/\{\{([①②③④])\}\}/).flatten }
      .uniq
    unless blank_labels == %w[① ② ③ ④]
      raise "模擬試験#{exam_number}の問#{question.question_number}は4空欄の条文穴埋め問題にしてください"
    end
  end

  if exam_number <= 3
    question_7_prompt = exam_questions[6].content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
    unless question_7_prompt.include?("第1章 総則 第5款")
      raise "模擬試験#{exam_number}の問7は第1章総則第5款から出題してください"
    end
  end

  (6..8).each do |question_number|
    prompt = exam_questions[question_number - 1].content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
    section_name = prompt[/の「(.+)」からの抜粋である。/, 1].to_s
    if section_name.match?(/\s(?:\(\d+\)|[ア-ン])\z/)
      raise "模擬試験#{exam_number}の問#{question_number}は抜粋分野名の末尾に個別項目番号を表示しないでください"
    end
  end

  question_9_prompt = exam_questions[8].content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
  if question_9_prompt.include?("第1章 総則 第1款") &&
      !question_9_prompt.include?("第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。")
    raise "模擬試験#{exam_number}の問9を第1款から出題するときは抜粋分野名を指定の表記にしてください"
  end

  question_15_text = exam_questions[14].content_blocks.map { |block| block["text"].to_s }.join("\n")
  unless question_15_text.include?(reiwa_answer_title)
    raise "模擬試験#{exam_number}の問15は答申名を指定の正式表記にしてください"
  end

  information_source_ranges = [
    {
      name: "学習指導要領第2章第10節",
      prompt_terms: ["高等学校学習指導要領", "第2章", "第10節"],
      source_terms: ["『高等学校学習指導要領（平成30年告示）』", "第2章第10節"],
      excluded_terms: ["解説 情報編"],
    },
    {
      name: "学習指導要領第3章第7節",
      prompt_terms: ["高等学校学習指導要領", "第3章", "第7節"],
      source_terms: ["『高等学校学習指導要領（平成30年告示）』", "第3章第7節"],
      excluded_terms: ["解説 情報編"],
    },
    {
      name: "解説情報編第1部",
      prompt_terms: ["高等学校学習指導要領（平成30年告示）解説 情報編", "第1部", "各学科に共通する教科"],
      source_terms: ["高等学校学習指導要領（平成30年告示）解説 情報編", "第1部"],
      excluded_terms: [],
    },
    {
      name: "解説情報編第2部",
      prompt_terms: ["高等学校学習指導要領（平成30年告示）解説 情報編", "第2部", "主として専門学科において開設される教科"],
      source_terms: ["高等学校学習指導要領（平成30年告示）解説 情報編", "第2部"],
      excluded_terms: [],
    },
  ]
  information_source_indexes = (16..18).map do |question_number|
    question = exam_questions[question_number - 1]
    question_text = question.content_blocks.map { |block| block["text"].to_s }.join("\n")
    source_text = question.source_text.to_s
    source_index = information_source_ranges.find_index do |requirements|
      requirements[:prompt_terms].all? { |term| question_text.include?(term) } &&
        requirements[:source_terms].all? { |term| source_text.include?(term) } &&
        requirements[:excluded_terms].none? { |term| question_text.include?(term) || source_text.include?(term) }
    end
    unless source_index
      raise "模擬試験#{exam_number}の問#{question_number}は情報科の指定4範囲のいずれかから出題してください"
    end

    source_index
  end
  unless information_source_indexes.uniq.size == 3
    raise "模擬試験#{exam_number}の問16から問18は情報科の指定4範囲から異なる3範囲を選んでください"
  end
  unless information_source_indexes == information_source_indexes.sort
    raise "模擬試験#{exam_number}の問16から問18は学習指導要領、解説情報編の項目順に並べてください"
  end

  exam_questions.each do |question|
    source_lines = question.source_text.to_s.lines.map(&:strip).reject(&:blank?)
    unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
      raise "模擬試験#{exam_number} 問#{question.question_number}の出典リンク形式が不正です"
    end

    unless question.content_blocks.any? && question.explanation_blocks.any?
      raise "模擬試験#{exam_number} 問#{question.question_number}の問題文または解説が空です"
    end

    question.content_blocks.select { |block| block["type"] == "fill_in_text" }.each do |block|
      prompt = block["text"].to_s
      unless prompt.match?(standard_fill_in_prompt_pattern) ||
          prompt.match?(based_on_fill_in_prompt_pattern) ||
          prompt.match?(student_guidance_prompt_pattern) ||
          [school_education_act_prompt, education_personnel_act_prompt, local_public_service_act_prompt].include?(prompt)
        raise "模擬試験#{exam_number} 問#{question.question_number}の抜粋穴埋め問題の体裁が不正です"
      end
    end

    blank_labels = question.content_blocks
      .select { |block| block["type"] == "fill_in_quote" }
      .flat_map { |block| block["text"].to_s.scan(/\{\{([①②③④⑤])\}\}/).flatten }
      .uniq

    if blank_labels.any?
      question.question_choices.each do |choice|
        fill_in_blocks = choice.content_blocks.select { |block| block["type"] == "fill_in_choice" }
        unless fill_in_blocks.one? && fill_in_blocks.first["cells"].to_a.size == blank_labels.size
          raise "模擬試験#{exam_number} 問#{question.question_number}の空欄数と選択肢セル数が一致しません"
        end
      end
    end

    unless question.question_choices.size == 4 && question.question_choices.count(&:is_correct?) == 1
      raise "模擬試験#{exam_number} 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end

  correct_label_counts = exam_questions.map do |question|
    question.question_choices.find(&:is_correct?).choice_label
  end.tally

  unless correct_label_counts == { "ア" => 5, "イ" => 5, "ウ" => 5, "エ" => 5 }
    raise "模擬試験#{exam_number}の正答位置はア・イ・ウ・エを各5問にしてください"
  end
end

all_mock_questions = Question.where(exam_number: 1..5).includes(:question_choices).order(:exam_number, :question_number).to_a

unless all_mock_questions.count { |question| question.question_number == 3 && question.content_blocks.any? { |block| block["type"] == "fill_in_text" } } == 2
  raise "模擬試験1〜5の問3は穴埋め2問、正誤3問にしてください"
end

question_3_non_fill_texts = all_mock_questions
  .select { |question| question.question_number == 3 && question.content_blocks.none? { |block| block["type"] == "fill_in_text" } }
  .map { |question| question.content_blocks.map { |block| block["text"].to_s }.join("\n") }
unless question_3_non_fill_texts.count { |text| text.include?("適切でないもの") } == 1 &&
    question_3_non_fill_texts.count { |text| text.include?("正しいものを") } == 1 &&
    question_3_non_fill_texts.count { |text| text.include?("正しいものはいくつあるか") } == 1
  raise "模擬試験1〜5の問3の正誤問題はR6型・R7型・R8型を各1問にしてください"
end

question_5_prompts = all_mock_questions.select { |question| question.question_number == 5 }.map do |question|
  question.content_blocks.find { |block| block["type"] == "fill_in_text" }.to_h["text"].to_s
end
unless question_5_prompts.count(education_personnel_act_prompt) == 4 && question_5_prompts.count(local_public_service_act_prompt) == 1
  raise "模擬試験1〜5の問5は教育公務員特例法4問、地方公務員法1問にしてください"
end

question_11s = all_mock_questions.select { |question| question.question_number == 11 }
unless question_11s.count { |question| question.content_blocks.any? { |block| block["type"] == "fill_in_text" } } == 4 &&
    question_11s.count { |question| question.content_blocks.any? { |block| block["type"] == "table" } } == 1
  raise "模擬試験1〜5の問11は抜粋穴埋め4問、原典表問題1問にしてください"
end

question_11s.each do |question|
  excerpt_text = question.content_blocks
    .select { |block| block["type"] == "fill_in_quote" }
    .map { |block| block["text"].to_s }
    .join("\n")
  if excerpt_text.length < 140
    raise "模擬試験#{question.exam_number}の問11は原文の文脈を含む長めの抜粋にしてください"
  end

  blank_labels = excerpt_text.scan(/\{\{([①②③])\}\}/).flatten.uniq
  if blank_labels.empty?
    table_text = question.content_blocks
      .select { |block| block["type"] == "table" }
      .flat_map { |block| block["rows"].to_a.flatten }
      .join("\n")
    blank_labels = table_text.scan(/[①②③]/).uniq
  end
  unless (2..3).cover?(blank_labels.size)
    raise "模擬試験#{question.exam_number}の問11の空欄は2個又は3個にしてください"
  end
end

unless all_mock_questions.count { |question| question.question_number == 15 && question.content_blocks.any? { |block| block["type"] == "fill_in_text" } } == 1
  raise "模擬試験1〜5の問15は正誤4問、穴埋め1問にしてください"
end

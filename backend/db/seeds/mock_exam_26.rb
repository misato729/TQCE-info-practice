text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験26（承認済み問3〜5。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "「教育基本法」（平成18年法律第120号）第2条に掲げる教育の目標について述べたものとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "幅広い知識と教養を身に付け，真理を求める態度を養うことに加え，高い教養と専門的能力を培い，新たな知見を創造することを，教育の目標として掲げている。"),
      text_choice.call("イ", "職業及び生活との関連を重視し，勤労を重んずる態度を養うことを掲げている。また，正義と責任，男女の平等，自他の敬愛と協力を重んじ，公共の精神に基づき，主体的に社会の形成に参画する態度を養うことを掲げている。", true),
      text_choice.call("ウ", "伝統と文化を尊重し，我が国と郷土を愛するとともに，他国を尊重することを掲げている。また，各個人の能力を伸ばしつつ社会において自立的に生きる基礎を培うことを，同条の目標として掲げている。"),
      text_choice.call("エ", "生命を尊び，自然を大切にし，環境の保全に寄与する態度を養うことを掲げている。また，人格の完成を目指し，平和で民主的な国家及び社会の形成者として必要な資質を備えた国民を育成することを，同条の目標として掲げている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：前半は第2条第1号と一致する。後半の「高い教養と専門的能力を培う」「新たな知見を創造する」は，第7条第1項が大学について定める内容であり，第2条に列挙された目標ではない。"),
      text_block.call("イ：第2条第2号の職業・生活との関連及び勤労，第3号の正義と責任等及び公共の精神に基づく社会への参画を正しく説明している。"),
      text_block.call("ウ：前半は第2条第5号の内容である。後半の「社会において自立的に生きる基礎を培う」は，第5条第2項が義務教育として行われる普通教育の目的を定めた語句であり，第2条の目標と取り違えている。"),
      text_block.call("エ：前半は第2条第4号の内容である。後半は第1条の教育の目的であり，第2条に列挙された目標と取り違えている。教育として重要かどうかではなく，設問が指定した第2条の規定との対応を判断する。"),
    ],
    source_text: "教育基本法・第1条，第2条，第5条第2項，第7条第1項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_1-At_2",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第71条\n\n{{①}}が設置する中学校及び高等学校においては、{{②}}の定めるところにより、{{③}}に準じて、中学校における教育と高等学校における教育を一貫して{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["同一の設置者","文部科学大臣","義務教育学校","施すものとする"]),
      fill_in_choice.call("イ", ["同一の市町村","都道府県の教育委員会","中等教育学校","施すことができる"]),
      fill_in_choice.call("ウ", ["同一の市町村","都道府県の教育委員会","義務教育学校","施すものとする"]),
      fill_in_choice.call("エ", ["同一の設置者","文部科学大臣","中等教育学校","施すことができる"], true),
    ],
    explanation_blocks: [
      text_block.call("第71条は、同一の設置者による中学校と高等学校で、文部科学大臣の定めるところにより、中等教育学校に準じた一貫教育を行うことができると定めている。設置者を市町村に限定する規定ではなく、国・地方公共団体・学校法人など、同一の設置者による学校が対象となる。"),
      text_block.call("ア：③は「中等教育学校」、④は「施すことができる」。義務教育学校に準じる規定ではなく、同一設置者の中学校・高等学校に一貫教育を一律に課す規定でもない。"),
      text_block.call("イ：①は「同一の設置者」、②は「文部科学大臣」。この条文の対象を同一市町村が設置する学校に限定する文言ではなく、定める主体も都道府県教育委員会ではない。同じ市町村が設置する学校では一貫教育を行えないという意味ではない。"),
      text_block.call("ウ：①〜④が全て原文と異なる。"),
      text_block.call("エ：四つの語句が全て原文と一致する。"),
    ],
    source_text: "学校教育法第71条（令和8年6月17日施行版） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_7-At_71\n学校教育法第2条（設置者に関する解説の根拠） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_1-At_2",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第11条　公立学校の校長の採用（現に校長の職以外の職に任命されている者を校長の職に任命する場合を含む。）並びに教員の採用（現に教員の職以外の職に任命されている者を教員の職に任命する場合を含む。以下この条において同じ。）及び昇任（採用に該当するものを除く。）は、{{①}}によるものとし、その{{①}}は、大学附置の学校にあつては当該大学の{{②}}が、大学附置の学校以外の公立学校（幼保連携型認定こども園を除く。）にあつてはその校長及び教員の任命権者である教育委員会の{{③}}が、大学附置の学校以外の公立学校（幼保連携型認定こども園に限る。）にあつてはその校長及び教員の任命権者である{{④}}が行う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["選考","学長","教育長","地方公共団体の長"], true),
      fill_in_choice.call("イ", ["選考","学長","教育委員","教育委員会の教育長"]),
      fill_in_choice.call("ウ", ["競争試験","教授会","教育長","教育委員会の教育長"]),
      fill_in_choice.call("エ", ["競争試験","教授会","教育委員","地方公共団体の長"]),
    ],
    explanation_blocks: [
      text_block.call("ア：4語句が原文と一致する。公立学校の校長の採用、教員の採用及び昇任は選考による。大学附置の学校では大学の学長、それ以外の公立学校では教育委員会の教育長、幼保連携型認定こども園では地方公共団体の長が、その選考を行う。"),
      text_block.call("イ：①②は正しいが、③は個々の教育委員ではなく「教育長」、④は「地方公共団体の長」である。公立学校の選考主体と、公立の幼保連携型認定こども園の選考主体を区別する。"),
      text_block.call("ウ：③は正しいが、①は「選考」、②は「学長」、④は「地方公共団体の長」。大学附置の学校の選考主体を教授会へ置き換えている点も誤りである。"),
      text_block.call("エ：④は正しいが、①は「選考」、②は「学長」、③は「教育長」である。採用・昇任の方法と、それを行う主体の対応を押さえる。"),
    ],
    source_text: "教育公務員特例法・第11条 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_2-Se_2-At_11",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [3, 4, 5]
  raise "承認済みの問番号は3〜5です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == "education_system"
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  if number >= 4 || choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } }
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt = blocks.first
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = number >= 4 ? prompt.fetch(:text).include?("空欄 ① ～ ④") : prompt_labels == %w[① ④]
    unless labels == %w[① ② ③ ④] && prompt[:type] == "fill_in_text" && introduction_labels_match &&
        quotes.any? && quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
      raise "問#{number}の条番号・空欄と選択肢の対応が不正です"
    end
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 部分seedはdraftで保存するが、追加した承認済み問題の内容は公開時と同じ品質で検査する。
  entry = { exam_number: 26, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(26, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 26, questions: questions, publication_status: "draft")

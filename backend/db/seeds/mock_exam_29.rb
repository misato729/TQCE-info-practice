text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験29（承認済み問3〜5。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第17条 教育振興基本計画」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第17条　{{①}}は、教育の振興に関する施策の総合的かつ計画的な推進を図るため、教育の振興に関する施策についての基本的な方針及び講ずべき施策その他必要な事項について、基本的な計画を定め、これを{{②}}に報告するとともに、公表しなければならない。\n\n２　地方公共団体は、前項の計画を{{③}}し、その地域の実情に応じ、当該地方公共団体における教育の振興のための施策に関する基本的な計画を{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["政府","国会","参酌","定めるよう努めなければならない"], true),
      fill_in_choice.call("イ", ["文部科学大臣","内閣","参酌","定めるよう努めなければならない"]),
      fill_in_choice.call("ウ", ["政府","国会","踏襲","定めなければならない"]),
      fill_in_choice.call("エ", ["文部科学大臣","内閣","踏襲","定めなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。政府には基本的な計画の策定・国会への報告・公表が義務付けられる。一方，地方公共団体は政府の計画を「参酌」し，地域の実情に応じた計画を定めるよう努めるものとされる。"),
      text_block.call("イ：③④は一致する。①は「政府」，②は「国会」である。文部科学大臣が定めて内閣に報告するという規定ではない。"),
      text_block.call("ウ：①②は一致する。③は「参酌」，④は「定めるよう努めなければならない」である。参酌は政府の計画を考慮に入れることであり，それをそのまま踏襲するという表現と区別する。また，地方公共団体については努力義務である。"),
      text_block.call("エ：①〜④の全てが原文と異なる。政府と地方公共団体の計画について，策定主体・報告先・計画間の関係・義務の強さを区別する。"),
    ],
    source_text: "教育基本法・第17条第1項，第2項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_3-At_17",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第37条第7項・第8項\n\n教頭は、校長（副校長を置く小学校にあつては、校長及び副校長）を助け、{{①}}、及び{{②}}児童の教育をつかさどる。\n\n８　教頭は、校長（副校長を置く小学校にあつては、校長及び副校長）に事故があるときは{{③}}、校長（副校長を置く小学校にあつては、校長及び副校長）が欠けたときは{{④}}。この場合において、教頭が二人以上あるときは、あらかじめ校長が定めた順序で、{{③}}、又は行う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["校務を整理し","必要に応じ","校長の職務を補佐し","校長の職務を代理する"]),
      fill_in_choice.call("イ", ["命を受けて校務をつかさどり","常時","校長の職務を代理し","校長の職務を行う"]),
      fill_in_choice.call("ウ", ["校務を整理し","必要に応じ","校長の職務を代理し","校長の職務を行う"], true),
      fill_in_choice.call("エ", ["命を受けて校務をつかさどり","常時","校長の職務を補佐し","校長の職務を代理する"]),
    ],
    explanation_blocks: [
      text_block.call("教頭は「校務を整理し」、必要に応じて児童の教育をつかさどる。「命を受けて校務をつかさどる」は第5項で定める副校長の職務との区別が必要である。また、校長等に事故があるときは校長の職務を代理し、欠けたときは校長の職務を行う。"),
      text_block.call("ア：③は「校長の職務を代理し」、④は「校長の職務を行う」。事故がある場合を単なる補佐とし、欠けた場合を代理としている点が原文と異なる。"),
      text_block.call("イ：①は「校務を整理し」、②は「必要に応じ」。教頭の職務を副校長の職務に置き換え、児童の教育をつかさどる条件も変更している。"),
      text_block.call("ウ：四つの語句が全て原文と一致する。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第37条第7項・第8項は第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法第37条第5項・第7項・第8項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_37\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：「主幹教諭等」は、公立の小学校等の主幹教諭、指導教諭、主務教諭、教諭、養護教諭、栄養教諭、主幹保育教諭、指導保育教諭、主務保育教諭、保育教諭又は講師を指す。「大学院の課程等」は、大学（短期大学を除く。）の大学院の課程若しくは専攻科の課程又はこれらに相当する外国の大学の課程を指す。" },
      { type: "fill_in_quote", text: "第26条第2項　大学院修学休業の許可を受けようとする主幹教諭等は、取得しようとする{{①}}の種類、{{②}}及び{{③}}を明らかにして、{{④}}に対し、その許可を申請するものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["専修免許状","在学しようとする大学院の課程等","大学院修学休業をしようとする期間","本属長"]),
      fill_in_choice.call("イ", ["専修免許状","在学しようとする大学院の課程等","大学院修学休業をしようとする期間","任命権者"], true),
      fill_in_choice.call("ウ", ["一種免許状","大学院修学休業に至るまでの研修の経過","教員として在職した期間","任命権者"]),
      fill_in_choice.call("エ", ["一種免許状","大学院修学休業に至るまでの研修の経過","教員として在職した期間","本属長"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①〜③は正しいが、申請先は④「任命権者」であり「本属長」ではない。第22条第2項の、勤務場所を離れて研修を行う際の本属長の承認と区別する。"),
      text_block.call("イ：4語句が原文と一致する。取得を目指す専修免許状の種類、在学予定の課程、休業予定の期間を明らかにして、任命権者へ許可を申請する。"),
      text_block.call("ウ：④は正しいが、①は「専修免許状」、②は「在学しようとする大学院の課程等」、③は「大学院修学休業をしようとする期間」である。休業開始前の研修歴や在職期間を、この項が申請時に明らかにする事項として挙げているわけではない。"),
      text_block.call("エ：4語句が原文と異なる。取得を目指す免許状、申請で示す課程と期間、許可の申請先をいずれも取り違えている。"),
    ],
    source_text: "教育公務員特例法・第26条第2項、第26条第1項（用語の補足）、第22条第2項（比較） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_5-At_26",
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
  entry = { exam_number: 29, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(29, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 29, questions: questions, publication_status: "draft")

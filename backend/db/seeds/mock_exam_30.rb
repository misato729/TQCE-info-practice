text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験30（承認済み問3〜5。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次の①～④は，「教育基本法」（平成18年法律第120号）に関する記述である。正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "①　法律に定める学校では，教育を受ける者の心身の発達に応じ，体系的な教育を組織的に行わなければならない。その際，学校生活に必要な規律を重んずることと，自ら進んで学習に取り組む意欲を高めることを，ともに重視するものとされている。" },
      { type: "fill_in_quote", text: "②　国及び地方公共団体が設置する学校では，特定の宗教のための宗教教育その他宗教的活動をしてはならない。一方，宗教に関する寛容の態度，一般的な教養及び宗教の社会生活における地位は，教育上尊重されなければならない。" },
      { type: "fill_in_quote", text: "③　私立学校は，公の性質と学校教育における重要な役割を有するが，その自主性も尊重される。このため，特定の政党を支持し，又はこれに反対するための政治教育その他政治的活動については，その自主性に基づいて行うことが認められている。" },
      { type: "fill_in_quote", text: "④　法律に定める学校の教員については，その使命と職責の重要性にかんがみ，身分の尊重及び待遇の適正が確保されていることを要件として，養成と研修の充実を図ることが定められている。教員自身が研究と修養に励み，職責の遂行に努めることも定められている。" },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("①：正しい。第6条第2項の体系的・組織的な教育と，規律及び自発的な学習意欲の重視に一致する。"),
      text_block.call("②：正しい。第15条第2項の国公立学校における特定宗教のための宗教教育等の禁止と，第1項の宗教に関する寛容の態度，一般的な教養及び社会生活における地位の尊重に一致する。"),
      text_block.call("③：誤り。第8条による私立学校の自主性の尊重は，第14条第2項の政治教育等の禁止の例外を定めるものではない。第14条第2項の対象は「法律に定める学校」であり，私立学校も含まれる。"),
      text_block.call("④：誤り。第9条第2項は，使命と職責の重要性にかんがみ，身分の尊重・待遇の適正と，養成・研修の充実を併せて定めている。前者の確保を後者の法的要件とする規定ではない。後半の教員自身の研究・修養と職責の遂行は，第1項と一致する。"),
      text_block.call("正しいものは①②の二つなのでイが正答である。アは正しい記述を一つ多く，ウは一つ少なく数えている。エの「なし」でもない。"),
    ],
    source_text: "教育基本法・第6条第2項，第8条，第9条，第14条第2項，第15条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_14",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第43条\n\n小学校は、当該小学校に関する保護者及び地域住民その他の関係者の{{①}}を深めるとともに、これらの者との{{②}}の推進に資するため、当該小学校の{{③}}に関する情報を{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["理解","連携及び協力","教育活動その他の学校運営の状況","積極的に提供するものとする"], true),
      fill_in_choice.call("イ", ["理解","連携及び協力","教育課程の編成及び実施の状況","求めに応じて提供するものとする"]),
      fill_in_choice.call("ウ", ["認識","協議及び調整","教育活動その他の学校運営の状況","積極的に提供するものとする"]),
      fill_in_choice.call("エ", ["認識","協議及び調整","教育課程の編成及び実施の状況","求めに応じて提供するものとする"]),
    ],
    explanation_blocks: [
      text_block.call("第43条は、保護者・地域住民等の理解を深め、連携及び協力を進めるために、教育活動その他の学校運営の状況に関する情報を積極的に提供することを定める。教育課程に関する情報だけを、求められたときに提供するという規定ではない。"),
      text_block.call("ア：四つの語句が全て原文と一致する。"),
      text_block.call("イ：③は「教育活動その他の学校運営の状況」、④は「積極的に提供するものとする」。情報の対象を教育課程の編成・実施へ狭め、提供のあり方も求めに応じる形へ変更している。"),
      text_block.call("ウ：①は「理解」、②は「連携及び協力」。関係者との協議・調整が実践として不要という意味ではなく、この条文の目的として明記される語句が異なる。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第43条は第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法第43条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_43\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語・参照先の補足（抜粋枠外）：「研修実施者実施研修」は、研修実施者が実施する初任者研修、中堅教諭等資質向上研修その他の研修を指す。第26条第1項は、大学院等の課程に在学して履修するための休業とその許可の要件に関する規定である。「大学院の課程等」は、大学（短期大学を除く。）の大学院の課程若しくは専攻科の課程又はこれらに相当する外国の大学の課程を指す。" },
      { type: "fill_in_quote", text: "第22条の5　公立の小学校等の校長及び教員の任命権者は、文部科学省令で定めるところにより、当該校長及び教員ごとに、研修の受講その他の当該校長及び教員の資質の向上のための取組の状況に関する記録（以下この条及び次条第二項において「研修等に関する記録」という。）を作成しなければならない。\n\n２　研修等に関する記録には、次に掲げる事項を記載するものとする。\n\n一　当該校長及び教員が{{①}}研修実施者実施研修に関する事項\n\n二　第二十六条第一項に規定する{{②}}により当該教員が履修した同項に規定する大学院の課程等に関する事項\n\n三　認定講習等（教育職員免許法（昭和二十四年法律第百四十七号）別表第三備考第六号の文部科学大臣の認定する講習又は通信教育をいう。次条第一項及び第三項において同じ。）のうち{{③}}ものであつて、当該校長及び教員が単位を修得したものに関する事項\n\n四　前三号に掲げるもののほか、当該校長及び教員が行つた資質の向上のための取組のうち{{④}}ものに関する事項" },
    ],
    choices: [
      fill_in_choice.call("ア", ["受講した","大学院修学休業","文部科学大臣が開設した","当該校長及び教員が必要と認める"]),
      fill_in_choice.call("イ", ["受講を申し込んだ","現職のままで受ける長期研修","当該任命権者が開設した","当該校長及び教員が必要と認める"]),
      fill_in_choice.call("ウ", ["受講を申し込んだ","現職のままで受ける長期研修","文部科学大臣が開設した","当該任命権者が必要と認める"]),
      fill_in_choice.call("エ", ["受講した","大学院修学休業","当該任命権者が開設した","当該任命権者が必要と認める"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが、③は「当該任命権者が開設した」、④は「当該任命権者が必要と認める」。認定講習等を認定する文部科学大臣と、この号で記録対象となる講習等の開設者を取り違えている。その他の取組を必要と認める主体も、校長・教員本人ではなく任命権者である。"),
      text_block.call("イ：③は正しいが、①は実際に「受講した」研修、②は「大学院修学休業」、④は「当該任命権者が必要と認める」。申込みの段階を受講した状態と同一に扱い、現職のまま受ける長期研修を別に定められた休業と混同している。"),
      text_block.call("ウ：④は正しいが、①は「受講した」、②は「大学院修学休業」、③は「当該任命権者が開設した」である。認定する者と開設する者の区別にも注意する。"),
      text_block.call("エ：4語句が原文と一致する。記録する事項には、受講した所定の研修、大学院修学休業で履修した課程、任命権者が開設し単位を修得した認定講習等、その他任命権者が必要と認める資質向上の取組が含まれる。"),
    ],
    source_text: "教育公務員特例法・第22条の5第1項〜第2項、第22条の4第2項第1号・第26条第1項（補足）、第22条第3項（比較） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22_5",
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
  entry = { exam_number: 30, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(30, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 30, questions: questions, publication_status: "draft")

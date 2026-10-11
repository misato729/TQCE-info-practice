text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験27（承認済み問3〜5。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第5条 義務教育」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第5条　国民は、その保護する子に、別に法律で定めるところにより、{{①}}を受けさせる義務を負う。\n\n２　義務教育として行われる{{①}}は、各個人の有する能力を伸ばしつつ社会において{{②}}生きる基礎を培い、また、国家及び社会の形成者として必要とされる基本的な資質を養うことを目的として行われるものとする。\n\n３　国及び地方公共団体は、義務教育の機会を保障し、その水準を確保するため、適切な役割分担及び相互の協力の下、その{{③}}に責任を負う。\n\n４　国又は地方公共団体の設置する学校における義務教育については、{{④}}を徴収しない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["普通教育","主体的に","普及","授業料"]),
      fill_in_choice.call("イ", ["高等普通教育","自立的に","普及","入学料"]),
      fill_in_choice.call("ウ", ["高等普通教育","主体的に","実施","入学料"]),
      fill_in_choice.call("エ", ["普通教育","自立的に","実施","授業料"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は一致する。②は「自立的に」，③は「実施」である。義務教育の目的として自立的に生きる基礎を培い，国及び地方公共団体は義務教育の実施に責任を負うと定めている。"),
      text_block.call("イ：②は一致する。①は「普通教育」，③は「実施」，④は「授業料」である。第5条が国民に受けさせる義務を課すのは普通教育であり，第4項が徴収しないと明記しているのは授業料である。"),
      text_block.call("ウ：③は一致する。①は「普通教育」，②は「自立的に」，④は「授業料」である。"),
      text_block.call("エ：四つとも原文と一致する。①は第1項と第2項に共通し，教育基本法第5条の語句は「普通教育」である。第4項の「授業料」を，教育に必要な費用一般が全て無償となる意味へ広げない。"),
    ],
    source_text: "教育基本法・第5条第1項〜第4項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_5",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第34条\n\n小学校においては、文部科学大臣の検定を経た教科用図書又は文部科学省が著作の名義を有する教科用図書を使用しなければならない。\n\n２　前項に規定する教科用図書（以下この条において「教科用図書」という。）の内容を文部科学大臣の定めるところにより記録した電磁的記録（電子的方式、磁気的方式その他人の知覚によつては認識することができない方式で作られる記録であつて、電子計算機による情報処理の用に供されるものをいう。）である教材がある場合には、同項の規定にかかわらず、文部科学大臣の定めるところにより、児童の教育の充実を図るため必要があると認められる{{①}}において、教科用図書に代えて当該教材を使用することができる。\n\n３　前項に規定する場合において、視覚障害、発達障害その他の文部科学大臣の定める事由により教科用図書を使用して学習することが困難な児童に対し、教科用図書に用いられた{{②}}その他の同項に規定する教材を電子計算機において用いることにより可能となる方法で指導することにより当該児童の学習上の困難の程度を{{③}}させる必要があると認められるときは、文部科学大臣の定めるところにより、{{④}}において、教科用図書に代えて当該教材を使用することができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育課程の一部","文字、図形等の拡大又は音声への変換","低減","教育課程の全部又は一部"], true),
      fill_in_choice.call("イ", ["教育課程の一部","文字、図形等の削減又は学習内容の簡素化","軽減","教育課程の全部又は一部"]),
      fill_in_choice.call("ウ", ["教育課程の全部又は一部","文字、図形等の拡大又は音声への変換","低減","教育課程の一部"]),
      fill_in_choice.call("エ", ["教育課程の全部又は一部","文字、図形等の削減又は学習内容の簡素化","軽減","教育課程の一部"]),
    ],
    explanation_blocks: [
      text_block.call("第2項の一般的な取扱いは「教育課程の一部」である。第3項は、教科用図書を使用して学習することが困難な児童について、拡大や音声への変換等で困難の程度を低減させる必要があると認められる場合に、「教育課程の全部又は一部」で代替教材を使用できると定める。学習内容を削減・簡素化することを定めた規定ではない。「軽減」は意味の近い語だが、原文の語句は「低減」である。"),
      text_block.call("ア：四つの語句が全て原文と一致する。"),
      text_block.call("イ：②は「文字、図形等の拡大又は音声への変換」、③は「低減」。教材へのアクセス方法の変更を、学習内容の削減・簡素化へ置き換えている。③は意味の近い「軽減」ではなく、原文の「低減」を入れる。"),
      text_block.call("ウ：①は「教育課程の一部」、④は「教育課程の全部又は一部」。一般の場合と、学習上の困難に対応する場合の適用範囲を逆にしている。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第34条は第62条により高等学校にも準用される。抜粋は準用元の原文なので「小学校」「児童」の表記を維持している。"),
    ],
    source_text: "学校教育法第34条第1〜3項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_34\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：「指標」は、校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する指標を指す。" },
      { type: "fill_in_quote", text: "第22条の7　公立の小学校等の校長及び教員の{{①}}は、指標の策定に関する協議並びに当該指標に基づく当該校長及び教員の資質の向上に関して必要な事項についての協議を行うための{{②}}（以下この条において「{{②}}」という。）を組織するものとする。\n\n２　{{②}}は、次に掲げる者をもつて構成する。\n\n一　指標を策定する{{①}}\n\n二　公立の小学校等の校長及び教員の研修に協力する大学その他の当該校長及び教員の資質の向上に関係する大学として{{③}}で定める者\n\n三　その他当該{{①}}が必要と認める者\n\n３　{{②}}において協議が調つた事項については、{{②}}の構成員は、その協議の結果を{{④}}。\n\n４　前三項に定めるもののほか、{{②}}の運営に関し必要な事項は、{{②}}が定める。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者","審議会","文部科学省令","遵守しなければならない"]),
      fill_in_choice.call("イ", ["任命権者","協議会","文部科学省令","尊重しなければならない"], true),
      fill_in_choice.call("ウ", ["研修実施者","審議会","政令","尊重しなければならない"]),
      fill_in_choice.call("エ", ["研修実施者","協議会","政令","遵守しなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は正しいが、②は「協議会」、④は「尊重しなければならない」。第3項が定めるのは協議の結果を尊重する義務であり、原文を「遵守」へ強めて置き換えることはできない。"),
      text_block.call("イ：4語句が原文と一致する。任命権者が協議会を組織し、その任命権者、所定の大学、その他必要と認める者で構成する。協議が調つた事項の結果は構成員が尊重し、運営に関する事項は協議会自身が定める。"),
      text_block.call("ウ：④は正しいが、①は「任命権者」、②は「協議会」、③は「文部科学省令」。研修を実施する役割と、指標の策定などを協議する組織を設ける役割を取り違えている。"),
      text_block.call("エ：②は正しいが、①は「任命権者」、③は「文部科学省令」、④は「尊重しなければならない」である。"),
    ],
    source_text: "教育公務員特例法・第22条の7、第22条の3第1項（補足） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22_7",
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
  entry = { exam_number: 27, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(27, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 27, questions: questions, publication_status: "draft")

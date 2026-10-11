text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験28（承認済み問3〜5。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，適切でないものを一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "国及び地方公共団体は，障害のある者がその障害の状態に応じて十分な教育を受けられるよう，教育上必要な支援を講じなければならない。また，能力があるにもかかわらず経済的理由で修学が困難な者に対し，奨学の措置を講じなければならない。"),
      text_choice.call("イ", "国及び地方公共団体は，家庭教育の自主性を尊重しつつ，保護者への学習機会や情報の提供などの支援施策を講ずるよう努めることとされている。また，幼児期の教育について，幼児の健やかな成長に資する良好な環境の整備などによって振興に努めることとされている。"),
      text_choice.call("ウ", "私立学校の有する公の性質と学校教育における重要な役割を踏まえ，その自主性を尊重しつつ，助成その他の適当な方法によって私立学校教育の振興に努めることが定められている。同法がこの義務を課している主体は，私立学校の設置者である。", true),
      text_choice.call("エ", "個人の要望や社会の要請にこたえ，社会において行われる教育は，国及び地方公共団体によって奨励されることとされている。その振興方法として，図書館，博物館及び公民館等の設置，学校の施設の利用，学習の機会及び情報の提供などが挙げられている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。第4条第2項の障害の状態に応じた教育上必要な支援と，第3項の奨学の措置について，主体・対象・義務を正しく説明している。"),
      text_block.call("イ：適切。前半は第10条第2項，後半は第11条の内容である。家庭教育の自主性を尊重すること，保護者への学習機会や情報の提供，幼児期の教育を振興するための環境整備を区別する。"),
      text_block.call("ウ：不適切。第8条で私立学校教育の振興に努める義務を課されている主体は「国及び地方公共団体」であり，「私立学校の設置者」ではない。公の性質，重要な役割，自主性の尊重及び助成等の方法という要素は正しく，義務主体を取り違えている。"),
      text_block.call("エ：適切。第12条第1項は社会教育の奨励を，第2項はその振興の努力義務と方法を定めている。学校の施設の利用も，社会教育の振興方法として含まれる。"),
    ],
    source_text: "教育基本法・第4条，第8条，第10条第2項，第11条，第12条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_8",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第54条第1項・第2項\n\n高等学校には、{{①}}のほか、{{②}}の課程を置くことができる。\n\n２　高等学校には、{{②}}の課程のみを置くことができる。" },
      { type: "fill_in_quote", text: "第59条\n\n高等学校に関する{{③}}その他必要な事項は、{{④}}が、これを定める。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["全日制の課程及び定時制の課程","単位制","入学、退学、転学","文部科学大臣"]),
      fill_in_choice.call("イ", ["全日制の課程又は定時制の課程","通信制","入学、退学、転学","文部科学大臣"], true),
      fill_in_choice.call("ウ", ["全日制の課程又は定時制の課程","通信制","入学、休学、留学","都道府県の教育委員会"]),
      fill_in_choice.call("エ", ["全日制の課程及び定時制の課程","単位制","入学、休学、留学","都道府県の教育委員会"]),
    ],
    explanation_blocks: [
      text_block.call("第54条は、全日制又は定時制の課程のほかに通信制の課程を置くことができ、通信制の課程だけを置くこともできると定める。第59条に列挙される事項は「入学、退学、転学」であり、これらの必要な事項を定める主体は文部科学大臣である。"),
      text_block.call("ア：①は「全日制の課程又は定時制の課程」、②は「通信制」。全日制と定時制の双方が必要という文言ではなく、単位制を課程の種類として加える規定でもない。"),
      text_block.call("イ：四つの語句が全て原文と一致する。"),
      text_block.call("ウ：③は「入学、退学、転学」、④は「文部科学大臣」。この条文で明示的に列挙する語句と、それらに関する必要事項を定める主体が異なる。休学や留学が学校制度上存在しないという意味ではない。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
    ],
    source_text: "学校教育法第54条第1項・第2項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_54\n学校教育法第59条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_59",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第39条　職員には、その{{①}}のために、研修を受ける機会が与えられなければならない。\n\n２　前項の研修は、{{②}}が行うものとする。\n\n３　{{③}}は、研修の目標、研修に関する計画の指針となるべき事項その他研修に関する基本的な方針を定めるものとする。\n\n４　{{④}}は、研修に関する計画の立案その他研修の方法について{{②}}に勧告することができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["勤務能率の発揮及び増進","任命権者","任命権者","教育委員会"]),
      fill_in_choice.call("イ", ["職務上の義務の履行","地方公共団体","地方公共団体","教育委員会"]),
      fill_in_choice.call("ウ", ["職務上の義務の履行","地方公共団体","任命権者","人事委員会"]),
      fill_in_choice.call("エ", ["勤務能率の発揮及び増進","任命権者","地方公共団体","人事委員会"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが、研修に関する基本的な方針を定める主体は③「地方公共団体」、研修の方法について任命権者へ勧告できる主体は④「人事委員会」である。"),
      text_block.call("イ：③は正しいが、①は「勤務能率の発揮及び増進」、②は「任命権者」、④は「人事委員会」。職務上の義務の履行は地方公務員の服務に関する論点だが、この条文の研修目的を示す語句ではない。"),
      text_block.call("ウ：④は正しいが、①は「勤務能率の発揮及び増進」、②は「任命権者」、③は「地方公共団体」。研修の実施主体と基本方針の策定主体を逆にしている。"),
      text_block.call("エ：4語句が原文と一致する。任命権者が研修を実施し、地方公共団体が基本方針を定め、人事委員会が計画の立案や方法について任命権者へ勧告できる。"),
    ],
    source_text: "地方公務員法・第39条第1項〜第4項 | https://laws.e-gov.go.jp/law/325AC0000000261/20250601_504AC0000000068#Mp-Ch_3-Se_7-At_39",
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
  entry = { exam_number: 28, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(28, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 28, questions: questions, publication_status: "draft")

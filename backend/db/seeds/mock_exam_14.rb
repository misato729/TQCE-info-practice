text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

fill_in_choice = lambda do |label, cells, correct = false|
  {
    label: label,
    content_blocks: [{ type: "fill_in_choice", cells: cells }],
    correct: correct,
  }
end

# 模擬試験14（作成中：問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の①～④は，我が国の女子教育に関する出来事である。年代の古いものから順に配列したものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。\n\n①　文部省は東京に官立の女学校を設置することを布達した。同校は翌年開校し，後に東京女学校と改称された。\n\n②　東京女子師範学校に附属高等女学校が創設され，その後の女子中等教育機関の一つの模範となった。\n\n③　高等女学校令が公布され，女子に高等普通教育を施す中等教育機関として，高等女学校が制度上整備された。\n\n④　旧教育基本法において，男女は互いに敬重し協力しなければならず，教育上の男女共学は認められなければならないと定められた。"),
    ],
    choices: [
      text_choice.call("ア", "① → ② → ③ → ④", true),
      text_choice.call("イ", "① → ③ → ② → ④"),
      text_choice.call("ウ", "② → ① → ③ → ④"),
      text_choice.call("エ", "① → ② → ④ → ③"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。①は1871（明治4）年12月の布達で，官立女学校は1872（明治5）年に開校し，東京女学校と改称されました。②の東京女子師範学校附属高等女学校は1882（明治15）年に創設されました。③の高等女学校令は1899（明治32）年に公布されました。④の旧教育基本法は1947（昭和22）年に制定されました。したがって，①→②→③→④となります。イは，高等女学校令を附属高等女学校の創設より前に置いています。ウは，1882年の出来事を1871年の出来事より前に置いています。エは，1947年の旧教育基本法を1899年の高等女学校令より前に置いています。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第一章第三節『三 明治初期の女子教育』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317595.htm
文部科学省『学制百年史 資料編』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317930.htm
文部科学省『昭和22年教育基本法制定時の条文』第5条 | https://www.mext.go.jp/b_menu/kihon/about/a001.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ケルシェンシュタイナーの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "労作学校の中心を職業で用いる手技能の熟達に置き，知的理解や共同生活における人格形成は，手作業の反復から生じる副次的な成果として位置付けた。"),
      text_choice.call("イ", "学習者が社会的な環境の中で自ら目的を定め，計画を立てて遂行する一連の活動を教授の中心に置くプロジェクト・メソッドを提唱した。"),
      text_choice.call("ウ", "ミュンヘン市の教育行政に携わり，補習学校の改革を進めた。労作を単なる手作業ではなく，身体的活動と精神的活動を結び付けて課題を完成する過程と捉え，公民としての責任感や人格を形成しようとした。", true),
      text_choice.call("エ", "学習課題の契約，教科別実験室及び生活集団を組み合わせ，学級で一斉に同じ内容を進める方式を改めて，学習者が自分の進度で学習する教育方法を構成した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，ケルシェンシュタイナーの労作学校を手技能の訓練に狭めている点が誤りです。労作学校では，課題の遂行を通して身体的活動と精神的活動を統合し，人格や公民性を形成することが重視されました。イはキルパトリックのプロジェクト・メソッドについての記述です。ウは，ケルシェンシュタイナーによるミュンヘンの補習学校改革と，労作学校及び公民教育の関係を正しく説明しています。エはパーカーストのドルトン・プランについての記述です。"),
    ],
    source_text: "国立国会図書館サーチ『労作学校の概念』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000001074366
京都大学学術情報リポジトリ『ケルシェンシュタイナーの公民教育論』 | https://repository.kulib.kyoto-u.ac.jp/dspace/bitstream/2433/266308/1/eda38_100.pdf
J-STAGE『労作学校思想の歴史的検討』 | https://www.jstage.jst.go.jp/article/joej/24/0/24_2021_0002/_pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第7条 大学」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第7条\n大学は、{{①}}として、{{②}}を培うとともに、深く真理を探究して{{③}}を創造し、これらの成果を広く社会に提供することにより、社会の発展に寄与するものとする。\n\n2　大学については、{{④}}その他の大学における教育及び研究の特性が尊重されなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["学術の中心", "高い教養と専門的能力", "新たな知見", "自主性、自律性"], true),
      fill_in_choice.call("イ", ["学術の中心", "幅広い知識と教養", "新たな知見", "自主性、公共性"]),
      fill_in_choice.call("ウ", ["専門教育の中心", "高い教養と専門的能力", "新たな文化", "自主性、自律性"]),
      fill_in_choice.call("エ", ["専門教育の中心", "幅広い知識と教養", "新たな文化", "自主性、公共性"]),
    ],
    explanation_blocks: [
      text_block.call("大学を「学術の中心」と位置付け，教育に加えて，新たな知見の創造と成果の社会への提供を規定している。また，第2項で明記されている特性は「自主性、自律性」である。"),
      text_block.call("イ：②は「高い教養と専門的能力」，④は「自主性、自律性」が正しい。"),
      text_block.call("ウ：①は「学術の中心」，③は「新たな知見」が正しい。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育基本法・第7条 | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第42条第1項\n小学校は、{{①}}の定めるところにより当該小学校の{{②}}その他の{{③}}の状況について評価を行い、その結果に基づき{{③}}の改善を図るため必要な措置を講ずることにより、その{{④}}の向上に努めなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["設置者", "教育活動", "学校運営", "教育水準"]),
      fill_in_choice.call("イ", ["文部科学大臣", "教育課程", "教育指導", "教育効果"]),
      fill_in_choice.call("ウ", ["文部科学大臣", "教育活動", "学校運営", "教育水準"], true),
      fill_in_choice.call("エ", ["設置者", "教育課程", "教育指導", "教育効果"]),
    ],
    explanation_blocks: [
      text_block.call("評価の対象は「教育活動その他の学校運営」の状況である。その結果を学校運営の改善に結び付け，「教育水準」の向上に努めることを規定している。"),
      text_block.call("ア：①は「文部科学大臣」が正しい。ここで定めているのは，学校が誰の定めるところにより評価を行うかという点である。"),
      text_block.call("イ：②は「教育活動」，③は「学校運営」，④は「教育水準」が正しい。評価対象を教育課程や教育指導へ置き換えている。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
      text_block.call("第42条は，第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第42条第1項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第29条第1項\n職員が次の各号のいずれかに該当する場合には、当該職員に対し、懲戒処分として戒告、{{①}}、{{②}}又は免職の処分をすることができる。\n\n一　この法律若しくは第五十七条に規定する特例を定めた法律又はこれらに基づく条例、地方公共団体の規則若しくは地方公共団体の機関の定める規程に違反した場合\n\n二　{{③}}に違反し、又は職務を怠つた場合\n\n三　{{④}}たるにふさわしくない非行のあつた場合",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["降給", "休職", "職務上の義務", "全体の奉仕者"]),
      fill_in_choice.call("イ", ["減給", "停職", "職務上の義務", "全体の奉仕者"], true),
      fill_in_choice.call("ウ", ["減給", "停職", "上司の職務上の命令", "地方公共団体の職員"]),
      fill_in_choice.call("エ", ["降給", "休職", "上司の職務上の命令", "地方公共団体の職員"]),
    ],
    explanation_blocks: [
      text_block.call("第29条が定める懲戒処分は「戒告・減給・停職・免職」である。処分事由には，職務上の義務違反や職務を怠った場合，全体の奉仕者としてふさわしくない非行があった場合などが含まれる。"),
      text_block.call("ア：①は「減給」，②は「停職」が正しい。「降給」「休職」は，第28条の分限に関する規定と区別する。"),
      text_block.call("ウ：③は「職務上の義務」，④は「全体の奉仕者」が正しい。第2号は，上司の命令に関する事柄だけを述べた規定ではない。"),
      text_block.call("エ：懲戒処分の種類と処分事由の両方を取り違えており，①〜④の全てが原文と異なる。"),
    ],
    source_text: "地方公務員法・第28条、第29条第1項 | https://laws.e-gov.go.jp/law/325AC0000000261",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験14の作成中データには承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  expected_category = question.fetch(:question_number) <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験14 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験14 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).one? { |block| block[:type] == "fill_in_choice" && block[:cells].size == blank_labels.size } }
      raise "模擬試験14 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験14 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験14 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

QuestionSeedSync.import(exam_number: 14, questions: questions, publication_status: "draft")

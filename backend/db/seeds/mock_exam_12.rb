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

# 模擬試験12（作成中：問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の私塾とそこで行われた教育について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "伊藤仁斎が京都に開いた古義堂では，古文辞学の立場から古代中国の言語や制度を研究し，その成果を政治の改革に結び付けることが重視された。"),
      text_choice.call("イ", "緒方洪庵が大坂に開いた適塾では，年齢・学歴・身分による差を設けない三奪法と，毎月の成績を公表する月旦評を用いて，門人同士の競争を促した。"),
      text_choice.call("ウ", "廣瀬淡窓が日田に開いた咸宜園では，年齢・学歴・身分による差を設けない三奪法，学業成績を評価する月旦評及び塾生に役割を分担させる職任の制などが採られた。", true),
      text_choice.call("エ", "本居宣長が松坂に開いた鈴屋では，蘭医学と蘭学を中心に教授し，福澤諭吉や大村益次郎など，幕末から明治期に活躍する人材を輩出した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，古義堂を開いた人物を伊藤仁斎としている点は適切ですが，仁斎が唱えたのは『論語』『孟子』を重視する古義学です。古文辞学を唱えたのは荻生徂徠です。イは，適塾を開いた人物を緒方洪庵としている点は適切ですが，三奪法と月旦評は咸宜園の制度です。適塾では蘭学・医学が教授され，福澤諭吉や大村益次郎らが学びました。ウは，咸宜園の三奪法，月旦評，職任の制を正しく説明しています。エは，鈴屋を開いた人物を本居宣長としている点は適切ですが，宣長は国学者であり，『古事記伝』などを著しました。蘭学・医学及び福澤諭吉，大村益次郎との対応は適塾です。"),
    ],
    source_text: "日田市咸宜園教育研究センター『咸宜園とは』 | https://www.city.hita.oita.jp/site/kangien/1736.html
大阪大学適塾記念センター『適塾』 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku
早稲田大学リポジトリ『伊藤仁斎と荻生徂徠の学問』 | https://waseda.repo.nii.ac.jp/record/3126/files/Tsuchida2_09410009.pdf",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ルソーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育の目的を，社会において有用な紳士の形成に置き，家庭教師による個別教育の下で，健康な身体，徳，知恵及び礼儀を習慣として身に付けさせることを重視した。"),
      text_choice.call("イ", "『エミール』において，子どもを小さな大人として扱わず，その自然な発達に即して教育することを主張した。消極教育は単なる放任ではなく，事物や経験から学べるよう環境を整え，時期尚早な知識や道徳の教え込みを控えるものであった。", true),
      text_choice.call("ウ", "教育を頭・心・手の諸力を調和的に発達させる営みと捉え，家庭的な共同生活と直観教授を基礎として，貧困状態にある子どもの教育に取り組んだ。"),
      text_choice.call("エ", "教育の究極目的を道徳的品性の形成に置き，既有の観念と新しい観念との結合を統覚によって説明するとともに，教授の段階を組織的に構成した。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アはロックの教育思想です。『教育論』では，家庭教師による紳士教育と，健康，徳，知恵，礼儀及び習慣形成が論じられました。イはルソーの教育思想を正しく説明しています。ルソーは『エミール』で子どもの発達に即した教育を説きました。消極教育は放任ではなく，発達に適した環境を用意し，経験を通じて学ばせる考え方です。ウはペスタロッチの教育思想です。頭・心・手の調和，直観教授及び家庭的な共同生活が対応します。エはヘルバルトの教育思想です。道徳的品性，統覚及び段階的な教授理論が対応します。"),
    ],
    source_text: "神戸大学学術成果リポジトリ『ルソーにおける消極教育』 | https://da.lib.kobe-u.ac.jp/da/kernel/81001379/81001379.pdf
国立国会図書館サーチ『エミール』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000002320860
立教大学図書館『ルソーと「エミール」』 | https://library.rikkyo.ac.jp/digitallibrary/jeanjacquesrousseau/contents/con_05.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第2条 教育の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第2条（第1号・第2号）\n\n一　幅広い知識と教養を身に付け、{{①}}を求める態度を養い、{{②}}を培うとともに、健やかな身体を養うこと。\n\n二　個人の価値を尊重して、その能力を伸ばし、創造性を培い、{{③}}の精神を養うとともに、{{④}}との関連を重視し、勤労を重んずる態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["真理", "豊かな人間性と創造性", "自主及び自律", "職業及び社会"]),
      fill_in_choice.call("イ", ["真実", "豊かな情操と道徳心", "自立及び協同", "職業及び生活"]),
      fill_in_choice.call("ウ", ["真実", "豊かな人間性と創造性", "自立及び協同", "職業及び社会"]),
      fill_in_choice.call("エ", ["真理", "豊かな情操と道徳心", "自主及び自律", "職業及び生活"], true),
    ],
    explanation_blocks: [
      text_block.call("第1号では「真理」を求める態度と「豊かな情操と道徳心」を，第2号では「自主及び自律」の精神と「職業及び生活」との関連を挙げている。"),
      text_block.call("ア：②は「豊かな情操と道徳心」，④は「職業及び生活」が正しい。"),
      text_block.call("イ：①は「真理」，③は「自主及び自律」が正しい。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育基本法・第2条第1号、第2号 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第37条第9項\n{{①}}は、校長（副校長を置く小学校にあつては、校長及び副校長）及び教頭を助け、命を受けて{{②}}を整理し、並びに児童の教育をつかさどる。\n\n第37条第10項\n{{③}}は、児童の教育をつかさどり、並びに教諭その他の職員に対して、教育指導の改善及び充実のために必要な{{④}}を行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["主幹教諭", "校務の一部", "指導教諭", "指導及び助言"], true),
      fill_in_choice.call("イ", ["指導教諭", "校務の一部", "主幹教諭", "指導及び助言"]),
      fill_in_choice.call("ウ", ["主幹教諭", "校務", "指導教諭", "連絡及び調整"]),
      fill_in_choice.call("エ", ["指導教諭", "校務", "主幹教諭", "連絡及び調整"]),
    ],
    explanation_blocks: [
      text_block.call("主幹教諭は，校長等を助け，命を受けて「校務の一部を整理」する。指導教諭は，教育指導の改善・充実に必要な「指導及び助言」を他の教職員に行う。"),
      text_block.call("イ：①と③が逆である。"),
      text_block.call("ウ：②は「校務の一部」，④は「指導及び助言」が正しい。「校務を整理」するという職務は，第7項の教頭の規定と区別する必要がある。"),
      text_block.call("エ：①と③が逆であり，②と④も原文と異なる。"),
      text_block.call("これらの規定は，第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第37条第7項、第9項、第10項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第18条\n{{①}}の教育公務員の政治的行為の制限については、当分の間、地方公務員法第三十六条の規定にかかわらず、{{②}}の例による。\n\n2　前項の規定は、政治的行為の制限に違反した者の{{③}}につき国家公務員法（昭和二十二年法律第百二十号）第百十条第一項の例による趣旨を{{④}}。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["国立学校及び公立学校", "国家公務員", "処罰", "含むものと解してはならない"]),
      fill_in_choice.call("イ", ["公立学校", "地方公務員", "懲戒", "含むものと解しなければならない"]),
      fill_in_choice.call("ウ", ["公立学校", "国家公務員", "処罰", "含むものと解してはならない"], true),
      fill_in_choice.call("エ", ["国立学校及び公立学校", "地方公務員", "懲戒", "含むものと解しなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("公立学校の教育公務員の政治的行為の制限には，国家公務員の例を用いる。ただし，この規定によって，違反者の処罰についても国家公務員法第110条第1項の例を用いることにはならない。"),
      text_block.call("ア：①は「公立学校」が正しい。"),
      text_block.call("イ：②は「国家公務員」，③は「処罰」，④は「含むものと解してはならない」が正しい。行為の制限と処罰の取扱いを区別する必要がある。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第18条 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験12の作成中データには承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  expected_category = question.fetch(:question_number) <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験12 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験12 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).one? { |block| block[:type] == "fill_in_choice" && block[:cells].size == blank_labels.size } }
      raise "模擬試験12 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験12 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験12 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 12,
      question_number: attributes.fetch(:question_number),
    )

    content_changed =
      question.persisted? &&
        (
          question.content_blocks != question_attributes.fetch(:content_blocks).as_json ||
          question.explanation_blocks != question_attributes.fetch(:explanation_blocks).as_json ||
          question.source_text != question_attributes.fetch(:source_text)
        )
    question.answer_histories.destroy_all if content_changed

    question.assign_attributes(question_attributes.merge(publication_status: "draft"))
    question.save!

    labels = choices.map { |choice| choice.fetch(:label) }
    question.question_choices.where.not(choice_label: labels).destroy_all
    question.question_choices.update_all(is_correct: false)

    choices.each_with_index do |choice_attributes, index|
      choice = question.question_choices.find_or_initialize_by(choice_label: choice_attributes.fetch(:label))
      choice.assign_attributes(
        content_blocks: choice_attributes.fetch(:content_blocks),
        is_correct: choice_attributes.fetch(:correct),
        display_order: index + 1,
      )
      choice.save!
    end

    unless question.question_choices.count == 4 && question.question_choices.where(is_correct: true).count == 1
      raise "模擬試験12 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

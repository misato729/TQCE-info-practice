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

# 模擬試験15（作成中：問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("1941（昭和16）年に公布された国民学校令について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "国民学校は初等科6年と高等科2年で構成され，「皇国ノ道」に基づく基礎的錬成を目的とした。義務教育年限も8年とされ，国民学校令の施行と同時に全国で8年間の就学義務が適用された。"),
      text_choice.call("イ", "国民学校令は義務教育年限を8年に延長し，その適用を昭和19年度から開始することとした。この計画は戦時下においても予定どおり実施され，終戦時まで全国で初等科と高等科を合わせた8年間の義務教育が行われた。"),
      text_choice.call("ウ", "国民学校は「皇国ノ道ニ則リテ初等普通教育ヲ施シ国民ノ基礎的錬成ヲ為ス」ことを目的とし，初等科6年と高等科2年で構成された。8年間の義務教育は昭和19年度から実施する予定であったが，戦時非常措置によって延期され，実施されないまま終戦を迎えた。", true),
      text_choice.call("エ", "国民学校令による初等科・高等科の構成は，戦後の学校教育法にも引き継がれた。昭和22年度から国民学校高等科を新制中学校の第1・第2学年として位置付け，8年間の義務教育を完成させた。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，国民学校令が制度上義務教育を8年に延長した点は適切ですが，その適用は施行時の昭和16年度ではなく，昭和19年度から予定されていました。イは，昭和19年度から予定されていた8年間の義務教育が実施されたとしている点が誤りです。この計画は戦時非常措置によって延期され，実施されないまま終戦となりました。ウは，国民学校の目的，課程構成及び8年制義務教育が実施に至らなかった経緯を正しく述べています。エは，戦後の学校教育法が国民学校の初等科・高等科を維持したとしている点が誤りです。戦後は小学校6年・中学校3年を含む新しい学校体系が発足しました。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第四章第二節『一 国民学校令の公布』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317696.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("キルパトリックのプロジェクト・メソッドについて述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教師又は教科書から与えられた課題を，あらかじめ定められた手順に従って正確に完成する活動を教授の中心に置き，学習者自身がその目的を受け入れているかどうかを学習成立の条件から切り離した。"),
      text_choice.call("イ", "学習者が一月程度の学習課題について契約を結び，教科別実験室で教師の助言を受けながら，自分の進度で学習を進める個別化された教育方法を構成した。"),
      text_choice.call("ウ", "教授によって多方面の興味を形成し，既有の観念と新しい観念を統覚によって結び付けることを通して，教育の究極目的である道徳的品性の形成を目指した。"),
      text_choice.call("エ", "デューイの影響を受け，社会的な環境の中で学習者が心から目的をもって行う活動を学習の中心に置いた。教師が提案した活動であっても，学習者がその目的を自分のものとして受け入れ，計画・遂行・評価に関与する場合にはプロジェクトとなり得る。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは，外部から課された作業を手順どおり実施すること自体を中心としている点が誤りです。キルパトリックは，学習者が目的を自覚し，主体的に取り組む活動を重視しました。イはパーカーストのドルトン・プランについての記述です。ウはヘルバルトの教育思想です。多方面の興味，統覚及び道徳的品性が対応します。エはプロジェクト・メソッドを正しく説明しています。教師の提案から始まる活動であっても，学習者が目的を主体的に受け入れ，社会的な状況の中で計画・遂行する場合にはプロジェクトとなり得ます。"),
    ],
    source_text: "国立国会図書館サーチ『プロジェクト法』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000001093995
J-STAGE『キルパトリックのプロジェクト・メソッド』 | https://www.jstage.jst.go.jp/article/kyouikutetsugaku1959/1962/7/1962_7_14/_article/-char/ja/
J-STAGE『プロジェクト・メソッドにおける目的的活動』 | https://www.jstage.jst.go.jp/article/nasemjournal/19/0/19_KJ00006622222/_pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "次の①～④のうち，「教育基本法」（平成18年法律第120号）の条文として正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "quote",
        text: "①　国民一人一人が、自己の人格を磨き、豊かな人生を送ることができるよう、その生涯にわたって、あらゆる機会に、あらゆる場所において学習することができ、その成果を適切に生かすことのできる社会の実現が図られなければならない。\n\n②　教育公務員は、その職責を遂行するために、絶えず研究と修養に努めなければならない。\n\n③　学校教育上支障のない限り、学校には、社会教育に関する施設を附置し、又は学校の施設を社会教育その他公共のために、利用させることができる。\n\n④　国及び地方公共団体は、教育が円滑かつ継続的に実施されるよう、必要な財政上の措置を講じなければならない。",
      },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("教育基本法の条文は，①と④の二つである。"),
      text_block.call("①：教育基本法第3条「生涯学習の理念」の条文である。学習機会だけでなく，学習成果を適切に生かせる社会の実現を規定している。"),
      text_block.call("②：教育公務員特例法第21条第1項の条文である。教育基本法第9条にも研究と修養に関する規定があるが，そちらは「法律に定める学校の教員は，自己の崇高な使命を深く自覚し……」という条文であり，提示文とは異なる。"),
      text_block.call("③：学校教育法第137条の条文である。教育基本法第12条にも学校施設の利用に関する規定があるが，提示文そのものの出典は学校教育法である。"),
      text_block.call("④：教育基本法第16条第4項の条文である。国及び地方公共団体に，教育の円滑かつ継続的な実施に必要な財政上の措置を求めている。"),
    ],
    source_text: "教育基本法・第3条、第9条、第12条、第16条第4項 | https://laws.e-gov.go.jp/law/418AC0000000120\n教育公務員特例法・第21条第1項 | https://laws.e-gov.go.jp/law/324AC0000000001\n学校教育法・第137条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第10条\n私立学校は、校長を定め、大学及び高等専門学校にあつては{{①}}に、大学及び高等専門学校以外の学校にあつては{{②}}に届け出なければならない。\n\n第11条\n{{③}}は、教育上必要があると認めるときは、{{①}}の定めるところにより、児童、生徒及び学生に懲戒を加えることができる。ただし、{{④}}を加えることはできない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "都道府県教育委員会", "校長", "体罰"]),
      fill_in_choice.call("イ", ["文部科学大臣", "都道府県知事", "校長及び教員", "体罰"], true),
      fill_in_choice.call("ウ", ["文部科学省", "都道府県知事", "校長及び教員", "肉体的苦痛"]),
      fill_in_choice.call("エ", ["文部科学省", "都道府県教育委員会", "校長", "肉体的苦痛"]),
    ],
    explanation_blocks: [
      text_block.call("私立学校の校長の届出先は，大学・高等専門学校では文部科学大臣，それ以外の学校では都道府県知事である。また，第11条は校長及び教員による懲戒を認める一方，体罰を禁止している。"),
      text_block.call("ア：②は「都道府県知事」，③は「校長及び教員」が正しい。私立学校の届出先を教育委員会と取り違えないことが重要である。"),
      text_block.call("ウ：①は「文部科学大臣」，④は「体罰」が正しい。第11条の禁止対象を表す原文の語句は「肉体的苦痛」ではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "学校教育法・第10条、第11条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の6\n公立の小学校等の校長及び教員の{{①}}は、当該校長及び教員がその{{②}}に応じた資質の向上のための取組を行うことを促進するため、当該校長及び教員からの相談に応じ、研修、認定講習等その他の資質の向上のための機会に関する情報を提供し、又は資質の向上に関する指導及び助言を行うものとする。\n\n2　公立の小学校等の校長及び教員の{{①}}は、前項の規定による相談への対応、情報の提供並びに指導及び助言（次項において「資質の向上に関する指導助言等」という。）を行うに当たつては、当該校長及び教員に係る{{③}}を踏まえるとともに、当該校長及び教員の{{④}}に係る情報を活用するものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["指導助言者", "職務の級及び在職期間", "指標及び教員研修計画", "人事評価の結果"]),
      fill_in_choice.call("イ", ["研修実施者", "職責、経験及び適性", "指針及び教育振興基本計画", "研修等に関する記録"]),
      fill_in_choice.call("ウ", ["指導助言者", "職責、経験及び適性", "指標及び教員研修計画", "研修等に関する記録"], true),
      fill_in_choice.call("エ", ["研修実施者", "職務の級及び在職期間", "指針及び教育振興基本計画", "人事評価の結果"]),
    ],
    explanation_blocks: [
      text_block.call("この条文は，指導助言者が，教員等の「職責、経験及び適性」に応じた資質向上を促すために行う対応を定めている。その際には「指標及び教員研修計画」を踏まえ，「研修等に関する記録」の情報を活用する。"),
      text_block.call("ア：②は「職責、経験及び適性」，④は「研修等に関する記録」が正しい。ここで活用すべき情報として明記されているのは，人事評価の結果ではない。"),
      text_block.call("イ：①は「指導助言者」，③は「指標及び教員研修計画」が正しい。研修の実施に関する立場と，この条文で定める指導助言に関する立場を区別する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条の6第1項、第2項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験15の作成中データには承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  expected_category = question.fetch(:question_number) <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験15 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験15 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).one? { |block| block[:type] == "fill_in_choice" && block[:cells].size == blank_labels.size } }
      raise "模擬試験15 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験15 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験15 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

QuestionSeedSync.import(exam_number: 15, questions: questions, publication_status: "draft")

text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験19（作成中：承認済みの問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("戦後の教育委員会制度の変遷について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "昭和23年に教育委員会法が制定され，教育委員の公選制に基づく教育委員会が発足した。全国の市町村への設置は昭和27年に実施され，昭和31年には地方教育行政の組織及び運営に関する法律が制定されて，委員の選任は首長が議会の同意を得て行う任命制へ改められた。", true),
      text_choice.call("イ", "昭和23年の教育委員会法は，地域住民の意向を教育行政に反映するため，都道府県と五大市に公選制の教育委員会を設けた。昭和27年に全国の市町村へ設置を広げる際には，市町村の委員について首長が議会の同意を得て任命する方式が採用された。"),
      text_choice.call("ウ", "昭和23年の教育委員会法は，教育行政の独立性を確保するため，都道府県と五大市に教育委員会を設けた。教育委員は地方議会が選任し，昭和31年の地方教育行政の組織及び運営に関する法律によって，住民による公選へと選任方法が改められた。"),
      text_choice.call("エ", "昭和23年の教育委員会法では公選制が採用され，昭和31年の地方教育行政の組織及び運営に関する法律によって任命制へ改められた。この昭和31年の改革は，それまで都道府県と五大市に置かれていた教育委員会を，全国の市町村に設置する契機にもなった。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。昭和23年（1948年）の発足，昭和27年（1952年）の全国市町村への設置，昭和31年（1956年）の公選制から任命制への変更という流れである。"),
      text_block.call("イ：任命制へ変更した時期が誤り。昭和27年に全国の市町村へ設置された教育委員会も公選制だった。"),
      text_block.call("ウ：選任方法とその変化が誤り。教育委員会法では公選制，昭和31年の地教行法では首長が議会の同意を得る任命制である。"),
      text_block.call("エ：全国市町村への設置時期が誤り。全国への設置は，昭和31年の改革より前の昭和27年に実施された。"),
    ],
    source_text: "文部科学省『学制百二十年史』「教育行政制度の改革と教育委員会制度の発足」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318255.htm\n文部科学省『地方分権時代における教育委員会の在り方について』2（1）「教育委員会制度の沿革」 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1382466.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("デューイの『経験と教育』における経験の捉え方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "経験に基づく教育では，活動が現在の学習者に与える満足感を重視した。教師が，学習者に満足を与える活動の量を増やしていくことによって，その経験が将来の成長へつながる連続性も確保され，経験の教育的な価値が高まると考えた。"),
      text_choice.call("イ", "経験の「連続性」は，学校で扱う教材を一定の順序で継続して提示することを指し，「相互作用」は，その教材について学習者同士が意見を交換することを指す。この二つを組み合わせ，教材の順序と集団内の対話を整えることが経験の教育的な価値を保障する。"),
      text_choice.call("ウ", "ある経験がその後の経験の質に影響する「連続性」と，学習者の内的条件と環境の客観的条件が関わる「相互作用」を重視した。経験の教育的な価値は，現在の経験の質と，後の成長へのつながりによって判断され，教師には経験が成立する条件を整える役割がある。", true),
      text_choice.call("エ", "経験の「連続性」と「相互作用」を重視し，子どもが経験を通して成長すると考えた。このうち，学習者の内的な状態と教材などの客観的条件が結び付く関係を「連続性」とし，以前の経験が後の経験の質を変える関係を「相互作用」として説明した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：現在の満足を与える活動の量を増やせば，将来の成長へのつながりも確保されるとする点が誤り。楽しい経験でも，後の成長を妨げるものは教育的な経験とはいえない。"),
      text_block.call("イ：二つの原理を，教材の提示順序と学習者間の対話に置き換えている点が誤り。連続性は経験が後の経験の質に影響すること，相互作用は学習者の内的条件と環境の客観的条件との関係である。"),
      text_block.call("ウ：適切。経験の現在の質と将来への影響，学習者と環境の関係を併せて捉えている。"),
      text_block.call("エ：連続性と相互作用の説明が逆になっている。"),
    ],
    source_text: "河北邦子・竹田礼子「小学校音楽科の創作活動にみる連続性と相互作用の研究」第3節 | https://ypir.lib.yamaguchi-u.ac.jp/yg/119/files/143344\n越野章史「J.デューイの教育思想と現代の教育課題」『和歌山大学教育学部紀要』第68巻第1号・200〜201頁 | https://repository.center.wakayama-u.ac.jp/files/public/0/3302/20180820134607379635/AN00257966.68(1).197.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第12条 社会教育」からの抜粋である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第12条\n\n{{①}}にこたえ、社会において行われる教育は、国及び地方公共団体によって{{②}}されなければならない。\n\n2　国及び地方公共団体は、図書館、博物館、公民館その他の社会教育施設の設置、{{③}}、{{④}}その他の適当な方法によって社会教育の振興に努めなければならない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["個人の要望や社会の要請", "推進", "学校の施設の利用", "学習の成果及び記録の評価"]),
      fill_in_choice.call("イ", ["地域の要望や産業の要請", "奨励", "学校の教育課程の編成", "学習の機会及び情報の提供"]),
      fill_in_choice.call("ウ", ["地域の要望や産業の要請", "推進", "学校の教育課程の編成", "学習の成果及び記録の評価"]),
      fill_in_choice.call("エ", ["個人の要望や社会の要請", "奨励", "学校の施設の利用", "学習の機会及び情報の提供"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「奨励」，④は「学習の機会及び情報の提供」。"),
      text_block.call("イ：①は「個人の要望や社会の要請」，③は「学校の施設の利用」。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも原文と一致する。社会教育の振興方法には，社会教育施設の設置に加え，学校施設の利用，学習機会・情報の提供が含まれる。"),
      text_block.call("学校施設を社会教育に利用することと，学校の教育課程を編成することは区別される。"),
    ],
    source_text: "教育基本法・第12条 | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("※第57条は，高等学校の入学資格を定めている。"),
      {
        type: "fill_in_quote",
        text: "第58条\n\n高等学校には、専攻科及び別科を置くことができる。\n\n2　高等学校の専攻科は、高等学校若しくはこれに準ずる学校若しくは中等教育学校を{{①}}者又は文部科学大臣の定めるところにより、これと{{②}}があると認められた者に対して、精深な程度において、特別の事項を教授し、その研究を指導することを目的とし、その修業年限は、{{③}}とする。\n\n3　高等学校の別科は、前条に規定する入学資格を有する者に対して、簡易な程度において、{{④}}を施すことを目的とし、その修業年限は、{{③}}とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["卒業した", "同程度の能力", "一年以上", "専門的な職業教育"]),
      fill_in_choice.call("イ", ["卒業した", "同等以上の学力", "一年以上", "特別の技能教育"], true),
      fill_in_choice.call("ウ", ["第3学年に在学する", "同等以上の学力", "二年以上", "特別の技能教育"]),
      fill_in_choice.call("エ", ["第3学年に在学する", "同程度の能力", "二年以上", "専門的な職業教育"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「同等以上の学力」，④は「特別の技能教育」。別科の目的に関する条文の表現は「専門的な職業教育」ではない。"),
      text_block.call("イ：四つとも原文と一致する。専攻科は高等学校等の卒業者等を対象とし，別科は高等学校への入学資格を有する者を対象とする。修業年限はいずれも一年以上である。"),
      text_block.call("ウ：①は「卒業した」，③は「一年以上」。専攻科の対象を，在学中の第3学年の生徒とする規定ではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "学校教育法・第57条、第58条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "fill_in_quote",
        text: "第25条\n\n公立の小学校等の教諭等の{{①}}は、児童、生徒又は幼児（以下「児童等」という。）に対する指導が不適切であると認定した教諭等に対して、その能力、適性等に応じて、当該指導の改善を図るために必要な事項に関する研修（以下この条において「指導改善研修」という。）を実施しなければならない。\n\n2　指導改善研修の期間は、一年を超えてはならない。ただし、特に必要があると認めるときは、{{①}}は、指導改善研修を開始した日から引き続き二年を超えない範囲内で、これを延長することができる。\n\n3　{{①}}は、指導改善研修を実施するに当たり、指導改善研修を受ける者の能力、適性等に応じて、その者ごとに指導改善研修に関する{{②}}を作成しなければならない。\n\n4　{{①}}は、指導改善研修の{{③}}において、指導改善研修を受けた者の児童等に対する指導の改善の程度に関する認定を行わなければならない。\n\n5　{{①}}は、第一項及び前項の認定に当たつては、教育委員会規則（幼保連携型認定こども園にあつては、地方公共団体の規則。次項において同じ。）で定めるところにより、教育学、医学、心理学その他の児童等に対する指導に関する専門的知識を有する者及び当該{{①}}の属する都道府県又は市町村の区域内に居住する保護者（親権を行う者及び未成年後見人をいう。）である者の{{④}}。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者", "計画書", "終了時", "意見を聴かなければならない"], true),
      fill_in_choice.call("イ", ["任命権者", "指標", "開始時", "意見を聴かなければならない"]),
      fill_in_choice.call("ウ", ["指導助言者", "計画書", "終了時", "同意を得なければならない"]),
      fill_in_choice.call("エ", ["指導助言者", "指標", "開始時", "同意を得なければならない"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。任命権者が受講者ごとの計画書を作成し，研修終了時に指導の改善の程度を認定する。"),
      text_block.call("イ：②は「計画書」，③は「終了時」。"),
      text_block.call("ウ：①は「任命権者」，④は「意見を聴かなければならない」。専門家等の同意を認定の要件とする規定ではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
      text_block.call("第5項の意見聴取は，指導が不適切であることの認定と，研修後の改善の程度の認定の双方に関わる。"),
    ],
    source_text: "教育公務員特例法・第25条第1項〜第5項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験19は承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験19 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験19 問#{number}の選択肢または正答数が不正です"
  end
  unless question.fetch(:content_blocks).any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験19 問#{number}の問題文または解説が空です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験19 問#{number}の出典リンク形式が不正です"
  end

  next unless (3..5).cover?(number)

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
  unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && quotes.size == 1 &&
      quotes.first.fetch(:text).match?(/\A第\d+条/) && blank_labels == %w[① ② ③ ④] &&
      choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
    raise "模擬試験19 問#{number}の条番号、空欄または選択肢の対応が不正です"
  end
end

QuestionSeedSync.import(exam_number: 19, questions: questions, publication_status: "draft")

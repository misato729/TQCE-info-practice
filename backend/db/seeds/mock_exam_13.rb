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

# 模擬試験13（作成中：問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("我が国の教員養成制度の変遷について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "明治19年の師範学校令では，尋常師範学校を全国一校の官立学校として東京に置き，高等師範学校を各府県に設置した。前者は尋常師範学校の教員を，後者は小学校教員を養成するものとされた。"),
      text_choice.call("イ", "文部省は「学制」の公布に先立って東京に師範学校を設置した。明治19年の師範学校令では，各府県の尋常師範学校が小学校教員を，全国一校の官立高等師範学校が尋常師範学校の教員を養成した。戦後は大学における教員養成と開放制が採用され，昭和24年に教育職員免許法が公布された。", true),
      text_choice.call("ウ", "明治30年の師範教育令は，尋常師範学校という名称と制度をそのまま維持し，戦前の教員養成制度に実質的な変更を加えなかった。戦後も，旧来の師範学校だけに教員養成を認める閉鎖的な制度が継承された。"),
      text_choice.call("エ", "戦後に採用された開放制は，各都道府県の国立教育学部だけに教員養成を認める制度であり，一般の国立・公立・私立大学が教員養成に参加することは想定されていなかった。また，大学を卒業すれば履修科目にかかわらず免許状が授与された。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アは，尋常師範学校と高等師範学校の設置主体及び養成対象を逆にしています。尋常師範学校は各府県に置かれて小学校教員を養成し，高等師範学校は全国一校の官立学校として東京に置かれ，尋常師範学校の教員などを養成しました。イは，明治初期から戦後への教員養成制度の変化を正しく述べています。ウは，明治30年の師範教育令により尋常師範学校が「師範学校」と改称されたこと，及び戦後に大学での開放制へ転換したことと反します。エは，開放制の対象を国立教育学部に限定している点が誤りです。開放制では，所定の課程を置く国立・公立・私立大学でも教員養成を行えます。また，単なる大学卒業だけで免許状が授与される制度ではありません。"),
    ],
    source_text: "文部科学省『学制百二十年史』第四節『教員及び教員養成』―戦前 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318234.htm
文部科学省『学制百二十年史』第四節『教員及び教員養成』―戦後 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318262.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("モンテッソーリの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "幼児の遊びを人間性の最も純粋な表現と捉えて幼稚園を創設し，恩物を通して，子どもの内面にある統一的な力を自発的に表現させようとした。"),
      text_choice.call("イ", "シカゴ大学に実験学校を開設し，経験の再構成として教育を捉えた。学校を共同生活の場とし，問題解決的な学習を通して民主的な社会の形成に参加する力を育てようとした。"),
      text_choice.call("ウ", "学習者が一定期間の学習課題について契約を結び，教科別実験室を利用しながら個々の進度で学習する仕組みと，異年齢の生活集団を組み合わせた教育方法を考案した。"),
      text_choice.call("エ", "医学的な観察を教育に生かし，1907年に「子どもの家」を開設した。敏感期と自己教育力を重視し，子どもが自ら誤りに気付ける教具を含む「準備された環境」を整え，教師を観察者・援助者として位置付けた。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アはフレーベルの教育思想です。幼稚園の創設，遊び及び恩物が対応します。イはデューイの教育思想とシカゴ大学実験学校についての記述です。ウはパーカーストが考案したドルトン・プランについての記述です。学習課題の契約，教科別実験室，個別進度及び生活集団が主要な構成要素となります。エはモンテッソーリ教育を正しく説明しています。モンテッソーリ教育では，敏感期，自己教育力，準備された環境，自己訂正的な教具及び観察者としての教師が重視されます。"),
    ],
    source_text: "お茶の水女子大学教育・研究成果コレクション『モンテッソーリ教育における感覚教育』 | https://teapot.lib.ocha.ac.jp/record/10434/files/20020601.pdf
国立国会図書館デジタルコレクション『幼児の秘密』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000039-I3042669
広島文教大学附属幼稚園『モンテッソーリ教育』 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，適切でないものを一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      text_choice.call("ア", "第6条第2項は，心身の発達に応じた体系的な教育を組織的に行うことに加え，学校生活に必要な規律を重んずることと，自ら進んで学習に取り組む意欲を高めることの双方を重視している。"),
      text_choice.call("イ", "第6条第1項は，法律に定める学校が公の性質を有することを示した上で，その設置者について，「国，地方公共団体及び学校法人のみが，これを設置することができる」と規定している。", true),
      text_choice.call("ウ", "第10条第2項は，国及び地方公共団体が，家庭教育の自主性を尊重しつつ，保護者に対する学習の機会や情報の提供など，家庭教育を支援するために必要な施策を講ずるよう努めることを定めている。"),
      text_choice.call("エ", "第12条第2項は，社会教育を振興する方法として，図書館，博物館，公民館などの施設の設置に加え，学校の施設の利用や，学習の機会及び情報の提供などを挙げている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。第6条第2項は，規律を重んずることと，自発的な学習意欲を高めることを併せて重視している。"),
      text_block.call("イ：不適切。原文は「国，地方公共団体及び法律に定める法人のみ」であり，「学校法人のみ」ではない。設置できる法人の範囲を書き換えている。"),
      text_block.call("ウ：適切。家庭教育への支援について，家庭教育の自主性を尊重することを明記している。"),
      text_block.call("エ：適切。学校の施設の利用も，社会教育振興の方法として第12条第2項に含まれている。"),
    ],
    source_text: "教育基本法・第6条、第10条第2項、第12条第2項 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第34条\n小学校においては、{{①}}の検定を経た教科用図書又は{{②}}が著作の名義を有する教科用図書を使用しなければならない。\n\n2　前項に規定する教科用図書（以下この条において「教科用図書」という。）の内容を{{①}}の定めるところにより記録した電磁的記録（電子的方式、磁気的方式その他人の知覚によつては認識することができない方式で作られる記録であつて、{{③}}の用に供されるものをいう。）である教材がある場合には、同項の規定にかかわらず、{{①}}の定めるところにより、児童の教育の充実を図るため必要があると認められる教育課程の一部において、{{④}}当該教材を使用することができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "文部科学省", "文字や図形等の表示", "教科用図書と併せて"]),
      fill_in_choice.call("イ", ["教育委員会", "国", "電子計算機による情報処理", "教科用図書と併せて"]),
      fill_in_choice.call("ウ", ["教育委員会", "国", "文字や図形等の表示", "教科用図書に代えて"]),
      fill_in_choice.call("エ", ["文部科学大臣", "文部科学省", "電子計算機による情報処理", "教科用図書に代えて"], true),
    ],
    explanation_blocks: [
      text_block.call("検定の主体は「文部科学大臣」，著作の名義を有する主体は「文部科学省」である。また，第2項は，所定の条件の下で，電磁的記録である教材を教科用図書に「代えて」使用できることを規定している。"),
      text_block.call("ア：③は「電子計算機による情報処理」，④は「教科用図書に代えて」が正しい。単なる併用についての規定ではない。"),
      text_block.call("イ：①は「文部科学大臣」，②は「文部科学省」，④は「教科用図書に代えて」が正しい。"),
      text_block.call("ウ：①と②に加え，電磁的記録の定義に当たる③も原文と異なる。"),
      text_block.call("第34条は，第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第34条第1項、第2項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の4第1項\n公立の小学校等の校長及び教員の{{①}}は、{{②}}を踏まえ、当該校長及び教員の研修について、{{③}}、{{④}}に実施するための計画（以下この条及び第二十二条の六第二項において「教員研修計画」という。）を定めるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "指標", "毎年度", "体系的かつ効果的"], true),
      fill_in_choice.call("イ", ["任命権者", "指針", "毎年度", "体系的かつ効果的"]),
      fill_in_choice.call("ウ", ["研修実施者", "指標", "三年ごと", "計画的かつ継続的"]),
      fill_in_choice.call("エ", ["任命権者", "指針", "三年ごと", "計画的かつ継続的"]),
    ],
    explanation_blocks: [
      text_block.call("教員研修計画は，「研修実施者」が「指標」を踏まえ，「毎年度」，研修を「体系的かつ効果的」に実施するために定める。"),
      text_block.call("イ：①は「研修実施者」，②は「指標」が正しい。「指針を参酌して任命権者が指標を定める」という前条の規定と区別する。"),
      text_block.call("ウ：③は「毎年度」，④は「体系的かつ効果的」が正しい。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条の3、第22条の4第1項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験13の作成中データには承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  expected_category = question.fetch(:question_number) <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験13 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験13 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).one? { |block| block[:type] == "fill_in_choice" && block[:cells].size == blank_labels.size } }
      raise "模擬試験13 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験13 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験13 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

QuestionSeedSync.import(exam_number: 13, questions: questions, publication_status: "draft")

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

# 模擬試験13（全20問）
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
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学校図書館を{{①}}に利用しその機能の活用を図り，生徒の主体的・対話的で深い学びの実現に向けた{{②}}に生かすとともに，生徒の{{③}}な学習活動や読書活動を充実すること。また，地域の図書館や博物館，美術館，劇場，音楽堂等の施設の活用を積極的に図り，資料を活用した{{④}}等の学習活動を充実すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["日常的", "授業改善", "自主的，自発的", "情報の収集や鑑賞"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["計画的", "授業改善", "自主的，自発的", "情報の収集や鑑賞"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["計画的", "教育課程の編成", "主体的，対話的", "知識の定着や技能の反復"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["日常的", "教育課程の編成", "自主的，自発的", "知識の定着や技能の反復"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "学校図書館は計画的に利用し，授業改善と自主的・自発的な学習活動・読書活動に生かします。地域の文化施設等については，資料による情報の収集や鑑賞などへの活用を規定しています。アは①，ウは②・③・④，エは①・②・④が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款1（6） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が，基礎的・基本的な知識及び技能の習得も含め，学習内容を確実に身に付けることができるよう，生徒や学校の{{①}}に応じ，{{②}}，繰り返し学習，学習内容の習熟の程度に応じた学習，生徒の興味・関心等に応じた課題学習，補充的な学習や発展的な学習などの学習活動を取り入れることや，{{③}}による指導体制を確保することなど，指導方法や指導体制の工夫改善により，{{④}}の充実を図ること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["実態", "個別学習やグループ別学習", "教師間の協力", "個別最適な学び"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["希望", "一斉学習や講義形式の学習", "地域の人々の協力", "個に応じた指導"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["希望", "個別学習やグループ別学習", "地域の人々の協力", "個別最適な学び"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["実態", "個別学習やグループ別学習", "教師間の協力", "個に応じた指導"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "生徒・学校の実態に応じた多様な学習活動と，教師間の協力による指導体制の工夫改善を通して，「個に応じた指導」を充実させる規定です。アは④，イは①・②・③，ウは①・③・④が異なります。「個別最適な学び」は重要な政策用語ですが，④の原文とは異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款1（5）第1文 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "他教科等及び総合的な探究の時間で身に付けた資質・能力を{{①}}，学習や生活において生かし，それらが{{②}}に働くようにすること。その際，{{③}}，情報活用能力など{{④}}となる資質・能力を重視すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["段階的に積み上げ", "総合的", "言語能力", "各教科・科目の基礎"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["相互に関連付け", "効果的", "読解力", "全ての学習の基盤"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["相互に関連付け", "総合的", "言語能力", "全ての学習の基盤"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["段階的に積み上げ", "効果的", "読解力", "各教科・科目の基礎"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "教科等と総合的な探究の時間で育てた資質・能力を相互に関連付け，総合的に働かせることを求めています。言語能力・情報活用能力は，特定教科だけでなく，全ての学習の基盤となる資質・能力です。アは①・④，イは②・③，エは全ての空欄が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第4章第3の1（4） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "参考：抜粋中の「第1款の2の（2）に示す道徳教育の目標」は，人間としての在り方生き方を考え，主体的な判断の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことを指す。" },
      { type: "fill_in_quote", text: "各学校においては，第１款の２の（2）に示す道徳教育の目標を踏まえ，{{①}}を作成し，校長の方針の下に，道徳教育の推進を主に担当する教師（「{{②}}」という。）を中心に，全教師が協力して道徳教育を展開すること。なお，道徳教育の全体計画の作成に当たっては，生徒や学校の実態に応じ，指導の方針や重点を明らかにして，{{③}}を明らかにすること。その際，公民科の「公共」及び「倫理」並びに特別活動が，人間としての在り方生き方に関する{{④}}の場面であることに配慮すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["道徳教育の全体計画", "道徳教育推進教師", "各教科・科目等との関係", "中核的な指導"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["道徳教育の年間指導計画", "道徳教育推進教師", "各教科・科目等との関係", "専門的な指導"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["道徳教育の全体計画", "道徳教育主任", "学校評価との関係", "中核的な指導"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["道徳教育の年間指導計画", "道徳教育主任", "学校評価との関係", "専門的な指導"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "全体計画を作成し，道徳教育推進教師を中心に全教師が協力することを定めています。全体計画では各教科・科目等との関係を明確にし，「公共」「倫理」及び特別活動を中核的な指導の場面として位置付けます。イは①・④，ウは②・③，エは全ての空欄が異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第7款1 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第2 各活動・学校行事の目標及び内容 〔生徒会活動〕2 内容」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒会の組織づくりと生徒会活動の計画や運営\n生徒が主体的に組織をつくり，{{①}}し，計画を立て，学校生活の課題を見いだし解決するために話し合い，{{②}}を図り実践すること。\n\n（2）学校行事への協力\n学校行事の特質に応じて，生徒会の組織を活用して，{{③}}を担当したり，運営に主体的に協力したりすること。\n\n（3）ボランティア活動などの社会参画\n地域や社会の課題を見いだし，具体的な対策を考え，実践し，{{④}}に参画できるようにすること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["役割を分担", "意思決定", "計画の一部", "地域や社会"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["活動を選択", "合意形成", "指導計画の作成", "学校生活の改善"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["役割を分担", "合意形成", "計画の一部", "地域や社会"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["活動を選択", "意思決定", "指導計画の作成", "学校生活の改善"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "生徒会活動は，役割分担と話合いによる合意形成を通して実践します。学校行事では計画の一部を担当するなどして協力し，ボランティア活動等では地域や社会への参画につなげます。アは②，イは①・③・④，エは全ての空欄が異なります。集団の課題解決についての②は「合意形成」です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第5章第2〔生徒会活動〕2（1）～（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=481",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "児童生徒理解においては、児童生徒を心理面のみならず、学習面、社会面、健康面、進路面、家庭面から総合的に理解していくことが重要です。また、学級・ホームルーム担任の日頃のきめ細かい観察力が、指導・援助の成否を大きく左右します。また、学年担当、教科担任、部活動等の顧問等による{{①}}な広い視野からの児童生徒理解に加えて、養護教諭、SC、SSWの専門的な立場からの児童生徒理解を行うことが大切です。この他、生活実態調査、いじめアンケート調査等の調査データに基づく{{②}}な理解も有効です。特に、教育相談では、児童生徒の声を、{{③}}し、相手の立場に寄り添って理解しようとする共感的理解が重要になります。" },
      text_block.call("注：SCはスクールカウンセラー、SSWはスクールソーシャルワーカーを指す。"),
    ],
    choices: [
      fill_in_choice.call("ア", ["複眼的", "客観的", "受容・傾聴"], true),
      fill_in_choice.call("イ", ["多面的", "客観的", "受容・助言"]),
      fill_in_choice.call("ウ", ["複眼的", "共感的", "受容・助言"]),
      fill_in_choice.call("エ", ["多面的", "共感的", "受容・傾聴"]),
    ],
    explanation_blocks: [
      text_block.call("異なる立場の教職員による「複眼的」な理解、調査データに基づく「客観的」な理解、本人の声を「受容・傾聴」する共感的理解を組み合わせています。"),
      text_block.call("イ：①と③が原文と異なります。複数の教職員の視点を合わせる箇所は「複眼的」、本人の声を受け止めて聴く箇所は「受容・傾聴」です。"),
      text_block.call("ウ：②と③が異なります。調査データに基づく理解は「客観的」です。助言を行うことと、本人の声を傾聴して理解することも区別します。"),
      text_block.call("エ：①と②が異なります。「共感的理解」は後半の、相手の立場に寄り添う理解に対応する語句です。"),
    ],
    source_text: "文部科学省『生徒指導提要』第1章1.3.1（2）「観察力と専門的・客観的・共感的理解」、本文24ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=27",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("情緒障害，特に選択性かん黙（場面緘黙）のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "家庭では話せても学校などで話せない状態がみられる。発声器官の機能の未熟さを中心に状態を把握し，発音の明瞭さを高める練習と関連付けて指導を計画する。"),
      text_choice.call("イ", "対人関係の緊張や不安によって，慣れない場所や相手とのやり取りが難しくなる。こうした状態は，自閉症と同じ原因による教育的ニーズの類型として指導内容を整理する。"),
      text_choice.call("ウ", "文字や身振りによって学級内での発表に参加できるようになった場合は，情緒障害の状態が解消したと捉え，非言語的な手段から音声による発表へ指導の中心を移す。"),
      text_choice.call("エ", "話せる相手や場所，緊張の程度などを把握し，安心して意思を伝えられる環境を整える。文字や身振りも活用し，本人と相談しながら話しやすい条件を整えて段階的に支援する。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：選択性かん黙は，一般に発声器官の障害ではなく，心理的な要因などによって特定の状況で話せない状態です。発音の練習を中心とする理解は適切ではありません。"),
      text_block.call("イ：外から見える状態が似ていても，背景や教育的ニーズが同じとは限りません。自閉症と，主として心理的な要因による選択性かん黙とでは，原因や対応が異なります。"),
      text_block.call("ウ：代替的な手段で参加できることは，困難さが解消したことを意味しません。音声へ一律に移行させず，本人の状態と必要な支援を継続して検討します。"),
      text_block.call("エ：適切です。非言語的な意思表示も受け止め，場所，相手，人数などの条件を整えながら，段階的な支援を行います。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』Ⅷ「情緒障害」―情緒の安定，コミュニケーション，通常の学級での指導，障害により生じる状態 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_12.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("児童期から青年期にかけての仲間関係を，ギャング・グループ，チャム・グループ，ピア・グループとして捉える考え方に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ギャング・グループは，共通の遊びや行動を通して形成される集団である。結び付きの中心は，互いの価値観や考え方の違いを認め合い，個人として対等に関わることにある。"),
      text_choice.call("イ", "チャム・グループでは，共通の趣味や内面的な類似性を確かめ合うことが重視される。ピア・グループでは，類似性に加えて自他の違いも認め合うような関係が重視される。", true),
      text_choice.call("ウ", "ピア・グループでは，自他の違いを認めながら仲間関係を形成する。その集団の結び付きの特徴は，外面的に同じ行動をとる程度を中心として捉えられる。"),
      text_choice.call("エ", "ギャング・グループでは，共通の活動や集団独自の規則によって結び付きが強まる。その後，自他の違いを認め合う関係を中心とする集団になると，チャム・グループと呼ばれる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：共通の遊びや行動を重視する部分は適切です。しかし，自他の違いを認める個別的な関係は，ピア・グループの特徴です。"),
      text_block.call("イ：適切です。チャム・グループの内面的な類似性と，ピア・グループの個別性の尊重を区別しています。"),
      text_block.call("ウ：前半は適切ですが，外面的な同一行動を重視する特徴はギャング・グループに対応します。"),
      text_block.call("エ：前半は適切です。自他の違いを認め合う関係を特徴とするのは，チャム・グループではなくピア・グループです。"),
    ],
    source_text: "川崎医療福祉大学臨床心理学科・本城瑞恵「ギャング集団・チャム集団・ピア集団」 | https://w.kawasaki-m.ac.jp/psycho/?p=6870",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("バンデューラの自己効力感に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "自己効力感は，ある行動をとれば望ましい結果が生じるという結果期待を意味する。自分が実際に成功した経験は，その行動がもたらす結果への確信を高める情報源となる。"),
      text_choice.call("イ", "結果期待は，望ましい結果を得るために必要な行動を，自分がどの程度うまく遂行できるかという見込みを意味する。こうした見込みには，他者からの励ましや説得も関係する。"),
      text_choice.call("ウ", "自己効力感は，ある結果を得るために必要な行動を，自分が遂行できるという見込みに関わる。自分に似た他者の成功を観察する代理体験も，その形成に関わる情報源となる。", true),
      text_choice.call("エ", "代理体験は，自分自身が行動して成功した経験を振り返り，その経験を別の課題にも当てはめることである。成功の経験が積み重なることによって，自己効力感が高まる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：行動がどのような結果を生むかという予測は結果期待です。自己効力感は，必要な行動を自分が遂行できるかという効力期待に関わります。"),
      text_block.call("イ：説明しているのは結果期待ではなく効力期待です。言語的・社会的な説得が自己効力感に影響する部分は適切です。"),
      text_block.call("ウ：適切です。自己効力感の意味と，代理体験という情報源を正しく示しています。"),
      text_block.call("エ：自分自身の成功経験は，遂行行動の達成や制御体験と呼ばれます。代理体験は，他者の行動を観察することに関わります。"),
    ],
    source_text: "日本心理学会『心理学ワールド』「学習意欲の心理学」―結果期待と効力期待 | https://psych.or.jp/publication/world102/pw19/\n東京大学山内研究室「【学びのキーワード】自己効力感」―四つの情報源 | https://fukutake.iii.u-tokyo.ac.jp/ylab/2010/09/post-256.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示されたICT環境整備の在り方に関する説明である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "GIGAスクール構想の端末は，シンプルかつ安価なものを配備する。端末から校内サーバーにアクセスし，学校内に保存されたデータやサービスを利用することを前提とし，クラウドはそのデータを学校外に保管する仕組みとして活用する。"),
      text_choice.call("イ", "学校内外をつなぐ高速大容量のネットワークを整備し，端末からクラウドを活用する。1人1台端末環境を実現する対象は小学校・中学校段階とし，高等学校段階では，多様な学科・教科の実態に応じた共同利用型の端末環境を整える。"),
      text_choice.call("ウ", "シンプルかつ安価な端末から，ネットワークを通じてクラウド上のデータやサービスを活用することを前提とする。学校の設置者が必要なセキュリティ対策を講じ，高等学校段階でも1人1台端末環境を実現するとともに，各学校段階で家庭への持ち帰りを可能にすることが望まれる。", true),
      text_choice.call("エ", "クラウドを活用するため，学校内外をつなぐネットワークを高速大容量にし，必要なセキュリティ対策を講じる。端末の家庭への持ち帰りは，生徒の発達の段階を踏まえ，義務教育を終えた高等学校段階から可能にすることが望まれる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：クラウドの位置付けが誤りです。答申は，端末からクラウドにアクセスして，クラウド上のデータや各種サービスを活用することを前提としています。校内サーバーの利用を前提とし，クラウドを保管用に位置付ける説明ではありません。"),
      text_block.call("イ：高等学校の端末環境が誤りです。多様な実態を踏まえつつ，高等学校段階でも「1人1台端末環境」を実現するとしています。学科・教科ごとの共同利用環境への置換ではありません。"),
      text_block.call("ウ：適切です。端末とクラウドの関係，必要なセキュリティ対策，高等学校の1人1台端末環境及び各学校段階での持ち帰りが，答申の内容と一致しています。"),
      text_block.call("エ：持ち帰りの対象となる学校段階が誤りです。答申は「各学校段階」において家庭への持ち帰りを可能にすることが望まれるとしています。高等学校段階から開始するという説明ではありません。"),
    ],
    source_text: "中央教育審議会『令和の日本型学校教育』答申・第Ⅰ部 総論5（3）「ICT環境整備の在り方」・本文32頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=37",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第2章 第10節 情報 第3款 各科目にわたる指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（2）各科目の指導においては，{{①}}を育成するため，情報と情報技術を活用した問題の発見・解決を行う過程において，自らの考察や解釈，概念等を{{②}}に説明したり記述したりするなどの{{③}}の充実を図ること。\n\n（3）各科目の指導においては，問題を発見し，設計，制作，実行し，その過程を振り返って評価し改善するなどの一連の過程に取り組むことなどを通して，{{④}}の育成を図ること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["知識及び技能", "論理的", "言語活動", "実践的な能力と態度"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["思考力，判断力，表現力等", "論理的", "表現活動", "科学的な知識と技能"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["思考力，判断力，表現力等", "直感的", "言語活動", "実践的な能力と態度"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["思考力，判断力，表現力等", "論理的", "言語活動", "実践的な能力と態度"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "論理的な説明・記述による言語活動は思考力・判断力・表現力等の育成に，一連の問題解決と振り返りは実践的な能力と態度の育成につながる。" },
      { type: "text", text: "アの①は「思考力，判断力，表現力等」，イの③は「言語活動」，④は「実践的な能力と態度」，ウの②は「論理的」が正しい。単なる表現活動というだけでなく，考察・解釈・概念を筋道立てて説明する活動が位置付けられている。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節，第3款2（2）・（3）・本文195頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=197",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第1部 各学科に共通する教科『情報』 第2章 各科目 第1節 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ア（ア）コンピュータや外部装置の仕組みや特徴，コンピュータでの情報の内部表現と計算に関する限界について理解することでは，コンピュータの特性を踏まえて活用するために，コンピュータの基本的な構成や演算の仕組み，オペレーティングシステムによる{{①}}と入力装置や出力装置などのハードウェアを抽象化して扱う考え方，コンピュータ内部でのプログラムやデータの扱い方，値の範囲や精度について理解するようにする。その際，ソフトウェアはオペレーティングシステムの機能を利用して動作していること，コンピュータでは定められた{{②}}のデータが扱われ，表現できる値の範囲や精度が{{③}}であることで，計算結果は原理的に{{④}}を含む可能性があることなどを理解するようにする。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["資源の管理", "桁数", "無限", "誤差"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["資源の管理", "ビット数", "有限", "誤差"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["プログラムの翻訳", "ビット数", "有限", "誤差"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["資源の管理", "ビット数", "有限", "通信遅延"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "オペレーティングシステムは資源や入出力を管理する。コンピュータのデータ表現にはビット数による範囲・精度の限界があり，計算結果に誤差が含まれる可能性がある。" },
      { type: "text", text: "アは②が「ビット数」，③が「有限」となる。ウの①は「資源の管理」が正しく，ソースプログラムの翻訳はコンパイラ等の役割である。エの④は「誤差」であり，通信遅延はここで述べる数値表現の有限性に由来する誤差とは異なる。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部，第2章第1節「情報Ⅰ」2（3）ア（ア）・本文32頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=40",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科『情報』 第2章 専門教科情報科の各科目 第7節 ネットワークシステム」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ウ ネットワークの仮想化\n\nここでは，仮想ネットワークとして{{①}}などを取り上げ，ネットワークの仮想化に関する基本的な仕組みや働き，仮想化の概念，{{②}}との比較，情報資源を{{③}}することで，{{④}}が向上することなどについて扱う。また，VLANやVPNを構築するための技法について実習を通して扱うことが考えられる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["VLAN（Virtual LAN），VPN（Virtual Private Network）", "仮想ネットワークと物理ネットワーク", "論理的に分割や統合", "情報資源の効率的な活用と利便性"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["VLAN（Virtual LAN），VPN（Virtual Private Network）", "有線ネットワークと無線ネットワーク", "論理的に分割や統合", "情報資源の効率的な活用と利便性"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["LAN（Local Area Network），WAN（Wide Area Network）", "仮想ネットワークと物理ネットワーク", "物理的に増設や交換", "情報資源の効率的な活用と利便性"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["VLAN（Virtual LAN），VPN（Virtual Private Network）", "仮想ネットワークと物理ネットワーク", "論理的に分割や統合", "情報資源の可用性と機密性"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "VLANやVPNは仮想ネットワークの例である。物理ネットワークと比較し，情報資源を論理的に分割・統合することで，効率的な活用と利便性を高める。" },
      { type: "text", text: "イは②が「仮想ネットワークと物理ネットワーク」となる。ウのLAN・WANはネットワークの範囲による区分であり，③の物理的な増設・交換も，ここで示される仮想化の説明とは異なる。エの④は「情報資源の効率的な活用と利便性」が原文の語句である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部，第2章第7節，第2「内容とその取扱い」2（1）ウ・本文131頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=138",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "正方形に並べられた二次元配列Mの行と列を入れ替え，処理後のM[i][j]が処理前のM[j][i]となるようにしたい。" },
      { type: "text", text: "対角線の上側と下側にある対応要素を1回ずつ交換する，次のプログラムの空欄①・②に当てはまる組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。新たな二次元配列は作らず，交換には変数tempを使用する。" },
      { type: "text", text: "疑似コードはPythonを模した表記であり，配列の添字は0から始まる。インデントの深さが同じ部分を同一ブロックとする。反復の範囲は両端を含み，開始値が終了値を超えるときは実行しない。" },
      { type: "code", code: "01 M = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]\n02 n = 要素数(M)\n03 iを0からn-1まで1ずつ増やしながら繰り返す:\n04     jを①からn-1まで1ずつ増やしながら繰り返す:\n05         temp = M[i][j]\n06         M[i][j] = M[j][i]\n07         M[j][i] = ②\n08 表示する(M)" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["0", "temp"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["i+1", "M[i][j]"]] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["i+1", "temp"]] }], correct: true },
      { label: "エ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["0", "M[i][j]"]] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "jをi＋1から始めると，添字の組（0，1），（0，2），（1，2）の3組を1回ずつ交換する。一時変数tempには，上書き前の値を保持する。" },
      { type: "code", code: "処理前               処理後\n1 2 3                1 4 7\n4 5 6                2 5 8\n7 8 9                3 6 9" },
      { type: "text", text: "アは，同じ組を（i，j）と（j，i）で2回交換するため元に戻る。イは6行目で上書きされたM[i][j]を7行目にも代入し，交換前の値を失う。エは両方の誤りを含む。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第3章・学習14「応用的プログラム」，学習15「アルゴリズムの比較」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "二つの量的変数x，yについて，次の4組のデータを得た。相関係数と関係の説明の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "相関係数rは，x，yの平均値をそれぞれx̄，ȳとして，次の式で求めるものとする。和は4組全てのデータについて取る。" },
      { type: "code", code: "               Σ(xᵢ − x̄)(yᵢ − ȳ)\nr = ─────────────────────────────────\n       √{Σ(xᵢ − x̄)² × Σ(yᵢ − ȳ)²}" },
      { type: "table", headers: ["x", "1", "2", "3", "4"], rows: [["y", "4", "3", "1", "2"]] },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "text", text: "相関係数は−0.8であり，負の相関がある。" }], correct: true },
      { label: "イ", content_blocks: [{ type: "text", text: "相関係数は−0.4であり，負の相関がある。" }], correct: false },
      { label: "ウ", content_blocks: [{ type: "text", text: "相関係数は0.8であり，正の相関がある。" }], correct: false },
      { label: "エ", content_blocks: [{ type: "text", text: "相関係数は−1であり，完全な負の相関がある。" }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "x，yの平均値は共に2.5である。" },
      { type: "table", headers: ["x", "y", "x−x̄", "y−ȳ", "（x−x̄）²", "（y−ȳ）²", "偏差の積"], rows: [["1", "4", "−1.5", "1.5", "2.25", "2.25", "−2.25"], ["2", "3", "−0.5", "0.5", "0.25", "0.25", "−0.25"], ["3", "1", "0.5", "−1.5", "0.25", "2.25", "−0.75"], ["4", "2", "1.5", "−0.5", "2.25", "0.25", "−0.75"], ["合計", "—", "0", "0", "5", "5", "−4"]] },
      { type: "code", code: "r = −4 / √(5 × 5) = −0.8" },
      { type: "text", text: "イの−0.4は，分母を√（5×5）ではなく5＋5としたときの値である。ウは符号を取り違えている。エの完全な負の相関は全ての点が右下がりの一直線上にある場合であり，この4点はその条件を満たさない。" },
    ],
    source_text: "総務省統計局「複数の変数の関係性を見る」 | https://www.stat.go.jp/naruhodo/10_tokucho/hukusu.html\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第4章・学習22（2）・本文186頁 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=34",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験13は問1〜20を順番に登録してください"
end

questions.each do |question|
  expected_category = case question.fetch(:question_number)
  when 1, 2 then "education_foundations"
  when 6 then "curriculum_organization"
  when 7 then "curriculum_organization"
  when 8 then "integrated_inquiry"
  when 9 then "moral_education"
  when 10 then "special_activities"
  when 11 then "student_guidance_career"
  when 12 then "special_support_education"
  when 13, 14 then "educational_psychology"
  when 16..18 then %w[information_education information_specialized information_specialized][question.fetch(:question_number) - 16]
  when 19, 20 then "information_specialized"
  else "education_system"
  end
  expected_major_category = question.fetch(:question_number) >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major_category
    raise "模擬試験13 問#{question.fetch(:question_number)}の大分類が不正です"
  end
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験13 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験13 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    if blank_labels.empty?
      table_text = question.fetch(:content_blocks).select { |block| block[:type] == "table" }.flat_map { |block| block.fetch(:rows).flatten }.join("\n")
      blank_labels = table_text.scan(/[①②③④]/).uniq
    end
    expected_blank_labels = question.fetch(:question_number) == 11 ? %w[① ② ③] : %w[① ② ③ ④]
    unless blank_labels == expected_blank_labels && choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
      raise "模擬試験13 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    if (3..5).cover?(question.fetch(:question_number)) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験13 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験13 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, section = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, "第1部"] : [3, "第2部"]
  elsif prompt.include?("第2章 第10節")
    [0, "第2章第10節"]
  else
    [1, "第3章第7節"]
  end
  unless prompt.include?(section.gsub(/第(\d+)章第(\d+)節/, '第\1章 第\2節')) && source.include?(section) &&
      prompt.include?("解説 情報編") == source.include?("解説 情報編")
    raise "模擬試験13 問#{question.fetch(:question_number)}の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "模擬試験13の問16〜18は指定4範囲から異なる3範囲を資料順に並べてください"
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験13の正答位置はア〜エ各5問にしてください"
end

(6..10).each do |number|
  question = questions.fetch(number - 1)
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && prompt.fetch(:text).include?("からの抜粋である。")
    raise "模擬試験13 問#{number}は原文穴埋め問題にしてください"
  end
end
question_6 = questions.fetch(5)
unless question_6.fetch(:content_blocks).first.fetch(:text).include?("第3款 教育課程の実施と学習評価") && question_6.fetch(:source_text).include?("第1章第3款")
  raise "模擬試験13 問6の出典は第1章総則第3款にしてください"
end

QuestionSeedSync.import(exam_number: 13, questions: questions, publication_status: "published")

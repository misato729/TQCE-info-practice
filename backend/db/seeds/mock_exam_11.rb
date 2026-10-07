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

# 模擬試験11（全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の①～④は，日本の教育史上の教育施設又は制度に関する記述である。年代の古いものから順に配列したものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。\n\n①　文部省は，「学制」の公布に先立って東京に師範学校を設置し，米国人教師スコットの指導により米国の教授法を導入するとともに，小学校の教育課程や教科書の編纂にも当たらせた。\n\n②　石上宅嗣は，自邸の一部に芸亭を設けて経書などの蔵書を置き，好学の徒に閲覧を許した。これは我が国における公開図書館の先駆とされる。\n\n③　岡山藩主池田光政は，庶民教育のために閑谷学校を設けた。同校では，武士だけを対象とした藩校とは異なり，庶民にも学問の機会が開かれた。\n\n④　北条実時は，金沢に和漢の典籍を収集した文庫を設けた。この文庫は，後に金沢文庫と呼ばれるようになった。"),
    ],
    choices: [
      text_choice.call("ア", "② → ③ → ④ → ①"),
      text_choice.call("イ", "④ → ② → ③ → ①"),
      text_choice.call("ウ", "② → ④ → ① → ③"),
      text_choice.call("エ", "② → ④ → ③ → ①", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。②の芸亭は奈良時代後期に設けられました。④の金沢文庫は鎌倉時代の13世紀後半に北条実時によって設けられました。③の閑谷学校は江戸時代前期の1670（寛文10）年に池田光政が設置を命じました。①の師範学校は1872（明治5）年，「学制」の公布に先立って東京に設置されました。したがって，②→④→③→①となります。アは，江戸時代の閑谷学校を鎌倉時代の金沢文庫より前に置いています。イは，鎌倉時代の金沢文庫を奈良時代の芸亭より前に置いています。ウは，明治期の師範学校を江戸時代の閑谷学校より前に置いています。"),
    ],
    source_text: "文部科学省『学制百二十年史』第四節『教員及び教員養成』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318234.htm
国立国会図書館レファレンス協同データベース『芸亭』 | https://crd.ndl.go.jp/reference/entry/index.php?id=1000109396&page=ref_view
神奈川県『神奈川県立金沢文庫』 | https://www.pref.kanagawa.jp/docs/u6p/prs/r1013650.html
岡山県教育委員会『閑谷学校創学350年記念式典・記念講演を開催しました』 | https://www.pref.okayama.jp/site/182/684141.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("コメニウスの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『大教授学』において，すべての人に広く教育を施すための学校制度と教授方法を構想した。また，『世界図絵』では，事物・絵・言葉を結び付け，感覚を通して理解させる方法を具体化した。", true),
      text_choice.call("イ", "教育の主要な目的を，社会生活を営む紳士の形成に置き，家庭教師による個別教育を重視した。知識の注入よりも，身体の鍛錬，徳の形成及び習慣づくりを優先した。"),
      text_choice.call("ウ", "『エミール』において，子どもの自然な発達段階に即して教育することを主張し，大人の価値観や知識を早期に教え込むことを避ける消極教育を説いた。"),
      text_choice.call("エ", "幼児期における遊びと自己活動を重視して幼稚園を創設し，球や積み木などからなる恩物を用いて，子どもの内的な力を発達させようとした。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。コメニウスは『大教授学』で普遍的な教育と組織的な教授方法を構想し，『世界図絵』では絵と語を対応させた直観的な学習を具体化しました。イはロックの教育思想です。ロックは『教育論』で，家庭における紳士教育，身体の鍛錬，徳や習慣の形成を重視しました。ウはルソーの教育思想です。『エミール』と消極教育はルソーに対応します。エはフレーベルの教育実践です。幼稚園の創設，遊び，自己活動及び恩物はフレーベルの主要な業績です。"),
    ],
    source_text: "筑波大学附属図書館『近代教育学の源流―コメニウスからフレーベルまで―』 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/genryu.PDF
国立国会図書館『コメニウス「世界図絵」』 | https://ndlsearch.ndl.go.jp/rnavi/children/post_237
国立国会図書館サーチ『コメニウス著作の日本語訳』 | https://ndlsearch.ndl.go.jp/search?cs=bib&from=0&q-author=%2200436418%22&size=20",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，正しいものを一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      text_choice.call("ア", "第4条第3項は，奨学の措置を講ずる対象を「学習意欲があるにもかかわらず，経済的理由によって修学が困難な者」とし，国及び地方公共団体にその措置を求めている。"),
      text_choice.call("イ", "第9条は，研究と修養に励むことについては法律に定める学校の教員を対象とし，身分の尊重と待遇の適正については国公立学校の教員を対象として定めている。"),
      text_choice.call("ウ", "第8条は，私立学校の公の性質と学校教育における重要な役割を踏まえ，国及び地方公共団体が，その自主性を尊重しつつ，助成その他の適当な方法によって私立学校教育の振興に努めることを定めている。", true),
      text_choice.call("エ", "第16条は，国の役割として地域の実情に応じた教育施策の策定と実施を定め，地方公共団体の役割として全国的な教育の機会均等と教育水準の維持向上を定めている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：誤り。第4条第3項の文言は「能力があるにもかかわらず，経済的理由によって修学が困難な者」であり，「学習意欲があるにもかかわらず」ではない。"),
      text_block.call("イ：誤り。第9条第2項の「前項の教員」は，第1項の「法律に定める学校の教員」を指す。身分の尊重や待遇の適正等について，国公立学校の教員に対象を絞っていない。"),
      text_block.call("ウ：正しい。私立学校の公の性質を認めることと，その自主性を尊重することを併せて規定している。"),
      text_block.call("エ：誤り。国と地方公共団体の役割が逆である。国は全国的な機会均等と教育水準の維持向上を，地方公共団体は地域の実情に応じた教育の振興を担う。"),
    ],
    source_text: "教育基本法・第4条、第8条、第9条、第16条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第51条\n高等学校における教育は、前条に規定する目的を実現するため、次に掲げる目標を達成するよう行われるものとする。\n\n一　{{①}}として行われる普通教育の成果を更に発展拡充させて、豊かな人間性、創造性及び健やかな身体を養い、国家及び社会の{{②}}として必要な資質を養うこと。\n\n二　社会において果たさなければならない{{③}}に基づき、個性に応じて将来の進路を決定させ、{{④}}を高め、専門的な知識、技術及び技能を習得させること。\n\n三　個性の確立に努めるとともに、社会について、広く深い理解と健全な批判力を養い、社会の発展に寄与する態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["義務教育", "形成者", "勤労の尊重", "幅広い知識と教養"]),
      fill_in_choice.call("イ", ["義務教育", "形成者", "使命の自覚", "一般的な教養"], true),
      fill_in_choice.call("ウ", ["中学校教育", "構成員", "使命の自覚", "一般的な教養"]),
      fill_in_choice.call("エ", ["中学校教育", "構成員", "勤労の尊重", "幅広い知識と教養"]),
    ],
    explanation_blocks: [
      text_block.call("第1号では「義務教育」の成果の発展拡充と，国家及び社会の「形成者」としての資質を，第2号では「使命の自覚」に基づく進路決定と「一般的な教養」の向上を規定している。"),
      text_block.call("ア：③は「使命の自覚」，④は「一般的な教養」が正しい。"),
      text_block.call("ウ：①は「義務教育」，②は「形成者」が正しい。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "学校教育法・第51条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の3\n公立の小学校等の校長及び教員の{{①}}は、{{②}}を参酌し、その地域の実情に応じ、当該校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する{{③}}（以下この章において「{{③}}」という。）を定めるものとする。\n\n2　公立の小学校等の校長及び教員の{{①}}は、{{③}}を定め、又はこれを変更しようとするときは、第二十二条の七第一項に規定する{{④}}において協議するものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "指針", "指標", "教育委員会"]),
      fill_in_choice.call("イ", ["任命権者", "教育振興基本計画", "教員研修計画", "協議会"]),
      fill_in_choice.call("ウ", ["研修実施者", "教育振興基本計画", "教員研修計画", "教育委員会"]),
      fill_in_choice.call("エ", ["任命権者", "指針", "指標", "協議会"], true),
    ],
    explanation_blocks: [
      text_block.call("文部科学大臣が定める「指針」を参酌し，任命権者が地域の実情等に応じた「指標」を定める。その策定・変更に当たっては，法定の「協議会」において協議する。"),
      text_block.call("ア：①は「任命権者」，④は「協議会」が正しい。"),
      text_block.call("イ：②は「指針」，③は「指標」が正しい。「教員研修計画」は，第22条の4に規定された別の計画である。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条の2〜第22条の4、第22条の7 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒のよい点や進歩の状況などを{{①}}に評価し，学習したことの意義や価値を実感できるようにすること。また，各教科・科目等の目標の実現に向けた{{②}}を把握する観点から，{{③}}を見通しながら評価の場面や方法を工夫して，学習の過程や成果を評価し，指導の改善や学習意欲の向上を図り，{{④}}の育成に生かすようにすること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["積極的", "学習状況", "単元や題材など内容や時間のまとまり", "学習習慣"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["客観的", "学習実態", "各学期の授業時数と内容の配列", "資質・能力"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["積極的", "学習状況", "単元や題材など内容や時間のまとまり", "資質・能力"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["客観的", "学習実態", "単元や題材など内容や時間のまとまり", "学習習慣"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "よい点や進歩を「積極的」に評価し，目標の実現に向けた「学習状況」を把握します。評価は単元や題材などのまとまりを見通して行い，「資質・能力」の育成に生かします。アは④，イは①・②・③，エは①・②・④が原文と異なります。「客観的」な評価を否定する問題ではなく，引用箇所の語句を問う問題です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款2（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "career_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が，学ぶことと自己の将来とのつながりを見通しながら，{{①}}に向けて必要な基盤となる資質・能力を身に付けていくことができるよう，{{②}}を要としつつ各教科・科目等の特質に応じて，{{③}}の充実を図ること。その中で，生徒が自己の在り方生き方を考え{{④}}に進路を選択することができるよう，学校の教育活動全体を通じ，組織的かつ計画的な進路指導を行うこと。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["社会的・職業的自立", "特別活動", "キャリア教育", "主体的"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["社会的・職業的自立", "総合的な探究の時間", "キャリア教育", "主体的"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["経済的・精神的自立", "特別活動", "職業教育", "自主的"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["社会的・職業的自立", "総合的な探究の時間", "職業教育", "自主的"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "キャリア教育では，社会的・職業的自立に必要な基盤となる資質・能力を育てます。その要となるのは特別活動であり，進路は生徒が主体的に選択できるようにします。イは②が異なります。ウは①・③・④，エは②・③・④が原文と異なり，特に「キャリア教育」を「職業教育」へ置き換えている点に注意が必要です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款1（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（2）{{①}}の作成に当たっては，{{②}}との関連の下に，目標及び内容，学習活動，指導方法や指導体制，{{③}}の計画などを示すこと。\n\n（3）目標を実現するにふさわしい探究課題を設定するに当たっては，{{④}}を生かすことができるよう配慮すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["全体計画及び年間指導計画", "各教科・科目の指導計画", "学習の評価", "生徒の多様な課題に対する意識"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["全体計画及び年間指導計画", "学校における全教育活動", "学習の評価", "生徒の多様な課題に対する意識"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["単元計画及び各時間の指導案", "学校における全教育活動", "学習の評価", "教師の専門分野に関する課題意識"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["全体計画及び年間指導計画", "学校における全教育活動", "学校の自己評価", "教師の専門分野に関する課題意識"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "全体計画・年間指導計画は，学校の全教育活動と関連付け，学習の評価も含めて作成します。探究課題の設定では，生徒の多様な課題意識を生かします。アは関連付ける範囲を各教科・科目の指導計画としている点，ウは計画の種類と課題意識の主体，エは評価の対象と課題意識の主体が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第4章第3の1（2）・（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育は，教育基本法及び学校教育法に定められた教育の根本精神に基づき，生徒が自己探求と自己実現に努め{{①}}に基づき行為しうる{{②}}にあることを考慮し，人間としての在り方生き方を考え，主体的な判断の下に行動し，{{③}}として{{④}}ための基盤となる道徳性を養うことを目標とすること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["国家・社会の一員としての自覚", "学習の段階", "自立した人間", "他者と共によりよく生きる"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["集団の成員としての役割", "発達の段階", "社会に適応した人間", "自己の能力を最大限に発揮する"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["国家・社会の一員としての自覚", "発達の段階", "社会に適応した人間", "自己の能力を最大限に発揮する"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["国家・社会の一員としての自覚", "発達の段階", "自立した人間", "他者と共によりよく生きる"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "生徒の発達段階を踏まえ，国家・社会の一員としての自覚に基づく行為と主体的な判断を重視します。目標は，自立した人間として他者と共によりよく生きるための道徳性を養うことです。アは②，イは①・③・④，ウは③・④が異なります。原文の目標を，社会への適応や自己の能力の発揮に置き換えないことが論点です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第1款2（2）第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ホームルーム活動における生徒の{{①}}な活動を中心として，各活動と学校行事を{{②}}ながら，個々の生徒についての理解を深め，教師と生徒，生徒相互の信頼関係を育み，{{③}}の充実を図ること。その際，特に，いじめの未然防止等を含めた{{④}}との関連を図るようにすること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["自発的，自治的", "相互に関連付け", "ホームルーム経営", "生徒指導"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["自主的，実践的", "相互に関連付け", "ホームルーム経営", "道徳教育"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["自発的，自治的", "段階的に位置付け", "生徒会活動", "生徒指導"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["自主的，実践的", "段階的に位置付け", "生徒会活動", "道徳教育"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "ここではホームルーム活動の「自発的，自治的」な活動を中心に，各活動と学校行事を相互に関連付けます。信頼関係を育むホームルーム経営と，いじめの未然防止を含む生徒指導との関連が論点です。イは①・④，ウは②・③，エは全ての空欄が異なります。「自主的，実践的」も特別活動の重要な特質ですが，①の原文とは区別します。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第5章第3の1（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=483",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒指導において発達を支えるとは、児童生徒の心理面（自信・自己肯定感等）の発達のみならず、学習面（興味・関心・学習意欲等）、社会面（人間関係・集団適応等）、進路面（進路意識・将来展望等）、健康面（生活習慣・メンタルヘルス等）の発達を含む包括的なものです。\n\nまた、生徒指導の目的を達成するためには、児童生徒一人一人が自己指導能力を身に付けることが重要です。児童生徒が、深い{{①}}に基づき、「何をしたいのか」、「何をするべきか」、主体的に問題や課題を発見し、自己の目標を選択・設定して、この目標の達成のため、{{②}}、かつ、{{③}}を尊重しながら、自らの行動を決断し、実行する力、すなわち、「自己指導能力」を獲得することが目指されます。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己評価", "自発的、自律的", "他者の主体性"]),
      fill_in_choice.call("イ", ["自己理解", "自発的、自律的", "他者の主体性"], true),
      fill_in_choice.call("ウ", ["自己理解", "自覚的、協調的", "集団の規範"]),
      fill_in_choice.call("エ", ["自己評価", "自覚的、協調的", "他者の主体性"]),
    ],
    explanation_blocks: [
      text_block.call("自己指導能力では、深い「自己理解」に基づいて目標を選択・設定し、「自発的、自律的」に、かつ「他者の主体性」を尊重しながら行動を決断・実行することが重視されています。"),
      text_block.call("ア：①が異なります。原文は「自己評価」ではなく「自己理解」です。自己のよさや可能性、関心などを理解することを基盤としています。"),
      text_block.call("ウ：②と③が異なります。原文は「自発的、自律的」「他者の主体性」であり、集団への協調や規範への適合を中心に定義しているわけではありません。"),
      text_block.call("エ：①と②が異なります。自己評価や協調性も教育上の意味を持ちますが、この定義の語句とは一致しません。"),
    ],
    source_text: "文部科学省『生徒指導提要』第1章1.1.1（2）「生徒指導の目的」、本文13ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=16",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("聴覚障害のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "聞こえの状態を把握する際には，音を検出できる程度を調べ，その結果を，言葉の聞き分けや文章の理解の程度として評価する。これに基づいて言語面の指導課題を設定する。"),
      text_choice.call("イ", "音を弁別する力とは，聞いた語句を用いて出来事の因果関係を説明する力をいう。このため，身近な出来事について話す活動を通して，音の弁別の程度を把握する。"),
      text_choice.call("ウ", "発話が明瞭である場合にも，文の理解や抽象的な語彙の理解などを把握する必要がある。言葉の指導では，聴覚や視覚的な情報を活用し，言葉とその背景となる概念とを結び付ける。", true),
      text_choice.call("エ", "補聴器や人工内耳の活用と視覚的な情報の活用を組み合わせる。その際，発音の明瞭さを主な基準として，文字や手話による情報保障の必要性を判断する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：音の検出，音の聞き分け，言葉や文章の理解は区別して把握します。音を検出できる程度から，言語理解の程度をそのまま評価することはできません。"),
      text_block.call("イ：音の弁別は，音を聞き分けることです。出来事の因果関係を言葉で説明することは，言語による思考や表現に関わります。"),
      text_block.call("ウ：適切です。発話できることと，語彙や文の意味を十分に理解していることは同じではありません。言葉の習得には，その背景となる概念の形成も重要です。"),
      text_block.call("エ：発音の明瞭さだけでは，聞き取りや理解の困難さを把握できません。障害の状態，言語発達，使用する手段の特徴などを踏まえて情報保障を検討します。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』Ⅱ「聴覚障害」―聞こえの把握，言葉の習得と概念の形成，コミュニケーション手段の選択 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_06.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エリクソンの心理社会的発達理論における青年期と，それに続く成人前期の発達に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "青年期には，同一性対同一性拡散という心理社会的危機が中心となる。成人前期には，自分の同一性を保ちながら他者と深く関わる親密性が課題となり，その対極に孤立が位置付けられる。", true),
      text_choice.call("イ", "青年期には，自分が何者であるかを問い，同一性対孤立という危機に取り組む。成人前期には，他者との関係を深める親密性対同一性拡散という危機に取り組む。"),
      text_choice.call("ウ", "児童期には，課題への取組を通して勤勉性対劣等感という危機に取り組む。青年期には，社会的役割を選択するための自律性対恥・疑惑という危機が中心となる。"),
      text_choice.call("エ", "青年期には，それまでの経験や社会的役割を統合して同一性を形成する。成人前期には，次世代の育成や社会への貢献を中心とする生殖性対停滞という危機に取り組む。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。青年期の同一性と，成人前期の親密性の関係を正しく示しています。親密性は，自己を失って相手に合わせることとは異なります。"),
      text_block.call("イ：危機の対極が入れ替わっています。青年期は「同一性対同一性拡散」，成人前期は「親密性対孤立」です。"),
      text_block.call("ウ：児童期の説明は適切ですが，「自律性対恥・疑惑」は幼児期前期の危機です。青年期の中心は同一性の形成です。"),
      text_block.call("エ：青年期の説明は適切ですが，「生殖性対停滞」は成人前期より後の成人期に位置付けられます。成人前期の中心は親密性です。"),
    ],
    source_text: "東京未来大学・島内晶「旅立ちのとき～エリクソンの発達課題が示すもの～」 | https://www.tokyomirai.ac.jp/future/shimanouchi/shimanouchi-893/\n人間環境大学「発達心理学」公開シラバス―心理社会的発達理論 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PS30101&jn=2022",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("スキナーのプログラム学習に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "細かく構成した教材で学習者に反応を求めるとともに，手本となる他者が報酬を受けることの観察を，学習者の反応を強める中心的な仕組みとして位置付ける。"),
      text_choice.call("イ", "学習者が各段階で反応し，その正否をすぐ確認できる教材を用いる。教材の有効性は，未学習の学習者に試用してもらい，実際の到達状況を基に検証し，改善する。", true),
      text_choice.call("ウ", "学習者がなるべく失敗しないように細かい学習段階を設定する。反応に対する正否の通知は，一連の教材の学習を終了した時点でまとめて行うことを基本とする。"),
      text_choice.call("エ", "教材は，学習者の反応を引き出すように構成する。その有効性は，難易度と提示順序に関する専門家の判定を，未学習者の到達状況に代わる基準として確かめる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：他者が報酬を受けることの観察は，バンデューラの代理強化に関する説明です。スキナーのプログラム学習では，学習者自身の反応と，それに対する即時の確認が重視されます。"),
      text_block.call("イ：適切です。積極的反応，即時確認，学習者検証の原理に対応しています。"),
      text_block.call("ウ：前半はスモールステップの原理に対応します。しかし，正否は教材の終了時にまとめてではなく，反応後にすぐ確認できるようにします。"),
      text_block.call("エ：専門家による吟味にも意義がありますが，学習者検証の原理では，実際に学習が成立したかを学習者の試用結果で確かめます。"),
    ],
    source_text: "熊本大学公開科目『基盤的教育論』・「プログラム学習とティーチングマシン」 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/3Block/07/07-1_text.html\n熊本大学公開科目『基盤的教育論』・「プログラム学習の5原則」 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/3Block/07/07-2_text.html\n熊本大学公開科目『基盤的教育論』・「代理強化」 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/3Block/07/07-3_text.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「連携・分担による学校マネジメント」に関する説明である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "事務職員が校務運営に参画する機会を拡大し，財務・総務等の専門性を生かす。教師の業務を適正化するため，校内の各種委員会を課題ごとに新設・細分化し，それぞれの担当と責任を明確にすることが求められる。"),
      text_choice.call("イ", "コミュニティ・スクールの設置は義務であり，地域学校協働本部の整備と併せて進めることが求められる。保護者や地域住民等の学校運営への参加・参画を得ながら，学校・家庭・地域がそれぞれの役割と責任を果たす体制を構築する。"),
      text_choice.call("ウ", "保護者やPTA，地域の関係機関と学校との連携・協働を進め，多様性のあるチームによる学校を実現する。その際，学校・家庭・地域の役割分担は，各学校が主体となって推進し，文部科学省は後方支援に徹することが求められる。"),
      text_choice.call("エ", "校長のリーダーシップの下，主幹教諭や指導教諭などのミドルリーダーが力を発揮できる組織運営を促進する。家庭や地域との連携・協働を教育課程に関連付け，組織的かつ計画的に教育活動の質の向上を図ることが重要である。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：事務職員の校務運営への参画と専門性の活用は適切です。しかし，教師の業務の適正化に向けて答申が挙げているのは，各種委員会の「整理・統合」等であり，「新設・細分化」ではありません。"),
      text_block.call("イ：設置の位置付けが誤りです。答申はコミュニティ・スクールの設置を「努力義務」としています。地域学校協働本部の整備や，保護者・地域住民の参加・参画に関する部分は適切です。"),
      text_block.call("ウ：文部科学省の役割が誤りです。答申は，学校・家庭・地域の役割分担を「文部科学省が前面に立って強力に推進する」としています。後方支援に徹するという位置付けではありません。"),
      text_block.call("エ：適切です。経験豊富で専門性の高いミドルリーダーが力を発揮する組織運営と，教育課程に関連付けたカリキュラム・マネジメントの双方が示されています。"),
    ],
    source_text: "中央教育審議会『令和の日本型学校教育』答申・第Ⅰ部 総論4（2）「連携・分担による学校マネジメントを実現する」・本文25〜26頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=30",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第2章 第10節 情報 第2款 各科目 第1 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（4）情報通信ネットワークとデータの活用\n\n情報通信ネットワークを介して流通するデータに着目し，情報通信ネットワークや情報システムにより提供されるサービスを活用し，問題を発見・解決する活動を通して，次の事項を身に付けることができるよう指導する。\n\nア 次のような知識及び技能を身に付けること。\n\n（ｱ）情報通信ネットワークの仕組みや{{①}}，{{②}}の役割及び{{③}}を確保するための方法や技術について理解すること。\n\n（ｲ）データを蓄積，管理，提供する方法，情報通信ネットワークを介して情報システムがサービスを提供する仕組みと特徴について理解すること。\n\n（ｳ）データを表現，蓄積するための表し方と，データを{{④}}する方法について理解し技能を身に付けること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["構成要素", "データモデル", "情報セキュリティ", "収集，整理，分析"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["構成要素", "プロトコル", "情報の信頼性", "蓄積，管理，提供"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["構成要素", "プロトコル", "情報セキュリティ", "収集，整理，分析"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["処理手順", "プロトコル", "情報セキュリティ", "蓄積，管理，提供"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "通信の規約であるプロトコルの役割と，情報セキュリティを確保する方法・技術を扱う。データの分析に至る過程は「収集，整理，分析」である。" },
      { type: "text", text: "アの②は「プロトコル」が正しい。イは③が「情報セキュリティ」，④が「収集，整理，分析」となる。エは①が「構成要素」，④が「収集，整理，分析」となる。「蓄積，管理，提供」は，抜粋の（ｲ）に示されたデータ管理・サービス提供に関する語句である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節，第2款第1「情報Ⅰ」2（4）ア・本文191〜192頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=193",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第3章 第7節 情報 第2款 各科目 第3 情報の表現と管理 3 内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）内容を取り扱う際には，次の事項に配慮するものとする。\n\nア 実習を通して，{{①}}を積極的に活用して{{②}}に表現しようとする主体的かつ協働的な態度を養うことができるよう留意して指導すること。\n\nイ 生徒や地域の実態，学科の特色等に応じて，具体的な課題を設定し，グループ活動を行うことなどを通して，{{③}}，{{④}}などについて考察するよう留意して指導すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["情報通信機器や情報技術", "創造的", "情報共有の有効性や情報管理の重要性", "個人及び組織の責任"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["情報通信機器や情報技術", "創造的", "情報共有の公平性や情報管理の効率性", "個人及び組織の責任"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["統計資料やデータベース", "論理的", "情報共有の有効性や情報管理の重要性", "個人及び組織の責任"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["情報通信機器や情報技術", "創造的", "情報共有の有効性や情報管理の重要性", "情報提供者及び利用者の権利"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "実習による創造的な表現と，グループ活動を通した情報共有・情報管理・責任の考察が位置付けられている。" },
      { type: "text", text: "イの③は「情報共有の有効性や情報管理の重要性」が正しい。ウは①が「情報通信機器や情報技術」，②が「創造的」となる。エの④は「個人及び組織の責任」となる。権利も関連する論点だが，この規定が考察させる事項は責任である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節，第2款第3「情報の表現と管理」3（1）ア・イ・本文409〜410頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=411",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第1部 各学科に共通する教科『情報』 第2章 各科目 第1節 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "例えば，道路標識やトイレの場所などを示すサイン，Webページなどの情報デザインを取り上げ，情報を{{①}}する方法としてアイコン，ピクトグラム，ダイヤグラム，地図のモデル化など，情報を{{②}}する方法として表，図解，グラフなど，情報を{{③}}する方法として，文字の配置，ページレイアウト，Webサイトの階層構造，ハイパーリンクなどを扱うことが考えられる。その際，全体を把握した上で，構成要素間の関係を分かりやすく整理することが大切である。更に，全ての人に伝わりやすい情報デザインの工夫を取り上げ，ユニバーサルデザイン，ユーザビリティ，アクセシビリティや環境の様々な要素が人の動作などに働きかけるシグニファイアなどを扱うことが考えられる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["構造化", "可視化", "抽象化"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["可視化", "抽象化", "構造化"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["抽象化", "構造化", "可視化"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["抽象化", "可視化", "構造化"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "対象の特徴を簡潔な記号やモデルで表すのが抽象化，表・図解・グラフで見える形にするのが可視化，配置・階層・リンクによって要素間の関係を整理するのが構造化である。" },
      { type: "text", text: "アは①と③，イは①と②，ウは②と③を取り違えている。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部，第2章第1節「情報Ⅰ」2（2）イ（イ）・本文29〜30頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=37",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "同じ値が連続する部分を，［値，連続する個数］という一つのペアに置き換えるプログラムを作成した。例えば，［3，3，1］は［［3，2］，［1，1］］に置き換わる。" },
      { type: "text", text: "この方法を実装するため，次のプログラムの9行目の空欄①と，11行目に加える処理②の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "疑似コードはPythonを模した表記であり，配列の添字は0から始まる。インデントの深さが同じ部分を同一ブロックとする。反復の範囲は両端を含む。" },
      { type: "code", code: "01 Data = [2, 2, 2, 5, 5, 1, 2, 2]\n02 n = 要素数(Data)\n03 Pairs = []\n04 count = 1\n05 iを1からn-1まで1ずつ増やしながら繰り返す:\n06     もし Data[i] == Data[i-1] ならば:\n07         count = count + 1\n08     そうでなければ:\n09         Pairsの末尾に[①, count]を追加する\n10         count = 1\n11 ②\n12 表示する(Pairs)" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["Data[i]", "Pairsの末尾に[Data[n-1], count]を追加する"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["Data[i-1]", "Pairsの末尾に[Data[n-1], 1]を追加する"]] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["Data[i-1]", "Pairsの末尾に[Data[n-1], count]を追加する"]] }], correct: true },
      { label: "エ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["Data[i]", "Pairsの末尾に[Data[n-1], 1]を追加する"]] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "異なる値に変わった時点のcountは，直前の値Data[i-1]の連続個数である。最後の連続部分には次の異なる値が現れないため，反復終了後に保存する。" },
      { type: "code", code: "連続部分       保存するペア\n2,2,2          [2,3]\n5,5            [5,2]\n1              [1,1]\n2,2            [2,2]\n\n出力：[[2,3],[5,2],[1,1],[2,2]]" },
      { type: "text", text: "アは，新しく現れたData[i]を直前の連続個数と組み合わせてしまう。イは，最後の2の連続個数を1としてしまう。エは両方の誤りを含む。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第3章・学習13「基本的プログラム」，学習14「応用的プログラム」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "12人について，ある1週間に図書館で借りた本の冊数を調べたところ，次の度数表を得た。中央値，第1四分位数，第3四分位数及び最頻値の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "ここでは，データを小さい順に並べ，全体の中央値は6番目と7番目の値の平均とする。第1四分位数は下位6個の中央値，第3四分位数は上位6個の中央値とする。" },
      { type: "table", headers: ["冊数", "0", "1", "2", "3", "4"], rows: [["人数", "2", "4", "3", "2", "1"]] },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["中央値", "第1四分位数", "第3四分位数", "最頻値"], rows: [["2", "1", "3", "2"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["中央値", "第1四分位数", "第3四分位数", "最頻値"], rows: [["1.5", "1", "2.5", "1"]] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["中央値", "第1四分位数", "第3四分位数", "最頻値"], rows: [["1.5", "0.5", "3", "2"]] }], correct: false },
      { label: "エ", content_blocks: [{ type: "table", headers: ["中央値", "第1四分位数", "第3四分位数", "最頻値"], rows: [["2", "0.5", "2.5", "1"]] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "度数を展開すると，次のようになる。" },
      { type: "code", code: "順位： 1  2  3  4  5  6 | 7  8  9 10 11 12\n冊数： 0  0  1  1  1  1 | 2  2  2  3  3  4\n\n中央値       = (1 + 2) / 2 = 1.5\n第1四分位数 = (1 + 1) / 2 = 1\n第3四分位数 = (2 + 3) / 2 = 2.5\n最頻値       = 1（度数4で最多）" },
      { type: "text", text: "イが正しい。アは中央値・第3四分位数・最頻値が誤り。全体と上位半分について中央の2値を平均するので，それぞれ1.5と2.5となる。最頻値は度数4の1冊であり，2冊の度数は3である。ウは第1四分位数・第3四分位数・最頻値が誤り。下位6個の3番目と4番目はいずれも1なので第1四分位数は1，上位6個の中央2値は2と3なので第3四分位数は2.5である。エは中央値と第1四分位数が誤りであり，それぞれ1.5と1になる。" },
    ],
    source_text: "総務省統計局『なるほど統計学園』「中心的な傾向を捉える」 | https://www.stat.go.jp/naruhodo/5_tokucho/chushin.html\n総務省統計局『なるほど統計学園』「データの散らばりを捉える」 | https://www.stat.go.jp/naruhodo/5_tokucho/chirabari.html\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第4章・学習22（1）・本文185頁 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=33",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験11は問1〜20を順番に登録してください"
end

questions.each do |question|
  expected_category = case question.fetch(:question_number)
  when 1, 2 then "education_foundations"
  when 6 then "curriculum_organization"
  when 7 then "career_education"
  when 8 then "integrated_inquiry"
  when 9 then "moral_education"
  when 10 then "special_activities"
  when 11 then "student_guidance_career"
  when 12 then "special_support_education"
  when 13, 14 then "educational_psychology"
  when 16..18 then %w[information_specialized information_education information_specialized][question.fetch(:question_number) - 16]
  when 19, 20 then "information_specialized"
  else "education_system"
  end
  expected_major_category = question.fetch(:question_number) >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major_category
    raise "模擬試験11 問#{question.fetch(:question_number)}の大分類が不正です"
  end
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験11 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験11 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    if blank_labels.empty?
      table_text = question.fetch(:content_blocks).select { |block| block[:type] == "table" }.flat_map { |block| block.fetch(:rows).flatten }.join("\n")
      blank_labels = table_text.scan(/[①②③④]/).uniq
    end
    expected_blank_labels = [11, 18].include?(question.fetch(:question_number)) ? %w[① ② ③] : %w[① ② ③ ④]
    unless blank_labels == expected_blank_labels && choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
      raise "模擬試験11 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    if (3..5).cover?(question.fetch(:question_number)) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験11 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験11 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
    raise "模擬試験11 問#{question.fetch(:question_number)}の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "模擬試験11の問16〜18は指定4範囲から異なる3範囲を資料順に並べてください"
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験11の正答位置はア〜エ各5問にしてください"
end

(6..10).each do |number|
  question = questions.fetch(number - 1)
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && prompt.fetch(:text).include?("からの抜粋である。")
    raise "模擬試験11 問#{number}は原文穴埋め問題にしてください"
  end
end
question_6 = questions.fetch(5)
unless question_6.fetch(:content_blocks).first.fetch(:text).include?("第3款 教育課程の実施と学習評価") && question_6.fetch(:source_text).include?("第1章第3款")
  raise "模擬試験11 問6の出典は第1章総則第3款にしてください"
end

QuestionSeedSync.import(exam_number: 11, questions: questions, publication_status: "published")

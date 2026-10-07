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

# 模擬試験14（全20問）
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
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒のよい点や進歩の状況などを積極的に評価し，学習したことの意義や価値を実感できるようにすること。また，各教科・科目等の目標の実現に向けた学習状況を把握する観点から，単元や題材など内容や時間のまとまりを見通しながら評価の場面や方法を工夫して，学習の過程や成果を評価し，指導の改善や{{①}}の向上を図り，資質・能力の育成に生かすようにすること。\n\n（2）{{②}}の中で学習評価の妥当性や信頼性が高められるよう，組織的かつ計画的な取組を推進するとともに，{{③}}を越えて生徒の{{④}}が円滑に接続されるように工夫すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["学習意欲", "統一基準", "学年や学校段階", "学習の成果"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["学習態度", "創意工夫", "教科や科目の枠", "学習の内容"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["学習意欲", "創意工夫", "学年や学校段階", "学習の成果"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["学習態度", "統一基準", "教科や科目の枠", "学習の内容"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "評価は指導改善と学習意欲の向上に生かします。創意工夫の中で評価の妥当性・信頼性を高め，学年や学校段階を越えて学習の成果を円滑に接続することも求めています。アは②，イは①・③・④，エは全ての空欄が異なります。③・④は，教科横断的な学習内容の関連付けではありません。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款2（1）・（2） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）不登校生徒への配慮\n\nア　不登校生徒については，保護者や関係機関と連携を図り，心理や福祉の専門家の{{①}}を得ながら，社会的自立を目指す観点から，個々の生徒の実態に応じた情報の提供その他の必要な支援を行うものとする。\n\nイ　相当の期間高等学校を欠席し引き続き欠席すると認められる生徒等を対象として，{{②}}が認める{{③}}を編成する場合には，生徒の実態に配慮した教育課程を編成するとともに，個別学習やグループ別学習など{{④}}の工夫改善に努めるものとする。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["助言又は援助", "都道府県教育委員会", "特別の教育課程", "指導方法や指導体制"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["助言又は援助", "文部科学大臣", "特別の教育課程", "指導方法や指導体制"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["助言又は協力", "文部科学大臣", "個別の教育課程", "指導内容や評価方法"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["助言又は協力", "都道府県教育委員会", "個別の教育課程", "指導内容や評価方法"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "専門家の助言又は援助を得ながら支援します。この規定で特別の教育課程を認める主体は文部科学大臣です。個別学習やグループ別学習など，指導方法・指導体制の工夫改善も求めています。アは②，ウは①・③・④，エは全ての空欄が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款2（3）ア・イ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）の「第3章 総合的な探究の時間の目標 第2節 目標の趣旨 1 総合的な探究の時間の特質に応じた学習の在り方」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "探究の見方・考え方を働かせるということを目標の冒頭に置いたのは，探究の重要性に鑑み，{{①}}を総合的な探究の時間の本質と捉え，中心に据えることを意味している。総合的な探究の時間における学習では，{{②}}が発展的に繰り返されていく。これを探究と呼ぶ。なお，小中学校における総合的な学習の時間では，「{{③}}を働かせる」としているのに対して，総合的な探究の時間では「{{④}}を働かせる」としている。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["探究の過程", "課題解決的な学習", "探究的な見方・考え方", "探究の見方・考え方"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["探究の成果", "問題解決的な学習", "探究的な見方・考え方", "探究の見方・考え方"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["探究の過程", "問題解決的な学習", "探究の見方・考え方", "探究的な見方・考え方"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["探究の過程", "問題解決的な学習", "探究的な見方・考え方", "探究の見方・考え方"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "本質として中心に据えるのは探究の過程であり，問題解決的な学習を発展的に繰り返すことを探究と説明しています。小中学校では「探究的な見方・考え方」，高等学校では「探究の見方・考え方」と表記します。アは②が「課題解決的」，イは①が「成果」となっている点が異なります。ウは③・④の学校段階ごとの表記が逆です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』第3章第2節1（1）第1段落 | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=20",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する道徳的諸価値についての理解を基にしながら，様々な体験や思索の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，自立心や自律性を高め，規律ある生活をすること，生命を尊重する心を育てること，{{①}}を高め，主体的に社会の形成に参画する意欲と態度を養うこと，{{②}}態度及び人権を尊重し差別のないよりよい社会を実現しようとする態度を養うこと，{{③}}を尊重し，それらを育んできた我が国と郷土を愛するとともに，{{④}}を尊重すること，国際社会に生きる日本人としての自覚を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["社会連帯の自覚", "権利を主張し自由を重んずる", "伝統と文化", "他国"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["社会的な役割の自覚", "義務を果たし責任を重んずる", "歴史と慣習", "国際機関"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["社会連帯の自覚", "義務を果たし責任を重んずる", "歴史と慣習", "国際機関"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["社会連帯の自覚", "義務を果たし責任を重んずる", "伝統と文化", "他国"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "社会連帯の自覚，義務・責任と人権の尊重，伝統と文化，我が国・郷土への愛と他国の尊重を併せて扱います。アは②，イは①・③・④，ウは③・④が異なります。権利や自由も重要ですが，②の原文は「義務を果たし責任を重んずる」態度です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第7款2全文 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第3章 各活動・学校行事の目標と内容 第3節 学校行事 2 学校行事の内容 （4）旅行・集団宿泊的行事」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "校外の豊かな自然や文化に触れる体験を通して，学校における{{①}}を充実発展させる。また，校外における集団活動を通して，教師と生徒が寝食を共にすることによって，教師と生徒，生徒相互の人間的な触れ合いや信頼関係の大切さを経験し，楽しい思い出をつくることができる。さらに，集団生活を通して，基本的な生活習慣や{{②}}などについての体験を積み，集団生活のきまりや{{③}}について考え，実践し，互いを思いやり，共に協力し合ったりするなどの{{④}}を形成しようとする態度を育てる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["学習活動", "公衆道徳", "社会生活上のルール", "よりよい人間関係"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["学習活動", "集団規律", "社会生活上のルール", "集団への所属感"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["教科の学習", "公衆道徳", "自治活動の運営方法", "よりよい人間関係"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["教科の学習", "集団規律", "自治活動の運営方法", "集団への所属感"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "旅行・集団宿泊的行事は，校外の体験を学校の学習活動の充実発展につなげます。共同生活によって公衆道徳や社会生活上のルールを考え，よりよい人間関係を形成する態度を育てます。イは②・④，ウは①・③，エは全ての空欄が異なります。所属感も学校行事全体に関わる概念ですが，この抜粋の④は人間関係です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 特別活動編』第3章第3節2（4）①・旅行・集団宿泊的行事のねらいと内容 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=101",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。下の表は，文章中の「図6 支援チームの形態」を表形式に整理したものである。表中の空欄 {{①}}・{{②}}・{{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "アセスメントに基づいて、問題解決のための具体的なチームによる指導・援助の計画を作成します。「何を目標に（長期目標と短期目標）、誰が（支援担当者や支援機関）、どこで（支援場所）、どのような支援を（支援内容や方法）、いつまで行うか（支援期間）」を記載した「チーム支援計画」を作成し、支援目標を達成するための支援チームを編成します。支援チームには、以下のような形態（図6）が考えられます。" },
      text_block.call("図6の内側から外側の順に示す。いずれも、管理職のリーダーシップによるマネジメントの下に位置付けられている。"),
      { type: "table", headers: ["支援チームの形態", "連携・協働"], rows: [["［①］", "担任等と学年・各校務分掌の最小単位の連携・協働"], ["［②］", "ミドルリーダーのコーディネーションによる連携・協働"], ["［③］", "地域・関係機関等との連携・協働"]] },
    ],
    choices: [
      fill_in_choice.call("ア", ["校内連携型支援チーム", "機動的連携型支援チーム", "ネットワーク型支援チーム"]),
      fill_in_choice.call("イ", ["機動的連携型支援チーム", "校内連携型支援チーム", "ネットワーク型支援チーム"], true),
      fill_in_choice.call("ウ", ["機動的連携型支援チーム", "ネットワーク型支援チーム", "校内連携型支援チーム"]),
      fill_in_choice.call("エ", ["校内連携型支援チーム", "ネットワーク型支援チーム", "機動的連携型支援チーム"]),
    ],
    explanation_blocks: [
      text_block.call("担任等を中心とする最小単位の連携が「機動的連携型」、校内のミドルリーダーによる連携が「校内連携型」、地域・関係機関等との連携が「ネットワーク型」です。支援の手順ではなく、チームの形態と連携の範囲を区別する問題です。"),
      text_block.call("ア：①と②が逆です。最小単位の連携は機動的連携型であり、ミドルリーダーの調整による校内の連携は校内連携型です。"),
      text_block.call("ウ：②と③が逆です。地域・関係機関等との連携はネットワーク型に対応します。"),
      text_block.call("エ：三つとも対応が異なります。機動的連携型を地域・関係機関等との連携に位置付けることも、原図と一致しません。"),
    ],
    source_text: "文部科学省『生徒指導提要』第3章3.4.2（1）③「チーム支援計画の作成」及び図6「支援チームの形態」、本文91〜92ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=94",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("学習障害（LD）及び注意欠如・多動性障害（ADHD）のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "LDの学習評価では，内容の理解を口頭で確かめる方法を取り入れる。口頭で内容を説明できる水準を，読字や書字の技能を習得している水準として扱い，評価する。"),
      text_choice.call("イ", "LDの学習評価では，測定したい学習内容に応じて口頭試問などを検討する。ADHDの行動調整では，実現可能な目当てを立て，点検表を用いて振り返る方法などを活用する。", true),
      text_choice.call("ウ", "ADHDで衝動的にルールを守れない状態は，ルールに関する知識の習得に困難があることを示す。このため，説明を細分化し，ルールの理解を確かめることを行動調整の中心とする。"),
      text_choice.call("エ", "LDとADHDは，いずれも学習上の困難を生じさせる。LDでは不注意・多動性・衝動性を中心に，ADHDでは読む・書く・計算する能力の特定の困難を中心に教育的ニーズを把握する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：内容を理解していることと，読字・書字の技能を習得していることは区別します。口頭試問などを用いる際も，何を評価する課題なのかを踏まえる必要があります。"),
      text_block.call("イ：適切です。LDでは評価の本質に応じた方法を検討し，ADHDでは自分の行動を選択・調整する力を育てる支援を行います。"),
      text_block.call("ウ：ルールを理解していても，衝動性などによって守れない場合があります。知識の不足と捉えて説明を繰り返すことに偏らず，ロールプレイや振り返りなどを検討します。"),
      text_block.call("エ：中心的な特徴が入れ替わっています。LDは読む・書く・計算するなどの特定の能力の困難，ADHDは不注意・多動性・衝動性に関わります。両者が併存する場合にも，各困難を区別して把握します。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』Ⅸ「学習障害」―合理的配慮と学習評価 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_13.pdf\n文部科学省『障害のある子供の教育支援の手引』Ⅹ「注意欠陥多動性障害」―行動の調整と集団への参加 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_14.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("レヴィンの時間的展望の考え方と，青年期におけるその発達に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "時間的展望は，ある時点において個人が抱いている心理的な過去や未来についての見方に関わる。過去の経験の捉え方や将来への見通しは，現在の行動にも影響する。"),
      text_choice.call("イ", "時間的展望は，発達の過程で獲得され，広がっていく。青年期には，進路選択などに際して，過去の経験と将来への見通しを関連付けながら考えることが重要になる。"),
      text_choice.call("ウ", "時間的展望は，場の理論における生活空間の一部として位置付けられる。現在の生活空間には，現時点で抱いている将来への希望や，自分の過去についての見方も含まれる。"),
      text_choice.call("エ", "時間的展望の発達によって，遠い過去や未来の事柄が現在の行動に影響するようになる。同時に，願望と現実とを重ねて捉えるようになり，両者を区別する程度が弱まる。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。時間的展望は，過去や未来の出来事そのものではなく，現在の個人がそれらをどのように捉えているかに関わります。"),
      text_block.call("イ：適切です。青年期は時間的展望が広がる重要な時期であり，進路選択などとの関係が指摘されています。"),
      text_block.call("ウ：適切です。生活空間を，現在の物理的な場所だけに限定して理解することはできません。"),
      text_block.call("エ：後半が誤りです。レヴィンは，時間的展望の発達に伴って，願望と現実との区別がよりよくできるようになると説明しています。"),
    ],
    source_text: "三重大学教育心理学研究室掲載研究・「時間的展望」―青年期における時間的展望 | https://educational-psychology.edu.mie-u.ac.jp/thesis/2018/takami/second.html\n三重大学教育心理学研究室掲載研究・時間的展望と生活空間の関係 | https://educational-psychology.edu.mie-u.ac.jp/thesis/2005/takahashi/mondai.htm",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("学習の転移に関する理論の記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ソーンダイクの同一要素説は，先行学習と後続学習に共通する要素を転移の条件として重視する。ジャッドの一般化説は，先行学習から一般的な原理を捉え，別の場面に適用することを重視する。", true),
      text_choice.call("イ", "ソーンダイクの同一要素説は，特定の内容の学習によって一般的な精神能力が鍛えられ，他の学習にも広く作用すると考える。ジャッドの一般化説は，学習経験からの原理の抽出を重視する。"),
      text_choice.call("ウ", "ソーンダイクの同一要素説は，二つの学習の間に共通する要素があることを重視する。ジャッドの一般化説は，先行学習と後続学習の具体的な材料に，同一の要素があることを転移の根拠とする。"),
      text_choice.call("エ", "ソーンダイクは，二つの学習に共通する要素があると転移が起こりやすいと考えた。ケーラーは，前の学習から一般的な法則を抽出して後の学習に適用する一般化説を提唱した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。同一要素説の「共通する要素」と，一般化説の「抽出された原理の適用」を区別しています。"),
      text_block.call("イ：前半は，一般的な精神能力を鍛える形式陶冶の考え方です。同一要素説の説明ではありません。ジャッドの説明は適切です。"),
      text_block.call("ウ：前半は適切ですが，後半も同一要素説の説明になっています。一般化説は，具体的な材料の共通性ではなく，一般化した原理の適用を重視します。"),
      text_block.call("エ：ソーンダイクの説明は適切ですが，一般化説はジャッドに関係します。ケーラーらに関係するのは，形態や関係構造の移調を重視する考え方です。"),
    ],
    source_text: "弘前大学教育学部附属教育実践総合センター研究員紀要・田中拓郎「『転移』に注目した国語科学習指導に関する調査的研究」―転移概念における歴史的諸説，本文pp.2–3 | https://hirosaki.repo.nii.ac.jp/record/6982/files/kenkyuinkiyou7_1.pdf",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示されたSTEAM（スティーム）教育に関する説明である。適切でないものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "STEAM教育には，新しい価値を提供できる人材を育成する側面と，関連分野が複雑に関係する現代社会に生きる市民を育成する側面がある。科学技術分野の人材育成に偏ることで学校間の格差を拡大する可能性にも留意し，生徒の能力や関心に応じて推進する必要がある。"),
      text_choice.call("イ", "高等学校では，「総合的な探究の時間」や「理数探究」を中心として取り組むことが期待される。その土台となる幼児期からの体験や小・中学校での探究的な学習等も充実させ，児童生徒の学習の状況によっては，小・中学校でSTEAM教育に取り組むことも考えられる。"),
      text_choice.call("ウ", "各教科等の学習を基盤として，そこで育成を目指す資質・能力を確実に育むとともに，教科等を横断する学びを行い，その成果を各教科へ還元する往還が重要である。探究の過程で生じた疑問や思考を記録させ，学校内外の関係者による多様な視点も評価に生かす。"),
      text_choice.call("エ", "STEAM教育のAの範囲は，芸術・文化・デザイン・感性を基本として定義し，生活，経済，法律，政治，倫理は，実社会の課題を理解するための背景として位置付ける。この区分に基づき，各教科の知識・技能を統合して，課題の発見・解決や社会的な価値の創造へ結び付ける。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。人材育成と市民育成の二つの側面が示され，科学技術分野の人材育成の側面に偏った場合の学校間格差も指摘されています。"),
      text_block.call("イ：適切です。高校で重点的に取り組むとともに，幼児期からの体験や小・中学校での学びを土台とすることが求められています。学習状況に応じた小・中学校での取組も挙げられています。"),
      text_block.call("ウ：適切です。各教科の学びとSTEAM教育との往還，疑問や思考の過程の記録，学校内外の関係者による多様な視点を生かした評価が示されています。"),
      text_block.call("エ：Aの範囲が誤りです。答申は，Aを芸術・文化に加えて「生活，経済，法律，政治，倫理等を含めた広い範囲」で定義して推進することを重視しています。これらをAの構成分野ではなく，課題理解の背景へ置き換えている点が不適切です。知識・技能を統合して課題解決や価値創造へ結び付ける部分は適切です。"),
    ],
    source_text: "中央教育審議会『令和の日本型学校教育』答申・第Ⅱ部 各論3（4）「STEAM教育等の教科等横断的な学習の推進による資質・能力の育成」・本文56〜58頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=61",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第3章 第7節 情報 第2款 各科目 第6 情報システムのプログラミング 3 内容の取扱い」に示された内容に基づく記述である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「データ構造とアルゴリズム」の「データの型」については，{{①}}などを扱う。「データ構造」については，{{②}}などを扱う。「アルゴリズム」については，具体的な事例を取り上げ，データ構造の選択と効率的なアルゴリズム及びその表記方法について扱う。\n\n「プログラミング」の「プログラム言語の種類と特性」については，目的に応じた適切なプログラミング言語の選択について扱う。「プログラムの作成」については，{{③}}によるプログラムの構造化についても扱う。「プログラムの統合」については，{{④}}でプログラムの動作を確認する実習を取り入れる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["数値型，文字型，論理型", "配列，リスト，レコード", "関数の定義と使用", "統合の後"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["配列，リスト，レコード", "数値型，文字型，論理型", "関数の定義と使用", "統合の前後"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["数値型，文字型，論理型", "配列，リスト，レコード", "関数の定義と使用", "統合の前後"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["数値型，文字型，論理型", "配列，リスト，レコード", "ライブラリの選択と導入", "統合の前"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "数値型・文字型・論理型はデータの型，配列・リスト・レコードはデータ構造の例である。関数の定義と使用によってプログラムを構造化し，統合の前後で動作を確認する。" },
      { type: "text", text: "アは④を統合後に限定している。イは①と②を取り違えている。エは③が「関数の定義と使用」，④が「統合の前後」となる。" },
      { type: "text", text: "作問上の注記：原典の項番参照を具体的な内容名へ展開しているため，「抜粋」ではなく「示された内容に基づく記述」とした。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節，第2款第6「情報システムのプログラミング」3（2）イ・ウ，参照先2（2）・（3）・本文413頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=415",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第1部 各学科に共通する教科『情報』 第2章 各科目 第1節 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ア（ウ）社会や自然などにおける事象をモデル化する方法，シミュレーションを通してモデルを評価し改善する方法について理解することでは，モデル化とシミュレーションを身近な問題を発見し解決する手段として活用するために，実際の事象を{{①}}などにモデル化して表現する方法，モデル化した事象をシミュレーションできるように表現し{{②}}を変えるなどしてシミュレーションする方法，作成したモデルのシミュレーションを通じてモデルを改善する方法を理解するようにする。その際，{{③}}によってシミュレーションの結果や精度が異なる場合があることを理解するようにする。\n\nイ（ウ）目的に応じたモデル化やシミュレーションを適切に行うとともに，その結果を踏まえて問題の適切な解決方法を考えることでは，モデル化とシミュレーションの考え方を様々な場面で活用するために，モデル化とシミュレーションを問題の発見や解決に役立てたり，その結果から問題の適切な解決方法を考えたり選択したりする力を養う。その際，学校や地域の実態及び生徒の状況に応じて，数学科と連携し，不確実な事象を含む{{④}}を扱うことも考えられる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["図や数式", "条件", "モデルの違い", "確定的モデル"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["図や数式", "条件", "モデルの違い", "確率的モデル"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["図や数式", "条件", "処理装置の違い", "確率的モデル"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["手順や文章", "計算結果", "モデルの違い", "確率的モデル"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "事象を図や数式などにモデル化し，条件を変えてシミュレーションを行う。モデルが異なれば結果や精度も異なる場合があり，不確実な事象を含む確率的モデルも対象となる。" },
      { type: "text", text: "アの④は「確率的モデル」，ウの③は「モデルの違い」が正しい。エは①が「図や数式」，②が「条件」となる。計算結果を先に変更するのではなく，条件の変更が結果に与える影響を調べる。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部，第2章第1節「情報Ⅰ」2（3）ア（ウ）・イ（ウ）・本文33〜34頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=41",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科『情報』 第2章 専門教科情報科の各科目 第10節 コンテンツの制作と発信」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "イ 音・音声の編集\n\nここでは，音・音声の編集を取り上げ，音・音声を扱うソフトウェアの特徴，編集技法などの制作と編集に関する知識と技術を扱う。その際，実際に作品を制作したり，編集したりする活動などを通して，{{①}}音源や{{②}}音源とアプリケーションソフトウェアを利用した音や音楽の作成，録音機器などを利用した音・音声の録音・取り込み，{{③}}などを利用した音・音声の編集，{{④}}などについて扱う。また，音・音声の様々なファイル形式について扱うとともに，音声合成や歌声合成などについても触れる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["PCM（Pulse Code Modulation）", "MIDI（Musical Instrument Digital Interface）", "波形編集ソフトウェア", "ミキシング"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["WAV（Waveform Audio File Format）", "MIDI（Musical Instrument Digital Interface）", "波形編集ソフトウェア", "ミキシング"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["PCM（Pulse Code Modulation）", "MIDI（Musical Instrument Digital Interface）", "波形編集ソフトウェア", "ラスタライズ"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["PCM（Pulse Code Modulation）", "MIDI（Musical Instrument Digital Interface）", "画像編集ソフトウェア", "ミキシング"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "原文はPCM音源とMIDI音源を用いた作成，波形編集ソフトウェアによる編集，ミキシングを挙げている。" },
      { type: "text", text: "イの①は「PCM」が正しい。WAVは音声データを保存するファイル形式であり，PCMのデータを保存できるが，PCMという符号化方式の名称と同じではない。ウの④は「ミキシング」，エの③は「波形編集ソフトウェア」となる。ミキシングは複数の音を混ぜて音量等を調整する処理，ラスタライズは図形等を画素の集合へ変換する処理である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部，第2章第10節，第2「内容とその取扱い」2（4）イ・本文158〜159頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=165\nMicrosoft Learn「リソース交換ファイル形式（RIFF）」 | https://learn.microsoft.com/ja-jp/windows/win32/xaudio2/resource-interchange-file-format--riff-",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "配列Dataを先頭から順に読み込み，3個以上読み込んだ後は，直近3個の値の合計を配列Outに保存したい。長さ3の配列Bufは0で初期化し，添字pの位置を新しい値で上書きした後，pを0→1→2→0→…と巡回させる。" },
      { type: "text", text: "次のプログラムを正しく動作させるため，空欄①・②に当てはまる組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "疑似コードはPythonを模した表記であり，配列の添字は0から始まる。インデントの深さが同じ部分を同一ブロックとする。反復の範囲は両端を含み，%は整数の除算の余りを表す。" },
      { type: "code", code: "01 Data = [2, 5, 1, 4, 7, 3, 6]\n02 Buf = [0, 0, 0]\n03 p = 0\n04 s = 0\n05 Out = []\n06 iを0から要素数(Data)-1まで1ずつ増やしながら繰り返す:\n07     s = ①\n08     Buf[p] = Data[i]\n09     s = s + Buf[p]\n10     p = ②\n11     もし i >= 2 ならば:\n12         Outの末尾にsを追加する\n13 表示する(Out)" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["s−Buf[p]", "（p+1）%2"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["s−Data[i]", "（p+1）%3"]] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["s−Data[i]", "（p+1）%2"]] }], correct: false },
      { label: "エ", content_blocks: [{ type: "table", headers: ["①", "②"], rows: [["s−Buf[p]", "（p+1）%3"]] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "上書き前のBuf[p]にある古い値を引いてから新しい値を加える。3で割った余りを使い，添字を0～2に循環させる。" },
      { type: "table", headers: ["読み込んだ添字i", "直近3個", "合計"], rows: [["2", "2，5，1", "8"], ["3", "5，1，4", "10"], ["4", "1，4，7", "12"], ["5", "4，7，3", "14"], ["6", "7，3，6", "16"]] },
      { type: "text", text: "出力は［8，10，12，14，16］となる。" },
      { type: "text", text: "アは添字が0と1だけを巡回し，3個分を保持できない。イは新しい値Data[i]を引いた直後に同じ値を加えるため，sが初期値0から変わらない。ウは引く対象と巡回周期の両方が誤っている。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第3章・学習13「基本的プログラム」，学習14「応用的プログラム」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "100人について，図書館の利用頻度と読書習慣を調べ，次のクロス集計表を作成した。表から読み取れる割合に関する記述として適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "table", headers: ["図書館の利用頻度", "毎日読書する", "毎日は読書しない", "合計"], rows: [["週1回以上", "24", "16", "40"], ["週1回未満", "6", "54", "60"], ["合計", "30", "70", "100"]] },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "text", text: "調査した100人のうち毎日読書する人は30%である。図書館を週1回以上利用する人のうち毎日読書する人は24%である。" }], correct: false },
      { label: "イ", content_blocks: [{ type: "text", text: "図書館を週1回以上利用する人のうち毎日読書する人は60%である。週1回未満の人のうち毎日読書する人は6%である。" }], correct: false },
      { label: "ウ", content_blocks: [{ type: "text", text: "図書館を週1回以上利用する人のうち毎日読書する人は60%である。週1回未満の人のうち毎日読書する人は10%である。" }], correct: true },
      { label: "エ", content_blocks: [{ type: "text", text: "毎日読書する人のうち図書館を週1回以上利用する人は60%である。調査した100人のうち週1回以上利用する人は40%である。" }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "ウが適切。割合を求めるときは，「誰のうちの割合か」に応じて分母を選ぶ。" },
      { type: "table", headers: ["求める割合", "計算", "結果"], rows: [["週1回以上利用する人のうち毎日読書する人", "24÷40×100", "60%"], ["週1回未満の人のうち毎日読書する人", "6÷60×100", "10%"], ["調査した100人のうち毎日読書する人", "30÷100×100", "30%"], ["毎日読書する人のうち週1回以上利用する人", "24÷30×100", "80%"], ["調査した100人のうち週1回以上利用する人", "40÷100×100", "40%"]] },
      { type: "text", text: "アは後半が誤り。24%は「週1回以上利用し，かつ毎日読書する人」の全体100人に対する割合であり，週1回以上利用する40人の中での割合は60%である。イも後半が誤り。分母は全体100人ではなく週1回未満の60人なので，6%ではなく10%になる。エは前半が誤り。分母は毎日読書する30人なので，60%ではなく80%である。" },
    ],
    source_text: "総務省統計局 Data StaRt「クロス集計」・クロス集計表の相対度数 | https://www.stat.go.jp/dstart/point/seminar/02/3-2-2.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験14は問1〜20を順番に登録してください"
end

questions.each do |question|
  expected_category = case question.fetch(:question_number)
  when 1, 2 then "education_foundations"
  when 6 then "curriculum_organization"
  when 7 then "student_guidance_career"
  when 8 then "integrated_inquiry"
  when 9 then "moral_education"
  when 10 then "special_activities"
  when 11 then "student_guidance_career"
  when 12 then "special_support_education"
  when 13, 14 then "educational_psychology"
  when 16..18 then %w[information_specialized information_specialized information_specialized][question.fetch(:question_number) - 16]
  when 19, 20 then "information_specialized"
  else "education_system"
  end
  expected_major_category = question.fetch(:question_number) >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major_category
    raise "模擬試験14 問#{question.fetch(:question_number)}の大分類が不正です"
  end
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験14 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験14 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
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
      raise "模擬試験14 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    if (3..5).cover?(question.fetch(:question_number)) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験14 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験14 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
    raise "模擬試験14 問#{question.fetch(:question_number)}の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "模擬試験14の問16〜18は指定4範囲から異なる3範囲を資料順に並べてください"
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験14の正答位置はア〜エ各5問にしてください"
end

(6..10).each do |number|
  question = questions.fetch(number - 1)
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && prompt.fetch(:text).include?("からの抜粋である。")
    raise "模擬試験14 問#{number}は原文穴埋め問題にしてください"
  end
end
question_6 = questions.fetch(5)
unless question_6.fetch(:content_blocks).first.fetch(:text).include?("第3款 教育課程の実施と学習評価") && question_6.fetch(:source_text).include?("第1章第3款")
  raise "模擬試験14 問6の出典は第1章総則第3款にしてください"
end

QuestionSeedSync.import(exam_number: 14, questions: questions, publication_status: "published")

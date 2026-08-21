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

questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_history",
    content_blocks: [
      text_block.call("明治期の教育制度に関する次の記述a・bについて、その正誤の組合せとして最も適切なものを選びなさい。\n\na　森有礼は、内閣制度の創設に伴い、明治18（1885）年に初代文部大臣に就任した。\nb　森有礼の下で、明治19（1886）年に小学校令・中学校令・師範学校令・帝国大学令がそれぞれ公布され、学校体系の整備が進められた。"),
    ],
    choices: [
      text_choice.call("ア", "aは正しいが、bは誤りである。"),
      text_choice.call("イ", "aは誤りだが、bは正しい。"),
      text_choice.call("ウ", "a、bともに正しい。", true),
      text_choice.call("エ", "a、bともに誤りである。"),
    ],
    explanation_blocks: [
      text_block.call("森有礼は明治18年12月、内閣制度の創設とともに初代文部大臣となりました。翌明治19年には、帝国大学令、師範学校令、小学校令、中学校令が相次いで公布され、近代学校制度の体系化が進められました。したがって、a、bともに正しい記述です。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第二章第一節「森文相と諸学校令の公布」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317609.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_history",
    content_blocks: [
      text_block.call("デューイ（Dewey, J.）の教育思想と実践に関する次の記述a〜dのうち、適切なものだけを全て挙げた組合せを選びなさい。\n\na　シカゴ大学に実験学校（Laboratory School）を設けた。\nb　『民主主義と教育』において、教育と民主主義の関係を論じた。\nc　「恩物」を考案し、幼稚園（Kindergarten）を創設した。\nd　明瞭・連合・系統・方法という教授段階を教育実践の中心に据えた。"),
    ],
    choices: [
      text_choice.call("ア", "a、b", true),
      text_choice.call("イ", "a、c"),
      text_choice.call("ウ", "b、d"),
      text_choice.call("エ", "c、d"),
    ],
    explanation_blocks: [
      text_block.call("デューイはシカゴ大学に実験学校を設け、経験と探究を重視する教育を実践しました。また、1916年の『民主主義と教育』は教育哲学上の代表作です。cはフレーベル、dはヘルバルト派の教授段階に対応します。"),
    ],
    source_text: "Stanford Encyclopedia of Philosophy『John Dewey』1. Biographical Sketch; 5. Philosophy of Education | https://plato.stanford.edu/entries/dewey/\nスペイン教育・職業訓練・スポーツ省教育図書館『Friedrich Froebel (1782-1852)』 | https://www.educacionfpydeportes.gob.es/biblioteca-central/blog/2026/abril/friedrich-frobel.html\nUniversity of Chemistry and Technology, Prague『Johan Friedrich Herbart』Formal Steps | https://e-learning.vscht.cz/mod/page/view.php?id=63074",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『教育基本法』（平成18年法律第120号）第2条第3号の条文である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "{{①}}、男女の平等、{{②}}を重んずるとともに、{{③}}に基づき、{{④}}社会の形成に参画し、その発展に寄与する態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自由と責任", "相互の敬愛と協力", "公共の利益", "積極的に"]),
      fill_in_choice.call("イ", ["正義と責任", "自他の敬愛と協力", "公共の精神", "主体的に"], true),
      fill_in_choice.call("ウ", ["正義と秩序", "自他の尊重と協調", "公共の福祉", "自律的に"]),
      fill_in_choice.call("エ", ["権利と義務", "男女の協力", "社会連帯の精神", "協働的に"]),
    ],
    explanation_blocks: [
      text_block.call("第2条第3号は、教育の目標として「正義と責任」「男女の平等」「自他の敬愛と協力」を重んじ、「公共の精神」に基づいて「主体的に」社会の形成に参画する態度を養うことを定めています。法令原文では、近い意味の語に置き換えず、語句を正確に押さえる必要があります。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第2条第3号 | https://elaws.e-gov.go.jp/document?lawid=418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『学校教育法』（昭和22年法律第26号）第50条の条文である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "高等学校は、{{①}}における教育の基礎の上に、{{②}}の発達及び{{③}}に応じて、{{④}}を施すことを目的とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["小学校", "身体", "適性", "普通教育及び職業教育"]),
      fill_in_choice.call("イ", ["中学校", "人格", "能力", "広い普通教育及び専門教育"]),
      fill_in_choice.call("ウ", ["義務教育学校", "心身", "適性", "基礎的な普通教育及び職業教育"]),
      fill_in_choice.call("エ", ["中学校", "心身", "進路", "高度な普通教育及び専門教育"], true),
    ],
    explanation_blocks: [
      text_block.call("学校教育法第50条は、高等学校の目的を「中学校における教育の基礎」の上に、「心身の発達及び進路」に応じて、「高度な普通教育及び専門教育」を施すことと定めています。「適性」「職業教育」などの似た語との混同に注意が必要です。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第50条 | https://elaws.e-gov.go.jp/document?lawid=322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『教育公務員特例法』（昭和24年法律第1号）第21条第1項の条文である。空欄 {{①}} 〜 {{③}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "教育公務員は、その{{①}}を遂行するために、{{②}}{{③}}に努めなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["職責", "絶えず", "研究と修養"], true),
      fill_in_choice.call("イ", ["職務", "自主的に", "研修と実践"]),
      fill_in_choice.call("ウ", ["職業", "勤務時間内に", "学術と技能"]),
      fill_in_choice.call("エ", ["使命", "任命権者の計画に従い", "研修と研究"]),
    ],
    explanation_blocks: [
      text_block.call("第21条第1項は、教育公務員に対し、その「職責」を遂行するために「絶えず研究と修養」に努める義務を定めています。第22条の研修機会に関する規定とは区別して理解しましょう。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第21条第1項 | https://elaws.e-gov.go.jp/document?lawid=324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第1章総則の一部である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "各学校においては，生徒の発達の段階を考慮し，{{①}}，{{②}}（情報モラルを含む。），{{③}}等の学習の基盤となる資質・能力を育成していくことができるよう，各教科・科目等の特質を生かし，{{④}}から教育課程の編成を図るものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["読解力", "デジタル活用能力", "探究能力", "総合的な視点"]),
      fill_in_choice.call("イ", ["言語能力", "コンピュータ操作能力", "論理的思考力", "各教科独自の視点"]),
      fill_in_choice.call("ウ", ["言語能力", "情報活用能力", "問題発見・解決能力", "教科等横断的な視点"], true),
      fill_in_choice.call("エ", ["コミュニケーション能力", "メディアリテラシー", "進路設計能力", "学校種別の視点"]),
    ],
    explanation_blocks: [
      text_block.call("総則では、学習の基盤となる資質・能力として「言語能力」「情報活用能力（情報モラルを含む。）」「問題発見・解決能力等」を例示し、各教科・科目等の特質を生かしながら「教科等横断的な視点」で教育課程を編成することを求めています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第2款2(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第1章総則「学習評価の充実」の一部である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "評価の場面や方法を工夫して，{{①}}を評価し，{{②}}や{{③}}を図り，{{④}}に生かすようにすること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["知識及び技能", "教育課程の変更", "試験結果の公表", "単位認定"]),
      fill_in_choice.call("イ", ["学習の過程や成果", "指導の改善", "学習意欲の向上", "資質・能力の育成"], true),
      fill_in_choice.call("ウ", ["学習態度だけ", "評定の透明化", "生徒間の競争", "順位付け"]),
      fill_in_choice.call("エ", ["自己評価", "学習内容の削減", "教師の負担軽減", "学校評価"]),
    ],
    explanation_blocks: [
      text_block.call("学習評価は、評定を付けることだけが目的ではありません。学習の過程や成果を評価し、その結果を「指導の改善」や「学習意欲の向上」につなげ、「資質・能力の育成」に生かすことが原文で示されています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款2(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第4章「総合的な探究の時間」の目標である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "{{①}}を働かせ，{{②}}な学習を行うことを通して，{{③}}を考えながら，{{④}}ための資質・能力を次のとおり育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["専門的な見方・考え方", "教科別・系統的", "職業の選択", "現在の課題に正解する"]),
      fill_in_choice.call("イ", ["体系的な思考", "反復的・基礎的", "学力の到達度", "知識を効率よく習得する"]),
      fill_in_choice.call("ウ", ["問題解決の手順", "個別的・選択的", "自己の適性", "与えられた課題を処理する"]),
      fill_in_choice.call("エ", ["探究の見方・考え方", "横断的・総合的", "自己の在り方生き方", "よりよく課題を発見し解決していく"], true),
    ],
    explanation_blocks: [
      text_block.call("総合的な探究の時間では、「探究の見方・考え方」を働かせ、「横断的・総合的な学習」を通して、「自己の在り方生き方」を考えながら、よりよく課題を発見し解決していくための資質・能力を育成します。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第4章第1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第1章総則の道徳教育に関する記述である。括弧内の定義部分を省略している。空欄 {{①}} 〜 {{③}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "学校における道徳教育は，{{①}}に関する教育を{{②}}を通じて行うことによりその充実を図るものとし，〔中略〕それぞれの特質に応じて，{{③}}を行うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間としての在り方生き方", "学校の教育活動全体", "適切な指導"], true),
      fill_in_choice.call("イ", ["職業倫理", "指定された教科・科目", "統一的な評価"]),
      fill_in_choice.call("ウ", ["社会規範", "特別活動のみ", "宗教に関する指導"]),
      fill_in_choice.call("エ", ["道徳法則", "ホームルーム活動のみ", "特定の価値観の教授"]),
    ],
    explanation_blocks: [
      text_block.call("高等学校の道徳教育は独立した一つの授業だけで行うものではなく、「人間としての在り方生き方に関する教育」を「学校の教育活動全体」を通じて行い、各教科・科目等の特質に応じて「適切な指導」を行うものとされています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款2(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第5章「特別活動」の目標の一部である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "{{①}}としての見方・考え方を働かせ，様々な集団活動に{{②}}に取り組み，{{③}}を発揮しながら{{④}}を解決することを通して，次のとおり資質・能力を育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["教科の専門家", "競争的・効率的", "知識や技能", "入学試験の課題"]),
      fill_in_choice.call("イ", ["個人のキャリア形成者", "独立的・計画的", "適性や能力", "進路上の目標"]),
      fill_in_choice.call("ウ", ["集団や社会の形成者", "自主的，実践的", "互いのよさや可能性", "集団や自己の生活上の課題"], true),
      fill_in_choice.call("エ", ["科学的な探究者", "主体的，協働的", "既有の知識", "社会全体の問題"]),
    ],
    explanation_blocks: [
      text_block.call("特別活動は、「集団や社会の形成者」としての見方・考え方を働かせ、自主的・実践的な集団活動を通して、互いのよさや可能性を発揮しながら、集団や自己の生活上の課題を解決することを重視します。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、文部科学省『生徒指導提要』（令和4年12月）の「生徒指導の定義」である。空欄 {{①}} 〜 {{③}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "生徒指導とは、児童生徒が、{{①}}の中で自分らしく生きることができる存在へと、{{②}}に成長や発達する過程を支える教育活動のことである。なお、生徒指導上の課題に対応するために、必要に応じて{{③}}を行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校", "意図的・計画的", "懲戒"]),
      fill_in_choice.call("イ", ["社会", "自発的・主体的", "指導や援助"], true),
      fill_in_choice.call("ウ", ["集団", "一律・段階的", "規律訓練"]),
      fill_in_choice.call("エ", ["将来社会", "能力主義的", "教育相談だけ"]),
    ],
    explanation_blocks: [
      text_block.call("令和4年改訂の『生徒指導提要』は、生徒指導を、児童生徒が社会の中で自分らしく生きる存在へと「自発的・主体的」に成長・発達する過程を支える教育活動と定義しています。課題への事後対応だけに限定されない点が重要です。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.1 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ある生徒には全般的な知的発達の遅れは見られないが、文字を正確に読むことと、考えを文章に書いて表すことに著しい困難が継続している。視覚・聴覚の障害や環境的要因が、その困難の直接の原因とは考えられない。文部科学省が示す定義に照らした障害の説明として、最も該当するものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "対人関係の形成の困難さと、限定された興味や反復的な行動を主な特徴とする自閉症"),
      text_choice.call("イ", "年齢や発達に不釣り合いな不注意、衝動性、多動性を主な特徴とする注意欠陥／多動性障害（ADHD）"),
      text_choice.call("ウ", "知的機能と適応行動の双方に全般的な制約が見られる知的障害"),
      text_choice.call("エ", "聞く、話す、読む、書く、計算する又は推論する能力のうち、特定のものの習得と使用に著しい困難を示す学習障害（LD）", true),
    ],
    explanation_blocks: [
      text_block.call("学習障害（LD）は、基本的には全般的な知的発達に遅れがない一方、聞く・話す・読む・書く・計算する・推論する能力のうち特定のものに著しい困難を示す状態です。教員が診断を行うのではなく、困難の現れ方を把握し、校内の支援体制や専門機関と連携して必要な支援につなげることが大切です。"),
    ],
    source_text: "文部科学省「学習障害（LD）、注意欠陥／多動性障害（ADHD）及び高機能自閉症について」 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1396626.htm",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ある高校生は、「振り子の周期には、おもりの重さ、糸の長さ、振れ幅のどれが影響するか」を調べるため、一つの条件だけを変えて結果を比較する実験を計画した。ピアジェ（Piaget, J.）の認知発達理論において、このように仮説を立て、変数を統制して可能性を系統的に検討する思考を最もよく説明する段階を選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "感覚運動期"),
      text_choice.call("イ", "前操作期"),
      text_choice.call("ウ", "形式的操作期", true),
      text_choice.call("エ", "具体的操作期"),
    ],
    explanation_blocks: [
      text_block.call("形式的操作期では、目の前の具体物だけに依存せず、抽象的な概念や仮説を扱い、仮説演繹的に考えることが可能になると説明されます。条件を一つずつ変えて可能性を系統的に検討する行動は、この思考の典型例です。"),
    ],
    source_text: "NCBI Bookshelf『Piaget』Formal Operations Period | https://www.ncbi.nlm.nih.gov/books/NBK448206/",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("協同学習の技法であるジグソー法を用いた授業の進め方として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学習内容を複数の部分に分け、各生徒が担当部分を専門家グループで学んだ後、元のグループに戻って互いに教え合い、全体を完成させる。", true),
      text_choice.call("イ", "全員に同一の課題を個別に解かせ、最も早く正答した生徒だけが、教師に代わって解答を読み上げる。"),
      text_choice.call("ウ", "教師が学習内容を全て説明した後、グループごとの平均点を競わせ、順位に応じて報酬を与える。"),
      text_choice.call("エ", "生徒ごとに異なる教材を与えるが、情報交換を禁止し、各自の成果だけを個別に評価する。"),
    ],
    explanation_blocks: [
      text_block.call("ジグソー法では、教材を分担し、同じ部分を担当する生徒同士の「専門家」活動を経て、元のグループで互いに教え合います。一人一人の担当が全体理解に必要となる相互依存性をつくる点が特徴です。"),
    ],
    source_text: "The Jigsaw Classroom『Jigsaw in 10 Easy Steps』 | https://www.jigsaw.org/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "new_japanese_school_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、中央教育審議会答申『「令和の日本型学校教育」の構築を目指して』（令和3年1月26日）の一部である。空欄 {{①}} 〜 {{③}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "なお，ICTはこれからの学校教育に{{①}}なものであり，{{②}}として最大限活用していく必要があるが，その{{③}}ことに留意が必要である。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["補助的", "授業効率化の手段", "導入費用を抑えるべきである"]),
      fill_in_choice.call("イ", ["選択可能", "個別学習専用の機器", "対面指導を置き換えるべきである"]),
      fill_in_choice.call("ウ", ["一時的に必要", "非常時の代替手段", "利用時間を最優先すべきである"]),
      fill_in_choice.call("エ", ["必要不可欠", "基盤的なツール", "活用自体が目的でない"], true),
    ],
    explanation_blocks: [
      text_block.call("答申は、ICTを学校教育に「必要不可欠」な「基盤的なツール」と位置付ける一方、「活用自体が目的でない」と明記しています。学習上の目的に応じて、これまでの実践とICTを適切に組み合わせることが重要です。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して』（答申）第I部4(3) | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『高等学校学習指導要領（平成30年告示）』第2章第10節「情報」の目標の一部である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "情報に関する{{①}}を働かせ，情報技術を活用して{{②}}を行う学習活動を通して，問題の発見・解決に向けて情報と情報技術を{{③}}に活用し，情報社会に{{④}}するための資質・能力を次のとおり育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["実務的な知識・技能", "情報機器の操作", "迅速かつ大量", "適応"]),
      fill_in_choice.call("イ", ["科学的な見方・考え方", "問題の発見・解決", "適切かつ効果的", "主体的に参画"], true),
      fill_in_choice.call("ウ", ["倫理的な態度", "情報の収集・発信", "安全かつ簡便", "協調"]),
      fill_in_choice.call("エ", ["数理的な手法", "プログラムの作成", "自動的かつ効率的", "貢献"]),
    ],
    explanation_blocks: [
      text_block.call("情報科の目標では、「情報に関する科学的な見方・考え方」を働かせ、情報技術を活用した「問題の発見・解決」を通して、情報と情報技術を「適切かつ効果的」に活用し、情報社会に「主体的に参画」する資質・能力の育成を目指します。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第1款 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『情報Ⅰ』の「コミュニケーションと情報デザイン」における知識及び技能の記述である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "メディアの特性とコミュニケーション手段の特徴について，その{{①}}も踏まえて{{②}}に理解すること。情報デザインが人や社会に果たしている{{③}}を理解すること。効果的なコミュニケーションを行うための情報デザインの考え方や方法を理解し{{④}}を身に付けること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["利用者層", "経験的", "危険性", "操作速度"]),
      fill_in_choice.call("イ", ["最新事例", "直感的", "経済効果", "プログラミング技能"]),
      fill_in_choice.call("ウ", ["変遷", "科学的", "役割", "表現する技能"], true),
      fill_in_choice.call("エ", ["市場規模", "批判的", "法的責任", "暗号化する技能"]),
    ],
    explanation_blocks: [
      text_block.call("原文は、メディアとコミュニケーション手段を「変遷」も踏まえて「科学的」に理解すること、情報デザインの「役割」を理解すること、考え方や方法を理解して「表現する技能」を身に付けることを示しています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報I」2(2)ア | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『情報Ⅰ』の「情報社会の問題解決」における知識及び技能の記述である。空欄 {{①}} 〜 {{④}} に当てはまる語句の組合せとして正しいものを選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "情報に関する{{①}}，{{②}}の重要性，情報社会における{{③}}及び{{④}}について理解すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["法規や制度", "情報セキュリティ", "個人の責任", "情報モラル"], true),
      fill_in_choice.call("イ", ["通信規約", "処理速度", "企業の利益", "操作方法"]),
      fill_in_choice.call("ウ", ["表現技法", "情報デザイン", "著作者の収益", "市場倫理"]),
      fill_in_choice.call("エ", ["統計理論", "データ量", "分析者の直感", "研究手順"]),
    ],
    explanation_blocks: [
      text_block.call("『情報Ⅰ』では、個別の法令名や操作方法を暗記するだけでなく、「情報に関する法規や制度」「情報セキュリティの重要性」「情報社会における個人の責任」「情報モラル」を関連付けて理解することが求められています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報I」2(1)ア(イ) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "algorithm",
    content_blocks: [
      text_block.call("次のプログラムは、二つの正の整数の最大公約数をユークリッドの互除法で求めるものである。実行終了時に表示される a と count の組合せとして正しいものを選びなさい。なお、「%」は整数除算の余りを表す。"),
      {
        type: "code",
        title: "最大公約数を求めるプログラム",
        code: "a = 1071\nb = 462\ncount = 0\n\nb != 0 の間繰り返す:\n  r = a % b\n  a = b\n  b = r\n  count = count + 1\n\na と count を表示する",
      },
    ],
    choices: [
      text_choice.call("ア", "a = 7、count = 4"),
      text_choice.call("イ", "a = 21、count = 2"),
      text_choice.call("ウ", "a = 147、count = 3"),
      text_choice.call("エ", "a = 21、count = 3", true),
    ],
    explanation_blocks: [
      text_block.call("余りと変数の変化を順に追うと、3回目でbが0になります。その時点のaが最大公約数なので、表示はa=21、count=3です。"),
      {
        type: "code",
        title: "変数の変化",
        code: "1回目: 1071 % 462 = 147 → a=462, b=147\n2回目: 462 % 147 = 21   → a=147, b=21\n3回目: 147 % 21 = 0     → a=21,  b=0",
      },
    ],
    source_text: "文部科学省『高等学校情報科「情報I」教員研修用教材』第3章 コンピュータとプログラミング | https://www.mext.go.jp/a_menu/shotou/zyouhou/detail/1416756.htm",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "data_science",
    content_blocks: [
      text_block.call("ある量的データについて、第1四分位数 Q1=18、第3四分位数 Q3=30 であった。外れ値の候補を「Q1−1.5×IQRより小さい値、またはQ3＋1.5×IQRより大きい値」（IQRは四分位範囲）とする。この基準による下側境界、上側境界、および外れ値の候補の組合せとして正しいものを選びなさい。"),
      {
        type: "table",
        headers: ["観測値"],
        rows: [
          ["9"],
          ["18"],
          ["18"],
          ["22"],
          ["24"],
          ["26"],
          ["30"],
          ["30"],
          ["52"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "下側境界6、上側境界42、外れ値の候補は52"),
      text_choice.call("イ", "下側境界0、上側境界48、外れ値の候補は52", true),
      text_choice.call("ウ", "下側境界0、上側境界48、外れ値の候補は9と52"),
      text_choice.call("エ", "下側境界12、上側境界36、外れ値の候補は9と52"),
    ],
    explanation_blocks: [
      text_block.call("表の中央値24を除いた下位4値と上位4値の中央値から、Q1=18、Q3=30となります。IQR=Q3−Q1=12なので、下側境界は18−1.5×12=0、上側境界は30＋1.5×12=48です。観測値のうち48より大きい52だけが外れ値の候補であり、9は境界内です。外れ値の候補を機械的に削除せず、入力誤りか、意味のある極端値かを確認することも重要です。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報I」教員研修用教材』第4章 データの活用 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験1は問1から問20までの20問で構成してください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 1,
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
      raise "模擬試験1 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

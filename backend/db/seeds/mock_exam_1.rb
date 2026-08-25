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

fill_in_prompt = lambda do |document, section, blanks|
  "次の文章は，#{document}の「#{section}」からの抜粋である。文章中の空欄 #{blanks} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"
end

questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("明治期の学校制度と森有礼の教育政策に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "森有礼は、1872（明治5）年の学制の起草を主導し、1879（明治12）年に教育令を公布して、中央集権的な学区制を完成させた。"),
      text_choice.call("イ", "森有礼は初代文部卿として1880（明治13）年の改正教育令を制定し、小学校教育に対する国家の関与を縮小した。"),
      text_choice.call("ウ", "森有礼は内閣制度の創設に伴い1885（明治18）年に初代文部大臣となり、翌年に帝国大学令、師範学校令、小学校令及び中学校令を公布して、学校種別ごとの制度化を進めた。", true),
      text_choice.call("エ", "森有礼は教育に関する権限を市町村に全面的に委ねることを重視し、1886（明治19）年の諸学校令では師範教育に対する国の統制を廃止した。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。学制と教育令は、森有礼が文部大臣として制定した法令ではありません。また、教育令は学制の画一的・中央集権的な性格を改める方向を示しました。イは誤りです。森は文部卿ではなく初代文部大臣であり、改正教育令の制定者とするのも誤りです。ウが適切です。1885年の就任後、1886年に学校種別の四学校令が公布されました。エは誤りです。森の政策は国家的な学校体系と師範教育の整備を進めるもので、国の統制を廃止したとする記述とは逆です。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第二章第一節「森文相と諸学校令の公布」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317609.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("デューイ（Dewey, J.）の教育思想と教育実践に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "シカゴ大学に実験学校を設け、子供の経験と探究を重視する教育を実践した。また、『民主主義と教育』では、教育と民主的社会との関係を論じた。", true),
      text_choice.call("イ", "幼児の自己活動と遊びを教育の中心に置き、Kindergartenを創設するとともに、教育遊具である恩物を考案した。"),
      text_choice.call("ウ", "観念の結合による道徳的品性の形成を教育の目的とし、明瞭・連合・系統・方法という教授段階を中心とする授業を提唱した。"),
      text_choice.call("エ", "感覚教育のための教具を用意し、教師が直接教え込むのではなく、子供が自発的に教具を操作することで知的独立を獲得する教育法を創始した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。デューイはシカゴ大学に実験学校を設け、子供の経験に基づく活動と探究を重視しました。『民主主義と教育』も代表作です。イは誤りです。Kindergartenの創設と恩物の考案はフレーベルの業績です。ウは誤りです。この教授段階はヘルバルト派に対応します。エは誤りです。感覚教育のための教具と自発的な操作を重視した説明は、モンテッソーリの教育法に対応します。"),
    ],
    source_text: "Stanford Encyclopedia of Philosophy『John Dewey』1. Biographical Sketch; 5. Philosophy of Education | https://plato.stanford.edu/entries/dewey/\nスペイン教育・職業訓練・スポーツ省教育図書館『Friedrich Froebel (1782-1852)』 | https://www.educacionfpydeportes.gob.es/biblioteca-central/blog/2026/abril/friedrich-froebel.html\nUniversity of Chemistry and Technology, Prague『Johan Friedrich Herbart』Formal Steps | https://e-learning.vscht.cz/mod/page/view.php?id=63074\nAssociation Montessori Internationale “Montessori Environments” | https://montessori-ami.org/about-montessori/montessori-environments",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「教育基本法」（平成18年法律第120号）", "第2条第3号", "{{①}} ～ {{④}}"),
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
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第50条　高等学校は、{{①}}における教育の基礎の上に、{{②}}の発達及び{{③}}に応じて、{{④}}を施すことを目的とする。",
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
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第21条　教育公務員は、その{{①}}を遂行するために、{{②}}{{③}}と{{④}}に努めなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["職責", "絶えず", "研究", "修養"], true),
      fill_in_choice.call("イ", ["職務", "自主的に", "研修", "実践"]),
      fill_in_choice.call("ウ", ["職業", "勤務時間内に", "学術", "技能"]),
      fill_in_choice.call("エ", ["使命", "計画的に", "研修", "研究"]),
    ],
    explanation_blocks: [
      text_block.call("第21条第1項は、教育公務員に対し、その「職責」を遂行するために「絶えず研究と修養」に努める義務を定めています。第22条の研修機会に関する規定とは区別して理解しましょう。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第21条第1項 | https://elaws.e-gov.go.jp/document?lawid=324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "第２款の２の（1）に示す{{①}}の育成を図るため，各学校において必要な{{②}}を整えるとともに，{{③}}を要としつつ各教科・科目等の特質に応じて，生徒の{{④}}を充実すること。あわせて，（6）に示すとおり読書活動を充実すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["読解力", "読書環境", "地理歴史科", "表現活動"]),
      fill_in_choice.call("イ", ["コミュニケーション能力", "情報環境", "外国語科", "対話活動"]),
      fill_in_choice.call("ウ", ["言語能力", "言語環境", "国語科", "言語活動"], true),
      fill_in_choice.call("エ", ["情報活用能力", "ICT環境", "情報科", "探究活動"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。言語能力の育成に当たっては、必要な『言語環境』を整え、『国語科』を要としつつ各教科・科目等の特質に応じて『言語活動』を充実することが求められます。アの『読解力』『読書環境』『地理歴史科』『表現活動』、イの『コミュニケーション能力』『情報環境』『外国語科』『対話活動』、エの『情報活用能力』『ICT環境』『情報科』『探究活動』はいずれも、この段落の原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "生徒が，{{①}}を実感しながら，{{②}}を形成し，有意義で充実した学校生活を送る中で，現在及び将来における{{③}}を図っていくことができるよう，生徒理解を深め，学習指導と関連付けながら，{{④}}を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習の成果", "協働的な学習集団", "進路実現", "教育相談の充実"]),
      fill_in_choice.call("イ", ["自己の存在感", "よりよい人間関係", "自己実現", "生徒指導の充実"], true),
      fill_in_choice.call("ウ", ["自己有用感", "望ましい集団規律", "社会的自立", "進路指導の充実"]),
      fill_in_choice.call("エ", ["所属感", "相互扶助的な関係", "人格の完成", "学習評価の充実"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。生徒が『自己の存在感』を実感しながら『よりよい人間関係』を形成し、現在及び将来の『自己実現』を図れるよう、生徒理解を深め、学習指導と関連付けて『生徒指導の充実』を図ります。ア、ウ、エはいずれも関連し得る語を含みますが、この連続した原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款1(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第1 目標", "{{①}} ～ {{④}}"),
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
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第1款 高等学校教育の基本と教育課程の役割", "{{①}} ～ {{③}}"),
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
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第5章 特別活動 第1 目標", "{{①}} ～ {{④}}"),
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
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "学校教育の目的は、「人格の完成を目指し、平和で民主的な国家及び社会の形成者として必要な資質を備えた心身ともに健康な国民の育成」（教育基本法第1条）を期することであり、また、「個人の価値を尊重して、その能力を伸ばし、創造性を培い、自主及び自律の精神を養う」（同法第2条第2号）ことが目標の一つとして掲げられています。この学校教育の目的や目標達成に寄与する生徒指導を定義すると、次のようになります。\n\n生徒指導とは、児童生徒が、{{①}}の中で自分らしく生きることができる存在へと、{{②}}に成長や発達する過程を支える教育活動のことである。なお、生徒指導上の課題に対応するために、必要に応じて{{③}}を行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校", "意図的・計画的", "懲戒"]),
      fill_in_choice.call("イ", ["社会", "自発的・主体的", "指導や援助"], true),
      fill_in_choice.call("ウ", ["集団", "一律・段階的", "規律訓練"]),
      fill_in_choice.call("エ", ["将来社会", "能力主義的", "教育相談だけ"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。令和4年改訂の『生徒指導提要』は、生徒指導を、児童生徒が『社会』の中で自分らしく生きる存在へと『自発的・主体的』に成長・発達する過程を支え、必要に応じて『指導や援助』を行う教育活動と定義しています。アは活動の場を学校だけに限定し、成長を意図的・計画的なもの、対応を懲戒だけとする点が誤りです。ウの『集団』『一律・段階的』『規律訓練』、エの『将来社会』『能力主義的』『教育相談だけ』も、児童生徒主体の定義と一致しません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.1 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("次の①～④は、学習障害（LD）、注意欠如・多動症（ADHD）及び自閉スペクトラム症（ASD）の状態像と教育的対応に関する記述である。適切なものの組合せとして正しいものを、下のア～エの中から一つ選んで記号で答えなさい。\n① LDでは、全般的な知的発達に遅れはないが、聞く、話す、読む、書く、計算する又は推論する能力のうち、特定のものの習得と使用に著しい困難を示すことがある。\n② ADHDでは、年齢又は発達に不釣合いな注意力、衝動性又は多動性を特徴とし、それが学習上又は社会生活上の支障となることがある。\n③ ASDでは、知的発達の遅れを伴わない場合でも、対人関係や社会的相互作用の困難、限定された興味・関心や行動上の特徴が見られることがある。\n④ 三つの障害は相互に排他的であるため、一つの特徴が確認できれば他の困難の把握は不要であり、診断名ごとに同一の支援を行う。"),
    ],
    choices: [
      text_choice.call("ア", "①・②・④"),
      text_choice.call("イ", "①・③・④"),
      text_choice.call("ウ", "②・③・④"),
      text_choice.call("エ", "①・②・③", true),
    ],
    explanation_blocks: [
      text_block.call("①～③は適切で、④は誤りであるため、正答はエです。①はLD、②はADHD、③はASDについて文部科学省が示す状態像に対応します。④は、困難が重なって現れる可能性や個人差を無視し、診断名だけで支援を一律に決める点が誤りです。アは誤った④を含み③を欠き、イは誤った④を含み②を欠き、ウは誤った④を含み①を欠きます。学校では一つの行動だけで診断せず、学習場面ごとの状態と教育的ニーズを把握して、提示方法、課題量、環境、表出方法等を個別に調整します。"),
    ],
    source_text: "文部科学省「学習障害（LD）、注意欠陥／多動性障害（ADHD）及び高機能自閉症について」 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1396626.htm",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ピアジェ（Piaget, J.）の認知発達理論における形式的操作期の思考に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "外界への働きかけを感覚と運動によって調整し、目の前から物が見えなくなっても存在し続けることを理解するが、仮説を立てて複数の条件を比較することはできない段階である。"),
      text_choice.call("イ", "言語やイメージによる象徴的な表象が可能になる一方、対象の一つの側面に注意が集中しやすく、操作を逆方向にたどることが困難な段階である。"),
      text_choice.call("ウ", "現実に観察された事実だけでなく、起こり得る可能性を組み合わせて仮説を立て、他の条件を一定に保ちながら一つの変数を操作して、その仮説を体系的に検証できる段階である。", true),
      text_choice.call("エ", "保存、分類、系列化などの論理的操作が可能になるが、その操作は具体的な事物や実際に経験できる状況に強く依存している段階である。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。これは感覚運動期の特徴です。イは誤りです。これは前操作期に見られる象徴機能、中心化及び不可逆性の説明です。ウが適切です。形式的操作期には、抽象的な可能性を想定し、変数を統制しながら仮説を検証する仮説演繹的思考が可能になります。エは誤りです。これは具体的操作期の特徴です。"),
    ],
    source_text: "NCBI Bookshelf『Piaget』Formal Operations Period | https://www.ncbi.nlm.nih.gov/books/NBK448206/",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ジグソー法に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "すべての学習者に同一の部分資料を与えて個別に学習させた後、各班で最も成績の高い学習者だけに説明させ、班同士で説明の優劣を競わせることを中心とする学習方法である。", true),
      text_choice.call("イ", "学習内容を複数の部分に分け、ホームグループの各成員に異なる部分を担当させた後、同じ部分を担当する学習者がエキスパートグループをつくって理解を深める。"),
      text_choice.call("ウ", "エキスパートグループでの学習後、各成員がホームグループに戻って担当部分を説明し合うことにより、全員の情報を組み合わせなければ課題全体を理解できない構造をつくる。"),
      text_choice.call("エ", "単に自由な話合いをさせるのではなく、学習者間の相互依存性と各成員の責任が成立するように課題を構成し、教師は学習状況を観察して必要な支援を行う。"),
    ],
    explanation_blocks: [
      text_block.call("アが不適切です。ジグソー法では、成員が異なる部分を担当し、その知識を持ち寄ります。代表者だけが説明する競争的な方法ではありません。イは適切です。ホームグループとエキスパートグループを往還する基本的な手順です。ウは適切です。各成員の情報が課題全体の理解に必要となるため、肯定的な相互依存関係が形成されます。エは適切です。相互依存性だけでなく、各成員が担当部分を説明する個人の責任も重要です。"),
    ],
    source_text: "The Jigsaw Classroom『Jigsaw in 10 Easy Steps』 | https://www.jigsaw.org/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示されたICT活用に関する記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ICTは非常時に対面指導を代替する補助的手段であり、平常時には従来の一斉指導へ戻すことを基本とする。端末の利用時間を増やすこと自体を成果指標とし、活用場面の教育的効果は問わない。"),
      text_choice.call("イ", "ICTは個別学習専用の機器であるため、協働的な学びや教師と児童生徒との関わりには用いない。デジタル教材を使う授業では、これまでの教育実践を原則として置き換える。"),
      text_choice.call("ウ", "ICT環境が整備された後は、教育内容や学習上の目的にかかわらず全ての活動をデジタル化し、対面指導とICTを組み合わせるよりも、機器の機能を最大限使うことを優先する。"),
      text_choice.call("エ", "ICTはこれからの学校教育に必要不可欠な基盤的なツールとして最大限活用する一方、活用自体を目的とはせず、これまでの教育実践と適切に組み合わせて教育の質の向上につなげる。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。答申は、ICTを学校教育に『必要不可欠』な『基盤的なツール』と位置付け、最大限活用する一方で、『活用自体が目的でない』ことに留意し、これまでの実践とICTを適切に組み合わせる必要があるとしています。アは平常時の活用を否定し利用時間を目的化する点、イはICTを個別学習だけに限定し協働や教師との関わりから切り離す点、ウは学習目的を無視して全面的なデジタル化を優先する点が、それぞれ答申の趣旨と異なります。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部4(3) | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第1款 目標", "{{①}} ～ {{④}}"),
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
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第3章 主として専門学科において開設される各教科 第7節 情報 目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "情報に関する科学的な見方・考え方を働かせ，{{①}}な学習活動を行うことなどを通して，情報産業を通じ，地域産業をはじめ情報社会の{{②}}で持続的な発展を担う職業人として必要な資質・能力を次のとおり育成することを目指す。\n(1) 情報の各分野について体系的・系統的に理解するとともに，関連する技術を身に付けるようにする。\n(2) 情報産業に関する課題を発見し，職業人に求められる{{③}}を踏まえ合理的かつ創造的に解決する力を養う。\n(3) 職業人として必要な豊かな人間性を育み，よりよい社会の構築を目指して自ら学び，情報産業の創造と発展に{{④}}に取り組む態度を養う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["実践的・体験的", "安全", "責任感", "主体的に"]),
      fill_in_choice.call("イ", ["探究的・協働的", "公正", "情報モラル", "協働的に"]),
      fill_in_choice.call("ウ", ["実践的・体験的", "健全", "倫理観", "主体的かつ協働的"], true),
      fill_in_choice.call("エ", ["主体的・対話的", "豊か", "使命感", "継続的かつ組織的"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。専門教科情報科は「実践的・体験的」な学習活動を通して情報社会の「健全」で持続的な発展を担う職業人を育成し、職業人に求められる「倫理観」を踏まえて課題を解決する力と、情報産業の創造・発展に「主体的かつ協働的」に取り組む態度を養います。アは「安全・責任感・主体的に」、イは「探究的・協働的・公正・情報モラル」、エは「主体的・対話的・豊か・使命感・継続的かつ組織的」が、この目標の原文とは一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節「情報」目標 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）", "第1部 各学科に共通する教科「情報」 第1章 総説 第3節 情報教育の中での共通教科情報科の位置付け 2 3観点による情報活用能力の整理", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "共通教科情報科の目標や内容を正しく理解し，授業を通して確実に実現するためには，小・中・高等学校を通して体系的・系統的に行われる情報教育の目標について正しく理解する必要がある。\n平成11年改訂の高等学校学習指導要領において情報科を新設するに当たって，「情報化の進展に対応した初等中等教育における情報教育の推進等に関する調査研究協力者会議」は，平成9年10月の第1次報告「体系的な情報教育の実施に向けて」（以下，「第1次報告」という。）において，情報教育の目標の観点を「{{①}}」，「{{②}}」，「{{③}}」の三つに整理している。平成21年改訂の高等学校学習指導要領では，情報教育の目標の観点として引き続きこの3観点を位置付けている。今回の改訂においては，これを資質・能力の三つの柱に沿って再整理した。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["情報活用の実践力", "情報の科学的な理解", "情報社会に参画する態度"], true),
      fill_in_choice.call("イ", ["情報機器の操作力", "情報の技術的な理解", "情報社会を管理する能力"]),
      fill_in_choice.call("ウ", ["問題発見・解決能力", "情報の批判的な理解", "情報社会を評価する態度"]),
      fill_in_choice.call("エ", ["情報収集の実践力", "情報の倫理的な理解", "情報産業に従事する態度"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。情報教育の目標は「情報活用の実践力」「情報の科学的な理解」「情報社会に参画する態度」の3観点で整理され、今回の改訂では同じ情報活用能力を資質・能力の三つの柱に沿って再整理しています。イの「情報機器の操作力」等、ウの「問題発見・解決能力」等、エの「情報収集の実践力」等は、3観点の正式な名称ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部第1章第3節2「3観点による情報活用能力の整理」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
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
    category_code: "information_specialized",
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

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
    category_code: "education_history",
    content_blocks: [
      text_block.call("1879（明治12）年の教育令と、1880（明治13）年の改正教育令に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育令は学制よりも中央集権的・画一的な制度を採用し、改正教育令は教育に関する権限を地方へ広く委ねた。"),
      text_choice.call("イ", "教育令は義務教育を9年とし、改正教育令は尋常小学校6年と高等小学校3年に区分した。"),
      text_choice.call("ウ", "教育令は学制の中央集権的・画一的な性格を改めて地方の自由を重んじ、改正教育令は国家の統制を強化した。", true),
      text_choice.call("エ", "教育令によって初めて学校種別ごとの学校令が整備され、改正教育令によって帝国大学が設置された。"),
    ],
    explanation_blocks: [
      text_block.call("1879（明治12）年の教育令は学制を廃止し、学制の中央集権的・画一的な性格を改めて、教育に関する権限を地方に委ねる方針を採りました。しかし、就学状況の後退などが問題となり、1880（明治13）年の改正教育令では国家の統制が再び強化されました。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第一章第二節「二 教育令・改正教育令と小学校の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317588.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_history",
    content_blocks: [
      text_block.call("コメニウス（Comenius, J. A.）とその著作に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『世界図絵』を著し、事物の図とことばを結び付けた子供向けの絵入り教材を示した。", true),
      text_choice.call("イ", "『エミール』において、子供の自然な発達に即した消極教育を論じた。"),
      text_choice.call("ウ", "幼児の自己活動と遊びを重視し、恩物を用いる幼稚園を創設した。"),
      text_choice.call("エ", "『学校と社会』において、学校を小さな社会と捉える教育を提唱した。"),
    ],
    explanation_blocks: [
      text_block.call("コメニウスの『世界図絵（Orbis sensualium pictus）』は1658年に刊行され、世界最初の子供向け絵入り本とされています。イはルソー、ウはフレーベル、エはデューイに対応する説明です。"),
    ],
    source_text: "国立国会図書館国際子ども図書館 Research Navi『コメニウス「世界図絵」』 | https://ndlsearch.ndl.go.jp/en/rnavi/children/post_237",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「教育基本法」（平成18年法律第120号）", "第13条", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "学校、家庭及び地域住民その他の関係者は、教育におけるそれぞれの{{①}}を自覚するとともに、相互の{{②}}及び{{③}}に努めるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["権利と義務", "理解", "支援"]),
      fill_in_choice.call("イ", ["役割と責任", "理解", "支援"]),
      fill_in_choice.call("ウ", ["権利と義務", "連携", "協力"]),
      fill_in_choice.call("エ", ["役割と責任", "連携", "協力"], true),
    ],
    explanation_blocks: [
      text_block.call("教育基本法第13条は、学校、家庭及び地域住民その他の関係者が、それぞれの『役割と責任』を自覚し、相互の『連携』及び『協力』に努めることを定めています。条文の見出しは『学校、家庭及び地域住民等の相互の連携協力』です。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第13条 | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「学校教育法」（昭和22年法律第26号）", "第51条第3号", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}に努めるとともに、社会について、広く深い理解と{{②}}を養い、{{③}}に寄与する態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人格の完成", "健全な判断力", "国家及び社会の形成"]),
      fill_in_choice.call("イ", ["個性の確立", "健全な批判力", "社会の発展"], true),
      fill_in_choice.call("ウ", ["個性の尊重", "公正な批判力", "社会の形成"]),
      fill_in_choice.call("エ", ["人格の確立", "論理的な思考力", "文化の発展"]),
    ],
    explanation_blocks: [
      text_block.call("学校教育法第51条第3号は、高等学校教育の目標として、個性の確立に努めること、社会について広く深い理解と健全な批判力を養うこと、社会の発展に寄与する態度を養うことを定めています。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第51条第3号 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「地方公務員法」（昭和25年法律第261号）", "第35条 職務に専念する義務", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "職員は、{{①}}に特別の定がある場合を除く外、その{{②}}のすべてをその{{③}}のために用い、{{④}}にのみ従事しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["法令", "勤務時間及び職務上の注意力", "職務遂行", "所属する組織の職務"]),
      fill_in_choice.call("イ", ["法律又は条例", "勤務時間", "公務遂行", "当該地方公共団体のすべての職務"]),
      fill_in_choice.call("ウ", ["法律又は規則", "職務上の注意力", "職責遂行", "任命権者が定める職務"]),
      fill_in_choice.call("エ", ["法律又は条例", "勤務時間及び職務上の注意力", "職責遂行", "当該地方公共団体がなすべき責を有する職務"], true),
    ],
    explanation_blocks: [
      text_block.call("地方公務員法第35条は、法律又は条例に特別の定がある場合を除き、職員が勤務時間及び職務上の注意力のすべてを職責遂行のために用い、当該地方公共団体がなすべき責を有する職務にのみ従事する義務を定めています。"),
    ],
    source_text: "e-Gov法令検索『地方公務員法』第35条（職務に専念する義務） | https://laws.e-gov.go.jp/law/325AC0000000261",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第2款 教育課程の編成 3 教育課程の編成における共通的事項 (5)", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "学校においては、第2章以下に示していない{{①}}を加えて指導することができる。〔中略〕ただし、これらの場合には、第2章以下に示す教科、科目及び特別活動の目標や内容の{{②}}を逸脱したり、生徒の{{③}}が過重となったりすることのないようにするものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["事項", "趣旨", "負担"], true),
      fill_in_choice.call("イ", ["科目", "範囲", "授業時数"]),
      fill_in_choice.call("ウ", ["科目", "趣旨", "学習内容"]),
      fill_in_choice.call("エ", ["事項", "範囲", "単位数"]),
    ],
    explanation_blocks: [
      text_block.call("高等学校では、第2章以下に示していない『事項』を加えて指導できます。ただし、各教科・科目及び特別活動の目標や内容の『趣旨』を逸脱せず、生徒の『負担』が過重とならないようにする必要があります。示された内容を超える指導が一律に禁止されているわけではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章総則第2款3(5) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実 (3)", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "その中で、生徒が{{①}}を考え主体的に進路を選択することができるよう、{{②}}を通じ、{{③}}な進路指導を行うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己の適性", "各教科・科目の授業", "個別的かつ継続的"]),
      fill_in_choice.call("イ", ["人間としての在り方生き方", "学校と地域社会", "自主的かつ実践的"]),
      fill_in_choice.call("ウ", ["自己の在り方生き方", "学校の教育活動全体", "組織的かつ計画的"], true),
      fill_in_choice.call("エ", ["自己の将来像", "特別活動", "体系的かつ段階的"]),
    ],
    explanation_blocks: [
      text_block.call("高等学校のキャリア教育では、生徒が『自己の在り方生き方』を考え、主体的に進路を選択できるようにすることが求められます。そのため、学校の教育活動全体を通じて、組織的かつ計画的な進路指導を行います。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款1(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第1 目標 (3)", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "探究に{{①}}に取り組むとともに、{{②}}を生かしながら、{{③}}を創造し、{{④}}を実現しようとする態度を養う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自主的・実践的", "それぞれの個性", "新しい知識", "持続可能な社会"]),
      fill_in_choice.call("イ", ["主体的・協働的", "互いのよさ", "新たな価値", "よりよい社会"], true),
      fill_in_choice.call("ウ", ["対話的・総合的", "多様な考え", "課題の解決策", "共生社会"]),
      fill_in_choice.call("エ", ["横断的・協働的", "自己の強み", "社会的価値", "地域社会"]),
    ],
    explanation_blocks: [
      text_block.call("総合的な探究の時間では、探究に主体的・協働的に取り組み、互いのよさを生かしながら、新たな価値を創造し、よりよい社会を実現しようとする態度を養うことが目標の一つです。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第4章第1(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第7款 道徳教育に関する配慮事項 3", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "学校やホームルーム内の{{①}}を整えるとともに、就業体験活動やボランティア活動、自然体験活動、地域の行事への参加などの{{②}}を充実すること。また、道徳教育の指導が、生徒の{{③}}に生かされるようにすること。その際、{{④}}等にも資することとなるように留意すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間関係や環境", "豊かな体験", "日常生活", "いじめの防止や安全の確保"], true),
      fill_in_choice.call("イ", ["規律や秩序", "勤労体験", "学校生活", "問題行動の早期発見"]),
      fill_in_choice.call("ウ", ["学習環境", "社会奉仕活動", "進路選択", "生命の尊重"]),
      fill_in_choice.call("エ", ["協働的な関係", "地域交流", "家庭生活", "情報モラルの向上"]),
    ],
    explanation_blocks: [
      text_block.call("道徳教育を進める際は、学校やホームルーム内の人間関係や環境を整え、就業体験活動などの豊かな体験を充実させます。指導を生徒の日常生活に生かし、いじめの防止や安全の確保等にも資するよう留意することが示されています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款3 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第5章 特別活動 第2〔ホームルーム活動〕1 目標", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "ホームルームや学校での生活をよりよくするための課題を見いだし、解決するために話し合い、{{①}}し、役割を分担して協力して実践したり、ホームルームでの話合いを生かして自己の課題の解決及び将来の生き方を描くために{{②}}して実践したりすることに、{{③}}、実践的に取り組むことを通して、第1の目標に掲げる資質・能力を育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["意思決定", "合意形成", "主体的"]),
      fill_in_choice.call("イ", ["集団決定", "意思決定", "主体的"]),
      fill_in_choice.call("ウ", ["合意形成", "自己決定", "協働的"]),
      fill_in_choice.call("エ", ["合意形成", "意思決定", "自主的"], true),
    ],
    explanation_blocks: [
      text_block.call("集団生活上の課題については話合いを通して『合意形成』し、自己の課題や将来の生き方については『意思決定』して実践します。また、目標の文言は『自主的、実践的に取り組む』です。集団の合意形成と個人の意思決定を区別することがポイントです。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第2〔ホームルーム活動〕1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("文部科学省「生徒指導提要」（令和4年12月）", "第1章 生徒指導の基礎 1.1.2 生徒指導の目的", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "(1) {{①}}の感受\n(2) {{②}}な人間関係の育成\n(3) {{③}}の場の提供\n(4) {{④}}な風土の醸成",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己肯定感", "支持的", "自己表現", "規律ある"]),
      fill_in_choice.call("イ", ["自己存在感", "共感的", "自己決定", "安全・安心"], true),
      fill_in_choice.call("ウ", ["自己有用感", "協働的", "役割選択", "開かれた"]),
      fill_in_choice.call("エ", ["所属感", "相互扶助的", "合意形成", "自由・公平"]),
    ],
    explanation_blocks: [
      text_block.call("『生徒指導提要』は、生徒指導実践上の視点として、①自己存在感の感受、②共感的な人間関係の育成、③自己決定の場の提供、④安全・安心な風土の醸成を示しています。自己肯定感や自己有用感は、自己存在感の感受と関連しますが、四視点の名称そのものではありません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.2 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ある生徒は、年齢や発達に不釣り合いな注意の持続の難しさに加え、衝動性や多動性を示し、学業や社会的な活動に支障が生じている。文部科学省が示す定義に照らして、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学習障害（LD）"),
      text_choice.call("イ", "高機能自閉症"),
      text_choice.call("ウ", "注意欠陥／多動性障害（ADHD）", true),
      text_choice.call("エ", "知的障害"),
    ],
    explanation_blocks: [
      text_block.call("文部科学省が示す定義では、注意欠陥／多動性障害（ADHD）は、年齢又は発達に不釣り合いな注意力、及び／又は衝動性、多動性を特徴とし、社会的な活動や学業の機能に支障を来す行動の障害です。学校では医療的な診断を行うのではなく、行動の背景と教育的ニーズを把握して必要な支援につなげます。"),
    ],
    source_text: "文部科学省『学習障害（LD）、注意欠陥／多動性障害（ADHD）及び高機能自閉症について』2 注意欠陥／多動性障害の定義 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1396626.htm",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エリクソン（Erikson, E. H.）の心理社会的発達理論における青年期の発達課題と、その時期に認められる社会的猶予の組合せとして、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "勤勉性 対 劣等感 ― アタッチメント"),
      text_choice.call("イ", "アイデンティティ 対 役割混乱 ― 心理社会的モラトリアム", true),
      text_choice.call("ウ", "世代性 対 停滞 ― モデリング"),
      text_choice.call("エ", "親密性 対 孤立 ― レディネス"),
    ],
    explanation_blocks: [
      text_block.call("エリクソンの第5段階に当たる青年期の危機は、アイデンティティ対役割混乱（アイデンティティ拡散）です。この時期には、社会的責任を直ちに全面的に引き受けず、様々な役割を試すことが許容される心理社会的モラトリアムが関係します。勤勉性対劣等感は学童期、親密性対孤立は成人初期、世代性対停滞は成人期の課題です。"),
    ],
    source_text: "APA Dictionary of Psychology『identity versus identity confusion』 | https://dictionary.apa.org/identity-versus-identity-confusion",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ある生徒は、課題を一人では解決できないが、教師の問いかけや、少し先を理解している仲間の援助があれば解決できる。この生徒の『単独で解決できる水準』と『援助を受けて解決できる水準』の間を表す概念として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "レディネス"),
      text_choice.call("イ", "心理社会的モラトリアム"),
      text_choice.call("ウ", "自己効力感"),
      text_choice.call("エ", "発達の最近接領域（ZPD）", true),
    ],
    explanation_blocks: [
      text_block.call("ヴィゴツキーの発達の最近接領域（ZPD）は、学習者が独力で達成できる水準と、より熟達した他者の援助や協働によって達成できる水準との差を指します。教師は、生徒が援助を受けながら可能にできる課題を見極め、徐々に援助を調整します。"),
    ],
    source_text: "APA Dictionary of Psychology『zone of proximal development』 | https://dictionary.apa.org/zone-of-proximal-development",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "new_japanese_school_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("中央教育審議会答申「「令和の日本型学校教育」の構築を目指して」（令和3年1月26日）", "第Ⅰ部 3 (1) 子供の学び", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "以上の「{{①}}」と「{{②}}」を教師視点から整理した概念が「{{③}}」であり、この「{{③}}」を学習者視点から整理した概念が「{{④}}」である。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["指導の個別化", "学習の個性化", "個に応じた指導", "個別最適な学び"], true),
      fill_in_choice.call("イ", ["学習の個別化", "指導の個性化", "個別最適な学び", "個に応じた指導"]),
      fill_in_choice.call("ウ", ["指導の重点化", "学習の協働化", "個別指導", "主体的な学び"]),
      fill_in_choice.call("エ", ["指導の個性化", "学習の個別化", "協働的な学び", "個別最適な学び"]),
    ],
    explanation_blocks: [
      text_block.call("答申は、『指導の個別化』と『学習の個性化』を教師視点から整理した概念を『個に応じた指導』、それを学習者視点から整理した概念を『個別最適な学び』としています。個別最適な学びが孤立した学びに陥らないよう、協働的な学びと一体的に充実させることも重要です。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して』（答申）第Ⅰ部3(1)「子供の学び」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第2款 第1「情報Ⅰ」2 (4) ア (イ)", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "データを{{①}}する方法、{{②}}を介して{{③}}がサービスを提供する{{④}}について理解すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["収集、分析、可視化", "インターネット", "データベース", "構成と機能"]),
      fill_in_choice.call("イ", ["蓄積、検索、共有", "通信回線", "サーバ", "役割と課題"]),
      fill_in_choice.call("ウ", ["蓄積、管理、提供", "情報通信ネットワーク", "情報システム", "仕組みと特徴"], true),
      fill_in_choice.call("エ", ["生成、加工、発信", "ネットワーク", "情報サービス", "利点と危険性"]),
    ],
    explanation_blocks: [
      text_block.call("『情報Ⅰ』では、データを蓄積、管理、提供する方法に加え、情報通信ネットワークを介して情報システムがサービスを提供する仕組みと特徴を理解することが求められます。データベース、ネットワーク、情報システムを関連付けて捉えることがポイントです。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(4)ア(イ) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第2款 第2「情報Ⅱ」2 内容", "{{①}} ～ {{⑤}}"),
      },
      {
        type: "fill_in_quote",
        text: "(1) {{①}}\n(2) {{②}}\n(3) {{③}}\n(4) {{④}}\n(5) {{⑤}}",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["情報社会の問題解決", "コミュニケーションと情報デザイン", "コンピュータとプログラミング", "情報通信ネットワークとデータの活用", "情報社会の課題研究"]),
      fill_in_choice.call("イ", ["情報社会の進展と情報技術", "情報デザインとコンテンツ", "データの活用", "情報システムの設計", "情報技術を活用した探究活動"]),
      fill_in_choice.call("ウ", ["情報産業と社会", "コンテンツの制作と発信", "データベース", "情報システムのプログラミング", "課題研究"]),
      fill_in_choice.call("エ", ["情報社会の進展と情報技術", "コミュニケーションとコンテンツ", "情報とデータサイエンス", "情報システムとプログラミング", "情報と情報技術を活用した問題発見・解決の探究"], true),
    ],
    explanation_blocks: [
      text_block.call("『情報Ⅱ』は、(1)情報社会の進展と情報技術、(2)コミュニケーションとコンテンツ、(3)情報とデータサイエンス、(4)情報システムとプログラミング、(5)情報と情報技術を活用した問題発見・解決の探究の五項目で構成されます。アの最初の四項目は『情報Ⅰ』の内容構成です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2「内容」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      text_block.call("高等学校学習指導要領における、専門教科「情報」の各科目にわたる指導計画の作成に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『情報テクノロジー』及び『情報実習』を原則として全ての生徒に履修させ、総授業時数の10分の3以上を実験・実習に配当する。"),
      text_choice.call("イ", "『情報セキュリティ』及び『情報システムのプログラミング』を原則として全ての生徒に履修させ、総授業時数の全てを実験・実習に配当する。"),
      text_choice.call("ウ", "『情報産業と社会』及び『課題研究』を原則として全ての生徒に履修させ、情報科に属する科目の総授業時数の10分の5以上を実験・実習に配当する。", true),
      text_choice.call("エ", "必履修科目は各学校が自由に定め、実験・実習に配当する授業時数についても基準を設けない。"),
    ],
    explanation_blocks: [
      text_block.call("情報に関する各学科では、『情報産業と社会』及び『課題研究』を原則として全ての生徒に履修させます。また、原則として専門教科情報に属する科目の総授業時数の10分の5以上を実験・実習に配当します。共通教科情報の『情報Ⅰ』の必履修規定と混同しないことが重要です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第3款1(2)(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "algorithm",
    content_blocks: [
      text_block.call("次のプログラムは、逆ポーランド記法で表された式をスタックで評価し、計算中のスタックの最大要素数も求めるものである。tokens = [5, 1, 2, \"+\", 4, \"*\", \"+\", 3, \"-\"] として実行したとき、最後の result と max_depth の組合せとして正しいものを選びなさい。演算子 token に対する『x token y』は、x と y の順で演算するものとする。"),
      {
        type: "code",
        title: "スタックによる式の評価",
        code: "stack = 空のスタック\nmax_depth = 0\n\ntokens の各 token について:\n  もし token が数なら:\n    token を stack に push\n  そうでなければ:\n    y = stack から pop\n    x = stack から pop\n    x token y の計算結果を stack に push\n\n  もし stack の要素数 > max_depth なら:\n    max_depth = stack の要素数\n\nresult = stack から pop\nresult と max_depth を出力する",
      },
    ],
    choices: [
      text_choice.call("ア", "result = 14、max_depth = 2"),
      text_choice.call("イ", "result = 14、max_depth = 3", true),
      text_choice.call("ウ", "result = 16、max_depth = 3"),
      text_choice.call("エ", "result = 16、max_depth = 4"),
    ],
    explanation_blocks: [
      text_block.call("数はスタックに積み、演算子が現れたら後から取り出した値を右辺 y、先に取り出した値を左辺 x として計算します。式の値は 5 + ((1 + 2) × 4) - 3 = 14 です。最初の 5、1、2 を積んだ時点などで要素数が3となり、これを超えないため max_depth は3です。"),
      {
        type: "code",
        title: "主なスタックの変化",
        code: "5, 1, 2  -> [5, 1, 2]（深さ3）\n+        -> [5, 3]\n4        -> [5, 3, 4]（深さ3）\n*        -> [5, 12]\n+        -> [17]\n3, -     -> [14]",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "data_science",
    content_blocks: [
      text_block.call("全国の高校生の動画視聴時間を推定するため、ある動画配信者が自分のSNSのフォロワーに回答を呼びかけ、回答のあった2万人の平均を全国の高校生の平均として発表した。この調査結果の解釈として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "回答者数が多くても、対象者の選ばれ方や自発的回答による偏りがあり得るため、そのまま全国の高校生へ一般化することはできない。", true),
      text_choice.call("イ", "回答者が1万人を超えていれば、抽出方法に関係なく標本は必ず母集団を代表する。"),
      text_choice.call("ウ", "SNSを使った調査は全数調査に当たるため、標本誤差や選択の偏りを考える必要はない。"),
      text_choice.call("エ", "平均値を中央値に置き換えれば、対象者の選ばれ方に起因する偏りは完全に解消される。"),
    ],
    explanation_blocks: [
      text_block.call("標本の大きさが大きくても、その標本が母集団から偏りなく選ばれていなければ、母集団の代表とは限りません。この調査では、特定の配信者のフォロワーであることに加え、回答するかどうかを本人が選ぶことによる選択の偏りが考えられます。母集団を代表するような標本抽出の設計が必要です。"),
    ],
    source_text: "総務省統計局『全数調査・標本調査』 | https://www.stat.go.jp/naruhodo/7_shurui/zensu.html\n総務省統計局 Data StaRt『インターネット調査』 | https://www.stat.go.jp/dstart/point/seminar/02/2-2-2.html",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験2は問1から問20までの20問で構成してください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 2,
      question_number: attributes.fetch(:question_number),
    )
    question.assign_attributes(question_attributes.merge(publication_status: "draft"))
    question.save!

    question.question_choices.update_all(is_correct: false)

    labels = choices.map { |choice| choice.fetch(:label) }
    question.question_choices.where.not(choice_label: labels).destroy_all

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
      raise "模擬試験2 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

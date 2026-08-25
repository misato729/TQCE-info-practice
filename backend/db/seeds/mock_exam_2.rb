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
      text_block.call("1879（明治12）年の教育令と1880（明治13）年の改正教育令に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育令は、全国を学区に分けて小学校設置を画一的に進めた学制の中央集権性を更に強め、改正教育令はその権限を地方に広く委ねた。"),
      text_choice.call("イ", "教育令は義務教育の期間を九年と定め、改正教育令は小学校を尋常小学校六年と高等小学校三年に分けて、現在の九年制義務教育の基礎を定めた。"),
      text_choice.call("ウ", "教育令は学制の中央集権的・画一的な性格を改め、地方の自由を重んじる方向を採ったが、就学状況の後退などが問題となり、改正教育令では国家の統制が再び強化された。", true),
      text_choice.call("エ", "教育令によって帝国大学令、師範学校令、小学校令及び中学校令が初めて整備され、改正教育令によって学校種別ごとの制度が廃止された。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。教育令と改正教育令の方向を逆にしています。イは誤りです。九年の義務教育や六・三制を定めた法令ではありません。ウが適切です。教育令は学制の画一性を緩和しましたが、その後の改正で国家の統制が強化されました。エは誤りです。学校種別の四学校令は1886（明治19）年に公布されたもので、教育令や改正教育令によるものではありません。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第一章第二節「二 教育令・改正教育令と小学校の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317588.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("西洋の教育思想家とその著作又は教育実践に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "コメニウスは『世界図絵』を著したが、感覚を通じた学習は知性を妨げると考えたため、挿絵を用いず抽象的な定義の暗記だけで言葉を教えた。", true),
      text_choice.call("イ", "ルソーは『エミール』において、大人の価値観や社会の悪影響を性急に子供に押し付けず、子供の自然な発達に即する消極教育を論じた。"),
      text_choice.call("ウ", "フレーベルは幼児の自己活動と遊びを重視し、子供が自ら操作する教育遊具である恩物を考案するとともに、Kindergartenを創設した。"),
      text_choice.call("エ", "デューイは『学校と社会』などを通じ、学校を小さな社会と捉え、子供の経験に基づく活動と共同的な問題解決を重視する教育を展開した。"),
    ],
    explanation_blocks: [
      text_block.call("アが不適切です。『世界図絵』は事物の図とことばを結び付けた絵入り教材であり、挿絵を避けた暗記中心の著作とする説明とは逆です。イは適切で、ルソーの消極教育の説明です。ウは適切で、フレーベルのKindergartenと恩物に対応します。エは適切で、デューイの経験主義的な教育思想を示しています。"),
    ],
    source_text: "国立国会図書館国際子ども図書館 Research Navi『コメニウス「世界図絵」』 | https://ndlsearch.ndl.go.jp/en/rnavi/children/post_237\nStanford Encyclopedia of Philosophy『Jean-Jacques Rousseau』 | https://plato.stanford.edu/entries/rousseau/\nFriedrich-Fröbel-Museum “Froebel’s theory of education” | https://froebel-museum.de/pages/en/friedrich-froebel/froebel92s-theory.php?lang=EN\nStanford Encyclopedia of Philosophy『John Dewey』5. Philosophy of Education | https://plato.stanford.edu/entries/dewey/",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
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
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第51条　{{①}}に努めるとともに、社会について、{{②}}理解と{{③}}を養い、{{④}}に寄与する態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人格の完成", "幅広く深い", "健全な判断力", "国家及び社会の形成"]),
      fill_in_choice.call("イ", ["個性の確立", "広く深い", "健全な批判力", "社会の発展"], true),
      fill_in_choice.call("ウ", ["個性の尊重", "広く正確な", "公正な批判力", "社会の形成"]),
      fill_in_choice.call("エ", ["人格の確立", "幅広く体系的な", "論理的な思考力", "文化の発展"]),
    ],
    explanation_blocks: [
      text_block.call("学校教育法第51条第3号は、高等学校教育の目標として、個性の確立に努めること、社会について広く深い理解と健全な批判力を養うこと、社会の発展に寄与する態度を養うことを定めています。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第51条第3号 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第35条　職員は、{{①}}に特別の定がある場合を除く外、その{{②}}のすべてをその{{③}}のために用い、{{④}}にのみ従事しなければならない。",
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
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "第２款の２の（1）に示す{{①}}の育成を図るため，各学校において，{{②}}を活用するために必要な環境を整え，これらを適切に活用した{{③}}の充実を図ること。また，{{④}}，視聴覚教材や教育機器などの教材・教具の適切な活用を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["情報活用能力", "コンピュータや情報通信ネットワークなどの情報手段", "学習活動", "各種の統計資料や新聞"], true),
      fill_in_choice.call("イ", ["情報モラル", "デジタル教材や学習支援システムなどの教育資源", "個別学習", "教科書や副教材"]),
      fill_in_choice.call("ウ", ["問題発見・解決能力", "図書館や博物館などの社会教育施設", "探究活動", "地域の人的資源や産業施設"]),
      fill_in_choice.call("エ", ["言語能力", "新聞や視聴覚教材などのメディア", "言語活動", "各種の図書資料や統計資料"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。情報活用能力の育成のため、『コンピュータや情報通信ネットワークなどの情報手段』を活用できる環境を整え、それらを用いた『学習活動』を充実するとともに、『各種の統計資料や新聞』等を適切に活用します。イ、ウ、エはいずれも教育活動に関係する語句を含みますが、四つの空欄を満たすこの段落の原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "career_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実", "{{①}} ～ {{③}}"),
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
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第1 目標", "{{①}} ～ {{④}}"),
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
    category_code: "moral_education",
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
    category_code: "special_activities",
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
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "児童生徒の自己指導能力の獲得を支える生徒指導では、多様な教育活動を通して、児童生徒が主体的に課題に挑戦してみることや多様な他者と協働して創意工夫することの重要性等を実感することが大切です。以下に、その際に留意する実践上の視点を示します。\n\n(1) {{①}}の感受\n(2) {{②}}な人間関係の育成\n(3) {{③}}の場の提供\n(4) 安全・安心な風土の醸成",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己肯定感", "支持的", "自己表現"]),
      fill_in_choice.call("イ", ["自己存在感", "共感的", "自己決定"], true),
      fill_in_choice.call("ウ", ["自己有用感", "協働的", "役割選択"]),
      fill_in_choice.call("エ", ["所属感", "相互扶助的", "合意形成"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。四つの実践上の視点は、『自己存在感の感受』『共感的な人間関係の育成』『自己決定の場の提供』『安全・安心な風土の醸成』です。アの自己肯定感や自己表現、ウの自己有用感や役割選択は関連する概念ですが、四視点の名称ではありません。エの所属感、相互扶助的な人間関係、合意形成も教育活動で重視され得ますが、この箇所の原文とは一致しません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.2 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("次の①～④は、発達障害のある生徒に見られ得る困難の把握と教育的対応に関する記述である。適切なものの組合せとして正しいものを、下のア～エの中から一つ選んで記号で答えなさい。\n① 読み誤りが続く生徒には、努力不足を自覚させるため音読量だけを増やし、文字の拡大、読み上げ、分かち書き等は正確な診断が確定するまで用いない。\n② 不注意や衝動性による困難が考えられるときは、指示を短く具体的にし、予定や手順を視覚化し、課題を小さな段階に分けるなど、実態に応じた環境調整を検討する。\n③ ASDのある生徒が流暢に話せる場合、曖昧な指示や暗黙の了解も必ず理解できるため、予定変更の予告や規則の明示は行わない。\n④ LD、ADHD、ASDの特徴は重なって現れることもあるため、一つの行動だけで障害を決め付けず、複数場面の観察、本人・保護者との相談、校内委員会や専門家との連携を通して教育的ニーズを把握する。"),
    ],
    choices: [
      text_choice.call("ア", "①・③"),
      text_choice.call("イ", "①・④"),
      text_choice.call("ウ", "②・④", true),
      text_choice.call("エ", "②・③"),
    ],
    explanation_blocks: [
      text_block.call("②と④が適切であるため、正答はウです。①は、読みの困難を努力不足と決め付け、診断前の教育的支援を止める点が誤りです。②は、ADHDに伴い得る実行・注意の困難への具体的な調整として適切です。③は、表出言語の流暢さと、曖昧な社会的情報や変化の理解とは同一ではなく、予告や明示が有効な場合があるため誤りです。④は、特徴の重なりと個人差を踏まえた多面的な把握として適切です。アとイは誤った①を含み、エは誤った③を含みます。"),
    ],
    source_text: "文部科学省『学習障害（LD）、注意欠陥／多動性障害（ADHD）及び高機能自閉症について』2 注意欠陥／多動性障害の定義 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1396626.htm",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エリクソン（Erikson, E. H.）の心理社会的発達理論における青年期の発達課題に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "青年期の発達課題は勤勉性対劣等感であり、学習活動を通して有能感を獲得することが中心となるため、職業や価値観の選択を試みる期間は発達上望ましくない。"),
      text_choice.call("イ", "青年期の発達課題は同一性対同一性混乱であり、自分の価値観、職業、役割などを探索する過程が重視され、最終的な決定を一定期間猶予される状態は心理社会的モラトリアムと呼ばれる。", true),
      text_choice.call("ウ", "青年期の発達課題は親密性対孤立であり、社会的責任を負わずに友人関係だけを広げることによって、将来の職業的役割が自動的に確立される。"),
      text_choice.call("エ", "青年期の発達課題は世代性対停滞であり、次の世代を育成する活動へ参加することで、児童期までに完成した同一性を社会的に証明することが中心となる。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。勤勉性対劣等感は主として学童期の発達課題です。イが適切です。青年期には「自分は何者か」を探索し、職業や価値観などに関する同一性の確立が課題となります。ウは誤りです。親密性対孤立は主として成人期初期の発達課題であり、友人関係だけで職業的同一性が自動的に確立するわけではありません。エは誤りです。世代性対停滞は主として成人期の発達課題です。"),
    ],
    source_text: "APA Dictionary of Psychology『identity versus identity confusion』 | https://dictionary.apa.org/identity-versus-identity-confusion",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ヴィゴツキー（Vygotsky, L. S.）の「発達の最近接領域」と、それに基づく学習支援に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "発達の最近接領域は、学習者が一人で遂行できる水準と、教師や能力の高い仲間から援助を受けることで遂行できる水準との間にある領域を示す。"),
      text_choice.call("イ", "現在一人で遂行できる課題だけで能力を判断するのではなく、援助を受けた場合にどこまで遂行できるかを見ることによって、今後発達し得る可能性を捉えようとする。"),
      text_choice.call("ウ", "教師は、手掛かり、例示、問い返しなどの支援を学習者の状態に応じて与え、自力で遂行できるようになるにつれて、その支援を段階的に減らすことが求められる。"),
      text_choice.call("エ", "学習者が自力で課題を遂行できるようになった後も、誤りを防ぐために当初と同じ最大限の援助を固定的に与え続けることが、発達の最近接領域を広げるために必要である。", true),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。独力による遂行水準と、援助を受けた場合の遂行水準との差に着目しています。イは適切です。既に完成した能力だけでなく、適切な援助によって発達しつつある能力を捉える考え方です。ウは適切です。一時的な支援を与え、学習者の習熟に応じて減らす考え方は足場かけと説明されます。エが不適切です。支援は学習者の状態に応じて調整し、自立に伴って減らす必要があります。"),
    ],
    source_text: "APA Dictionary of Psychology『zone of proximal development』 | https://dictionary.apa.org/zone-of-proximal-development",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された『個別最適な学び』に関する記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『指導の個別化』と『学習の個性化』を教師視点から整理した概念が『個に応じた指導』であり、これを学習者視点から整理した概念が『個別最適な学び』である。個別最適な学びと協働的な学びは一体的に充実させることが重要である。", true),
      text_choice.call("イ", "『学習の個別化』とは全ての児童生徒に同じ方法と速度で基礎事項を教えることであり、『指導の個性化』とは学習者が教師の計画どおりに同一課題を反復することである。両者を合わせて『協働的な学び』という。"),
      text_choice.call("ウ", "『個別最適な学び』は、児童生徒を集団から分離して一人で学ばせることを原則とし、他者との関わりによる学びは個別最適化を妨げるため、協働的な学びとは別々に実施する。"),
      text_choice.call("エ", "『個に応じた指導』は学習者視点、『個別最適な学び』は教師視点の概念である。学習内容の確実な定着は学習者の興味・関心に委ね、教師による指導方法や教材の工夫は行わない。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。答申は、『指導の個別化』と『学習の個性化』を教師視点から整理した概念を『個に応じた指導』、これを学習者視点から整理した概念を『個別最適な学び』としています。また、個別最適な学びが孤立した学びに陥らないよう、協働的な学びと一体的に充実させます。イは二つの概念の内容と総称を誤り、ウは個別最適な学びを孤立した学びに限定し、エは教師視点と学習者視点を逆にして指導上の工夫を否定しているため、いずれも不適切です。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部3(1)「子供の学び」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第1 情報Ⅰ 2 内容 (4) 情報通信ネットワークとデータの活用", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "（4）情報通信ネットワークとデータの活用\n情報通信ネットワークを介して流通するデータに着目し，情報通信ネットワークや情報システムにより提供されるサービスを活用し，問題を発見・解決する活動を通して，次の事項を身に付けることができるよう指導する。\n\nア　次のような知識及び技能を身に付けること。\n（ア）情報通信ネットワークの仕組みや構成要素，プロトコルの役割及び情報セキュリティを確保するための方法や技術について理解すること。\n（イ）データを{{①}}する方法，{{②}}を介して{{③}}がサービスを提供する{{④}}について理解すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["収集，分析，可視化", "インターネット", "データベース", "構成と機能"]),
      fill_in_choice.call("イ", ["蓄積，検索，共有", "通信回線", "サーバ", "役割と課題"]),
      fill_in_choice.call("ウ", ["蓄積，管理，提供", "情報通信ネットワーク", "情報システム", "仕組みと特徴"], true),
      fill_in_choice.call("エ", ["生成，加工，発信", "ネットワーク", "情報サービス", "利点と危険性"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。データを『蓄積，管理，提供』する方法と、情報通信ネットワークを介して情報システムがサービスを提供する『仕組みと特徴』を関連付けて理解することが求められています。アの『収集，分析，可視化』はデータ分析に関係しますが、この箇所の語句ではなく、サービスを提供する主体もデータベースではありません。イの『蓄積，検索，共有』『通信回線』『サーバ』『役割と課題』は、いずれも原文の組合せではありません。エの『生成，加工，発信』や『利点と危険性』も関連する学習内容ですが、この箇所の表現ではなく、『ネットワーク』『情報サービス』も正式な語句と一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(4)ア(イ) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第3章 主として専門学科において開設される各教科 第7節 情報 第3款 各科目にわたる指導計画の作成と内容の取扱い", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "1 指導計画の作成に当たっては，次の事項に配慮するものとする。\n(2) 情報に関する各学科においては，「{{①}}」及び「{{②}}」を原則として全ての生徒に履修させること。\n(3) 情報に関する各学科においては，原則としてこの章に示す情報科に属する科目に配当する総授業時数の10分の{{③}}以上を実験・実習に配当すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["情報テクノロジー", "情報実習", "3"]),
      fill_in_choice.call("イ", ["情報産業と社会", "情報実習", "5"]),
      fill_in_choice.call("ウ", ["情報テクノロジー", "課題研究", "3"]),
      fill_in_choice.call("エ", ["情報産業と社会", "課題研究", "5"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。情報に関する各学科では「情報産業と社会」と「課題研究」を原則として全ての生徒に履修させ、専門教科情報科に属する科目の総授業時数の10分の5以上を実験・実習に配当します。アは両科目と割合、イは2科目目、ウは1科目目と割合が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第3款1(2)(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      text_block.call("『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の第1部「各学科に共通する教科『情報』」に示された「情報Ⅰ」の「情報社会の問題解決」の位置付けと内容の取扱いに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『情報Ⅰ』の全内容を学習した後に成果を確認する終末課題として位置付け、（2）から（4）までとは関連付けず、個人で情報機器の操作技能だけを評価する。"),
      text_choice.call("イ", "法規や制度、情報セキュリティ、情報モラルは用語を記憶させる内容であるため、生徒が情報社会の問題を発見したり、解決策を考えたりする活動から切り離して指導する。"),
      text_choice.call("ウ", "『情報Ⅰ』の導入として位置付け、（2）から（4）までとの関連に配慮するとともに、情報社会の問題を生徒が主体的に発見し明確化し、解決策を考える活動を取り入れる。", true),
      text_choice.call("エ", "中学校までの問題解決学習との連続性は設けず、高等学校で初めて問題発見・解決の方法を扱い、公民科をはじめとする他教科との関連も避ける。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。解説は「情報社会の問題解決」を『情報Ⅰ』の導入とし、（2）から（4）との関連に配慮した上で、生徒が情報社会の問題を主体的に発見・明確化し、解決策を考える活動を取り入れるとしています。アは導入を終末課題とし他内容から切り離す点、イは法規等を問題発見・解決活動から切り離す点、エは中学校までの学習や公民科等との関連を否定する点が誤りです。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部第2章第1節2(1)「情報社会の問題解決」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
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
    category_code: "information_specialized",
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

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

# 模擬試験16（承認済みの問1〜15。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("大正期の大学制度の改革について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "大正7年の大学令は，大学に学部を置き，必要な場合には予科を設けることを定め，大学制度の拡張を図った。これに伴って従来の帝国大学令は廃止され，帝国大学を含む官立・公立・私立の大学が同じ大学令によって設置されることになった。"),
      text_choice.call("イ", "大正7年の大学令では，官立大学に加えて公立・私立大学の設置が認められ，私立大学には財団法人としての財産などが求められた。大学は複数の学部を備える総合大学として組織することとされ，単科大学は専門学校の制度に位置付けられた。"),
      text_choice.call("ウ", "大正7年の大学令は，従来の帝国大学令を存続させつつ，官立・公立・私立大学を制度化した。複数の学部を置くことを原則としながら単科大学も認められ，この制度の下で，東京高等商業学校は東京商科大学へ昇格し，慶應義塾や早稲田にも大学設置が認可された。", true),
      text_choice.call("エ", "大正7年の大学令によって私立大学の設置が認められ，慶應義塾や早稲田は大正9年に大学として認可された。その際，それまで官立の帝国大学に置かれていた分科大学を各校にも設け，それぞれの分科大学を学部に相当する教育組織とした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：帝国大学令が廃止されたとする点が誤り。帝国大学令は，帝国大学に関する規定として存続した。"),
      text_block.call("イ：単科大学の扱いが誤り。大学令は，一学部からなる大学も認めていた。"),
      text_block.call("ウ：適切。大正7年（1918年）の大学令によって大学の設置主体と形態が拡張され，大正9年（1920年）には東京商科大学の設置と慶應義塾・早稲田などの大学認可が行われた。"),
      text_block.call("エ：分科大学を新たな制度で維持したとする点が誤り。分科大学の名称は廃され，「学部」とされた。"),
    ],
    source_text: "文部科学省『学制百年史』・二「大学令の制定と大学の拡張」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317663.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("スペンサーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育を「完全な生活」のための準備と捉え，自己保存，生計，子どもの養育，社会的・政治的活動，余暇に関わる活動を考察した。古典語を重んじる伝統的な教育に対し，これらの生活上の活動に役立つ知識として科学の価値を高く評価した。", true),
      text_choice.call("イ", "教育を「完全な生活」のための準備と捉え，生活上の活動を重要性に応じて位置付けた。社会的・政治的活動に必要な知識を教育課程の最優先事項とし，生命と健康を保つ自己保存に関する知識を，その基礎を支える第二の事項に位置付けた。"),
      text_choice.call("ウ", "子どもの発達の自然な過程を尊重し，教授方法も精神の発達法則に従うべきだと考えた。具体的な事物の観察を学習へ取り入れるに当たっては，抽象的な概念を先に体系的に説明し，その概念を具体的な事物に当てはめる順序を原則とした。"),
      text_choice.call("エ", "知育・徳育・体育のそれぞれを論じ，徳育では子どもが行為の結果を理解することを重視した。そのため，行為から自然に生じる結果に任せるよりも，親が行為に応じた罰を設け，その罰と行為との関係を子どもに説明する方法を基本とした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。生活の諸活動に役立つ知識を検討し，科学を最も価値ある知識として重視した。"),
      text_block.call("イ：活動の位置付けが誤り。直接の自己保存が最初に置かれ，社会的・政治的活動は，間接的な自己保存（生計），子どもの養育に続く位置にある。"),
      text_block.call("ウ：教授の順序が逆。「抽象的なものから具体的なものへ」ではなく，「具体的なものから抽象的なものへ」が原則である。"),
      text_block.call("エ：徳育の方法が誤り。スペンサーは行為の自然的な結果から学ぶことを重視し，人為的な罰によって道徳を教える方法を批判した。"),
    ],
    source_text: "川瀬八洲夫「H．スペンサーの教育思想―我が国における受容の諸問題を中心にして―」『東京家政大学研究紀要』第8集・147〜148頁 | https://tokyo-kasei.repo.nii.ac.jp/record/11187/files/2011_k_0131.pdf\nスペンサー著・三笠乙彦訳『知育・徳育・体育論』・国立国会図書館サーチ書誌 | https://ndlsearch.ndl.go.jp/books/R100000001-I06111100054843",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，正しいものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "第2条は，教育の目標を学問の自由を尊重しつつ達成することとし，社会の形成への参画については，公共の福祉に基づき，主体的にその発展に寄与する態度を養うことを掲げている。"),
      text_choice.call("イ", "第2条は，生命を尊び，自然を大切にし，環境の保全に寄与する態度を養うことを掲げている。また，伝統と文化を尊重し，我が国と郷土を愛することと，他国を尊重し，国際社会の平和と発展に寄与することを併せて掲げている。", true),
      text_choice.call("ウ", "第17条は，政府が教育の振興に関する施策の総合的かつ計画的な推進を図るため，基本的な計画を定め，これを内閣に報告するとともに，公表することを定めている。"),
      text_choice.call("エ", "第13条は，学校，家庭及び地域住民その他の関係者が，教育におけるそれぞれの役割と責任を自覚することを定めるとともに，相互の連携及び協力に努める主体を，国及び地方公共団体としている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：第2条第3号の文言は「公共の精神」であり，「公共の福祉」ではない。学問の自由を尊重する点や，主体的な参画を重視する点は正しい。"),
      text_block.call("イ：正しい。第2条第4号の生命・自然・環境に関する内容と，第5号の伝統・文化，我が国と郷土，他国及び国際社会に関する内容に一致する。"),
      text_block.call("ウ：報告先が誤り。第17条第1項が定める報告先は「国会」であり，「内閣」ではない。"),
      text_block.call("エ：連携・協力に努める主体が誤り。第13条では，いずれも「学校、家庭及び地域住民その他の関係者」が主体である。"),
    ],
    source_text: "教育基本法・第2条、第13条、第17条第1項 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第3条\n学校を設置しようとする者は、学校の種類に応じ、{{①}}の定める設備、編制その他に関する{{②}}に従い、これを設置しなければならない。\n\n第5条\n{{③}}は、その設置する学校を管理し、法令に特別の定のある場合を除いては、その学校の経費を負担する。\n\n第7条\n学校には、{{④}}を置かなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "設置基準", "国及び地方公共団体", "校長及び相当数の教員"]),
      fill_in_choice.call("イ", ["都道府県の教育委員会", "設置認可基準", "学校の設置者", "校長及び相当数の教員"]),
      fill_in_choice.call("ウ", ["文部科学大臣", "設置認可基準", "学校の設置者", "校長及び教頭"]),
      fill_in_choice.call("エ", ["文部科学大臣", "設置基準", "学校の設置者", "校長及び相当数の教員"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：③が異なる。管理・経費負担の主体は「学校の設置者」であり，国及び地方公共団体に限らない。私立学校の設置者も含まれる。"),
      text_block.call("イ：①は「文部科学大臣」，②は「設置基準」。設置認可を行う主体と，全国的な設置基準を定める主体を区別する。"),
      text_block.call("ウ：②は「設置基準」，④は「校長及び相当数の教員」。個別校種の教頭に関する規定と，学校一般に適用される第7条を区別する。"),
      text_block.call("エ：四つとも原文と一致する。"),
    ],
    source_text: "学校教育法・第3条、第5条、第7条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条\n教育公務員には、{{①}}が与えられなければならない。\n\n2　教員は、授業に支障のない限り、{{②}}の承認を受けて、勤務場所を離れて研修を行うことができる。\n\n3　教育公務員は、{{③}}（第二十条第一項第一号に掲げる者については、同号に定める市町村の教育委員会。以下この章において同じ。）の定めるところにより、{{④}}で、長期にわたる研修を受けることができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修を受ける機会", "任命権者", "本属長", "現職のまま"]),
      fill_in_choice.call("イ", ["研究を行う時間", "本属長", "任命権者", "休職中"]),
      fill_in_choice.call("ウ", ["研修を受ける機会", "本属長", "任命権者", "現職のまま"], true),
      fill_in_choice.call("エ", ["研究を行う時間", "任命権者", "本属長", "休職中"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②と③の主体が逆。勤務場所を離れる研修では「本属長」の承認を受け，長期研修は「任命権者」の定めるところによる。"),
      text_block.call("イ：①は「研修を受ける機会」，④は「現職のまま」。研究時間の保障や休職中の研修を規定した文章ではない。"),
      text_block.call("ウ：四つとも原文と一致する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条第1項〜第3項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第２款の２の（1）に示す言語能力の育成を図るため，各学校において必要な言語環境を整えるとともに，{{①}}を要としつつ{{②}}に応じて，生徒の言語活動を充実すること。あわせて，（6）に示すとおり{{③}}を充実すること。" },
      text_block.call("参考：抜粋中の（6）は，学校図書館や地域の図書館等の活用に関する規定を指す。"),
    ],
    choices: [
      fill_in_choice.call("ア", ["国語科", "生徒の言語能力の発達の段階", "読書活動"]),
      fill_in_choice.call("イ", ["総合的な探究の時間", "各教科・科目等の特質", "表現活動"]),
      fill_in_choice.call("ウ", ["総合的な探究の時間", "生徒の言語能力の発達の段階", "読書活動"]),
      fill_in_choice.call("エ", ["国語科", "各教科・科目等の特質", "読書活動"], true),
    ],
    explanation_blocks: [
      text_block.call("国語科を要としつつ，各教科・科目等の特質に応じて言語活動を充実し，読書活動も充実することが示されている。アは②が異なり，この箇所で対応させるのは言語能力の発達段階ではなく教科等の特質である。イは①が「国語科」，③が「読書活動」である。ウは①・②が異なる。"),
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款1（2） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（ｱ）学校においては，生徒が学校の定める{{①}}に従って通級による指導を履修し，その成果が{{②}}からみて満足できると認められる場合には，当該学校の単位を修得したことを認定しなければならない。\n\n（ｲ）学校においては，生徒が通級による指導を２以上の年次にわたって履修したときは，{{③}}に当該学校の単位を修得したことを認定することを原則とする。ただし，年度途中から通級による指導を開始するなど，特定の年度における授業時数が，１単位として計算する標準の単位時間に満たない場合は，次年度以降に通級による指導の時間を設定し，２以上の年次にわたる授業時数を{{④}}して単位の修得の認定を行うことができる。また，単位の修得の認定を学期の区分ごとに行うことができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["個別の教育支援計画", "個別に設定された指導目標", "各年次ごと", "合算"]),
      fill_in_choice.call("イ", ["個別の指導計画", "個別に設定された指導目標", "各年次ごと", "合算"], true),
      fill_in_choice.call("ウ", ["個別の指導計画", "各教科・科目の目標", "最終年次", "平均"]),
      fill_in_choice.call("エ", ["個別の教育支援計画", "各教科・科目の目標", "最終年次", "合算"]),
    ],
    explanation_blocks: [
      text_block.call("個別の指導計画に従った履修と，個別に設定された指導目標に照らした成果に基づき認定する。複数年次の履修でも各年次ごとの認定が原則であり，条件を満たす場合に授業時数を合算できる。アは①が異なる。ウは②・③・④が異なり，最終年次に平均時数で認定する規定ではない。エは①・②・③が異なる。"),
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款2（1）イ（ｱ）・（ｲ） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第2 各学校において定める目標及び内容」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）各学校において定める目標については，各学校における{{①}}を踏まえ，総合的な探究の時間を通して育成を目指す資質・能力を示すこと。\n\n（2）各学校において定める目標及び内容については，他教科等の目標及び内容との違いに留意しつつ，他教科等で育成を目指す資質・能力との{{②}}を重視すること。\n\n（3）各学校において定める目標及び内容については，{{③}}との関わりを重視すること。\n\n（4）各学校において定める内容については，目標を実現するにふさわしい探究課題，探究課題の解決を通して育成を目指す{{④}}を示すこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育目標", "関連", "地域や社会", "具体的な資質・能力"], true),
      fill_in_choice.call("イ", ["教育課程", "関連", "地域や社会", "具体的な資質・能力"]),
      fill_in_choice.call("ウ", ["教育目標", "共通性", "学校内の各教科・科目", "具体的な資質・能力"]),
      fill_in_choice.call("エ", ["教育目標", "関連", "地域や社会", "具体的な学習活動"]),
    ],
    explanation_blocks: [
      text_block.call("学校の教育目標を踏まえ，他教科等で育成する資質・能力との関連，地域や社会との関わりを重視する。内容には探究課題と，その解決を通して育成する具体的な資質・能力を示す。イは①が異なる。ウは②・③が異なり，共通性や学校内の教科との関わりに置き換えている。エは④が異なり，ここで示すのは学習活動ではなく資質・能力である。"),
    ],
    source_text: "『高等学校学習指導要領』第4章第2の3（1）〜（4）、本文475頁（PDF477頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=477",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する道徳的諸価値についての理解を基にしながら，様々な体験や思索の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，{{①}}を高め，規律ある生活をすること，{{②}}を育てること，社会連帯の自覚を高め，主体的に社会の形成に参画する意欲と態度を養うこと，義務を果たし責任を重んずる態度及び{{③}}を尊重し差別のないよりよい社会を実現しようとする態度を養うこと，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛するとともに，他国を尊重すること，{{④}}を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自主性や自発性", "生命を尊重する心", "人格", "国際社会に生きる日本人としての自覚"]),
      fill_in_choice.call("イ", ["自立心や自律性", "自然を愛護する心", "人権", "国家・社会の一員としての自覚"]),
      fill_in_choice.call("ウ", ["自立心や自律性", "生命を尊重する心", "人権", "国際社会に生きる日本人としての自覚"], true),
      fill_in_choice.call("エ", ["自主性や自発性", "自然を愛護する心", "人格", "国家・社会の一員としての自覚"]),
    ],
    explanation_blocks: [
      text_block.call("原文は，自立心や自律性，生命を尊重する心，人権，国際社会に生きる日本人としての自覚を挙げている。アは①・③が異なる。イは②・④が異なる。「国家・社会の一員としての自覚」は第1款の道徳教育の目標に登場するが，この空欄の語句ではない。エは四つとも異なる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款2全文（PDF34ページ／冊子32ページ） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』の「第2章 特別活動の目標 第1節 特別活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「自己実現」は，一般的には様々な意味で用いられるが，特別活動においては，{{①}}の中で，{{②}}の自己の生活の課題を発見し，よりよく改善しようとする視点である。自己実現のために必要な資質・能力は，自己の理解を深め，{{③}}を生かす力，{{④}}を考え設計する力など，{{①}}の中において，個々人が共通して当面する{{②}}に関わる課題を考察する中で育まれるものと考えられる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["個人", "現在及び将来", "自己のよさや可能性", "自己の生き方"]),
      fill_in_choice.call("イ", ["個人", "現在", "個人の適性や能力", "職業生活"]),
      fill_in_choice.call("ウ", ["集団", "現在及び将来", "個人の適性や能力", "職業生活"]),
      fill_in_choice.call("エ", ["集団", "現在及び将来", "自己のよさや可能性", "自己の生き方"], true),
    ],
    explanation_blocks: [
      text_block.call("特別活動における自己実現は，集団の中で現在及び将来の生活の課題を考え，自己のよさや可能性を生かし，自己の生き方を設計する視点である。アは①が異なる。イは四つとも異なる。ウは③・④が異なり，職業の適性や職業生活に限った説明へ置き換えている。"),
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 特別活動編』第2章第1節1（1）③「自己実現」、本文12〜13頁（PDF20〜21頁） | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=20",
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
        text: "学級経営・ホームルーム経営（以下「学級・ホームルーム経営」という。）の焦点は、教職員と児童生徒、児童生徒同士の選択できない出会いから始まる{{①}}を、どのようにして認め合い・励まし合い・支え合える学習集団に変えていくのかということに置かれます。失敗を恐れない、間違いやできないことを笑わない、むしろ、なぜそう思ったのか、どうすればできるようになるのかを皆で考える{{②}}な学級・ホームルームづくりが生徒指導の土台となります。そのためには、自他の個性を尊重し、相手の立場に立って考え、行動できる{{③}}で共感的な人間関係をいかに早期に創りあげるかが重要となります。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["生活集団", "協働的で自治的", "自律的"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["生活集団", "支持的で創造的", "相互扶助的"],
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["学習集団", "支持的で創造的", "自律的"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["学習集団", "協働的で自治的", "相互扶助的"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "イが原文と一致します。選択できない出会いから始まる「生活集団」を、互いに認め合い支え合える「学習集団」へ育てることが焦点です。その土台として「支持的で創造的」な学級・ホームルームづくりと、「相互扶助的」で共感的な人間関係が示されています。",
      },
      {
        type: "text",
        text: "ア：②・③が異なります。協働や自治も重要な観点ですが、この箇所は、失敗を受け止め皆で考える「支持的で創造的」な集団づくりを述べています。人間関係の性格も、自分を律する「自律的」ではなく、互いに助け合う「相互扶助的」です。",
      },
      {
        type: "text",
        text: "ウ：①・③が異なります。出発点は「生活集団」であり、育てていく集団が「学習集団」です。③は「相互扶助的」に直します。",
      },
      {
        type: "text",
        text: "エ：①・②が異なります。①は「生活集団」、②は「支持的で創造的」です。出発点と目指す集団を区別し、この段落に示される集団づくりの性格を確認します。",
      },
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.2（2）「共感的な人間関係の育成」、本文14〜15ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=17",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      {
        type: "text",
        text: "次の①～④は，学習障害（LD）のある生徒の理解及び指導に関する記述である。適切なものの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\n① 暗算や筆算の困難と，数の概念を理解する困難とを把握する。具体的な事象を基に数概念を形成したり，文章題の内容を図示して意味を捉えたりするなど，本人に適した方法を使えるように指導する。\n② 文字の形を覚えにくい場合には，目で見て字形を捉える力を把握する。腕を大きく動かして字形をなぞる活動は，文字の認識の指導ではなく，手指の細かな運動の正確さを評価するための活動として位置付ける。\n③ 書くことの困難には，文字を書く正確さや速さが関わる。文字を正確に書ける場合，伝えたい事柄を選び文章を組み立てるための支援の必要性は，書字の速度を基準として評価する。\n④ 事実から結果を予測したり，結果から原因を推測したりすることに困難がある場合には，実体験や具体的な事象を用い，位置関係や算数・数学で使う用語の理解などを図る。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "①・④",
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "①・③",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "②・③",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "②・④",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：適切です。①は数概念，計算，文章題の意味理解を区別した対応，④は予測や推測の困難に対し，具体的な事象や用語・位置関係の理解を用いる対応です。",
      },
      {
        type: "text",
        text: "イ：③が誤りです。書字の正確さ・速さと，何をどのように文章として表すかは区別して把握します。書字速度から文章構成の支援の必要性を判断することはできません。",
      },
      {
        type: "text",
        text: "ウ：②・③が誤りです。②の，腕を動かして字形をなぞる活動は，様々な感覚を使って文字を認識するための指導です。手指の細かな運動の正確さを評価するための活動とする点が誤りです。③は書字と文章構成の能力を混同しています。",
      },
      {
        type: "text",
        text: "エ：②が誤りです。視知覚だけでは文字を思い出しにくいなどの困難に対し，大きな腕の動きなど他の感覚を組み合わせ，文字の認識を支える指導として位置付けます。手指の細かな運動の評価とは目的が異なります。④は適切です。",
      },
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅸ「学習障害」1(2)②オ及び2(2)「通級による指導」・本文292・299～300ページ，分割PDF8・15～16ページ | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_13.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "エリクソンの心理社会的発達理論における青年期の同一性（アイデンティティ）に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "同一性は，それまで経験した役割を一つのまとまりとして捉えることに関わる。そのまとまりは，他者が期待する役割を自分の生き方として受け入れている程度によって判断される。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "同一性は，自分の経験を時間的につながったものとして捉えることに関わる。この感覚と，他者や社会の中で自分の存在に意味を見いだす感覚とは，別々の発達課題に位置付けられる。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "同一性は，時間が経っても自分が自分であるという感覚と，他者や社会の中で自分の存在に意味を見いだすことに関わる。過去の経験と将来の見通しを，現在の自分の生き方へ結び付けていく。",
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "同一性は，自分が担ってきた役割や価値観を整理することに関わる。このとき，自分に好ましい評価を与える自尊感情の高さが，同一性という概念の中心的な意味に当たる。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：役割をまとめて捉える点は適切ですが，他者の期待を受け入れる程度を同一性の判断基準とする部分が誤りです。自分の経験や価値観と社会的な役割を結び付け，自分なりの生き方を形成することが問題となります。",
      },
      {
        type: "text",
        text: "イ：時間的な連続性と，他者や社会の中での自己の位置付けは，別々の発達課題ではなく，同一性を捉える際の関連した側面です。",
      },
      {
        type: "text",
        text: "ウ：適切です。同一性には，自己の斉一性・連続性という時間的な側面と，他者や社会の中での自己の意味という対人的・心理社会的な側面が含まれます。",
      },
      {
        type: "text",
        text: "エ：自尊感情は自分の価値に関する評価であり，同一性と関連しても同じ概念ではありません。同一性は，自己の連続性やまとまり，社会の中での位置付けを捉える概念です。",
      },
    ],
    source_text: "人間環境大学『教育・学校心理学』・第13回 発達（3）・細目②・同一性の連続性／斉一性及び対他的・心理社会的側面 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PSC22101&jn=2022\n谷冬彦『青年期における同一性の感覚の構造』・抄録・同一性の下位概念及び自尊心との関連（概念を区別） | https://www.jstage.jst.go.jp/article/jjep1953/49/3/49_265/_article/-char/ja",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "古典的条件づけにおける諸現象に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "刺激般化は，条件刺激に似た別の刺激にも条件反応が生じる現象である。刺激弁別は，元の条件刺激と似た刺激に，それぞれ同じ無条件刺激を対提示することで形成される。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "消去は，無条件刺激を伴わずに条件刺激を繰り返し提示することで，条件反応が弱まる過程である。消去後に休止期間を置いて条件刺激を提示すると，条件反応が再び現れることがある。",
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "刺激弁別は，複数の刺激に対する反応が異なるようになる現象である。ある刺激で獲得した条件反応が，それと似た別の刺激に現れる場合も，刺激弁別に含めて捉える。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "自発的回復は，消去後に休止期間を置くと条件反応が再び現れる現象である。その成立には，休止期間の終了後に条件刺激と無条件刺激を改めて対提示することが必要となる。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：刺激般化の説明は適切です。刺激弁別では，例えば一方の刺激には無条件刺激を伴わせ，別の刺激には伴わせないなど，刺激によって異なる関係を学習させます。双方に同じ無条件刺激を対提示するという説明は，弁別訓練の説明になっていません。",
      },
      {
        type: "text",
        text: "イ：適切です。消去では条件刺激だけを提示して条件反応を弱めます。休止後に条件反応が再び現れる自発的回復は，反応が弱まったことを元の学習の消失と同一視できないことを示す現象です。",
      },
      {
        type: "text",
        text: "ウ：前半は適切です。似た別の刺激にも条件反応が生じる現象は，刺激弁別ではなく刺激般化です。弁別は刺激の違いに応じて反応が分かれることに関わります。",
      },
      {
        type: "text",
        text: "エ：前半は適切です。自発的回復は，休止後に条件刺激を提示したときに生じ得るものであり，無条件刺激との新たな対提示を必要としません。新たな対提示による反応の形成は，再条件づけと区別します。",
      },
    ],
    source_text: "人間環境大学公開シラバス『学習・言語心理学』・第3回「獲得と消去」「般化と弁別」・第3回 細目レベル②③ | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=RD405001&jn=2026\n聖徳大学公開シラバス『学習心理学』・第1課題 古典的条件づけ・第1課題3のⅤ，4のⅡ・Ⅵ | https://tk-univ-seitoku.jp/sy/2026/course/p007/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「指導の個別化」及び「学習の個性化」に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "「指導の個別化」では，興味・関心やキャリア形成の方向性に応じた探究課題に取り組む機会を提供する。「学習の個性化」では，学習進度や到達度に応じて教材や学習時間を柔軟に設定し，基礎的・基本的な知識・技能を確実に習得させる。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "「指導の個別化」では，学習進度や到達度などに応じて指導方法・教材や学習時間を柔軟に設定する。「学習の個性化」では，興味・関心やキャリア形成の方向性などに応じた課題に取り組む機会を提供し，子供自身が学習を調整する。",
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "「学習の個性化」では，学習の基盤となる資質・能力を土台とし，子供の興味・関心などに応じた学習機会を提供する。そこでいう子供自身による学習の調整とは，教師が次の課題や学習方法を決定し，子供が提示された手順を再現することを意味する。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "「指導の個別化」では，支援の必要な子供への重点的な指導などにより，知識・技能の確実な習得を図る。思考力・判断力・表現力等や，自ら学習を調整して粘り強く取り組む態度の育成は，この個別化とは区別して「学習の個性化」の目的に位置付ける。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：二つの概念の対応が逆である。学習進度・到達度等に応じた指導方法・教材・学習時間等の柔軟な提供・設定が「指導の個別化」，興味・関心やキャリア形成の方向性等に応じた学習機会を提供し，子供自身が学習を調整することが「学習の個性化」である。",
      },
      {
        type: "text",
        text: "イ：適切。答申は，指導方法・教材・学習時間等の柔軟化と，子供の興味・関心等に応じた学習活動・課題の提供を，このように整理している。教師による学習機会の提供と，子供自身による学習の調整を併せて捉える点も適切である。",
      },
      {
        type: "text",
        text: "ウ：前半は適切だが，後半が誤り。子供自身による学習の調整を，教師が決めた課題・方法の手順を再現することと同一視している。答申は，子供が自ら学習の状況を把握し，主体的に学習を調整できるよう促すことを求めている。",
      },
      {
        type: "text",
        text: "エ：知識・技能の習得だけでなく，思考力・判断力・表現力等や，自ら学習を調整しながら粘り強く取り組む態度等の育成も，「指導の個別化」が必要となる目的として挙げられている。これらを個別化から切り離して個性化の目的に振り分ける点が誤りである。",
      },
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部3(1)「子供の学び」・本文17～18ページ（PDF22～23ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=22",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..15).to_a
  raise "模擬試験16は承認済みの問1〜15を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = case number
  when 1, 2 then "education_foundations"
  when 3, 4, 5 then "education_system"
  when 6 then "curriculum_organization"
  when 7 then "special_support_education"
  when 8 then "integrated_inquiry"
  when 9 then "moral_education"
  when 10 then "special_activities"
  when 11 then "student_guidance_career"
  when 12 then "special_support_education"
  when 13, 14 then "educational_psychology"
  when 15 then "education_system"
  end
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験16 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験16 問#{number}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験16 問#{number}の出典リンク形式が不正です"
  end

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any? && number <= 10
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    expected_blank_labels = number == 6 ? %w[① ② ③] : %w[① ② ③ ④]
    unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && blank_labels == expected_blank_labels &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
      raise "模擬試験16 問#{number}の空欄と選択肢の対応が不正です"
    end
    if [4, 5].include?(number) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験16 問#{number}は抜粋枠の冒頭に条番号を表示してください"
    end
  elsif [4, 5, 6, 7, 8, 9, 10].include?(number)
    raise "模擬試験16 問#{number}は原文穴埋め問題にしてください"
  end

  if (6..10).cover?(number)
    prompt = question.fetch(:content_blocks).first.fetch(:text)
    source = question.fetch(:source_text)
    expected_sections = {
      6 => ["第1章 総則 第3款 教育課程の実施と学習評価", "第1章第3款"],
      7 => ["第1章 総則 第5款 生徒の発達の支援", "第1章第5款"],
      8 => ["第4章 総合的な探究の時間", "第4章第2"],
      9 => ["第1章 総則 第7款 道徳教育に関する配慮事項", "第1章第7款2"],
      10 => ["解説 特別活動編", "第2章第1節"],
    }
    prompt_section, source_section = expected_sections.fetch(number)
    unless prompt.start_with?("次の文章は，") && prompt.include?("からの抜粋である。") &&
        prompt.include?("空欄 {{①}} ～ {{#{blank_labels.last}}}") &&
        prompt.include?(prompt_section) && source.include?(source_section) &&
        source.match?(/https:\/\/www\.mext\.go\.jp\/content\/\S+\.pdf#page=\d+\z/) &&
        quotes.size == 1
      raise "模擬試験16 問#{number}の導入文または抜粋元が不正です"
    end
  end
end

questions.select { |question| question.fetch(:question_number) >= 11 }.each do |question|
  number = question.fetch(:question_number)
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first.fetch(:text)
  unless blocks.any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験16 問#{number}の問題文または解説が空です"
  end
  if number == 11 && !prompt.start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
    raise "模擬試験16 問11の導入文が不正です"
  end
  if number == 15 && !prompt.include?("「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）")
    raise "模擬試験16 問15の答申名が不正です"
  end
  if number == 11 || (16 == 17 && number == 15)
    blank_labels = blocks.flat_map { |block| block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten }.uniq.sort
    unless blocks.first.fetch(:type) == "fill_in_text" && blank_labels == %w[① ② ③] &&
        question.fetch(:choices).all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
      raise "模擬試験16 問#{number}の空欄と選択肢の対応が不正です"
    end
  end
end

QuestionSeedSync.import(exam_number: 16, questions: questions, publication_status: "draft")

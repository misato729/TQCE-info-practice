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

# 模擬試験12（全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の私塾とそこで行われた教育について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "伊藤仁斎が京都に開いた古義堂では，古文辞学の立場から古代中国の言語や制度を研究し，その成果を政治の改革に結び付けることが重視された。"),
      text_choice.call("イ", "緒方洪庵が大坂に開いた適塾では，年齢・学歴・身分による差を設けない三奪法と，毎月の成績を公表する月旦評を用いて，門人同士の競争を促した。"),
      text_choice.call("ウ", "廣瀬淡窓が日田に開いた咸宜園では，年齢・学歴・身分による差を設けない三奪法，学業成績を評価する月旦評及び塾生に役割を分担させる職任の制などが採られた。", true),
      text_choice.call("エ", "本居宣長が松坂に開いた鈴屋では，蘭医学と蘭学を中心に教授し，福澤諭吉や大村益次郎など，幕末から明治期に活躍する人材を輩出した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，古義堂を開いた人物を伊藤仁斎としている点は適切ですが，仁斎が唱えたのは『論語』『孟子』を重視する古義学です。古文辞学を唱えたのは荻生徂徠です。イは，適塾を開いた人物を緒方洪庵としている点は適切ですが，三奪法と月旦評は咸宜園の制度です。適塾では蘭学・医学が教授され，福澤諭吉や大村益次郎らが学びました。ウは，咸宜園の三奪法，月旦評，職任の制を正しく説明しています。エは，鈴屋を開いた人物を本居宣長としている点は適切ですが，宣長は国学者であり，『古事記伝』などを著しました。蘭学・医学及び福澤諭吉，大村益次郎との対応は適塾です。"),
    ],
    source_text: "日田市咸宜園教育研究センター『咸宜園とは』 | https://www.city.hita.oita.jp/site/kangien/1736.html
大阪大学適塾記念センター『適塾』 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku
早稲田大学リポジトリ『伊藤仁斎と荻生徂徠の学問』 | https://waseda.repo.nii.ac.jp/record/3126/files/Tsuchida2_09410009.pdf",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ルソーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育の目的を，社会において有用な紳士の形成に置き，家庭教師による個別教育の下で，健康な身体，徳，知恵及び礼儀を習慣として身に付けさせることを重視した。"),
      text_choice.call("イ", "『エミール』において，子どもを小さな大人として扱わず，その自然な発達に即して教育することを主張した。消極教育は単なる放任ではなく，事物や経験から学べるよう環境を整え，時期尚早な知識や道徳の教え込みを控えるものであった。", true),
      text_choice.call("ウ", "教育を頭・心・手の諸力を調和的に発達させる営みと捉え，家庭的な共同生活と直観教授を基礎として，貧困状態にある子どもの教育に取り組んだ。"),
      text_choice.call("エ", "教育の究極目的を道徳的品性の形成に置き，既有の観念と新しい観念との結合を統覚によって説明するとともに，教授の段階を組織的に構成した。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アはロックの教育思想です。『教育論』では，家庭教師による紳士教育と，健康，徳，知恵，礼儀及び習慣形成が論じられました。イはルソーの教育思想を正しく説明しています。ルソーは『エミール』で子どもの発達に即した教育を説きました。消極教育は放任ではなく，発達に適した環境を用意し，経験を通じて学ばせる考え方です。ウはペスタロッチの教育思想です。頭・心・手の調和，直観教授及び家庭的な共同生活が対応します。エはヘルバルトの教育思想です。道徳的品性，統覚及び段階的な教授理論が対応します。"),
    ],
    source_text: "神戸大学学術成果リポジトリ『ルソーにおける消極教育』 | https://da.lib.kobe-u.ac.jp/da/kernel/81001379/81001379.pdf
国立国会図書館サーチ『エミール』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000002320860
立教大学図書館『ルソーと「エミール」』 | https://library.rikkyo.ac.jp/digitallibrary/jeanjacquesrousseau/contents/con_05.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第2条 教育の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第2条（第1号・第2号）\n\n一　幅広い知識と教養を身に付け、{{①}}を求める態度を養い、{{②}}を培うとともに、健やかな身体を養うこと。\n\n二　個人の価値を尊重して、その能力を伸ばし、創造性を培い、{{③}}の精神を養うとともに、{{④}}との関連を重視し、勤労を重んずる態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["真理", "豊かな人間性と創造性", "自主及び自律", "職業及び社会"]),
      fill_in_choice.call("イ", ["真実", "豊かな情操と道徳心", "自立及び協同", "職業及び生活"]),
      fill_in_choice.call("ウ", ["真実", "豊かな人間性と創造性", "自立及び協同", "職業及び社会"]),
      fill_in_choice.call("エ", ["真理", "豊かな情操と道徳心", "自主及び自律", "職業及び生活"], true),
    ],
    explanation_blocks: [
      text_block.call("第1号では「真理」を求める態度と「豊かな情操と道徳心」を，第2号では「自主及び自律」の精神と「職業及び生活」との関連を挙げている。"),
      text_block.call("ア：②は「豊かな情操と道徳心」，④は「職業及び生活」が正しい。"),
      text_block.call("イ：①は「真理」，③は「自主及び自律」が正しい。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育基本法・第2条第1号、第2号 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第37条第9項\n{{①}}は、校長（副校長を置く小学校にあつては、校長及び副校長）及び教頭を助け、命を受けて{{②}}を整理し、並びに児童の教育をつかさどる。\n\n第37条第10項\n{{③}}は、児童の教育をつかさどり、並びに教諭その他の職員に対して、教育指導の改善及び充実のために必要な{{④}}を行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["主幹教諭", "校務の一部", "指導教諭", "指導及び助言"], true),
      fill_in_choice.call("イ", ["指導教諭", "校務の一部", "主幹教諭", "指導及び助言"]),
      fill_in_choice.call("ウ", ["主幹教諭", "校務", "指導教諭", "連絡及び調整"]),
      fill_in_choice.call("エ", ["指導教諭", "校務", "主幹教諭", "連絡及び調整"]),
    ],
    explanation_blocks: [
      text_block.call("主幹教諭は，校長等を助け，命を受けて「校務の一部を整理」する。指導教諭は，教育指導の改善・充実に必要な「指導及び助言」を他の教職員に行う。"),
      text_block.call("イ：①と③が逆である。"),
      text_block.call("ウ：②は「校務の一部」，④は「指導及び助言」が正しい。「校務を整理」するという職務は，第7項の教頭の規定と区別する必要がある。"),
      text_block.call("エ：①と③が逆であり，②と④も原文と異なる。"),
      text_block.call("これらの規定は，第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第37条第7項、第9項、第10項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第18条\n{{①}}の教育公務員の政治的行為の制限については、当分の間、地方公務員法第三十六条の規定にかかわらず、{{②}}の例による。\n\n2　前項の規定は、政治的行為の制限に違反した者の{{③}}につき国家公務員法（昭和二十二年法律第百二十号）第百十条第一項の例による趣旨を{{④}}。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["国立学校及び公立学校", "国家公務員", "処罰", "含むものと解してはならない"]),
      fill_in_choice.call("イ", ["公立学校", "地方公務員", "懲戒", "含むものと解しなければならない"]),
      fill_in_choice.call("ウ", ["公立学校", "国家公務員", "処罰", "含むものと解してはならない"], true),
      fill_in_choice.call("エ", ["国立学校及び公立学校", "地方公務員", "懲戒", "含むものと解しなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("公立学校の教育公務員の政治的行為の制限には，国家公務員の例を用いる。ただし，この規定によって，違反者の処罰についても国家公務員法第110条第1項の例を用いることにはならない。"),
      text_block.call("ア：①は「公立学校」が正しい。"),
      text_block.call("イ：②は「国家公務員」，③は「処罰」，④は「含むものと解してはならない」が正しい。行為の制限と処罰の取扱いを区別する必要がある。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第18条 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が生命の有限性や自然の大切さ，{{①}}や多様な他者と協働することの重要性などを実感しながら理解することができるよう，{{②}}に応じた体験活動を重視し，家庭や地域社会と{{③}}しつつ{{④}}に実施できるよう工夫すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["主体的に挑戦してみること", "生徒の興味・関心", "連携", "段階的・重点的"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["自ら問いを見いだすこと", "各教科・科目等の特質", "分担", "体系的・継続的"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["自ら問いを見いだすこと", "生徒の興味・関心", "分担", "段階的・重点的"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["主体的に挑戦してみること", "各教科・科目等の特質", "連携", "体系的・継続的"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "体験活動は，各教科・科目等の特質に応じ，家庭や地域社会と連携しながら体系的・継続的に実施します。生命や自然，主体的な挑戦，他者との協働の重要性を実感して理解するための規定です。アは②・④，イは①・③，ウは全ての空欄が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款1（5） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "障害のある生徒に対して，学校教育法施行規則第140条の規定に基づき，{{①}}を編成し，障害に応じた特別の指導（以下「{{②}}」という。）を行う場合には，学校教育法施行規則第129条の規定により定める現行の特別支援学校高等部学習指導要領第６章に示す{{③}}の内容を参考とし，具体的な目標や内容を定め，指導を行うものとする。その際，通級による指導が効果的に行われるよう，各教科・科目等と通級による指導との関連を図るなど，{{④}}に努めるものとする。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["特別の教育課程", "特別支援学級による指導", "各教科", "教師間の連携"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["個別の教育課程", "通級による指導", "自立活動", "専門家との連携"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["特別の教育課程", "通級による指導", "自立活動", "教師間の連携"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["個別の教育課程", "特別支援学級による指導", "各教科", "専門家との連携"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "通級による指導は，特別の教育課程を編成して行う指導です。自立活動の内容を参考に目標・内容を定め，各教科・科目等との関連を図るため教師間の連携に努めます。アは②・③，イは①・④，エは全ての空欄が異なります。「個別の指導計画」と「特別の教育課程」は別の用語です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款2（1）イ第1段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）の「第3章 総合的な探究の時間の目標 第2節 目標の趣旨 2 総合的な探究の時間で育成することを目指す資質・能力」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "総合的な探究の時間における探究の過程では，生徒は，教科・科目等の枠組みを超えて，長時間じっくり課題に取り組む中で，様々な事柄を知り，様々な人の考えに出会う。その中で，{{①}}だけでなく，それらが複雑に絡み合っている状況についても理解するようになる。その知識は，教科書や資料集に整然と整理されているものを取り込んで獲得するものではなく，探究の過程を通して，自分自身で{{②}}し，整理し，既にもっている知識や体験と結び付けながら，{{③}}し，身に付けていくものである。こうした過程を経ることにより，獲得された知識は，実社会や実生活における様々な課題の解決に活用可能な生きて働く知識，すなわち{{④}}が形成されるのである。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["具体的・個別的な事実", "取捨・選択", "構造化", "概念"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["具体的・個別的な事実", "取捨・選択", "一般化", "概念"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["抽象的・一般的な原理", "分類・配列", "構造化", "仮説"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["具体的・個別的な事実", "分類・配列", "一般化", "仮説"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "探究で得る知識は，生徒自身の取捨・選択と，既有の知識・体験との関連付けによって構造化されます。形成される「生きて働く知識」を，ここでは概念と説明しています。イは③，ウは①・②・④，エは②・③・④が異なります。一般化も解説の別の段落で扱われますが，この抜粋の③は構造化です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』第3章第2節2・知識及び技能の説明 | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=24",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，{{①}}，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する{{②}}についての理解を基にしながら，様々な{{③}}の機会等を通して，{{④}}についての考えを深めるよう留意すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["他者との関わり", "道徳的判断", "経験や思考", "人間としての在り方生き方"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["人との関わり", "道徳的諸価値", "体験や思索", "人間としての在り方生き方"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["人との関わり", "道徳的諸価値", "経験や思考", "社会の形成者としての役割"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["他者との関わり", "道徳的判断", "体験や思索", "社会の形成者としての役割"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "中学校までに深めた道徳的諸価値の理解を基盤とし，高等学校では体験や思索を通して，人間としての在り方生き方について考えを深めます。①も原文の価値領域の表記「人との関わり」に合わせます。アは①・②・③，ウは③・④，エは①・②・④が原文と異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第7款2第1文 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第2章 特別活動の目標 第1節 特別活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「社会参画」はよりよいホームルームや学校生活づくりなど，集団や社会に参画し様々な問題を主体的に解決しようとするという視点である。社会参画のために必要な資質・能力は，集団の中において，{{①}}を通して，{{②}}する中で育まれるものと考えられる。学校は一つの小さな社会であると同時に，様々な集団から構成される。学校内の様々な集団における活動に主体的に関わることが，地域や社会に対する参画，{{③}}となっていくことにもつながっていく。また，{{④}}の醸成にも結び付くものである。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["自主的，実践的な活動", "集団が個人へ援助", "持続可能な社会の担い手", "主権者としての自覚"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["自発的，自治的な活動", "個人が集団へ関与", "持続可能な社会の担い手", "主権者としての自覚"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["自発的，自治的な活動", "個人が集団へ関与", "地域文化の継承者", "職業人としての自覚"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["自主的，実践的な活動", "集団が個人へ援助", "地域文化の継承者", "職業人としての自覚"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "社会参画の視点では，自発的・自治的な活動を通した個人から集団への関与を重視します。学校内の活動は，持続可能な社会の担い手や主権者としての自覚にもつながります。アは①・②，ウは③・④，エは全ての空欄が異なります。②は集団が個人を援助する方向ではなく，個人が集団へ関与する方向です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 特別活動編』第2章第1節1（1）②「社会参画」 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=20",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "発達支持的生徒指導は、{{①}}、全ての児童生徒を対象に、学校の教育目標の実現に向けて、{{②}}において進められる生徒指導の基盤となるものです。発達支持的というのは、児童生徒に向き合う際の基本的な立ち位置を示しています。すなわち、あくまでも児童生徒が{{③}}に自らを発達させていくことが尊重され、その発達の過程を学校や教職員がいかに支えていくかという視点に立っています。すなわち、教職員は、児童生徒の「個性の発見とよさや可能性の伸長と社会的資質・能力の発達を支える」ように働きかけます。\n\n発達支持的生徒指導では、日々の教職員の児童生徒への挨拶、声かけ、励まし、賞賛、対話、及び、授業や行事等を通した個と集団への働きかけが大切になります。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["特定の課題の未然防止を意図して", "教育課程内外の全ての教育活動", "自発的・主体的"]),
      fill_in_choice.call("イ", ["特定の課題を意識することなく", "年間指導計画に位置付けた教育プログラム", "自発的・主体的"]),
      fill_in_choice.call("ウ", ["特定の課題を意識することなく", "教育課程内外の全ての教育活動", "意図的・計画的"]),
      fill_in_choice.call("エ", ["特定の課題を意識することなく", "教育課程内外の全ての教育活動", "自発的・主体的"], true),
    ],
    explanation_blocks: [
      text_block.call("発達支持的生徒指導は、特定の課題への対応に限らず、全ての児童生徒の発達を教育活動全体で支えるものです。児童生徒自身の自発的・主体的な発達を尊重する立場を取ります。"),
      text_block.call("ア：①が異なります。特定の課題の未然防止をねらいとする教育は、「課題予防的生徒指導：課題未然防止教育」の特徴です。"),
      text_block.call("イ：②が異なります。計画された教育プログラムに限らず、教育課程内外の全ての教育活動を範囲とします。日常の挨拶や声かけなども含まれます。"),
      text_block.call("ウ：③が異なります。ここで述べているのは教職員による教育活動の計画性ではなく、児童生徒自身が「自発的・主体的」に発達していくことです。"),
    ],
    source_text: "文部科学省『生徒指導提要』第1章1.2.2「発達支持的生徒指導」、本文20ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=23",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("自閉症スペクトラム障害（ASD）のある生徒の理解及び指導に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "語彙が豊富で文章を流暢に話せる場合は，言葉の字義を理解する力と，会話の文脈から相手の意図や感情を読み取る力が，同程度に発達していると捉える。", true),
      text_choice.call("イ", "感覚の過敏さや鈍感さがある場合には，本人の感覚の特性を把握する。苦手な音への対処では，音源から離れることや，音量を調整する器具の活用などを検討する。"),
      text_choice.call("ウ", "一斉の指示が自分に向けられたものと捉えにくい場合には，全体への説明の後に個別に確認する。指示内容や作業手順を視覚的に示すことも，理解を助ける手掛かりとなる。"),
      text_choice.call("エ", "同じ動作や行動へのこだわりには，快適な刺激を得ることや不安を和らげることが関係する場合がある。その背景を把握し，本人が納得して次の活動へ移れるように支援する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切ではありません。発語や語彙が豊富でも，言葉を字義どおりに受け取り，相手の真意や感情を文脈から理解することに困難がある場合があります。"),
      text_block.call("イ：適切です。感覚の特性を理解し，環境の調整や補助具の活用を通して，本人が対処できる方法を身に付けることが重要です。"),
      text_block.call("ウ：適切です。一斉指示の理解と，個別に示された指示の理解は同じとは限りません。具体的な説明や視覚的な手掛かりを検討します。"),
      text_block.call("エ：適切です。行動の背景を捉え，段階的に意識を切り替えられるようにする支援が示されています。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』Ⅶ「自閉症」―社会性及び集団への参加，感覚調整，他者の意図や感情の理解 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_11.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("マーシャの同一性地位の考え方に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "同一性達成は，職業や価値観について積極的に探索しているものの，自分が取り組む方向をまだ決めていない状態である。探索への積極性を，同一性が達成されたことの指標とする。"),
      text_choice.call("イ", "早期完了は，複数の生き方を比較し，迷いや葛藤を経験した上で，自分の選んだ方向に積極的に取り組む状態である。選択が早く済んだことから，この名称が用いられる。"),
      text_choice.call("ウ", "早期完了と同一性達成は，いずれも一定の方向への積極的な関与がみられる。前者は十分な探索を経ずに周囲の期待などを受け入れ，後者は探索や危機を経て自分の方向を定める。", true),
      text_choice.call("エ", "同一性拡散は，危機の経験の有無にかかわらず積極的な関与が乏しい状態である。モラトリアムは，進路や価値観を確定し，選んだ方向への取組を安定して続けている状態である。"),
    ],
    explanation_blocks: [
      text_block.call("ア：方向をまだ定めず，積極的に探索している状態はモラトリアムです。同一性達成では，探索を経て選んだ方向への関与がみられます。"),
      text_block.call("イ：説明しているのは同一性達成です。早期完了は，決定の速さを意味するものではなく，十分な探索や危機を経ずに方向を受け入れた状態を指します。"),
      text_block.call("ウ：適切です。現在の関与の強さが似ていても，探索や危機を経たかどうかによって，同一性達成と早期完了を区別します。"),
      text_block.call("エ：同一性拡散の説明は適切です。一方，モラトリアムは，自分の生き方や方向を探索している状態であり，確定した方向への安定した取組を意味しません。"),
    ],
    source_text: "三重大学教育心理学研究室掲載研究―同一性地位の分類 | https://educational-psychology.edu.mie-u.ac.jp/thesis/2006/nakahara/houhou.html\n日本薬学教育学会誌「学生のアイデンティティ発達に大学はどこまで関われるのか」 | https://www.jstage.jst.go.jp/article/jjphe/7/0/7_2023-022/_html/-char/ja",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("オーズベルの学習の分類に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "受容学習と発見学習の区別は，既有の認知構造への関連付けの仕方による。有意味学習と機械的学習の区別は，学習内容が最終的な形で提示されるかどうかによる。"),
      text_choice.call("イ", "受容学習では，学習内容が最終的な形で提示される。その内容を既有の知識に関連付けて理解する段階に進むと，学習の分類は受容学習から発見学習へ変わる。"),
      text_choice.call("ウ", "有意味学習には，学習材料の論理的な有意味性と，学習者が関連する知識をもっていることが必要である。さらに，学習者が内容を自力で発見することが成立の条件となる。"),
      text_choice.call("エ", "受容学習と発見学習は，学習内容の獲得の仕方によって区別される。有意味学習と機械的学習は，既有の認知構造への関連付けの仕方によって区別され，受容学習でも有意味学習は成立する。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：二つの分類軸が逆です。「受容―発見」は内容の獲得の仕方，「有意味―機械的」は既有の認知構造への関連付けに関わります。"),
      text_block.call("イ：既有の知識に関連付けても，最終的な形で提示された内容を学ぶ場合は受容学習です。有意味受容学習として捉えます。"),
      text_block.call("ウ：前半は適切ですが，自力での発見は有意味学習の成立条件ではありません。学習者が関連する知識をもち，関連付けようとする構えなどが必要です。"),
      text_block.call("エ：適切です。受容学習と発見学習のそれぞれに，有意味な場合と機械的な場合があります。"),
    ],
    source_text: "東京大学山内研究室「【学びの大事典！】『有意味受容学習』」―二つの分類軸と成立要件（オーズベル『教室学習の心理学』日本語訳に基づく） | https://fukutake.iii.u-tokyo.ac.jp/ylab/2009/10/post-191.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された教師のICT活用指導力の向上に関する説明である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教員養成段階で，学生が1人1台端末を持つことを前提とした教育を実現し，児童生徒の情報活用能力を育てるICT活用指導力や，学習履歴の利活用などのデータリテラシーを育成する。現職教師にも，国のコンテンツ提供や都道府県等の研修の充実を通じて指導力の向上を図る。", true),
      text_choice.call("イ", "教員養成段階では，児童生徒に情報活用能力を身に付けさせるためのICT活用指導力を育成する。学習履歴を利活用するデータリテラシーの教育は，学校現場での指導経験を基礎として現職研修の段階から開始し，教師の専門性を段階的に高める。"),
      text_choice.call("ウ", "教師は授業研究を通じて「子供はいかに学ぶか」「どう支援するか」を問い直し，資質・能力の三つの柱を一体的に育成する。その授業改善を支える教師のネットワークでは，ICT機器・サービスを提供する民間事業者が中核となり，教員養成大学等が研究成果を研修に取り入れる。"),
      text_choice.call("エ", "教職課程では，各教科の指導法におけるICTの活用を修得した後，各教科に共通して修得すべきICT活用指導力を総論的に学ぶ科目を設ける。教職実践演習では，修得した内容を学校現場で生かすため，ICTを活用した模擬授業などの演習を行う。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。情報活用能力を育てる指導力と，教師自身のデータリテラシーの向上を，教員養成段階から図ることが求められています。現職教師へのコンテンツ提供や研修の充実も示されています。"),
      text_block.call("イ：データリテラシーの教育を開始する段階が誤りです。答申は，大学の教員養成段階で，学習履歴の利活用などに関する教育を充実させることを求めています。"),
      text_block.call("ウ：ネットワークの中核となる主体が誤りです。答申が中核としての役割を求めているのは，教員養成大学・学部，教職大学院及び国立大学附属学校です。授業研究と三つの柱の一体的な育成に関する部分は適切です。"),
      text_block.call("エ：修得の順序が逆です。各教科の指導法におけるICT活用を修得する「前」に，各教科に共通するICT活用指導力を総論的に修得できる科目を設けること等を検討するとされています。教職実践演習での模擬授業等は適切です。"),
    ],
    source_text: "中央教育審議会『令和の日本型学校教育』答申・第Ⅰ部 総論5（2）「ICTの活用に向けた教師の資質・能力の向上」・本文31〜32頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=36\n中央教育審議会『令和の日本型学校教育』答申・第Ⅱ部 各論9（2）「教師のICT活用指導力の向上方策」・本文86〜87頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=91",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第2章 第10節 情報 第2款 各科目 第2 情報Ⅱ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報システムの在り方や社会生活に及ぼす影響，情報の流れや処理の仕組みに着目し，情報システムを協働して開発する活動を通して，次の事項を身に付けることができるよう指導する。\n\nア 次のような知識及び技能を身に付けること。\n\n（ｱ）情報システムにおける，情報の流れや処理の仕組み，{{①}}を確保する方法や技術について理解すること。\n\n（ｲ）情報システムの設計を表記する方法，{{②}}等のソフトウェア開発のプロセスと{{③}}について理解すること。\n\n（ｳ）情報システムを構成するプログラムを{{④}}する方法について理解し技能を身に付けること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["情報セキュリティ", "設計，実装，運用，テスト", "プロジェクト・マネジメント", "制作"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["情報セキュリティ", "設計，実装，テスト，運用", "プロジェクト・マネジメント", "制作"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["情報の信頼性", "設計，実装，テスト，運用", "サービス・マネジメント", "制作"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["情報セキュリティ", "設計，実装，テスト，運用", "プロジェクト・マネジメント", "選択"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "情報システムでは，情報セキュリティを確保する技術，ソフトウェア開発のプロセスとプロジェクト・マネジメント，プログラムを制作する技能を学ぶ。" },
      { type: "text", text: "アは，テストと運用の順を取り違えている。ウは①が「情報セキュリティ」，③が「プロジェクト・マネジメント」となる。エの④は「制作」が正しく，既存プログラムの選択を指す記述ではない。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節，第2款第2「情報Ⅱ」2（4）ア・本文194頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=196",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第3章 第7節 情報 第2款 各科目 第4 情報テクノロジー 1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報に関する科学的な見方・考え方を働かせ，実践的・体験的な学習活動を行うことなどを通して，情報社会を支える情報テクノロジーの活用に必要な資質・能力を次のとおり育成することを目指す。\n\n（1）情報テクノロジーについて体系的・系統的に理解するとともに，関連する技術を身に付けるようにする。\n\n（2）情報テクノロジーの{{①}}などに関する課題を発見し，情報産業に携わる者として合理的かつ創造的に解決する力を養う。\n\n（3）情報テクノロジーの{{②}}な利用，開発及び管理を目指して自ら学び，情報システムの{{③}}などに{{④}}に取り組む態度を養う。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["利用，開発及び管理", "安全かつ効率的", "設計，実装及びテスト", "主体的かつ協働的"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["利用，開発及び管理", "適切かつ効果的", "構築，運用及び保守", "主体的かつ協働的"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["収集，分析及び評価", "安全かつ効率的", "構築，運用及び保守", "計画的かつ組織的"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["利用，開発及び管理", "安全かつ効率的", "構築，運用及び保守", "主体的かつ協働的"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "情報テクノロジーの利用・開発・管理に関する課題の解決と，安全かつ効率的に活用し，情報システムの構築・運用・保守に主体的かつ協働的に取り組む態度を育てる。" },
      { type: "text", text: "アの③は「構築，運用及び保守」，イの②は「安全かつ効率的」が正しい。ウは①が「利用，開発及び管理」，④が「主体的かつ協働的」となる。設計・実装・テストはソフトウェア開発に関係するが，この目標の当該語句ではない。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節，第2款第4「情報テクノロジー」1・本文410頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=412",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科『情報』 第2章 専門教科情報科の各科目 第4節 情報テクノロジー」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "エ 情報システムを構成するソフトウェア\n\nここでは，これまで学んできたソフトウェアに関連した情報テクノロジーを，情報システムと結び付けて取り上げ，異なる目的で作られたソフトウェアの相互運用やデータ等の継承について，{{①}}の視点で扱う。\n\nその際，情報システムによる課題解決は技術者視点による{{②}}を導くのではなく，利用者に対して{{③}}を通して実現できる{{④}}を提供することが目的であることを理解するようにする。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["利用者側", "最適解", "製品やサービス", "最高の処理性能"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["開発者側", "標準仕様", "製品やサービス", "最適な体験"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["利用者側", "最適解", "製品やサービス", "最適な体験"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["利用者側", "最適解", "ソースコードや設計書", "最適な体験"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "ソフトウェアの相互運用やデータの継承を利用者側から捉え，製品やサービスを通して利用者に最適な体験を提供することを目指している。" },
      { type: "text", text: "アの④は「最適な体験」が正しい。イは①が「利用者側」，②が「最適解」となる。エの③は「製品やサービス」となる。技術者から見た性能や設計と，利用者が目的を達成できる体験とを区別する記述である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部，第2章第4節，第2「内容とその取扱い」2（3）エ・本文114頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=121",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "配列Dataから探索値keyを探し，見つかった要素の添字をposに格納する，次のプログラムAとBがある。見つからない場合のposは−1とする。BはDataを複製したWorkの末尾に探索値を追加し，この追加要素を番兵として用いる。Data自体は変更しない。" },
      { type: "text", text: "次の①～③の記述のうち正しいものを全て挙げた組合せを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "疑似コードはPythonを模した表記であり，配列の添字は0から始まる。インデントの深さが同じ部分を同一ブロックとする。cが数えるのは「配列の要素の値とkeyとの比較」の実行回数であり，添字とnの比較は含まない。" },
      { type: "code", code: "Data = [8, 3, 6, 1, 9, 4, 7]\nn = 要素数(Data)" },
      { type: "code_group", items: [{ title: "プログラムA", code: "i = 0\nc = 0\npos = -1\ni < n の間繰り返す:\n    c = c + 1\n    もし Data[i] == key ならば:\n        pos = i\n        繰り返しを終了する\n    i = i + 1" }, { title: "プログラムB", code: "Work = Dataの複製\nWorkの末尾にkeyを追加する\ni = 0\nc = 0\n無条件に繰り返す:\n    c = c + 1\n    もし Work[i] == key ならば:\n        繰り返しを終了する\n    i = i + 1\nもし i < n ならば:\n    pos = i\nそうでなければ:\n    pos = -1" }] },
      { type: "text", text: "①　key＝4のとき，AとBのposは共に5，cは共に6となる。" },
      { type: "text", text: "②　key＝5のとき，AとBのposは共に−1となるが，cはAで7，Bで8となる。" },
      { type: "text", text: "③　keyがDataの7要素のいずれかと等しい値になる確率がそれぞれ1/7であるとき，cの平均はAで3，Bで4となる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "text", text: "①と②" }], correct: true },
      { label: "イ", content_blocks: [{ type: "text", text: "①と③" }], correct: false },
      { label: "ウ", content_blocks: [{ type: "text", text: "②と③" }], correct: false },
      { label: "エ", content_blocks: [{ type: "text", text: "①と②と③" }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "①は正しい。4は添字5にあり，添字0～5の6要素と比較する。②も正しい。5は元の配列にはないため，Aは7要素の比較で終了する。Bは番兵Work[7]とも比較して8回となるが，i＝nなのでpos＝−1とする。" },
      { type: "table", headers: ["key", "Aのpos", "Aのc", "Bのpos", "Bのc"], rows: [["4", "5", "6", "5", "6"], ["5", "−1", "7", "−1", "8"]] },
      { type: "text", text: "③は誤り。各要素を見つけるまでの比較回数は両プログラムとも1～7回であり，平均は次のようになる。" },
      { type: "code", code: "(1+2+3+4+5+6+7)÷7＝4回" },
      { type: "text", text: "イ・ウ・エはいずれも誤った③を含む。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第3章・学習15「アルゴリズムの比較」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf\n香川大学『プログラミング』第6章「関数」・線形探索と番兵法 | https://guppy.eng.kagawa-u.ac.jp/~kagawa/2022/Programming/Reveal/Chapter6.html",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "データAの各値に10を加えて，データBを作った。平均値，分散及び標準偏差に関する記述として適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "ここでは，分散は各値と平均値との差の2乗を合計してデータの個数で割った値，標準偏差は分散の正の平方根とする。" },
      { type: "table", headers: ["データ", "値"], rows: [["A", "2，4，6"], ["B", "12，14，16"]] },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "text", text: "Bの平均値は14であり，Aより10大きい。分散も各値に加えた10の分だけ大きくなる。" }], correct: false },
      { label: "イ", content_blocks: [{ type: "text", text: "Bの平均値は14であり，Aより10大きい。平均値からの各値の差は変わらないので，分散と標準偏差はAと同じである。" }], correct: true },
      { label: "ウ", content_blocks: [{ type: "text", text: "BはAの各値を同じだけ移動させたデータなので，平均値はAと同じ4である。分散と標準偏差もAと同じである。" }], correct: false },
      { label: "エ", content_blocks: [{ type: "text", text: "Bの平均値は14であり，分散はAと同じである。標準偏差は各値に加えた10の分だけ大きくなる。" }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "イが正しい。平均値はAが（2＋4＋6）÷3＝4，Bが（12＋14＋16）÷3＝14となる。" },
      { type: "table", headers: ["データ", "平均値", "平均値からの差", "差の2乗の合計", "分散", "標準偏差"], rows: [["A", "4", "−2，0，2", "8", "8÷3", "√（8÷3）"], ["B", "14", "−2，0，2", "8", "8÷3", "√（8÷3）"]] },
      { type: "text", text: "アは分散の変化が誤り。各値と平均値がともに10大きくなるため，平均との差は変わらず，分散も変わらない。ウは平均値が誤り。各値を10増やすと平均値も10増えて14になる。エは標準偏差の変化が誤り。分散が変わらないので，その正の平方根である標準偏差も変わらない。" },
    ],
    source_text: "総務省統計局「記述統計量」・分散と標準偏差 | https://www.stat.go.jp/dstart/point/seminar/02/3-3-1.html\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第4章・学習22（1）・本文185頁 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=33",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験12は問1〜20を順番に登録してください"
end

questions.each do |question|
  expected_category = case question.fetch(:question_number)
  when 1, 2 then "education_foundations"
  when 6 then "curriculum_organization"
  when 7 then "special_support_education"
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
    raise "模擬試験12 問#{question.fetch(:question_number)}の大分類が不正です"
  end
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験12 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験12 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
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
      raise "模擬試験12 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    if (3..5).cover?(question.fetch(:question_number)) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験12 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験12 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
    raise "模擬試験12 問#{question.fetch(:question_number)}の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "模擬試験12の問16〜18は指定4範囲から異なる3範囲を資料順に並べてください"
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験12の正答位置はア〜エ各5問にしてください"
end

(6..10).each do |number|
  question = questions.fetch(number - 1)
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && prompt.fetch(:text).include?("からの抜粋である。")
    raise "模擬試験12 問#{number}は原文穴埋め問題にしてください"
  end
end
question_6 = questions.fetch(5)
unless question_6.fetch(:content_blocks).first.fetch(:text).include?("第3款 教育課程の実施と学習評価") && question_6.fetch(:source_text).include?("第1章第3款")
  raise "模擬試験12 問6の出典は第1章総則第3款にしてください"
end

QuestionSeedSync.import(exam_number: 12, questions: questions, publication_status: "published")

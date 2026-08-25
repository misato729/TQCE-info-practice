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
      text_block.call("大正期の新教育運動に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "小原國芳は、1917（大正6）年に成城小学校を新教育の実験校として創設し、児童の自発性を重視する教育を始めた。その後、1921（大正10）年の八大教育主張講演会で全人教育論を発表し、成城小学校の校長職を澤柳政太郎に引き継いだ。"),
      text_choice.call("イ", "澤柳政太郎は、1917（大正6）年に成城小学校を新教育の実験校として創設し、児童の自発性を重視する教育を展開した。同校では、個性尊重、自然と親しむ教育、心情の教育、科学的研究を基礎とする教育などが掲げられた。", true),
      text_choice.call("ウ", "木下竹次は、1919（大正8）年に千葉県師範学校附属小学校の主事となり、発動的創造的学習を実施して「奈良の学習法」の基礎を築いた。さらに、1921（大正10）年には八大教育主張講演会で自由教育論を発表した。"),
      text_choice.call("エ", "手塚岸衛は、1919（大正8）年に奈良女子高等師範学校附属小学校の主事となり、子供自身が学習目的を定める自教育を実践した。この実践は発動的創造的学習と呼ばれ、現在の「奈良の学習法」に継承された。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。澤柳政太郎は1917年に成城小学校を新教育の実験校として創設し、児童の自発性を重んじる教育を進めました。アは誤りです。小原國芳は澤柳に招かれて成城小学校の主事となり、1921年に全人教育論を発表しましたが、同校の創設者は澤柳です。また、校長職を澤柳に引き継いだという関係も逆です。ウは誤りです。木下竹次が1919年に主事となって発動的創造的学習を実施したのは奈良女子高等師範学校附属小学校であり、千葉県師範学校附属小学校ではありません。八大教育主張講演会で自由教育論を唱えたのも手塚岸衛です。エは誤りです。手塚岸衛が自由教育・自教育を展開したのは千葉県師範学校附属小学校であり、奈良女子高等師範学校附属小学校の発動的創造的学習は木下竹次に対応します。"),
    ],
    source_text: "国立国会図書館『近代日本人の肖像 澤柳政太郎』 | https://www.ndl.go.jp/portrait/datas/527\n玉川学園『澤柳政太郎』 | https://www.tamagawa.jp/introduction/history/detail_6081.html\n奈良女子大学附属小学校『学校紹介』 | https://www.nara-wu.ac.jp/fusyo/school/index.html\n千葉大学教育学部附属小学校『大正自由主義教育運動－本校の歴史』 | https://www.el.chiba-u.jp/news-detail.php?id=118",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ペスタロッチ（Pestalozzi, J. H.）の教育思想と実践に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "社会の人為的な慣習から子供を遠ざけ、発達の自然な順序に従う消極教育を唱えた。『エミール』では、青年期まで家庭教師が一人の子供を導く構想を示し、感覚、理性、道徳性の発達を年齢段階に即して論じた。"),
      text_choice.call("イ", "教育の目的を道徳的品性の形成に置き、既有の観念群が新しい観念を取り入れる統覚を重視した。教授を明瞭、連合、系統、方法の段階として捉える考え方は、後にヘルバルト派によって五段階教授法へ展開された。"),
      text_choice.call("ウ", "子供の内にある神的な本質が自己活動を通して展開すると捉え、遊びを幼児期の主要な活動に位置付けた。Kindergartenを創設し、球や立方体などからなる恩物を教育遊具として考案した。"),
      text_choice.call("エ", "教育を頭・心・手の諸力の調和的発達として捉え、具体物の直観から学ぶ方法を重視した。貧困児の教育に取り組み、イヴェルドンの学園では知的教育と道徳的・実際的教育を結び付けようとした。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。ペスタロッチは、知的・道徳的・身体的な諸力を調和的に育てる教育を構想し、具体的な事物の直観から出発する教授を重視しました。また、貧困児の教育やイヴェルドンの学園での実践で知られます。アは誤りです。消極教育と『エミール』はルソーに対応します。イは誤りです。統覚、道徳的品性、形式的教授段階はヘルバルト及びヘルバルト派に対応します。ウは誤りです。Kindergartenと恩物、遊びを中心とする幼児教育はフレーベルに対応します。"),
    ],
    source_text: "Pestalozzi International『Johann Heinrich Pestalozzi's Philosophy of Education』 | https://cms.pestalozzi.international/uploads/documents/Pestalozzi-International_Philosophy-Of-Education.pdf\nStanford Encyclopedia of Philosophy『Jean-Jacques Rousseau』5 Education | https://plato.stanford.edu/entries/rousseau/\nEncyclopaedia Britannica『Johann Friedrich Herbart』 | https://www.britannica.com/biography/Johann-Friedrich-Herbart\nFriedrich-Fröbel-Museum “Froebel’s theory of education” | https://froebel-museum.de/pages/en/friedrich-froebel/froebel92s-theory.php?lang=EN",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("『教育基本法』（平成18年法律第120号）第4条に関する記述として正しいものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "すべて国民は、ひとしく、その能力に応じた教育を受ける機会を与えられ、人種、信条、性別、社会的身分、経済的地位又は門地によって教育上差別されない。また、国及び地方公共団体は、障害のある者がその状態に応じ十分な教育を受けられるよう、教育上必要な支援を講じなければならない。", true),
      text_choice.call("イ", "教育の機会均等は能力が同程度の者を同一に扱うことを意味するため、家庭の経済的地位や門地に応じて異なる教育機会を設けても、各群の内部で平等に扱えば教育上の差別には当たらない。"),
      text_choice.call("ウ", "障害のある者への教育上必要な支援は、義務教育段階の身体障害者だけを対象とする努力義務であり、高等学校段階や知的障害、発達障害その他の障害は同項の対象に含まれない。"),
      text_choice.call("エ", "国公立学校では、幼稚園から大学までの全ての教育について授業料を徴収してはならず、私立学校でも、経済的理由で修学困難な者には一律に授業料を免除しなければならない。"),
    ],
    explanation_blocks: [
      text_block.call("アが正しい記述です。第4条第1項は能力に応じた教育を受ける機会と列挙事由による差別の禁止を、第2項は障害の状態に応じた十分な教育に必要な支援を定めています。イは経済的地位や門地による差別を容認する点、ウは支援の対象・学校段階を限定し義務を努力義務とする点が誤りです。エも誤りで、第3項が授業料を徴収しないとするのは、国又は地方公共団体が設置する学校における義務教育です。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第4条（教育の機会均等） | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第58条　高等学校には、{{①}}及び{{②}}を置くことができる。\n２ 高等学校の専攻科は、（中略）{{③}}程度において、特別の事項を教授し、その研究を指導することを目的とし、その修業年限は、一年以上とする。\n３ 高等学校の別科は、（中略）{{④}}程度において、特別の技能教育を施すことを目的とし、その修業年限は、一年以上とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["専修科", "別科", "専門的な", "基礎的な"]),
      fill_in_choice.call("イ", ["専攻科", "専修科", "高度な", "簡易な"]),
      fill_in_choice.call("ウ", ["専攻科", "別科", "精深な", "簡易な"], true),
      fill_in_choice.call("エ", ["専門科", "別科", "精深な", "実践的な"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。第58条は、高等学校に『専攻科』及び『別科』を置くことができるとし、専攻科では『精深な』程度で特別の事項を教授して研究を指導し、別科では『簡易な』程度で特別の技能教育を施すと定めています。アの『専修科・専門的な・基礎的な』、イの『専修科・高度な』、エの『専門科・実践的な』は、いずれもこの条文の語句ではありません。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第58条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第25条　公立の小学校等の教諭等の{{①}}は、児童、生徒又は幼児（以下「児童等」という。）に対する指導が{{②}}であると認定した教諭等に対して、その能力、適性等に応じて、当該指導の改善を図るために必要な事項に関する{{③}}を実施しなければならない。\n２ 指導改善研修の期間は、{{④}}を超えてはならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "不十分", "中堅教諭等資質向上研修", "二年"]),
      fill_in_choice.call("イ", ["任命権者", "不適切", "指導改善研修", "一年"], true),
      fill_in_choice.call("ウ", ["本属長", "不適当", "初任者研修", "一年"]),
      fill_in_choice.call("エ", ["教育委員会", "不十分", "職務改善研修", "二年"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。第25条は、教諭等の『任命権者』が、児童等に対する指導が『不適切』であると認定した教諭等に『指導改善研修』を実施すること、その期間は原則として『一年』を超えないことを定めています。アは主体・認定語・研修名・期間、ウは主体・認定語・研修名、エは四語全てが原文と異なります。なお、特に必要があると認めるときは、開始日から引き続き二年を超えない範囲内で延長できますが、原則期間自体が二年という意味ではありません。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第25条第1項、第2項 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "{{①}}を計画的に利用しその機能の活用を図り，生徒の{{②}}の実現に向けた授業改善に生かすとともに，生徒の{{③}}を充実すること。また，{{④}}の活用を積極的に図り，資料を活用した情報の収集や鑑賞等の学習活動を充実すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["視聴覚教室", "個別最適な学び", "個別学習や協働学習", "地域の文化施設や産業施設"]),
      fill_in_choice.call("イ", ["情報通信ネットワーク", "探究的な学び", "情報の収集や表現活動", "大学や研究機関，民間企業等の施設"]),
      fill_in_choice.call("ウ", ["図書室", "主体的・協働的な学び", "自主的な学習活動や言語活動", "地域の公民館や生涯学習施設"]),
      fill_in_choice.call("エ", ["学校図書館", "主体的・対話的で深い学び", "自主的，自発的な学習活動や読書活動", "地域の図書館や博物館，美術館，劇場，音楽堂等の施設"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。『学校図書館』の計画的な利用を『主体的・対話的で深い学び』に向けた授業改善へ生かし、『自主的，自発的な学習活動や読書活動』を充実するとともに、『地域の図書館や博物館，美術館，劇場，音楽堂等の施設』も積極的に活用します。ア、イ、ウはいずれも関連する施設や学習活動を含みますが、四つの空欄を満たす原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1(6) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "educational_counseling",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "学習や生活の基盤として，教師と生徒との{{①}}及び生徒相互のよりよい人間関係を育てるため，日頃から{{②}}の充実を図ること。また，主に{{③}}の場面で必要な指導や援助を行うガイダンスと，個々の生徒の多様な実態を踏まえ，一人一人が抱える課題に{{④}}に対応した指導を行うカウンセリングの双方により，生徒の発達を支援すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["信頼関係", "ホームルーム経営", "集団", "個別"], true),
      fill_in_choice.call("イ", ["指導関係", "学年経営", "個別", "組織的"]),
      fill_in_choice.call("ウ", ["協働関係", "教科経営", "集団", "段階的"]),
      fill_in_choice.call("エ", ["人間関係", "学校経営", "学級", "継続的"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。教師と生徒との『信頼関係』と生徒相互のよりよい人間関係を育てるため『ホームルーム経営』を充実し、主に『集団』の場面で行うガイダンスと、課題に『個別』に対応するカウンセリングの双方で発達を支援します。イの『指導関係』『学年経営』等、ウの『協働関係』『教科経営』等、エの『人間関係』『学校経営』等は、この箇所の原文とは一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款1(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）", "第4章 各学校において定める目標及び内容 第3節 各学校において定める目標及び内容の取扱い", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "総合的な探究の時間は，生徒が，{{①}}時間であり，生徒の主体的な学習態度を育成する時間である。また，{{②}}を考えながら探究できるようにすることを目指した時間である。その意味からも，総合的な探究の時間において，生徒の興味・関心に基づく探究課題を取り上げ，その解決を通して具体的な資質・能力を育成していくことは重要なことである。なお，生徒の興味・関心に基づく課題については，{{③}}として，探究の見方・考え方を働かせ，{{④}}が期待できるかどうかを，教師が十分に判断する必要がある。たとえ生徒が興味・関心を抱いた課題であっても，総合的な探究の時間の目標にふさわしくない場合や十分な学習の成果が得られない場合には，適切に指導を行うことが求められる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["自ら課題を設定し，解決する", "自己実現", "探究的な学習", "目標の達成"]),
      fill_in_choice.call("イ", ["主体的・協働的に学ぶ", "将来の進路", "教科等横断的な学習", "学習成果の定着"]),
      fill_in_choice.call("ウ", ["自ら学び，自ら考える", "自己の在り方生き方", "横断的・総合的な学習", "学習の質的高まり"], true),
      fill_in_choice.call("エ", ["自ら計画し，評価する", "社会との関わり", "総合的・統合的な学習", "探究課題の完成"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。総合的な探究の時間は、生徒が『自ら学び，自ら考える』時間であり、『自己の在り方生き方』を考えながら探究することを目指します。興味・関心に基づく課題であっても、『横断的・総合的な学習』として『学習の質的高まり』が期待できるかを教師が判断します。ア、イ、エはいずれも関連する表現を含みますが、四つの空欄を満たす連続した原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』第4章第3節(5) | https://www.mext.go.jp/component/a_menu/education/micro_detail/__icsFiles/afieldfile/2019/11/22/1407196_21_1_1_2.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 総則編」（平成30年7月文部科学省，令和6年12月一部改訂）", "第3章 教育課程の編成 第1節 高等学校教育の基本と教育課程の役割 2 生きる力を育む各学校の特色ある教育活動の展開 ② 高等学校における道徳教育", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "各教科，総合的な探究の時間及び特別活動にはそれぞれ{{①}}があり，それらを重視しつつ教育活動が行われるが，それと同時にその全てが{{②}}に規定する「人格の完成を目指し，平和で民主的な国家及び社会の形成者として必要な資質を備えた心身ともに健康な国民の育成」を目的としている。したがって，それぞれの教育活動においても，その特質を生かし，{{③}}を適切に考慮しつつ，人格形成の根幹であると同時に，{{④}}を根底で支える道徳教育の役割をも担うことになる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["共通の目標と内容", "学校教育法第51条", "生徒の学習状況や進路希望", "学校と地域社会の連携"]),
      fill_in_choice.call("イ", ["固有の目標や特質", "教育基本法第１条", "生徒の一般的な発達の段階や個々人の特性等", "民主的な国家・社会の持続的発展"], true),
      fill_in_choice.call("ウ", ["それぞれの見方・考え方", "教育基本法第２条", "学校や地域の実態及び教育課程", "持続可能な社会の形成"]),
      fill_in_choice.call("エ", ["固有の内容や方法", "学校教育法第50条", "生徒の道徳性や家庭環境", "公共の精神に基づく社会参画"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。各教科等は『固有の目標や特質』をもちつつ、全て『教育基本法第１条』の目的につながります。その特質を生かし、『生徒の一般的な発達の段階や個々人の特性等』を考慮しながら、『民主的な国家・社会の持続的発展』を支える道徳教育の役割も担います。アは各教科等を『共通の目標と内容』とし、引用法条も第51条としており誤りです。ウは第２条ではなく第１条であり、①・③・④も原文の語句と異なります。エは学校教育法第50条ではなく教育基本法第１条であり、残る三語句も原文と一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 総則編』第3章第1節2②（令和6年12月一部改訂） | https://www.mext.go.jp/content/20250213-mxt_kyoiku01-100002620_1.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）", "第3章 各活動・学校行事の目標と内容 第1節 ホームルーム活動 1 ホームルーム活動の目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "ホームルーム活動の内容「（2）日常の生活や学習への適応と自己の成長及び健康安全」，内容「（3）一人一人のキャリア形成と自己実現」においては，（2）は現在及び将来における生活上の課題，（3）は現在及び将来を見通した学習や在り方生き方に関する課題という違いがあるが，{{①}}，解決方法の話合い，{{②}}，決めたことの実践，{{③}}という基本的な学習過程は同じである。なお，ホームルーム経営や生徒の発達段階を踏まえ，教師がこれらの活動で取り上げたいことをあらかじめ{{④}}に即して設定したものを「題材」と称す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["問題の発見・確認", "解決方法の決定", "振り返り", "年間指導計画"], true),
      fill_in_choice.call("イ", ["課題の把握", "合意形成", "評価", "学校教育目標"]),
      fill_in_choice.call("ウ", ["問題の発見・確認", "解決方法の合意", "自己評価", "全体計画"]),
      fill_in_choice.call("エ", ["自己の課題設定", "解決方法の選択", "改善", "年間行事予定"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。内容（2）と（3）は、『問題の発見・確認』から話合いを経て『解決方法の決定』を行い、実践後に『振り返り』を行う基本的な学習過程を共有します。教師が『年間指導計画』に即して設定したものが題材です。イの『課題の把握』『合意形成』等、ウの『解決方法の合意』『自己評価』等、エの『自己の課題設定』『年間行事予定』等は、いずれもこの箇所の原文とは一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 特別活動編』第3章第1節1 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf",
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
        text: "児童生徒の課題への対応の時間軸に着目すると、図1の右端のように2分されます。\n\n① 常態的・先行的（プロアクティブ）生徒指導\n　日常の生徒指導を基盤とする{{①}}（→1.2.2 発達支持的生徒指導）と組織的・計画的な{{②}}（→1.2.3 課題予防的生徒指導：課題未然防止教育）は、積極的な先手型の常態的・先行的（{{③}}）生徒指導と言えます。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["課題予防的生徒指導", "課題早期発見対応", "リアクティブ"]),
      fill_in_choice.call("イ", ["発達支持的生徒指導", "困難課題対応的生徒指導", "プロアクティブ"]),
      fill_in_choice.call("ウ", ["発達支持的生徒指導", "課題未然防止教育", "リアクティブ"]),
      fill_in_choice.call("エ", ["発達支持的生徒指導", "課題未然防止教育", "プロアクティブ"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。日常の生徒指導を基盤とする『発達支持的生徒指導』と、組織的・計画的な『課題未然防止教育』は、常態的・先行的な『プロアクティブ』生徒指導です。アは発達支持的生徒指導を課題予防的生徒指導に、課題未然防止教育を課題早期発見対応に置き換えています。イは即応的・継続的な困難課題対応的生徒指導を含める点、ウは時間軸をリアクティブとする点が、それぞれ原文と異なります。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.2.1(1)「生徒指導の2軸」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("通常の学級に在籍する聴覚障害のある生徒への理解と支援に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育上の聞こえ方は純音聴力検査の聴力レベルだけで一意に決まるため、補聴器装用時の数値を確認すれば授業中の観察は不要である。数値が同じ生徒には、話者や教室の騒音にかかわらず同一の支援を行う。"),
      text_choice.call("イ", "補聴器や人工内耳を使用していれば聴覚に障害のない状態と同等に聞き取れると考え、指示は音声だけで行う。読話への依存を防ぐため教師は口元を見せず、要点の板書や字幕等の視覚情報は用いない。"),
      text_choice.call("ウ", "聴力レベルだけでなく、話者の話し方、距離、騒音等による聞こえ方の違いを把握する。座席、話者の音量、補聴援助機器、要点の文字提示等を個別に調整し、本人が必要な支援を周囲へ求める力も育てる。", true),
      text_choice.call("エ", "聴覚障害のある生徒には手話だけを用いることを原則とし、本人が主に音声言語や文字を用いている場合も方法を統一する。学級内の話合いでは、本人への確認よりも障害種別ごとの標準的な方法を優先する。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。聞こえや話の理解は聴力レベルや補聴器装用閾値だけでは決まらず、話し方、騒音、距離等にも左右されます。視覚的情報、座席、補聴援助機器等を一人一人に合わせ、本人が支援を求める力も育てます。アは誤りです。数値だけで教育的ニーズを決定せず、実際の学習場面を多面的に把握します。イは誤りです。補聴器等を使用しても聞き取りには個人差があり、音声のみの指示が難しい場合があります。エは誤りです。コミュニケーション手段は一律に定めず、本人の状態・特性・意思に応じて選びます。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅱ「聴覚障害」1(2)②、1(2)③ | https://www.mext.go.jp/kaigisiryo/content/20211215-mxt_tokubetu01-000019574-12.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エルキンド（Elkind, D.）が論じた青年期の自己中心性に照らしたとき、次の二つの生徒の認知の組合せとして最も適切なものを、下のア～エの中から一つ選んで記号で答えなさい。\n生徒A：髪型が少し崩れただけで、教室中の生徒が自分の外見を注視し、評価しているように感じる。\n生徒B：危険性を説明されても、自分だけは特別で重大な事故には遭わないと確信している。"),
    ],
    choices: [
      text_choice.call("ア", "生徒A：想像上の観衆 ／ 生徒B：個人的寓話（不死性・無敵性の感覚）", true),
      text_choice.call("イ", "生徒A：個人的寓話 ／ 生徒B：想像上の観衆"),
      text_choice.call("ウ", "生徒A：対象の永続性 ／ 生徒B：保存の概念"),
      text_choice.call("エ", "生徒A：同一性拡散 ／ 生徒B：早期完了"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。生徒Aのように、実際にはそうでなくても他者が自分の外見や行動を絶えず注視していると感じる認知は『想像上の観衆』です。生徒Bの特別性や無敵性の感覚は『個人的寓話』に対応します。イは二つの概念を逆にしています。ウの対象の永続性と保存は、ピアジェの乳児期・児童期の認知発達に関する概念で、この青年期の場面を説明しません。エの同一性拡散と早期完了はマーシャのアイデンティティ地位であり、他者からの注視感や無敵性を表す概念ではありません。"),
    ],
    source_text: "David Elkind “Egocentrism in Adolescence” Child Development 38(4) | https://doi.org/10.2307/1127100\nAPA Dictionary of Psychology “imaginary audience” | https://dictionary.apa.org/imaginary-audience",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("オーズベル（Ausubel, D. P.）の有意味受容学習及び先行オーガナイザーに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "有意味受容学習では、教師から教材が提示される受容学習は全て機械的暗記になると考える。そのため、先行オーガナイザーを示さず、学習者が具体例から概念を独力で発見することを学習成立の必要条件とする。"),
      text_choice.call("イ", "先行オーガナイザーとは、教材を最小単位へ分割し、一つの反応ごとに正誤を即時に知らせる直線型プログラムである。既有知識との意味的関係より、同じ反応を反復して強化することを目的とする。"),
      text_choice.call("ウ", "先行オーガナイザーは、新しい教材より具体的で細部の多い要約を学習後に提示するものである。新旧の知識の関連付けは学習者の混乱を招くため、既有の認知構造から切り離して記憶させる。"),
      text_choice.call("エ", "有意味受容学習では、新しい教材を学習者の既有の認知構造へ実質的に関連付けることを重視する。先行オーガナイザーは、教材に先立って、教材より包括的・抽象的な枠組みを示し、新旧の知識を結び付ける働きをする。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。オーズベルは、受容学習であっても、新しい教材が既有の認知構造と実質的に関連付けば有意味学習になり得ると考えました。先行オーガナイザーは教材より包括的・抽象的な枠組みを事前に示して、その関連付けを助けます。アは受容学習を機械的暗記と同一視し発見を必須とする点、イは先行オーガナイザーをスキナー型のプログラム学習と取り違える点、ウは具体的な学習後要約とし既有知識との切断を求める点が、それぞれ誤りです。"),
    ],
    source_text: "David P. Ausubel “The use of advance organizers in the learning and retention of meaningful verbal material” | https://doi.org/10.1037/h0046669\nDavid P. Ausubel “The facilitation of meaningful verbal learning in the classroom” | https://doi.org/10.1080/00461527709529171",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）", "第Ⅰ部 総論 3 2020年代を通じて実現すべき『令和の日本型学校教育』の姿 (2) 教職員の姿", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "教師が技術の発達や新たなニーズなど学校教育を取り巻く環境の変化を{{①}}に受け止め，教職生涯を通じて探究心を持ちつつ{{②}}に新しい知識・技能を学び続け，子供一人一人の学びを{{③}}教師としての役割を果たしている。その際，子供の主体的な学びを支援する{{④}}としての能力も備えている。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["慎重", "計画的かつ組織的", "標準化する", "管理者"]),
      fill_in_choice.call("イ", ["前向き", "自律的かつ継続的", "最大限に引き出す", "伴走者"], true),
      fill_in_choice.call("ウ", ["客観的", "段階的かつ協働的", "公平に評価する", "指導者"]),
      fill_in_choice.call("エ", ["柔軟", "主体的かつ対話的", "個別に最適化する", "助言者"]),
    ],
    explanation_blocks: [
      text_block.call("イが答申本文と一致します。教師は環境変化を『前向き』に受け止め、『自律的かつ継続的』に学び続け、子供一人一人の学びを『最大限に引き出す』とともに、主体的な学びを支援する『伴走者』としての能力を備える姿が示されています。アの『標準化』『管理者』、ウの『公平に評価』『指導者』、エの『個別に最適化』『助言者』等は、この連続した原文の語句ではありません。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部総論3(2) | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第2款 第1『情報Ⅰ』2 (3) コンピュータとプログラミング", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}を表現する手段，プログラミングによってコンピュータや{{②}}を活用する方法について理解し技能を身に付けること。社会や自然などにおける事象を{{③}}する方法，シミュレーションを通してモデルを{{④}}する方法について理解すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["データ構造", "外部装置", "抽象化", "検証し実装"]),
      fill_in_choice.call("イ", ["問題解決", "データベース", "数値化", "分析し可視化"]),
      fill_in_choice.call("ウ", ["アルゴリズム", "情報通信ネットワーク", "モデル化", "評価し改善"], true),
      fill_in_choice.call("エ", ["プログラム", "オペレーティングシステム", "構造化", "設計し開発"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。『情報Ⅰ』では、『アルゴリズム』を表現する手段と、プログラミングによりコンピュータや『情報通信ネットワーク』を活用する方法を扱います。また、事象を『モデル化』し、シミュレーションを通してモデルを『評価し改善』する方法を理解します。ア、イ、エにも情報分野で用いる語が含まれますが、この箇所の四つの語句の組合せとは一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第3章 主として専門学科において開設される各教科 第7節 情報 第7 ネットワークシステム 3 内容の取扱い", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "（1）内容を取り扱う際には，次の事項に配慮するものとする。\nア　社会で利用されている{{①}}に着目させ，ネットワークシステムの{{②}}などと関連付けて{{③}}よう留意して指導すること。\nイ　ネットワークシステムに関する{{④}}を設定し，解決する学習活動を取り入れること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["ネットワークシステム", "開発，運用及び保守", "考察する", "具体的な課題"], true),
      fill_in_choice.call("イ", ["ネットワークシステム", "設計，構築及び評価", "実習する", "具体的な課題"]),
      fill_in_choice.call("ウ", ["情報通信ネットワーク", "開発，運用及び保守", "検証する", "技術的な課題"]),
      fill_in_choice.call("エ", ["ネットワークサービス", "利用，管理及び監査", "考察する", "地域社会の課題"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。社会で実際に利用されているネットワークシステムに着目し、その開発・運用・保守と関連付けて考察するとともに、具体的な課題を解決する学習活動を取り入れることが求められています。イは①と④は一致しますが、②は『開発，運用及び保守』、③は『考察する』が正しいため誤りです。ウは②のみ一致し、着目させる対象、活動及び設定する課題が原文と異なります。エは③のみ一致し、対象をネットワークサービスに限定する点、『利用，管理及び監査』『地域社会の課題』が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第7「ネットワークシステム」3「内容の取扱い」(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）", "第1部 各学科に共通する教科「情報」 第3章 各科目にわたる指導計画の作成と内容の取扱い 2 内容の取扱いに当たっての配慮事項 (4) 情報機器の活用等に関する配慮事項", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "なお，今回の学習指導要領の改訂に当たって，従前と同様に各科目とも総授業時数に占める実習に配当する授業時数の{{①}}を明示していない。この割合については各学校の実情に応じて{{②}}に設定できるようにしたものである。しかし，ここで特に留意すべきことは，情報活用能力を確実に身に付けるためには，問題解決の過程で情報手段を活用することが不可欠であり，{{③}}は重要である。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["時間数", "一律", "講義"]),
      fill_in_choice.call("イ", ["基準", "段階的", "演習"]),
      fill_in_choice.call("ウ", ["割合", "計画的", "評価"]),
      fill_in_choice.call("エ", ["割合", "弾力的", "実習"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。解説は、実習に配当する授業時数の『割合』を明示せず、学校の実情に応じて『弾力的』に設定できるようにする一方、情報活用能力を確実に身に付ける上で『実習』が重要であると示しています。アは割合を時間数、弾力的を一律、実習を講義へ置き換えています。イの基準・段階的・演習、ウの計画的・評価も、この連続した原文の語句ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部「各学科に共通する教科『情報』」第3章2(4)「情報機器の活用等に関する配慮事項」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次の疑似コードは、隣接リストで表された有向グラフを頂点Aから幅優先探索する。各隣接リストは左から右の順に調べ、頂点はキューへ追加した時点で訪問済みにする。取り出される頂点の順序と、実行中のキューの最大要素数の組合せとして正しいものを、下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "code",
        title: "隣接リストと幅優先探索",
        code: "隣接 = {\n  A: [B, C],\n  B: [D, E],\n  C: [E, F],\n  D: [C],\n  E: [F, G],\n  F: [G],\n  G: []\n}\n\nキュー = [A]\n訪問済み = {A}\nキューが空でない間、次を繰り返す:\n  キューの先頭を取り出して v とし、v を出力する\n  隣接[v] の各頂点 w を左から順に調べる:\n    w が訪問済みでなければ:\n      w を訪問済みにし、キューの末尾へ追加する",
      },
    ],
    choices: [
      text_choice.call("ア", "順序：A → B → D → E → C → F → G ／ 最大要素数：3"),
      text_choice.call("イ", "順序：A → B → C → D → E → G → F ／ 最大要素数：3"),
      text_choice.call("ウ", "順序：A → B → C → D → E → F → G ／ 最大要素数：3", true),
      text_choice.call("エ", "順序：A → B → C → D → E → F → G ／ 最大要素数：4"),
    ],
    explanation_blocks: [
      text_block.call("ウが正しい組合せです。幅優先探索はキューを用い、始点に近い階層の頂点から調べます。AからB・C、BからD・E、CからFが追加され、既に訪問済みの頂点は再追加しません。そのため出力順はA、B、C、D、E、F、Gで、キューの最大要素数は3です。アは深さ優先探索に近い順序で誤りです。イはEからGを追加しても、先にキューへ入っているFより先には取り出されません。エは順序は正しいものの、キューが4要素になる時点はありません。"),
      {
        type: "code",
        title: "キューの状態",
        code: "初期     [A]\nAを処理  [B, C]\nBを処理  [C, D, E]  ← 最大3\nCを処理  [D, E, F]\nDを処理  [E, F]\nEを処理  [F, G]\nFを処理  [G]\nGを処理  []",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf\nNIST Dictionary of Algorithms and Data Structures “breadth-first search” | https://www.nist.gov/dads/HTML/breadthfirst.html",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("ある生徒が、受験者集団の異なるテストXとテストYを受験した。結果は次の表のとおりである。各テスト内での相対的位置を標準得点 z =（得点－平均）÷標準偏差で求め、さらに T = 50 + 10z に変換する。この生徒の結果の解釈として最も適切なものを、下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "table",
        headers: ["", "本人の得点", "受験者平均", "標準偏差"],
        rows: [
          ["テストX", "74", "62", "8"],
          ["テストY", "88", "76", "6"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "Xはz=1.5、Yはz=2.0であるが、平均との差はどちらも12点なので相対的位置は等しく、T得点はともに65である。"),
      text_choice.call("イ", "Xはz=1.5でT=65、Yはz=2.0でT=70である。したがって、平均からの標準偏差単位の距離はYの方が大きく、各集団内での相対的位置はYの方が高い。", true),
      text_choice.call("ウ", "得点の尺度が異なるテスト間では、平均と標準偏差が与えられていても相対的位置を比較できない。比較できるのは、本人の素点が高いYであるという事実だけである。"),
      text_choice.call("エ", "Xはz=8/12、Yはz=6/12であるため、T得点はXの方が高い。標準得点では、平均との差を標準偏差で割るのではなく、標準偏差を平均との差で割る。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。Xは(74−62)÷8=1.5なのでT=65、Yは(88−76)÷6=2.0なのでT=70です。Yは平均より2標準偏差上、Xは1.5標準偏差上に位置します。アは平均との差が同じでも標準偏差が異なる点を無視し、YのT得点も誤っています。ウは誤りです。標準化により異なる分布における相対的位置を比較できます。エは分子と分母を逆にしており、z得点の式を誤っています。"),
      {
        type: "code",
        title: "計算過程",
        code: "X: z = (74 - 62) / 8 = 1.5\n   T = 50 + 10 × 1.5 = 65\nY: z = (88 - 76) / 6 = 2.0\n   T = 50 + 10 × 2.0 = 70",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf\nPennsylvania State University『STAT 200』Lesson 2.2.7 “z-scores” | https://online.stat.psu.edu/stat200/Lesson02",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験4は問1から問20までの20問で構成してください"
end

correct_label_counts = questions.map do |question|
  question.fetch(:choices).find { |choice| choice.fetch(:correct) }.fetch(:label)
end.tally

unless correct_label_counts == { "ア" => 5, "イ" => 5, "ウ" => 5, "エ" => 5 }
  raise "模擬試験4の正答位置はア・イ・ウ・エを各5問にしてください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 4,
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
      raise "模擬試験4 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

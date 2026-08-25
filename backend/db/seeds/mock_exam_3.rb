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
      text_block.call("第二次世界大戦後の新しい学校制度の発足に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学校教育法の施行により、新制の小学校と中学校は1947（昭和22）年、新制高等学校は1948（昭和23）年、新制大学は原則として1949（昭和24）年に発足した。ただし、一部の私立大学は1948（昭和23）年に発足した。", true),
      text_choice.call("イ", "学校教育法は1947（昭和22）年に施行され、六・三・三・四制を一斉に完成させるため、小学校、中学校、高等学校及び大学は、いずれも同年4月に同時に発足した。"),
      text_choice.call("ウ", "教育基本法の施行により、新制の小学校と中学校は1947（昭和22）年に発足したが、高等学校と大学については、旧制学校からの移行を終えた1950（昭和25）年に同時に発足した。"),
      text_choice.call("エ", "学校教育法の施行後も、義務教育段階では国民学校と青年学校の制度が維持され、新制小学校と中学校が発足したのは、新制高等学校の発足後である1949（昭和24）年であった。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。新制小学校・中学校は1947年、高等学校は1948年、大学は原則1949年に発足し、一部の私立大学は1948年に発足しました。イは誤りです。各学校段階は同時に発足したのではありません。ウは誤りです。直接の制度的根拠を教育基本法とする点に加え、高等学校と大学の発足年も誤っています。エは誤りです。国民学校と青年学校を維持したまま新制学校の発足を遅らせたのではなく、新制小学校・中学校が最初に1947年に発足しました。"),
    ],
    source_text: "文部科学省『学制百年史』第二編第一章第一節「三 新教育制度の具現」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317739.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("フレーベル（Fröbel, F.）の教育思想と教育実践に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "世界を具体的な事物と絵によって学ばせることを重視し、絵入り教科書『世界図絵』を著すとともに、あらゆる人を対象とする体系的な学校制度を構想した。"),
      text_choice.call("イ", "表象の明瞭化と観念の結合を通して道徳的品性を形成することを教育の目的とし、明瞭・連合・系統・方法からなる教授段階を授業構成の基礎とした。"),
      text_choice.call("ウ", "子供が自ら誤りに気付けるよう工夫された感覚教具と、整えられた環境における自発的活動を重視し、教師を子供の活動を観察する援助者として位置付けた。"),
      text_choice.call("エ", "子供の内的な力が自己活動を通して発達すると捉え、遊びを幼児教育の中心に置いた。Kindergartenを創設し、子供の活動を導く教育遊具として恩物を考案した。", true),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。『世界図絵』と体系的な学校制度の構想はコメニウスに対応します。イは誤りです。道徳的品性の形成と教授段階はヘルバルト及びヘルバルト派に対応します。ウは誤りです。自己訂正的な感覚教具と整えられた環境はモンテッソーリ教育の特徴です。エが適切です。フレーベルは自己活動と遊びを重視し、Kindergartenを創設して恩物を考案しました。"),
    ],
    source_text: "Friedrich-Fröbel-Museum “Froebel’s theory of education” | https://froebel-museum.de/pages/en/friedrich-froebel/froebel92s-theory.php?lang=EN\n国立国会図書館「コメニウスと『世界図絵』」 | https://ndlsearch.ndl.go.jp/en/rnavi/children/post_237\nUniversity of Chemistry and Technology, Prague『Johan Friedrich Herbart』Formal Steps | https://e-learning.vscht.cz/mod/page/view.php?id=63074\nAssociation Montessori Internationale “Montessori Environments” | https://montessori-ami.org/about-montessori/montessori-environments",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("『教育基本法』（平成18年法律第120号）の条文として適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "家庭教育については学校が第一義的責任を有し、父母その他の保護者は、学校が定める家庭教育計画に従って、生活上必要な習慣の形成や自立心の育成に努めなければならない。", true),
      text_choice.call("イ", "国民一人一人が、自己の人格を磨き、豊かな人生を送ることができるよう、その生涯にわたって、あらゆる機会に、あらゆる場所において学習することができ、その成果を適切に生かすことのできる社会の実現が図られなければならない。"),
      text_choice.call("ウ", "父母その他の保護者は、子の教育について第一義的責任を有するものであって、生活のために必要な習慣を身に付けさせるとともに、自立心を育成し、心身の調和のとれた発達を図るよう努めるものとする。"),
      text_choice.call("エ", "国及び地方公共団体は、家庭教育の自主性を尊重しつつ、保護者に対する学習の機会及び情報の提供その他の家庭教育を支援するために必要な施策を講ずるよう努めなければならない。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切でない記述です。第10条第1項で子の教育について第一義的責任を有するのは、学校ではなく『父母その他の保護者』です。また、学校が家庭教育計画への服従を命ずる規定もありません。イは第3条の生涯学習の理念、ウは第10条第1項の保護者の責任、エは同条第2項の国及び地方公共団体による家庭教育支援を、それぞれ適切に説明しています。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第3条、第10条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第72条　特別支援学校は、視覚障害者、聴覚障害者、{{①}}、{{②}}又は病弱者（身体虚弱者を含む。以下同じ。）に対して、幼稚園、小学校、中学校又は高等学校に{{③}}を施すとともに、障害による学習上又は生活上の困難を克服し{{④}}を図るために必要な知識技能を授けることを目的とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["知的障害者", "肢体不自由者", "相当する教育", "就労"]),
      fill_in_choice.call("イ", ["発達障害者", "肢体不自由者", "準ずる教育", "進学"]),
      fill_in_choice.call("ウ", ["知的障害者", "肢体不自由者", "準ずる教育", "自立"], true),
      fill_in_choice.call("エ", ["知的障害者", "情緒障害者", "相当する教育", "共生"]),
    ],
    explanation_blocks: [
      text_block.call("第72条は、特別支援学校の目的を、各学校段階に『準ずる教育』と、障害による『学習上又は生活上の困難』を克服して『自立』を図るための知識技能の教授という二つの面から定めています。"),
    ],
    source_text: "学校教育法 第72条（特別支援学校の目的） | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条第2項　教員は、{{①}}のない限り、{{②}}の承認を受けて、{{③}}を離れて{{④}}を行うことができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["職務に支障", "校長", "勤務地", "自主研修"]),
      fill_in_choice.call("イ", ["授業に支障", "本属長", "勤務場所", "研修"], true),
      fill_in_choice.call("ウ", ["校務に支障", "任命権者", "所属校", "長期研修"]),
      fill_in_choice.call("エ", ["教育活動に支障", "教育委員会", "勤務地", "研究と修養"]),
    ],
    explanation_blocks: [
      text_block.call("第22条第2項は、教員が『授業に支障のない限り』、『本属長』の承認を受けて、『勤務場所を離れて』研修を行うことができると定めています。自主研修であっても、勤務場所を離れる場合の要件を正確に押さえる必要があります。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第22条第2項（研修の機会） | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "生徒が{{①}}，主体的に挑戦してみることや{{②}}の重要性などを実感しながら理解することができるよう，各教科・科目等の特質に応じた{{③}}を重視し，{{④}}と連携しつつ体系的・継続的に実施できるよう工夫すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["生命の有限性や自然の大切さ", "多様な他者と協働すること", "体験活動", "家庭や地域社会"], true),
      fill_in_choice.call("イ", ["生命の尊厳や環境保全の必要性", "他者と合意を形成すること", "奉仕活動", "地域の関係機関"]),
      fill_in_choice.call("ウ", ["自然環境の有限性や持続可能性", "異なる文化を理解すること", "探究活動", "保護者や地域住民"]),
      fill_in_choice.call("エ", ["生命の大切さや自然との共生", "集団の中で役割を果たすこと", "特別活動", "家庭や関係団体"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。生徒が『生命の有限性や自然の大切さ』や『多様な他者と協働すること』の重要性を実感を伴って理解できるよう、『体験活動』を重視し、『家庭や地域社会』と連携して体系的・継続的に実施します。イ、ウ、エはいずれも関連し得る表現ですが、四つの空欄を満たすこの段落の原文ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1(5) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "障害のある生徒などについては，{{①}}の助言又は援助を活用しつつ，個々の生徒の{{②}}に応じた{{③}}や{{④}}の工夫を組織的かつ計画的に行うものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育委員会", "発達の段階", "教育課程", "評価方法"]),
      fill_in_choice.call("イ", ["医療機関", "教育的ニーズ", "学習内容", "支援体制"]),
      fill_in_choice.call("ウ", ["特別支援教育コーディネーター", "心身の発達", "教材", "評価"]),
      fill_in_choice.call("エ", ["特別支援学校等", "障害の状態等", "指導内容", "指導方法"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。障害のある生徒などへの指導では、『特別支援学校等』の助言又は援助を活用し、個々の『障害の状態等』に応じて『指導内容』や『指導方法』を工夫し、組織的かつ計画的に行います。ア、イ、ウも支援に関係する語を含みますが、この連続した原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款2(1)ア | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第1 目標", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "実社会や実生活と自己との関わりから{{①}}を見いだし，自分で{{②}}を立て，情報を集め，整理・分析して，{{③}}することができるようにする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["問題", "仮説", "検証・評価"]),
      fill_in_choice.call("イ", ["問い", "課題", "まとめ・表現"], true),
      fill_in_choice.call("ウ", ["関心", "目標", "発表・討論"]),
      fill_in_choice.call("エ", ["価値", "計画", "実践・省察"]),
    ],
    explanation_blocks: [
      text_block.call("目標は、実社会や実生活と自己との関わりから『問い』を見いだし、自分で『課題』を立て、情報の収集、整理・分析を経て『まとめ・表現』する一連の探究過程を示しています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第4章第1(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第7款 道徳教育に関する配慮事項 1", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "各学校においては，（中略）{{①}}を作成し，校長の方針の下に，道徳教育の推進を主に担当する教師（「{{②}}」という。）を中心に，全教師が協力して道徳教育を展開すること。（中略）公民科の{{③}}並びに特別活動が，人間としての在り方生き方に関する中核的な指導の場面であることに配慮すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["道徳教育の全体計画", "道徳教育推進教師", "「公共」及び「倫理」"], true),
      fill_in_choice.call("イ", ["年間指導計画", "特別活動主任", "「公共」及び「政治・経済」"]),
      fill_in_choice.call("ウ", ["道徳教育の指導計画", "生徒指導主事", "「倫理」"]),
      fill_in_choice.call("エ", ["教育課程の全体計画", "教務主任", "「公共」"]),
    ],
    explanation_blocks: [
      text_block.call("高等学校では、道徳教育の全体計画を作成し、道徳教育推進教師を中心に全教師で進めます。また、公民科の『公共』と『倫理』、および特別活動が、人間としての在り方生き方を扱う中核的な指導場面です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款1 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第5章 特別活動 第2 各活動・学校行事の目標及び内容 〔学校行事〕1 目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}で協力し，{{②}}を築くための体験的な活動を通して，{{③}}を深め，{{④}}を養いながら，第１の目標に掲げる資質・能力を育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["全校の生徒", "特色ある学校文化", "集団への帰属意識", "社会性や協調性"]),
      fill_in_choice.call("イ", ["学年又はホームルームの集団", "充実した学校生活", "相互の信頼感や一体感", "自治の精神"]),
      fill_in_choice.call("ウ", ["全校若しくは学年又はそれらに準ずる集団", "よりよい学校生活", "集団への所属感や連帯感", "公共の精神"], true),
      fill_in_choice.call("エ", ["学校の全生徒又は地域の人々", "豊かな社会生活", "他者との協働性や責任感", "奉仕の精神"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。学校行事は、『全校若しくは学年又はそれらに準ずる集団』で協力し、『よりよい学校生活』を築く体験的活動を通して、『集団への所属感や連帯感』を深め、『公共の精神』を養うことを目標とします。ア、イ、エはいずれも学校行事に関係し得る表現を含みますが、この目標の四つの空欄を満たす原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第2〔学校行事〕1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      text_block.call("次の文章及び表は，『生徒指導提要』 （令和4年12月文部科学省）に示された生徒指導の2軸3類4層構造からの抜粋である。表中の空欄 ①・② に当てはまる語句の組合せとして正しいものを、下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "fill_in_quote",
        text: "図2は、図1の2軸3類に加えて、生徒指導の対象となる児童生徒の範囲から、全ての児童生徒を対象とした第1層「発達支持的生徒指導」と第2層「課題予防的生徒指導：課題未然防止教育」、一部の児童生徒を対象とした第3層「課題予防的生徒指導：課題早期発見対応」、そして、特定の生徒を対象とした第4層「困難課題対応的生徒指導」の4層から成る生徒指導の重層的支援構造を示したものです。以下で、具体的に各層について説明します。",
      },
      {
        type: "table",
        headers: ["生徒指導の層", "主な対象", "時間軸"],
        rows: [
          ["発達支持的生徒指導", "全ての児童生徒", "常態的・先行的（プロアクティブ）"],
          ["課題予防的生徒指導：課題未然防止教育", "①", "常態的・先行的（プロアクティブ）"],
          ["課題予防的生徒指導：課題早期発見対応", "課題の前兆行動が見られる一部の児童生徒", "②"],
          ["困難課題対応的生徒指導", "深刻な課題を抱えている特定の児童生徒", "即応的・継続的（リアクティブ）"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "①：課題の前兆行動が見られる一部の児童生徒 ／ ②：常態的・先行的（プロアクティブ）"),
      text_choice.call("イ", "①：深刻な課題を抱えている特定の児童生徒 ／ ②：即応的・継続的（リアクティブ）"),
      text_choice.call("ウ", "①：全ての児童生徒 ／ ②：常態的・先行的（プロアクティブ）"),
      text_choice.call("エ", "①：全ての児童生徒 ／ ②：即応的・継続的（リアクティブ）", true),
    ],
    explanation_blocks: [
      text_block.call("エが正答です。課題未然防止教育は『全ての児童生徒』を対象とする常態的・先行的（プロアクティブ）生徒指導です。課題早期発見対応は、課題の前兆行動が見られる一部の児童生徒を対象とする『即応的・継続的（リアクティブ）』生徒指導です。アは①と②をともに誤り、イは①を困難課題対応的生徒指導の対象と取り違え、ウは②をプロアクティブとする点が誤りです。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.2.1(3)「生徒指導の4層」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("次のア～エは、発達障害のある生徒に見られ得る状態像と教育的対応を組み合わせた記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "文章を正確に読めても書字だけに著しい困難がある場合、LDの可能性は除外される。書く量を一律に増やすことで改善を図り、口頭回答やICTによる入力は評価条件を変えるため認めない。"),
      text_choice.call("イ", "文字の読み書きに著しい困難がある一方で口頭説明の理解が良好な生徒には、困難の現れ方を把握した上で、読み上げ、分かち書き、文字入力、口頭回答等を選択できるようにする。予定変更や比喩的表現の理解にも困難が見られる場合は、ASD等の特徴が重なる可能性も含めて多面的に把握する。", true),
      text_choice.call("ウ", "提出物の紛失と発言への割込みが続けば、担任がADHDと確定できる。本人には診断名を前提とした着席訓練だけを行い、課題の細分化、手順の視覚化、刺激の調整は甘やかしになるため避ける。"),
      text_choice.call("エ", "会話が流暢な生徒にはASDに伴う社会的相互作用や想像力の困難は生じない。暗黙の規則は説明せず、急な予定変更への反応も本人の性格の問題として扱い、見通しを示す支援は行わない。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。LDは読む・書く等の特定領域に異なる現れ方をし得るため、得意な情報処理を生かす提示・表出方法を検討します。また、LD、ADHD、ASDの特徴が重なって見られる場合もあるので、一つの診断名だけで説明せず多面的に把握します。アは書字だけの著しい困難をLDから除外し代替手段を否定する点、ウは担任が行動だけで診断を確定し環境調整を否定する点、エは会話の流暢さだけでASDの特徴を否定し見通しの支援を行わない点が、それぞれ誤りです。"),
    ],
    source_text: "文部科学省『学習障害（LD）、注意欠陥／多動性障害（ADHD）及び高機能自閉症について』 | https://www.mext.go.jp/b_menu/shingi/chukyo/chukyo0/toushin/attach/1396626.htm",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("マーシャ（Marcia, J. E.）のアイデンティティ・ステイタス論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "進路や価値観について十分な探索を経験せず、親や周囲が示した選択に強く関与している状態は、探索もコミットメントも低いアイデンティティ拡散に分類される。"),
      text_choice.call("イ", "進路や価値観について積極的に探索し、検討の結果として自ら選んだ目標に関与している状態は、コミットメントがないモラトリアムに分類される。"),
      text_choice.call("ウ", "進路や価値観について積極的に探索しているが、まだ特定の選択へのコミットメントに至っていない状態は、モラトリアムに分類される。", true),
      text_choice.call("エ", "進路や価値観について探索することも特定の目標に関与することも避けている状態は、探索を経て目標を選択したアイデンティティ達成に分類される。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。探索を十分に経ずにコミットメントがある状態は早期完了です。イは誤りです。探索を経てコミットメントがある状態はアイデンティティ達成です。ウが適切です。探索があり、コミットメントがまだない状態がモラトリアムです。エは誤りです。探索もコミットメントも乏しい状態はアイデンティティ拡散です。"),
    ],
    source_text: "Marcia, J. E. (1966) “Development and validation of ego-identity status” | https://doi.org/10.1037/h0023281",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("バンデューラ（Bandura, A.）の観察学習における主要な過程について述べた次の記述のうち、適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "注意過程では、観察者がモデルの行動のうち何に注目するかが学習に影響し、モデルの特徴や行動の目立ちやすさ、観察者の関心などが関係する。"),
      text_choice.call("イ", "保持過程では、観察した行動を言語的又はイメージ的な表象として記憶し、モデルがいない場面でも後に取り出せるようにする。"),
      text_choice.call("ウ", "運動再生過程では、観察した行動が記憶に保持されていれば、観察者自身の身体的能力や下位技能、練習及びフィードバックの有無にかかわらず、直ちに正確な遂行が可能になる。", true),
      text_choice.call("エ", "動機付け過程では、観察によって行動を学習していても、その行動を実際に遂行するかどうかは、予期される結果や強化などの影響を受ける。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。注意過程は、モデルのどの行動を選択的に観察するかに関わります。イは適切です。保持過程では、観察内容を表象として記憶します。ウが適切でない記述です。観察内容を保持していても、正確に再生するには必要な身体的能力や下位技能があり、練習やフィードバックによる修正も関係します。エは適切です。学習された行動が実際に遂行されるかどうかには、予期される結果や強化などの動機付けが関わります。"),
    ],
    source_text: "Bandura, A.『Social Learning Theory』第2章（観察学習） | https://openlibrary.org/books/OL4899477M/Social_learning_theory",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）が、学校教育の本質的な役割として重視し、継承する必要があるとした『三つの保障』に関する記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "基礎的・基本的な知識及び技能の保障／個別最適な学びの保障／ICT環境の保障"),
      text_choice.call("イ", "教育を受ける機会の保障／職業的自立の保障／災害時の学習継続の保障"),
      text_choice.call("ウ", "確かな学力の保障／豊かな心の保障／健やかな体の保障"),
      text_choice.call("エ", "学習機会と学力の保障／社会の形成者としての全人的な発達・成長の保障／安全・安心な居場所・セーフティネットとしての身体的、精神的な健康の保障", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。答申は、①学習機会と学力の保障、②社会の形成者としての全人的な発達・成長の保障、③安全・安心な居場所・セーフティネットとしての身体的、精神的な健康の保障を重視し、継承する必要があるとしています。アはICT環境や個別最適な学びを三保障そのものと取り違え、イは職業的自立と災害時の学習継続へ置き換え、ウは学習指導要領で育む知・徳・体に関係する表現を三保障と取り違えています。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部4「構築に向けた今後の方向性」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第3款 1 (3)", "{{①}} ～ {{②}}"),
      },
      {
        type: "fill_in_quote",
        text: "各科目は，原則として{{①}}で履修させること。また，「情報Ⅱ」については，{{②}}を履修した後に履修させることを原則とすること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["複数年次", "「情報Ⅰ」"]),
      fill_in_choice.call("イ", ["同一年次", "数学科の必履修科目"]),
      fill_in_choice.call("ウ", ["同一年次", "「情報Ⅰ」"], true),
      fill_in_choice.call("エ", ["複数年次", "専門教科「情報」"]),
    ],
    explanation_blocks: [
      text_block.call("各科目は原則として同一年次で履修させます。また、『情報Ⅱ』は『情報Ⅰ』の学習を基礎として内容が構成されているため、『情報Ⅰ』の履修後に履修させることが原則です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第3款1(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第3章 主として専門学科において開設される各教科 第7節 情報 第2 課題研究 1 目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "情報に関する科学的な見方・考え方を働かせ，実践的・体験的な学習活動を行うことなどを通して，{{①}}職業人として必要な資質・能力を次のとおり育成することを目指す。\n（1）情報の各分野について体系的・系統的に理解するとともに，{{②}}技術を身に付けるようにする。\n（2）情報産業に関する課題を発見し，情報産業に携わる者として{{③}}解決する力を養う。\n（3）情報産業に関する課題を解決する力の向上を目指して自ら学び，{{④}}に主体的かつ協働的に取り組む態度を養う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["社会を支え情報産業の発展を担う", "実践的・専門的な", "合理的かつ創造的に", "情報産業の創造と発展"]),
      fill_in_choice.call("イ", ["社会を支え情報産業の発展を担う", "相互に関連付けられた", "解決策を探究し，科学的な根拠に基づいて創造的に", "情報産業の創造と発展"], true),
      fill_in_choice.call("ウ", ["情報社会の健全で持続的な発展を担う", "相互に関連付けられた", "解決策を探究し，合理的な根拠に基づいて創造的に", "情報システムの開発と運用"]),
      fill_in_choice.call("エ", ["地域社会の情報化を推進する", "個別に専門化された", "解決策を探究し，科学的な根拠に基づいて創造的に", "職業資格の取得と活用"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。『課題研究』では、情報の各分野の技術を相互に関連付け、情報産業の課題を科学的な根拠に基づいて創造的に解決する力を育成します。アは①と④は一致しますが、②は『相互に関連付けられた』、③は『解決策を探究し，科学的な根拠に基づいて創造的に』が正しいため誤りです。ウは②のみ一致し、①、③の『合理的な根拠』、④の『情報システムの開発と運用』が原文と異なります。エは③のみ一致し、①、②、④が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第2「課題研究」1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      text_block.call("『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の第1部「各学科に共通する教科『情報』」に示された「情報Ⅱ」の目標及びねらいに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "効果的なコミュニケーション、コンピュータやデータの活用について基礎的な技能を習得し、情報社会に主体的に参画することを目指すが、新たな価値の創造や情報社会の発展への寄与までは扱わない。"),
      text_choice.call("イ", "専門教科情報科の職業人育成を目的とし、情報産業の実務で使われる機器の操作技能と職業資格の取得を中心に据え、共通教科「情報Ⅰ」との内容上の関連は設けない。"),
      text_choice.call("ウ", "「情報Ⅰ」とは独立して履修することを前提とし、法規・制度や情報セキュリティは既習内容とせず、情報システムのプログラミングだけを通して創造性を育成する。"),
      text_choice.call("エ", "「情報Ⅰ」の学習を基礎に、多様なコミュニケーション、情報システム及び多様なデータの活用を深め、情報と情報技術を適切かつ効果的、創造的に活用し、新たな価値の創造と情報社会の発展への寄与を目指す。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。「情報Ⅱ」は「情報Ⅰ」を基礎として、多様なコミュニケーション、情報システム、多様なデータの活用を深め、情報と情報技術を「適切かつ効果的，創造的」に活用する力と、新たな価値を創造して情報社会の発展に寄与する態度を育成します。アは「情報Ⅰ」の目標に近く「情報Ⅱ」の創造性・発展への寄与を欠く点、イは共通教科を職業資格中心の専門教科と取り違える点、ウは「情報Ⅰ」との関連を否定し内容をプログラミングだけに限定する点が誤りです。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部第2章第2節1「情報Ⅱの目標」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次の疑似コードは挿入ソートで配列 a を昇順に整列する。a = [5, 2, 4, 1] のとき、外側の繰返しで i = 2 の処理を終えた直後の配列と、全処理終了時の count の値の組合せとして正しいものを選びなさい。count は、要素を右へ1位置移動するたびに1増える。"),
      {
        type: "code",
        title: "挿入ソート",
        code: "a = [5, 2, 4, 1]\ncount = 0\n\ni を 1 から 3 まで 1 ずつ増やしながら繰り返す:\n  x = a[i]\n  j = i - 1\n  j >= 0 かつ a[j] > x の間繰り返す:\n    a[j + 1] = a[j]\n    j = j - 1\n    count = count + 1\n  a[j + 1] = x",
      },
    ],
    choices: [
      text_choice.call("ア", "i = 2 の直後：[2, 4, 5, 1] ／ count = 5", true),
      text_choice.call("イ", "i = 2 の直後：[2, 5, 4, 1] ／ count = 4"),
      text_choice.call("ウ", "i = 2 の直後：[2, 4, 5, 1] ／ count = 4"),
      text_choice.call("エ", "i = 2 の直後：[2, 4, 5, 1] ／ count = 6"),
    ],
    explanation_blocks: [
      text_block.call("i=1では5を1回移動して[2,5,4,1]、i=2では5を1回移動して[2,4,5,1]となります。i=3では5、4、2を順に3回移動するので、移動回数は合計1+1+3=5回です。"),
      {
        type: "code",
        title: "配列と累積移動回数",
        code: "i=1: [2, 5, 4, 1]  count=1\ni=2: [2, 4, 5, 1]  count=2\ni=3: [1, 2, 4, 5]  count=5",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("教材Aと教材Bの小テスト合格率を、受講前学力が基礎層か発展層かに分けて比較したところ、次の表が得られた。このデータの解釈として最も適切なものを選びなさい。"),
      {
        type: "table",
        headers: ["層", "教材A", "教材B"],
        rows: [
          ["発展層", "18/20（90%）", "80/100（80%）"],
          ["基礎層", "30/100（30%）", "4/20（20%）"],
          ["計", "48/120（40%）", "84/120（70%）"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "全体の合格率が教材Bで高いので、どの学力層でも教材Bの方が有効である。"),
      text_choice.call("イ", "各層では教材Aの合格率が高いが、層の人数構成が教材間で異なるため全体では教材Bが高くなっており、全体の率だけで教材Bの効果が高いとは結論できない。", true),
      text_choice.call("ウ", "各層の合格率と全体の合格率が逆転することは計算上あり得ないため、表の集計には誤りがある。"),
      text_choice.call("エ", "受講者数が両教材とも120人で等しいため、学力層の人数構成を考慮する必要はない。"),
    ],
    explanation_blocks: [
      text_block.call("基礎層でも発展層でも教材Aが10ポイント高い一方、教材Bには合格しやすい発展層が多く、教材Aには基礎層が多いため、全体では順位が逆転しています。これはシンプソンのパラドックスの例で、交絡する層を考慮した比較が必要です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf\nPennsylvania State University『STAT 100』Lesson 6.2 “Simpson’s Paradox” | https://online.stat.psu.edu/stat100/Lesson06",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験3は問1から問20までの20問で構成してください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 3,
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
      raise "模擬試験3 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

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
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「教育基本法」（平成18年法律第120号）", "第10条第1項 家庭教育", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "父母その他の保護者は、子の教育について{{①}}を有するものであって、{{②}}を身に付けさせるとともに、{{③}}を育成し、{{④}}を図るよう努めるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["第一義的責任", "生活のために必要な習慣", "自立心", "心身の調和のとれた発達"], true),
      fill_in_choice.call("イ", ["最終的責任", "社会生活に必要な規律", "公共心", "知・徳・体の調和のとれた成長"]),
      fill_in_choice.call("ウ", ["第一義的責任", "基本的な生活習慣", "社会性", "人格の完成"]),
      fill_in_choice.call("エ", ["共同の責任", "生活のために必要な習慣", "自律心", "心身の健全な成長"]),
    ],
    explanation_blocks: [
      text_block.call("第10条第1項は、父母その他の保護者が子の教育について『第一義的責任』を有し、生活のために必要な習慣を身に付けさせるとともに、『自立心』を育成し、『心身の調和のとれた発達』を図るよう努めることを定めています。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第10条第1項（家庭教育） | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「学校教育法」（昭和22年法律第26号）", "第72条", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "特別支援学校は、（中略）幼稚園、小学校、中学校又は高等学校に{{①}}を施すとともに、障害による{{②}}を克服し{{③}}を図るために必要な知識技能を授けることを目的とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["相当する教育", "社会参加上の制約", "就労"]),
      fill_in_choice.call("イ", ["準ずる教育", "身体上又は精神上の障害", "進学"]),
      fill_in_choice.call("ウ", ["準ずる教育", "学習上又は生活上の困難", "自立"], true),
      fill_in_choice.call("エ", ["相当する教育", "学習上又は生活上の困難", "共生"]),
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
        text: fill_in_prompt.call("「教育公務員特例法」（昭和24年法律第1号）", "第22条第2項 研修の機会", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "教員は、{{①}}、{{②}}の承認を受けて、{{③}}研修を行うことができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["職務に支障のない範囲で", "校長", "勤務地以外で"]),
      fill_in_choice.call("イ", ["授業に支障のない限り", "本属長", "勤務場所を離れて"], true),
      fill_in_choice.call("ウ", ["授業時間外に", "任命権者", "自宅で"]),
      fill_in_choice.call("エ", ["校務運営に支障のない限り", "教育委員会", "所属校内で"]),
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
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第1款 高等学校教育の基本と教育課程の役割 3", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "その際，生徒の発達の段階や特性等を踏まえつつ，次に掲げることが{{①}}実現できるようにするものとする。\n（1）{{②}}が習得されるようにすること。\n（2）{{③}}を育成すること。\n（3）{{④}}を涵養すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["偏りなく", "知識及び技能", "思考力，判断力，表現力等", "学びに向かう力，人間性等"], true),
      fill_in_choice.call("イ", ["段階的に", "基礎的な知識", "論理的思考力", "主体性，協働性"]),
      fill_in_choice.call("ウ", ["総合的に", "知識及び技能", "問題発見・解決能力", "社会性，公共性"]),
      fill_in_choice.call("エ", ["個別に", "情報活用能力", "思考力，判断力，表現力等", "学習意欲，自己効力感"]),
    ],
    explanation_blocks: [
      text_block.call("学習指導要領は、資質・能力の三つの柱である『知識及び技能』『思考力，判断力，表現力等』『学びに向かう力，人間性等』が、偏りなく実現されるようにすることを求めています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款3 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第6款 学校運営上の留意事項 1 教育課程の改善と学校評価，教育課程外の活動との連携等 ア", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "各学校においては，{{①}}の方針の下に，{{②}}に基づき教職員が適切に役割を分担しつつ，相互に連携しながら，各学校の特色を生かした{{③}}を行うよう努めるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育委員会", "学校評価", "教育課程の編成"]),
      fill_in_choice.call("イ", ["校長", "職員会議の決定", "学校運営協議会"]),
      fill_in_choice.call("ウ", ["教育委員会", "校務分掌", "学習評価の改善"]),
      fill_in_choice.call("エ", ["校長", "校務分掌", "カリキュラム・マネジメント"], true),
    ],
    explanation_blocks: [
      text_block.call("カリキュラム・マネジメントは校長の方針の下で行われ、教職員は校務分掌に基づいて役割を分担しながら相互に連携します。教育課程を一部の担当者だけで扱わない全校的な取組が求められています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第6款1ア「教育課程の改善と学校評価、教育課程外の活動との連携等」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第1 目標 (2)", "{{①}} ～ {{③}}"),
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
      text_block.call("高等学校学習指導要領の特別活動において、学校行事として示されている五つの種類の組合せとして正しいものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "儀式的行事／学芸的行事／保健体育的行事／遠足・旅行的行事／勤労生産的行事"),
      text_choice.call("イ", "文化的行事／進路的行事／健康安全的行事／集団宿泊的行事／地域交流的行事"),
      text_choice.call("ウ", "儀式的行事／文化的行事／健康安全・体育的行事／旅行・集団宿泊的行事／勤労生産・奉仕的行事", true),
      text_choice.call("エ", "儀式的行事／文化的行事／体育的行事／修学旅行／ボランティア活動"),
    ],
    explanation_blocks: [
      text_block.call("学校行事は、儀式的行事、文化的行事、健康安全・体育的行事、旅行・集団宿泊的行事、勤労生産・奉仕的行事の五種類です。旧来の呼称に似せた選択肢や、具体的活動だけを示す選択肢に注意が必要です。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第2〔学校行事〕2 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      text_block.call("ある高等学校では、全ての生徒を対象に、年間指導計画に位置付けて『SOSの出し方教育』を実施することにした。文部科学省『生徒指導提要』の2軸3類4層構造に照らした、この取組の位置付けとして最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "発達支持的生徒指導／常態的・先行的（プロアクティブ）／第1層"),
      text_choice.call("イ", "課題予防的生徒指導：課題早期発見対応／即応的・継続的（リアクティブ）／第3層"),
      text_choice.call("ウ", "困難課題対応的生徒指導／即応的・継続的（リアクティブ）／第4層"),
      text_choice.call("エ", "課題予防的生徒指導：課題未然防止教育／常態的・先行的（プロアクティブ）／第2層", true),
    ],
    explanation_blocks: [
      text_block.call("SOSの出し方教育を含む自殺予防教育は、全ての児童生徒を対象とする『課題予防的生徒指導：課題未然防止教育』の具体例です。これは先手型の常態的・先行的（プロアクティブ）生徒指導に属し、重層的支援構造では第2層に位置付けられます。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.2.1「2軸3類4層構造」・1.2.3「課題未然防止教育」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("障害のある生徒の教育的ニーズの把握と学びの場の検討に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "医学的診断によって障害の種類が確定すれば、同じ障害名の生徒には原則として同じ学びの場と同じ指導内容を設定し、本人及び保護者の意見は判定後に確認する。"),
      text_choice.call("イ", "障害の状態だけでなく、必要な特別の指導内容、合理的配慮を含む支援の内容、本人及び保護者の意見などを総合的に把握し、関係者の共通理解の下で学びの場を検討し、就学後も必要に応じて見直す。", true),
      text_choice.call("ウ", "視覚障害のある生徒への支援は、教科書の文字を一律に拡大することで完結するため、触覚や聴覚の活用、ICT機器の利用、学習環境の調整を個別に検討する必要はない。"),
      text_choice.call("エ", "肢体不自由のある生徒については、主として手足の運動機能だけを評価すればよく、姿勢の保持、コミュニケーション、認知特性、健康状態が学習活動に与える影響は判断材料に含めない。"),
    ],
    explanation_blocks: [
      text_block.call("アは誤りです。障害名だけで学びの場や指導内容を一律に決めるのではなく、本人・保護者の意見を含めた総合的な検討が必要です。イが適切です。障害の状態、必要な指導と支援、合理的配慮、本人・保護者の意見などから教育的ニーズを整理し、就学後も継続的に見直します。ウは誤りです。視覚障害の状態は多様であり、拡大だけでなく触覚・聴覚・ICTや環境調整も個別に検討します。エは誤りです。肢体不自由についても、姿勢、コミュニケーション、認知、健康などを含む学習上・生活上の困難を総合的に把握します。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第1編「障害のある子供の教育支援の基本的な考え方」・第3編「障害の状態等に応じた教育的対応」 | https://www.mext.go.jp/a_menu/shotou/tokubetu/material/1340250_00004.htm",
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
      text_block.call("中央教育審議会答申『「令和の日本型学校教育」の構築を目指して』が、学校教育の本質的な役割として重視し、継承する必要があるとした『三つの保障』の組合せとして正しいものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "基礎的・基本的な知識及び技能の保障／個別最適な学びの保障／ICT環境の保障"),
      text_choice.call("イ", "教育を受ける機会の保障／職業的自立の保障／災害時の学習継続の保障"),
      text_choice.call("ウ", "確かな学力の保障／豊かな心の保障／健やかな体の保障"),
      text_choice.call("エ", "学習機会と学力の保障／社会の形成者としての全人的な発達・成長の保障／安全・安心な居場所・セーフティネットとしての身体的、精神的な健康の保障", true),
    ],
    explanation_blocks: [
      text_block.call("答申は、①学習機会と学力の保障、②社会の形成者としての全人的な発達・成長の保障、③安全・安心な居場所・セーフティネットとしての身体的、精神的な健康の保障を、学校教育の本質的な役割として重視し、継承する必要があるとしています。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して』（令和3年1月26日答申）第Ⅰ部4「構築に向けた今後の方向性」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
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
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第2款 第2「情報Ⅱ」2 (4)", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "情報システムの在り方や{{①}}，情報の流れや{{②}}に着目し，情報システムを{{③}}して開発する活動を通して，次の事項を身に付けることができるよう指導する。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["社会の情報化に及ぼす影響", "情報伝達の方法", "個別に"]),
      fill_in_choice.call("イ", ["社会生活に及ぼす影響", "処理の仕組み", "協働"], true),
      fill_in_choice.call("ウ", ["人間関係に及ぼす影響", "通信の仕組み", "分担"]),
      fill_in_choice.call("エ", ["経済活動に及ぼす効果", "データベースの構造", "反復"]),
    ],
    explanation_blocks: [
      text_block.call("『情報Ⅱ』の『情報システムとプログラミング』では、情報システムの在り方や『社会生活に及ぼす影響』、情報の流れや『処理の仕組み』に着目し、情報システムを『協働』して開発する活動を行います。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2(4) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第2章 各学科に共通する各教科 第10節 情報 第3款 2 (1)", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "各科目の指導においては，情報の{{①}}を見極めたり確保したりする能力の育成を図るとともに，{{②}}の保護と活用をはじめ，{{③}}の育成を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["正確性や最新性", "著作権や産業財産権", "情報活用能力"]),
      fill_in_choice.call("イ", ["完全性や可用性", "情報資産や営業秘密", "実践的な情報セキュリティ"]),
      fill_in_choice.call("ウ", ["公平性や透明性", "肖像権やプライバシー", "主体的な情報倫理"]),
      fill_in_choice.call("エ", ["信頼性や信憑性", "知的財産や個人情報", "科学的な理解に基づく情報モラル"], true),
    ],
    explanation_blocks: [
      text_block.call("情報科では、情報の信頼性・信憑性を判断し確保する力とともに、知的財産や個人情報の保護と活用を扱います。情報モラルは、単なる禁止事項ではなく科学的な理解に基づいて育成することが求められています。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第3款2(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
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

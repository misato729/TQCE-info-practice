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
      text_block.call("1872（明治5）年に公布された「学制」に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "従来の学区制と中央集権的な統制を改め、町村を小学校設置の基本単位として地域の実情に応じた学校運営を認めた。就学義務を緩和して最短16か月としたが、翌年の改正で再び就学を強化した。"),
      text_choice.call("イ", "全国を大学区・中学区・小学区に分け、全国一律の学校制度を構想した。「邑に不学の戸なく家に不学の人なからしめん」として身分や男女を問わない就学の理念を掲げた一方、学校設置と就学に伴う地域住民の負担が重く、計画どおりの実施は困難であった。", true),
      text_choice.call("ウ", "森有礼の下で、帝国大学令・師範学校令・小学校令・中学校令を一体として公布し、学校体系を段階別に整備した。小学校を尋常科と高等科に分け、尋常科の修業年限を義務教育期間とした。"),
      text_choice.call("エ", "日本国憲法と教育基本法の理念を受けて学校教育法と同時に公布され、小学校6年・中学校3年・高等学校3年・大学4年を基本とする単線型の学校体系を定め、男女共学を原則とした。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。学制は1872年に公布され、大学区・中学区・小学区からなる学区制によって全国一律の近代学校制度を構想し、身分や男女を問わない国民皆学の理念を掲げました。しかし、学校経費を地域に大きく依存したため、学校設置や就学を計画どおり進めることは困難でした。アは1879年の教育令と1880年の改正教育令の特徴を組み合わせた説明であり、学制ではありません。ウは1886年の諸学校令に対応します。エは1947年の学校教育法を中心とする戦後の新学校制度に対応します。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第一章第一節「二 学制の制定」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03459.html\n文部科学省『学制百年史』第一編第一章第二節「二 教育令・改正教育令と小学校の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317588.htm\n文部科学省『学制百年史』第一編第二章第二節「一 小学校令の制定」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317616.htm\n文部科学省『学制百年史』第二編第一章第一節「三 新教育制度の具現」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317739.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ロック（Locke, J.）の教育思想に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『エミール』において、子供を社会の人為的な悪影響から遠ざけ、発達の自然な順序に従う消極教育を構想した。青年期までは書物による知識の教授を避け、自然と事物から学ばせることを重視した。"),
      text_choice.call("イ", "教育の究極目的を道徳的品性の形成に置き、既有の観念群が新しい観念を取り入れる統覚を教授の中心概念とした。明瞭・連合・系統・方法の形式的段階は、後に五段階教授法へ展開された。"),
      text_choice.call("ウ", "子供の内にある神的な本質が自己活動によって展開すると捉え、幼児期の遊びを重視した。Kindergartenを創設し、球・立方体などからなる恩物を通して統一・多様・発展を経験させようとした。"),
      text_choice.call("エ", "『教育に関する考察』を、友人エドワード・クラークへの助言を基に著した。主にジェントリの家庭教育を念頭に、健全な身体と徳性・理性の形成を重視し、子供の個性に応じ、遊びや会話を生かして学ばせ、体罰や機械的な暗記に依存しない教育を説いた。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。ロックの『教育に関する考察』（1693年）は、友人エドワード・クラークへの教育上の助言をもとに成立し、当時のジェントリの子弟を主な対象として、健康、徳性、理性、実際的な有用性を重視しました。子供の個性を見極め、遊びや会話を生かし、過度の体罰や暗記を避ける考えも示しています。アはルソーの『エミール』と消極教育、イはヘルバルト及びヘルバルト派の統覚・形式的教授段階、ウはフレーベルの幼稚園・恩物の説明です。"),
    ],
    source_text: "Stanford Encyclopedia of Philosophy『John Locke』3 Locke's Major Works on Education | https://plato.stanford.edu/entries/locke/",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次の①～④は、『教育基本法』（平成18年法律第120号）第9条に関する記述である。正しいものはいくつあるか。下のア～エの中から一つ選んで記号で答えなさい。\n① 法律に定める学校の教員は、自己の崇高な使命を深く自覚し、絶えず研究と修養に励み、その職責の遂行に努めなければならない。\n② 教員については、その使命と職責の重要性にかんがみ、その身分は尊重され、待遇の適正が期せられなければならない。\n③ 教員については、養成と研修の充実が図られなければならない。\n④ 教員の研究と修養は任命権者が命じた勤務時間内の研修に限られ、自主的な研究と修養は同条の対象に含まれない。"),
    ],
    choices: [
      text_choice.call("ア", "三つ", true),
      text_choice.call("イ", "二つ"),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "ない"),
    ],
    explanation_blocks: [
      text_block.call("①～③が正しく、④が誤りであるため、正答はアの『三つ』です。①は第9条第1項、②と③は同条第2項の内容です。④は、『絶えず研究と修養に励み』とする規定を命令された勤務時間内研修だけに限定している点が誤りです。イ、ウ、エは正しい記述の数と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第9条（教員） | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第60条　高等学校には、校長、{{①}}、{{②}}及び{{③}}を置かなければならない。\n〔中略〕\n４ 実習助手は、実験又は実習について、{{④}}。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["副校長", "教諭", "事務職員", "独立して生徒を教授する"]),
      fill_in_choice.call("イ", ["教頭", "養護教諭", "事務職員", "教諭の職務を代行する"]),
      fill_in_choice.call("ウ", ["教頭", "教諭", "事務職員", "教諭の職務を助ける"], true),
      fill_in_choice.call("エ", ["副校長", "教諭", "技術職員", "実験又は実習を指導する"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。第60条第1項は、高等学校に校長、『教頭』『教諭』及び『事務職員』を置くことを定め、第4項は、実習助手が実験又は実習について『教諭の職務を助ける』と定めています。アは必置職を副校長とし職務を独立教授とする点、イは教諭を養護教諭へ置き換え職務を代行とする点、エは必置職を副校長・技術職員とし職務を指導とする点が、原文と異なります。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第60条（令和8年4月1日時点） | https://laws.e-gov.go.jp/law/322AC0000000026?occasion_date=20260401",
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
        text: "第24条　公立の小学校等の中堅教諭等〔中略〕の研修実施者は、当該中堅教諭等に対して、個々の{{①}}等に応じて、教育活動その他の{{②}}の円滑かつ効果的な実施において{{③}}を果たすことが期待される中堅教諭等としての職務を遂行する上で必要とされる資質の向上を図るために必要な事項に関する{{④}}を実施しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["経験、年齢", "教育課程", "指導的な役割", "初任者研修"]),
      fill_in_choice.call("イ", ["能力、適性", "学校運営", "中核的な役割", "研修"], true),
      fill_in_choice.call("ウ", ["勤務成績、意欲", "校務運営", "専門的な役割", "指導改善研修"]),
      fill_in_choice.call("エ", ["資質、経験", "教育活動", "中心的な役割", "長期研修"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。第24条第1項は、中堅教諭等の個々の『能力、適性』等に応じ、教育活動その他の『学校運営』において『中核的な役割』を果たすための資質向上に必要な『研修』を実施するよう定めています。アは経験・年齢、教育課程、指導的な役割、初任者研修、ウは勤務成績・意欲、校務運営、専門的な役割、指導改善研修、エは資質・経験、教育活動、中心的な役割、長期研修とし、いずれも原文の四語とは一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第24条第1項（中堅教諭等資質向上研修） | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第3款 教育課程の実施と学習評価 2 学習評価の充実", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "創意工夫の中で{{①}}の{{②}}が高められるよう，{{③}}な取組を推進するとともに，学年や学校段階を越えて生徒の学習の成果が{{④}}されるように工夫すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["観点別評価", "客観性や公平性", "継続的かつ体系的", "適切に共有"]),
      fill_in_choice.call("イ", ["指導と評価", "一貫性や透明性", "校内で組織的", "確実に引き継が"]),
      fill_in_choice.call("ウ", ["学習成果", "有効性や継続性", "計画的かつ段階的", "総合的に評価"]),
      fill_in_choice.call("エ", ["学習評価", "妥当性や信頼性", "組織的かつ計画的", "円滑に接続"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。学習評価については、その『妥当性や信頼性』を高めるため『組織的かつ計画的』な取組を進め、学年や学校段階を越えて学習成果が『円滑に接続』されるよう工夫します。アの『観点別評価・客観性や公平性』、イの『指導と評価・一貫性や透明性』、ウの『学習成果・有効性や継続性』はいずれも関連し得る表現ですが、この段落の原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款2(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
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
        text: "障害のある生徒などについては，{{①}}の業務を行う関係機関との連携を図り，長期的な視点で生徒への教育的支援を行うために，{{②}}を作成し活用することに努めるとともに，各教科・科目等の指導に当たって，個々の生徒の実態を的確に把握し，{{③}}を作成し活用することに努めるものとする。特に，通級による指導を受ける生徒については，個々の生徒の障害の状態等の{{④}}し，個別の教育支援計画や個別の指導計画を作成し，効果的に活用するものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["家庭，学校及び教育や医療，福祉等", "個別の指導計画", "個別の教育支援計画", "教育的ニーズを総合的に整理"]),
      fill_in_choice.call("イ", ["家庭，地域及び医療，福祉，労働等", "合理的配慮計画", "教育支援計画", "状態と特性を継続的に観察"]),
      fill_in_choice.call("ウ", ["家庭，地域及び医療や福祉，保健，労働等", "個別の教育支援計画", "個別の指導計画", "実態を的確に把握"], true),
      fill_in_choice.call("エ", ["家庭，地域及び教育や保健，福祉，雇用等", "個別の移行支援計画", "年間指導計画", "困難さと強みを多面的に把握"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。長期的な教育的支援のため、家庭・地域及び医療、福祉、保健、労働等の関係機関と連携して『個別の教育支援計画』を作成・活用し、各教科・科目等の具体的な指導では『個別の指導計画』を作成・活用します。通級による指導を受ける生徒については、障害の状態等の『実態を的確に把握』して両計画を効果的に活用します。アは二つの計画を逆にし、関係機関の列挙も原文と異なります。イの『合理的配慮計画』『教育支援計画』、エの『個別の移行支援計画』『年間指導計画』はいずれも原文の名称ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款2(1)ウ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第4章 総合的な探究の時間 第2 各学校において定める目標及び内容", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "探究課題の解決を通して育成を目指す具体的な資質・能力については，次の事項に配慮すること。\nア 知識及び技能については，他教科等及び総合的な探究の時間で習得する知識及び技能が{{①}}，{{②}}として形成されるようにすること。\nイ 思考力，判断力，表現力等については，課題の設定，情報の収集，整理・分析，まとめ・表現などの探究の過程において発揮され，{{③}}ものとして身に付けられるようにすること。\nウ 学びに向かう力，人間性等については，{{④}}の両方の視点を踏まえること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["相互に関連付けられ", "社会の中で生きて働くもの", "未知の状況において活用できる", "自分自身に関すること及び他者や社会との関わりに関すること"], true),
      fill_in_choice.call("イ", ["教科等横断的に統合され", "実社会で直ちに役立つもの", "新たな課題へ転移できる", "自己の在り方生き方及び地域や社会への参画に関すること"]),
      fill_in_choice.call("ウ", ["体系的・系統的に整理され", "将来の進路で活用できるもの", "異なる文脈で応用できる", "個人の成長及び集団の形成に関すること"]),
      fill_in_choice.call("エ", ["各教科の見方・考え方と結び付けられ", "生活の中で実践されるもの", "実社会の問題解決に活用できる", "主体性及び協働性に関すること"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。知識・技能は『相互に関連付けられ』て『社会の中で生きて働くもの』となること、思考力等は探究の過程で発揮され『未知の状況において活用できる』こと、学びに向かう力等は『自分自身』と『他者や社会との関わり』の両方の視点を踏まえることが求められます。イ、ウ、エはいずれも総合的な探究と関係する表現を含みますが、三つの資質・能力について示したこの連続箇所の原文とは一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第4章第2の3(6) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第1款 高等学校教育の基本と教育課程の役割", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "道徳教育は，{{①}}に定められた教育の根本精神に基づき，生徒が{{②}}に努め{{③}}に基づき行為しうる発達の段階にあることを考慮し，人間としての在り方生き方を考え，{{④}}の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことを目標とすること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["日本国憲法及び教育基本法", "自己理解と自己決定", "公共の精神", "合理的な判断"]),
      fill_in_choice.call("イ", ["教育基本法及び学習指導要領", "自己肯定と自己実現", "社会の形成者としての自覚", "自律的な判断"]),
      fill_in_choice.call("ウ", ["教育基本法及び学校教育法", "自己探求と人格の完成", "国家及び社会への責任", "主体的な意思決定"]),
      fill_in_choice.call("エ", ["教育基本法及び学校教育法", "自己探求と自己実現", "国家・社会の一員としての自覚", "主体的な判断"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。高等学校の道徳教育は、『教育基本法及び学校教育法』の根本精神に基づき、自己探求と自己実現に努め、国家・社会の一員としての自覚に基づき行為し得る発達段階を考慮して、『主体的な判断』の下に行動するための道徳性を養います。アは法令名と三つの語句、イは学校教育法を欠き各語句、ウは②～④が、それぞれ原文と異なります。今回は過去3年で実際に確認できる第1款2(2)第2段落から出題しており、出典範囲を広げていません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款2(2)第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第5章 特別活動 第2 各活動・学校行事の目標及び内容 〔生徒会活動〕1 目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}で協力し，{{②}}を図るための諸問題の解決に向けて，{{③}}し，協力して運営することに{{④}}に取り組むことを通して，第１の目標に掲げる資質・能力を育成することを目指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["全校の生徒", "学校文化の形成と発展", "話し合って合意形成", "主体的，協働的"]),
      fill_in_choice.call("イ", ["異年齢の生徒同士", "学校生活の充実と向上", "計画を立て役割を分担", "自主的，実践的"], true),
      fill_in_choice.call("ウ", ["多様な集団", "集団生活の改善と発展", "目標を定め仕事を分担", "自発的，自治的"]),
      fill_in_choice.call("エ", ["学校の全生徒", "地域社会への参画と貢献", "課題を見いだし計画を作成", "主体的，実践的"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。生徒会活動では、『異年齢の生徒同士』が協力し、『学校生活の充実と向上』に向けて『計画を立て役割を分担』し、『自主的，実践的』に運営へ取り組みます。アの『学校文化の形成と発展・合意形成』、ウの『集団生活の改善と発展・自治的』、エの『地域社会への参画と貢献』等は、生徒会活動に関連し得る表現ですが、この目標の原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第2〔生徒会活動〕1「目標」 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
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
        text: "生徒指導の課題性（「高い」「低い」）と課題への対応の種類から分類すると、図1のように以下の3類になります。\n\n① 発達支持的生徒指導\n　全ての児童生徒の発達を支えます。\n\n② {{①}}\n　全ての児童生徒を対象とした{{②}}と、課題の前兆行動が見られる一部の児童生徒を対象とした{{③}}を含みます。\n\n③ 困難課題対応的生徒指導\n　深刻な課題を抱えている特定の児童生徒への指導・援助を行います。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["課題予防的生徒指導", "課題の未然防止教育", "課題の早期発見と対応"], true),
      fill_in_choice.call("イ", ["発達支持的生徒指導", "課題の早期発見教育", "困難課題への継続的対応"]),
      fill_in_choice.call("ウ", ["困難課題対応的生徒指導", "課題の未然防止教育", "発達を支える指導"]),
      fill_in_choice.call("エ", ["課題予防的生徒指導", "発達支持的生徒指導", "課題の未然防止と対応"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。『課題予防的生徒指導』は、全ての児童生徒を対象とする『課題の未然防止教育』と、課題の前兆行動が見られる一部の児童生徒を対象とする『課題の早期発見と対応』を含みます。イは発達支持的生徒指導を第2類とし、未然防止教育と早期発見対応の名称も取り違えています。ウは困難課題対応的生徒指導を全員対象の未然防止とする点、エは第2類の名称以外の二つを別概念へ置き換える点が誤りです。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.2.1(2)「生徒指導の3類」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("通常の学級に在籍する視覚障害のある生徒は、小さい文字や遠方の表示が読み取りにくく、まぶしさのある教室では見え方がさらに低下する一方、拡大表示を用いると多くの文章を読むことができる。この生徒の教育的ニーズの把握と支援に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育的ニーズは遠見視力の数値だけで判断し、同じ視力値の生徒には全国共通の支援を行う。公平性を保つため、座席、照明、文字の大きさは他の生徒と同じにし、授業時間の延長や視覚補助具の使用は認めない。"),
      text_choice.call("イ", "視覚障害があることから直ちに全ての読み書きを点字へ切り替え、保有する視覚を使う教材は中止する。眼疾患の状態や本人の希望、拡大文字・弱視レンズ・ICTによる見え方を確認せず、触覚だけを主な学習手段とする。"),
      text_choice.call("ウ", "視力だけでなく視野、まぶしさ、距離、教材の大きさなど実際の見え方と本人の希望を把握する。必要に応じて座席・照明・コントラストを調整し、拡大資料、弱視レンズ、画面拡大・色調整・読み上げ等を選べるようにし、実物や模型、時間延長、援助を求める方法も含めて専門機関と連携する。", true),
      text_choice.call("エ", "見えにくさによる負担をなくすため、図表・観察・移動を伴う学習目標を個別の教育課程から削除する。教師が情報収集や課題作成を代行し、本人が補助具や支援方法を選択したり、必要な援助を依頼したりする場面は設けない。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。視覚障害の教育的ニーズは視力値だけでなく、視野、まぶしさ、距離や環境による見え方、保有する視覚の活用状況、本人の意思等を総合して把握します。拡大資料、弱視レンズ、ICTの画面拡大・色調整・読み上げ、実物・模型、時間や環境の調整を個別に組み合わせ、本人が補助具を活用し援助を求める力も育てます。アは視力値だけで一律に判断し合理的配慮を否定する点が誤りです。イは全ての視覚障害者が点字を主な手段とするわけではなく、保有視覚や本人の希望を無視しています。エは学習参加を可能にする調整ではなく、学習機会と自己選択を奪っています。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅰ「視覚障害」1「視覚障害のある子供の教育的ニーズ」 | https://www.mext.go.jp/content/20210629-mxt_tokubetu01-000016487_02.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ハヴィガースト（Havighurst, R. J.）が示した発達課題のうち、青年期に対応する課題の組合せとして最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "歩行と言語を獲得し、排泄を自分で調整し、性差を知る。身近な人や事物について単純な概念を形成し、両親やきょうだいとの情緒的な関係を学び、善悪を区別する良心の基礎を形成する。"),
      text_choice.call("イ", "遊びに必要な身体技能を身に付け、同年齢の仲間とうまく付き合い、読み・書き・計算の基礎技能を獲得する。日常生活に必要な概念、道徳性、態度を発達させ、個人として自立する力を高める。"),
      text_choice.call("ウ", "配偶者を選び、夫婦として生活することを学び、家庭を設けて子供を養育する。職業生活を開始し、市民としての責任を引き受け、自分と配偶者に合う社会集団を見いだす。"),
      text_choice.call("エ", "男女双方の同年齢者との成熟した関係を築き、自己の身体を受容して有効に用い、親や他の大人から情緒的に自立する。職業を選択・準備し、結婚と家庭生活、市民的能力、社会的に責任ある行動、行動の指針となる価値・倫理体系を準備・獲得する。", true),
    ],
    explanation_blocks: [
      text_block.call("エが青年期の発達課題に対応します。ハヴィガーストは青年期について、同年齢者との成熟した関係、身体の受容、親からの情緒的自立、経済的自立への準備、職業選択・準備、結婚・家庭生活の準備、市民的能力、社会的責任ある行動、価値・倫理体系の獲得などを挙げました。アは乳幼児期、イは児童期、ウは成人初期の発達課題に対応します。発達課題は各時期の身体的成熟、社会的期待、個人の価値・目標などから生じるものとして捉えられます。"),
    ],
    source_text: "ERIC ED315896・Hough『Vertical Articulation for the Middle Grades』Chart 1 “Developmental Tasks”（Havighurst 1972からの整理） | https://files.eric.ed.gov/fulltext/ED315896.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ブルーム（Bloom, B. S.）の完全習得学習（mastery learning）の考え方に基づく授業として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "単元の指導時間と教授方法を全員で同一に固定し、終了時の一回のテストで得点を正規分布に近づけて順位付けする。下位一定割合を不合格とし、その差を次の単元の学習能力の差として扱う。"),
      text_choice.call("イ", "明確な学習目標と到達基準を示し、学習途中の形成的評価で未習得箇所を特定する。代替的な説明や練習などの修正的支援を行って再確認し、既に習得した生徒は次の学習へ進めるなど、必要な時間や援助を調整して多くの生徒の習得を目指す。", true),
      text_choice.call("ウ", "教師が内容を小さな段階に分けて一方向に提示し、正反応には直ちに強化を与えることだけを完全習得学習の必要十分条件とする。形成的評価や誤答に応じた別の学習経路は用いない。"),
      text_choice.call("エ", "学習者が目標と教材を全て自由に選び、教師は評価基準や正誤のフィードバックを示さない。誤概念も個性的な発見として保持させ、共通の到達目標や再学習の機会を設けない。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。完全習得学習は、学習目標と習得基準を明確にし、形成的評価によって学習上の困難を早期に発見し、修正的な学習機会と再確認を用意することで、必要な時間や援助があれば多くの生徒が目標を習得できると考えます。アは時間を固定して相対評価により一定数を不合格にするため、完全習得学習と逆です。ウはプログラム学習に近い要素を一部含みますが、形成的評価と個々の誤りに応じた修正を排除しており不適切です。エは共通目標、評価、フィードバック、再学習を設けず、完全習得学習の要点を欠きます。"),
    ],
    source_text: "Bloom『Learning for Mastery. Instruction and Curriculum』（ERIC ED053419） | https://files.eric.ed.gov/fulltext/ED053419.pdf",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された『協働的な学び』に関する記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "協働的な学びでは集団として一つの意見に到達することを優先し、個々の児童生徒のよさや可能性、異なる考え方は合意形成の妨げになるため、授業では扱わない。"),
      text_choice.call("イ", "個別最適な学びを先に完成させた後でのみ協働的な学びへ移行できるため、両者を往還させたり、一体的に充実させたりする必要はない。"),
      text_choice.call("ウ", "協働的な学びでは集団の中で個が埋没しないよう、『主体的・対話的で深い学び』の実現に向けた授業改善につなげる。一人一人のよい点や可能性を生かし、異なる考え方を組み合わせて、よりよい学びを生み出すことが大切である。", true),
      text_choice.call("エ", "協働的な学びは同じ学年・学級の児童生徒同士に限定され、地域の人々や専門家、多様な他者との協働は、学校教育の公平性を損なうため含まれない。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。答申は、協働的な学びで『集団の中で個が埋没してしまう』ことを避け、『主体的・対話的で深い学び』の実現へつなげ、一人一人のよい点や可能性を生かして『異なる考え方』からよりよい学びを生み出すことを重視します。アは個のよさと異なる考えを排除し、イは個別最適な学びと協働的な学びの一体的充実を否定し、エは協働する相手を同級生だけに限定しているため、いずれも答申の趣旨と異なります。"),
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
        text: "次の文は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第1 情報Ⅰ 3 内容の取扱い」に示された内容に基づく記述である。文中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "（3）内容の「コミュニケーションと情報デザイン」の「情報デザインが人や社会に果たしている役割を理解すること」については，{{①}}を基に，{{②}}できるようにする工夫，{{③}}に関係なく{{④}}工夫などを取り上げるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["身近で具体的な情報デザインの例", "コンピュータなどを簡単に操作", "年齢や障害の有無，言語など", "全ての人にとって利用しやすくする"], true),
      fill_in_choice.call("イ", ["公共機関のウェブサイトの例", "情報機器を効率的に利用", "身体的な特性や情報活用能力", "多様な利用者が誤りなく操作できるようにする"]),
      fill_in_choice.call("ウ", ["ユニバーサルデザインの原則", "情報を直感的に理解", "年齢，性別，国籍など", "誰もが同じ方法で利用できるようにする"]),
      fill_in_choice.call("エ", ["実社会で用いられる情報システム", "コンピュータを安全に操作", "障害の状態や利用環境", "必要な情報へ公平にアクセスできるようにする"]),
    ],
    explanation_blocks: [
      text_block.call("アが原典に示された内容と一致します。身近で具体的な情報デザインを基に、コンピュータなどを簡単に操作できるようにする工夫と、年齢、障害の有無、言語などに関係なく全ての人にとって利用しやすくする工夫を扱います。イは対象を公共機関のウェブサイトに限定し、『簡単に操作』を『効率的に利用』へ置き換えています。ウのユニバーサルデザインは関連概念ですが、『誰もが同じ方法で利用できるようにする』という説明は適切ではありません。エの情報システム、安全な操作、公平なアクセスも関連する論点ですが、この規定が示す具体的な語句ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」3(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第12 情報実習 3 内容の取扱い」に示された内容に基づく記述である。文中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "生徒や地域の実態，学科の特色等に応じて，「情報システムの開発のプロセス」及び「コンテンツの制作のプロセス」から{{①}}を選択するとともに，「情報システムの開発実習」「コンテンツの制作実習」「情報システム分野とコンテンツ分野を関連させた総合的な実習」の中から{{②}}を選択し，実習を行わせること。その際，具体的な課題を設定し，開発又は制作した作品を{{③}}に確認する学習活動を取り入れること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["2項目全て", "2項目以上", "形成的・総括的"]),
      fill_in_choice.call("イ", ["1項目以上", "1項目以上", "実験的・実証的"], true),
      fill_in_choice.call("ウ", ["いずれか1項目", "全て", "継続的・組織的"]),
      fill_in_choice.call("エ", ["2項目以上", "いずれか1項目", "客観的・定量的"]),
    ],
    explanation_blocks: [
      text_block.call("イが原典に示された内容と一致します。『情報システムの開発のプロセス』及び『コンテンツの制作のプロセス』から1項目以上を選び、三つの実習からも1項目以上を選択します。さらに、開発又は制作した作品を実験的・実証的に確認する学習活動を取り入れます。アは両方のプロセスを全て選択する必要はなく、実習も2項目以上に限定されず、『形成的・総括的』も原文ではありません。ウの『いずれか1項目』は1項目だけに限定する表現であり、三つの実習全てを選ぶ必要もありません。エは選択数と確認方法がいずれも原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第12「情報実習」3(1)イ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）", "第2部 主として専門学科において開設される教科「情報」 第1章 総説 第4節 専門教科情報科の内容構成 2 分野構成", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "今回の改訂では，教科の目標に示す資質・能力を育成するために12科目を{{①}}に分類している。これを図に示すと次のとおりとなる（図1参照）。このうち，「情報産業と社会」，「情報の表現と管理」，「情報テクノロジー」，「情報セキュリティ」は，{{②}}として位置付けている。各学校においては，いずれの分野の学習を目指す生徒に対しても，共通的分野の学習が重要であることを十分考慮に入れた教育課程を編成することが望ましい。また，「情報システムのプログラミング」，「ネットワークシステム」，「データベース」，「情報デザイン」，「コンテンツの制作と発信」，「メディアとサービス」は，進路希望などに応じて選択する{{③}}である。「情報実習」は，情報システム分野とコンテンツ分野双方の専門科目で個別に学んだ知識と技術を総合的に活用することができるようにすることを狙いとしている科目であり，各分野の学習に当たっては，こうした科目のねらいを十分踏まえることが重要である。さらに，「課題研究」は，{{④}}である。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["三つの分野と総合的科目", "原則履修科目", "応用的選択科目", "各分野の専門技術を個別に深める選択科目"]),
      fill_in_choice.call("イ", ["三つの分野と選択必履修科目", "共通的分野の科目", "発展的必修科目", "専門科目の内容を相互に関連付けて実践的な内容を取り扱う総合的科目"]),
      fill_in_choice.call("ウ", ["二つの分野と総合的科目", "基礎的選択科目", "応用的選択科目", "情報システム分野とコンテンツ分野の実習を個別に行う総合的科目"]),
      fill_in_choice.call("エ", ["三つの分野と総合的科目", "共通的分野の科目", "応用的選択科目", "専門科目の内容を相互に関連付けて実践的な内容を取り扱う総合的科目"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。専門教科情報科の12科目は三つの分野と総合的科目に分類され、『情報産業と社会』『情報の表現と管理』『情報テクノロジー』『情報セキュリティ』は共通的分野の科目、六つの分野別科目は応用的選択科目とされています。また、『課題研究』は専門科目の内容を相互に関連付けて実践的な内容を取り扱う総合的科目です。アは①と③は一致しますが、②を原則履修科目、④を個別に深める選択科目としている点が誤りです。イは②と④は一致しますが、①の分類と③の位置付けが原文と異なります。ウは③のみ一致し、分野数、共通的分野の位置付け及び『課題研究』の役割が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部「主として専門学科において開設される教科『情報』」第1章第4節2「分野構成」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次の疑似コードは、配列aの末尾要素を基準値pivotとしてクイックソートの分割処理を1回行う。条件が真になるたびに実行する交換と、最後のpivotの交換をそれぞれ1回と数える。処理終了後の配列、pivotの添字i、交換回数swapsの組合せとして正しいものを、下のア～エの中から一つ選んで記号で答えなさい。添字は0から始まる。"),
      {
        type: "code",
        title: "分割処理",
        code: "a = [7, 2, 9, 4, 3, 8, 5]\npivot = a[6]\ni = 0\nswaps = 0\n\nfor j = 0 to 5:\n  if a[j] <= pivot:\n    a[i] と a[j] を交換する\n    swaps = swaps + 1\n    i = i + 1\n\na[i] と a[6] を交換する\nswaps = swaps + 1",
      },
    ],
    choices: [
      text_choice.call("ア", "配列：[2, 4, 3, 5, 7, 8, 9] ／ i：3 ／ swaps：3"),
      text_choice.call("イ", "配列：[2, 3, 4, 5, 9, 8, 7] ／ i：3 ／ swaps：4"),
      text_choice.call("ウ", "配列：[2, 4, 3, 5, 9, 8, 7] ／ i：3 ／ swaps：4", true),
      text_choice.call("エ", "配列：[2, 4, 3, 7, 9, 8, 5] ／ i：6 ／ swaps：3"),
    ],
    explanation_blocks: [
      text_block.call("ウが正しい組合せです。pivotは5です。走査中に5以下となる2、4、3を順に左側へ交換してiは3となり、最後にa[3]と末尾のpivotを交換します。よって配列は[2, 4, 3, 5, 9, 8, 7]、pivotの添字は3、交換回数は走査中3回と最後の1回を合わせて4回です。アは分割処理だけで7と9まで整列するとし、交換回数も1回少ないため誤りです。イは5以下の要素の相対順序を3、4へ変えており、この処理結果ではありません。エは最後のpivot交換を行っておらず、iも条件成立回数と一致しません。"),
      {
        type: "code",
        title: "配列の変化",
        code: "初期              [7, 2, 9, 4, 3, 8, 5]  i=0, swaps=0\nj=1（2を交換）    [2, 7, 9, 4, 3, 8, 5]  i=1, swaps=1\nj=3（4を交換）    [2, 4, 9, 7, 3, 8, 5]  i=2, swaps=2\nj=4（3を交換）    [2, 4, 3, 7, 9, 8, 5]  i=3, swaps=3\npivotを交換       [2, 4, 3, 5, 9, 8, 7]  i=3, swaps=4",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf\nNIST Dictionary of Algorithms and Data Structures “quicksort” | https://xlinux.nist.gov/dads/HTML/quicksort.html",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("1万通の電子メールのうち、実際の迷惑メールは5%である。ある判定器は、実際の迷惑メールの90%を迷惑メールと判定し、実際には通常メールであるものの10%も誤って迷惑メールと判定する。このとき、迷惑メールと判定されたメールの適合率（precision）と、実際の迷惑メールに対する再現率（recall）の組合せとして最も適切なものを、下のア～エの中から一つ選んで記号で答えなさい。百分率は小数第2位を四捨五入する。"),
    ],
    choices: [
      text_choice.call("ア", "適合率：約32.1% ／ 再現率：90.0%。通常メールの母数が大きいため、偽陽性950通が真陽性450通を上回る。", true),
      text_choice.call("イ", "適合率：90.0% ／ 再現率：約32.1%。適合率には実際の迷惑メール全体を、再現率には迷惑メールと判定された全体を分母として用いる。"),
      text_choice.call("ウ", "適合率：約47.4% ／ 再現率：90.0%。真陽性450通を偽陽性950通だけで割れば、迷惑メール判定のうち正しい割合を求められる。"),
      text_choice.call("エ", "適合率：90.0% ／ 再現率：90.0%。真陽性率と偽陽性率がいずれも母集団に対する割合として与えられているため、迷惑メールの出現率は適合率に影響しない。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。実際の迷惑メールは500通なので真陽性TPは450通、偽陰性FNは50通です。通常メールは9,500通なので偽陽性FPは950通、真陰性TNは8,550通です。適合率はTP÷(TP+FP)=450÷1,400≈32.1%、再現率はTP÷(TP+FN)=450÷500=90.0%です。イは適合率と再現率の分母を逆に説明しています。ウは450÷950を用いており、適合率の分母から真陽性を欠いています。エは真陽性率を適合率と取り違え、基礎となる迷惑メールの出現率を無視しています。"),
      {
        type: "table",
        headers: ["", "迷惑メールと判定", "通常メールと判定", "合計"],
        rows: [
          ["実際に迷惑メール", "450（TP）", "50（FN）", "500"],
          ["実際に通常メール", "950（FP）", "8,550（TN）", "9,500"],
          ["合計", "1,400", "8,600", "10,000"],
        ],
      },
      {
        type: "code",
        title: "計算式",
        code: "precision = TP / (TP + FP) = 450 / 1,400 ≈ 0.321\nrecall    = TP / (TP + FN) = 450 / 500   = 0.900",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2(3) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf\nNISTIR 7972『Performance Metrics for Evaluating Object and Human Detection and Tracking Systems』3.2.7・3.2.8 | https://nvlpubs.nist.gov/nistpubs/ir/2014/nist.ir.7972.pdf",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験5は問1から問20までの20問で構成してください"
end

unless (6..10).all? { |question_number| questions[question_number - 1][:content_blocks].any? { |block| block[:type] == "fill_in_text" } }
  raise "模擬試験5の問6から問10は全て抜粋穴埋め問題にしてください"
end

unless questions[5][:content_blocks].first.fetch(:text).include?("第3款 教育課程の実施と学習評価")
  raise "模擬試験5の問6は第1章総則第3款から出題してください"
end

correct_label_counts = questions.map do |question|
  question.fetch(:choices).find { |choice| choice.fetch(:correct) }.fetch(:label)
end.tally

unless correct_label_counts == { "ア" => 5, "イ" => 5, "ウ" => 5, "エ" => 5 }
  raise "模擬試験5の正答位置はア・イ・ウ・エを各5問にしてください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 5,
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
      raise "模擬試験5 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

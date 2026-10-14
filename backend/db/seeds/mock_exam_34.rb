text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験34（承認済みの問1・2及び問6〜10。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
# 問6〜10承認正本：document/模試31〜35_問6〜10草案_2026-10-14.md
# 文部科学省の公式原典を空欄化した独自の予想問題。原典の連続性・全肢代入は独立fixtureで検証する。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の①～④は，終戦後の教科書の取扱いや制度に関する出来事である。起こった時期が早いものから順に並べたものとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("①　小学校・中学校の六・三制が発足した年度，文部省の著作による新しい教科書が用いられた。学校教育の民主化に対応した学習内容を教材に盛り込む一方，教科書の著作主体は文部省となっていた。"),
      text_block.call("②　終戦直後，従来の教科書から戦時下の教育に関わる教材を応急的に除去する措置がとられた。墨で塗りつぶしたり，該当する部分を切り取ったりして，手元の教科書を使用する対応が行われた。"),
      text_block.call("③　義務教育諸学校の全学年を対象とする教科書の無償給与が実現した。国が教科書を購入して児童生徒に給与する制度により，義務教育段階の小学校と中学校の教科書が無償で提供されるようになった。"),
      text_block.call("④　民間の創意による多様な教科書を用いる趣旨から，検定を経た民間の発行者による教科書の使用が始まった。また，教科書の発行に関する臨時措置法に基づき，需給の調整や適正価格の維持などが図られた。"),
    ],
    choices: [
      text_choice.call("ア", "② → ① → ④ → ③", true),
      text_choice.call("イ", "① → ② → ④ → ③"),
      text_choice.call("ウ", "② → ④ → ① → ③"),
      text_choice.call("エ", "② → ① → ③ → ④"),
    ],
    explanation_blocks: [
      text_block.call("②は1945（昭和20）年の終戦直後の教材除去，①は1947（昭和22）年の新学制発足時の暫定的な文部省著作，④は1949（昭和24）年度からの検定教科書の使用，③は1969（昭和44）年度の義務教育諸学校全体における無償給与の実現である。"),
      text_block.call("ア：正しい。終戦直後の応急的な対応，新学制発足，検定教科書の使用，全体の無償給与という順序になる。"),
      text_block.call("イ：1947年の新学制発足を，1945年の教材除去より前に置いている。"),
      text_block.call("ウ：1949年度からの検定教科書の使用を，1947年の暫定的な文部省著作より前に置いている。"),
      text_block.call("エ：1969年度の全体の無償給与を，1949年度からの検定教科書の使用より前に置いている。"),
    ],
    source_text: "文部科学省『学制百二十年史』「第一節 初等教育」―新しい初等教育の発足 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318259.htm\n文部科学省『学制百年史』「三 新教育制度の具現」―新学制の実施と学習指導要領 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317739.htm\n文部科学省『学制百年史』「五 教科書制度の整備」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317797.htm\n玉川大学教育博物館「墨塗り教科書」 | https://www.tamagawa.ac.jp/museum/archive/1998/091.html\n文部科学省「12．教科書無償給与制度」―実施の経緯／教科書無償給与の流れ | https://www.mext.go.jp/a_menu/shotou/kyoukasho/gaiyou/04060901/1235098.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("デューイの教育思想及び経験の捉え方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "民主主義と教育を結び付け，学校が社会の中で果たす役割を重視した。民主的な共同生活が成立しているかどうかを判断する基準を，代表者の選挙と多数決による決定手続の採用に求め，学校にもその手続を取り入れようとした。"),
      text_choice.call("イ", "『経験と教育』で，学習者の内的条件と環境の客観的条件とが関わる原理を連続性とし，ある経験が後の経験の質に影響する原理を相互作用とした。また，経験の現在の質と将来への影響を考慮する教育を重視した。"),
      text_choice.call("ウ", "民主主義を，政治の仕組みにとどまらず，共同生活や共同経験の一様式として捉えた。関心を共有する範囲を広げ，異なる集団の間でも経験を交流できることを重視し，学校自体を，子どもが協同して生活する場として構想した。", true),
      text_choice.call("エ", "民主主義を共同生活と関連付け，教育では経験を共有するためのコミュニケーションを重視した。成熟した成員から未成熟な成員へ経験を伝える際，その過程で変わるのは受け手の性向であるとし，伝える側と学ぶ側の役割を区別した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：判断基準を選挙と多数決の手続へ置き換えた点が誤り。デューイが示すのは，関心の共有の広さや，集団間の自由な交流・相互作用という社会生活の基準であり，政治的な決定手続の採用だけを基準とする説明ではない。"),
      text_block.call("イ：連続性と相互作用の対応が逆。ある経験が後の経験の質に影響する原理が連続性で，学習者の内的条件と環境の客観的条件との関係が相互作用である。経験の現在の質と将来への影響を重視する後半は適切。"),
      text_block.call("ウ：適切。民主主義を共同生活・共同経験と関連付け，関心の共有と集団間の交流，学校の協同的な生活を結び付けている。"),
      text_block.call("エ：コミュニケーションで変わる対象を受け手へ限定した点が誤り。経験を分かち合う過程は，伝える側も含めた双方の性向を修正する。成熟者と未成熟者の区別を，経験の共有が一方向の変化になる理由として扱わない。"),
    ],
    source_text: "白石崇人『資料から考える教育原理』第13章・160〜162頁，資料10〜13 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n梶原郁郎「J.デューイの地理学習の『民主主義と教育』における構造的位置」24頁 | https://tohoku.repo.nii.ac.jp/record/124082/files/0386-0663-2017-44-21.pdf#page=4\n河北邦子・竹田礼子「小学校音楽科の創作活動にみる連続性と相互作用の研究―『こきりこ』のリズム伴奏づくりの班活動を通して―」第3節・3〜4頁 | https://ypir.lib.yamaguchi-u.ac.jp/yg/119/files/143344#page=3",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）{{①}}を計画的に利用しその機能の活用を図り，生徒の主体的・対話的で深い学びの実現に向けた{{②}}に生かすとともに，生徒の{{③}}な学習活動や読書活動を充実すること。また，地域の図書館や博物館，美術館，劇場，音楽堂等の施設の活用を積極的に図り，{{④}}情報の収集や鑑賞等の学習活動を充実すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校図書館", "授業改善", "自主的，自発的", "資料を活用した"], true),
      fill_in_choice.call("イ", ["学校図書館", "授業改善", "系統的，段階的", "体験を中心とした"]),
      fill_in_choice.call("ウ", ["学校の情報センター", "教育課程の編成", "自主的，自発的", "資料を活用した"]),
      fill_in_choice.call("エ", ["学校の情報センター", "教育課程の編成", "系統的，段階的", "体験を中心とした"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。学校図書館の機能を授業改善と自主的・自発的な活動に生かし、地域の施設でも資料を活用する学習を充実する。"),
      text_block.call("イ：①②は原文と一致する。③は「自主的，自発的」、④は「資料を活用した」である。ここでは生徒が自ら行う学習・読書と、資料を使った情報収集・鑑賞を示している。"),
      text_block.call("ウ：③④は原文と一致する。①は「学校図書館」、②は「授業改善」である。情報センター一般の機能や教育課程の編成という広い取組へ置き換えず、図書館の機能を授業改善に生かす対応を確認する。"),
      text_block.call("エ：全て原文と異なる。施設、活用を生かす取組、生徒の学習の性質、地域施設での学習方法をそれぞれ取り違えている。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款1（6）全文、PDF31頁／印刷29頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ウ　障害のある生徒などについては，家庭，地域及び{{①}}等の業務を行う関係機関との連携を図り，{{②}}で生徒への教育的支援を行うために，個別の教育支援計画を{{③}}とともに，各教科・科目等の指導に当たって，個々の生徒の実態を的確に把握し，個別の指導計画を{{③}}ものとする。特に，{{④}}については，個々の生徒の障害の状態等の実態を的確に把握し，個別の教育支援計画や個別の指導計画を作成し，効果的に活用するものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育や文化，芸術，スポーツ", "在学中の支援を中心とする視点", "作成し活用することに努める", "通級による指導を受ける生徒"]),
      fill_in_choice.call("イ", ["医療や福祉，保健，労働", "長期的な視点", "作成し活用することに努める", "通級による指導を受ける生徒"], true),
      fill_in_choice.call("ウ", ["医療や福祉，保健，労働", "長期的な視点", "作成し活用する義務を負う", "各教科・科目等で個別の指導を受ける生徒"]),
      fill_in_choice.call("エ", ["教育や文化，芸術，スポーツ", "在学中の支援を中心とする視点", "作成し活用する義務を負う", "各教科・科目等で個別の指導を受ける生徒"]),
    ],
    explanation_blocks: [
      text_block.call("ア：③④は原文と一致する。①は医療・福祉・保健・労働等の業務を行う関係機関まで含む語句、②は「長期的な視点」である。教育・文化・芸術・スポーツの機関との連携が一般に不要という意味ではなく、この箇所が明示する連携先と、在学中の支援を中心とする視点では表し切れない長期の視点を問う。"),
      text_block.call("イ：全て原文と一致する。関係機関と連携した長期的な教育的支援には個別の教育支援計画、各教科・科目等の指導には個別の指導計画を用いる。一般の障害のある生徒などについては両計画の作成・活用に「努める」とし、特に通級による指導を受ける生徒については、両計画を「作成し，効果的に活用するものとする」と定めている。"),
      text_block.call("ウ：①②は原文と一致する。③は「作成し活用することに努める」、④は「通級による指導を受ける生徒」である。一般の生徒に関する作成・活用の努力の規定を、そのまま作成・活用する義務を負う規定へ置き換え、通級指導を受ける生徒という対象を各教科・科目等の個別指導の対象へ広げている。"),
      text_block.call("エ：全て原文と異なる。①②の連携先と時間的な視点、③④の規定の強さと対象の関係をそれぞれ取り違えている。学校が支援に責任を負うかどうかを一般論として問うのではなく、この段落が区別する作成・活用の規定を判断する。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款2（1）ウ全文、PDF32〜33頁／印刷30〜31頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）の「第2章 総合的な探究の時間の特質」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "質の高い探究とは，次の二つで考えることができる。\n\n一つは，探究の過程が高度化するということである。高度化とは，①探究において{{①}}に矛盾がない（整合性），②探究において適切に{{②}}を活用している（効果性），③焦点化し深く掘り下げて探究している（鋭角性），④{{③}}を視野に入れながら探究している（広角性）などの姿で捉えることができる。\n\nもう一つは，探究が自律的に行われるということである。具体的には，①自分にとって関わりが深い課題になる（自己課題），②{{④}}つつ，自分の力で進められる（運用），③得られた知見を生かして社会に参画しようとする（社会参画）などの姿で捉えることができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["目的と解決の方法", "資質・能力", "多様な立場", "探究の成果を予測し"]),
      fill_in_choice.call("イ", ["探究の計画と得られた結果", "情報や資料", "幅広い可能性", "探究の過程を見通し"]),
      fill_in_choice.call("ウ", ["目的と解決の方法", "資質・能力", "幅広い可能性", "探究の過程を見通し"], true),
      fill_in_choice.call("エ", ["探究の計画と得られた結果", "情報や資料", "多様な立場", "探究の成果を予測し"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は一致する。③は「幅広い可能性」，④は「探究の過程を見通し」。広角性は可能性の広がりを視野に入れる姿を，運用は探究の過程を見通して自分の力で進める姿を指す。立場の多様さへの配慮や成果の予測とは対象が異なる。"),
      text_block.call("イ：③④は一致する。①は「目的と解決の方法」，②は「資質・能力」。整合性は目的と方法の関係に矛盾がないことを，効果性は資質・能力を適切に活用する姿を示す。計画と結果の一致，情報・資料という資源の活用へ置き換えない。"),
      text_block.call("ウ：全て一致する。整合性では目的と方法の対応，効果性では資質・能力の活用，広角性では可能性の広がり，運用では過程の見通しと自力での遂行を示す。分類の名称だけでなく，それぞれが直接対象としている関係・行動を区別する。"),
      text_block.call("エ：全て異なる。①は「目的と解決の方法」，②は「資質・能力」，③は「幅広い可能性」，④は「探究の過程を見通し」とする。計画・結果の照合，資料の活用，立場の考慮，成果の予測も探究に関わり得るが，ここで示された各視点の説明とは取り違えている。"),
    ],
    source_text: "高等学校学習指導要領解説 総合的な探究の時間編 第2章1，質の高い探究の二つの視点，印刷9頁／PDF17頁 | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=17",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("参考（参照先の内容説明。以下の抜粋とは別の補足）：抜粋中の「第１款の２の（2）に示す道徳教育の目標」は，人間としての在り方生き方を考え，主体的な判断の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことを指す。また，「各教科・科目等」は，各教科に属する科目，総合的な探究の時間及び特別活動をまとめた呼び方である。"),
      { type: "fill_in_quote", text: "１ 各学校においては，第１款の２の（2）に示す道徳教育の目標を踏まえ，{{①}}を作成し，校長の方針の下に，道徳教育の推進を主に担当する教師（「道徳教育推進教師」という。）を中心に，{{②}}が協力して道徳教育を展開すること。なお，{{①}}の作成に当たっては，生徒や学校の実態に応じ，{{③}}を明らかにして，各教科・科目等との関係を明らかにすること。その際，{{④}}並びに特別活動が，人間としての在り方生き方に関する中核的な指導の場面であることに配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["道徳教育の全体計画", "各ホームルーム担任", "教育課程の編成方針", "公民科の「公共」及び「政治・経済」"]),
      fill_in_choice.call("イ", ["道徳教育の年間指導計画", "全教師", "教育課程の編成方針", "公民科の「公共」及び「政治・経済」"]),
      fill_in_choice.call("ウ", ["道徳教育の年間指導計画", "各ホームルーム担任", "指導の方針や重点", "公民科の「公共」及び「倫理」"]),
      fill_in_choice.call("エ", ["道徳教育の全体計画", "全教師", "指導の方針や重点", "公民科の「公共」及び「倫理」"], true),
    ],
    explanation_blocks: [
      text_block.call("①は「道徳教育の全体計画」、②は「全教師」、③は「指導の方針や重点」、④は「公民科の『公共』及び『倫理』」である。校長の方針の下で道徳教育推進教師を中心に全教師が協力し、全体計画では生徒や学校の実態に応じた指導の方針・重点と各教科・科目等との関係を明らかにする。公民科の「公共」「倫理」と特別活動が、中核的な指導の場面として示される。"),
      text_block.call("ア：②③④が誤り。協力する範囲は各ホームルーム担任に置き換えず「全教師」とする。計画の作成に当たって明らかにする原語は「指導の方針や重点」であり、中核的な指導の科目は「公共」「倫理」である。"),
      text_block.call("イ：①③④が誤り。作成する計画は「道徳教育の全体計画」である。③④も原典がこの箇所に定める方針・重点及び科目の組合せと異なる。"),
      text_block.call("ウ：①②が誤り。③④は正しいが、作成する計画と、その計画の下で協力して道徳教育を展開する教師の範囲が異なる。"),
      text_block.call("エ：全て原文と一致する。全体計画、全教師の協力、指導の方針・重点及び中核的な指導の科目が正しく対応している。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款1全文（PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34\n同第1章第1款2(2)第1・第2段落（各教科・科目等の範囲及び道徳教育の目標、PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）{{①}}，{{②}}などについては，主に集団の場面で必要な指導や援助を行うガイダンスと，個々の生徒の{{③}}を踏まえ，一人一人が抱える課題に個別に対応した指導を行うカウンセリング（教育相談を含む。）の双方の趣旨を踏まえて指導を行うこと。特に入学当初においては，個々の生徒が学校生活に適応するとともに，{{④}}をもって生活をできるよう工夫すること。あわせて，生徒の家庭との連絡を密にすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校生活への適応や人間関係の形成", "学習計画や学習方法の選択", "多様な実態", "所属感や連帯感"]),
      fill_in_choice.call("イ", ["学校生活への適応や人間関係の形成", "教科・科目や進路の選択", "多様な実態", "希望や目標"], true),
      fill_in_choice.call("ウ", ["学習内容の理解や成績の向上", "教科・科目や進路の選択", "学習の到達度", "希望や目標"]),
      fill_in_choice.call("エ", ["学習内容の理解や成績の向上", "学習計画や学習方法の選択", "学習の到達度", "所属感や連帯感"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は一致する。②は「教科・科目や進路の選択」，④は「希望や目標」。所属感や連帯感は特別活動の別の目標にも関わるが，入学当初の適応と生活についてこの規定で示す語句は希望・目標である。"),
      text_block.call("イ：全て一致する。学校生活や人間関係，教科・科目及び進路の選択を，集団へのガイダンスと個別のカウンセリングの双方で支える。学習の到達度だけでなく多様な実態を踏まえ，入学当初の希望や目標にも配慮する。"),
      text_block.call("ウ：②④は一致する。①は「学校生活への適応や人間関係の形成」，③は「多様な実態」。規定の対象を学習内容の理解・成績に置き換えず，個別の指導で踏まえる範囲を到達度に狭めない。"),
      text_block.call("エ：全て異なる。①は学校生活への適応と人間関係の形成，②は教科・科目及び進路の選択，③は多様な実態，④は希望・目標に訂正する。"),
    ],
    source_text: "高等学校学習指導要領 第5章 第3の2（3），印刷481頁／PDF483頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=483",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 6, 7, 8, 9, 10]
  raise "模擬試験34の承認済み問番号は1・2及び6〜10です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",

  6 => "curriculum_organization", 7 => "special_support_education",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
}
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == categories.fetch(number)
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  if number <= 3
    unless blocks.all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "text" && !choice.fetch(:content_blocks).first.fetch(:text).strip.empty? }
      raise "問#{number}の本文と選択肢は通常の文章ブロックにしてください"
    end
  else
    quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten }.uniq
    expected_blocks = number == 9 ? %w[fill_in_text text fill_in_quote] : %w[fill_in_text fill_in_quote]
    unless blocks.map { |block| block[:type] } == expected_blocks && quotes.size == 1 &&
        blocks.first.fetch(:text).include?(number <= 5 ? "空欄 ① ～ ④" : "空欄 {{①}} ～ {{④}}") && labels == %w[① ② ③ ④] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 && choice.fetch(:content_blocks).first.fetch(:cells).all? { |cell| !cell.strip.empty? } }
      raise "問#{number}の抜粋・4空欄と選択肢の対応が不正です"
    end
    if number <= 5 && !quotes.first.fetch(:text).match?(/\A第\d+条第\d+項/)
      raise "問#{number}の抜粋枠の冒頭に条番号・項番号を表示してください"
    end
    if (6..10).cover?(number)
      cells = choices.map { |choice| choice.fetch(:content_blocks).first.fetch(:cells) }
      unless cells.transpose.all? { |column| column.group_by { |cell| cell }.values.map(&:size).sort == [2, 2] }
        raise "問#{number}の選択肢は各列の語句を2対2にしてください"
      end
      if number == 6 && !(blocks.first.fetch(:text).include?("第1章 総則 第3款 教育課程の実施と学習評価") && question.fetch(:source_text).include?("第3款"))
        raise "問6は総則第3款から出題してください"
      end
      if number == 7 && !(blocks.first.fetch(:text).include?("第1章 総則 第5款 生徒の発達の支援") && question.fetch(:source_text).include?("第5款"))
        raise "問7は総則第5款から出題してください"
      end
    end
  end
  explanation = question.fetch(:explanation_blocks)
  unless explanation.all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
      %w[ア イ ウ エ].all? { |label| explanation.any? { |block| block.fetch(:text).start_with?("#{label}：") } }
    raise "問#{number}は全ての選択肢の解説を記載してください"
  end
  sources = question.fetch(:source_text).lines
  unless sources.any? && sources.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
    raise "問#{number}の出典は資料名・章節とURLを記載してください"
  end
end

QuestionSeedSync.import(exam_number: 34, questions: questions, publication_status: "draft")

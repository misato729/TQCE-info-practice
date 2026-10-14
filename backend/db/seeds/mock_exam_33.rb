text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験33（承認済みの問1・2及び問6〜10。全20問がそろうまで下書き）
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
      text_block.call("大正新教育に関わる人物の教育思想や実践について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "木下竹次は，奈良女子高等師範学校附属小学校で，子どもの自発性・自律性を重視する学習法を構想した。子どもを学習の主体として，生活と学習を結び付け，教科ごとに分かれた学習を総合的に扱う合科学習を進めた。"),
      text_choice.call("イ", "澤柳政太郎が創設した成城小学校では，個性尊重，自然と親しむ教育，心情の教育，科学的研究を基とする教育が掲げられた。個々の子どもの能力を踏まえた学習の進め方や感性を育てる教育を重視し，教育の実際と研究を結び付けようとした。"),
      text_choice.call("ウ", "手塚岸衛は，千葉県師範学校附属小学校で自由教育を進め，八大教育主張講演会でも自由教育論を唱えた。子どもの関心や感動を大切にし，子ども自身が学ぶ目的を決めて学習する「自教育」を実践した。"),
      text_choice.call("エ", "小原國芳は，全人教育によって真，善，美，聖，健，富の価値を調和的に形成することを重視した。全人教育を共通の人格的基礎を完成させる段階，個性尊重の教育をその後の個別的な発展の段階とし，前者を終えてから後者へ進む関係として位置付けた。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。木下の学習法は，自発性・自律性に基づき，子どもを学習の主体とする合科学習を含むものである。生活と学習の関係を重視した。"),
      text_block.call("イ：適切。成城の四綱領と，個々の能力に応じた学習，感性の教育，教育の実際に即した研究という説明が対応している。"),
      text_block.call("ウ：適切。手塚の自由教育論及び千葉師範附属での「自教育」は，子どもが学習の目的を自ら決めることを重視した。"),
      text_block.call("エ：全人教育と個性尊重を前後の別段階とする点が誤り。小原は両者を対立・分離するものとせず，個性の発揮と調和ある人格の形成が結び付く「一物の両面」と捉えた。六つの価値を調和的に形成するという前半は適切。"),
    ],
    source_text: "奈良女子大学学術情報センター「『学習研究』について」―小田切毅一による公開説明 | https://www.nara-wu.ac.jp/aic/gdb/nwugdb/z002/aisatu.html\n成城学園「建学の精神」 | https://www.seijogakuen.ed.jp/thought/founders-vision/\n千葉大学教育学部附属小学校「大正自由主義教育運動－本校の歴史」 | https://www.el.chiba-u.jp/news-detail.php?id=118\n玉川学園「全人教育」―2．全人教育と個性尊重の教育 | https://www.tamagawa.jp/introduction/history/detail_12629.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("西洋の教育思想について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ルソーは，『エミール』で子どもを小さな大人として扱うことを改め，子ども期に固有の活動や発達を重視した。大人の価値観を性急に教え込むことを避け，子どもが事物や経験を通して学べるようにする教育を論じた。"),
      text_choice.call("イ", "カントは，人間は教育によって人間になるとし，教育を養育・訓練・教授と指導に分けた。訓練を知識や技能を積極的に身に付けさせる営みとし，教授と指導を，動物的な衝動によって人間性の法則から逸脱することを予防する営みとした。", true),
      text_choice.call("ウ", "ペスタロッチは，貧しい子どもの教育に取り組み，人間の諸力の調和的発達を重視した。家庭における親子の関係や生活を人間形成の基礎とし，具体的な事物を捉える直観から，知的な認識を明瞭にしていく教授を構想した。"),
      text_choice.call("エ", "デューイは，学校と社会生活との関係を重視し，学校を共同生活の場として捉えた。子どもが活動を通して経験を得ることと，その経験を他者と分かち合うことを結び付け，民主的な社会の形成に関わる教育を論じた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。ルソーは子ども期に固有の活動・発達を重視し，事物や経験を通して学ぶ教育を構想した。消極教育は，子どもの経験が成立する条件を整えることとも結び付く。"),
      text_block.call("イ：不適切。訓練と教授・指導（陶冶）の役割が逆。訓練は動物的な衝動による逸脱を予防する働きをもち，教授・指導は能力や技能を身に付け，学んだことを実践するよう積極的に導く働きに関わる。カントは，自ら思考することを学ぶ意義も重視した。"),
      text_block.call("ウ：適切。貧民教育，家庭的な関係，諸力の調和，直観に基づく教授はペスタロッチに対応する。"),
      text_block.call("エ：適切。学校を共同生活の場とし，経験の共有を通して個人の成長と民主的な社会の形成を結び付ける説明は，デューイの教育思想に対応する。"),
    ],
    source_text: "白石崇人『資料から考える教育原理』第9章・105〜107頁，第10章・120頁，第13章・160〜162頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n筑波大学附属図書館『近代教育学の源流』III「教育学と自然・人間・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html\n同IV「教育学と家庭・学校・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n明治図書『世界教育学選集60 教育学講義 他』カント著・伊勢田耀子ほか訳 | https://www.meijitosho.co.jp/detail/4-18-056028-3",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特に，各教科・科目等において身に付けた知識及び技能を{{①}}，思考力，判断力，表現力等や学びに向かう力，人間性等を発揮させたりして，学習の対象となる物事を捉え思考することにより，各教科・科目等の特質に応じた{{②}}（以下「見方・考え方」という。）が鍛えられていくことに留意し，生徒が各教科・科目等の特質に応じた見方・考え方を働かせながら，{{③}}，情報を精査して考えを形成したり，問題を見いだして解決策を考えたり，{{④}}することに向かう過程を重視した学習の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["活用したり", "物事を捉える視点や考え方", "知識を領域ごとに分類して体系的に整理したり", "知識や技能を基に評価したり"]),
      fill_in_choice.call("イ", ["確認したり", "問題を解決する能力や技能", "知識を相互に関連付けてより深く理解したり", "思いや考えを基に創造したり"]),
      fill_in_choice.call("ウ", ["確認したり", "問題を解決する能力や技能", "知識を領域ごとに分類して体系的に整理したり", "知識や技能を基に評価したり"]),
      fill_in_choice.call("エ", ["活用したり", "物事を捉える視点や考え方", "知識を相互に関連付けてより深く理解したり", "思いや考えを基に創造したり"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は原文と一致する。③は「知識を相互に関連付けてより深く理解したり」、④は「思いや考えを基に創造したり」である。知識の領域ごとの整理や評価も学習行為として成立するが、この箇所の深い理解・創造に向かう過程を置き換えている。"),
      text_block.call("イ：③④は原文と一致する。①は「活用したり」、②は「物事を捉える視点や考え方」である。「見方・考え方」は各教科・科目等の特質に応じて物事を捉える視点や考え方を指し、問題を解決する能力や技能そのものを名称の定義にはしていない。"),
      text_block.call("ウ：全て原文と異なる。知識・技能の活用、見方・考え方の意味、知識相互の関係付け、思いや考えからの創造という対応を確認する。"),
      text_block.call("エ：全て原文と一致する。既に身に付けた知識・技能の活用と資質・能力の発揮を通じて見方・考え方が鍛えられ、その見方・考え方を働かせる学習の過程を重視する。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款1（1）第2段落全文、PDF30頁／印刷28頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "イ　障害のある生徒に対して，学校教育法施行規則第140条の規定に基づき，{{①}}を編成し，障害に応じた特別の指導（以下「通級による指導」という。）を行う場合には，学校教育法施行規則第129条の規定により定める現行の特別支援学校高等部学習指導要領第６章に示す{{②}}の内容を参考とし，{{③}}を定め，指導を行うものとする。その際，通級による指導が効果的に行われるよう，{{④}}と通級による指導との関連を図るなど，教師間の連携に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["特別の教育課程", "職業教育", "共通の評価基準や方法", "各教科・科目等"]),
      fill_in_choice.call("イ", ["高等学校の標準的な教育課程", "自立活動", "具体的な目標や内容", "個別の教育支援計画"]),
      fill_in_choice.call("ウ", ["特別の教育課程", "自立活動", "具体的な目標や内容", "各教科・科目等"], true),
      fill_in_choice.call("エ", ["高等学校の標準的な教育課程", "職業教育", "共通の評価基準や方法", "個別の教育支援計画"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は原文と一致する。②は「自立活動」、③は「具体的な目標や内容」である。参考とする自立活動の内容から、通級による指導の具体的な目標・内容を定める規定であり、職業教育や共通の評価基準を定める規定ではない。"),
      text_block.call("イ：②③は原文と一致する。①は「特別の教育課程」、④は「各教科・科目等」である。個別の教育支援計画も支援に使う計画だが、この段落の教師間の連携では、各教科・科目等と通級による指導の関連を図る。"),
      text_block.call("ウ：全て原文と一致する。特別の教育課程として行う通級による指導について、自立活動を参考に目標・内容を定め、各教科・科目等との関連を図る。"),
      text_block.call("エ：全て原文と異なる。通級による指導を位置付ける教育課程、参照する内容、定める事項、関連付ける対象をそれぞれ取り違えている。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款2（1）イ第1段落全文、PDF32頁／印刷30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）年間や，{{①}}を見通して，その中で育む資質・能力の育成に向けて，生徒の主体的・対話的で深い学びの実現を図るようにすること。その際，生徒や学校，地域の実態等に応じて，生徒が探究の見方・考え方を働かせ，教科・科目等の枠を超えた横断的・総合的な学習や生徒の興味・関心等に基づく学習を行うなど創意工夫を生かした教育活動の充実を図ること。\n（2）全体計画及び年間指導計画の作成に当たっては，学校における全教育活動との関連の下に，目標及び内容，学習活動，指導方法や指導体制，{{②}}の計画などを示すこと。\n（3）目標を実現するにふさわしい探究課題を設定するに当たっては，{{③}}を生かすことができるよう配慮すること。\n（4）他教科等及び総合的な探究の時間で身に付けた資質・能力を相互に関連付け，学習や生活において生かし，それらが総合的に働くようにすること。その際，言語能力，{{④}}など全ての学習の基盤となる資質・能力を重視すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["単元など内容や時間のまとまり", "学習の評価", "生徒の学習習慣や生活経験", "コミュニケーション能力"]),
      fill_in_choice.call("イ", ["単元など内容や時間のまとまり", "学習の評価", "生徒の多様な課題に対する意識", "情報活用能力"], true),
      fill_in_choice.call("ウ", ["学期など学校生活の時間的な区切り", "教材の配置", "生徒の多様な課題に対する意識", "情報活用能力"]),
      fill_in_choice.call("エ", ["学期など学校生活の時間的な区切り", "教材の配置", "生徒の学習習慣や生活経験", "コミュニケーション能力"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は一致する。③は「生徒の多様な課題に対する意識」，④は「情報活用能力」。生活経験の活用やコミュニケーションの重要性自体を否定せず，探究課題の設定と学習の基盤に関する原文の対応を問う。"),
      text_block.call("イ：全て一致する。内容・時間のまとまりを見通す授業改善，評価を含む指導計画，生徒の課題意識を生かした課題設定，全ての学習の基盤となる資質・能力を関連させる。"),
      text_block.call("ウ：③④は一致する。①は「単元など内容や時間のまとまり」，②は「学習の評価」。学期など学校生活の時間的な区切りだけでなく，単元など学習内容と時間のまとまりを見通す点を示す。指導計画に示す事項の一つとしては評価が挙げられる。"),
      text_block.call("エ：全て異なる。①は学習のまとまり，②は学習の評価，③は多様な課題への意識，④は情報活用能力。授業改善・計画・課題設定・基盤となる能力の各位置付けに訂正する。"),
    ],
    source_text: "高等学校学習指導要領 第4章 第3の1（1）〜（4），印刷476頁／PDF478頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，{{①}}と生命に対する畏敬の念を家庭，学校，その他社会における具体的な生活の中に生かし，豊かな心をもち，伝統と文化を尊重し，それらを育んできた{{②}}を愛し，個性豊かな文化の創造を図るとともに，平和で民主的な国家及び社会の形成者として，{{③}}を尊び，社会及び国家の発展に努め，他国を尊重し，国際社会の平和と発展や環境の保全に貢献し{{④}}のある日本人の育成に資することとなるよう特に留意すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間尊重の精神", "我が国と郷土", "公共の精神", "未来を拓く主体性"], true),
      fill_in_choice.call("イ", ["人間尊重の精神", "家庭と地域社会", "自律の精神", "国際社会で活躍する能力"]),
      fill_in_choice.call("ウ", ["人間相互の信頼感", "我が国と郷土", "自律の精神", "国際社会で活躍する能力"]),
      fill_in_choice.call("エ", ["人間相互の信頼感", "家庭と地域社会", "公共の精神", "未来を拓く主体性"]),
    ],
    explanation_blocks: [
      text_block.call("①は「人間尊重の精神」、②は「我が国と郷土」、③は「公共の精神」、④は「未来を拓く主体性」である。人間尊重と生命への畏敬を具体的な生活に生かすこと、伝統・文化の尊重と創造、公共の精神、他国の尊重、国際社会の平和と発展及び環境の保全への貢献を連続して示している。"),
      text_block.call("ア：全て原文と一致する。生活の中に生かす精神、伝統・文化を育んできた対象、形成者として尊ぶ精神及び育成する日本人の主体性との対応が正しい。"),
      text_block.call("イ：②③④が誤り。②は「我が国と郷土」である。平和で民主的な国家及び社会の形成者として尊ぶ③の原語は「公共の精神」であり、「自律の精神」ではない。④は「未来を拓く主体性」である。"),
      text_block.call("ウ：①③④が誤り。生命に対する畏敬の念と併記する原語は「人間尊重の精神」である。③④も、この段落で示す精神及び主体性の語句と異なる。"),
      text_block.call("エ：①②が誤り。③④は正しいが、人間尊重の精神と、伝統・文化を育んできた我が国・郷土との対応が原文と一致しない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款2(2)第3段落（PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第3章 各活動・学校行事の目標と内容 第1節 ホームルーム活動」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ホームルーム活動の内容「（2）日常の生活や学習への適応と自己の成長及び健康安全」，内容「（3）一人一人のキャリア形成と自己実現」においては，（2）は{{①}}における生活上の課題，（3）は{{①}}を見通した学習や在り方生き方に関する課題という違いがあるが，問題の発見・確認，{{②}}，解決方法の決定，{{③}}，振り返りという基本的な学習過程は同じである。なお，ホームルーム経営や生徒の発達段階を踏まえ，教師がこれらの活動で取り上げたいことをあらかじめ年間指導計画に即して設定したものを「題材」と称す。ここで言う「問題の発見・確認」とは，「題材」に基づいた資料やアンケート結果から生徒一人一人が日常生活や将来に向けた自己の生き方，進路等の問題を確認し，取り組むべき課題を見いだして，{{④}}をもつことを示している。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["現在及び将来", "課題の分析", "解決案の共有", "解決の見通し"]),
      fill_in_choice.call("イ", ["将来", "課題の分析", "解決案の共有", "評価の基準"]),
      fill_in_choice.call("ウ", ["現在及び将来", "解決方法の話合い", "決めたことの実践", "解決の見通し"], true),
      fill_in_choice.call("エ", ["将来", "解決方法の話合い", "決めたことの実践", "評価の基準"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は一致する。②は「解決方法の話合い」，③は「決めたことの実践」。分析や解決案の共有に置き換えず，話合いによる考察，決定，実践，振り返りという過程を押さえる。"),
      text_block.call("イ：全て異なる。両内容とも現在及び将来を対象とする。基本的な学習過程には解決方法の話合いと決めたことの実践があり，問題の発見・確認では解決の見通しをもつ。"),
      text_block.call("ウ：全て一致する。扱う課題の領域には違いがあっても，現在・将来を視野に入れ，話合いから実践・振り返りへ進む基本過程は共通する。題材から自己の課題を見いだす段階も，解決への見通しと結び付く。"),
      text_block.call("エ：②③は一致する。①は「現在及び将来」であり，将来だけを扱うのではない。④は「解決の見通し」であり，この段階を評価基準の設定と取り違えない。"),
    ],
    source_text: "高等学校学習指導要領解説 特別活動編 第3章 第1節1，ホームルーム活動（2）（3）の基本的な学習過程の説明，印刷39頁／PDF47頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=47",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 6, 7, 8, 9, 10]
  raise "模擬試験33の承認済み問番号は1・2及び6〜10です"
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
    expected_blocks = %w[fill_in_text fill_in_quote]
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

QuestionSeedSync.import(exam_number: 33, questions: questions, publication_status: "draft")

text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験35（承認済みの問1・2及び問6〜10。全20問がそろうまで下書き）
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
      text_block.call("戦後の新制大学と高等教育の改革について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "新制大学は，旧制の大学，高等学校，専門学校などを改編して発足し，専門的な研究や職業人の養成とともに一般的な教養を重視した。この教養教育は，旧制高等学校と同じく大学入学前の独立した予科に置き，大学の学部では専門教育を行う構成とした。"),
      text_choice.call("イ", "新制国立大学の設置では，教育の機会均等や大都市への集中を避けることが重視され，一府県一大学の方針が示された。これは，府県内の国立・公立・私立の大学を一校に統合し，その大学が地域の高等教育を担うようにする方針であった。"),
      text_choice.call("ウ", "新制大学では，旧制の高等教育機関が狭い専門教育や職業教育に偏っていた点を改め，一般的な人間的教養を基盤として，学問研究と職業人の養成を結び付けようとした。また，勤労青年に大学教育の機会を広げるため，夜間の学部や通信による教育も制度上位置付けられた。", true),
      text_choice.call("エ", "短期大学は，旧制の専門学校の中で四年制大学への転換が認められなかった学校などに対応して，昭和25年度に発足した。修業年限は二年又は三年とされ，発足時から学校体系の恒久的な制度として位置付け，四年制大学と並ぶ独自の高等教育を担うものとした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：一般的教養を大学入学前の独立した予科に置いたとする点が誤り。一般教育は新制大学自体の重要な理念であり，大学の教養課程などで行われた。一般教養を基盤に専門教育と結び付ける構成へ転換したのであって，旧制高等学校・大学予科の仕組みをそのまま維持したのではない。"),
      text_block.call("イ：一府県一大学という方針の対象が誤り。新制国立大学の設置に関する方針であり，国立・公立・私立の大学を府県内の一校へ統合する方針ではない。教育機会と大都市集中への配慮は適切。"),
      text_block.call("ウ：適切。新制大学における一般的教養と専門教育の関係及び，夜間・通信による大学教育への機会の拡大を述べている。"),
      text_block.call("エ：発足時の制度上の位置付けが誤り。短期大学は当初，暫定措置として設けられた。後に1964（昭和39）年の学校教育法改正で恒久的な制度となった。発足年度と修業年限は適切。"),
    ],
    source_text: "文部科学省『学制百二十年史』「第三節 高等教育」―新制大学の制度・発足／短期大学の発足／大学の通信制教育と夜間制教育 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318261.htm\n文部科学省『学制百二十年史』「第三節 高等教育」―大学制度の整備／短期大学制度の確立と発展 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318274.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("フレーベルとモンテッソーリの教育思想及び教育方法について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "フレーベルは，遊びを子どもの内面が表れる自己活動として重視し，恩物を考案した。モンテッソーリは，教具を使った作業の正否を教師が判定し，その結果を子どもへ伝えて修正させる過程を，自己訂正として位置付けた。"),
      text_choice.call("イ", "フレーベルは，遊びや自己活動を援助するために幼稚園を創設した。モンテッソーリは，子どもの活動を観察し，その発達に合わせた環境を整えることを重視し，この考えを，幼児の教育遊具である恩物の開発へ具体化した。"),
      text_choice.call("ウ", "フレーベルは，恩物を用いた遊びを通して子どもの内的な力を育てようとした。モンテッソーリは，ある能力を獲得した後，その能力を安定させる活動に特に強い関心を示す時期を敏感期とし，その時期に応じた環境を整えた。"),
      text_choice.call("エ", "フレーベルは，遊びを内的なものが表れる自己活動と捉え，恩物を用いた活動を重視した。モンテッソーリは，子どもが自ら活動を選び，誤りにも気付いて修正できる教具や環境を整え，教師に活動を観察し援助する役割を求めた。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：自己訂正の主体・仕組みが誤り。自己訂正は，教具の仕組みなどを通して，子ども自身が誤りに気付き修正することに関わる。教師の判定結果を受けて直す過程の名称ではない。"),
      text_block.call("イ：恩物を考案したのはフレーベル。モンテッソーリによる観察・環境の整備の説明は適切だが，その方法を恩物の開発へ結び付けた点が誤り。"),
      text_block.call("ウ：敏感期を，能力を獲得した後の安定化の時期とした点が誤り。ある事柄へ特に強い関心をもち，集中した活動・反復を通して一定の能力を獲得していく時期に関わる。"),
      text_block.call("エ：適切。両者とも子どもの自発的な活動を重視するが，フレーベルの遊び・恩物と，モンテッソーリの自己訂正的な教具・観察に基づく援助を区別している。どちらか一方だけが遊びや環境を重視するという対立ではない。"),
    ],
    source_text: "白石崇人『資料から考える教育原理』第11章・129〜131頁，第12章・142〜145頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n広島文教大学附属幼稚園「モンテッソーリ教育」 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒の{{①}}などを積極的に評価し，学習したことの意義や価値を実感できるようにすること。また，{{②}}に向けた学習状況を把握する観点から，{{③}}を見通しながら評価の場面や方法を工夫して，学習の過程や成果を評価し，指導の改善や学習意欲の向上を図り，資質・能力の育成に生かすようにすること。\n（2）創意工夫の中で学習評価の妥当性や信頼性が高められるよう，組織的かつ計画的な取組を推進するとともに，{{④}}を越えて生徒の学習の成果が円滑に接続されるように工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["よい点や進歩の状況", "各教科・科目等の目標の実現", "学期や学年など学校暦上の区切り", "教科や科目の領域"]),
      fill_in_choice.call("イ", ["到達目標との差や課題", "学校の教育活動全体の進展", "単元や題材など内容や時間のまとまり", "学年や学校段階"]),
      fill_in_choice.call("ウ", ["よい点や進歩の状況", "各教科・科目等の目標の実現", "単元や題材など内容や時間のまとまり", "学年や学校段階"], true),
      fill_in_choice.call("エ", ["到達目標との差や課題", "学校の教育活動全体の進展", "学期や学年など学校暦上の区切り", "教科や科目の領域"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は原文と一致する。③は「単元や題材など内容や時間のまとまり」、④は「学年や学校段階」である。評価を見通すまとまりと、学習成果を接続する範囲を、学校暦の区切り及び教科横断の領域へ置き換えている。"),
      text_block.call("イ：③④は原文と一致する。①は「よい点や進歩の状況」、②は「各教科・科目等の目標の実現」である。生徒の前進を積極的に評価することと、各教科・科目等の目標を基準に学習状況を把握することを確認する。"),
      text_block.call("ウ：全て原文と一致する。よい点・進歩の評価、目標に向けた学習状況の把握、単元や題材を見通した評価、学年や学校段階を越える成果の接続を示す。"),
      text_block.call("エ：全て原文と異なる。①②は生徒の評価対象と学習状況を把握する基準、③④は評価のまとまりと成果の接続範囲を取り違えている。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款2（1）〜（2）、PDF31頁／印刷29頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）不登校生徒への配慮\nア　不登校生徒については，保護者や関係機関と連携を図り，{{①}}の助言又は援助を得ながら，{{②}}を目指す観点から，個々の生徒の実態に応じた情報の提供その他の必要な支援を行うものとする。\nイ　相当の期間高等学校を欠席し引き続き欠席すると認められる生徒等を対象として，{{③}}が認める特別の教育課程を編成する場合には，生徒の実態に配慮した教育課程を編成するとともに，個別学習やグループ別学習など{{④}}の工夫改善に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["心理や福祉の専門家", "社会的自立", "都道府県教育委員会", "学習形態や評価方法"]),
      fill_in_choice.call("イ", ["医療や法律の専門家", "社会参加の機会拡大", "都道府県教育委員会", "学習形態や評価方法"]),
      fill_in_choice.call("ウ", ["医療や法律の専門家", "社会参加の機会拡大", "文部科学大臣", "指導方法や指導体制"]),
      fill_in_choice.call("エ", ["心理や福祉の専門家", "社会的自立", "文部科学大臣", "指導方法や指導体制"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は原文と一致する。③は「文部科学大臣」、④は「指導方法や指導体制」である。特別の教育課程を認める主体を取り違え、指導の方法と組織的な体制という原文の対応を、学習形態と評価方法へ置き換えている。"),
      text_block.call("イ：全て原文と異なる。①は「心理や福祉の専門家」、②は「社会的自立」であり、③④もそれぞれ文部科学大臣、指導方法や指導体制である。医療・法律の専門家との連携や社会参加の機会が支援上不要という意味ではなく、この箇所が明示する専門家と支援の観点を問う。"),
      text_block.call("ウ：③④は原文と一致する。①は「心理や福祉の専門家」、②は「社会的自立」である。特別の教育課程の制度と、不登校生徒への必要な支援の観点を分けて確認する。"),
      text_block.call("エ：全て原文と一致する。心理・福祉の専門家と連携して社会的自立を目指し、特別の教育課程では文部科学大臣の認定と、生徒の実態に応じた指導方法・指導体制の工夫を示す。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款2（3）ア〜イ全文、PDF33頁／印刷31頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（4）探究の過程においては，{{①}}して課題を解決しようとする学習活動や，言語により分析し，まとめたり表現したりするなどの学習活動が行われるようにすること。その際，例えば，比較する，分類する，関連付けるなどの{{②}}が自在に活用されるようにすること。\n（5）探究の過程においては，{{③}}などを適切かつ効果的に活用して，情報を収集・整理・発信するなどの学習活動が行われるよう工夫すること。その際，情報や情報手段を主体的に選択し活用できるよう配慮すること。\n（6）自然体験や就業体験活動，ボランティア活動などの社会体験，ものづくり，生産活動などの体験活動，{{④}}，調査・研究，発表や討論などの学習活動を積極的に取り入れること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["他者と協働", "考えるための技法", "コンピュータや情報通信ネットワーク", "観察・実験・実習"], true),
      fill_in_choice.call("イ", ["他者と協働", "考えるための技法", "教科書や参考書", "演習・復習・テスト"]),
      fill_in_choice.call("ウ", ["自己の経験を活用", "調べるための技法", "コンピュータや情報通信ネットワーク", "観察・実験・実習"]),
      fill_in_choice.call("エ", ["自己の経験を活用", "調べるための技法", "教科書や参考書", "演習・復習・テスト"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て一致する。協働と，言語及び考えるための技法の活用，コンピュータ・情報通信ネットワークによる情報活用，観察・実験・実習等を組み合わせて探究を支える。"),
      text_block.call("イ：①②は一致する。③は「コンピュータや情報通信ネットワーク」，④は「観察・実験・実習」。教科書等や演習を利用できないという意味ではなく，情報手段の活用と積極的に取り入れる活動について，この項に示された語句を問う。"),
      text_block.call("ウ：③④は一致する。①は「他者と協働」，②は「考えるための技法」。自分の経験の活用だけへ置き換えず，比較・分類・関連付けを思考の技法として位置付ける。"),
      text_block.call("エ：全て異なる。①は他者との協働，②は考えるための技法，③はコンピュータ・情報通信ネットワーク，④は観察・実験・実習に訂正する。"),
    ],
    source_text: "高等学校学習指導要領 第4章 第3の2（4）〜（6），印刷476頁／PDF478頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "２ 道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する道徳的諸価値についての理解を基にしながら，様々な体験や思索の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，自立心や自律性を高め，規律ある生活をすること，生命を尊重する心を育てること，{{①}}を高め，{{②}}意欲と態度を養うこと，義務を果たし責任を重んずる態度及び人権を尊重し差別のないよりよい社会を実現しようとする態度を養うこと，{{③}}を尊重し，それらを育んできた我が国と郷土を愛するとともに，{{④}}を尊重すること，国際社会に生きる日本人としての自覚を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["社会連帯の自覚", "主体的に自己の進路を選択する", "地域の生活と習慣", "国際機関"]),
      fill_in_choice.call("イ", ["社会連帯の自覚", "主体的に社会の形成に参画する", "伝統と文化", "他国"], true),
      fill_in_choice.call("ウ", ["国家・社会の一員としての自覚", "主体的に自己の進路を選択する", "伝統と文化", "他国"]),
      fill_in_choice.call("エ", ["国家・社会の一員としての自覚", "主体的に社会の形成に参画する", "地域の生活と習慣", "国際機関"]),
    ],
    explanation_blocks: [
      text_block.call("①は「社会連帯の自覚」、②は「主体的に社会の形成に参画する」、③は「伝統と文化」、④は「他国」である。社会連帯の自覚を高めることを社会形成に参画する意欲・態度と結び付け、伝統・文化及び我が国・郷土への愛と、他国の尊重及び国際社会に生きる日本人としての自覚を併せて示す。"),
      text_block.call("ア：②③④が誤り。②は進路選択ではなく、社会の形成への参画である。③は「伝統と文化」、④は「他国」であり、それぞれ原典が明示した対象と異なる。"),
      text_block.call("イ：全て原文と一致する。社会連帯と社会形成への参画、伝統・文化と他国の尊重の関係が正しい。"),
      text_block.call("ウ：①②が誤り。「国家・社会の一員としての自覚」は第1款2(2)第2段落の道徳教育の目標に記す語句である。この抜粋の①は「社会連帯の自覚」であり、②は社会形成への参画を表す。"),
      text_block.call("エ：①③④が誤り。②は正しいが、自覚の原語と、尊重する対象の二つが原文と一致しない。"),
      text_block.call("進路選択、地域の生活・習慣及び国際機関を尊重すること自体の是非を問うのではなく、当該段落が示す自覚・行動・対象の組合せを問う。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款2全文（PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34\n同第1章第1款2(2)第2段落（国家・社会の一員としての自覚、PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第2章 特別活動の目標 第2節 特別活動の基本的な性格と教育活動全体における意義」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特別活動は，学校生活を送る上での基盤となる力や，{{①}}を育む活動として機能し，人間形成の中でも特に，情意面や態度面の資質・能力の育成について強調してきた。今回の改訂では，各教科・科目等を通して育成することを目指す資質・能力として「知識及び技能」，「思考力・判断力・表現力等」，「学びに向かう力，人間性等」を{{②}}育むことを重視している。そのために重要なことは，目標に「様々な集団活動に自主的，実践的に取り組み」とあるように，自主的，実践的な活動を重視するということである。様々な集団活動の中で，「思考力・判断力・表現力等」を活用しながら他者と協力して実践することを通して，「知識及び技能」は{{③}}され，活動を通して得られたことを{{④}}生かそうとする「学びに向かう力，人間性等」が育成されていく。特別活動の内容は，各教科・科目等に広く関わるものであるが，こうした特徴をもつ特別活動だからこそ目指すことができる資質・能力を育むことが大切である。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["社会で他者と関わって生きて働く力", "総合的に", "反復的な練習によって習得", "生涯にわたって積極的に"]),
      fill_in_choice.call("イ", ["学校で他者と関わって活動を進める力", "バランスよく", "実感を伴って体得", "学校生活において自主的に"]),
      fill_in_choice.call("ウ", ["学校で他者と関わって活動を進める力", "総合的に", "反復的な練習によって習得", "学校生活において自主的に"]),
      fill_in_choice.call("エ", ["社会で他者と関わって生きて働く力", "バランスよく", "実感を伴って体得", "生涯にわたって積極的に"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は一致する。②は「バランスよく」，③は「実感を伴って体得」。三つの柱をバランスよく育み，他者と協力して実践することを通じ，知識・技能を実感とともに体得する点を示す。"),
      text_block.call("イ：②③は一致する。①は「社会で他者と関わって生きて働く力」，④は「生涯にわたって積極的に」。学校の中での活動だけに範囲を狭めず，社会生活と生涯にわたる活用へつなげる。"),
      text_block.call("ウ：全て異なる。社会で生きて働く力，三つの柱のバランス，実感を伴う体得，生涯にわたる積極的な活用という位置付けに訂正する。"),
      text_block.call("エ：全て一致する。学校生活の基盤だけでなく社会で働く力を育み，実践を通して三つの柱をバランスよく育成し，生涯の活用へつなげるという特別活動の教育的意義を示す。"),
    ],
    source_text: "高等学校学習指導要領解説 特別活動編 第2章 第2節2（1）「特別活動の特質を踏まえた資質・能力の育成」第1段落，印刷25頁／PDF33頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=33",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 6, 7, 8, 9, 10]
  raise "模擬試験35の承認済み問番号は1・2及び6〜10です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",

  6 => "curriculum_organization", 7 => "student_guidance_career",
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

QuestionSeedSync.import(exam_number: 35, questions: questions, publication_status: "draft")

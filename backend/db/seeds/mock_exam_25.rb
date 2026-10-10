text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験25（承認済みの全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "戦後の新制高等学校の発足と教育改革について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "新制高等学校の発足に当たり，旧制の学校間の格差を是正する趣旨から，小学区制，男女共学，総合制が重視された。総合制は，全日制，定時制，通信制の三つの課程を同じ学校に設け，学習時間帯や方法の違いを一つの学校にまとめる構想であった。"),
      text_choice.call("イ", "新制高等学校は，中学校に続く後期中等教育の学校として，高等普通教育と専門教育を併せ行うものとされた。勤労青少年には定時制の課程を設けたが，その教育は全日制より基礎的な程度とし，修了者には全日制とは別の卒業資格を与えた。"),
      text_choice.call("ウ", "新制高等学校では，普通教育を主とする学科と専門教育を主とする学科が設けられ，選択教科制と単位制によって進路の多様性に対応した。この制度は，旧制高等学校を新制高等学校に改編し，その大学予科としての教育を引き継いで成立した。"),
      text_choice.call("エ", "新制高等学校の発足に際して，旧制の中学校，高等女学校，実業学校の間の格差を是正する趣旨で，小学区制，男女共学，総合制が重視された。この総合制は，普通教育の課程と専門教育の課程を同じ学校に併置し，教育の機会均等を図る構想であった。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：三原則の説明は適切だが，総合制の内容が誤り。普通教育課程と専門教育課程の併置を指し，全日制・定時制・通信制の併置ではない。"),
      text_block.call("イ：新制高等学校の教育と定時制の設置目的は適切だが，教育の程度と資格が誤り。定時制は全日制と同等の教育を施し，同一の資格を与えるものとされた。"),
      text_block.call("ウ：学科や選択教科制・単位制の説明は適切だが，旧制学校との対応が誤り。新制高等学校は，主として旧制の中学校，高等女学校，実業学校が移行して成立した。旧制高等学校などは，新制大学の構成へと移っていった。"),
      text_block.call("エ：適切。新制高等学校の三原則と，総合制の意味を正しく説明している。文部省が三原則の一律実施を指導したのではなく，実施には地域差があったことも押さえたい。"),
    ],
    source_text: "文部科学省『学制百二十年史』「第二節 中等教育」―新制高等学校の発足／定時制・通信制教育／高等学校の教育課程 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318260.htm\n文部科学省『学制百年史』「七 新教育制度の整備・充実」―戦後の高等教育学校体系 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317572.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "コメニウスの『大教授学』における学校の構想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "子どもの発達に応じて，母親学校，母国語学校，ラテン語学校，大学という四つの段階を構想した。母親学校は家庭における幼児の教育を意味するもので，事物を見たり触れたりする感覚的な経験を重視し，その後の学校教育へつながる基礎とした。", true),
      text_choice.call("イ", "乳幼児期の教育を後の学校教育の基礎として重視し，母親学校では身近な事物を見聞きする学習を構想した。母親学校は，母親に代わる専門の教師が子どもを集めて教授する独立の就学施設を意味し，その後に母国語学校へ進むものとした。"),
      text_choice.call("ウ", "母親学校から大学に至る段階を設け，発達の段階に応じて教育する構想を示した。母親学校では，文字の読み書きを通して記憶力や想像力を育てることを主な課題とし，その次の母国語学校では，身近な事物を見聞きして外的な感覚を育てることを主な課題とした。"),
      text_choice.call("エ", "『大教授学』では，幼児期から青年期に至る学校を構想し，社会の広い範囲の人々へ教育を及ぼそうとした。母親学校の後は，家庭の身分に応じて母国語学校又はラテン語学校の別系統へ進む仕組みとし，両者を並行する学校として配置した。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切である。コメニウスは，発達段階に応じた四段階の学校を構想した。母親学校は，家庭で母親などが幼児に行う教育を指す。イは，母親学校を専門教師による独立の就学施設とした点が誤りである。ウは，母親学校と母国語学校の主要な課題の対応が逆である。母親学校では外的感覚，母国語学校では読み書きなどによる記憶力・想像力と手・舌の訓練が重視された。エは，二つの学校を身分に応じて分かれる並行の系統とした点が誤りであり，年齢と発達に対応する段階として構想された。"),
    ],
    source_text: "五十嵐裕子「コメニウスの保育思想に関する一考察―『母親学校』と『幼児期の学校』を中心に―」『浦和論叢』第54号・5〜6頁，第3節及び表1 | https://urawa.repo.nii.ac.jp/record/492/files/urawaronso_054_001-016.pdf#page=5\nコメニウス著・太田光一訳『大教授学』日本語訳・第27〜31章目次（東信堂） | https://www.toshindo-pub.com/book/091806/",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次の①～④のうち，「教育基本法」（平成18年法律第120号）の条文として正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "①　国及び地方公共団体は、家庭教育の自主性を尊重しつつ、保護者に対する学習の機会及び情報の提供その他の家庭教育を支援するために必要な施策を講ずるよう努めなければならない。" },
      { type: "fill_in_quote", text: "②　小学校は、文部科学大臣の定めるところにより当該小学校の教育活動その他の学校運営の状況について評価を行い、その結果に基づき学校運営の改善を図るため必要な措置を講ずることにより、その教育水準の向上に努めなければならない。" },
      { type: "fill_in_quote", text: "③　国及び地方公共団体は、障害のある者が、その障害の状態に応じ、十分な教育を受けられるよう、教育上必要な支援を講じなければならない。" },
      { type: "fill_in_quote", text: "④　幼児期の教育は、生涯にわたる人格形成の基礎を培う重要なものであることにかんがみ、国及び地方公共団体は、幼児の健やかな成長に資する良好な環境の整備その他適当な方法によって、その振興に努めなければならない。" },
    ],
    choices: [
      text_choice.call("ア", "二つ"),
      text_choice.call("イ", "三つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("①：教育基本法第10条第2項の，家庭教育への支援に関する規定である。家庭教育の自主性を尊重し，保護者に対する学習機会・情報の提供などの施策を講ずる努力義務を定めている。"),
      text_block.call("②：学校教育法第42条第1項の，学校評価とその結果に基づく改善に関する規定であり，教育基本法の条文ではない。高校へも第62条により準用されるが，法令の帰属は変わらない。"),
      text_block.call("③：教育基本法第4条第2項の，障害の状態に応じた教育上必要な支援に関する規定である。"),
      text_block.call("④：教育基本法第11条の，幼児期の教育の振興に関する規定である。"),
      text_block.call("したがって，教育基本法の条文は①・③・④の三つ。ア・ウ・エは個数が一致しない。"),
    ],
    source_text: "教育基本法・第4条第2項、第10条第2項、第11条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_10-Pr_2\n学校教育法・第42条第1項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_42-Pr_1",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第6条\n\n学校においては、{{①}}を徴収することができる。ただし、{{②}}の小学校及び中学校、義務教育学校、中等教育学校の{{③}}又は特別支援学校の{{④}}における義務教育については、これを徴収することができない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["授業料", "公立又は私立", "後期課程", "小学部及び中学部"]),
      fill_in_choice.call("イ", ["入学料", "公立又は私立", "後期課程", "中学部及び高等部"]),
      fill_in_choice.call("ウ", ["授業料", "国立又は公立", "前期課程", "小学部及び中学部"], true),
      fill_in_choice.call("エ", ["入学料", "国立又は公立", "前期課程", "中学部及び高等部"]),
    ],
    explanation_blocks: [
      text_block.call("第6条は，学校が「授業料」を徴収できることを原則とし，「国立又は公立」の列挙された学校段階で行われる義務教育については徴収できないと定める。中等教育学校について列挙されるのは「前期課程」，特別支援学校について列挙されるのは「小学部及び中学部」である。高等学校も学校一般についての原則に含まれるが，高等学校や特別支援学校高等部の授業料をこの条文のただし書によって不徴収とする規定ではない。"),
      text_block.call("ア：②は「国立又は公立」，③は「前期課程」。私立を含めた学校の列挙ではなく，中等教育学校の後期課程を挙げる規定でもない。"),
      text_block.call("イ：①〜④が全て原文と異なる。授業料と入学料，国立・公立と私立，前期課程と後期課程，特別支援学校の小学部・中学部と高等部を区別する。"),
      text_block.call("ウ：4語句が原文と一致する。"),
      text_block.call("エ：①は「授業料」，④は「小学部及び中学部」。この条文は入学料についての規定ではなく，特別支援学校高等部をただし書の対象へ含める規定でもない。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第6条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_1-At_6",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：本文の「主幹教諭等」は、公立の小学校等の主幹教諭、指導教諭、主務教諭、教諭、養護教諭、栄養教諭、主幹保育教諭、指導保育教諭、主務保育教諭、保育教諭又は講師を指す（第26条第1項）。" },
      { type: "fill_in_quote", text: "第27条　大学院修学休業をしている主幹教諭等は、地方公務員としての身分を保有するが、{{①}}。\n\n２　大学院修学休業をしている期間については、{{②}}。\n\n第28条　大学院修学休業の許可は、当該大学院修学休業をしている主幹教諭等が{{③}}の処分を受けた場合には、その{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["職務に従事しない", "給与を支給しない", "休職又は停職", "効力を失う"], true),
      fill_in_choice.call("イ", ["職務に従事しない", "給与を支給する", "降任又は減給", "期間が短縮される"]),
      fill_in_choice.call("ウ", ["職務に従事する", "給与を支給しない", "降任又は減給", "期間が短縮される"]),
      fill_in_choice.call("エ", ["職務に従事する", "給与を支給する", "休職又は停職", "効力を失う"]),
    ],
    explanation_blocks: [
      text_block.call("正答はア。原語は①「職務に従事しない」、②「給与を支給しない」、③「休職又は停職」、④「効力を失う」。大学院修学休業中も地方公務員としての身分は保有するが、職務に従事せず、その期間の給与は支給されない。休職又は停職の処分を受けた場合、休業の許可は効力を失う。イは②を給与支給、③を降任・減給、④を期間短縮としている。ウは①を職務従事とし、③・④も誤り。エは①・②が誤り。身分を保有することから職務従事や給与支給が当然に続くと考えず、大学院修学休業の具体的な効果を押さえる。なお、第22条第3項の現職のまま受ける長期研修とは、別に定められた制度である。"),
    ],
    source_text: "教育公務員特例法・第26条第1項、第27条、第28条第1項、第22条第3項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_5-At_27",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報活用能力の育成を図るため，各学校において，コンピュータや情報通信ネットワークなどの情報手段を活用するために{{①}}を整え，これらを{{②}}した学習活動の充実を図ること。また，{{③}}，視聴覚教材や教育機器などの{{④}}の適切な活用を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["必要な環境", "計画的に利用", "教科書や参考書", "情報・資料"]),
      fill_in_choice.call("イ", ["共通の利用基準", "適切に活用", "教科書や参考書", "情報・資料"]),
      fill_in_choice.call("ウ", ["必要な環境", "適切に活用", "各種の統計資料や新聞", "教材・教具"], true),
      fill_in_choice.call("エ", ["共通の利用基準", "計画的に利用", "各種の統計資料や新聞", "教材・教具"]),
    ],
    explanation_blocks: [
      text_block.call("情報活用能力を育てるための環境整備と，情報手段を活用する学習活動の充実を述べている。後半では統計資料・新聞や教育機器などを教材・教具として活用する。"),
      text_block.call("ア：②は情報手段を学習活動で「適切に活用」することである。計画的な利用一般を述べる語句とは区別する。 ③は「各種の統計資料や新聞」である。教科書や参考書も教材になり得るが，この列挙の原文ではない。 ④は視聴覚教材や教育機器を含む「教材・教具」であり，内容としての情報・資料に置き換えない。"),
      text_block.call("イ：①は情報手段を活用するための「必要な環境」の整備であり，利用基準の共通化を述べた箇所ではない。 ③は「各種の統計資料や新聞」である。教科書や参考書も教材になり得るが，この列挙の原文ではない。 ④は視聴覚教材や教育機器を含む「教材・教具」であり，内容としての情報・資料に置き換えない。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：①は情報手段を活用するための「必要な環境」の整備であり，利用基準の共通化を述べた箇所ではない。 ②は情報手段を学習活動で「適切に活用」することである。計画的な利用一般を述べる語句とは区別する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第3款 1(3)（項番参照直後から末尾まで） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）不登校生徒への配慮\n\nア 不登校生徒については，保護者や関係機関と連携を図り，{{①}}の助言又は援助を得ながら，社会的自立を目指す観点から，個々の生徒の実態に応じた{{②}}を行うものとする。\n\nイ 相当の期間高等学校を欠席し引き続き欠席すると認められる生徒等を対象として，{{③}}が認める特別の教育課程を編成する場合には，生徒の実態に配慮した教育課程を編成するとともに，{{④}}など指導方法や指導体制の工夫改善に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教科指導や学習評価の専門家", "教科・科目等の選択に関する支援", "都道府県教育委員会", "個別学習やグループ別学習"]),
      fill_in_choice.call("イ", ["教科指導や学習評価の専門家", "教科・科目等の選択に関する支援", "文部科学大臣", "補充的な学習や発展的な学習"]),
      fill_in_choice.call("ウ", ["心理や福祉の専門家", "情報の提供その他の必要な支援", "都道府県教育委員会", "補充的な学習や発展的な学習"]),
      fill_in_choice.call("エ", ["心理や福祉の専門家", "情報の提供その他の必要な支援", "文部科学大臣", "個別学習やグループ別学習"], true),
    ],
    explanation_blocks: [
      text_block.call("不登校生徒への支援は社会的自立を目指し，心理・福祉の専門家と連携する。一定の欠席状況にある生徒等への特別の教育課程については，文部科学大臣が認めるものとし，個別学習等の工夫を述べている。"),
      text_block.call("ア：①は「心理や福祉の専門家」の助言・援助である。教科指導や評価の専門家に置き換える規定ではない。 ②は「情報の提供その他の必要な支援」であり，教科選択に関する支援に限定した語句ではない。 ③はこの特別の教育課程を認める「文部科学大臣」である。"),
      text_block.call("イ：①は「心理や福祉の専門家」の助言・援助である。教科指導や評価の専門家に置き換える規定ではない。 ②は「情報の提供その他の必要な支援」であり，教科選択に関する支援に限定した語句ではない。 ④に列挙されるのは「個別学習やグループ別学習」である。補充的・発展的な学習も場面により行えるが，この原文の列挙ではない。"),
      text_block.call("ウ：③はこの特別の教育課程を認める「文部科学大臣」である。 ④に列挙されるのは「個別学習やグループ別学習」である。補充的・発展的な学習も場面により行えるが，この原文の列挙ではない。"),
      text_block.call("エ：全ての空欄が原文と一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第5款 2(3)ア・イ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第4章 各学校において定める目標及び内容 第2節 各学校において定める内容」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "探究課題の解決を通して育成を目指す具体的な資質・能力とは，{{①}}に記された資質・能力を{{②}}具体的に示したものであり，教師の適切な指導の下，生徒が各探究課題の解決に取り組む中で，育成することを目指す資質・能力のことである。\n\nこのように，総合的な探究の時間の内容は，目標を実現するにふさわしい探究課題と，探究課題の解決を通して育成を目指す具体的な資質・能力の二つによって構成される。両者の関係については，目標の実現に向けて，生徒が「{{③}}」を表したものが探究課題であり，各探究課題との関わりを通して，具体的に「{{④}}」を明らかにしたものが具体的な資質・能力という関係になる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["各学校において定める目標", "全ての学習活動に共通して", "どのようなことができるようになるか", "何について学ぶか"]),
      fill_in_choice.call("イ", ["各学校において定める目標", "各探究課題に即して", "何について学ぶか", "どのようなことができるようになるか"], true),
      fill_in_choice.call("ウ", ["学習指導要領に共通に示された目標", "各探究課題に即して", "どのようなことができるようになるか", "何について学ぶか"]),
      fill_in_choice.call("エ", ["学習指導要領に共通に示された目標", "全ての学習活動に共通して", "何について学ぶか", "どのようなことができるようになるか"]),
    ],
    explanation_blocks: [
      text_block.call("各学校の目標に示された資質・能力を，探究課題に即して具体化する。探究課題は「何について学ぶか」，具体的な資質・能力は「どのようなことができるようになるか」という役割をもつ。"),
      text_block.call("ア：②は「各探究課題に即して」具体化することであり，全活動に共通する表現へ置き換えない。 ③は学習対象を示す「何について学ぶか」であり，探究課題の側に対応する。 ④は学習を通して育成する力を示す「どのようなことができるようになるか」であり，具体的な資質・能力の側に対応する。"),
      text_block.call("イ：全ての空欄が原文と一致する。"),
      text_block.call("ウ：①は「各学校において定める目標」である。学習指導要領の共通目標をそのまま指す箇所ではない。 ③は学習対象を示す「何について学ぶか」であり，探究課題の側に対応する。 ④は学習を通して育成する力を示す「どのようなことができるようになるか」であり，具体的な資質・能力の側に対応する。"),
      text_block.call("エ：①は「各学校において定める目標」である。学習指導要領の共通目標をそのまま指す箇所ではない。 ②は「各探究課題に即して」具体化することであり，全活動に共通する表現へ置き換えない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』・第4章第2節（印刷24頁） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=32",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，人間尊重の精神と生命に対する畏敬の念を家庭，学校，その他社会における{{①}}の中に生かし，豊かな心をもち，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛し，{{②}}を図るとともに，平和で民主的な国家及び社会の形成者として，{{③}}を尊び，社会及び国家の発展に努め，他国を尊重し，{{④}}や環境の保全に貢献し未来を拓く主体性のある日本人の育成に資することとなるよう特に留意すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["具体的な生活", "個性豊かな文化の創造", "公共の精神", "国際社会の平和と発展"], true),
      fill_in_choice.call("イ", ["道徳教育の授業", "伝統的な文化の継承", "社会連帯の自覚", "国際社会の平和と発展"]),
      fill_in_choice.call("ウ", ["道徳教育の授業", "伝統的な文化の継承", "公共の精神", "国際競争力の向上"]),
      fill_in_choice.call("エ", ["具体的な生活", "個性豊かな文化の創造", "社会連帯の自覚", "国際競争力の向上"]),
    ],
    explanation_blocks: [
      text_block.call("人間尊重や生命への畏敬を具体的な生活で生かすとともに，文化を尊重するだけでなく個性豊かな文化を創造する。公共の精神と，国際社会の平和・発展への貢献も含めた育成を求めている。"),
      text_block.call("ア：全ての空欄が原文と一致する。"),
      text_block.call("イ：①は家庭・学校・社会における「具体的な生活」であり，道徳教育の授業に場面を限る語句ではない。 ②は「個性豊かな文化の創造」である。前にある伝統・文化の尊重と，創造という役割の違いを押さえる。 ③は「公共の精神」である。「社会連帯の自覚」は第7款2に見られるが，この原文の空欄とは異なる。"),
      text_block.call("ウ：①は家庭・学校・社会における「具体的な生活」であり，道徳教育の授業に場面を限る語句ではない。 ②は「個性豊かな文化の創造」である。前にある伝統・文化の尊重と，創造という役割の違いを押さえる。 ④は「国際社会の平和と発展」である。国際競争力の向上を直接の目標とする語句ではない。"),
      text_block.call("エ：③は「公共の精神」である。「社会連帯の自覚」は第7款2に見られるが，この原文の空欄とは異なる。 ④は「国際社会の平和と発展」である。国際競争力の向上を直接の目標とする語句ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第1款 2(2)第3段落（令和7年度問9で出題実績を確認） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』の「第4章 指導計画の作成と内容の取扱い 第5節 特別活動における評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が自己の活動を振り返り，新たな目標や課題をもてるようにするために，活動の結果だけでなく{{①}}における生徒の努力や意欲などを積極的に認めたり，生徒のよさを{{②}}に評価したりすることが大切である。\n\nそのため，生徒一人一人が，自らの学習状況やキャリア形成を見通したり，振り返ったりできるようにすることができるようなポートフォリオ的な教材などを活用して，自己評価や相互評価するなどの工夫が求められる。\n\nなお，生徒の自己評価や相互評価は{{③}}であり，それをそのまま学習評価とすることは適切ではないが，{{④}}として適切に活用することにより，生徒の学習意欲の向上につなげることができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["活動の過程", "個別的・分析的", "学習評価", "評定を確定するための資料"]),
      fill_in_choice.call("イ", ["活動の結果", "多面的・総合的", "学習評価", "評定を確定するための資料"]),
      fill_in_choice.call("ウ", ["活動の過程", "多面的・総合的", "学習活動", "学習評価の参考資料"], true),
      fill_in_choice.call("エ", ["活動の結果", "個別的・分析的", "学習活動", "学習評価の参考資料"]),
    ],
    explanation_blocks: [
      text_block.call("活動の結果だけでなく過程での努力等を認め，よさを多面的・総合的に評価する。自己評価・相互評価は学習活動であり，教師の学習評価にそのまま置き換えず，評価の参考資料として活用する。"),
      text_block.call("ア：②は生徒のよさを捉える「多面的・総合的」な評価である。「個別的・分析的」はこの箇所の原語ではない。 ③は生徒の自己評価・相互評価を「学習活動」と位置付ける。教師が行う学習評価そのものではない。 ④は「学習評価の参考資料」としての活用である。自己評価等をそのまま評定確定の資料とするよう述べた規定ではない。"),
      text_block.call("イ：①は結果に加えて見る「活動の過程」である。同じ結果の語を繰り返すのではない。 ③は生徒の自己評価・相互評価を「学習活動」と位置付ける。教師が行う学習評価そのものではない。 ④は「学習評価の参考資料」としての活用である。自己評価等をそのまま評定確定の資料とするよう述べた規定ではない。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：①は結果に加えて見る「活動の過程」である。同じ結果の語を繰り返すのではない。 ②は生徒のよさを捉える「多面的・総合的」な評価である。「個別的・分析的」はこの箇所の原語ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 特別活動編』・第4章第5節（印刷127頁） | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=135",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{②}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒指導では、未経験の課題性の高い対応を迫られることがあります。自分の不安や困り感を同僚に開示できない、素直に助けてほしいといえない、努力しているが解決の糸口がみつからない、自己の実践に肯定的評価がなされない等により、強い不安感、焦燥感、閉塞感、孤立感を抱き、心理的ストレスの高い状態が継続することがあります。この状態が、常態化するとバーンアウト（燃え尽き症候群）のリスクが高まります。\n\nそれに対して、受容的・支持的・相互扶助的な{{①}}がある職場であれば、バーンアウトの軽減効果が期待されます。また、自分の心理状態を振り返る、{{②}}も重要です。不安や苦しみを自覚したときに、一人で抱え込まず、SCも含めて身近な教職員に相談できる職場の雰囲気や体制の整備が求められます。" },
      { type: "text", text: "注：SCはスクールカウンセラーを表す。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["専門性", "セルフ・モニタリング"]),
      fill_in_choice.call("イ", ["同僚性", "セルフ・コントロール"]),
      fill_in_choice.call("ウ", ["専門性", "セルフ・コントロール"]),
      fill_in_choice.call("エ", ["同僚性", "セルフ・モニタリング"], true),
    ],
    explanation_blocks: [
      text_block.call("エ：正しい。受容的・支持的・相互扶助的な同僚性は、教職員が互いに支え合える職場の関係を指す。また、自分の心理状態を振り返って把握することをセルフ・モニタリングと表現している。"),
      text_block.call("ア：②は正しいが、①が誤り。原文が述べているのは、各教職員の専門性そのものではなく、支え合いを可能にする同僚性である。"),
      text_block.call("イ：①は正しいが、②が誤り。セルフ・コントロールは自分の行動等を制御することに関わる語であり、この箇所でいう心理状態の振り返り・把握を表すセルフ・モニタリングとは異なる。"),
      text_block.call("ウ：①・②が誤り。職場の相互扶助的な関係は同僚性、自分の心理状態を振り返ることはセルフ・モニタリングである。専門性の向上や自制だけに置き換えないことが重要である。"),
    ],
    source_text: "『生徒指導提要』第1章 1.4.1 教職員集団の同僚性（2）教職員のメンタルヘルスの維持とセルフ・モニタリング（29〜30頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=32\n徳島大学総合科学部「心と身体の『見える化』が、未来を拓く」（セルフ・モニタリングとセルフ・コントロールの説明、誤答解説の補助資料） | https://www.ias.tokushima-u.ac.jp/make-your-move-05/",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "text", text: "肢体不自由，特に脳性まひのある生徒の状態の把握と教育的対応に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "話すための筋の調節が難しく，発音が不明瞭な場合には，言葉の意味を理解する能力も同じ程度に損なわれていると捉える。文字盤等を用いる場合にも，発音の明瞭さを言語理解の水準の目安として，表現する内容を設定する。"),
      text_choice.call("イ", "脳性まひは脳の非進行性の病変に由来するため，それに伴う運動や姿勢の状態も，成長によって変わらないと捉える。学習用具や座位の調整は，初めに把握した運動や姿勢の状態を基準として検討する。"),
      text_choice.call("ウ", "脳性まひには，動作の困難に加えて，形や位置関係を捉える視知覚の困難が伴う場合がある。線分の長さや角度，図形の見比べ，文字の読み書きなどの状態を把握し，運動や姿勢の状態と区別して教育的ニーズを整理する。", true),
      text_choice.call("エ", "視知覚の障害とは，見た情報に合わせて手指を正確に動かす力の障害をいう。図形や文字の形を捉えることが難しい場合には，その状態を，筆記や用具操作における手指の動きの正確さの評価として位置付ける。"),
    ],
    explanation_blocks: [
      text_block.call("ア：発音の明瞭さと言語理解を同じ水準とする点が誤り。構音の困難があっても言葉の理解は損なわれていない場合があり，文字盤等によって理解や意思を表せるようにする。"),
      text_block.call("イ：非進行性の病変と，運動・姿勢の状態が変化しないことを混同している。状態は発育・発達に伴って変化し得るため，継続して把握する。"),
      text_block.call("ウ：適切。視知覚の困難では長さや角度の比較，図形の見比べなどが難しくなる場合があり，手指の操作や姿勢の困難と区別して把握する。"),
      text_block.call("エ：視知覚と，手指の運動・目と手の協応を混同している。形や関係を捉える力と，手指を正確に動かす力は同じではない。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅳ「肢体不自由」3(3)①，②ア(イ)・(ウ)（164・166〜167頁） | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_08.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "ピアジェの道徳判断の発達に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。なお，責任判断の例では，Aは手伝い中の不注意でコップを5個割り，Bは腹を立ててコップを壊そうとし，1個割ったものとする。" },
    ],
    choices: [
      text_choice.call("ア", "他律的な道徳では，規則を大人などの権威によって定められたものとして捉える。また，行為の結果よりも意図を重視するため，この例では，故意に割ったBの責任をAより重く判断する。"),
      text_choice.call("イ", "自律的な道徳では，規則を当事者の合意によって変更できるものとして捉える。また，行為の意図や動機を考慮するため，この例では，故意に割ったBの責任をAより重く判断する。", true),
      text_choice.call("ウ", "他律的な道徳では，行為が生んだ結果の大きさを重視するため，この例では，多く割ったAの責任をBより重く判断する。また，規則を当事者の合意によって変更できるものとして捉える。"),
      text_choice.call("エ", "自律的な道徳では，行為の意図や動機を考慮するため，この例では，故意に割ったBの責任をAより重く判断する。また，大人などの権威によって定められた規則を変更できないものとして捉える。"),
    ],
    explanation_blocks: [
      text_block.call("ア：規則観は他律的な道徳に対応するが，意図を重視する責任判断は自律的な道徳に対応する。他律的な判断では結果の大きいAを重く判断する。"),
      text_block.call("イ：適切。自律的な道徳では合意による規則の変更と，意図・動機を考慮する主観的責任判断が特徴となる。"),
      text_block.call("ウ：結果の大きさを重視する責任判断は他律的な道徳に対応するが，合意による規則の変更は自律的な道徳に対応する。"),
      text_block.call("エ：意図を考慮する責任判断は適切だが，権威の規則を変更できないものとする規則観は他律的な道徳に対応する。"),
    ],
    source_text: "杉本任士「児童期における社会性の発達と規範意識の形成」『日本大学大学院総合社会情報研究科紀要』第16号，表6「ピアジェの道徳的判断の研究」（173〜174頁） | https://gssc.dld.nihon-u.ac.jp/wp-content/uploads/journal/pdf16/16-167-176-Sugimoto.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "診断的評価，形成的評価及び総括的評価に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "診断的評価は，指導に先立ち，学習に必要な知識や能力などの準備状態を把握するために行われる。総括的評価は，学習途中のつまずきを明らかにし，その後の指導や学習の改善に生かすことを基本的な役割とする。"),
      text_choice.call("イ", "形成的評価は，学習の途中で目標の達成状況を確かめるために行われる。ブルームの完全習得学習では，形成的テストを，一定期間の学習成果を総合的に判定して記録することを主要な目的とする評価として位置付ける。"),
      text_choice.call("ウ", "総括的評価は，一定期間の学習成果を総合的に把握するために行われる。形成的評価との区別は，テストの項目数の多少や，記述式か選択式かという出題形式の違いに基づく。"),
      text_choice.call("エ", "診断的評価は，指導に先立ち学習者の準備状態を把握して計画に生かす。形成的評価は，学習途中の到達状況を確かめて指導や学習の改善に生かし，総括的評価は，一定期間の学習成果を総合的に把握するために行われる。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：診断的評価は適切だが，後半は形成的評価の役割。総括的評価は一定期間の学習成果を総合的に把握するために行う。"),
      text_block.call("イ：形成的評価の時期は適切だが，完全習得学習の形成的テストの目的が誤り。未達成の目標を明らかにし，結果に応じた補充学習や指導につなげるために用いる。"),
      text_block.call("ウ：総括的評価は適切だが，区別の基準が誤り。形成的・総括的は評価の役割についての区別であり，問題数や出題形式の違いではない。"),
      text_block.call("エ：適切。準備状態の把握，学習過程の改善，期間終了後の成果の総括という三つの機能を正しく対応させている。"),
    ],
    source_text: "日本英語検定協会『英語情報Web』池田周「『自分の学びを評価できる』力の育成」〈教育における「評価」〉 | https://eigojoho.eiken.or.jp/education/1411/\n熊本大学公開科目「基盤的教育論」〈完全習得学習と形成的テスト〉 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/2Block/03/1_text.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅱ部 各論 3 新時代に対応した高等学校教育等の在り方について」に示された定時制・通信制課程に関する記述である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "通信教育の質保証に向けて，通信教育実施計画の作成と教育活動等の状況に関する情報公開の義務化，面接指導等実施施設の教育環境の基準の明確化を挙げている。また，面接指導は少人数を基幹とすることを明確にする。", true),
      text_choice.call("イ", "多様な生徒の学習ニーズに対応するため，ICTを活用した指導・評価方法を検討し，専門スタッフを充実させる。また，担当教科・科目の教師によらない学習支援も，当該教科・科目の面接指導の時間数に算入する。"),
      text_choice.call("ウ", "生徒の実態や学習ニーズに応じ，家庭・地域や企業，ハローワーク等との連携を促進する。また，特別活動は，学校の年間指導計画に代えて生徒自身の個別の活動計画に位置付け，多様な進路希望に対応する。"),
      text_choice.call("エ", "生徒の学習ニーズを踏まえ，各学校の特色に応じた学校教育活動のPDCAサイクルを確立する。また，通信教育では，年間の面接指導及び試験を終えた後に，年間の添削指導を完了させるよう計画する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。通信教育実施計画，施設の環境基準，少人数を基幹とする面接指導，情報公開の四つを，質保証の対応方策として挙げている。2021年の答申に示された方策を問うもので，現行法令の施行状況を問うものではない。"),
      text_block.call("イ：ICTの活用と専門スタッフの充実は適切。しかし，担当教科・科目の教師によらない指導・学習支援の時間を，当該教科・科目の面接指導に算入することは，脚注67で不適切な事例として挙げられている。"),
      text_block.call("ウ：家庭・地域や企業等との連携は適切。しかし，特別活動を学校の年間指導計画に位置付けていない事例は，脚注67で問題として挙げられている。生徒の個別計画で学校の年間指導計画を代替することはできない。"),
      text_block.call("エ：学校教育活動のPDCAサイクルの確立は適切。しかし，年間の添削指導を終えていない段階で，年間の面接指導及び試験を全て実施する取扱いは，脚注67で不適切な事例として挙げられている。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅱ部3(3)①・②，本文55〜56頁・脚注67（PDF60〜61頁） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=60",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第2 情報Ⅱ 3 内容の取扱い」に示された内容に基づく記述である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「情報と情報技術を活用した問題発見・解決の探究」については，この科目の{{①}}として位置付け，生徒の興味・関心や学校の実態に応じて，コンピュータや情報システムの基本的な仕組みと活用，コミュニケーションのための情報技術の活用，データを活用するための情報技術の活用，情報社会と情報技術の中から{{②}}の項目に関わる課題を設定して問題の発見・解決に取り組ませるものとする。なお，学習上の必要があり，かつ効果的と認められる場合は，指導の時期を{{③}}することもできるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["導入", "一つ又は複数", "集約"]),
      fill_in_choice.call("イ", ["まとめ", "一つ又は複数", "分割"], true),
      fill_in_choice.call("ウ", ["まとめ", "全て", "集約"]),
      fill_in_choice.call("エ", ["導入", "全て", "分割"]),
    ],
    explanation_blocks: [
      text_block.call("この探究は科目の「まとめ」として位置付け，列挙された領域の「一つ又は複数」に関わる課題を設定する。学習上必要で効果的な場合には指導時期を「分割」できる。アは①・③，ウは②・③，エは①・②が異なる。全ての領域を一つの課題に盛り込む規定ではなく，学校・生徒の実態に応じて領域を選べる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第2章第10節 情報Ⅱ 3(5)，参照先2(5)（194頁／PDF196頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=196",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第11 メディアとサービス 3 内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1） 内容を取り扱う際には，次の事項に配慮するものとする。\n\nア 実習を効果的に取り入れ，メディアを利用してコンテンツを提供する{{①}}について考察するよう留意して指導すること。\n\nイ 生徒や地域の実態，学科の特色等に応じて，適切な{{②}}及びコンテンツ管理のための適切な{{③}}を選択すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["サービスの全体像", "コンテンツ開発環境", "システムや運用サービス"], true),
      fill_in_choice.call("イ", ["情報システムの要求仕様", "コンテンツ開発環境", "ファイル形式や圧縮方式"]),
      fill_in_choice.call("ウ", ["サービスの全体像", "プログラミング言語", "ファイル形式や圧縮方式"]),
      fill_in_choice.call("エ", ["情報システムの要求仕様", "プログラミング言語", "システムや運用サービス"]),
    ],
    explanation_blocks: [
      text_block.call("コンテンツ提供を「サービスの全体像」として捉え，制作のための「コンテンツ開発環境」と管理のための「システムや運用サービス」を実態に応じて選ぶ。イは①・③，ウは②・③，エは①・②が異なる。要求仕様やファイル形式の選定に置き換えると，サービス全体・開発環境・管理運用という対応からずれる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第3章第7節 メディアとサービス 3(1)ア・イ（419頁／PDF421頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=421",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "次のA〜Cは，『高等学校学習指導要領（平成30年告示）解説 情報編』の「第1部 各学科に共通する教科『情報』 第2章 共通教科情報科の各科目 第2節 情報Ⅱ 2 内容とその取扱い」の「情報とデータサイエンス」に示された内容に関する記述である。正しいものの個数を，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "A 目的に応じて適切なデータを収集し，整理し，整形する学習では，測定しようとするもの自体の状態や性質を交絡因子として扱い，データの入手元の違いによる信頼性なども含めて，収集したデータの特性について判断する力を養う。" },
      { type: "text", text: "B データを収集する際に生じる偏りのうち，対象となるデータを選択する際に生じる偏りを選択バイアス，データを測定する際に生じる偏りを情報バイアスとして扱う。" },
      { type: "text", text: "C バイアスを考慮する際には，データの収集が適切かに加え，実際の値より低い値になる過少申告や，実際の値より高い値になる過剰反応などを誘導するものではないかを考慮し，データの内容についての信頼性や信憑性を検討する。" },
    ],
    choices: [
      text_choice.call("ア", "3個"),
      text_choice.call("イ", "2個", true),
      text_choice.call("ウ", "1個"),
      text_choice.call("エ", "0個"),
    ],
    explanation_blocks: [
      text_block.call("A：誤り。交絡因子を測定対象そのものの状態や性質としている点が異なる。原典は「測定しようとするもの以外で結果に影響を与える」ものと説明している。入手元による信頼性なども含めて判断するという後半は適切である。"),
      text_block.call("B：正しい。対象を選択する際の偏りが選択バイアス，測定する際の偏りが情報バイアスである。"),
      text_block.call("C：正しい。原典は収集の適切さ，過少申告・過剰反応などを誘導する可能性を，信頼性や信憑性の検討に必要な要素としている。"),
      text_block.call("アはAも正しいと数える点，ウはB・Cのどちらかを誤りと数える点，エはB・Cまで誤りと数える点が異なる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』・第1部 情報Ⅱ（3）情報とデータサイエンス イ（ア）及び続くバイアスの説明（50頁／PDF58頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=58",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "次のプログラムを実行したとき，09行で表示される値として正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "def f(x) は関数 f の定義であり，f(y) を実行すると，その時点の y の値を引数 x として02行から処理を行う。関数内の x と s は呼び出しごとに独立して扱い，return s は s の値を呼び出した側へ返す。range(0, 3) は0，1，2，range(0, 2) は0，1を順に取り出す。= は代入を表し，行頭の字下げは処理の範囲を表す。" },
      { type: "code", code: "01 def f(x):\n02     s = 1\n03     for i in range(0, 3):\n04         s = s + x\n05     return s\n06 y = 2\n07 for k in range(0, 2):\n08     y = f(y)\n09 print(y)" },
    ],
    choices: [
      text_choice.call("ア", "7"),
      text_choice.call("イ", "18"),
      text_choice.call("ウ", "28"),
      text_choice.call("エ", "22", true),
    ],
    explanation_blocks: [
      text_block.call("関数 f は呼び出すたびに s を1へ初期化し，引数 x を3回加えるため，戻り値は 3 * x + 1 となる。1回目の戻り値7が y に代入され，2回目は7を引数として処理する。"),
      {
        type: "table",
        headers: ["呼び出し", "引数 x", "s の変化", "戻り値・代入後の y"],
        rows: [
          ["1回目", "2", "1 → 3 → 5 → 7", "7"],
          ["2回目", "7", "1 → 8 → 15 → 22", "22"],
        ],
      },
      text_block.call("ア：7は1回目の呼び出し後の値である。外側の繰返しは2回実行される。"),
      text_block.call("イ：18は，仮に02行を s = 0 とした場合の結果である。この変更では y が2 → 6 → 18と変わるが，実際には毎回1から加算する。"),
      text_block.call("ウ：28は，仮に s を最初に一度だけ1へ初期化し，関数の呼び出しをまたいで値を持ち越した場合の結果である。その変更では2回目を7から始めて7を3回加えることになるが，実際には02行が再び実行される。"),
      text_block.call("エ：正しい。2回目の戻り値22が最終的な y である。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習14（3）関数（123～124頁／PDF29～30頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=29",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "ある商品の1日の広告掲載回数 x（回）から，その日の販売個数 y（個）を予測するため，次の回帰式を得た。" },
      { type: "code", code: "販売個数の予測値 ＝ 8 ＋ 3x" },
      { type: "text", text: "二つの日A・Bの広告掲載回数と販売個数の実測値は，次のとおりであった。" },
      {
        type: "table",
        headers: ["日", "広告掲載回数 x（回）", "販売個数の実測値 y（個）"],
        rows: [
          ["A", "2", "16"],
          ["B", "4", "18"],
        ],
      },
      { type: "text", text: "ここでは，残差を「実測値−予測値」とする。残差と予測の大小関係に関する記述として正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "Aの残差は＋2，Bの残差は−2であり，Aでは実測値より大きく予測している。"),
      text_choice.call("イ", "Aの残差は−2，Bの残差は＋2であり，Aでは実測値より大きく予測している。"),
      text_choice.call("ウ", "Aの残差は＋2，Bの残差は−2であり，Aでは実測値より小さく予測している。", true),
      text_choice.call("エ", "Aの残差は−2，Bの残差は＋2であり，Aでは実測値より小さく予測している。"),
    ],
    explanation_blocks: [
      text_block.call("残差は予測からのずれを，符号も含めて表す。指定された定義では，正の残差は実測値が予測値より大きく，負の残差は実測値が予測値より小さいことを意味する。"),
      {
        type: "table",
        headers: ["日", "予測値", "残差", "予測と実測の関係"],
        rows: [
          ["A", "8＋3×2＝14", "16−14＝＋2", "実測値より2個小さく予測"],
          ["B", "8＋3×4＝20", "18−20＝−2", "実測値より2個大きく予測"],
        ],
      },
      text_block.call("ア：残差の値は正しいが，Aの予測値14は実測値16より小さいため，予測の大小関係が逆である。"),
      text_block.call("イ：「予測値−実測値」と逆向きに計算した符号である。また，Aの予測値は実測値より小さい。"),
      text_block.call("ウ：正しい。Aは正の残差で過小予測，Bは負の残差で過大予測となる。"),
      text_block.call("エ：Aで実測値より小さく予測している点は正しいが，残差の符号がA・Bとも逆になっている。"),
    ],
    source_text: "総務省統計局「なるほど統計学園」複数の変数の関係性を見る・回帰分析の考え方 | https://www.stat.go.jp/naruhodo/10_tokucho/hukusu.html\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章・学習22（3）単回帰分析を用いた値の推測・回帰直線と残差（本文186頁／PDF34頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=34",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験25の承認済み問番号は1〜20です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験25 問#{number}は4択・正答1件にしてください"
  end
  if number <= 5 && question.fetch(:category_code) != (number <= 2 ? "education_foundations" : "education_system")
    raise "模擬試験25 問#{number}の分類が不正です"
  end
  expected_category = { 11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology", 15 => "education_system" }[number]
  if expected_category && question.fetch(:category_code) != expected_category
    raise "模擬試験25 問#{number}の分類が不正です"
  end
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  required_cloze = (4..10).cover?(number) || number == 11
  if required_cloze
    expected_labels = if number == 11
      %w[① ②]
    elsif number == 15
      %w[① ② ③]
    else
      %w[① ② ③ ④]
    end
    quote_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = if number >= 6
      prompt_labels == [expected_labels.first, expected_labels.last]
    else
      prompt.fetch(:text).match?(/空欄 ① ～ ④/)
    end
    unless prompt[:type] == "fill_in_text" && quotes.any? && (number <= 5 || quotes.size == 1) &&
        quote_labels == expected_labels && introduction_labels_match &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == expected_labels.size }
      raise "模擬試験25 問#{number}の空欄と選択肢の対応が不正です"
    end
    if [4, 5].include?(number) && !quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) }
      raise "模擬試験25 問#{number}の抜粋枠には条番号を表示してください"
    end
  elsif number >= 16 && choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } }
    labels = blocks.drop(1).flat_map do |block|
      block[:type] == "code" ? block.fetch(:code).scan(/【([①②③])】/).flatten : block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten
    end.uniq
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten.uniq
    quote_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten }.uniq
    valid_body = number == 19 ? blocks.count { |block| block[:type] == "code" } == 1 : quotes.size == 1 && quote_labels == labels
    unless [%w[① ②], %w[① ② ③]].include?(labels) && prompt[:type] == "fill_in_text" &&
        prompt_labels == [labels.first, labels.last] && valid_body &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == labels.size }
      raise "追加問題の空欄と選択肢の対応が不正です"
    end
  elsif !choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && (number == 20 ? %w[text table] : %w[text]).include?(choice.fetch(:content_blocks).first[:type]) }
    raise "模擬試験25 問#{number}の選択肢形式が不正です"
  end
  if [6, 7].include?(number)
    scope = number == 6 ? "第3款" : "第5款"
    unless prompt.fetch(:text).include?("第1章 総則 #{scope}") && question.fetch(:source_text).include?("第1章#{scope}")
      raise "模擬試験25 問#{number}の導入文と出典範囲が一致しません"
    end
  end
  entry = { exam_number: 25, attributes: question, publication_status: "published" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(25, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験25の全20問の正答位置は各記号5件にしてください"
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, section = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, "第1部"] : [3, "第2部"]
  elsif prompt.include?("第2章") && prompt.include?("第10節")
    [0, "第2章第10節"]
  else
    [1, "第3章第7節"]
  end
  unless source.include?(section) && prompt.include?("解説 情報編") == source.include?("解説 情報編") &&
      question.fetch(:major_category_code) == "information" && %w[information_education information_specialized].include?(question.fetch(:category_code))
    raise "情報科の導入文・出典範囲・分類が不正です"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "問16〜18は異なる3範囲を資料順に並べてください"
end
unless questions.last(2).all? { |question| question.fetch(:major_category_code) == "information" && question.fetch(:category_code) == "information_specialized" }
  raise "問19・20の分類が不正です"
end

QuestionSeedSync.import(exam_number: 25, questions: questions, publication_status: "published")

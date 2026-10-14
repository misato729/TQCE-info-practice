text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験31（承認済みの問1〜10。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
# 問3〜5承認正本：document/模試31_問3〜5草案_2026-10-14.md
# 問6〜10承認正本：document/模試31〜35_問6〜10草案_2026-10-14.md
# 文部科学省の公式原典を空欄化した独自の予想問題。原典の連続性・全肢代入は独立fixtureで検証する。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("明治12年の教育令と明治13年の改正教育令による学校教育の制度について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育令は，学制の学区制を廃止し，町村ごと又は複数の町村が連合して公立小学校を設置する方針を採った。また，町村人民の選挙によって学務委員を選ぶとともに，私立小学校の設置には府知事・県令の認可を必要とした。"),
      text_choice.call("イ", "教育令では，学務委員を町村人民の選挙で選ぶこととしたが，改正教育令では，人民が推薦した候補者から府知事・県令が選任する方式へ改めた。また，改正教育令では，小学校の教則を文部卿の定める綱領に基づいて府知事・県令が編成し，文部卿の認可を受けることとした。", true),
      text_choice.call("ウ", "教育令は，地方の実情を踏まえた学校設置や就学を認める一方，小学校の教育課程については文部省が全国共通の教則を直接定めた。各府県はその教則を用いて，町村人民が選挙した学務委員による学校運営を進めることとした。"),
      text_choice.call("エ", "改正教育令は，府知事・県令の監督権を強め，町村が学齢児童を教育するのに足りる小学校を設けることや，就学を督励する規則を整えることを定めた。その一方，学務委員は従来と同じく町村人民の直接選挙で選び，町村内の学校事務を担うものとした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：学校設置の単位と学務委員の選挙は適切だが，私立小学校の設置手続が誤り。教育令では府知事・県令への届出でよいこととされた。認可を必要とする方式へ強化されたのは改正教育令である。"),
      text_block.call("イ：適切。教育令の民選と，改正教育令の推薦・選任という区別に加え，改正教育令における教育課程の基準設定・編成・認可の主体を正しく述べている。"),
      text_block.call("ウ：地方管理と学務委員の選挙は適切だが，教育課程の基準が誤り。教育令は小学校教則の全国的基準を定めていなかった。公立学校の教則については文部卿の認可を求め，私立学校の教則は府知事・県令への届出とした。文部卿の綱領に基づいて府県が教則を編成する仕組みは改正教育令による。"),
      text_block.call("エ：学校設置・就学督励の強化は適切だが，学務委員の選出方法が誤り。改正教育令では人民による推薦と府知事・県令による選任に変更された。"),
    ],
    source_text: "文部科学省『学制百年史』「二 教育令・改正教育令と小学校の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317588.htm\n文部科学省『学制百年史』「五 改正教育令の実施」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03476.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("コメニウスとルソーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "コメニウスは，感覚を通して事物を理解するための絵入り教材として『世界図絵』を著した。ルソーは，子どもの自然な発達を重視し，『エミール』で母親学校・母国語学校・ラテン語学校・大学という学校の四段階を構想した。"),
      text_choice.call("イ", "コメニウスは，事物・絵・言葉を結び付ける教授を重視し，『大教授学』で教育の方法を論じた。その構想は，紳士となる子どもを家庭教師が個別に教育することを主な対象とした。ルソーは，子ども期に固有の活動や発達を尊重した。"),
      text_choice.call("ウ", "コメニウスは，組織的な学校教育と，事物と言語とを結び付ける教授を構想した。その教授では，抽象的な定義を先に説明し，事物の観察をその定義に当てはめる順序を基本とした。ルソーは，子どもの自然な発達に即する教育を論じた。"),
      text_choice.call("エ", "コメニウスは，広く人々に教育を及ぼす学校と教授方法を構想し，感覚を通した事物の理解を重視した。ルソーは，『エミール』で一人の子どもの成長を描き，大人の知識や価値観を性急に教え込むことを改め，子どもの発達に即する教育を論じた。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：四段階の学校を構想したのはコメニウスであり，ルソーの『エミール』の学校制度構想とする点が誤り。『世界図絵』をコメニウスに帰属させる前半は適切。"),
      text_block.call("イ：『大教授学』の対象を紳士の個別家庭教育へ狭めた点が誤り。コメニウスは，広い範囲の人々への学校教育を構想した。紳士の家庭教育を主な対象とする説明は，ロックの『教育論』に対応する。"),
      text_block.call("ウ：直観・感覚を出発点とする教授を，抽象的な定義から事物へ進む教授へ逆転させている。ルソーが自然な発達を尊重するという後半は適切。"),
      text_block.call("エ：適切。コメニウスによる普遍的・組織的な学校教育の構想と，ルソーによる子ども期・発達の尊重を比較している。ルソーの思想全体を家庭教育だけに限定する記述ではない。"),
    ],
    source_text: "筑波大学附属図書館『近代教育学の源流』I「近代教育学の曙―コメニウスとロック―」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap1.html\n同III「教育学と自然・人間・社会―啓蒙主義・ルソー・フランス革命―」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html\n白石崇人『資料から考える教育原理』第8章・92頁，第9章・106〜107頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「教育基本法」（平成18年法律第120号）の教育行政及び教育振興基本計画に関する記述である。正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育に関する施策について，国は，全国的な教育の機会均等と教育水準の維持向上を図るため，総合的に策定し，実施しなければならない。地方公共団体も，その地域における教育の振興を図るため，地域の実情に応じた施策を策定し，実施しなければならない。", true),
      text_choice.call("イ", "政府は，教育の振興に関する基本的な計画を定め，これを国会に報告するとともに公表しなければならない。地方公共団体についても，地域の教育施策の策定・実施と，政府の計画を参酌した地域の基本的な計画の策定が，ともに義務として定められている。"),
      text_choice.call("ウ", "教育の振興に関する施策を総合的かつ計画的に推進するための基本的な計画について，同法は，文部科学大臣が定め，国会に報告するとともに公表することを定めている。地方公共団体は，その計画を参酌し，地域の実情に応じた基本的な計画を定めるよう努めなければならない。"),
      text_choice.call("エ", "教育行政は，国と地方公共団体との適切な役割分担及び相互の協力の下，公正かつ適正に行われなければならない。また，国及び地方公共団体は，教育が円滑かつ継続的に実施されるよう，必要な財政上の措置を講ずるよう努めなければならない。"),
    ],
    explanation_blocks: [
      text_block.call("ア：正しい。第16条第2項は，国による全国的な教育の機会均等と教育水準の維持向上のための施策の策定・実施を，同条第3項は，地方公共団体による地域の実情に応じた施策の策定・実施を，いずれも義務として定めている。"),
      text_block.call("イ：政府の基本的な計画の策定・国会への報告・公表は，第17条第1項と一致する。一方，地方公共団体の基本的な計画の策定は，同条第2項の「定めるよう努めなければならない」という努力義務である。第16条第3項の「施策の策定・実施」の義務と，第17条第2項の「基本的な計画の策定」の努力義務を取り違えている。"),
      text_block.call("ウ：地方公共団体の計画に関する後半は適切だが，第17条第1項の計画の策定主体は「政府」であり，「文部科学大臣」ではない。同法が明記する主体と，教育行政に関わる大臣とを区別する。"),
      text_block.call("エ：教育行政の役割分担・協力・公正さについての前半は，第16条第1項と一致する。しかし，必要な財政上の措置について，同条第4項は「講じなければならない」と定めており，努力義務へ弱めた点が誤りである。"),
    ],
    source_text: "e-Gov法令検索「教育基本法」第16条・第17条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_3-At_16",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第37条第9項・第10項\n\n９　主幹教諭は、校長（副校長を置く小学校にあつては、校長及び副校長）及び教頭を助け、{{①}}{{②}}を整理し、並びに児童の教育をつかさどる。\n\n１０　指導教諭は、児童の教育をつかさどり、並びに{{③}}に対して、{{④}}のために必要な指導及び助言を行う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["命を受けて", "校務", "教諭その他の職員", "学校運営の改善及び充実"]),
      fill_in_choice.call("イ", ["自己の判断により", "校務の一部", "校長及び教頭", "教育指導の改善及び充実"]),
      fill_in_choice.call("ウ", ["命を受けて", "校務の一部", "教諭その他の職員", "教育指導の改善及び充実"], true),
      fill_in_choice.call("エ", ["自己の判断により", "校務", "校長及び教頭", "学校運営の改善及び充実"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「校務の一部」，④は「教育指導の改善及び充実」が正しい。主幹教諭が「校務の一部を整理」する職務と，第37条第7項の教頭が「校務を整理」する職務を区別する。また，指導教諭による指導・助言の目的は，この項では教育指導の改善・充実と定められている。"),
      text_block.call("イ：①は「命を受けて」，③は「教諭その他の職員」が正しい。主幹教諭の職務のあり方を自己の判断によるものへ，指導教諭の指導・助言の対象を校長及び教頭へ取り違えている。教員が日常の職務で自ら判断できないという意味ではない。"),
      text_block.call("ウ：四つとも原文と一致する。主幹教諭は「命を受けて校務の一部を整理」し，指導教諭は「教諭その他の職員」に対して「教育指導の改善及び充実」のために必要な指導・助言を行う。"),
      text_block.call("エ：①〜④の全てが原文と異なる。主幹教諭の校務整理のあり方と範囲，指導教諭の指導・助言の対象と目的を取り違えている。"),
      text_block.call("第37条第9項・第10項は，第62条によって高等学校にも準用される。抜粋は準用元の原文のため，「小学校」「児童」の表記を維持している。"),
    ],
    source_text: "e-Gov法令検索「学校教育法」第37条第7項・第9項・第10項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_37\n同法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第22条第1項・第2項\n\n{{①}}には、研修を受ける機会が与えられなければならない。\n\n２　{{②}}は、{{③}}のない限り、{{④}}の承認を受けて、勤務場所を離れて研修を行うことができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育公務員", "教育公務員", "校務に支障", "本属長"]),
      fill_in_choice.call("イ", ["教育公務員", "教員", "授業に支障", "本属長"], true),
      fill_in_choice.call("ウ", ["教員", "教育公務員", "授業に支障", "任命権者"]),
      fill_in_choice.call("エ", ["教員", "教員", "校務に支障", "任命権者"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は一致する。②は「教員」，③は「授業に支障」が正しい。研修の機会を定める第1項の対象「教育公務員」と，勤務場所を離れて行う研修を定める第2項の対象「教員」を同一にしている。また，条件は授業に支障がないことである。"),
      text_block.call("イ：四つとも原文と一致する。第1項は「教育公務員」への研修機会，第2項は「教員」が授業に支障のない限り「本属長」の承認を受けて勤務場所を離れる研修を定めている。"),
      text_block.call("ウ：③は一致する。①は「教育公務員」，②は「教員」，④は「本属長」が正しい。二つの項の対象を入れ替えている。また，同条第3項の長期研修が「任命権者」の定めるところによることと，第2項の承認者を取り違えている。"),
      text_block.call("エ：②は一致する。①は「教育公務員」，③は「授業に支障」，④は「本属長」が正しい。第1項の対象を教員へ狭め，第2項の条件と承認者を取り違えている。"),
      text_block.call("同法第2条の定義上，「教育公務員」には校長や教育委員会の専門的教育職員なども含まれ，「教員」と同じ範囲ではない。教員も研修機会の対象だが，第1項は教員を含む，より広い教育公務員を対象に定めている。二つの項の対象の違いを読む。"),
    ],
    source_text: "e-Gov法令検索「教育公務員特例法」第22条第1項〜第3項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22\n同法第2条第1項・第2項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_1-At_2",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒のよい点や進歩の状況などを積極的に評価し，{{①}}を実感できるようにすること。また，各教科・科目等の目標の実現に向けた学習状況を把握する観点から，単元や題材など内容や時間のまとまりを見通しながら評価の場面や方法を工夫して，{{②}}を評価し，指導の改善や学習意欲の向上を図り，資質・能力の育成に生かすようにすること。\n（2）創意工夫の中で学習評価の{{③}}が高められるよう，{{④}}な取組を推進するとともに，学年や学校段階を越えて生徒の学習の成果が円滑に接続されるように工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習したことの意義や価値", "学習の過程や成果", "迅速性や効率性", "実践的かつ弾力的"]),
      fill_in_choice.call("イ", ["他の生徒との学習成果の差", "学習の正確さや速さ", "妥当性や信頼性", "組織的かつ計画的"]),
      fill_in_choice.call("ウ", ["学習したことの意義や価値", "学習の過程や成果", "妥当性や信頼性", "組織的かつ計画的"], true),
      fill_in_choice.call("エ", ["他の生徒との学習成果の差", "学習の正確さや速さ", "迅速性や効率性", "実践的かつ弾力的"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は原文と一致する。③は「妥当性や信頼性」、④は「組織的かつ計画的」である。評価の質を確保する取組の規定を、評価の処理速度や運用の柔軟さへ置き換えている。"),
      text_block.call("イ：③④は原文と一致する。①は「学習したことの意義や価値」、②は「学習の過程や成果」である。生徒が学んだことの価値を実感することと、過程・成果を評価することが示されており、他の生徒との差や正確さ・速さという比較軸をこの箇所の規定に置かない。"),
      text_block.call("ウ：全て原文と一致する。学習の意義・価値の実感、過程・成果の評価、評価の妥当性・信頼性、組織的・計画的な取組を組み合わせて捉える。"),
      text_block.call("エ：全て原文と異なる。①②は評価によって生徒に実感させる内容と評価対象、③④は評価の質と取組の在り方を取り違えている。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款2（1）〜（2）、PDF31頁／印刷29頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "career_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が，{{①}}を見通しながら，{{②}}に向けて必要な基盤となる資質・能力を身に付けていくことができるよう，特別活動を要としつつ各教科・科目等の特質に応じて，{{③}}の充実を図ること。その中で，生徒が自己の在り方生き方を考え主体的に進路を選択することができるよう，{{④}}を通じ，組織的かつ計画的な進路指導を行うこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学ぶことと自己の将来とのつながり", "社会的・職業的自立", "キャリア教育", "学校の教育活動全体"], true),
      fill_in_choice.call("イ", ["学ぶことと自己の将来とのつながり", "社会的・職業的自立", "進路学習", "特別活動を中心とする学習活動"]),
      fill_in_choice.call("ウ", ["学校での役割と社会での評価とのつながり", "社会的・職業的成功", "キャリア教育", "学校の教育活動全体"]),
      fill_in_choice.call("エ", ["学校での役割と社会での評価とのつながり", "社会的・職業的成功", "進路学習", "特別活動を中心とする学習活動"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。学ぶことと将来をつなぎ、社会的・職業的自立に向けて資質・能力を育てるキャリア教育と、学校の教育活動全体を通じた進路指導を示している。"),
      text_block.call("イ：①②は原文と一致する。③は「キャリア教育」、④は「学校の教育活動全体」である。「特別活動を要とする」位置付けを、後続の進路指導を行う範囲と混同しない。"),
      text_block.call("ウ：③④は原文と一致する。①は「学ぶことと自己の将来とのつながり」、②は「社会的・職業的自立」である。外部からの評価や職業上の成功ではなく、学びと将来の関係を見通し、自立に必要な基盤を身に付ける規定である。"),
      text_block.call("エ：全て原文と異なる。①②はキャリア教育の見通しと目指す方向、③④は教育の名称と進路指導の実施範囲を取り違えている。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款1（3）全文、PDF32頁／印刷30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第2 各学校において定める目標及び内容」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）各学校において定める目標については，各学校における教育目標を踏まえ，総合的な探究の時間を通して{{①}}を示すこと。\n（2）各学校において定める目標及び内容については，他教科等の目標及び内容との違いに留意しつつ，他教科等で{{①}}との関連を重視すること。\n（3）各学校において定める目標及び内容については，{{②}}を重視すること。\n（4）各学校において定める内容については，{{③}}，探究課題の解決を通して育成を目指す具体的な資質・能力を示すこと。\n（5）{{③}}については，地域や学校の実態，生徒の特性等に応じて，例えば，国際理解，情報，環境，福祉・健康などの現代的な諸課題に対応する横断的・総合的な課題，地域や学校の特色に応じた課題，生徒の興味・関心に基づく課題，{{④}}に関する課題などを踏まえて設定すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["育成を目指す資質・能力", "他教科等との関連", "目標を実現するにふさわしい探究課題", "産業や地域の振興"]),
      fill_in_choice.call("イ", ["習得した知識及び技能", "地域や社会との関わり", "生徒が興味・関心を抱く探究課題", "職業や自己の進路"]),
      fill_in_choice.call("ウ", ["習得した知識及び技能", "他教科等との関連", "生徒が興味・関心を抱く探究課題", "産業や地域の振興"]),
      fill_in_choice.call("エ", ["育成を目指す資質・能力", "地域や社会との関わり", "目標を実現するにふさわしい探究課題", "職業や自己の進路"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は一致する。②は「地域や社会との関わり」，④は「職業や自己の進路」。他教科等との関連は（2）に別に示されている。産業や地域の振興を学習対象にできないという意味ではなく，（5）の課題例における原文の位置付けを問う。"),
      text_block.call("イ：②④は一致する。①は既に習得した内容の列挙ではなく「育成を目指す資質・能力」。③は興味・関心だけで課題を決める語句ではなく「目標を実現するにふさわしい探究課題」であり，（4）（5）の両方に入る。"),
      text_block.call("ウ：全て異なる。学校の目標に示すのは育成を目指す資質・能力であり，地域・社会との関わりを重視する。探究課題には目標にふさわしいことが求められ，課題例の末尾は職業・自己の進路である。"),
      text_block.call("エ：全て一致する。目標が示す資質・能力，内容が示す探究課題と具体的な資質・能力，地域・社会及び自己の進路との関わりを区別した組合せである。"),
    ],
    source_text: "高等学校学習指導要領 第4章 第2の3（1）〜（5），印刷475頁／PDF477頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=477",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学校における道徳教育は，{{①}}に関する教育を{{②}}を通じて行うことによりその充実を図るものとし，各教科に属する科目（以下「各教科・科目」という。），総合的な探究の時間及び特別活動（以下「{{③}}」という。）のそれぞれの特質に応じて，適切な指導を行うこと。\n\n道徳教育は，教育基本法及び学校教育法に定められた教育の根本精神に基づき，生徒が自己探求と自己実現に努め国家・社会の一員としての自覚に基づき行為しうる発達の段階にあることを考慮し，{{①}}を考え，{{④}}の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことを目標とすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間としての在り方生き方", "公民科及び特別活動", "各教科・科目", "集団としての判断"]),
      fill_in_choice.call("イ", ["人間としての在り方生き方", "学校の教育活動全体", "各教科・科目等", "主体的な判断"], true),
      fill_in_choice.call("ウ", ["道徳的諸価値", "学校の教育活動全体", "各教科・科目等", "集団としての判断"]),
      fill_in_choice.call("エ", ["道徳的諸価値", "公民科及び特別活動", "各教科・科目", "主体的な判断"]),
    ],
    explanation_blocks: [
      text_block.call("①は「人間としての在り方生き方」、②は「学校の教育活動全体」、③は「各教科・科目等」、④は「主体的な判断」である。第1段落では道徳教育を行う範囲と各教科・科目等の特質に応じた指導を定め、第2段落では生徒の発達段階を考慮した道徳教育の目標を定めている。同じ①は、教育の内容と生徒が考える対象の双方に対応する。"),
      text_block.call("ア：②③④が誤り。公民科と特別活動は中核的な指導の場面に関わるが、道徳教育を行う範囲全体を表す②ではない。総合的な探究の時間と特別活動まで含める③は「各教科・科目等」であり、目標では「主体的な判断」の下に行動することが示されている。"),
      text_block.call("イ：全て原文と一致する。人間としての在り方生き方に関する教育を学校の教育活動全体で行い、生徒が人間としての在り方生き方を考えて主体的に判断する関係が示されている。"),
      text_block.call("ウ：①④が誤り。「道徳的諸価値」は第7款2で中学校までの学習等を通じて深めた理解として扱う語句である。この抜粋の①は「人間としての在り方生き方」であり、④は「集団としての判断」ではない。"),
      text_block.call("エ：①②③が誤り。④は正しいが、教育の対象、教育を行う範囲及び各教科・科目等をまとめた名称の三つが原文と異なる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款2(2)第1・第2段落（PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21\n同第1章第7款1・2（中核的な指導の場面及び道徳的諸価値、PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第2章 特別活動の目標 第1節 特別活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「社会参画」はよりよいホームルームや学校生活づくりなど，集団や社会に参画し様々な問題を{{①}}しようとするという視点である。社会参画のために必要な資質・能力は，集団の中において，{{②}}な活動を通して，{{③}}する中で育まれるものと考えられる。学校は一つの小さな社会であると同時に，様々な集団から構成される。学校内の様々な集団における活動に主体的に関わることが，地域や社会に対する参画，持続可能な社会の担い手となっていくことにもつながっていく。また，主権者としての自覚の醸成にも結び付くものである。\n\nなお，社会は，様々な集団で構成されていると捉えられることから，ホームルームや学校の集団をよりよくするために参画することと，社会をよりよくするために参画することは，「社会参画」という意味で同じ視点として整理している。\n\n③　「自己実現」\n\n「自己実現」は，一般的には様々な意味で用いられるが，特別活動においては，集団の中で，現在及び将来の自己の生活の課題を発見し，よりよく改善しようとする視点である。自己実現のために必要な資質・能力は，自己の理解を深め，自己のよさや可能性を生かす力，{{④}}を考え設計する力など，集団の中において，個々人が共通して当面する現在及び将来に関わる課題を考察する中で育まれるものと考えられる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["主体的に解決", "自発的，自治的", "個人が集団へ関与", "自己の生き方"], true),
      fill_in_choice.call("イ", ["主体的に解決", "自発的，自治的", "集団が個人を支援", "自己の進路"]),
      fill_in_choice.call("ウ", ["協働的に解決", "自主的，実践的", "個人が集団へ関与", "自己の生き方"]),
      fill_in_choice.call("エ", ["協働的に解決", "自主的，実践的", "集団が個人を支援", "自己の進路"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て一致する。社会参画では，個人が集団へ関与し，自発的・自治的な活動を通じて問題を主体的に解決する。自己実現では，進路選択に限らない自己の生き方の考察・設計を扱う。"),
      text_block.call("イ：①②は一致する。③は「個人が集団へ関与」であり，集団から個人への支援という向きではない。④は「自己の生き方」であり，進路という一領域に置き換えない。"),
      text_block.call("ウ：③④は一致する。①は「主体的に解決」，②は「自発的，自治的」。協働的な解決や自主的・実践的な活動の大切さを否定するものではなく，社会参画の視点について直接示された語句を区別する。"),
      text_block.call("エ：全て異なる。主体的な問題解決，自発的・自治的な活動，個人から集団への関与，自己の生き方の設計という対応に訂正する。"),
    ],
    source_text: "高等学校学習指導要領解説 特別活動編 第2章 第1節1（1）②「社会参画」〜③「自己実現」，印刷12〜13頁／PDF20〜21頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=20",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..10).to_a
  raise "模擬試験31の承認済み問番号は1〜10です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "career_education",
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

QuestionSeedSync.import(exam_number: 31, questions: questions, publication_status: "draft")

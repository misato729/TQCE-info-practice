text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験31（承認済みの問1〜5。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
# 問3〜5承認正本：document/模試31_問3〜5草案_2026-10-14.md
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
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験31の承認済み問番号は1〜5です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
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
    labels = blocks.select { |block| block[:type] == "fill_in_quote" }.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blocks.map { |block| block[:type] } == %w[fill_in_text fill_in_quote] &&
        blocks.first.fetch(:text).include?("空欄 ① ～ ④") &&
        blocks.last.fetch(:text).match?(/\A第\d+条第\d+項/) && labels == %w[① ② ③ ④] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 && choice.fetch(:content_blocks).first.fetch(:cells).all? { |cell| !cell.strip.empty? } }
      raise "問#{number}の条番号・4空欄と選択肢の対応が不正です"
    end
  end
  explanation = question.fetch(:explanation_blocks)
  unless explanation.all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
      %w[ア イ ウ エ].all? { |label| explanation.any? { |block| block.fetch(:text).start_with?("#{label}：") } }
    raise "問#{number}は全ての選択肢の解説を記載してください"
  end
  unless question.fetch(:source_text).lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
    raise "問#{number}の出典は資料名・章節とURLを記載してください"
  end
end

QuestionSeedSync.import(exam_number: 31, questions: questions, publication_status: "draft")

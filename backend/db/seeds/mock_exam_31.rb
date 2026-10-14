text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

# 模擬試験31（承認済みの問1・問2。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
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
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験31の承認済み問番号は1・2です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == "education_foundations"
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  unless question.fetch(:content_blocks).all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
      choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "text" && !choice.fetch(:content_blocks).first.fetch(:text).strip.empty? }
    raise "問#{number}の本文と選択肢は通常の文章ブロックにしてください"
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

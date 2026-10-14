text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

# 模擬試験33（承認済みの問1・問2。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
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
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験33の承認済み問番号は1・2です"
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

QuestionSeedSync.import(exam_number: 33, questions: questions, publication_status: "draft")

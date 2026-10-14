text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

# 模擬試験35（承認済みの問1・問2。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
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
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験35の承認済み問番号は1・2です"
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

QuestionSeedSync.import(exam_number: 35, questions: questions, publication_status: "draft")

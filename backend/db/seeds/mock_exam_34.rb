text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

# 模擬試験34（承認済みの問1・問2。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
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
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験34の承認済み問番号は1・2です"
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

QuestionSeedSync.import(exam_number: 34, questions: questions, publication_status: "draft")

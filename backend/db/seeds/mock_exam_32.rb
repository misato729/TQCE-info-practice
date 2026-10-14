text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

# 模擬試験32（承認済みの問1・問2。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の教育施設における学習内容や学習の進め方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "寺子屋では，師匠が示す手本による手習とともに，往来物が読み書きの教材として使われた。往来物には，手紙文，地理や産業に関わる内容などが盛り込まれていたが，これらは中国の儒学の経書を日本語に翻訳して成立した教材であった。"),
      text_choice.call("イ", "廣瀬淡窓が開いた咸宜園では，入門時の学歴・年齢・身分による区別を設けない三奪法が採られた。門下生の学習意欲を高めるために月旦評も行われたが，これは学力試験の成績ではなく，門下生の生活態度を中心とする人物評価を公表する制度であった。"),
      text_choice.call("ウ", "寺子屋では，庶民の生活に必要な手習や読物の学習が行われた。算用は家庭生活の中やそろばん塾で学ぶことも多かったが，幕末には読み・書き・算を併せて教える寺子屋も増え，近代の小学校に近い学習内容を持つようになった。", true),
      text_choice.call("エ", "緒方洪庵が大坂に開いた適塾では，蘭学や医学が教授され，福澤諭吉などが学んだ。学習を進めるに当たっては，月初めに門下生の成績を評価して公表する月旦評を制度化し，門下生の学力に応じた等級によって競争を促した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：往来物の成立が誤り。往来物は，教材としての目的をもって日本で作られたもので，もともと往復の手紙文を集めた形式から多様な内容へ発展した。中国の儒学の経書の翻訳から成立したものではない。手習・読物の双方の教材として用いられた点は適切。"),
      text_block.call("イ：三奪法の説明は適切だが，月旦評の内容が誤り。月旦評は門下生の学力・学業成績を評価し，成績を公表する制度である。生活態度を中心とする人物評価という説明と取り違えている。"),
      text_block.call("ウ：適切。寺子屋の基本的な学習と，算用を家庭・そろばん塾で学ぶ場合，幕末に読み・書き・算を扱う寺子屋が増えたことを区別している。"),
      text_block.call("エ：適塾の創設者，学問分野及び門人は適切だが，制度の帰属が誤り。月旦評は咸宜園の制度である。適塾でも蘭書の会読や成績に応じた競争が行われたが，それを咸宜園の月旦評と同一の制度として扱うことはできない。"),
    ],
    source_text: "文部科学省『学制百年史』「一 幕末期の教育」―庶民の教育 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html\n日田市咸宜園教育研究センター「咸宜園とは」―咸宜園の教育 | https://www.city.hita.oita.jp/site/kangien/1736.html\n大阪大学適塾記念センター「概要」 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku\n大阪大学適塾記念センター「適塾の教育・塾生」 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku/education",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ペスタロッチの教育思想及び教授方法について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "人間の知的・道徳的・身体的な諸力の調和的発達を重視し，これを頭・心・手に関わる教育として捉えた。また，直観を知的な学習の基礎に置き，数・形・語を，事物を明瞭に認識するための基本的な要素として位置付けた。", true),
      text_choice.call("イ", "人間の諸力を調和的に発達させることを目指し，家庭における親子の関係を重視した。数・形・語は知的・道徳的・身体的な諸力をそれぞれ表すもので，頭・心・手は事物を認識するための教授方法の基本的な要素を表すものとした。"),
      text_choice.call("ウ", "頭・心・手に関わる諸力の調和と，数・形・語を基礎とする教授を重視した。直観とは，新しい表象を既有の表象群へ取り入れて結び付ける心の働きであり，教師はその結合を導くことで子どもの認識を明瞭にすると考えた。"),
      text_choice.call("エ", "貧しい子どもの教育に取り組み，知的・道徳的・身体的な諸力の調和と，生活に根ざす教授を重視した。『人間の教育』では，具体的な事物を直観することを出発点として，知識の基礎となる数・形・語の教育を体系的に論じた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。頭・心・手は人間の諸力の調和的発達に，数・形・語は直観を基礎とする知的な認識・教授に関わる。二つの三要素を同じ分類として扱わない。"),
      text_block.call("イ：二つの三要素の位置付けが逆。知的・道徳的・身体的な諸力の調和が頭・心・手に対応し，数・形・語は事物の認識の基本的な要素として位置付けられる。"),
      text_block.call("ウ：直観を，ヘルバルトの統覚の説明へ置き換えた点が誤り。ペスタロッチの直観は，具体的な事物を直接捉えることに関わる。新しい表象を既有の表象群へ取り入れて結び付ける心の働きは，ヘルバルトが重視した統覚である。"),
      text_block.call("エ：著作の帰属が誤り。『人間の教育』はフレーベルの著作。ペスタロッチが数・形・語の教授を論じた著作には『ゲルトルート児童教授法』がある。"),
    ],
    source_text: "玉川学園『玉川豆知識 No.136 小原國芳がペスタロッチ賞を受賞』1「ペスタロッチ」 | https://www.tamagawa.jp/introduction/tamagawa_trivia/tamagawa_trivia-136.html\n筑波大学附属図書館『近代教育学の源流』IV「教育学と家庭・学校・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n白石崇人『資料から考える教育原理』第10章・120頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n白石陽一「ヘルバルトにおける教授技術の性格―『教える』ことの技術の教授学的検討（その2）―」23頁 | https://www.jstage.jst.go.jp/article/nasemjournal/11/0/11_KJ00006621998/_pdf/-char/ja#page=5",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験32の承認済み問番号は1・2です"
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

QuestionSeedSync.import(exam_number: 32, questions: questions, publication_status: "draft")

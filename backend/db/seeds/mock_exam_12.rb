text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験12（作成中：問1〜2）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の私塾とそこで行われた教育について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "伊藤仁斎が京都に開いた古義堂では，古文辞学の立場から古代中国の言語や制度を研究し，その成果を政治の改革に結び付けることが重視された。"),
      text_choice.call("イ", "緒方洪庵が大坂に開いた適塾では，年齢・学歴・身分による差を設けない三奪法と，毎月の成績を公表する月旦評を用いて，門人同士の競争を促した。"),
      text_choice.call("ウ", "廣瀬淡窓が日田に開いた咸宜園では，年齢・学歴・身分による差を設けない三奪法，学業成績を評価する月旦評及び塾生に役割を分担させる職任の制などが採られた。", true),
      text_choice.call("エ", "本居宣長が松坂に開いた鈴屋では，蘭医学と蘭学を中心に教授し，福澤諭吉や大村益次郎など，幕末から明治期に活躍する人材を輩出した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，古義堂を開いた人物を伊藤仁斎としている点は適切ですが，仁斎が唱えたのは『論語』『孟子』を重視する古義学です。古文辞学を唱えたのは荻生徂徠です。イは，適塾を開いた人物を緒方洪庵としている点は適切ですが，三奪法と月旦評は咸宜園の制度です。適塾では蘭学・医学が教授され，福澤諭吉や大村益次郎らが学びました。ウは，咸宜園の三奪法，月旦評，職任の制を正しく説明しています。エは，鈴屋を開いた人物を本居宣長としている点は適切ですが，宣長は国学者であり，『古事記伝』などを著しました。蘭学・医学及び福澤諭吉，大村益次郎との対応は適塾です。"),
    ],
    source_text: "日田市咸宜園教育研究センター『咸宜園とは』 | https://www.city.hita.oita.jp/site/kangien/1736.html
大阪大学適塾記念センター『適塾』 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku
早稲田大学リポジトリ『伊藤仁斎と荻生徂徠の学問』 | https://waseda.repo.nii.ac.jp/record/3126/files/Tsuchida2_09410009.pdf",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ルソーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育の目的を，社会において有用な紳士の形成に置き，家庭教師による個別教育の下で，健康な身体，徳，知恵及び礼儀を習慣として身に付けさせることを重視した。"),
      text_choice.call("イ", "『エミール』において，子どもを小さな大人として扱わず，その自然な発達に即して教育することを主張した。消極教育は単なる放任ではなく，事物や経験から学べるよう環境を整え，時期尚早な知識や道徳の教え込みを控えるものであった。", true),
      text_choice.call("ウ", "教育を頭・心・手の諸力を調和的に発達させる営みと捉え，家庭的な共同生活と直観教授を基礎として，貧困状態にある子どもの教育に取り組んだ。"),
      text_choice.call("エ", "教育の究極目的を道徳的品性の形成に置き，既有の観念と新しい観念との結合を統覚によって説明するとともに，教授の段階を組織的に構成した。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アはロックの教育思想です。『教育論』では，家庭教師による紳士教育と，健康，徳，知恵，礼儀及び習慣形成が論じられました。イはルソーの教育思想を正しく説明しています。ルソーは『エミール』で子どもの発達に即した教育を説きました。消極教育は放任ではなく，発達に適した環境を用意し，経験を通じて学ばせる考え方です。ウはペスタロッチの教育思想です。頭・心・手の調和，直観教授及び家庭的な共同生活が対応します。エはヘルバルトの教育思想です。道徳的品性，統覚及び段階的な教授理論が対応します。"),
    ],
    source_text: "神戸大学学術成果リポジトリ『ルソーにおける消極教育』 | https://da.lib.kobe-u.ac.jp/da/kernel/81001379/81001379.pdf
国立国会図書館サーチ『エミール』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000002320860
立教大学図書館『ルソーと「エミール」』 | https://library.rikkyo.ac.jp/digitallibrary/jeanjacquesrousseau/contents/con_05.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験12の作成中データには承認済みの問1と問2を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験12 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験12 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 12,
      question_number: attributes.fetch(:question_number),
    )

    content_changed =
      question.persisted? &&
        (
          question.content_blocks != question_attributes.fetch(:content_blocks).as_json ||
          question.explanation_blocks != question_attributes.fetch(:explanation_blocks).as_json ||
          question.source_text != question_attributes.fetch(:source_text)
        )
    question.answer_histories.destroy_all if content_changed

    question.assign_attributes(question_attributes.merge(publication_status: "draft"))
    question.save!

    labels = choices.map { |choice| choice.fetch(:label) }
    question.question_choices.where.not(choice_label: labels).destroy_all
    question.question_choices.update_all(is_correct: false)

    choices.each_with_index do |choice_attributes, index|
      choice = question.question_choices.find_or_initialize_by(choice_label: choice_attributes.fetch(:label))
      choice.assign_attributes(
        content_blocks: choice_attributes.fetch(:content_blocks),
        is_correct: choice_attributes.fetch(:correct),
        display_order: index + 1,
      )
      choice.save!
    end

    unless question.question_choices.count == 4 && question.question_choices.where(is_correct: true).count == 1
      raise "模擬試験12 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

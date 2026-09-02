text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験13（作成中：問1〜2）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("我が国の教員養成制度の変遷について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "明治19年の師範学校令では，尋常師範学校を全国一校の官立学校として東京に置き，高等師範学校を各府県に設置した。前者は尋常師範学校の教員を，後者は小学校教員を養成するものとされた。"),
      text_choice.call("イ", "文部省は「学制」の公布に先立って東京に師範学校を設置した。明治19年の師範学校令では，各府県の尋常師範学校が小学校教員を，全国一校の官立高等師範学校が尋常師範学校の教員を養成した。戦後は大学における教員養成と開放制が採用され，昭和24年に教育職員免許法が公布された。", true),
      text_choice.call("ウ", "明治30年の師範教育令は，尋常師範学校という名称と制度をそのまま維持し，戦前の教員養成制度に実質的な変更を加えなかった。戦後も，旧来の師範学校だけに教員養成を認める閉鎖的な制度が継承された。"),
      text_choice.call("エ", "戦後に採用された開放制は，各都道府県の国立教育学部だけに教員養成を認める制度であり，一般の国立・公立・私立大学が教員養成に参加することは想定されていなかった。また，大学を卒業すれば履修科目にかかわらず免許状が授与された。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アは，尋常師範学校と高等師範学校の設置主体及び養成対象を逆にしています。尋常師範学校は各府県に置かれて小学校教員を養成し，高等師範学校は全国一校の官立学校として東京に置かれ，尋常師範学校の教員などを養成しました。イは，明治初期から戦後への教員養成制度の変化を正しく述べています。ウは，明治30年の師範教育令により尋常師範学校が「師範学校」と改称されたこと，及び戦後に大学での開放制へ転換したことと反します。エは，開放制の対象を国立教育学部に限定している点が誤りです。開放制では，所定の課程を置く国立・公立・私立大学でも教員養成を行えます。また，単なる大学卒業だけで免許状が授与される制度ではありません。"),
    ],
    source_text: "文部科学省『学制百二十年史』第四節『教員及び教員養成』―戦前 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318234.htm
文部科学省『学制百二十年史』第四節『教員及び教員養成』―戦後 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318262.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("モンテッソーリの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "幼児の遊びを人間性の最も純粋な表現と捉えて幼稚園を創設し，恩物を通して，子どもの内面にある統一的な力を自発的に表現させようとした。"),
      text_choice.call("イ", "シカゴ大学に実験学校を開設し，経験の再構成として教育を捉えた。学校を共同生活の場とし，問題解決的な学習を通して民主的な社会の形成に参加する力を育てようとした。"),
      text_choice.call("ウ", "学習者が一定期間の学習課題について契約を結び，教科別実験室を利用しながら個々の進度で学習する仕組みと，異年齢の生活集団を組み合わせた教育方法を考案した。"),
      text_choice.call("エ", "医学的な観察を教育に生かし，1907年に「子どもの家」を開設した。敏感期と自己教育力を重視し，子どもが自ら誤りに気付ける教具を含む「準備された環境」を整え，教師を観察者・援助者として位置付けた。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アはフレーベルの教育思想です。幼稚園の創設，遊び及び恩物が対応します。イはデューイの教育思想とシカゴ大学実験学校についての記述です。ウはパーカーストが考案したドルトン・プランについての記述です。学習課題の契約，教科別実験室，個別進度及び生活集団が主要な構成要素となります。エはモンテッソーリ教育を正しく説明しています。モンテッソーリ教育では，敏感期，自己教育力，準備された環境，自己訂正的な教具及び観察者としての教師が重視されます。"),
    ],
    source_text: "お茶の水女子大学教育・研究成果コレクション『モンテッソーリ教育における感覚教育』 | https://teapot.lib.ocha.ac.jp/record/10434/files/20020601.pdf
国立国会図書館デジタルコレクション『幼児の秘密』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000039-I3042669
広島文教大学附属幼稚園『モンテッソーリ教育』 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験13の作成中データには承認済みの問1と問2を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験13 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験13 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 13,
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
      raise "模擬試験13 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

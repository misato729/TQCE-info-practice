text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験14（作成中：問1〜2）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の①～④は，我が国の女子教育に関する出来事である。年代の古いものから順に配列したものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。\n\n①　文部省は東京に官立の女学校を設置することを布達した。同校は翌年開校し，後に東京女学校と改称された。\n\n②　東京女子師範学校に附属高等女学校が創設され，その後の女子中等教育機関の一つの模範となった。\n\n③　高等女学校令が公布され，女子に高等普通教育を施す中等教育機関として，高等女学校が制度上整備された。\n\n④　旧教育基本法において，男女は互いに敬重し協力しなければならず，教育上の男女共学は認められなければならないと定められた。"),
    ],
    choices: [
      text_choice.call("ア", "① → ② → ③ → ④", true),
      text_choice.call("イ", "① → ③ → ② → ④"),
      text_choice.call("ウ", "② → ① → ③ → ④"),
      text_choice.call("エ", "① → ② → ④ → ③"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。①は1871（明治4）年12月の布達で，官立女学校は1872（明治5）年に開校し，東京女学校と改称されました。②の東京女子師範学校附属高等女学校は1882（明治15）年に創設されました。③の高等女学校令は1899（明治32）年に公布されました。④の旧教育基本法は1947（昭和22）年に制定されました。したがって，①→②→③→④となります。イは，高等女学校令を附属高等女学校の創設より前に置いています。ウは，1882年の出来事を1871年の出来事より前に置いています。エは，1947年の旧教育基本法を1899年の高等女学校令より前に置いています。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第一章第三節『三 明治初期の女子教育』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317595.htm
文部科学省『学制百年史 資料編』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317930.htm
文部科学省『昭和22年教育基本法制定時の条文』第5条 | https://www.mext.go.jp/b_menu/kihon/about/a001.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ケルシェンシュタイナーの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "労作学校の中心を職業で用いる手技能の熟達に置き，知的理解や共同生活における人格形成は，手作業の反復から生じる副次的な成果として位置付けた。"),
      text_choice.call("イ", "学習者が社会的な環境の中で自ら目的を定め，計画を立てて遂行する一連の活動を教授の中心に置くプロジェクト・メソッドを提唱した。"),
      text_choice.call("ウ", "ミュンヘン市の教育行政に携わり，補習学校の改革を進めた。労作を単なる手作業ではなく，身体的活動と精神的活動を結び付けて課題を完成する過程と捉え，公民としての責任感や人格を形成しようとした。", true),
      text_choice.call("エ", "学習課題の契約，教科別実験室及び生活集団を組み合わせ，学級で一斉に同じ内容を進める方式を改めて，学習者が自分の進度で学習する教育方法を構成した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，ケルシェンシュタイナーの労作学校を手技能の訓練に狭めている点が誤りです。労作学校では，課題の遂行を通して身体的活動と精神的活動を統合し，人格や公民性を形成することが重視されました。イはキルパトリックのプロジェクト・メソッドについての記述です。ウは，ケルシェンシュタイナーによるミュンヘンの補習学校改革と，労作学校及び公民教育の関係を正しく説明しています。エはパーカーストのドルトン・プランについての記述です。"),
    ],
    source_text: "国立国会図書館サーチ『労作学校の概念』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000001074366
京都大学学術情報リポジトリ『ケルシェンシュタイナーの公民教育論』 | https://repository.kulib.kyoto-u.ac.jp/dspace/bitstream/2433/266308/1/eda38_100.pdf
J-STAGE『労作学校思想の歴史的検討』 | https://www.jstage.jst.go.jp/article/joej/24/0/24_2021_0002/_pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験14の作成中データには承認済みの問1と問2を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験14 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験14 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 14,
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
      raise "模擬試験14 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

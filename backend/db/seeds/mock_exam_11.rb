text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験11（作成中：問1〜2）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の①～④は，日本の教育史上の教育施設又は制度に関する記述である。年代の古いものから順に配列したものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。\n\n①　文部省は，「学制」の公布に先立って東京に師範学校を設置し，米国人教師スコットの指導により米国の教授法を導入するとともに，小学校の教育課程や教科書の編纂にも当たらせた。\n\n②　石上宅嗣は，自邸の一部に芸亭を設けて経書などの蔵書を置き，好学の徒に閲覧を許した。これは我が国における公開図書館の先駆とされる。\n\n③　岡山藩主池田光政は，庶民教育のために閑谷学校を設けた。同校では，武士だけを対象とした藩校とは異なり，庶民にも学問の機会が開かれた。\n\n④　北条実時は，金沢に和漢の典籍を収集した文庫を設けた。この文庫は，後に金沢文庫と呼ばれるようになった。"),
    ],
    choices: [
      text_choice.call("ア", "② → ③ → ④ → ①"),
      text_choice.call("イ", "④ → ② → ③ → ①"),
      text_choice.call("ウ", "② → ④ → ① → ③"),
      text_choice.call("エ", "② → ④ → ③ → ①", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。②の芸亭は奈良時代後期に設けられました。④の金沢文庫は鎌倉時代の13世紀後半に北条実時によって設けられました。③の閑谷学校は江戸時代前期の1670（寛文10）年に池田光政が設置を命じました。①の師範学校は1872（明治5）年，「学制」の公布に先立って東京に設置されました。したがって，②→④→③→①となります。アは，江戸時代の閑谷学校を鎌倉時代の金沢文庫より前に置いています。イは，鎌倉時代の金沢文庫を奈良時代の芸亭より前に置いています。ウは，明治期の師範学校を江戸時代の閑谷学校より前に置いています。"),
    ],
    source_text: "文部科学省『学制百二十年史』第四節『教員及び教員養成』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318234.htm
国立国会図書館レファレンス協同データベース『芸亭』 | https://crd.ndl.go.jp/reference/entry/index.php?id=1000109396&page=ref_view
神奈川県『神奈川県立金沢文庫』 | https://www.pref.kanagawa.jp/docs/u6p/prs/r1013650.html
岡山県教育委員会『閑谷学校創学350年記念式典・記念講演を開催しました』 | https://www.pref.okayama.jp/site/182/684141.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("コメニウスの教育思想及び教育実践について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『大教授学』において，すべての人に広く教育を施すための学校制度と教授方法を構想した。また，『世界図絵』では，事物・絵・言葉を結び付け，感覚を通して理解させる方法を具体化した。", true),
      text_choice.call("イ", "教育の主要な目的を，社会生活を営む紳士の形成に置き，家庭教師による個別教育を重視した。知識の注入よりも，身体の鍛錬，徳の形成及び習慣づくりを優先した。"),
      text_choice.call("ウ", "『エミール』において，子どもの自然な発達段階に即して教育することを主張し，大人の価値観や知識を早期に教え込むことを避ける消極教育を説いた。"),
      text_choice.call("エ", "幼児期における遊びと自己活動を重視して幼稚園を創設し，球や積み木などからなる恩物を用いて，子どもの内的な力を発達させようとした。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。コメニウスは『大教授学』で普遍的な教育と組織的な教授方法を構想し，『世界図絵』では絵と語を対応させた直観的な学習を具体化しました。イはロックの教育思想です。ロックは『教育論』で，家庭における紳士教育，身体の鍛錬，徳や習慣の形成を重視しました。ウはルソーの教育思想です。『エミール』と消極教育はルソーに対応します。エはフレーベルの教育実践です。幼稚園の創設，遊び，自己活動及び恩物はフレーベルの主要な業績です。"),
    ],
    source_text: "筑波大学附属図書館『近代教育学の源流―コメニウスからフレーベルまで―』 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/genryu.PDF
国立国会図書館『コメニウス「世界図絵」』 | https://ndlsearch.ndl.go.jp/rnavi/children/post_237
国立国会図書館サーチ『コメニウス著作の日本語訳』 | https://ndlsearch.ndl.go.jp/search?cs=bib&from=0&q-author=%2200436418%22&size=20",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験11の作成中データには承認済みの問1と問2を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験11 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験11 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 11,
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
      raise "模擬試験11 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

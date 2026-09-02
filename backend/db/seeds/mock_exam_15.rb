text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験15（作成中：問1〜2）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("1941（昭和16）年に公布された国民学校令について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "国民学校は初等科6年と高等科2年で構成され，「皇国ノ道」に基づく基礎的錬成を目的とした。義務教育年限も8年とされ，国民学校令の施行と同時に全国で8年間の就学義務が適用された。"),
      text_choice.call("イ", "国民学校令は義務教育年限を8年に延長し，その適用を昭和19年度から開始することとした。この計画は戦時下においても予定どおり実施され，終戦時まで全国で初等科と高等科を合わせた8年間の義務教育が行われた。"),
      text_choice.call("ウ", "国民学校は「皇国ノ道ニ則リテ初等普通教育ヲ施シ国民ノ基礎的錬成ヲ為ス」ことを目的とし，初等科6年と高等科2年で構成された。8年間の義務教育は昭和19年度から実施する予定であったが，戦時非常措置によって延期され，実施されないまま終戦を迎えた。", true),
      text_choice.call("エ", "国民学校令による初等科・高等科の構成は，戦後の学校教育法にも引き継がれた。昭和22年度から国民学校高等科を新制中学校の第1・第2学年として位置付け，8年間の義務教育を完成させた。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，国民学校令が制度上義務教育を8年に延長した点は適切ですが，その適用は施行時の昭和16年度ではなく，昭和19年度から予定されていました。イは，昭和19年度から予定されていた8年間の義務教育が実施されたとしている点が誤りです。この計画は戦時非常措置によって延期され，実施されないまま終戦となりました。ウは，国民学校の目的，課程構成及び8年制義務教育が実施に至らなかった経緯を正しく述べています。エは，戦後の学校教育法が国民学校の初等科・高等科を維持したとしている点が誤りです。戦後は小学校6年・中学校3年を含む新しい学校体系が発足しました。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第四章第二節『一 国民学校令の公布』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317696.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("キルパトリックのプロジェクト・メソッドについて述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教師又は教科書から与えられた課題を，あらかじめ定められた手順に従って正確に完成する活動を教授の中心に置き，学習者自身がその目的を受け入れているかどうかを学習成立の条件から切り離した。"),
      text_choice.call("イ", "学習者が一月程度の学習課題について契約を結び，教科別実験室で教師の助言を受けながら，自分の進度で学習を進める個別化された教育方法を構成した。"),
      text_choice.call("ウ", "教授によって多方面の興味を形成し，既有の観念と新しい観念を統覚によって結び付けることを通して，教育の究極目的である道徳的品性の形成を目指した。"),
      text_choice.call("エ", "デューイの影響を受け，社会的な環境の中で学習者が心から目的をもって行う活動を学習の中心に置いた。教師が提案した活動であっても，学習者がその目的を自分のものとして受け入れ，計画・遂行・評価に関与する場合にはプロジェクトとなり得る。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは，外部から課された作業を手順どおり実施すること自体を中心としている点が誤りです。キルパトリックは，学習者が目的を自覚し，主体的に取り組む活動を重視しました。イはパーカーストのドルトン・プランについての記述です。ウはヘルバルトの教育思想です。多方面の興味，統覚及び道徳的品性が対応します。エはプロジェクト・メソッドを正しく説明しています。教師の提案から始まる活動であっても，学習者が目的を主体的に受け入れ，社会的な状況の中で計画・遂行する場合にはプロジェクトとなり得ます。"),
    ],
    source_text: "国立国会図書館サーチ『プロジェクト法』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000001093995
J-STAGE『キルパトリックのプロジェクト・メソッド』 | https://www.jstage.jst.go.jp/article/kyouikutetsugaku1959/1962/7/1962_7_14/_article/-char/ja/
J-STAGE『プロジェクト・メソッドにおける目的的活動』 | https://www.jstage.jst.go.jp/article/nasemjournal/19/0/19_KJ00006622222/_pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "模擬試験15の作成中データには承認済みの問1と問2を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験15 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験15 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 15,
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
      raise "模擬試験15 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

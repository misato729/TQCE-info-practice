text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験10は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("明治期における義務教育制度の整備に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "1886（明治19）年の小学校令によって、尋常小学校の修業年限は直ちに6年へ統一され、公立尋常小学校の授業料は全面的に廃止された。これにより、同年から6年間の無償義務教育が全国で完成した。"),
      text_choice.call("イ", "1900（明治33）年の小学校令は、尋常小学校について3年制と4年制の併存を維持し、公立尋常小学校でも授業料を必ず徴収することとした。義務教育年限の統一と授業料不徴収は、戦後の学校教育法まで実現しなかった。"),
      text_choice.call("ウ", "1900（明治33）年の小学校令では、尋常小学校を4年制に統一して4年間の義務教育制度を確立し、公立小学校では授業料を徴収しないことを原則とした。その後、1907（明治40）年の小学校令改正で尋常小学校を6年制とし、1年の準備期間を経て6年間の義務教育が実施された。", true),
      text_choice.call("エ", "1907（明治40）年の改正は高等小学校を義務教育段階として6年間追加し、尋常小学校4年と合わせて10年間を義務教育とした。同時に中学校・高等女学校・実業学校を廃止し、義務教育修了者全員が同じ学校へ進む単線型制度を完成させた。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは、1886年の小学校令によって6年間の無償義務教育が完成したとしている点が誤りです。イは、1900年の小学校令が3年制を廃止して尋常小学校を4年制に統一し、公立の義務教育では授業料不徴収を原則としたことと反します。ウは、1900年の4年制義務教育の確立と、1907年の改正による6年制への延長を正しく説明しています。6年制は準備期間を経て1908年度から実施されました。エは、6年制となった対象を高等小学校としている点と、義務教育修了後の複線的な進路を廃止したとしている点が誤りです。6年制となったのは尋常小学校であり、その後にも中学校、高等女学校、実業学校、高等小学校など複数の進路が存在しました。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第二章第二節「五 義務教育制度の確立」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317613.htm
文部科学省『学制百年史』第一編第三章第二節「三 義務教育年限の延長」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317618.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("フレイレ（Freire, P.）の教育思想に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "「銀行型教育」は、教師と学習者が対話を通じて現実の問題を共同探究する解放的教育であると評価した。教師が知識を預金するように伝達し、学習者が受動的に蓄積する方式を、批判的意識を形成する最も有効な方法とした。"),
      text_choice.call("イ", "『被抑圧者の教育学』では、教師が知識を一方的に預け入れ、学習者を受動的な対象とする「銀行型教育」を批判した。これに対して、教師と学習者がともに教育過程の主体となり、対話を通じて現実を問題化し、省察と行動を結び付けて世界の変革に関わる問題提起型教育を構想した。", true),
      text_choice.call("ウ", "意識化とは、学習者が社会の矛盾を検討せず、既存の秩序へ適応するための規範を無批判に受け入れる過程であるとした。識字教育では「世界を読む」ことから文字の学習を切り離し、語句を機械的に暗記することを優先した。"),
      text_choice.call("エ", "教育は政治的・社会的価値から完全に中立な技術であると考え、教師と学習者が現実の権力関係や生活上の問題を授業で扱うことに反対した。対話は、教師があらかじめ決めた結論を効率的に受け入れさせるための話法にすぎないと位置付けた。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アは、フレイレが批判した銀行型教育を解放的教育として肯定している点が誤りです。銀行型教育は、教師が知識を預け入れ、学習者を受動的な受け手にすることで、創造性や批判的意識を弱めるものとされました。イは、銀行型教育への批判と、教師と学習者が対話を通じて現実を問題化し、省察と行動を結び付ける問題提起型教育を正しく説明しています。ウは、意識化を既存秩序への無批判な適応としている点が誤りです。意識化は、社会的現実とその矛盾を批判的に認識する過程であり、「世界を読むこと」と「言葉を読むこと」は相互に関連付けられます。エは、教育を価値中立的な技術とし、対話を結論の押し付けの手段としている点が誤りです。フレイレにとって対話は、教育者と学習者が現実を共同で認識し、変革へ向かうための基礎です。"),
    ],
    source_text: "パウロ・フレイレ著、三砂ちづる訳『被抑圧者の教育学 50周年記念版』（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I028908398
兵庫教育大学 原安利『パウロ・フレイレの教育論における「対話」に関する一考察』 | https://hyogo-u.repo.nii.ac.jp/records/2692",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "作成中の模擬試験10には承認済みの問1・問2だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験10 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験10 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 10,
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
      raise "模擬試験10 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

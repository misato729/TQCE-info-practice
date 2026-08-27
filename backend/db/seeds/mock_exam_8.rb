text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験8は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の教育機関に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "藩校は主として藩士の教育機関として設けられ、儒学、特に朱子学を中心とするものが多かった。幕末には国学、洋学、西洋医学、武芸などを加え、庶民の入学を認める学校も現れるなど、総合的な教育機関へ発展した例があった。"),
      text_choice.call("イ", "寺子屋は庶民の日常生活に必要な初歩的・実用的教育を行う私設の施設であり、手習を中心に、往来物などを教材として用いた。幕末には読み・書き・算術を併せて教える寺子屋も増え、学制公布後の小学校設置を支える基盤の一つとなった。"),
      text_choice.call("ウ", "郷校は、民間の学者が自宅に設けた施設だけを指し、幕府、藩主、代官などの保護や監督を受けることはなかった。したがって教育対象、教育内容、経営形態のいずれにおいても私塾と同一であり、藩校や寺子屋との中間的性格をもつものは存在しなかった。", true),
      text_choice.call("エ", "私塾は一般に教師の私宅などで学問や芸能を門弟へ授ける施設で、漢学塾、国学塾、洋学塾、算学塾など多様な形態をとった。幕末には身分上の区別が比較的少ない私塾もあり、近代の私立学校につながる源流の一つとなった。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切でない記述です。アは適切です。藩校は武士教育を基本としましたが、幕末には教育内容を国学、洋学、西洋医学、武芸などへ広げ、教育対象を拡張した例もありました。イも適切です。寺子屋は手習と往来物を中心とする庶民の教育機関で、読み・書き・算術を扱うものも増え、近代の小学校設置を支える社会的基盤の一つとなりました。ウは誤りです。郷校には、藩校の延長として武士を対象とするもの、藩主や代官の保護・監督下で庶民を教育するもの、武士と庶民の双方を受け入れるものなどがあり、すべてを私塾と同一視することはできません。エは適切です。私塾は学問分野も入学者の身分も比較的多様で、近代私立学校の母体となったものもあります。"),
    ],
    source_text: "文部科学省『学制百年史』序章「一 幕末期の教育」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html
文化庁日本遺産ポータル『近世日本の教育遺産群』 | https://japan-heritage.bunka.go.jp/ja/stories/story001/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ヘルバルト（Herbart, J. F.）の教育思想及びヘルバルト派の教授理論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育の目的を知識量の増大と職業的技能の獲得だけに置き、道徳的品性の形成を家庭や宗教の領域に委ねた。したがって、教授が生徒の意志や行為に影響することを避け、価値から中立な知識伝達を理想とした。"),
      text_choice.call("イ", "統覚とは、新しい表象を既有の表象から切り離し、過去の経験を意識から排除して受け入れる過程であるとした。そのため、教師は生徒の既有知識や興味を確認せず、未知の教材を最初から提示するべきだと考えた。"),
      text_choice.call("ウ", "予備・提示・比較・総括・応用という五段階教授法を、ヘルバルト自身が変更不可能な授業手順として完成させた。ヘルバルトが示した明瞭・連合・系統・方法という四つの契機は、この五段階教授法とは無関係であり、後世のヘルバルト派には継承されなかった。"),
      text_choice.call("エ", "教育の中心的な目的を道徳的品性の形成に置き、教授を通じて多面的な興味を育てようとした。新しい表象が既有の表象群と関連付けられて理解される統覚を重視し、明瞭・連合・系統・方法という教授上の契機は、後にツィラーやラインらによって五段階教授法へ展開された。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは、ヘルバルトが教育の目的を道徳性から切り離したとしている点が誤りです。ヘルバルトは道徳的品性の形成を教育の中心に据えました。イは、統覚を既有の表象や経験から切り離す過程としている点が誤りです。統覚は、新しい表象が既有の表象群と結び付いて理解される過程を指します。ウは、ヘルバルト本人と後世のヘルバルト派の理論を取り違えています。ヘルバルト自身が示したのは明瞭・連合・系統・方法という四つの契機であり、予備・提示・比較・総括・応用の五段階教授法は、ツィラーやラインらによる展開です。エは、道徳的品性、多面的興味、統覚、ヘルバルト本人の理論と後世の五段階教授法との関係を正しく説明しています。"),
    ],
    source_text: "ヘルバルト著、三枝孝弘訳『一般教育学』（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000001-I40111100048707
共栄学園短期大学研究紀要第16号『ヘルバルト派の形式的教授段階』 | https://kyoei.repo.nii.ac.jp/record/484/files/KJ00000173172.pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "作成中の模擬試験8には承認済みの問1・問2だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験8 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験8 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 8,
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
      raise "模擬試験8 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

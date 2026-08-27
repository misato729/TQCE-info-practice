text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験7は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("中世の足利学校に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "足利学校の創建時期には奈良時代、平安時代、鎌倉時代などの諸説があるが、歴史上の具体像が明確になるのは、室町時代に関東管領上杉憲実が書籍や学田を寄進し、僧の快元を招いて学校を再興してからである。戦国期にも学問の拠点として栄え、フランシスコ・ザビエルによって海外に紹介された。", true),
      text_choice.call("イ", "足利学校は奈良時代に地方官人を養成する国学として創設されたことが史料上確定しており、律令制の衰退後も一貫して朝廷の直轄学校として運営された。上杉憲実は学校を廃止し、その蔵書を鎌倉の寺院へ移した人物である。"),
      text_choice.call("ウ", "上杉憲実は15世紀に足利学校を再興したが、その際に江戸の林羅山を初代庠主として招き、朱子学以外の易学、兵学、本草学などを禁じた。この方針が後の寛政異学の禁へ直接引き継がれた。"),
      text_choice.call("エ", "ザビエルは足利学校を「坂東の大学」として紹介しただけでなく、自ら学校を創設して初代庠主となり、ラテン語とキリスト教神学を中心とする宣教師養成機関へ改編した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。足利学校の創建時期には諸説がありますが、上杉憲実による再興以後の歴史は比較的明確です。憲実は書籍や学田を寄進し、僧の快元を庠主として学校経営に当たらせました。イは、奈良時代の国学を起源とする説を確定した事実としている点と、上杉憲実を廃止者としている点が誤りです。ウは、江戸時代初期の林羅山を15世紀に招いたとしている時代関係が成り立たず、足利学校で易学、兵学、本草学などが学ばれたこととも反します。エは、ザビエルを創設者・庠主としている点が誤りです。ザビエルは足利学校の評判を海外へ伝えましたが、学校を宣教師養成機関へ改編したわけではありません。"),
    ],
    source_text: "足利市『史跡足利学校』 | https://www.city.ashikaga.tochigi.jp/education/000031/
文化庁日本遺産ポータル『足利学校跡』 | https://japan-heritage.bunka.go.jp/ja/culturalproperties/result/25/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("クインティリアヌス（Quintilian）の教育思想に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『弁論家の教育』では、弁論術の技法だけでなく、幼児期から完成された弁論家に至るまでの教育過程を扱った。理想の弁論家には優れた話術とともに徳性が必要であり、「善き人」であることを弁論家の重要な条件とした。"),
      text_choice.call("イ", "家庭での個人教授と学校教育を比較し、道徳上の危険が家庭にも学校にも存在し得ることを認めた上で、他者の長所や誤りから学び、仲間と競いながら公的生活に慣れることのできる学校教育を支持した。"),
      text_choice.call("ウ", "子供は理性的な説得では十分に規律を身に付けられないため、教師には日常的な鞭打ちと無制限の懲戒権を認めるべきであるとした。恐怖による服従を、将来の自由な市民と弁論家を形成する最も確実な方法と位置付けた。", true),
      text_choice.call("エ", "幼い子供の学習では、能力を超える課題を一度に課すことを避け、遊びや競争を取り入れることを認めた。文字の学習に象牙製の文字を用いるなど、子供が興味をもって扱える教材についても言及した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切でない記述です。アは適切です。クインティリアヌスは教育を弁論技法だけに限定せず、徳性を備えた理想的弁論家の形成として捉えました。イも適切です。学校の危険を無視したのではなく、家庭教育にも同様の問題があり得るとした上で、仲間の長所や誤りから学び、公的生活へ備えられる学校教育の利点を論じています。ウは誤りです。クインティリアヌスは鞭打ちを、自由人にふさわしくない屈辱的な罰であり、恐怖や羞恥によって子供の精神を損なうものとして批判しました。エは適切です。子供の受容可能な量を考慮すること、休息や教育的な遊びを認めること、文字を楽しく扱える教材を用いることなどを述べています。"),
    ],
    source_text: "クインティリアヌス著、森谷宇一ほか訳『弁論家の教育1』第1巻第1章〜第3章（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I000007736785",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "作成中の模擬試験7には承認済みの問1・問2だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験7 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験7 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 7,
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
      raise "模擬試験7 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

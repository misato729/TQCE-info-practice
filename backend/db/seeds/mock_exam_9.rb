text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験9は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("幕末の洋学教育機関に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "蕃書調所は『解体新書』刊行直後の1774（安永3）年に設けられ、昌平坂学問所の一部として儒学経典の校訂だけを行った。外国語を教授する生徒教育は行わず、幕末まで名称や組織も変更されなかった。"),
      text_choice.call("イ", "幕府は1856（安政3）年、洋学の中心機関として蕃書調所を正式に設置し、後に洋書調所、開成所へと改称した。開港後は蘭学だけでなく英学なども発達し、明治維新後には開成学校、大学南校などを経て、東京大学創設の母体の一つとなった。", true),
      text_choice.call("ウ", "長崎海軍伝習所は明治政府が横浜に設けた海軍士官学校であり、イギリス人教官が法学と倫理学だけを教授した。幕府関係者や諸藩の藩士が学ぶことは認められず、航海術、造船、砲術、測量なども教育対象外であった。"),
      text_choice.call("エ", "伊東玄朴らが設けた種痘所は幕府直轄となった後、西洋医学所、医学所へ改称されたが、開成所へ吸収された時点で西洋医学教育を廃止した。そのため、明治政府の大学や東京大学医学系組織には継承されなかった。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アは、蕃書調所の正式な設置を1774年とし、生徒教育や名称変更がなかったとしている点が誤りです。正式な設置は1856年で、その後、洋書調所、開成所へと名称を変更しました。イは、設置年、名称の変遷、蘭学から英学等への広がり、東京大学へつながる系譜を正しく説明しています。ウは、長崎海軍伝習所の設置主体、場所、教官及び教育内容のすべてが誤りです。幕府が長崎に設け、オランダ人から航海術、造船学、砲術、測量術などを学び、幕府関係者のほか諸藩からも参加者がありました。エは、種痘所から西洋医学所、医学所へ発展した系譜を開成所へ吸収されて消滅したとしている点が誤りです。この系譜は明治政府に引き継がれ、東京大学医学系組織の母体の一つとなりました。"),
    ],
    source_text: "文部科学省『学制百年史』序章「一 幕末期の教育―洋学および洋学校の発達」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("パーカースト（Parkhurst, H.）とドルトン・プランに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "パーカーストは、一斉教授と一律の進度を改めるためにラボラトリー・プランを構想し、1920年にマサチューセッツ州ドルトンの学校で実験した。生活と協同の拠点となる「ハウス」、一定期間の学習計画と課題を示す「アサインメント」、教師の助言を受けながら個別又は小集団で学ぶ「ラボラトリー」などを通して、生徒の自由・自立と社会的責任を両立させようとし、1922年に『ドルトン・プランの教育』を刊行した。", true),
      text_choice.call("イ", "ドルトン・プランでは、生徒ごとのアサインメントを設定する一方、その課題を毎日同じ順序・同じ時間に全員で処理することを義務付けた。生徒同士の協力は個人の独立を妨げるとして禁止し、教師による一斉説明をすべての学習の中心に置いた。"),
      text_choice.call("ウ", "パーカーストのいう自由とは、共通の教育内容や履行すべきアサインメントを設けず、生徒がその日の気分だけで活動を選ぶことを意味した。ラボラトリーでは教師の助言を排除し、課題を完了する責任や時間管理を生徒に求めなかった。"),
      text_choice.call("エ", "ドルトン・プランは、学習を完全に孤立した個人間の競争として組織するもので、学校を社会的共同体として捉えることを否定した。ハウス、アサインメント、ラボラトリーはいずれも生徒同士の交流を防ぎ、成績順位だけを高めるための仕組みとして設計された。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。パーカーストは、1920年にマサチューセッツ州ドルトンの学校でラボラトリー・プランを実施し、後にドルトン・プランとして知られる教育方法を発展させました。ドルトン・プランは、ハウス、アサインメント、ラボラトリーを通して、学習者の自由と責任、個人の自立と社会的協同を結び付ける構想です。イは、一律の時間割・進度と一斉説明を中心に据え、協力を禁止するとしている点が誤りです。ウは、自由を無制限な放任としている点と、アサインメントに対する責任、時間管理、教師の援助を否定している点が誤りです。エは、ドルトン・プランが学校を社会的共同体として捉え、自由と協同の両立を重視したことと反します。"),
    ],
    source_text: "パーカースト著、赤井米吉訳、中野光編『ドルトン・プランの教育』（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I000001190245
宮本健市郎『ドルトン・プランの成立過程とヘレン・パーカーストの思想形成』 | https://www.jstage.jst.go.jp/article/kyouikushigaku/42/0/42_KJ00009273870/_article/-char/ja/
長崎大学教育学部『長崎県に於ける新教育運動の展開―ドールトン・プランを主として』 | https://nagasaki-u.repo.nii.ac.jp/record/8289/files/kyoikuKyK00_16_02.pdf
河合塾学園ドルトンスクール『学校紹介』 | https://www.dalton-school.ed.jp/about/",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "作成中の模擬試験9には承認済みの問1・問2だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験9 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験9 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 9,
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
      raise "模擬試験9 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

# 模擬試験6は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("古代日本の官人養成と教育施設に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "律令制下の大学寮は中務省に属し、身分を問わず全国の庶民を官人として養成する中央教育機関であった。一方、国学は都に置かれ、皇族・上級貴族の子弟だけを対象として大学寮への進学準備を行った。"),
      text_choice.call("イ", "平安時代の大学別曹は、衰退した国学に代えて各国に設置された国営の地方学校であり、藤原氏の学館院、橘氏の勧学院などが代表例である。入学者は氏族との関係を問われず、大学寮とは独立した教育課程で学んだ。"),
      text_choice.call("ウ", "空海が設けた綜芸種智院は、大学寮の附属施設として官人候補者に儒学だけを教授した学校であり、入学は貴族の子弟に限られ、僧侶や庶民が学ぶことは認められていなかった。"),
      text_choice.call("エ", "律令制下では、中央に式部省管轄の大学寮が置かれて主として貴族・官人の子弟を教育し、地方には国ごとに国学が置かれて郡司の子弟などを教育した。平安時代には有力氏族が一族の子弟を支援する大学別曹を設け、藤原氏の勧学院、橘氏の学館院などが成立した。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは、大学寮を中務省管轄とし、国学を都に置かれた施設としている点が誤りです。大学寮は式部省の管轄で、国学は地方の各国に置かれました。イは、大学別曹を国営の地方学校としている点に加え、氏族と施設の対応を逆にしている点が誤りです。大学別曹は、大学寮で学ぶ一族の子弟を寄宿・経済面などから支援するため、有力氏族が設けた施設で、藤原氏の勧学院、橘氏の学館院などが知られています。ウは、綜芸種智院を大学寮の附属施設及び貴族子弟だけを対象とする儒学専門校としている点が誤りです。綜芸種智院は空海が設けた私的な教育施設で、僧俗を問わず庶民にも学問を開こうとしました。エは、大学寮、国学、大学別曹の性格と具体例を正しく組み合わせています。"),
    ],
    source_text: "拓殖大学論集『日本古代における大学・国学教育と釈奠』 | https://takushoku-u.repo.nii.ac.jp/record/214/files/%E6%97%A5%E6%9C%AC%E5%8F%A4%E4%BB%A3%E3%81%AB%E3%81%8A%E3%81%91%E3%82%8B%E5%A4%A7%E5%AD%A6%E3%83%BB%E5%9B%BD%E5%AD%A6%E6%95%99%E8%82%B2%E3%81%A8%E9%87%88%E5%A5%A0.pdf\n名桜大学教員養成講座資料『日本の教育史』 | https://www2.meio-u.ac.jp/ext-center/TTC/files/5-13_4.pdf",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の各文は、教育史上の人物の教育思想や教育実践に関する記述である。プラトンの教育思想及び教育実践についての記述として最も適切なものを、下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "対話を通して相手の意見を引き出して吟味し、自らの無知を自覚させることによって、普遍的な概念の探究へ導こうとした。知識を一方的に授けるのではなく、相手の内にある知を生み出すのを助ける働きを、産婆の働きになぞらえた。"),
      text_choice.call("イ", "ソクラテスの弟子として哲学的探究を発展させ、アカデメイアを創設した。真理の探究に必要な学習として数論、幾何学、天文学、音楽理論などを重視するとともに、哲学的訓練を受けた者を国家の統治者として養成することを構想した。", true),
      text_choice.call("ウ", "すべての人が広く体系的な知識を学ぶことのできる教育を唱え、人の発達段階に応じた学校制度を構想した。また、『世界図絵』を著し、観察や経験を重視して、事物や事象を感覚器官を通して学ばせようとした。"),
      text_choice.call("エ", "子供を固有の発達段階にある存在として捉え、『エミール』において自然の歩みに即した教育を論じた。幼少期には徳や真理を直接教え込むのではなく、悪徳や誤った判断から子供を守りながら、経験を通して学ばせる消極教育を重視した。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アはソクラテスの問答法と産婆術についての説明です。ソクラテスは、対話によって相手の考えを吟味し、無知を自覚させながら、相手自身が知を生み出すのを援助しようとしました。イはプラトンについての適切な説明です。プラトンはアカデメイアを創設し、真理の探究のために数論、幾何学、天文学、音楽理論などを重視しました。また、哲学的訓練を受けた統治者の養成を教育目的の一つとしました。ウはコメニウスについての説明です。コメニウスは、すべての人を対象とする体系的な教育を構想し、『世界図絵』では感覚を通した学習を重視しました。エはルソーについての説明です。ルソーは『エミール』で子供の自然な発達を尊重し、幼少期には大人の価値観や知識を早急に教え込まない消極教育を論じました。"),
    ],
    source_text: "八戸学院大学短期大学部『教育原理⑥配布資料』Ⅰ『西洋の教育制度』 | https://jc.hachinohe-u.ac.jp/wp-content/uploads/2022/09/d3f727f70b2e4f333b41e75aeb6896c9.pdf\n茨城キリスト教大学『教育史Ⅰ』授業計画『プラトン―哲人王と教育』 | https://www.icc.ac.jp/kyoumu/syllabus/pdf/1301201001.pdf\n広島大学『第57回 ソクラテスメソッド』 | https://www.hiroshima-u.ac.jp/node/56937\n北海道大学 橋本努講義レジュメ『ルソー「エミール」』 | https://www.econ.hokudai.ac.jp/~hasimoto/Resume%20on%20Rousseau%20Emile.htm",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2]
  raise "作成中の模擬試験6には承認済みの問1・問2だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験6 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験6 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 6,
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
      raise "模擬試験6 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

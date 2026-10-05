text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  {
    label: label,
    content_blocks: [{ type: "text", text: text }],
    correct: correct,
  }
end

fill_in_choice = lambda do |label, cells, correct = false|
  {
    label: label,
    content_blocks: [{ type: "fill_in_choice", cells: cells }],
    correct: correct,
  }
end

# 模擬試験20（承認済みの問1〜5。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("大正新教育に関わる人物の著作と教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "木下竹次は，学習を生活と結び付け，他律的な教育から自律的な学習への転換を重視した。教師自身の成長と子どもの学習を関連付け，子どもの学習によって教師も学ぶという考え方を，著書『実際的教育学』にまとめた。"),
      text_choice.call("イ", "手塚岸衛は，自由教育を唱え，自学，自治，自育を重視した。児童が学ぶ目的を自ら定めることや，学校生活の中で自治に取り組むことを重んじ，自由を自覚と自律に結び付ける教育の考え方を，著書『学習原論』にまとめた。"),
      text_choice.call("ウ", "小原國芳は，八大教育主張の講演会で全人教育を唱え，『全人教育論』でも調和ある人格の形成を論じた。学問，道徳，芸術，宗教，身体，生活に対応する真，善，美，聖，健，富の六つの価値を，人格の中に調和的に形成することを重視した。", true),
      text_choice.call("エ", "澤柳政太郎は，教育の現実を研究する教育学の構築を目指し，教師にも教育者と研究者の役割を求めた。児童の自学自習や自治自律を学びの姿勢として重視し，教育を実証的に研究する考え方を，著書『自由教育真義』にまとめた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：著作の帰属が誤り。木下の自律的学習や「学習即生活」を論じる著作は『学習原論』。『実際的教育学』は澤柳の著作である。"),
      text_block.call("イ：著作の帰属が誤り。手塚の著作は『自由教育真義』。『学習原論』は木下の著作である。自学・自治・自育を重視したことは適切。"),
      text_block.call("ウ：適切。小原は大正10年（1921年）の八大教育主張で全人教育を提唱し，人間文化の六つの価値を調和的に形成することを重視した。"),
      text_block.call("エ：著作の帰属が誤り。澤柳は『実際的教育学』を著し，実際の教育を研究することを重視した。『自由教育真義』は手塚の著作である。"),
    ],
    source_text: "明治図書出版『学習原論』書籍案内 | https://www.meijitosho.co.jp/detail/4-18-056424-6\n千葉市『千葉市史』第2項『附属小学校の自由教育』 | https://adeac.jp/chiba-city/texthtml/d100020/mp200010-100020/ht021940\n玉川学園『全人教育』 | https://www.tamagawa.jp/introduction/history/detail_12629.html\n白石崇人『澤柳政太郎「実際的教育学」の実証主義再考』 | https://www.jstage.jst.go.jp/article/kyoiku/89/2/89_220/_article/-char/ja\n成城学園『建学の精神』 | https://www.seijogakuen.ed.jp/thought/founders-vision/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("西洋の教育思想及び教育実践について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ルソーは『エミール』で，子どもには子ども固有の感じ方や考え方があることを重視した。一人の子どもの成長を家庭教師との関係の中で描き，子どもの自然な発達を尊重する消極教育を論じた。これは，大人の価値観を早期に教え込む教育を問い直すものだった。"),
      text_choice.call("イ", "オーウェンは，紡績工場で働く人々の生活と子どもの教育の改善に取り組み，性格形成学院を設けた。人間の性格形成への環境の影響を重視し，幼児の自発的な活動を育てるため，球や立方体などの教育遊具を体系化した恩物を考案して教育に用いた。", true),
      text_choice.call("ウ", "ペスタロッチは，貧しい子どもたちの教育に尽力し，『隠者の夕暮れ』『リーンハルトとゲルトルート』などを著した。人間がもつ諸能力を調和的に発達させることを重視し，頭・心・手に関わる教育を，日常生活とも結び付けて展開しようとした。"),
      text_choice.call("エ", "モンテッソーリは，医学的な観察を教育へ生かし，子どもの発達に応じた環境と教具を整えた。子どもが自ら活動を選んで取り組むことを重視し，大人には，子どもの自発的な活動と成長を支える人的・物的な環境を用意して援助する役割があると考えた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。ルソーの『エミール』における家庭教育と，子ども期及び自然な発達を重視する考え方を説明している。"),
      text_block.call("イ：恩物を考案した人物が誤り。恩物を体系化したのはフレーベルである。オーウェンが労働者の生活改善，性格形成学院，性格形成への環境の影響を重視したことは適切。"),
      text_block.call("ウ：適切。ペスタロッチの著作，貧しい子どもたちへの教育，諸能力の調和的な発達に対応する。"),
      text_block.call("エ：適切。モンテッソーリ教育は，子どもの自由選択と自発的活動を支える環境を重視する。"),
    ],
    source_text: "長瀬啓子『保育内容五領域と育みたい資質・能力について』134頁 | https://tokaigakuin-u.repo.nii.ac.jp/record/3648/files/20181217.pdf\n筑波大学『近代教育学の源流』III『教育学と自然・人間・社会』 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html\n広島文教大学附属幼稚園『モンテッソーリ教育』 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次の①～④のうち，「教育基本法」（平成18年法律第120号）の条文として正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "quote",
        text: "①　良識ある公民として必要な政治的教養は、教育上尊重されなければならない。\n\n②　すべて職員は、全体の奉仕者として公共の利益のために勤務し、且つ、職務の遂行に当つては、全力を挙げてこれに専念しなければならない。\n\n③　教育は、人格の完成を目指し、平和で民主的な国家及び社会の形成者として必要な資質を備えた心身ともに健康な国民の育成を期して行われなければならない。\n\n④　教育公務員には、研修を受ける機会が与えられなければならない。",
      },
    ],
    choices: [
      text_choice.call("ア", "二つ", true),
      text_choice.call("イ", "一つ"),
      text_choice.call("ウ", "三つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("①：教育基本法第14条第1項の政治教育に関する規定である。"),
      text_block.call("②：地方公務員法第30条の服務の根本基準であり，教育基本法の条文ではない。"),
      text_block.call("③：教育基本法第1条の教育の目的である。"),
      text_block.call("④：教育公務員特例法第22条第1項の規定であり，教育基本法の条文ではない。"),
      text_block.call("したがって，教育基本法の条文は①と③の二つ。イ・ウ・エは個数が一致しない。教育基本法第9条にも教員の研修の充実に関する規定があるが，提示された④そのものの出典は教育公務員特例法である。"),
    ],
    source_text: "教育基本法・第1条、第9条、第14条 | https://laws.e-gov.go.jp/law/418AC0000000120\n地方公務員法・第30条 | https://laws.e-gov.go.jp/law/325AC0000000261\n教育公務員特例法・第22条第1項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第9条\n\n次の各号のいずれかに該当する者は、{{①}}となることができない。\n\n一　{{②}}以上の刑に処せられた者\n\n二　教育職員免許法第十条第一項第二号又は第三号に該当することにより免許状がその効力を失い、当該失効の日から{{③}}を経過しない者\n\n三　教育職員免許法第十一条第一項から第三項までの規定により{{④}}の処分を受け、{{③}}を経過しない者\n\n四　日本国憲法施行の日以後において、日本国憲法又はその下に成立した政府を暴力で破壊することを主張する政党その他の団体を結成し、又はこれに加入した者",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["校長又は教員", "罰金", "五年", "免許状取上げ"]),
      fill_in_choice.call("イ", ["校長又は教諭", "拘禁刑", "三年", "懲戒免職"]),
      fill_in_choice.call("ウ", ["校長又は教諭", "罰金", "五年", "懲戒免職"]),
      fill_in_choice.call("エ", ["校長又は教員", "拘禁刑", "三年", "免許状取上げ"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「拘禁刑」，③は「三年」。罰金以上の刑，五年という規定ではない。"),
      text_block.call("イ：①は「校長又は教員」，④は「免許状取上げ」。「教員」を「教諭」に限定せず，懲戒処分と免許状に関する処分を区別する。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも現行条文と一致する。第2号・第3号については，それぞれ条文に示された場合に，三年を経過しない者が対象となる。"),
    ],
    source_text: "学校教育法・第9条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第24条\n\n公立の小学校等の中堅教諭等（主務教諭（養護又は栄養の指導及び管理をつかさどる主務教諭を除く。）、主務保育教諭及び教諭等のうち、臨時的に任用された者その他の政令で定める者以外のものであつて、公立の小学校等における教育に関し相当の経験を有する者として文部科学省令で定めるものをいう。以下この項において同じ。）の{{①}}は、当該中堅教諭等に対して、個々の能力、適性等に応じて、教育活動その他の学校運営の円滑かつ効果的な実施において中核的な役割を果たすことが期待される中堅教諭等としての職務を遂行する上で必要とされる資質の向上を図るために必要な事項に関する研修（次項において「中堅教諭等資質向上研修」という。）を実施しなければならない。\n\n2　{{②}}は、中堅教諭等資質向上研修を実施するに当たり、中堅教諭等資質向上研修を受ける者の能力、適性等について{{③}}を行い、その結果に基づき、当該者ごとに中堅教諭等資質向上研修に関する{{④}}を作成しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "指導助言者", "認定", "指標"]),
      fill_in_choice.call("イ", ["研修実施者", "指導助言者", "評価", "計画書"], true),
      fill_in_choice.call("ウ", ["指導助言者", "研修実施者", "評価", "計画書"]),
      fill_in_choice.call("エ", ["指導助言者", "研修実施者", "認定", "指標"]),
    ],
    explanation_blocks: [
      text_block.call("ア：③は「評価」，④は「計画書」。受講者の能力・適性等を評価し，その結果に基づく受講者ごとの計画書を作成する。"),
      text_block.call("イ：四つとも原文と一致する。研修実施者が研修を実施し，指導助言者が受講者の評価と計画書の作成を行う。"),
      text_block.call("ウ：①と②の主体が逆になっている。"),
      text_block.call("エ：①〜④の全てが原文と異なる。受講者ごとの計画書と，教員等として向上を図るべき資質に関する指標は同じものではない。"),
    ],
    source_text: "教育公務員特例法・第24条 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験20は承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験20 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験20 問#{number}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験20 問#{number}の出典リンク形式が不正です"
  end

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  next if quotes.empty?

  blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
  unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
    raise "模擬試験20 問#{number}の空欄と選択肢の対応が不正です"
  end
  unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && quotes.first.fetch(:text).match?(/\A第\d+条/)
    raise "模擬試験20 問#{number}は原文穴埋めとし抜粋枠の冒頭に条番号を表示してください"
  end
end

QuestionSeedSync.import(exam_number: 20, questions: questions, publication_status: "draft")

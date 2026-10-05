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

# 模擬試験17（承認済みの問1〜5。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("近代日本における私学の創設と教育理念について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "福澤諭吉は，江戸に蘭学塾を開き，慶応4年に学塾を慶應義塾と名付けた。独立自尊と実学を重視し，実学を，職業に直接結び付く技能や知識の習得と位置付け，その習得によって，社会の先導者として活動できる人物を育てようとした。"),
      text_choice.call("イ", "新島襄は，明治8年に京都で同志社英学校を創設し，その後，大学の設立を目指す運動を進めた。知識を与えることに加えて徳性と品性を高めることを重視し，キリスト教主義を徳育の基本として，良心を手腕に運用する人物を育てようとした。", true),
      text_choice.call("ウ", "津田梅子は，米国留学の経験を生かし，明治33年に女子英学塾を創設した。少人数で一人一人に行き届いた指導を行い，英語教育と幅広い教養を重視した。この学校は，高等女学校令に基づく中等教育機関として，女子の普通教育を行うために設けられた。"),
      text_choice.call("エ", "大隈重信らは，明治15年に東京専門学校を創設し，学問の独立を重視した。創設に関わった小野梓は，国民精神の独立を学問の独立と結び付け，専門科目を英語で講義することを教育の基本に据え，学生が外国の学問を直接学べるようにしようとした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：「実学」を職業に直結する技能・知識と捉えている点が誤り。福澤の実学は，実証的に真理を解明する科学と，その科学的な姿勢を意味する。"),
      text_block.call("イ：適切。明治8年（1875年）の同志社英学校創設と，キリスト教主義に基づく徳育・良心教育という新島の理念を述べている。"),
      text_block.call("ウ：教育段階と制度上の位置付けが誤り。女子英学塾は女子の高等教育を目指す私学であり，高等女学校令に基づく中等教育機関とは区別される。"),
      text_block.call("エ：講義の言語が誤り。小野は専門的な学問を邦語（日本語）で講義することを重視し，同時に英学科で原書を読む力を養おうとした。"),
    ],
    source_text: "慶應義塾・理念と歴史 | https://www.keio.ac.jp/ja/about/philosophy/\n同志社大学キリスト教文化センター・同志社大学とキリスト教主義 | https://christian-center.doshisha.ac.jp/cc/christianism/\n津田塾大学・津田塾の歴史 | https://www.tsuda.ac.jp/aboutus/history/\n津田塾大学・沿革 | https://www.tsuda.ac.jp/aboutus/history/milestone.html\n早稲田大学・小野梓の開校演説 | https://www.waseda.jp/inst/weekly/column/2017/10/17/34860/\n早稲田大学・早稲田大学 誕生の時 | https://www.waseda.jp/inst/weekly/feature/2012/10/18/47451/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ソクラテスの思想と教育方法について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "人間がどのように生きるべきかを重要な問題とし，青年との対話を重ねた。対話では，個々の人がもつ感覚や判断を真理の基準として尊重し，同じ事柄でも人によって正しさが異なることを確かめることで，徳についての理解を深めようとした。"),
      text_choice.call("イ", "人間の生き方を問い，対話を通して相手の主張の根拠を検討した。こうした問答の最終的な目的は，議会や法廷で自分の主張を相手に受け入れさせる技術を身に付けることであり，政治生活で役立つ弁論能力の育成を教育の中心に置いた。"),
      text_choice.call("ウ", "「徳は知である」と考え，知識と道徳的な行為との関係を重視した。この知とは，幅広い事柄について他者より多くの情報を蓄えていることであり，情報の量を増やす学習を通して，善く生きるための徳も高められると捉えた。"),
      text_choice.call("エ", "対話相手の主張を問答によって吟味し，知っているつもりの事柄について無知を自覚させようとした。相手が自ら理解を生み出すのを助ける方法は産婆術と呼ばれ，知徳合一説でいう知も，善く生きることや徳とは何かについての理解に関わる。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：個々人の判断を真理の基準とする相対主義を結び付けた点が誤り。ソクラテスは，個々人の意見を吟味し，徳などの普遍的な意味を探究した。"),
      text_block.call("イ：弁論技術の習得を問答の最終目的とする点が誤り。ソクラテスの問答は，善く生きることや徳の探究に向けられた。"),
      text_block.call("ウ：知徳合一説の「知」を情報量と捉えている点が誤り。善とは何か，どのように善く生きるかに関わる知である。"),
      text_block.call("エ：適切。問答法，無知の自覚，産婆術及び知徳合一を関連付けて述べている。"),
    ],
    source_text: "広島大学・第57回 ソクラテスメソッド | https://www.hiroshima-u.ac.jp/node/56937\n和田正美「ソクラテスの倫理・教育思想―古代ギリシアの倫理思想―」『関西国際大学研究紀要』第13号・240・243・247頁 | https://kuins.repo.nii.ac.jp/record/362/files/KJ00007793679.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第10条 家庭教育」からの抜粋である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第10条\n{{①}}は、子の教育について{{②}}を有するものであって、生活のために必要な習慣を身に付けさせるとともに、{{③}}を育成し、心身の調和のとれた発達を図るよう努めるものとする。\n\n2　国及び地方公共団体は、家庭教育の{{④}}を尊重しつつ、保護者に対する学習の機会及び情報の提供その他の家庭教育を支援するために必要な施策を講ずるよう努めなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["父母その他の保護者", "第一義的責任", "自立心", "自主性"], true),
      fill_in_choice.call("イ", ["父母その他の保護者", "最終的責任", "自立心", "独自性"]),
      fill_in_choice.call("ウ", ["学校及び保護者", "第一義的責任", "社会性", "自主性"]),
      fill_in_choice.call("エ", ["学校及び保護者", "最終的責任", "社会性", "独自性"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。保護者の第一義的責任と，家庭教育の自主性を尊重した行政の支援を規定している。"),
      text_block.call("イ：②は「第一義的責任」，④は「自主性」。"),
      text_block.call("ウ：①は「父母その他の保護者」，③は「自立心」。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
      text_block.call("「社会性」の育成を否定する問題ではなく，この条文で明記された語句を問う問題である。"),
    ],
    source_text: "教育基本法・第10条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
      text_block.call("※第29条は小学校の目的，第21条は義務教育の目標を定めている。"),
      {
        type: "fill_in_quote",
        text: "第30条\n小学校における教育は、前条に規定する目的を実現するために必要な程度において第二十一条各号に掲げる目標を達成するよう行われるものとする。\n\n2　前項の場合においては、生涯にわたり学習する基盤が培われるよう、{{①}}を習得させるとともに、これらを活用して課題を解決するために必要な{{②}}その他の能力をはぐくみ、{{③}}を養うことに、特に意を用いなければならない。\n\n第31条\n小学校においては、前条第一項の規定による目標の達成に資するよう、教育指導を行うに当たり、児童の体験的な学習活動、特にボランティア活動など{{④}}、自然体験活動その他の体験活動の充実に努めるものとする。この場合において、社会教育関係団体その他の関係団体及び関係機関との連携に十分配慮しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["基礎的な知識及び技能", "思考力、判断力、表現力", "学びに向かう力、人間性等", "社会貢献活動"]),
      fill_in_choice.call("イ", ["基本的な知識及び技術", "思考力、判断力、表現力", "学びに向かう力、人間性等", "社会奉仕体験活動"]),
      fill_in_choice.call("ウ", ["基礎的な知識及び技能", "思考力、判断力、表現力", "主体的に学習に取り組む態度", "社会奉仕体験活動"], true),
      fill_in_choice.call("エ", ["基本的な知識及び技術", "思考力、創造力、実践力", "学びに向かう力、人間性等", "社会貢献活動"]),
    ],
    explanation_blocks: [
      text_block.call("ア：③は「主体的に学習に取り組む態度」，④は「社会奉仕体験活動」。「学びに向かう力、人間性等」は学習指導要領の資質・能力の柱だが，この条文の語句ではない。"),
      text_block.call("イ：①は「基礎的な知識及び技能」，③は「主体的に学習に取り組む態度」。"),
      text_block.call("ウ：四つとも原文と一致する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。②で列挙されるのは思考力・判断力・表現力であり，創造力・実践力ではない。"),
      text_block.call("第30条第2項と第31条は，第62条によって高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第21条、第29条、第30条、第31条、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の2\n{{①}}は、公立の小学校等の校長及び教員の{{②}}な資質の向上を図るため、次条第一項に規定する{{③}}の策定に関する指針（以下この条及び次条第一項において「指針」という。）を定めなければならない。\n\n2　指針においては、次に掲げる事項を定めるものとする。\n\n一　公立の小学校等の校長及び教員の資質の向上に関する基本的な事項\n\n二　次条第一項に規定する{{③}}の内容に関する事項\n\n三　その他公立の小学校等の校長及び教員の資質の向上を図るに際し配慮すべき事項\n\n3　{{①}}は、指針を定め、又はこれを変更したときは、遅滞なく、これを{{④}}。\n\n第22条の3\n公立の小学校等の校長及び教員の任命権者は、指針を参酌し、その地域の実情に応じ、当該校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する{{③}}（以下この章において「{{③}}」という。）を定めるものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "体系的かつ効果的", "教員研修計画", "公表するよう努めるものとする"]),
      fill_in_choice.call("イ", ["文部科学大臣", "計画的かつ効果的", "指標", "公表しなければならない"], true),
      fill_in_choice.call("ウ", ["任命権者", "計画的かつ効果的", "教員研修計画", "公表しなければならない"]),
      fill_in_choice.call("エ", ["任命権者", "体系的かつ効果的", "指標", "公表するよう努めるものとする"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「計画的かつ効果的」，③は「指標」，④は「公表しなければならない」。「体系的かつ効果的」は第22条の4における研修の実施の表現である。"),
      text_block.call("イ：四つとも原文と一致する。文部科学大臣が指標の策定に関する指針を定め，策定・変更後には公表する義務を負う。"),
      text_block.call("ウ：①は「文部科学大臣」，③は「指標」。任命権者が指針を参酌して指標を定める第22条の3と区別する。"),
      text_block.call("エ：①・②・④が異なる。任命権者による指標の公表は努力義務だが，ここで問う文部科学大臣による指針の公表は義務である。"),
    ],
    source_text: "教育公務員特例法・第22条の2〜第22条の4 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験17は承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験17 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験17 問#{number}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験17 問#{number}の出典リンク形式が不正です"
  end

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && blank_labels == %w[① ② ③ ④] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == 4 }
      raise "模擬試験17 問#{number}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験17 問#{number}は抜粋枠の冒頭に条番号を表示してください"
    end
  elsif [3, 4, 5].include?(number)
    raise "模擬試験17 問#{number}は条文の原文穴埋め問題にしてください"
  end
end

QuestionSeedSync.import(exam_number: 17, questions: questions, publication_status: "draft")

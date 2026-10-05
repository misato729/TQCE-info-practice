text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験18（作成中：承認済みの問1〜5）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("明治期における教科書制度の変遷について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "明治19年の小学校令によって，小学校の教科書に文部大臣の検定を必要とする制度が定められた。民間で編纂された教科書が検定の対象となり，修身をはじめ各教科の教科書には，この制度の下で複数の編纂者や出版社によるものが用いられた。"),
      text_choice.call("イ", "明治23年の教育勅語の発布は，修身教科書の内容にも影響を及ぼした。この時点で小学校の教科書が国定に切り替わったわけではなく，教育勅語を受けた内容上の変化と，後の国定教科書制度への転換とは，時期を区別して捉える必要がある。"),
      text_choice.call("ウ", "教科書の採択をめぐる不正事件を背景として，明治36年に小学校令が改正され，国定教科書制度が成立した。翌年から国定教科書の使用が始まり，文部省が著作する一方，印刷・発行・供給には民間業者も関わる仕組みが採られた。"),
      text_choice.call("エ", "明治36年の国定教科書制度の成立により，修身，国語，日本歴史，地理などの教科書が文部省の著作となった。この転換は小学校に加えて中学校と高等女学校にも及び，これらの学校でも，国定教科書が従来の検定教科書に代わって使用されるようになった。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。明治19年（1886年）の小学校令で検定制度が定められた。"),
      text_block.call("イ：適切。教育勅語は修身教科書の内容に影響したが，明治23年（1890年）に国定制度が成立したわけではない。"),
      text_block.call("ウ：適切。明治36年（1903年）に国定制度が成立し，明治37年（1904年）から国定教科書が使用された。民間の翻刻発行制度も採られていた。"),
      text_block.call("エ：国定制度の対象校種を広げている点が誤り。中学校，高等女学校，師範学校などでは，その後も検定制度が存続した。"),
    ],
    source_text: "文部科学省『学制百年史』五「国定教科書制度の成立」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317624.htm\n文部科学省『学制百年史』七「学科課程と教科書の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317615.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ヘルバルトの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育学を体系的な学問として構成するために，倫理学と心理学をその基礎に置いた。心理学によって，人間が目指すべき道徳的な価値と教育の目的を定め，倫理学によって，学習者の精神の働きに応じた教授の方法を明らかにしようとした。"),
      text_choice.call("イ", "教育学の基礎に倫理学と心理学を置き，教育の目的を倫理学に，目的を実現する方法を心理学に求めた。道徳的品性の形成を重視し，教授も，知識を内容や媒介として学習者の思想に働きかけ，道徳形成へ結び付くものとして捉えた。", true),
      text_choice.call("ウ", "教育学の基礎に倫理学と心理学を置き，道徳的品性の形成を教育の目的とした。教授は知識の習得を，訓育は道徳的な態度の形成を，それぞれ分担するものとし，道徳形成は，教科の教授を終えた後に行う訓育によって実現されると捉えた。"),
      text_choice.call("エ", "教育の目的と教授方法の関係を体系的に論じ，道徳的品性を形成するために多面的な興味を育てようとした。これらを述べた『ゲルトルート児童教授法』では，家庭教育における母親の教授を出発点として，教育学の体系化を進めた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：倫理学と心理学の役割が逆。教育目的を倫理学に，教育方法を心理学に求めた。"),
      text_block.call("イ：適切。道徳的品性の形成を，知識を媒介とする教授とも結び付けて考えている。"),
      text_block.call("ウ：教授を道徳形成から切り離している点が誤り。ヘルバルトは教授そのものにも道徳形成の働きを見いだした。"),
      text_block.call("エ：著作の帰属が誤り。『ゲルトルート児童教授法』はペスタロッチの著作である。ヘルバルトの代表的著作には『一般教育学』『教育学講義綱要』がある。"),
    ],
    source_text: "金築忠雄「教育学におけるさまざまな学的態度について」『島根農科大学研究報告』第6号B・35、40頁 | https://ir.lib.shimane-u.ac.jp/4282/files/1094\n筑波大学『近代教育学の源流』IV「ペスタロッチ・ヘルバルト」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "大学は，学術の中心として高い教養と専門的能力を培い，深く真理を探究して新たな知見を創造するとともに，これらの成果を広く社会に提供することにより，社会の発展に寄与するものとされている。"),
      text_choice.call("イ", "幼児期の教育は，生涯にわたる人格形成の基礎を培う重要なものであることから，国及び地方公共団体は，幼児の健やかな成長に資する良好な環境の整備などによって，その振興に努めることとされている。"),
      text_choice.call("ウ", "国及び地方公共団体は，適切な役割分担及び相互の協力の下，義務教育の実施に責任を負う。また，授業料を徴収しないとする規定の対象は，法律に定める学校における義務教育である。", true),
      text_choice.call("エ", "国及び地方公共団体は，障害のある者がその障害の状態に応じ十分な教育を受けられるよう，教育上必要な支援を講じる義務を負う。また，能力があるにもかかわらず経済的理由で修学が困難な者に対し，奨学の措置を講じる義務を負う。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。第7条第1項の大学の教育・研究・社会貢献に関する規定に一致する。"),
      text_block.call("イ：適切。第11条は，幼児期の教育の重要性を踏まえ，国及び地方公共団体による振興の努力義務を定めている。"),
      text_block.call("ウ：後半の対象が誤り。第5条第4項は「国又は地方公共団体の設置する学校における義務教育」について，授業料を徴収しないと定める。「法律に定める学校」に置き換えると私立学校も含み，規定の対象に一致しない。"),
      text_block.call("エ：適切。障害の状態に応じた教育上必要な支援は第4条第2項，経済的理由で修学が困難な能力のある者への奨学の措置は同条第3項に定められている。"),
    ],
    source_text: "教育基本法・第4条、第5条、第6条、第7条、第11条 | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "fill_in_quote",
        text: "第37条第4項\n校長は、{{①}}をつかさどり、{{②}}を監督する。\n\n第37条第5項\n副校長は、校長を助け、{{③}} {{①}}をつかさどる。\n\n第37条第6項\n副校長は、校長に事故があるときは{{④}}、校長が欠けたときはその職務を行う。この場合において、副校長が二人以上あるときは、あらかじめ校長が定めた順序で、{{④}}、又は行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["校務", "所属職員", "命を受けて", "その職務を代理し"], true),
      fill_in_choice.call("イ", ["校務", "教諭", "命を受けて", "その職務を代行し"]),
      fill_in_choice.call("ウ", ["教育課程", "所属職員", "任命権者の指示を受けて", "その職務を代理し"]),
      fill_in_choice.call("エ", ["教育課程", "教諭", "任命権者の指示を受けて", "その職務を代行し"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。校長は校務をつかさどり，所属職員を監督する。副校長は校長を助け，命を受けて校務をつかさどる。"),
      text_block.call("イ：②は「所属職員」，④は「その職務を代理し」。監督の対象は教諭に限らない。"),
      text_block.call("ウ：①は「校務」，③は「命を受けて」。校務は教育課程に関する事項だけではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
      text_block.call("校長に事故がある場合の「代理」と，校長が欠けた場合に職務を「行う」ことは区別される。これらの規定は第62条によって高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第37条第4項〜第6項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "fill_in_quote",
        text: "第38条\n\n職員は、{{①}}の許可を受けなければ、商業、工業又は金融業その他{{②}}（以下この項及び次条第一項において「営利企業」という。）を営むことを目的とする会社その他の団体の役員その他人事委員会規則（人事委員会を置かない地方公共団体においては、地方公共団体の規則）で定める地位を兼ね、若しくは{{③}}、又は{{④}}を得ていかなる事業若しくは事務にも従事してはならない。ただし、非常勤職員（短時間勤務の職を占める職員及び第二十二条の二第一項第二号に掲げる職員を除く。）については、この限りでない。\n\n2　人事委員会は、人事委員会規則により前項の場合における{{①}}の許可の基準を定めることができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者", "営利を目的とする私企業", "自ら営利企業に出資し", "給与"]),
      fill_in_choice.call("イ", ["所属長", "公益を目的とする法人", "自ら営利企業を営み", "報酬"]),
      fill_in_choice.call("ウ", ["所属長", "公益を目的とする法人", "自ら営利企業に出資し", "給与"]),
      fill_in_choice.call("エ", ["任命権者", "営利を目的とする私企業", "自ら営利企業を営み", "報酬"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：③は「自ら営利企業を営み」，④は「報酬」。条文で挙げられているのは出資ではなく経営である。"),
      text_block.call("イ：①は「任命権者」，②は「営利を目的とする私企業」。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも原文と一致する。営利企業の役員等の地位を兼ねること，自ら営利企業を営むこと，報酬を得て事業・事務に従事することを規定している。"),
      text_block.call("許可基準を定めることができる主体は人事委員会だが，許可自体の主体は任命権者である。"),
    ],
    source_text: "地方公務員法・第38条 | https://laws.e-gov.go.jp/law/325AC0000000261",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験18は承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験18 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験18 問#{number}の選択肢または正答数が不正です"
  end
  unless question.fetch(:content_blocks).any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験18 問#{number}の問題文または解説が空です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験18 問#{number}の出典リンク形式が不正です"
  end

  next unless [4, 5].include?(number)

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
  unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && quotes.size == 1 &&
      quotes.first.fetch(:text).match?(/\A第\d+条/) && blank_labels == %w[① ② ③ ④] &&
      choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
    raise "模擬試験18 問#{number}の条番号、空欄または選択肢の対応が不正です"
  end
end

QuestionSeedSync.import(exam_number: 18, questions: questions, publication_status: "draft")

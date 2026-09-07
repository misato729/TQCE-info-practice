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

# 模擬試験11（作成中：問1〜5）
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
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，正しいものを一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      text_choice.call("ア", "第4条第3項は，奨学の措置を講ずる対象を「学習意欲があるにもかかわらず，経済的理由によって修学が困難な者」とし，国及び地方公共団体にその措置を求めている。"),
      text_choice.call("イ", "第9条は，研究と修養に励むことについては法律に定める学校の教員を対象とし，身分の尊重と待遇の適正については国公立学校の教員を対象として定めている。"),
      text_choice.call("ウ", "第8条は，私立学校の公の性質と学校教育における重要な役割を踏まえ，国及び地方公共団体が，その自主性を尊重しつつ，助成その他の適当な方法によって私立学校教育の振興に努めることを定めている。", true),
      text_choice.call("エ", "第16条は，国の役割として地域の実情に応じた教育施策の策定と実施を定め，地方公共団体の役割として全国的な教育の機会均等と教育水準の維持向上を定めている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：誤り。第4条第3項の文言は「能力があるにもかかわらず，経済的理由によって修学が困難な者」であり，「学習意欲があるにもかかわらず」ではない。"),
      text_block.call("イ：誤り。第9条第2項の「前項の教員」は，第1項の「法律に定める学校の教員」を指す。身分の尊重や待遇の適正等について，国公立学校の教員に対象を絞っていない。"),
      text_block.call("ウ：正しい。私立学校の公の性質を認めることと，その自主性を尊重することを併せて規定している。"),
      text_block.call("エ：誤り。国と地方公共団体の役割が逆である。国は全国的な機会均等と教育水準の維持向上を，地方公共団体は地域の実情に応じた教育の振興を担う。"),
    ],
    source_text: "教育基本法・第4条、第8条、第9条、第16条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第51条\n高等学校における教育は、前条に規定する目的を実現するため、次に掲げる目標を達成するよう行われるものとする。\n\n一　{{①}}として行われる普通教育の成果を更に発展拡充させて、豊かな人間性、創造性及び健やかな身体を養い、国家及び社会の{{②}}として必要な資質を養うこと。\n\n二　社会において果たさなければならない{{③}}に基づき、個性に応じて将来の進路を決定させ、{{④}}を高め、専門的な知識、技術及び技能を習得させること。\n\n三　個性の確立に努めるとともに、社会について、広く深い理解と健全な批判力を養い、社会の発展に寄与する態度を養うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["義務教育", "形成者", "勤労の尊重", "幅広い知識と教養"]),
      fill_in_choice.call("イ", ["義務教育", "形成者", "使命の自覚", "一般的な教養"], true),
      fill_in_choice.call("ウ", ["中学校教育", "構成員", "使命の自覚", "一般的な教養"]),
      fill_in_choice.call("エ", ["中学校教育", "構成員", "勤労の尊重", "幅広い知識と教養"]),
    ],
    explanation_blocks: [
      text_block.call("第1号では「義務教育」の成果の発展拡充と，国家及び社会の「形成者」としての資質を，第2号では「使命の自覚」に基づく進路決定と「一般的な教養」の向上を規定している。"),
      text_block.call("ア：③は「使命の自覚」，④は「一般的な教養」が正しい。"),
      text_block.call("ウ：①は「義務教育」，②は「形成者」が正しい。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "学校教育法・第51条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の3\n公立の小学校等の校長及び教員の{{①}}は、{{②}}を参酌し、その地域の実情に応じ、当該校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する{{③}}（以下この章において「{{③}}」という。）を定めるものとする。\n\n2　公立の小学校等の校長及び教員の{{①}}は、{{③}}を定め、又はこれを変更しようとするときは、第二十二条の七第一項に規定する{{④}}において協議するものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "指針", "指標", "教育委員会"]),
      fill_in_choice.call("イ", ["任命権者", "教育振興基本計画", "教員研修計画", "協議会"]),
      fill_in_choice.call("ウ", ["研修実施者", "教育振興基本計画", "教員研修計画", "教育委員会"]),
      fill_in_choice.call("エ", ["任命権者", "指針", "指標", "協議会"], true),
    ],
    explanation_blocks: [
      text_block.call("文部科学大臣が定める「指針」を参酌し，任命権者が地域の実情等に応じた「指標」を定める。その策定・変更に当たっては，法定の「協議会」において協議する。"),
      text_block.call("ア：①は「任命権者」，④は「協議会」が正しい。"),
      text_block.call("イ：②は「指針」，③は「指標」が正しい。「教員研修計画」は，第22条の4に規定された別の計画である。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条の2〜第22条の4、第22条の7 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験11の作成中データには承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  expected_category = question.fetch(:question_number) <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験11 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験11 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless blank_labels == %w[① ② ③ ④] && choices.all? { |choice| choice.fetch(:content_blocks).one? { |block| block[:type] == "fill_in_choice" && block[:cells].size == blank_labels.size } }
      raise "模擬試験11 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験11 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験11 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

QuestionSeedSync.import(exam_number: 11, questions: questions, publication_status: "draft")

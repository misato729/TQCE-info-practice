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

# 模擬試験16（承認済みの問1〜5。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("大正期の大学制度の改革について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "大正7年の大学令は，大学に学部を置き，必要な場合には予科を設けることを定め，大学制度の拡張を図った。これに伴って従来の帝国大学令は廃止され，帝国大学を含む官立・公立・私立の大学が同じ大学令によって設置されることになった。"),
      text_choice.call("イ", "大正7年の大学令では，官立大学に加えて公立・私立大学の設置が認められ，私立大学には財団法人としての財産などが求められた。大学は複数の学部を備える総合大学として組織することとされ，単科大学は専門学校の制度に位置付けられた。"),
      text_choice.call("ウ", "大正7年の大学令は，従来の帝国大学令を存続させつつ，官立・公立・私立大学を制度化した。複数の学部を置くことを原則としながら単科大学も認められ，この制度の下で，東京高等商業学校は東京商科大学へ昇格し，慶應義塾や早稲田にも大学設置が認可された。", true),
      text_choice.call("エ", "大正7年の大学令によって私立大学の設置が認められ，慶應義塾や早稲田は大正9年に大学として認可された。その際，それまで官立の帝国大学に置かれていた分科大学を各校にも設け，それぞれの分科大学を学部に相当する教育組織とした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：帝国大学令が廃止されたとする点が誤り。帝国大学令は，帝国大学に関する規定として存続した。"),
      text_block.call("イ：単科大学の扱いが誤り。大学令は，一学部からなる大学も認めていた。"),
      text_block.call("ウ：適切。大正7年（1918年）の大学令によって大学の設置主体と形態が拡張され，大正9年（1920年）には東京商科大学の設置と慶應義塾・早稲田などの大学認可が行われた。"),
      text_block.call("エ：分科大学を新たな制度で維持したとする点が誤り。分科大学の名称は廃され，「学部」とされた。"),
    ],
    source_text: "文部科学省『学制百年史』・二「大学令の制定と大学の拡張」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317663.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("スペンサーの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育を「完全な生活」のための準備と捉え，自己保存，生計，子どもの養育，社会的・政治的活動，余暇に関わる活動を考察した。古典語を重んじる伝統的な教育に対し，これらの生活上の活動に役立つ知識として科学の価値を高く評価した。", true),
      text_choice.call("イ", "教育を「完全な生活」のための準備と捉え，生活上の活動を重要性に応じて位置付けた。社会的・政治的活動に必要な知識を教育課程の最優先事項とし，生命と健康を保つ自己保存に関する知識を，その基礎を支える第二の事項に位置付けた。"),
      text_choice.call("ウ", "子どもの発達の自然な過程を尊重し，教授方法も精神の発達法則に従うべきだと考えた。具体的な事物の観察を学習へ取り入れるに当たっては，抽象的な概念を先に体系的に説明し，その概念を具体的な事物に当てはめる順序を原則とした。"),
      text_choice.call("エ", "知育・徳育・体育のそれぞれを論じ，徳育では子どもが行為の結果を理解することを重視した。そのため，行為から自然に生じる結果に任せるよりも，親が行為に応じた罰を設け，その罰と行為との関係を子どもに説明する方法を基本とした。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。生活の諸活動に役立つ知識を検討し，科学を最も価値ある知識として重視した。"),
      text_block.call("イ：活動の位置付けが誤り。直接の自己保存が最初に置かれ，社会的・政治的活動は，間接的な自己保存（生計），子どもの養育に続く位置にある。"),
      text_block.call("ウ：教授の順序が逆。「抽象的なものから具体的なものへ」ではなく，「具体的なものから抽象的なものへ」が原則である。"),
      text_block.call("エ：徳育の方法が誤り。スペンサーは行為の自然的な結果から学ぶことを重視し，人為的な罰によって道徳を教える方法を批判した。"),
    ],
    source_text: "川瀬八洲夫「H．スペンサーの教育思想―我が国における受容の諸問題を中心にして―」『東京家政大学研究紀要』第8集・147〜148頁 | https://tokyo-kasei.repo.nii.ac.jp/record/11187/files/2011_k_0131.pdf\nスペンサー著・三笠乙彦訳『知育・徳育・体育論』・国立国会図書館サーチ書誌 | https://ndlsearch.ndl.go.jp/books/R100000001-I06111100054843",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，正しいものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "第2条は，教育の目標を学問の自由を尊重しつつ達成することとし，社会の形成への参画については，公共の福祉に基づき，主体的にその発展に寄与する態度を養うことを掲げている。"),
      text_choice.call("イ", "第2条は，生命を尊び，自然を大切にし，環境の保全に寄与する態度を養うことを掲げている。また，伝統と文化を尊重し，我が国と郷土を愛することと，他国を尊重し，国際社会の平和と発展に寄与することを併せて掲げている。", true),
      text_choice.call("ウ", "第17条は，政府が教育の振興に関する施策の総合的かつ計画的な推進を図るため，基本的な計画を定め，これを内閣に報告するとともに，公表することを定めている。"),
      text_choice.call("エ", "第13条は，学校，家庭及び地域住民その他の関係者が，教育におけるそれぞれの役割と責任を自覚することを定めるとともに，相互の連携及び協力に努める主体を，国及び地方公共団体としている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：第2条第3号の文言は「公共の精神」であり，「公共の福祉」ではない。学問の自由を尊重する点や，主体的な参画を重視する点は正しい。"),
      text_block.call("イ：正しい。第2条第4号の生命・自然・環境に関する内容と，第5号の伝統・文化，我が国と郷土，他国及び国際社会に関する内容に一致する。"),
      text_block.call("ウ：報告先が誤り。第17条第1項が定める報告先は「国会」であり，「内閣」ではない。"),
      text_block.call("エ：連携・協力に努める主体が誤り。第13条では，いずれも「学校、家庭及び地域住民その他の関係者」が主体である。"),
    ],
    source_text: "教育基本法・第2条、第13条、第17条第1項 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第3条\n学校を設置しようとする者は、学校の種類に応じ、{{①}}の定める設備、編制その他に関する{{②}}に従い、これを設置しなければならない。\n\n第5条\n{{③}}は、その設置する学校を管理し、法令に特別の定のある場合を除いては、その学校の経費を負担する。\n\n第7条\n学校には、{{④}}を置かなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "設置基準", "国及び地方公共団体", "校長及び相当数の教員"]),
      fill_in_choice.call("イ", ["都道府県の教育委員会", "設置認可基準", "学校の設置者", "校長及び相当数の教員"]),
      fill_in_choice.call("ウ", ["文部科学大臣", "設置認可基準", "学校の設置者", "校長及び教頭"]),
      fill_in_choice.call("エ", ["文部科学大臣", "設置基準", "学校の設置者", "校長及び相当数の教員"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：③が異なる。管理・経費負担の主体は「学校の設置者」であり，国及び地方公共団体に限らない。私立学校の設置者も含まれる。"),
      text_block.call("イ：①は「文部科学大臣」，②は「設置基準」。設置認可を行う主体と，全国的な設置基準を定める主体を区別する。"),
      text_block.call("ウ：②は「設置基準」，④は「校長及び相当数の教員」。個別校種の教頭に関する規定と，学校一般に適用される第7条を区別する。"),
      text_block.call("エ：四つとも原文と一致する。"),
    ],
    source_text: "学校教育法・第3条、第5条、第7条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条\n教育公務員には、{{①}}が与えられなければならない。\n\n2　教員は、授業に支障のない限り、{{②}}の承認を受けて、勤務場所を離れて研修を行うことができる。\n\n3　教育公務員は、{{③}}（第二十条第一項第一号に掲げる者については、同号に定める市町村の教育委員会。以下この章において同じ。）の定めるところにより、{{④}}で、長期にわたる研修を受けることができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修を受ける機会", "任命権者", "本属長", "現職のまま"]),
      fill_in_choice.call("イ", ["研究を行う時間", "本属長", "任命権者", "休職中"]),
      fill_in_choice.call("ウ", ["研修を受ける機会", "本属長", "任命権者", "現職のまま"], true),
      fill_in_choice.call("エ", ["研究を行う時間", "任命権者", "本属長", "休職中"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②と③の主体が逆。勤務場所を離れる研修では「本属長」の承認を受け，長期研修は「任命権者」の定めるところによる。"),
      text_block.call("イ：①は「研修を受ける機会」，④は「現職のまま」。研究時間の保障や休職中の研修を規定した文章ではない。"),
      text_block.call("ウ：四つとも原文と一致する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条第1項〜第3項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "模擬試験16は承認済みの問1〜5を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = number <= 2 ? "education_foundations" : "education_system"
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == expected_category
    raise "模擬試験16 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験16 問#{number}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験16 問#{number}の出典リンク形式が不正です"
  end

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text" && blank_labels == %w[① ② ③ ④] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == 4 }
      raise "模擬試験16 問#{number}の空欄と選択肢の対応が不正です"
    end
    unless quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験16 問#{number}は抜粋枠の冒頭に条番号を表示してください"
    end
  elsif [4, 5].include?(number)
    raise "模擬試験16 問#{number}は条文の原文穴埋め問題にしてください"
  end
end

QuestionSeedSync.import(exam_number: 16, questions: questions, publication_status: "draft")

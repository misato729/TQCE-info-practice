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

# 模擬試験15（全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("1941（昭和16）年に公布された国民学校令について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "国民学校は初等科6年と高等科2年で構成され，「皇国ノ道」に基づく基礎的錬成を目的とした。義務教育年限も8年とされ，国民学校令の施行と同時に全国で8年間の就学義務が適用された。"),
      text_choice.call("イ", "国民学校令は義務教育年限を8年に延長し，その適用を昭和19年度から開始することとした。この計画は戦時下においても予定どおり実施され，終戦時まで全国で初等科と高等科を合わせた8年間の義務教育が行われた。"),
      text_choice.call("ウ", "国民学校は「皇国ノ道ニ則リテ初等普通教育ヲ施シ国民ノ基礎的錬成ヲ為ス」ことを目的とし，初等科6年と高等科2年で構成された。8年間の義務教育は昭和19年度から実施する予定であったが，戦時非常措置によって延期され，実施されないまま終戦を迎えた。", true),
      text_choice.call("エ", "国民学校令による初等科・高等科の構成は，戦後の学校教育法にも引き継がれた。昭和22年度から国民学校高等科を新制中学校の第1・第2学年として位置付け，8年間の義務教育を完成させた。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。アは，国民学校令が制度上義務教育を8年に延長した点は適切ですが，その適用は施行時の昭和16年度ではなく，昭和19年度から予定されていました。イは，昭和19年度から予定されていた8年間の義務教育が実施されたとしている点が誤りです。この計画は戦時非常措置によって延期され，実施されないまま終戦となりました。ウは，国民学校の目的，課程構成及び8年制義務教育が実施に至らなかった経緯を正しく述べています。エは，戦後の学校教育法が国民学校の初等科・高等科を維持したとしている点が誤りです。戦後は小学校6年・中学校3年を含む新しい学校体系が発足しました。"),
    ],
    source_text: "文部科学省『学制百年史』第一編第四章第二節『一 国民学校令の公布』 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317696.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("キルパトリックのプロジェクト・メソッドについて述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教師又は教科書から与えられた課題を，あらかじめ定められた手順に従って正確に完成する活動を教授の中心に置き，学習者自身がその目的を受け入れているかどうかを学習成立の条件から切り離した。"),
      text_choice.call("イ", "学習者が一月程度の学習課題について契約を結び，教科別実験室で教師の助言を受けながら，自分の進度で学習を進める個別化された教育方法を構成した。"),
      text_choice.call("ウ", "教授によって多方面の興味を形成し，既有の観念と新しい観念を統覚によって結び付けることを通して，教育の究極目的である道徳的品性の形成を目指した。"),
      text_choice.call("エ", "デューイの影響を受け，社会的な環境の中で学習者が心から目的をもって行う活動を学習の中心に置いた。教師が提案した活動であっても，学習者がその目的を自分のものとして受け入れ，計画・遂行・評価に関与する場合にはプロジェクトとなり得る。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは，外部から課された作業を手順どおり実施すること自体を中心としている点が誤りです。キルパトリックは，学習者が目的を自覚し，主体的に取り組む活動を重視しました。イはパーカーストのドルトン・プランについての記述です。ウはヘルバルトの教育思想です。多方面の興味，統覚及び道徳的品性が対応します。エはプロジェクト・メソッドを正しく説明しています。教師の提案から始まる活動であっても，学習者が目的を主体的に受け入れ，社会的な状況の中で計画・遂行する場合にはプロジェクトとなり得ます。"),
    ],
    source_text: "国立国会図書館サーチ『プロジェクト法』日本語訳 | https://ndlsearch.ndl.go.jp/books/R100000002-I000001093995
J-STAGE『キルパトリックのプロジェクト・メソッド』 | https://www.jstage.jst.go.jp/article/kyouikutetsugaku1959/1962/7/1962_7_14/_article/-char/ja/
J-STAGE『プロジェクト・メソッドにおける目的的活動』 | https://www.jstage.jst.go.jp/article/nasemjournal/19/0/19_KJ00006622222/_pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "次の①～④のうち，「教育基本法」（平成18年法律第120号）の条文として正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "quote",
        text: "①　国民一人一人が、自己の人格を磨き、豊かな人生を送ることができるよう、その生涯にわたって、あらゆる機会に、あらゆる場所において学習することができ、その成果を適切に生かすことのできる社会の実現が図られなければならない。\n\n②　教育公務員は、その職責を遂行するために、絶えず研究と修養に努めなければならない。\n\n③　学校教育上支障のない限り、学校には、社会教育に関する施設を附置し、又は学校の施設を社会教育その他公共のために、利用させることができる。\n\n④　国及び地方公共団体は、教育が円滑かつ継続的に実施されるよう、必要な財政上の措置を講じなければならない。",
      },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("教育基本法の条文は，①と④の二つである。"),
      text_block.call("①：教育基本法第3条「生涯学習の理念」の条文である。学習機会だけでなく，学習成果を適切に生かせる社会の実現を規定している。"),
      text_block.call("②：教育公務員特例法第21条第1項の条文である。教育基本法第9条にも研究と修養に関する規定があるが，そちらは「法律に定める学校の教員は，自己の崇高な使命を深く自覚し……」という条文であり，提示文とは異なる。"),
      text_block.call("③：学校教育法第137条の条文である。教育基本法第12条にも学校施設の利用に関する規定があるが，提示文そのものの出典は学校教育法である。"),
      text_block.call("④：教育基本法第16条第4項の条文である。国及び地方公共団体に，教育の円滑かつ継続的な実施に必要な財政上の措置を求めている。"),
    ],
    source_text: "教育基本法・第3条、第9条、第12条、第16条第4項 | https://laws.e-gov.go.jp/law/418AC0000000120\n教育公務員特例法・第21条第1項 | https://laws.e-gov.go.jp/law/324AC0000000001\n学校教育法・第137条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第10条\n私立学校は、校長を定め、大学及び高等専門学校にあつては{{①}}に、大学及び高等専門学校以外の学校にあつては{{②}}に届け出なければならない。\n\n第11条\n{{③}}は、教育上必要があると認めるときは、{{①}}の定めるところにより、児童、生徒及び学生に懲戒を加えることができる。ただし、{{④}}を加えることはできない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["文部科学大臣", "都道府県教育委員会", "校長", "体罰"]),
      fill_in_choice.call("イ", ["文部科学大臣", "都道府県知事", "校長及び教員", "体罰"], true),
      fill_in_choice.call("ウ", ["文部科学省", "都道府県知事", "校長及び教員", "肉体的苦痛"]),
      fill_in_choice.call("エ", ["文部科学省", "都道府県教育委員会", "校長", "肉体的苦痛"]),
    ],
    explanation_blocks: [
      text_block.call("私立学校の校長の届出先は，大学・高等専門学校では文部科学大臣，それ以外の学校では都道府県知事である。また，第11条は校長及び教員による懲戒を認める一方，体罰を禁止している。"),
      text_block.call("ア：②は「都道府県知事」，③は「校長及び教員」が正しい。私立学校の届出先を教育委員会と取り違えないことが重要である。"),
      text_block.call("ウ：①は「文部科学大臣」，④は「体罰」が正しい。第11条の禁止対象を表す原文の語句は「肉体的苦痛」ではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "学校教育法・第10条、第11条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の6\n公立の小学校等の校長及び教員の{{①}}は、当該校長及び教員がその{{②}}に応じた資質の向上のための取組を行うことを促進するため、当該校長及び教員からの相談に応じ、研修、認定講習等その他の資質の向上のための機会に関する情報を提供し、又は資質の向上に関する指導及び助言を行うものとする。\n\n2　公立の小学校等の校長及び教員の{{①}}は、前項の規定による相談への対応、情報の提供並びに指導及び助言（次項において「資質の向上に関する指導助言等」という。）を行うに当たつては、当該校長及び教員に係る{{③}}を踏まえるとともに、当該校長及び教員の{{④}}に係る情報を活用するものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["指導助言者", "職務の級及び在職期間", "指標及び教員研修計画", "人事評価の結果"]),
      fill_in_choice.call("イ", ["研修実施者", "職責、経験及び適性", "指針及び教育振興基本計画", "研修等に関する記録"]),
      fill_in_choice.call("ウ", ["指導助言者", "職責、経験及び適性", "指標及び教員研修計画", "研修等に関する記録"], true),
      fill_in_choice.call("エ", ["研修実施者", "職務の級及び在職期間", "指針及び教育振興基本計画", "人事評価の結果"]),
    ],
    explanation_blocks: [
      text_block.call("この条文は，指導助言者が，教員等の「職責、経験及び適性」に応じた資質向上を促すために行う対応を定めている。その際には「指標及び教員研修計画」を踏まえ，「研修等に関する記録」の情報を活用する。"),
      text_block.call("ア：②は「職責、経験及び適性」，④は「研修等に関する記録」が正しい。ここで活用すべき情報として明記されているのは，人事評価の結果ではない。"),
      text_block.call("イ：①は「指導助言者」，③は「指標及び教員研修計画」が正しい。研修の実施に関する立場と，この条文で定める指導助言に関する立場を区別する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育公務員特例法・第22条の6第1項、第2項 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特に，各教科・科目等において身に付けた知識及び技能を活用したり，思考力，判断力，表現力等や{{①}}を発揮させたりして，学習の対象となる物事を捉え思考することにより，各教科・科目等の特質に応じた物事を捉える視点や考え方（以下「見方・考え方」という。）が{{②}}ことに留意し，生徒が各教科・科目等の特質に応じた見方・考え方を働かせながら，知識を相互に関連付けてより深く理解したり，{{③}}考えを形成したり，問題を見いだして解決策を考えたり，思いや考えを基に創造したりすることに向かう{{④}}を重視した学習の充実を図ること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["学びに向かう力，人間性等", "鍛えられていく", "情報を精査して", "過程"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["主体的に学習に取り組む態度", "鍛えられていく", "情報を収集して", "成果"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["学びに向かう力，人間性等", "明確に位置付けられる", "情報を精査して", "成果"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["主体的に学習に取り組む態度", "明確に位置付けられる", "情報を収集して", "過程"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "資質・能力の三つの柱を活用・発揮する中で，見方・考え方が鍛えられます。情報を精査して考えを形成するなど，理解・思考・創造へ向かう過程を重視します。イは①・③・④，ウは②・④，エは①・②・③が異なります。①は学習評価の観点名「主体的に学習に取り組む態度」ではなく，資質・能力の柱である「学びに向かう力，人間性等」です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第3款1（1）第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "educational_counseling",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学習や生活の基盤として，教師と生徒との{{①}}及び生徒相互のよりよい人間関係を育てるため，日頃からホームルーム経営の充実を図ること。また，主に集団の場面で必要な指導や援助を行う{{②}}と，個々の生徒の多様な実態を踏まえ，一人一人が抱える課題に個別に対応した指導を行う{{③}}の双方により，{{④}}を支援すること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["協力関係", "ガイダンス", "コンサルテーション", "生徒の適応"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["信頼関係", "カウンセリング", "ガイダンス", "生徒の発達"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["信頼関係", "ガイダンス", "カウンセリング", "生徒の発達"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["協力関係", "カウンセリング", "コンサルテーション", "生徒の適応"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "教師・生徒間の信頼関係を基盤に，集団の場面で行うガイダンスと，個別の課題に対応するカウンセリングの双方で生徒の発達を支援します。アは①・③・④，イは②・③，エは全ての空欄が異なります。イは集団と個別の対応を逆にしており，ア・エは個別の課題への指導をカウンセリング以外の用語へ置き換えています。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第5款1（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（5）探究の過程においては，コンピュータや情報通信ネットワークなどを{{①}}に活用して，情報を{{②}}するなどの学習活動が行われるよう工夫すること。その際，情報や情報手段を{{③}}に選択し活用できるよう配慮すること。\n\n（6）自然体験や就業体験活動，ボランティア活動などの社会体験，ものづくり，生産活動などの体験活動，観察・実験・実習，調査・研究，発表や討論などの学習活動を積極的に取り入れること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["効率的かつ計画的", "収集・整理・発信", "協働的"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["適切かつ効果的", "収集・整理・発信", "主体的"] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["適切かつ効果的", "収集・分析・評価", "協働的"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["効率的かつ計画的", "収集・分析・評価", "主体的"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "情報手段は適切かつ効果的に活用し，情報の収集・整理・発信につなげます。情報や情報手段を主体的に選択し活用できるようにすることが論点です。アは①・③，ウは②・③，エは①・②が異なります。他者との協働も別項で重視されますが，③の原文は主体的です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第4章第3の2（5）・（6） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学校における道徳教育は，人間としての在り方生き方に関する教育を学校の教育活動全体を通じて行うことによりその充実を図るものとし，各教科に属する科目（以下「{{①}}」という。），{{②}}及び特別活動（以下「{{③}}」という。）の{{④}}に応じて，適切な指導を行うこと。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["各教科・科目", "総合的な探究の時間", "各教科・科目等", "それぞれの特質"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["各教科・科目等", "総合的な探究の時間", "各教科・科目", "それぞれの特質"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["各教科・科目", "総合的な学習の時間", "各教科・科目等", "生徒の発達の段階"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["各教科・科目等", "総合的な学習の時間", "各教科・科目", "生徒の発達の段階"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "各教科に属する科目を「各教科・科目」といい，総合的な探究の時間と特別活動を含めて「各教科・科目等」としています。高等学校では総合的な探究の時間という名称を用い，道徳教育はそれぞれの特質に応じて指導します。イは①・③の用語の範囲が逆です。ウは②・④，エは全ての空欄が異なります。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第1章第1款2（2）第1段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）多様な他者と協働する様々な集団活動の意義や活動を行う上で必要となることについて理解し，{{①}}を身に付けるようにする。\n\n（2）{{②}}の課題を見いだし，解決するために話し合い，合意形成を図ったり，意思決定したりすることができるようにする。\n\n（3）{{③}}な集団活動を通して身に付けたことを生かして，主体的に集団や社会に参画し，生活及び人間関係をよりよく形成するとともに，人間としての在り方生き方についての自覚を深め，{{④}}を図ろうとする態度を養う。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["行動の仕方", "現在及び将来の生き方", "自主的，実践的", "自己実現"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["集団生活の規律", "集団や自己の生活，人間関係", "自発的，自治的", "社会的自立"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["行動の仕方", "集団や自己の生活，人間関係", "自主的，実践的", "社会的自立"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["行動の仕方", "集団や自己の生活，人間関係", "自主的，実践的", "自己実現"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "（1）は活動の意義等の理解と行動の仕方，（2）は集団や自己の生活・人間関係の課題の解決，（3）は自主的・実践的な集団活動を通した社会参画や自己実現を目指す態度を示しています。アは②，イは①・③・④，ウは④が異なります。「自発的，自治的」も特別活動の一部に関わる特質ですが，③の原文は「自主的，実践的」です。" },
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）』第5章第1（1）～（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=480",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "参加するメンバーは、個人情報を含めチーム支援において知り得た情報を守秘しなければなりません。{{①}}が重要です。学校や教職員は、保護者や地域社会に対して、{{②}}を有し、情報公開請求に応えることも求められます。特に、当該児童生徒の保護者の知る権利への配慮が大切です。\n\n③ 記録保持と情報セキュリティ\n\n会議録、各種調査票、チーム支援計画シート、教育相談記録等を、的確に作成し、規定の期間保持することが必要です。これらの情報資産については、{{③}}が定める教育情報セキュリティポリシーに準拠して慎重に取り扱うことが求められます。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["説明責任（アカウンタビリティ）", "守秘義務", "自治体"]),
      fill_in_choice.call("イ", ["チーム内守秘義務（集団守秘義務）", "説明責任", "文部科学省"]),
      fill_in_choice.call("ウ", ["チーム内守秘義務（集団守秘義務）", "説明責任", "自治体"], true),
      fill_in_choice.call("エ", ["説明責任（アカウンタビリティ）", "守秘義務", "文部科学省"]),
    ],
    explanation_blocks: [
      text_block.call("チーム支援で得た情報については「チーム内守秘義務（集団守秘義務）」が重要です。一方、学校や教職員は保護者や地域社会に対して「説明責任」を有します。情報資産は、「自治体」が定める教育情報セキュリティポリシーに準拠して取り扱います。"),
      text_block.call("ア：①と②の対応が異なります。前半は支援に参加するメンバーの守秘について、後半は保護者や地域社会への説明について述べています。"),
      text_block.call("イ：③が異なります。この箇所でポリシーを定める主体として示されているのは、文部科学省ではなく自治体です。"),
      text_block.call("エ：①と②の対応に加え、③も異なります。守秘と説明は両方必要ですが、それぞれが置かれる文脈を区別する必要があります。"),
    ],
    source_text: "文部科学省『生徒指導提要』第1章1.3.4（2）②「守秘義務と説明責任」〜③「記録保持と情報セキュリティ」、本文28ページ | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=31",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("病弱・身体虚弱のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "入院や治療による学習空白と，現在の習熟状況を把握する。主治医の助言などを踏まえて学習内容を変更・調整し，病状の変化や治療の見通しに応じて学習機会を確保する。", true),
      text_choice.call("イ", "同じ病気であれば，必要な生活上の制限や学習可能な活動の範囲には共通性がある。このため，病名別に定めた活動の範囲を基準として，各生徒の指導計画を作成する。"),
      text_choice.call("ウ", "病弱は，継続して入院し治療を必要とする状態として捉える。退院後にも医療や生活上の管理が必要な場合は，病弱から身体虚弱へ区分を変更して教育的対応を行う。"),
      text_choice.call("エ", "病弱教育では，身体疾患の状態とその治療に対応する。心身症や精神疾患によって学習や生活に困難が生じる状態は，情緒障害の教育の対象として区分して対応する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。学習空白，習熟状況，病状や治療の見通しを踏まえ，医療機関と連携して内容や方法を調整します。"),
      text_block.call("イ：同じ病気でも，病状や必要な支援は一人一人異なります。病名別の活動範囲をそのまま指導計画の基準とするのではなく，個々の状態と医療上の助言などを踏まえます。"),
      text_block.call("ウ：病弱は，入院中に限定されません。退院や通院という形態によって，身体虚弱へ機械的に区分を変更するものではありません。"),
      text_block.call("エ：心身症や精神疾患なども，病弱教育の対象となる場合があります。身体疾患と精神疾患をこのように二分する説明は適切ではありません。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』Ⅴ「病弱・身体虚弱」―定義，学習内容の変更・調整，学習機会の確保，対象となる病気等 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_09.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ピアジェの認知発達理論におけるシェマ，同化，調節及び均衡化に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "シェマは，対象を捉えたり対象に働きかけたりする際の枠組みである。外界の対象を既有のシェマに取り込み，その枠組みに沿って理解する働きを調節という。"),
      text_choice.call("イ", "同化は，外界の対象を既有のシェマに取り込む働きである。外界の対象に合うように自分のシェマを修正する働きを均衡化といい，この二つによって認知の適応を説明する。"),
      text_choice.call("ウ", "調節は，外界の対象に応じて自分のシェマを修正する働きである。既有のシェマに新たな対象を取り込む働きを均衡化といい，調節と均衡化の相互作用によって認知が発達する。"),
      text_choice.call("エ", "同化は，外界の対象を既有のシェマに取り込む働きであり，調節は，対象に応じてシェマを修正する働きである。均衡化は，これらを調整しながら新たな認知の構造へ向かう過程に関わる。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：シェマの説明は適切ですが，後半は調節ではなく同化です。"),
      text_block.call("イ：同化の説明は適切です。しかし，シェマを対象に合わせて修正する働きは，均衡化ではなく調節です。"),
      text_block.call("ウ：調節の説明は適切ですが，既有のシェマに対象を取り込む働きは同化です。同化と調節を調整する過程が均衡化に関わります。"),
      text_block.call("エ：適切です。既有の枠組みを用いる同化と，枠組みを修正する調節とを区別し，両者と均衡化の関係を示しています。"),
    ],
    source_text: "東京大学山内研究室・ピアジェの認知発達理論―シェマ，同化，調節，均衡化 | https://fukutake.iii.u-tokyo.ac.jp/ylab/2014/10/post-504.html",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("記憶及び忘却に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "系列位置効果は，記憶材料が提示された位置によって再生成績が異なる現象である。自由再生では，リストの初めの項目と終わりの項目が，中間の項目より再生されやすい傾向がみられる。"),
      text_choice.call("イ", "先に学習した内容が，後に学習した内容の記憶を妨げる現象を逆向干渉という。これに対して，後に学習した内容が，先に学習した内容の記憶を妨げる現象を順向干渉という。", true),
      text_choice.call("ウ", "記憶の二重貯蔵モデルでは，初頭効果を長期記憶，新近効果を短期記憶の働きと関連付けて説明する。提示後に復唱を妨げる課題を挟むと，新近効果が低下することが知られている。"),
      text_choice.call("エ", "維持リハーサルは，情報を繰り返して保持することに関わる。精緻化リハーサルは，情報の意味を考えたり既有の知識と関連付けたりすることに関わり，長期的な保持を促進する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。初めの項目が再生されやすい現象を初頭効果，終わりの項目が再生されやすい現象を新近効果と呼びます。"),
      text_block.call("イ：名称が逆です。「先の学習が後の記憶を妨げる」のが順向干渉，「後の学習が先の記憶を妨げる」のが逆向干渉です。順行抑制・逆行抑制などの名称も用いられます。"),
      text_block.call("ウ：適切です。二重貯蔵モデルに基づく代表的な説明です。復唱を妨げる課題などによって，終末部の情報を短期的に保持している効果が低下します。"),
      text_block.call("エ：適切です。単に反復する維持リハーサルと，意味や関連を深く処理する精緻化リハーサルを区別しています。"),
    ],
    source_text: "北海道大学公開講義「心理学」記憶に関する講義資料―自由再生，リハーサル，忘却，PDF pp.10・14 | https://ocw.hokudai.ac.jp/wp-content/uploads/2016/02/Psychology-2009-Note-10.pdf\n人間環境大学公開シラバス―記憶の系列位置効果と短期記憶・長期記憶 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=RD304001&jn=2026",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅰ部 総論 4 『令和の日本型学校教育』の構築に向けた今後の方向性 （5）感染症や災害の発生等を乗り越えて学びを保障する」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "また，やむを得ず学校の臨時休業等が行われる場合であっても，スクールカウンセラーやスクールソーシャルワーカー等の専門スタッフや，市町村や児童相談所，警察等の関係機関との連携を図りつつ，子供たちと学校との関係を継続することで，心のケアや虐待の防止を図り，子供たちの学びを保障していくための方策を講じることが必要である。\n\nさらに，感染症に対する差別や偏見，誹謗中傷等を許さないことが重要である。学校においては，誤った情報や認識や不確かな情報に惑わされることなく，正確な情報や科学的根拠に基づいた行動を行うこと，感染者，濃厚接触者等とその家族に対する誤解や偏見に基づく差別を行わないことなどの点について，しっかりと取り上げ，身に付けさせることが必要である。あわせて，保護者や地域においては，学校における感染症対策と教育活動の両立に対する理解や協力に加え，差別等を許さない地域を作ることが期待される。\n\nこれらの取組を円滑に進めるためには，{{①}}等も活用して，{{②}}との連携を積極的に行うとともに，教育委員会等の学校の設置者が学校における取組を後押しすることも重要である。特に，今般の新型コロナウイルス感染症対応においては，教育委員会が，学校の{{③}}な取組を積極的に支援するという役割を果たしていたか否かが，子供たちの学びの保障においても重要であったことを踏まえ，教育委員会が率先して課題に取り組み，学校を支援する教育委員会の在り方について検討していくことが必要である。また，今般の新型コロナウイルス感染症の発生のような危機的な状況を乗り越えるためには，特に保護者や地域と協働し，{{④}}を推し進めることが必要である。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["総合教育会議", "首長部局", "自主的・自立的", "学校運営や教育行政"], true),
      fill_in_choice.call("イ", ["総合教育会議", "議会", "組織的・計画的", "学校運営や教育行政"]),
      fill_in_choice.call("ウ", ["学校運営協議会", "首長部局", "自主的・自立的", "校務分掌や授業改善"]),
      fill_in_choice.call("エ", ["学校運営協議会", "議会", "組織的・計画的", "校務分掌や授業改善"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致します。総合教育会議等を活用した首長部局との連携，学校の自主的・自立的な取組を支える教育委員会の役割，保護者や地域との協働による学校運営・教育行政の推進が示されています。"),
      text_block.call("イ：①と④は一致しますが，②は「首長部局」，③は「自主的・自立的」です。「組織的・計画的」は学校教育の他の文脈でも用いられる表現ですが，この箇所の原文ではありません。"),
      text_block.call("ウ：②と③は一致しますが，①は「総合教育会議」，④は「学校運営や教育行政」です。学校内の校務分掌・授業改善へ範囲を置き換えている点も異なります。"),
      text_block.call("エ：四つとも原文と異なります。臨時休業時の子供への支援や差別防止を，学校と教育委員会，首長部局，保護者・地域の連携によって進める文脈として押さえる必要があります。"),
    ],
    source_text: "中央教育審議会『令和の日本型学校教育』答申・第Ⅰ部 総論4（5）「感染症や災害の発生等を乗り越えて学びを保障する」・本文29頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=34",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第2章 第10節 情報 第2款 各科目 第1 情報Ⅰ 3 内容の取扱い」に示された内容に基づく記述である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「コンピュータとプログラミング」の，アルゴリズムを表現する手段やプログラミングによるコンピュータ等の活用方法の理解・技能の習得，及び目的に応じたアルゴリズムの考案・表現とプログラミングによる活用については，{{①}}によりプログラムの構造を整理するとともに，{{②}}を改善する工夫の必要性についても触れる。\n\n事象のモデル化とシミュレーションによるモデルの評価・改善，及び結果を踏まえた問題の解決方法の考察については，{{③}}とともに，{{④}}によって結果に違いが出ることについても触れる。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["関数の定義・使用", "性能", "コンピュータを使う場合と使わない場合の双方を体験させる", "モデルの違い"] }], correct: true },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["変数の宣言・初期化", "性能", "コンピュータを使う場合と使わない場合の双方を体験させる", "モデルの違い"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["関数の定義・使用", "操作性", "コンピュータを使う場合と使わない場合の双方を体験させる", "モデルの違い"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["関数の定義・使用", "性能", "コンピュータを使う場合を中心に体験させる", "計算機の種類"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "関数の定義・使用によって構造を整理し，性能改善の工夫にも触れる。モデル化・シミュレーションでは，コンピュータを使う場合と使わない場合の双方を体験し，モデルの違いによる結果の違いを扱う。" },
      { type: "text", text: "イの①は「関数の定義・使用」，ウの②は「性能」が正しい。エは③が「コンピュータを使う場合と使わない場合の双方を体験させる」，④が「モデルの違い」となる。" },
      { type: "text", text: "作問上の注記：原典の項番参照を具体的な学習事項へ展開しているため，「抜粋」ではなく「示された内容に基づく記述」とした。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節，第2款第1「情報Ⅰ」3（4），参照先2（3）・本文191〜192頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=193",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月30日文部科学省告示第68号）の「第3章 第7節 情報 第2款 各科目 第9 情報デザイン 3 内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）内容を取り扱う際には，次の事項に配慮するものとする。\n\nア 情報デザインに関する具体的な事例を取り上げ，{{①}}と関連付けて考察するよう留意して指導すること。\n\nイ 実習を通して，情報の収集，整理，{{②}}などの学習活動を行わせるとともに，地域や社会における情報伝達やコミュニケーションに関する具体的な課題を設定し，{{③}}を作品として{{④}}する学習活動を取り入れること。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["情報伝達やコミュニケーション", "標準化，最適化", "解決の手段", "制作，評価及び改善"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["情報伝達やコミュニケーション", "構造化，可視化", "調査の結果", "制作，評価及び改善"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["情報伝達やコミュニケーション", "構造化，可視化", "解決の手段", "制作，評価及び改善"] }], correct: true },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["情報システムやデータベース", "構造化，可視化", "解決の手段", "制作，公開及び保守"] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "情報デザインを情報伝達・コミュニケーションと関連付け，構造化・可視化の活動を通して，課題の解決手段を作品にし，制作・評価・改善する。" },
      { type: "text", text: "アの②は「構造化，可視化」，イの③は「解決の手段」が正しい。エは①が「情報伝達やコミュニケーション」，④が「制作，評価及び改善」となる。調査結果を示すだけでなく，課題を解決する手段を作品として作ることが位置付けられている。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節，第2款第9「情報デザイン」3（1）ア・イ・本文416〜417頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=418",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第1部 各学科に共通する教科『情報』 第2章 各科目 第1節 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "データの収集としては，データの内容や形式を踏まえて，その{{①}}を理解するようにする。データの整理としては，データに含まれる{{②}}の扱いやデータを整理，変換する必要性を理解するようにする。データの分析としては，基礎的な分析及び{{③}}の方法，多量のテキストから有用な情報を取り出す{{④}}の基礎やその方法を理解するようにする。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "fill_in_choice", cells: ["収集方法", "欠損値や外れ値", "標準化", "テキストマイニング"] }], correct: false },
      { label: "イ", content_blocks: [{ type: "fill_in_choice", cells: ["格納方式", "平均値や中央値", "可視化", "テキストマイニング"] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "fill_in_choice", cells: ["収集方法", "欠損値や外れ値", "可視化", "データクレンジング"] }], correct: false },
      { label: "エ", content_blocks: [{ type: "fill_in_choice", cells: ["収集方法", "欠損値や外れ値", "可視化", "テキストマイニング"] }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "収集では内容・形式に応じた収集方法，整理では欠損値・外れ値の扱いや変換，分析では可視化・テキストマイニングを扱う。" },
      { type: "text", text: "アの③は「可視化」，イの①は「収集方法」，②は「欠損値や外れ値」，ウの④は「テキストマイニング」が正しい。テキストマイニングは多量のテキストから有用な情報を取り出す分析であり，データクレンジングは欠損・誤記などを扱ってデータを整える処理である。" },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部，第2章第1節「情報Ⅰ」2（4）ア（ウ）・本文38頁 | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=46",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "次のプログラムは，配列Dataにおいて正の値が連続する部分の最大の長さを求めるものである。runは現在の連続する長さ，bestはそれまでの最大の長さを表す。updatesは9行目の代入の実行回数を数える。bestの値が変わらない代入も1回と数える。" },
      { type: "text", text: "実行後のbestとupdatesの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "疑似コードはPythonを模した表記であり，配列の添字は0から始まる。インデントの深さが同じ部分を同一ブロックとする。反復の範囲は両端を含む。" },
      { type: "code", code: "01 Data = [2, 3, 0, 4, 5, 6, -1, 7, 8, 9, 10]\n02 run = 0\n03 best = 0\n04 updates = 0\n05 iを0から要素数(Data)-1まで1ずつ増やしながら繰り返す:\n06     もし Data[i] > 0 ならば:\n07         run = run + 1\n08         もし run >= best ならば:\n09             best = run\n10             updates = updates + 1\n11     そうでなければ:\n12         run = 0\n13 表示する(best, updates)" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["best", "updates"], rows: [["3", "5"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["best", "updates"], rows: [["4", "6"]] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["best", "updates"], rows: [["4", "4"]] }], correct: false },
      { label: "エ", content_blocks: [{ type: "table", headers: ["best", "updates"], rows: [["3", "4"]] }], correct: false },
    ],
    explanation_blocks: [
      { type: "text", text: "正の値が連続する区間の長さは2，3，4であり，最大長は4となる。「run≧best」のため，bestと同じ長さに到達した場合も代入を数える。" },
      { type: "table", headers: ["区間の値", "runの推移", "区間内の代入回数", "区間終了時のbest"], rows: [["2，3", "1，2", "2", "2"], ["4，5，6", "1，2，3", "2", "3"], ["7，8，9，10", "1，2，3，4", "2", "4"]] },
      { type: "text", text: "したがって，代入回数は2＋2＋2＝6回である。" },
      { type: "text", text: "アは最後の要素10を処理する前の状態であり，反復は最後の添字まで含む。ウの4回はbestの値が厳密に増加した回数であり，同値での代入2回を数えていない。エは最大長と代入回数の両方が誤っている。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第3章・学習13「基本的プログラム」，学習14「応用的プログラム」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "二つの集団の母平均について，帰無仮説を「二つの母平均は等しい」として統計的仮説検定を行い，有意確率（p値）として0.04が得られた。有意水準は検定前に5%と定めた。" },
      { type: "text", text: "ここでは，p値が有意水準以下なら帰無仮説を棄却し，有意水準を上回れば棄却しないものとする。" },
      { type: "text", text: "この検定結果の説明として最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "text", text: "有意水準5%では帰無仮説を棄却する。p値が0.04なので，二つの母平均が等しい確率は4%と解釈する。" }], correct: false },
      { label: "イ", content_blocks: [{ type: "text", text: "有意水準5%では帰無仮説を棄却する。同じデータとp値で判断するので，有意水準1%で評価した場合も棄却する。" }], correct: false },
      { label: "ウ", content_blocks: [{ type: "text", text: "有意水準5%では帰無仮説を棄却し，1%で評価した場合は棄却しない。後者は，二つの母平均が等しいことを確かめたことを表す。" }], correct: false },
      { label: "エ", content_blocks: [{ type: "text", text: "有意水準5%では帰無仮説を棄却し，1%で評価した場合は棄却しない。後者の判断は，母平均が等しいと証明したことを意味しない。" }], correct: true },
    ],
    explanation_blocks: [
      { type: "text", text: "エが適切。p値と有意水準を比べると，次の判断になる。" },
      { type: "table", headers: ["評価する有意水準", "p値との比較", "判断"], rows: [["5%（0.05）", "0.04＜0.05", "帰無仮説を棄却する"], ["1%（0.01）", "0.04＞0.01", "帰無仮説を棄却しない"]] },
      { type: "text", text: "アはp値の意味が誤り。p値は，帰無仮説が正しいと仮定したときの観測結果の起こりにくさを評価する値であり，帰無仮説そのものが正しい確率ではない。イは1%での判定が誤り。同じp値でも有意水準を小さくすると棄却の基準は厳しくなり，0.04は0.01を上回るので棄却しない。ウは，棄却しないことと帰無仮説が正しいと証明することとを混同している。棄却しない場合は，今回のデータが，その有意水準で母平均の相違を示す十分な証拠にならないという判断にとどまる。" },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』，第4章・学習22（4）「量的データの統計的仮説検定」・本文186〜187頁 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=35",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験15は問1〜20を順番に登録してください"
end

questions.each do |question|
  expected_category = case question.fetch(:question_number)
  when 1, 2 then "education_foundations"
  when 6 then "curriculum_organization"
  when 7 then "educational_counseling"
  when 8 then "integrated_inquiry"
  when 9 then "moral_education"
  when 10 then "special_activities"
  when 11 then "student_guidance_career"
  when 12 then "special_support_education"
  when 13, 14 then "educational_psychology"
  when 16..18 then %w[information_education information_education information_specialized][question.fetch(:question_number) - 16]
  when 19, 20 then "information_specialized"
  else "education_system"
  end
  expected_major_category = question.fetch(:question_number) >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major_category
    raise "模擬試験15 問#{question.fetch(:question_number)}の大分類が不正です"
  end
  unless question.fetch(:category_code) == expected_category
    raise "模擬試験15 問#{question.fetch(:question_number)}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験15 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if quotes.any?
    blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    if blank_labels.empty?
      table_text = question.fetch(:content_blocks).select { |block| block[:type] == "table" }.flat_map { |block| block.fetch(:rows).flatten }.join("\n")
      blank_labels = table_text.scan(/[①②③④]/).uniq
    end
    expected_blank_labels = [8, 11].include?(question.fetch(:question_number)) ? %w[① ② ③] : %w[① ② ③ ④]
    unless blank_labels == expected_blank_labels && choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
      raise "模擬試験15 問#{question.fetch(:question_number)}の空欄と選択肢の対応が不正です"
    end
    if (3..5).cover?(question.fetch(:question_number)) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
      raise "模擬試験15 問#{question.fetch(:question_number)}は抜粋枠の冒頭に条番号を表示してください"
    end
  end

  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験15 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, section = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, "第1部"] : [3, "第2部"]
  elsif prompt.include?("第2章 第10節")
    [0, "第2章第10節"]
  else
    [1, "第3章第7節"]
  end
  unless prompt.include?(section.gsub(/第(\d+)章第(\d+)節/, '第\1章 第\2節')) && source.include?(section) &&
      prompt.include?("解説 情報編") == source.include?("解説 情報編")
    raise "模擬試験15 問#{question.fetch(:question_number)}の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "模擬試験15の問16〜18は指定4範囲から異なる3範囲を資料順に並べてください"
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験15の正答位置はア〜エ各5問にしてください"
end

(6..10).each do |number|
  question = questions.fetch(number - 1)
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && prompt.fetch(:text).include?("からの抜粋である。")
    raise "模擬試験15 問#{number}は原文穴埋め問題にしてください"
  end
end
question_6 = questions.fetch(5)
unless question_6.fetch(:content_blocks).first.fetch(:text).include?("第3款 教育課程の実施と学習評価") && question_6.fetch(:source_text).include?("第1章第3款")
  raise "模擬試験15 問6の出典は第1章総則第3款にしてください"
end

QuestionSeedSync.import(exam_number: 15, questions: questions, publication_status: "published")

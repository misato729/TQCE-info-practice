text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験26（承認済み問3〜11。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "「教育基本法」（平成18年法律第120号）第2条に掲げる教育の目標について述べたものとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "幅広い知識と教養を身に付け，真理を求める態度を養うことに加え，高い教養と専門的能力を培い，新たな知見を創造することを，教育の目標として掲げている。"),
      text_choice.call("イ", "職業及び生活との関連を重視し，勤労を重んずる態度を養うことを掲げている。また，正義と責任，男女の平等，自他の敬愛と協力を重んじ，公共の精神に基づき，主体的に社会の形成に参画する態度を養うことを掲げている。", true),
      text_choice.call("ウ", "伝統と文化を尊重し，我が国と郷土を愛するとともに，他国を尊重することを掲げている。また，各個人の能力を伸ばしつつ社会において自立的に生きる基礎を培うことを，同条の目標として掲げている。"),
      text_choice.call("エ", "生命を尊び，自然を大切にし，環境の保全に寄与する態度を養うことを掲げている。また，人格の完成を目指し，平和で民主的な国家及び社会の形成者として必要な資質を備えた国民を育成することを，同条の目標として掲げている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：前半は第2条第1号と一致する。後半の「高い教養と専門的能力を培う」「新たな知見を創造する」は，第7条第1項が大学について定める内容であり，第2条に列挙された目標ではない。"),
      text_block.call("イ：第2条第2号の職業・生活との関連及び勤労，第3号の正義と責任等及び公共の精神に基づく社会への参画を正しく説明している。"),
      text_block.call("ウ：前半は第2条第5号の内容である。後半の「社会において自立的に生きる基礎を培う」は，第5条第2項が義務教育として行われる普通教育の目的を定めた語句であり，第2条の目標と取り違えている。"),
      text_block.call("エ：前半は第2条第4号の内容である。後半は第1条の教育の目的であり，第2条に列挙された目標と取り違えている。教育として重要かどうかではなく，設問が指定した第2条の規定との対応を判断する。"),
    ],
    source_text: "教育基本法・第1条，第2条，第5条第2項，第7条第1項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_1-At_2",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第71条\n\n{{①}}が設置する中学校及び高等学校においては、{{②}}の定めるところにより、{{③}}に準じて、中学校における教育と高等学校における教育を一貫して{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["同一の設置者","文部科学大臣","義務教育学校","施すものとする"]),
      fill_in_choice.call("イ", ["同一の市町村","都道府県の教育委員会","中等教育学校","施すことができる"]),
      fill_in_choice.call("ウ", ["同一の市町村","都道府県の教育委員会","義務教育学校","施すものとする"]),
      fill_in_choice.call("エ", ["同一の設置者","文部科学大臣","中等教育学校","施すことができる"], true),
    ],
    explanation_blocks: [
      text_block.call("第71条は、同一の設置者による中学校と高等学校で、文部科学大臣の定めるところにより、中等教育学校に準じた一貫教育を行うことができると定めている。設置者を市町村に限定する規定ではなく、国・地方公共団体・学校法人など、同一の設置者による学校が対象となる。"),
      text_block.call("ア：③は「中等教育学校」、④は「施すことができる」。義務教育学校に準じる規定ではなく、同一設置者の中学校・高等学校に一貫教育を一律に課す規定でもない。"),
      text_block.call("イ：①は「同一の設置者」、②は「文部科学大臣」。この条文の対象を同一市町村が設置する学校に限定する文言ではなく、定める主体も都道府県教育委員会ではない。同じ市町村が設置する学校では一貫教育を行えないという意味ではない。"),
      text_block.call("ウ：①〜④が全て原文と異なる。"),
      text_block.call("エ：四つの語句が全て原文と一致する。"),
    ],
    source_text: "学校教育法第71条（令和8年6月17日施行版） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_7-At_71\n学校教育法第2条（設置者に関する解説の根拠） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_1-At_2",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第11条　公立学校の校長の採用（現に校長の職以外の職に任命されている者を校長の職に任命する場合を含む。）並びに教員の採用（現に教員の職以外の職に任命されている者を教員の職に任命する場合を含む。以下この条において同じ。）及び昇任（採用に該当するものを除く。）は、{{①}}によるものとし、その{{①}}は、大学附置の学校にあつては当該大学の{{②}}が、大学附置の学校以外の公立学校（幼保連携型認定こども園を除く。）にあつてはその校長及び教員の任命権者である教育委員会の{{③}}が、大学附置の学校以外の公立学校（幼保連携型認定こども園に限る。）にあつてはその校長及び教員の任命権者である{{④}}が行う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["選考","学長","教育長","地方公共団体の長"], true),
      fill_in_choice.call("イ", ["選考","学長","教育委員","教育委員会の教育長"]),
      fill_in_choice.call("ウ", ["競争試験","教授会","教育長","教育委員会の教育長"]),
      fill_in_choice.call("エ", ["競争試験","教授会","教育委員","地方公共団体の長"]),
    ],
    explanation_blocks: [
      text_block.call("ア：4語句が原文と一致する。公立学校の校長の採用、教員の採用及び昇任は選考による。大学附置の学校では大学の学長、それ以外の公立学校では教育委員会の教育長、幼保連携型認定こども園では地方公共団体の長が、その選考を行う。"),
      text_block.call("イ：①②は正しいが、③は個々の教育委員ではなく「教育長」、④は「地方公共団体の長」である。公立学校の選考主体と、公立の幼保連携型認定こども園の選考主体を区別する。"),
      text_block.call("ウ：③は正しいが、①は「選考」、②は「学長」、④は「地方公共団体の長」。大学附置の学校の選考主体を教授会へ置き換えている点も誤りである。"),
      text_block.call("エ：④は正しいが、①は「選考」、②は「学長」、③は「教育長」である。採用・昇任の方法と、それを行う主体の対応を押さえる。"),
    ],
    source_text: "教育公務員特例法・第11条 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_2-Se_2-At_11",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒のよい点や進歩の状況などを積極的に評価し，学習したことの意義や価値を実感できるようにすること。また，{{①}}の実現に向けた学習状況を把握する観点から，{{②}}を見通しながら評価の場面や方法を工夫して，学習の過程や成果を評価し，{{③}}を図り，資質・能力の育成に生かすようにすること。\n（2）創意工夫の中で学習評価の妥当性や信頼性が高められるよう，組織的かつ計画的な取組を推進するとともに，学年や学校段階を越えて生徒の学習の成果が{{④}}されるように工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["各教科・科目等の目標", "単元や題材など内容や時間のまとまり", "学習内容の定着や学習習慣の確立", "確実に継承"]),
      fill_in_choice.call("イ", ["各教科・科目等の内容", "年間の指導計画や各教科・科目の評価規準", "指導の改善や学習意欲の向上", "円滑に接続"]),
      fill_in_choice.call("ウ", ["各教科・科目等の目標", "単元や題材など内容や時間のまとまり", "指導の改善や学習意欲の向上", "円滑に接続"], true),
      fill_in_choice.call("エ", ["各教科・科目等の内容", "年間の指導計画や各教科・科目の評価規準", "学習内容の定着や学習習慣の確立", "確実に継承"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③④が異なる。評価を生かす先は「指導の改善や学習意欲の向上」であり，学年・学校段階を越えた学習成果は「円滑に接続」されるよう工夫する。"),
      text_block.call("イ：③④は正しいが，①②が異なる。内容の習得だけでなく「各教科・科目等の目標」の実現に向けた学習状況を把握し，「単元や題材など内容や時間のまとまり」を見通すと記されている。"),
      text_block.call("ウ：全て原文と一致する。目標の実現を捉える評価を，内容や時間のまとまりの中で工夫し，指導改善・学習意欲の向上につなげる。学習成果の学校段階間の接続も求めている。"),
      text_block.call("エ：全て原文と異なる。①は目標，②は単元や題材などのまとまり，③は指導改善と学習意欲，④は円滑な接続である。指導計画や評価規準の重要性自体を否定する問題ではなく，抜粋中の位置付けを区別する。"),
    ],
    source_text: "高等学校学習指導要領 第1章 総則 第3款2 学習評価の充実（1）〜（2）（印刷29頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "career_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が，学ぶことと自己の将来とのつながりを見通しながら，社会的・職業的自立に向けて{{①}}を身に付けていくことができるよう，{{②}}を要としつつ各教科・科目等の特質に応じて，キャリア教育の充実を図ること。その中で，生徒が{{③}}を考え主体的に進路を選択することができるよう，学校の教育活動全体を通じ，{{④}}な進路指導を行うこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["必要な基盤となる資質・能力", "特別活動", "自己の在り方生き方", "組織的かつ計画的"], true),
      fill_in_choice.call("イ", ["必要な基盤となる資質・能力", "総合的な探究の時間", "地域社会や産業の動向", "組織的かつ計画的"]),
      fill_in_choice.call("ウ", ["各教科・科目に関する専門的な知識・技能", "特別活動", "地域社会や産業の動向", "段階的かつ継続的"]),
      fill_in_choice.call("エ", ["各教科・科目に関する専門的な知識・技能", "総合的な探究の時間", "自己の在り方生き方", "段階的かつ継続的"]),
    ],
    explanation_blocks: [
      text_block.call("ア：正しい。社会的・職業的自立に向けて必要な基盤となる資質・能力を育成するキャリア教育は，特別活動を要として各教科・科目等の特質に応じて行う。その中で，自己の在り方生き方を考えて進路を主体的に選択できるよう，組織的かつ計画的な進路指導を行う。"),
      text_block.call("イ：①④は正しいが，②③が原文と異なる。要とするのは総合的な探究の時間ではなく特別活動であり，主体的に進路を選択する際に考える対象として記されるのは自己の在り方生き方である。"),
      text_block.call("ウ：②は正しいが，①③④が原文と異なる。育成する対象は必要な基盤となる資質・能力であり，専門的な知識・技能という教科の内容に置き換えない。自己の在り方生き方と，組織的かつ計画的な進路指導が示される。"),
      text_block.call("エ：③は正しいが，①②④が原文と異なる。特別活動を要とするキャリア教育の位置付けと，学校の教育活動全体を通じて行う組織的かつ計画的な進路指導を取り違えている。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第1章第5款1（3）、印刷30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "探究の見方・考え方を働かせ，横断的・総合的な学習を行うことを通して，自己の在り方生き方を考えながら，よりよく課題を発見し解決していくための資質・能力を次のとおり育成することを目指す。\n（1）探究の過程において，{{①}}に必要な知識及び技能を身に付け，{{②}}を形成し，{{③}}を理解するようにする。\n（2）実社会や実生活と自己との関わりから問いを見いだし，自分で課題を立て，情報を集め，整理・分析して，まとめ・表現することができるようにする。\n（3）探究に主体的・協働的に取り組むとともに，{{④}}を生かしながら，新たな価値を創造し，よりよい社会を実現しようとする態度を養う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["課題の発見と解決", "教科固有の概念", "探究の意義や価値", "他者の意見"]),
      fill_in_choice.call("イ", ["知識の習得と活用", "課題に関わる概念", "学習成果の評価方法", "他者の意見"]),
      fill_in_choice.call("ウ", ["知識の習得と活用", "教科固有の概念", "学習成果の評価方法", "互いのよさ"]),
      fill_in_choice.call("エ", ["課題の発見と解決", "課題に関わる概念", "探究の意義や価値", "互いのよさ"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は原文と一致するが，②は「課題に関わる概念」，④は「互いのよさ」である。特定の教科に固有の概念の形成に置き換えず，探究課題に関わる概念を形成する点を押さえる。"),
      text_block.call("イ：②は原文と一致するが，①は「課題の発見と解決」，③は「探究の意義や価値」，④は「互いのよさ」である。知識・技能は課題の発見と解決に必要なものとして示され，評価方法の理解がここでの目標とはされていない。"),
      text_block.call("ウ：④は原文と一致するが，①②③はそれぞれ「課題の発見と解決」「課題に関わる概念」「探究の意義や価値」である。知識・技能の習得だけでなく，概念の形成や探究自体の意義・価値の理解まで含めた目標である。"),
      text_block.call("エ：全て原文と一致する。目標（1）は，課題の発見と解決に必要な知識・技能，課題に関わる概念，探究の意義や価値を一体として示す。目標（3）では互いのよさを生かしながら新たな価値を創造する態度を養う。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第4章 総合的な探究の時間 第1 目標 全文（印刷475頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=477",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育は，教育基本法及び学校教育法に定められた{{①}}に基づき，生徒が{{②}}に努め国家・社会の一員としての自覚に基づき行為しうる発達の段階にあることを考慮し，人間としての在り方生き方を考え，主体的な判断の下に行動し，{{③}}として他者と共によりよく生きるための基盤となる道徳性を養うことを目標とすること。\n\n道徳教育を進めるに当たっては，人間尊重の精神と生命に対する畏敬の念を家庭，学校，その他社会における具体的な生活の中に生かし，豊かな心をもち，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛し，{{④}}を図るとともに，平和で民主的な国家及び社会の形成者として，公共の精神を尊び，社会及び国家の発展に努め，他国を尊重し，国際社会の平和と発展や環境の保全に貢献し未来を拓く主体性のある日本人の育成に資することとなるよう特に留意すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育の根本精神", "自己理解と進路選択", "社会的に自立した職業人", "個性豊かな文化の創造"]),
      fill_in_choice.call("イ", ["教育の根本精神", "自己探求と自己実現", "自立した人間", "個性豊かな文化の創造"], true),
      fill_in_choice.call("ウ", ["教育行政の基本方針", "自己探求と自己実現", "社会的に自立した職業人", "多様な文化の継承"]),
      fill_in_choice.call("エ", ["教育行政の基本方針", "自己理解と進路選択", "自立した人間", "多様な文化の継承"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は原文と一致するが，②③が異なる。高校生の発達段階を捉えるのは「自己探求と自己実現」，育成する人間像は「自立した人間」である。進路選択や職業人の自立への置換ではない。"),
      text_block.call("イ：全て原文と一致する。教育の根本精神を踏まえ，自己探求・自己実現に努める発達段階を考慮し，自立した人間として他者と生きる基盤となる道徳性を養う。文化については継承だけでなく個性豊かな文化の創造を図ると記される。"),
      text_block.call("ウ：①③④が異なる。①は「教育の根本精神」，③は「自立した人間」，④は「個性豊かな文化の創造」である。教育行政の基本方針・職業人という人間像・文化の継承に置き換えない。"),
      text_block.call("エ：①②④が異なる。教育の根本精神，自己探求と自己実現，個性豊かな文化の創造が原語である。進路指導と道徳教育の基盤，伝統・文化の尊重と個性豊かな創造の位置付けを区別する。"),
    ],
    source_text: "第1章 総則 第1款2(2)第2・第3段落（PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』（平成30年7月文部科学省）の「第4章 指導計画の作成と内容の取扱い 第2節 内容の取扱いについての配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特別活動の目標に明示されているように，「{{①}}な活動」を行うことは，特別活動の全ての内容に共通している。その上で，「{{②}}な活動」は，「{{①}}」であることに加えて，目的をもって編制された集団において，生徒が自ら課題等を見いだし，その解決方法などについての{{③}}を図り，協力して目標を達成していくものである。生徒の{{②}}な活動を特質としている内容は，ホームルーム活動の「（1）ホームルームや学校における生活づくりへの参画」及び生徒会活動である。\n\nこれに対して，ホームルーム活動の「（2）日常の生活や学習への適応と自己の成長及び健康安全」と「（3）一人一人のキャリア形成と自己実現」及び学校行事は，教師の指導を中心とした生徒の{{①}}活動を特質とする内容である。これらの活動や学校行事は，年間指導計画に沿ってねらいや具体的な活動が設定され，自分に合った解決方法を{{④}}する。ホームルームや学校として実践することを，生徒が提案し，{{③}}を図ることによって決める「{{②}}な活動」とは異なる学習過程となる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自主的，実践的", "自発的，自治的", "意思決定", "合意形成"]),
      fill_in_choice.call("イ", ["自発的，自治的", "自主的，実践的", "合意形成", "意思決定"]),
      fill_in_choice.call("ウ", ["自主的，実践的", "自発的，自治的", "合意形成", "意思決定"], true),
      fill_in_choice.call("エ", ["自発的，自治的", "自主的，実践的", "意思決定", "合意形成"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③④が逆である。ホームルームや学校として実践する課題の解決は集団の合意形成，ホームルーム活動（2）（3）などにおいて自分に合った解決方法を決めることは意思決定として示されている。"),
      text_block.call("イ：③④は正しいが，①②が逆である。全ての内容に共通するのは自主的，実践的な活動であり，自発的，自治的な活動を特質とする内容は，ホームルーム活動（1）及び生徒会活動である。"),
      text_block.call("ウ：正しい。全ての内容に共通する自主的，実践的な活動と，生徒が自ら課題を見いだして集団として合意形成する自発的，自治的な活動を区別している。個人の解決方法を決める場合には意思決定を用いる。"),
      text_block.call("エ：①②と③④の双方が逆である。自発的，自治的な活動を全ての内容に共通するものとして扱わず，集団の合意形成と個人の意思決定も区別する必要がある。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 特別活動編・第4章第2節1（1）、印刷115頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=123",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "教職員が児童生徒や学級・ホームルームの実態に応じて、{{①}}という観点から、学校生活への適応やよりよい人間関係の形成、学習活動や進路等における主体的な取組や選択及び自己の生き方などに関して、全ての児童生徒に、組織的・計画的に情報提供や説明を行います。場合によっては、社会性の発達を支援するプログラム（ソーシャル・スキル・トレーニングやソーシャル・エモーショナル・ラーニング等）などを実施します。\n\nまた、{{②}}という観点からは、児童生徒一人一人の生活や人間関係などに関する悩みや迷いなどを受け止め、自己の可能性や適性についての自覚を深めるように働きかけたり、適切な情報を提供したりしながら、児童生徒が自らの意志と責任で選択、決定することができるようにするための相談・助言等を個別に行います。\n\n{{①}}と{{②}}は、教員、SC、SSW等が協働して行う生徒指導において、児童生徒の{{③}}を促し、一人一人の発達を支える働きかけの両輪として捉えることができます。" },
      { type: "text", text: "注：SCはスクールカウンセラー，SSWはスクールソーシャルワーカーを表す。ソーシャル・エモーショナル・ラーニングは「社会性と情動の学習」を指す。本文の脚注参照記号は省いている。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["ガイダンス", "カウンセリング", "社会的資質・能力の発達"]),
      fill_in_choice.call("イ", ["ガイダンス", "カウンセリング", "行動や意識の変容"], true),
      fill_in_choice.call("ウ", ["カウンセリング", "ガイダンス", "行動や意識の変容"]),
      fill_in_choice.call("エ", ["カウンセリング", "ガイダンス", "社会的資質・能力の発達"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③が異なる。両者の働きかけは原文で『行動や意識の変容』を促すと説明される。『社会的資質・能力の発達』は同書の生徒指導の目的に現れる概念だが，この文が述べる働きかけの原語と置き換えない。"),
      text_block.call("イ：全て原文と一致する。ガイダンスは全ての児童生徒に組織的・計画的に情報を提供する働きかけ，カウンセリングは一人一人の悩みを受け止め，主体的な選択・決定を支える個別の相談・助言として説明される。両者は行動や意識の変容を促す両輪である。"),
      text_block.call("ウ：③は正しいが，①②が逆である。集団への組織的・計画的な情報提供と，個別の相談・助言との対応を取り違えている。末尾で二つの名称を並べる順序そのものを問うのではない。"),
      text_block.call("エ：①②が逆で，③も異なる。全体への情報提供と個別の相談・助言を区別する。生徒指導の目的としての社会的資質・能力の発達と，両者が促す行動や意識の変容の位置付けも区別する。"),
    ],
    source_text: "『生徒指導提要』第1章1.3.3「ガイダンスとカウンセリング」，教職員が実態に応じて行う支援の説明から同節末尾まで（印刷26〜27頁／PDF29〜30頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=29\n同書 第1章1.1.1（2）生徒指導の目的（誤答③の概念照合，印刷13頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=16",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (3..11).to_a
  raise "承認済みの問番号は3〜11です"
end

categories = {
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "career_education",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
  11 => "student_guidance_career",
}
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == categories.fetch(number)
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  if number <= 5 && (number >= 4 || choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt = blocks.first
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = number >= 4 ? prompt.fetch(:text).include?("空欄 ① ～ ④") : prompt_labels == %w[① ④]
    unless labels == %w[① ② ③ ④] && prompt[:type] == "fill_in_text" && introduction_labels_match &&
        quotes.any? && quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
      raise "問#{number}の条番号・空欄と選択肢の対応が不正です"
    end
  elsif number >= 6
    count = number == 11 ? 3 : 4
    expected_labels = %w[① ② ③ ④].first(count)
    table_question = false
    labels = if table_question
      blocks.select { |block| block[:type] == "table" }.flat_map { |block| block.fetch(:rows).flatten.join.scan(/【([①②③④])】/).flatten }.uniq
    else
      quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    end
    prompt = blocks.first
    prompt_labels = table_question ? expected_labels : [expected_labels.first, expected_labels.last]
    unless quotes.size == 1 && labels == expected_labels && prompt[:type] == "fill_in_text" &&
        prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq == prompt_labels &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == count }
      raise "問#{number}の抜粋・空欄と選択肢の対応が不正です"
    end
    if number == 6 && !(prompt.fetch(:text).include?("第1章 総則 第3款 教育課程の実施と学習評価") && question.fetch(:source_text).include?("第3款"))
      raise "問6は総則第3款から出題してください"
    end
    if number == 11 && !prompt.fetch(:text).start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
      raise "問11の資料名・書き出しが不正です"
    end
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 部分seedはdraftで保存するが、承認済み問題の内容は公開時と同じ品質で検査する。
  entry = { exam_number: 26, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(26, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 26, questions: questions, publication_status: "draft")

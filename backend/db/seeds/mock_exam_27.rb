text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験27（承認済み問3〜11。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第5条 義務教育」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第5条　国民は、その保護する子に、別に法律で定めるところにより、{{①}}を受けさせる義務を負う。\n\n２　義務教育として行われる{{①}}は、各個人の有する能力を伸ばしつつ社会において{{②}}生きる基礎を培い、また、国家及び社会の形成者として必要とされる基本的な資質を養うことを目的として行われるものとする。\n\n３　国及び地方公共団体は、義務教育の機会を保障し、その水準を確保するため、適切な役割分担及び相互の協力の下、その{{③}}に責任を負う。\n\n４　国又は地方公共団体の設置する学校における義務教育については、{{④}}を徴収しない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["普通教育","主体的に","普及","授業料"]),
      fill_in_choice.call("イ", ["高等普通教育","自立的に","普及","入学料"]),
      fill_in_choice.call("ウ", ["高等普通教育","主体的に","実施","入学料"]),
      fill_in_choice.call("エ", ["普通教育","自立的に","実施","授業料"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は一致する。②は「自立的に」，③は「実施」である。義務教育の目的として自立的に生きる基礎を培い，国及び地方公共団体は義務教育の実施に責任を負うと定めている。"),
      text_block.call("イ：②は一致する。①は「普通教育」，③は「実施」，④は「授業料」である。第5条が国民に受けさせる義務を課すのは普通教育であり，第4項が徴収しないと明記しているのは授業料である。"),
      text_block.call("ウ：③は一致する。①は「普通教育」，②は「自立的に」，④は「授業料」である。"),
      text_block.call("エ：四つとも原文と一致する。①は第1項と第2項に共通し，教育基本法第5条の語句は「普通教育」である。第4項の「授業料」を，教育に必要な費用一般が全て無償となる意味へ広げない。"),
    ],
    source_text: "教育基本法・第5条第1項〜第4項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_5",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第34条\n\n小学校においては、文部科学大臣の検定を経た教科用図書又は文部科学省が著作の名義を有する教科用図書を使用しなければならない。\n\n２　前項に規定する教科用図書（以下この条において「教科用図書」という。）の内容を文部科学大臣の定めるところにより記録した電磁的記録（電子的方式、磁気的方式その他人の知覚によつては認識することができない方式で作られる記録であつて、電子計算機による情報処理の用に供されるものをいう。）である教材がある場合には、同項の規定にかかわらず、文部科学大臣の定めるところにより、児童の教育の充実を図るため必要があると認められる{{①}}において、教科用図書に代えて当該教材を使用することができる。\n\n３　前項に規定する場合において、視覚障害、発達障害その他の文部科学大臣の定める事由により教科用図書を使用して学習することが困難な児童に対し、教科用図書に用いられた{{②}}その他の同項に規定する教材を電子計算機において用いることにより可能となる方法で指導することにより当該児童の学習上の困難の程度を{{③}}させる必要があると認められるときは、文部科学大臣の定めるところにより、{{④}}において、教科用図書に代えて当該教材を使用することができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育課程の一部","文字、図形等の拡大又は音声への変換","低減","教育課程の全部又は一部"], true),
      fill_in_choice.call("イ", ["教育課程の一部","文字、図形等の削減又は学習内容の簡素化","軽減","教育課程の全部又は一部"]),
      fill_in_choice.call("ウ", ["教育課程の全部又は一部","文字、図形等の拡大又は音声への変換","低減","教育課程の一部"]),
      fill_in_choice.call("エ", ["教育課程の全部又は一部","文字、図形等の削減又は学習内容の簡素化","軽減","教育課程の一部"]),
    ],
    explanation_blocks: [
      text_block.call("第2項の一般的な取扱いは「教育課程の一部」である。第3項は、教科用図書を使用して学習することが困難な児童について、拡大や音声への変換等で困難の程度を低減させる必要があると認められる場合に、「教育課程の全部又は一部」で代替教材を使用できると定める。学習内容を削減・簡素化することを定めた規定ではない。「軽減」は意味の近い語だが、原文の語句は「低減」である。"),
      text_block.call("ア：四つの語句が全て原文と一致する。"),
      text_block.call("イ：②は「文字、図形等の拡大又は音声への変換」、③は「低減」。教材へのアクセス方法の変更を、学習内容の削減・簡素化へ置き換えている。③は意味の近い「軽減」ではなく、原文の「低減」を入れる。"),
      text_block.call("ウ：①は「教育課程の一部」、④は「教育課程の全部又は一部」。一般の場合と、学習上の困難に対応する場合の適用範囲を逆にしている。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第34条は第62条により高等学校にも準用される。抜粋は準用元の原文なので「小学校」「児童」の表記を維持している。"),
    ],
    source_text: "学校教育法第34条第1〜3項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_34\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：「指標」は、校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する指標を指す。" },
      { type: "fill_in_quote", text: "第22条の7　公立の小学校等の校長及び教員の{{①}}は、指標の策定に関する協議並びに当該指標に基づく当該校長及び教員の資質の向上に関して必要な事項についての協議を行うための{{②}}（以下この条において「{{②}}」という。）を組織するものとする。\n\n２　{{②}}は、次に掲げる者をもつて構成する。\n\n一　指標を策定する{{①}}\n\n二　公立の小学校等の校長及び教員の研修に協力する大学その他の当該校長及び教員の資質の向上に関係する大学として{{③}}で定める者\n\n三　その他当該{{①}}が必要と認める者\n\n３　{{②}}において協議が調つた事項については、{{②}}の構成員は、その協議の結果を{{④}}。\n\n４　前三項に定めるもののほか、{{②}}の運営に関し必要な事項は、{{②}}が定める。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者","審議会","文部科学省令","遵守しなければならない"]),
      fill_in_choice.call("イ", ["任命権者","協議会","文部科学省令","尊重しなければならない"], true),
      fill_in_choice.call("ウ", ["研修実施者","審議会","政令","尊重しなければならない"]),
      fill_in_choice.call("エ", ["研修実施者","協議会","政令","遵守しなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は正しいが、②は「協議会」、④は「尊重しなければならない」。第3項が定めるのは協議の結果を尊重する義務であり、原文を「遵守」へ強めて置き換えることはできない。"),
      text_block.call("イ：4語句が原文と一致する。任命権者が協議会を組織し、その任命権者、所定の大学、その他必要と認める者で構成する。協議が調つた事項の結果は構成員が尊重し、運営に関する事項は協議会自身が定める。"),
      text_block.call("ウ：④は正しいが、①は「任命権者」、②は「協議会」、③は「文部科学省令」。研修を実施する役割と、指標の策定などを協議する組織を設ける役割を取り違えている。"),
      text_block.call("エ：②は正しいが、①は「任命権者」、③は「文部科学省令」、④は「尊重しなければならない」である。"),
    ],
    source_text: "教育公務員特例法・第22条の7、第22条の3第1項（補足） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22_7",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報活用能力の育成を図るため，各学校において，{{①}}などの情報手段を活用するために必要な環境を整え，これらを適切に活用した学習活動の充実を図ること。また，各種の統計資料や新聞，{{②}}などの{{③}}の適切な活用を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["コンピュータや情報通信ネットワーク", "参考図書や学習用プリント", "学習資料・学習資源"]),
      fill_in_choice.call("イ", ["インターネットや学習支援ソフト", "視聴覚教材や教育機器", "学習資料・学習資源"]),
      fill_in_choice.call("ウ", ["インターネットや学習支援ソフト", "参考図書や学習用プリント", "教材・教具"]),
      fill_in_choice.call("エ", ["コンピュータや情報通信ネットワーク", "視聴覚教材や教育機器", "教材・教具"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①は正しいが，②③が異なる。統計資料や新聞とともに挙げられているのは「視聴覚教材や教育機器」であり，これらを「教材・教具」として適切に活用すると記されている。"),
      text_block.call("イ：②は正しいが，①③が異なる。環境を整えて活用する情報手段の例は「コンピュータや情報通信ネットワーク」である。後半の教材等の位置付けは「教材・教具」であり，学習資源という語への置換ではない。"),
      text_block.call("ウ：③は正しいが，①②が異なる。前半の情報手段としてコンピュータ・情報通信ネットワーク，後半の教材・教具の例として視聴覚教材・教育機器が挙げられている。"),
      text_block.call("エ：全て原文と一致する。情報手段の利用環境を整えて学習活動を充実させることと，統計資料・新聞・視聴覚教材・教育機器などの教材・教具を活用することが示されている。"),
    ],
    source_text: "高等学校学習指導要領 第1章 総則 第3款1（3），情報活用能力の育成から始まる連続範囲（印刷28頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ア 海外から帰国した生徒などについては，{{①}}を図るとともに，外国における生活経験を生かすなどの適切な指導を行うものとする。\n\nイ 日本語の習得に困難のある生徒については，{{②}}に応じた指導内容や指導方法の工夫を組織的かつ計画的に行うものとする。\n\nウ 日本語の修得に困難のある生徒に対して，学校教育法施行規則第86条の２の規定に基づき，特別の教育課程を編成し，日本語の能力に応じた特別の指導（以下「通級による日本語指導」という。）を行う場合には，{{③}}に努め，{{④}}などにより，効果的な指導に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校生活への適応", "学校全体の指導方針", "教師間の連携", "指導についての計画を学年ごとに作成すること"]),
      fill_in_choice.call("イ", ["日本語の能力の向上", "個々の生徒の実態", "家庭や地域との連携", "指導についての計画を個別に作成すること"]),
      fill_in_choice.call("ウ", ["学校生活への適応", "個々の生徒の実態", "教師間の連携", "指導についての計画を個別に作成すること"], true),
      fill_in_choice.call("エ", ["日本語の能力の向上", "学校全体の指導方針", "家庭や地域との連携", "指導についての計画を学年ごとに作成すること"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は正しいが，②④が原文と異なる。日本語の習得に困難がある生徒には個々の生徒の実態に応じた工夫を行う。通級による日本語指導の計画は学年ごとではなく個別に作成することが示される。"),
      text_block.call("イ：②④は正しいが，①③が原文と異なる。海外から帰国した生徒などについて図るものは学校生活への適応であり，通級による日本語指導の箇所では教師間の連携が示される。家庭や地域との連携が一般に不要という意味ではない。"),
      text_block.call("ウ：正しい。帰国生徒の学校生活への適応，日本語の習得に困難がある生徒の個々の実態に応じた工夫，通級による日本語指導での教師間の連携と個別の指導計画を区別している。"),
      text_block.call("エ：①〜④がいずれも原文と異なる。帰国生徒への対応を日本語能力の向上に置き換えず，日本語指導も学校や学年の一般的な方針ではなく個々の実態に即した計画を用いる。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第1章第5款2（2）ア・イ・ウ第1段落、印刷31頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第10章 総合的な探究の時間の評価 第2節 生徒の学習状況の評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "総合的な探究の時間における生徒の具体的な学習状況の評価の方法については，{{①}}評価の方法であること，{{②}}評価の方法であること，{{③}}を評価する方法であること，の三つが重要である。\n第1に，{{①}}評価とするためには，教師の適切な判断に基づいた評価が必要であり，著しく異なったり偏ったりすることなく，およそどの教師も同じように判断できる評価が求められる。例えば，あらかじめ{{④}}において，評価の観点や評価規準を確認しておき，これに基づいて生徒の学習状況を評価するなどが考えられる。この場合には，各学校において定められた評価の観点を，一単位時間で全て評価しようとするのではなく，年間や，単元などの内容のまとまりを通して，一定程度の時間数の中において評価を行うように心がける必要がある。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["信頼される", "多面的な", "学習状況の過程", "指導する教師間"], true),
      fill_in_choice.call("イ", ["信頼される", "継続的な", "学習状況の結果", "指導する教師間"]),
      fill_in_choice.call("ウ", ["客観的な", "多面的な", "学習状況の結果", "生徒と教師との間"]),
      fill_in_choice.call("エ", ["客観的な", "継続的な", "学習状況の過程", "生徒と教師との間"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。具体的な評価方法の要点は，信頼されること，多面的であること，過程を評価することである。教師間で評価の観点や評価規準を確認し，判断の著しい偏りを防ぐことが説明されている。"),
      text_block.call("イ：①④は一致するが，②は「多面的な」，③は「学習状況の過程」である。継続的に評価することや結果を捉えることも一般には重要だが，この箇所で示される三つの要点の原語とは異なる。"),
      text_block.call("ウ：②は一致するが，①は「信頼される」，③は「学習状況の過程」，④は「指導する教師間」である。ここでの事前の規準確認は，教師間の評価判断をそろえるための説明であり，生徒と教師との確認を記した箇所ではない。"),
      text_block.call("エ：③は一致するが，①②④はそれぞれ「信頼される」「多面的な」「指導する教師間」である。「どの教師も同じように判断できる」ことと，そのための教師間の規準確認を対応させる。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編 第10章 総合的な探究の時間の評価 第2節 生徒の学習状況の評価 2 評価規準の設定と評価方法の工夫改善，具体的な評価方法の三点と第1の説明（印刷135頁） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=143",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する{{①}}についての理解を基にしながら，様々な{{②}}の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，自立心や自律性を高め，規律ある生活をすること，生命を尊重する心を育てること，{{③}}を高め，主体的に社会の形成に参画する意欲と態度を養うこと，義務を果たし責任を重んずる態度及び{{④}}態度を養うこと，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛するとともに，他国を尊重すること，国際社会に生きる日本人としての自覚を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["道徳的諸価値", "観察や実験", "社会連帯の自覚", "勤労を尊重し経済的に豊かな社会を実現しようとする"]),
      fill_in_choice.call("イ", ["社会生活の諸規則", "体験や思索", "勤労観や職業観", "人権を尊重し差別のないよりよい社会を実現しようとする"]),
      fill_in_choice.call("ウ", ["社会生活の諸規則", "観察や実験", "勤労観や職業観", "勤労を尊重し経済的に豊かな社会を実現しようとする"]),
      fill_in_choice.call("エ", ["道徳的諸価値", "体験や思索", "社会連帯の自覚", "人権を尊重し差別のないよりよい社会を実現しようとする"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②④が異なる。道徳的諸価値の理解を人間としての在り方生き方へ深める機会として挙げるのは「体験や思索」であり，観察や実験ではない。④は「人権を尊重し差別のないよりよい社会を実現しようとする」で，勤労と経済的な豊かさへの置換は原文と異なる。"),
      text_block.call("イ：①③が異なる。四つの関わりに関する理解の対象は「道徳的諸価値」であり，社会生活の諸規則へ置き換えない。社会の形成への主体的参画につながる原語は「社会連帯の自覚」で，「勤労観や職業観」はこの箇所の原語ではない。"),
      text_block.call("ウ：全て原文と異なる。①は「道徳的諸価値」，②は「体験や思索」，③は「社会連帯の自覚」，④は「人権を尊重し差別のないよりよい社会を実現しようとする」である。規則の理解・科学的な調査活動・職業観・経済的な豊かさに，この抜粋の四つの位置付けを置き換えている。"),
      text_block.call("エ：全て原文と一致する。中学校までに深めた道徳的諸価値の理解を基に，体験や思索を通して考えを深める。社会連帯と社会形成への参画，人権尊重と差別のない社会の実現を対応させている。"),
    ],
    source_text: "第1章 総則 第7款2全文（PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第2 各活動・学校行事の目標及び内容〔学校行事〕」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）儀式的行事\n学校生活に有意義な変化や折り目を付け，{{①}}気分を味わい，新しい生活の展開への動機付けとなるようにすること。\n\n（2）文化的行事\n平素の学習活動の成果を発表し，{{②}}の意欲を一層高めたり，文化や芸術に親しんだりするようにすること。\n\n（3）健康安全・体育的行事\n心身の健全な発達や健康の保持増進，事件や事故，災害等から身を守る安全な行動や規律ある集団行動の体得，運動に親しむ態度の育成，{{③}}の涵養，{{④}}などに資するようにすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["厳粛で清新な", "自己の向上", "公共の精神や奉仕の精神", "競技技能の向上"]),
      fill_in_choice.call("イ", ["厳粛で清新な", "自己の向上", "責任感や連帯感", "体力の向上"], true),
      fill_in_choice.call("ウ", ["穏やかで親密な", "社会貢献", "責任感や連帯感", "競技技能の向上"]),
      fill_in_choice.call("エ", ["穏やかで親密な", "社会貢献", "公共の精神や奉仕の精神", "体力の向上"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③④が原文と異なる。健康安全・体育的行事は責任感や連帯感の涵養，体力の向上などに資するようにする。公共の精神や奉仕の精神，競技技能の向上に置き換えてはいけない。"),
      text_block.call("イ：正しい。儀式的行事は厳粛で清新な気分と新しい生活への動機付け，文化的行事は学習成果の発表と自己の向上の意欲，健康安全・体育的行事は責任感や連帯感及び体力の向上などが示されている。"),
      text_block.call("ウ：③は正しいが，①②④が原文と異なる。儀式的行事は穏やかで親密な気分ではなく厳粛で清新な気分，文化的行事は社会貢献ではなく自己の向上の意欲，健康安全・体育的行事は競技技能ではなく体力の向上と記される。"),
      text_block.call("エ：④は正しいが，①②③が原文と異なる。儀式的行事の気分，文化的行事が高める意欲，健康安全・体育的行事で涵養する態度の対応をそれぞれ取り違えている。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第5章第2〔学校行事〕2（1）〜（3）、印刷480頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=482",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "課題早期発見対応では、課題の予兆行動が見られたり、問題行動のリスクが高まったりするなど、{{①}}を対象に、深刻な問題に発展しないように、初期の段階で諸課題を発見し、対応します。例えば、ある時期に成績が急落する、遅刻・早退・欠席が増える、身だしなみに変化が生じたりする児童生徒に対して、いじめや不登校、自殺などの深刻な事態に至らないように、早期に{{②}}などを行い、実態に応じて迅速に対応します。\n\n特に、早期発見では、いじめアンケートのような{{③}}に基づくスクリーニングテストや、SCやスクールソーシャルワーカー（以下「SSW」という。）を交えたスクリーニング会議によって気になる児童生徒を早期に見いだして、指導・援助につなげます。" },
      { type: "text", text: "注：SCはスクールカウンセラーを表す。原文の脚注参照記号[*7]は省いている。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["気になる一部の児童生徒", "個別の学習支援や進路指導", "質問紙"]),
      fill_in_choice.call("イ", ["深刻な課題を抱える特定の児童生徒", "教育相談や家庭訪問", "個別面接"]),
      fill_in_choice.call("ウ", ["深刻な課題を抱える特定の児童生徒", "個別の学習支援や進路指導", "個別面接"]),
      fill_in_choice.call("エ", ["気になる一部の児童生徒", "教育相談や家庭訪問", "質問紙"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②が異なる。原文は，予兆のある児童生徒に対して早期に行う対応として『教育相談や家庭訪問』を挙げている。個別の学習支援や進路指導が不適切だという意味ではなく，この抜粋の例示との相違である。"),
      text_block.call("イ：①③が異なる。課題早期発見対応の対象は『気になる一部の児童生徒』であり，深刻な課題を抱える特定の児童生徒への対応と区別する。また，いじめアンケートのような『質問紙』に基づくスクリーニングテストを挙げている。"),
      text_block.call("ウ：全て異なる。対象は予兆や高まるリスクが見られる一部の児童生徒，例示された初期対応は教育相談や家庭訪問，早期発見の手段は質問紙に基づくスクリーニングテストである。"),
      text_block.call("エ：全て原文と一致する。課題の予兆を捉えた対象の選定，実態に応じた早期の対応，質問紙や専門職を交えた会議による早期発見をつなげている。"),
    ],
    source_text: "『生徒指導提要』（令和4年12月）第1章1.2.4『課題予防的生徒指導：課題早期発見対応』第1・第2段落、印刷21頁（PDF24頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=24",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (3..11).to_a
  raise "承認済みの問番号は3〜11です"
end

categories = {
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "curriculum_organization",
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
    count = [6, 11].include?(number) ? 3 : 4
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
  entry = { exam_number: 27, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(27, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 27, questions: questions, publication_status: "draft")

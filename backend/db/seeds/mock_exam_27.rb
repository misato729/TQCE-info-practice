text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験27（承認済みの全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "日本の学校教育における教授法の導入及び教育実践に関する次の①～④の出来事を，起こった時期が早いものから順に並べたものとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("①　ヘルバルト派の教授理論の影響が強まり，既有の知識と新しい教材とを関連付けながら授業を進める五段階の形式的教授法が普及した。"),
      text_block.call("②　澤柳政太郎が成城小学校を創設し，個性尊重，自然と親しむ教育，心情の教育，科学的研究を基とする教育を掲げ，教育の実際に即した研究を進めた。"),
      text_block.call("③　米国のオスウィーゴー師範学校で学んだ高嶺秀夫が帰国し，東京師範学校などでペスタロッチ主義を伝え，開発主義教授法の研究と普及が進んだ。"),
      text_block.call("④　東京に創設された文部省直轄の師範学校にスコットが招かれ，学級を単位とする一斉教授や，実物を用いる教授の方法が取り入れられた。"),
    ],
    choices: [
      text_choice.call("ア", "④ → ① → ③ → ②"),
      text_choice.call("イ", "④ → ③ → ① → ②", true),
      text_choice.call("ウ", "③ → ④ → ① → ②"),
      text_choice.call("エ", "④ → ③ → ② → ①"),
    ],
    explanation_blocks: [
      text_block.call("④は明治5年（1872年）に設立された師範学校でのスコットの指導，③は明治11年（1878年）の高嶺の帰国とその後の開発主義教授法の展開である。"),
      text_block.call("①のヘルバルト主義は明治20〜30年代に広がった。②の成城小学校の創設は大正6年（1917年）である。したがって④ → ③ → ① → ②。"),
      text_block.call("ア：高嶺の帰国後の開発主義の展開と，後のヘルバルト派の普及の順序を逆にしている。"),
      text_block.call("イ：正しい。"),
      text_block.call("ウ：学制期のスコットの指導と，高嶺の帰国後の活動の順序を逆にしている。"),
      text_block.call("エ：明治期のヘルバルト派の普及を，大正期の成城小学校創設より後にしている。"),
    ],
    source_text: "文部科学省『学制百年史』「三 小学校教育の内容と方法」・スコットと教育方法の改革／教育方法の進歩と開発主義教授法 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317589.htm\n川瀬八洲夫「H.スペンサーの教育思想―我国における受容の諸問題を中心にして―」145頁 | https://tokyo-kasei.repo.nii.ac.jp/record/11187/files/2011_k_0131.pdf\n奥山和夫「情意的学習法の理論とその試み」『共栄学園短期大学研究紀要』16（2000年）、表1 | https://kyoei.repo.nii.ac.jp/record/484/files/KJ00000173172.pdf\n成城学園「建学の精神」・創設時の四綱領 | https://www.seijogakuen.ed.jp/thought/founders-vision/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "教育思想及び教育実践について述べた次の①～④の記述と，それぞれに該当する人物の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("①　『児童の世紀』を著し，子どもの自然な本性や個性を尊重することを求めた。画一的な学校教育を批判し，子どもの成長を支える家庭とそこでの生活の意義を重視した。"),
      text_block.call("②　医学的な観察を教育に生かし，「子どもの家」で実践を行った。子どもが活動を選び，誤りにも自ら気付いて修正できる教具などを用いながら成長するための環境を整えた。"),
      text_block.call("③　識字教育などに取り組み，学習者に知識を預け入れる「銀行型教育」を批判した。対話と，省察・行動を結び付けることを重視し，学習者が現実を捉え直す主体になることを求めた。"),
      text_block.call("④　『教育論』において，教育を完全な生活への準備として捉えた。生活を構成する諸活動に照らして知識の価値を比較し，科学的知識の教育上の価値を重視した。"),
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["①", "②", "③", "④"], rows: [["モンテッソーリ","エレン・ケイ","スペンサー","フレイレ"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["①", "②", "③", "④"], rows: [["エレン・ケイ","モンテッソーリ","スペンサー","フレイレ"]] }], correct: false },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["①", "②", "③", "④"], rows: [["エレン・ケイ","モンテッソーリ","フレイレ","スペンサー"]] }], correct: true },
      { label: "エ", content_blocks: [{ type: "table", headers: ["①", "②", "③", "④"], rows: [["モンテッソーリ","エレン・ケイ","フレイレ","スペンサー"]] }], correct: false },
    ],
    explanation_blocks: [
      text_block.call("①はエレン・ケイ，②はモンテッソーリ，③はフレイレ，④はスペンサーである。"),
      text_block.call("ア：①と②，③と④の双方の対応を逆にしている。"),
      text_block.call("イ：①と②は正しいが，銀行型教育を批判したフレイレと，完全生活への準備を論じたスペンサーを逆にしている。"),
      text_block.call("ウ：全ての対応が正しい。"),
      text_block.call("エ：③と④は正しいが，『児童の世紀』のエレン・ケイと，「子どもの家」で実践したモンテッソーリを逆にしている。"),
    ],
    source_text: "岡部美香「ユートピア空間としての〈家庭〉―エレン・ケイ『児童の世紀』の再考察―」『大阪大学教育学年報』2（1997年）、131頁ほか | https://ir.library.osaka-u.ac.jp/repo/ouka/all/5974/aes02-131.pdf\n広島文教大学附属幼稚園「モンテッソーリ教育」 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html\n原安利「パウロ・フレイレの教育論における『対話』に関する一考察」『教育実践学論集』12（2011年）、99〜112頁、特に106頁 | https://hyogo-u.repo.nii.ac.jp/record/2692/files/AA114330270120009.pdf\n川瀬八洲夫「H.スペンサーの教育思想―我国における受容の諸問題を中心にして―」147頁 | https://tokyo-kasei.repo.nii.ac.jp/record/11187/files/2011_k_0131.pdf",
  },
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
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("次の①～④は，視覚障害のある生徒の情報の把握と概念の形成に関する記述である。適切なものの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("① 対象物を表す言葉の意味を説明できる場合には，その対象物の形や構造を経験に結び付けて理解していると捉える。語の定義を説明する正確さを，対象物の全体像を把握する程度の指標とする。"),
      text_block.call("② 触覚や保有する視覚を用い，対象物の形，大きさ，手触り，構造や機能を確かめられるようにする。そこで形成した概念を，日常の学習や生活で活用できるように指導する。"),
      text_block.call("③ 音声による説明は，一度に全体像と各部分の関係を把握できるという特性がある。位置や方向を伝える際は，情報を詳しく一括して示すことで，記憶をたどって統合する負担を軽減する。"),
      text_block.call("④ 音声情報では，一つ一つの情報をつなぎ合わせ，全体像を捉えることが必要になる。言葉で伝える内容の本質的な部分を選んで強調し，具体的な事物や動作と言葉の意味を結び付ける。"),
    ],
    choices: [
      text_choice.call("ア", "①・②"),
      text_choice.call("イ", "②・④", true),
      text_choice.call("ウ", "①・③"),
      text_choice.call("エ", "③・④"),
    ],
    explanation_blocks: [
      text_block.call("ア：①が誤り。言葉を説明できることと，対象物の形・構造等を具体的に理解していることは同じではない。経験と概念の結び付きを確かめる必要がある。②は適切。"),
      text_block.call("イ：②・④とも適切。直接的な観察で概念の形成を支え，音声情報を順に統合する負担にも配慮する。"),
      text_block.call("ウ：①・③が誤り。①は語の説明と具体的な概念の形成を同一視している。③は視覚映像で全体と部分を捉える過程と，音声情報をつなぎ合わせる過程を取り違えている。"),
      text_block.call("エ：③が誤り。音声の説明量を増やして一括提示することが，情報を記憶し統合する負担の軽減になるとする点が誤り。④は適切。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅰ「視覚障害」1(2)②ア(イ)及びイ(イ)（69〜70頁、分割PDF10〜11ページ） | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_05.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エリクソンの同一性（アイデンティティ）の考え方を踏まえた青年期とその後の発達に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "青年期には，進路や価値観を検討する中で，自分が何者であり，何をなすべきかという問題に直面する。これまでの自分の在り方を捉え直し，将来どのように生きるかを検討することが，同一性の形成に関わる。"),
      text_choice.call("イ", "同一性は青年期の重要な発達課題であるが，成人期以降にも捉え直される。仕事や家庭などで担う役割が変わる中で，自分の生き方を考え直すことは，同一性の再構築に関わる。"),
      text_choice.call("ウ", "青年期には，職業や価値観の選択を通して同一性を検討する。成人期以降の仕事や家庭での役割の選び直しは，形成された同一性を生活に適用する課題であり，同一性を再構築する発達過程とは別の課題として区分される。", true),
      text_choice.call("エ", "青年期に進路を決めようとして迷うことは，自己の在り方を問い直す過程に関わる。同一性の形成を考える際には，進路の決定という結果とともに，自分が大切にする価値や将来の見通しも問題になる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。青年期には，これまでの自分を捉え直し，進路や価値観を検討することが同一性の形成に関わる。"),
      text_block.call("イ：適切。同一性は青年期に重要である一方，成人期，中年期，老年期にも再構築されるものとして理解される。"),
      text_block.call("ウ：不適切。成人期以降の役割の選び直しを，形成済みの同一性の適用と捉え，同一性の再構築とは別の課題に区分している点が誤り。成人期，中年期，老年期にも，新しい役割や経験との関係で同一性は再構築される。"),
      text_block.call("エ：適切。青年期の迷いを，直ちに失敗と扱うのではなく，自己を問い直す過程として理解する。何を大切にして生きたいかという価値や将来の見通しと，具体的な進路選択とが関係する。"),
    ],
    source_text: "東京大学大学院法学政治学研究科・法学部 学習相談室「コラム25：アイデンティティと進路」（青年期の同一性形成と，成人期以降の再構築） | https://www.j.u-tokyo.ac.jp/adviser/column/n-25/",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("クロンバックが提唱した適性処遇交互作用（ATI）に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "適性には，学習者の知識や動機づけなどの個人差が，処遇には，教材や指導方法などの条件が含まれる。指導方法の効果が学習者の適性によって異なることに着目し，両者の組合せを検討する。", true),
      text_choice.call("イ", "処遇には，教材の構成や指導方法などの条件が含まれる。二つの指導方法の成績の差が，学習者の適性の高低によらず同じ大きさで認められる場合に，適性処遇交互作用が成立する。"),
      text_choice.call("ウ", "適性処遇交互作用では，学習者と指導方法との組合せを検討する。このとき，教材の提示順序や学習課題の構成を適性，学習前の知識や学習者の動機づけを処遇として位置付ける。"),
      text_choice.call("エ", "適性には，学習者の知的能力や動機づけなどの個人差が含まれる。一つの指導方法のもとで適性の高い学習者ほど成績が高くなる関係を，適性と処遇との交互作用として捉える。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。クロンバックのATIは，学習者側の個人差と教育条件との関係を捉えます。平均的に効果の高い指導方法を選ぶことと，適性に応じて効果がどう異なるかを検討することとは区別されます。"),
      text_block.call("イ：処遇の説明は適切です。指導方法の成績差が適性によらず同じなら，処遇の効果は認められても，適性に応じてその効果が変わる交互作用の説明にはなりません。"),
      text_block.call("ウ：組合せを検討する点は適切です。適性と処遇の具体例が逆です。知識や動機づけなどが学習者側の適性，教材や課題の構成などが教育条件としての処遇に当たります。"),
      text_block.call("エ：適性の説明は適切です。しかし，一つの指導方法で適性と成績が関係することだけでは，複数の処遇の効果が適性に応じて異なることを示せません。"),
    ],
    source_text: "日本心理学会『心理学ワールド』94号・山森光陽「教育心理学と教育政策」，「知見の一般化に慎重な態度」（ATIの定義及びクロンバックへの帰属） | https://psych.or.jp/publication/world094/pw10/\n石井英里子「児童生徒の個に応じた指導力―適性処遇交互作用研究からの小中学校外国語教育への示唆―」鹿児島県立短期大学地域研究所『研究年報』54号，2.2「ATIの概念」及びFigure 2・Figure 3（95〜97頁） | https://k-kentan.repo.nii.ac.jp/record/2956/files/07-%E7%9F%B3%E4%BA%95.pdf",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅱ部 各論 3 新時代に対応した高等学校教育等の在り方について」に示された高等学校の役割に関する記述である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "高等学校は，高等教育機関と実社会への接続を担い，学ぶことと将来との関係を見通した学びを充実させる。自己のキャリア形成と関連付けて生涯にわたり学び続けるため，義務教育段階の取組を発展させる。", true),
      text_choice.call("イ", "高等学校は，多様な生徒が自己の将来とのつながりを見通し，学ぶ意欲を高める教育を進める。キャリア教育で育成する基盤となる資質・能力は，各職業に固有の専門的な知識・技能の習得として整理する。"),
      text_choice.call("ウ", "高等学校は，高等教育機関と実社会への接続を担う。進学希望者には大学等での学修への準備を行い，実社会との接続に必要な資質・能力の育成は，高等教育段階で担うものと位置付ける。"),
      text_choice.call("エ", "高等学校は，社会経済の変化と多様な生徒の背景を踏まえ，教育活動を充実させる。社会性・人間性の育成を福祉的機能，安全・安心な居場所の提供を社会的機能として捉え，実社会への接続を支える。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。高等学校は高等教育機関と実社会の双方への接続機能を担います。義務教育段階での取組を発展させ，自己のキャリア形成と関連付けて生涯にわたり学び続けるための，学びに向かう力やキャリア教育を充実させます。"),
      text_block.call("イ：学習の意欲を高めるという前半は適切です。社会的・職業的自立に必要な基盤となる資質・能力を，各職業固有の専門的な知識・技能の習得に置き換える点が誤りです。キャリア教育の基盤と，特定の職業の専門的な知識・技能を同一視しません。"),
      text_block.call("ウ：高等学校の接続機能という前半は適切です。進学希望者について，実社会への接続に必要な資質・能力の育成を高等教育段階へ移している点が誤りです。高等学校段階でも，社会的・職業的自立や社会の形成への主体的な参画を支える資質・能力を育てます。"),
      text_block.call("エ：前半は適切ですが，福祉的機能と社会的機能の対応が逆です。安全・安心な居場所の提供が福祉的機能，社会性・人間性の育成が社会的機能です。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅱ部3(1)，本文50頁（PDF55ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=55\n中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅰ部3(1)③，本文20頁（PDF25ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=25\n文部科学省『キャリア教育』・キャリア教育の定義（誤答イの補助根拠） | https://www.mext.go.jp/a_menu/shotou/career/index.htm\n文部科学省『キャリア教育の推進に関する総合的調査研究協力者会議報告書』・第2章4(1)・5(2)，普通教育・職業教育とキャリア教育の関係（誤答イの補助根拠） | https://www.mext.go.jp/b_menu/shingi/chousa/shotou/023/toushin/04012801/002/003.htm",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第2 情報Ⅱ 2 内容 コミュニケーションとコンテンツ」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "イ 次のような思考力，判断力，表現力等を身に付けること。\n\n（ｱ） 目的や状況に応じて，{{①}}を考え，文字，音声，静止画，動画などを選択し，組合せを考えること。\n\n（ｲ） {{②}}に配慮してコンテンツを制作し，評価し改善すること。\n\n（ｳ） コンテンツを社会に発信したときの効果や影響を考え，{{③}}やコンテンツを評価し改善すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["コミュニケーションの形態","情報セキュリティ","データの収集方法"]),
      fill_in_choice.call("イ", ["情報システムの構成","情報デザイン","データの収集方法"]),
      fill_in_choice.call("ウ", ["コミュニケーションの形態","情報デザイン","発信の手段"], true),
      fill_in_choice.call("エ", ["情報システムの構成","情報セキュリティ","発信の手段"]),
    ],
    explanation_blocks: [
      text_block.call("①「コミュニケーションの形態」，②「情報デザイン」，③「発信の手段」が対応する。送り手・受け手などの形態に応じたメディアの選択，情報デザインに配慮した制作，発信の効果・影響を踏まえた手段とコンテンツの改善という三つの内容を区別する。"),
      text_block.call("ア：②・③が誤り。制作時にここで問うのは情報デザイン，発信後に評価・改善するのは発信の手段である。"),
      text_block.call("イ：①・③が誤り。（ｱ）は情報システムの構成ではなくコミュニケーションの形態，（ｳ）はデータの収集方法ではなく発信の手段である。"),
      text_block.call("ウ：三つとも原文に一致する。"),
      text_block.call("エ：①・②が誤り。コミュニケーションの形態と情報デザインが入る。③は一致する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第2章第10節 第2款第2 情報Ⅱ 2（2）イ（ｱ）〜（ｳ）・193頁（PDF195頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=195",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第1 情報産業と社会 1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報に関する科学的な見方・考え方を働かせ，実践的・体験的な学習活動を行うことなどを通して，情報産業を通じ，地域産業をはじめ情報社会の健全で持続的な発展を担う職業人として必要な{{①}}な資質・能力を次のとおり育成することを目指す。\n\n（1）情報産業と社会について体系的・系統的に理解するとともに，関連する技術を身に付けるようにする。\n\n（2）情報産業と社会との関わりに関する課題を発見し，情報産業に携わる者として合理的かつ創造的に解決する力を養う。\n\n（3）情報技術者に必要とされる{{②}}の習得を目指して自ら学び，情報社会に主体的かつ協働的に{{③}}する態度を養う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["基礎的","情報処理能力","適応し貢献"]),
      fill_in_choice.call("イ", ["総合的","情報活用能力","適応し貢献"]),
      fill_in_choice.call("ウ", ["総合的","情報処理能力","参画し寄与"]),
      fill_in_choice.call("エ", ["基礎的","情報活用能力","参画し寄与"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②・③が異なる。「情報活用能力」の習得と，情報社会へ「参画し寄与」する態度を目指す。①は一致する。"),
      text_block.call("イ：①・③が異なる。「基礎的」な資質・能力と，「参画し寄与」する態度が示される。②は一致する。"),
      text_block.call("ウ：①・②が異なる。「基礎的」と「情報活用能力」が入る。③は一致する。"),
      text_block.call("エ：原文に一致する。「情報産業と社会」は基礎的な資質・能力を育成し，情報活用能力と情報社会への参画を目標にする。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第1 情報産業と社会 1 目標 1「目標」全文（407頁／PDF409頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=409",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科「情報」 第2章 専門教科情報科の各科目 第3節 情報の表現と管理 第2 内容とその取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ア 情報の管理とドキュメンテーション\n\nここでは，適切に情報を整理し管理するドキュメンテーションについて扱う。情報産業で作成，管理される様々なドキュメントとして，{{①}}などについて取り上げ，それぞれのドキュメントの作成方法について扱う。その際，規程などがある場合にはそれに則って，必要な情報を整理し分かりやすく作成することに留意する。\n\nまた，文書を{{②}}するなどの一連の流れを示す{{③}}の考え方や図書分類法などを取り上げ，分類手法を用いて作成されたドキュメントを適切に管理する基礎的な知識と技術を扱う。その際，企業などと連携し，実際の情報管理やドキュメンテーションについて体験するなどの学習活動も考えられる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["通知文，企画書，報告書及び仕様書","作成，保存及び廃棄","ファイリングシステム"], true),
      fill_in_choice.call("イ", ["通知文，企画書，報告書及び仕様書","起案，承認及び発行","ワークフロー"]),
      fill_in_choice.call("ウ", ["申請書，契約書，請求書及び納品書","作成，保存及び廃棄","ワークフロー"]),
      fill_in_choice.call("エ", ["申請書，契約書，請求書及び納品書","起案，承認及び発行","ファイリングシステム"]),
    ],
    explanation_blocks: [
      text_block.call("ア：原文に一致する。文書の例，作成・保存・廃棄という流れ，ファイリングシステムの対応を確認する。"),
      text_block.call("イ：②・③が異なる。「作成，保存及び廃棄」と「ファイリングシステム」が入る。起案から承認・発行までの仕事の流れとは区別する。"),
      text_block.call("ウ：①・③が異なる。原文の文書例は通知文・企画書・報告書・仕様書で，管理の考え方はファイリングシステムである。他の文書がドキュメントではないという意味ではない。"),
      text_block.call("エ：①・②が異なる。原文に挙げた文書例と，文書の作成・保存・廃棄という一連の流れを問う。③は一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』・第2部 主として専門学科において開設される教科「情報」 第2章 専門教科情報科の各科目 第3節 情報の表現と管理 第2 内容とその取扱い 2（2）ア「情報の管理とドキュメンテーション」全文（106頁／PDF113頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=113",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次のプログラムは，二つの変数 x，y を3回更新するものである。各回の更新では，更新前の x と y の和を新しい x とし，更新前の x を新しい y とする。空欄 {{①}}・{{②}} に当てはまるものの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("= は右辺の値を求めた後，その値を左辺へ代入することを表す。各行は上から順に実行される。range(0, 3) は0，1，2を順に取り出し，行頭の字下げは処理の範囲を表す。t は更新前の値を一時的に保存するための変数である。"),
      { type: "code", code: "01 x = 2\n02 y = 3\n03 for i in range(0, 3):\n04     t = 【①】\n05     x = x + y\n06     y = 【②】\n07 print(x)" },
    ],
    choices: [
      fill_in_choice.call("ア", ["x", "x"]),
      fill_in_choice.call("イ", ["x", "t"], true),
      fill_in_choice.call("ウ", ["y", "t"]),
      fill_in_choice.call("エ", ["y", "x"]),
    ],
    explanation_blocks: [
      text_block.call("05行で x を更新すると，更新前の x は x から読み取れなくなる。その値を04行で t に保存し，06行で y へ代入する必要がある。"),
      {
        type: "table",
        headers: ["更新回数", "更新前の x，y", "t", "更新後の x，y"],
        rows: [["1回目", "2，3", "2", "5，2"], ["2回目", "5，2", "5", "7，5"], ["3回目", "7，5", "7", "12，7"]],
      },
      text_block.call("ア：更新前の x を退避する点は正しいが，06行で更新後の x を y に入れてしまう。x，y はともに5，10，20と変わり，表示は20となる。"),
      text_block.call("イ：正しい。各回の古い x を次の y に引き継ぐため，表示は12となる。"),
      text_block.call("ウ：退避するのが更新前の y なので，y は3のまま変わらない。x は5，8，11と変わり，表示は11となる。"),
      text_block.call("エ：退避する値が y であり，さらに y へ更新後の x を代入する。t は更新に使われず，アと同様に表示は20となる。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習13（2）制御構造（114頁／PDF20頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=20\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習13（4）反復の例（117頁／PDF23頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=23",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("図書館の利用状況を調べるため，次の二つの資料を作成した。資料の構造と分析に関する記述として適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("資料Ⅰ：ある一つの図書館について，2024年1月から2025年12月までの各月の来館者数を記録した。1行が一つの月に対応し，年月と来館者数の列を持つ。"),
      text_block.call("資料Ⅱ：40の図書館について，2025年12月の来館者数と延床面積を記録した。1行が一つの図書館に対応し，図書館名，来館者数及び延床面積の列を持つ。"),
    ],
    choices: [
      text_choice.call("ア", "資料Ⅰは時系列データ，資料Ⅱはクロスセクションデータである。資料Ⅰの来館者数を小さい順に並べたときの隣り合う値の差から，前月と比べた増減を分析できる。"),
      text_choice.call("イ", "資料Ⅰは24個の月を対象とするクロスセクションデータ，資料Ⅱは40の図書館を対象とする時系列データである。記録の件数と対象の数に基づき，両者を分類できる。"),
      text_choice.call("ウ", "資料Ⅰは一つの図書館を時間に沿って記録した時系列データ，資料Ⅱは同じ月の複数の図書館を記録したクロスセクションデータである。前者は時間的な推移，後者は図書館間の違いを調べるために利用できる。", true),
      text_choice.call("エ", "資料Ⅰは時系列データ，資料Ⅱはクロスセクションデータである。資料Ⅱで延床面積の大きい図書館ほど来館者数が多ければ，同じ図書館が年月とともに面積を広げたときの来館者数の変化も記録されていると解釈できる。"),
    ],
    explanation_blocks: [
      text_block.call("データが「同じ対象について異なる時点を記録しているか」「同じ時点について異なる対象を記録しているか」を区別する。"),
      text_block.call("ア：資料の分類は正しいが，時間の順序を来館者数の大小順へ置き換えると，隣り合う値は前月と当月を表すとは限らない。前月からの増減には年月の対応を用いる。"),
      text_block.call("イ：両者の分類が逆である。24件，40件という件数自体では分類できず，各行がどの対象・時点に対応するかを確認する。"),
      text_block.call("ウ：正しい。資料Ⅰは同じ図書館を24か月にわたって観測し，資料Ⅱは同じ月に40の図書館を観測している。"),
      text_block.call("エ：資料の分類は正しいが，異なる図書館間の違いを，同じ図書館の時間的変化と取り違えている。資料Ⅱには，各図書館が面積を広げる前後の来館者数は記録されていない。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章・学習22（1）「量的データと質的データ」・時系列データとクロスセクションデータ（本文184頁／PDF32頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=32",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験27の承認済み問番号は1〜20です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "curriculum_organization",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
  11 => "student_guidance_career",
  12 => "special_support_education", 13 => "educational_psychology",
  14 => "educational_psychology", 15 => "education_system",
  16 => "information_education",
  17 => "information_education",
  18 => "information_specialized",
  19 => "information_specialized", 20 => "information_specialized",
}
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  expected_major = number >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major && question.fetch(:category_code) == categories.fetch(number)
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  if number <= 2 && (blocks.any? { |block| %w[fill_in_text fill_in_quote].include?(block[:type]) } ||
      choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    raise "問1・2の原文列挙番号は空欄として扱わないでください"
  end
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  if (3..5).include?(number) && (number >= 4 || choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt = blocks.first
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = number >= 4 ? prompt.fetch(:text).include?("空欄 ① ～ ④") : prompt_labels == %w[① ④]
    unless labels == %w[① ② ③ ④] && prompt[:type] == "fill_in_text" && introduction_labels_match &&
        quotes.any? && quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
      raise "問#{number}の条番号・空欄と選択肢の対応が不正です"
    end
  elsif (6..11).include?(number)
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
  elsif (16..18).include?(number)
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/{{([①②③])}}/).flatten }.uniq
    prompt = blocks.first
    unless quotes.size == 1 && labels == %w[① ② ③] && prompt[:type] == "fill_in_text" &&
        prompt.fetch(:text).scan(/{{([①②③])}}/).flatten.uniq == %w[① ③] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
      raise "問#{number}の抜粋・空欄と選択肢の対応が不正です"
    end
  elsif number == 19
    prompt = blocks.first
    code = blocks.find { |block| block[:type] == "code" }
    unless prompt[:type] == "fill_in_text" && prompt.fetch(:text).scan(/\{\{([①②])\}\}/).flatten.uniq == %w[① ②] &&
        code && code.fetch(:code).scan(/【([①②])】/).flatten.uniq == %w[① ②] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 2 }
      raise "問19のコードの空欄と選択肢の対応が不正です"
    end
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 承認済みの全20問を公開する前に、投入元のデータを検査する。
  entry = { exam_number: 27, attributes: question, publication_status: "published" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(27, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験27の全20問の正答位置は各記号5件にしてください"
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, source_pattern = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, /第1部/] : [3, /第2部/]
  elsif prompt.include?("第2章") && prompt.include?("第10節")
    [0, /第2章.*第10節/]
  elsif prompt.include?("第3章") && prompt.include?("第7節")
    [1, /第3章.*第7節/]
  else
    raise "問16〜18の導入文には出典の資料・章節を明示してください"
  end
  unless source.match?(source_pattern) && prompt.include?("解説 情報編") == source.include?("解説 情報編")
    raise "問16〜18の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "問16〜18は異なる3範囲を資料順に並べてください"
end

QuestionSeedSync.import(exam_number: 27, questions: questions, publication_status: "published")

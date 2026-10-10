text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験21（承認済みの全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "我が国の幼稚園の成立と制度化について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "明治5年の「学制」は，小学校の一種として就学前の幼児を対象とする幼稚小学を定め，各地でその設置が進められた。明治9年の東京女子師範学校附属幼稚園は，既に普及していた幼稚小学の保育方法を全国へ統一するために開設された。"),
      text_choice.call("イ", "明治9年に開設された東京女子師範学校附属幼稚園は，フレーベルの幼稚園を模範とし，恩物を取り入れた保育を行った。開園当初は，働く親の生活を支えるための施設として，貧困家庭の子どもが園児の大部分を占めていた。"),
      text_choice.call("ウ", "大正15年には幼稚園に関する独立した勅令として幼稚園令が公布され，家庭教育を補うことが目的に掲げられた。保育項目には修身，読書，習字，算術などを定め，小学校入学前に教科の初歩を習得させる構成とした。"),
      text_choice.call("エ", "明治9年の東京女子師範学校附属幼稚園は，フレーベルの幼稚園を模範として保育を始めた。大正15年の幼稚園令は，幼児の心身の健全な発達，善良な性情の涵養及び家庭教育の補完を目的とし，施行規則では遊戯，唱歌，観察，談話，手技等を保育項目とした。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：幼稚小学が実際に普及したとする点が誤り。「学制」は幼稚小学を規定したが，実現しなかった。東京女子師範学校附属幼稚園は，既存の幼稚小学の方法を全国統一する施設ではない。"),
      text_block.call("イ：フレーベルを模範としたことは適切だが，開園当初の園児の構成が誤り。上流階級の子女が大部分を占めていた。働く家庭の便宜を図る保育所的役割は，後の幼稚園令で示された特徴と区別する。"),
      text_block.call("ウ：法令の制定年と目的は適切だが，保育項目が誤り。修身，読書，習字，算術ではなく，遊戯，唱歌，観察，談話，手技等である。"),
      text_block.call("エ：幼稚園の創設時の教育方法と，幼稚園令の目的・保育項目を正しく組み合わせている。"),
    ],
    source_text: "文部科学省『学制百年史』「五 幼稚園の創設」―幼稚小学と幼稚園の開設／東京女子師範学校付属幼稚園 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317591.htm\n文部科学省『学制百年史』「三 幼稚園令の制定」―幼稚園令の特質と意義 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317655.htm\n玉川大学教育博物館『恩物紹介の訳書「幼稚園」』 | https://www.tamagawa.ac.jp/museum/archive/1990/005.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "ルソーの『エミール』における教育の捉え方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "教育には自然・人間・事物という三つの源泉があると考えた。このうち，自然の教育とは，子どもが周囲の自然現象を観察して経験を得ることであり，人間の教育とは，その経験によって身体や諸能力が内面的に発達することであるとした。"),
      text_choice.call("イ", "身体の諸器官や諸能力の内的な発達を自然の教育，それらを用いることを他者から学ぶことを人間の教育，周囲の事物との関わりから経験を得ることを事物の教育とした。三つの教育が調和するよう，人間と事物の教育を自然の教育に合わせようとした。", true),
      text_choice.call("ウ", "子どもは自然・人間・事物から教育を受けるとし，それらの働きが調和することを重視した。人間の教育とは，事物に働きかけて自ら経験を得ることであり，事物の教育とは，教師が諸能力の使い方を言葉や模範によって教えることであるとした。"),
      text_choice.call("エ", "身体や諸能力の発達，教師などから受ける働きかけ，周囲の事物から得る経験を，三つの教育として区別した。その調和に当たっては，教師などが諸能力の使い方を教える人間の教育を基準とし，自然の教育と事物の教育をそれに合わせることを基本とした。"),
    ],
    explanation_blocks: [
      text_block.call("イは適切である。ルソーは，三つの教育の働きを区別した上で，人間と事物の教育を自然の教育の方向に合わせることを論じた。アは，自然の教育を自然現象の観察とする点と，人間の教育を内的な発達とする点が誤りである。自然の教育は，子どもの諸器官・諸能力の内的な発達を指す。ウは，人間の教育と事物の教育の対応が逆である。エは，調和の基準を人間の教育に置いた点が誤りであり，ルソーは自然の教育を基準としている。"),
    ],
    source_text: "関勤「デューイによる，ルソーの自然的発達としての教育説の批判」『茨城大学教育学部紀要（教育科学）』第31号・101頁「結語」の三つの要因 | https://rose-ibadai.repo.nii.ac.jp/record/16757/files/CSI2010_3073.pdf#page=15\n佐々井利夫「ルソーの『事物の教育』と生活科」12頁・第1節 | https://meisei.repo.nii.ac.jp/record/1801/files/kyoiku-no12-a02.pdf#page=1\n筑波大学『近代教育学の源流』III「教育学と自然・人間・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "「教育基本法」（平成18年法律第120号）の条文として正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "高等学校は、中学校における教育の基礎の上に、心身の発達及び進路に応じて、高度な普通教育及び専門教育を施すことを目的とする。"),
      text_choice.call("イ", "職員には、その勤務能率の発揮及び増進のために、研修を受ける機会が与えられなければならない。\n2　前項の研修は、任命権者が行うものとする。"),
      text_choice.call("ウ", "すべて国民は、法律の定めるところにより、その能力に応じて、ひとしく教育を受ける権利を有する。"),
      text_choice.call("エ", "義務教育として行われる普通教育は、各個人の有する能力を伸ばしつつ社会において自立的に生きる基礎を培い、また、国家及び社会の形成者として必要とされる基本的な資質を養うことを目的として行われるものとする。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：学校教育法第50条の，高等学校の目的に関する規定である。教育基本法の条文ではない。"),
      text_block.call("イ：地方公務員法第39条第1項・第2項の，勤務能率の発揮・増進のための研修とその実施主体に関する規定である。教育基本法第9条も養成と研修の充実を定めるが，この提示文とは異なる。"),
      text_block.call("ウ：日本国憲法第26条第1項の，教育を受ける権利に関する規定である。教育基本法第4条第1項は「その能力に応じた教育を受ける機会を与えられなければならず」と規定しており，提示文そのものの出典は憲法である。"),
      text_block.call("エ：教育基本法第5条第2項と一致する。義務教育として行われる普通教育の目的を，個人の能力と自立的に生きる基礎，国家・社会の形成者としての基本的資質の双方から定めている。"),
    ],
    source_text: "教育基本法・第4条第1項、第5条第2項、第9条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_5-Pr_2\n学校教育法・第50条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_50\n地方公務員法・第39条第1項、第2項 | https://laws.e-gov.go.jp/law/325AC0000000261/20250601_504AC0000000068#Mp-Ch_3-Se_7-At_39\n日本国憲法・第26条第1項 | https://laws.e-gov.go.jp/law/321CONSTITUTION#Mp-Ch_3-At_26-Pr_1",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第12条\n\n学校においては、別に法律で定めるところにより、幼児、児童、生徒及び学生並びに{{①}}の健康の保持増進を図るため、{{②}}を行い、その他その保健に必要な措置を講じなければならない。" },
      { type: "fill_in_quote", text: "第137条\n\n{{③}}支障のない限り、学校には、社会教育に関する施設を附置し、又は学校の施設を{{④}}のために、利用させることができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["職員", "健康診断", "学校教育上", "社会教育その他公共"], true),
      fill_in_choice.call("イ", ["教員", "健康診断", "学校教育上", "地域の教育活動"]),
      fill_in_choice.call("ウ", ["職員", "保健指導", "施設管理上", "社会教育その他公共"]),
      fill_in_choice.call("エ", ["教員", "保健指導", "施設管理上", "地域の教育活動"]),
    ],
    explanation_blocks: [
      text_block.call("第12条は，幼児・児童・生徒・学生に加え，「職員」の健康の保持増進のために「健康診断」を行うこと等を定める。第137条は，「学校教育上」支障のない限り，学校施設を「社会教育その他公共」のために利用させることができると規定している。"),
      text_block.call("ア：4語句が原文と一致する。"),
      text_block.call("イ：①は「職員」，④は「社会教育その他公共」。健康の保持増進の対象を教員に限る表現ではなく，学校施設の利用目的も地域の教育活動に限定されていない。"),
      text_block.call("ウ：②は「健康診断」，③は「学校教育上」。この条文で挙げる具体的措置を保健指導へ置き換え，施設利用の条件を施設管理上の支障の有無へ置き換えている。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第12条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_1-At_12\ne-Gov法令検索『学校教育法』第137条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_12-At_137",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第21条第2項　教育公務員の{{①}}は、教育公務員（公立の小学校等の{{②}}（臨時的に任用された者その他の政令で定める者を除く。以下この章において同じ。）を除く。）の研修について、それに要する施設、研修を{{③}}するための方途その他研修に関する計画を樹立し、その実施に{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "教諭及び講師", "評価", "努めることができる"]),
      fill_in_choice.call("イ", ["指導助言者", "校長及び教員", "評価", "努めることができる"]),
      fill_in_choice.call("ウ", ["研修実施者", "校長及び教員", "奨励", "努めなければならない"], true),
      fill_in_choice.call("エ", ["指導助言者", "教諭及び講師", "奨励", "努めなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("正答はウ。原語は①「研修実施者」、②「校長及び教員」、③「奨励」、④「努めなければならない」。第21条第2項は、臨時的に任用された者その他の政令で定める者を除く公立の小学校等の校長及び教員を、対象となる教育公務員から除いている。その対象となる教育公務員の研修について、研修実施者に施設、研修を奨励する方途などの計画を樹立し、実施に努める義務を課す。アは②が除外対象を教諭・講師だけに狭め、③が研修の奨励を評価へ取り違え、④が努力義務を裁量的な権限へ変えている。イは①を指導助言者とし、③・④もアと同じ取り違えがある。エは①と②が誤り。指導助言者が資質向上のための指導・助言を行うことと、この項の研修計画を樹立する主体・対象とは区別する。"),
    ],
    source_text: "教育公務員特例法・第21条第2項、第20条、第22条の6 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_21",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価 2 学習評価の充実」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒のよい点や進歩の状況などを積極的に評価し，{{①}}を実感できるようにすること。また，各教科・科目等の目標の実現に向けた学習状況を把握する観点から，単元や題材など内容や時間のまとまりを見通しながら{{②}}を工夫して，学習の過程や成果を評価し，指導の改善や学習意欲の向上を図り，資質・能力の育成に生かすようにすること。\n\n（2）創意工夫の中で学習評価の{{③}}が高められるよう，{{④}}な取組を推進するとともに，学年や学校段階を越えて生徒の学習の成果が円滑に接続されるように工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習したことの意義や価値", "評価の時期や基準", "客観性や統一性", "各教師の判断に基づく個別的"]),
      fill_in_choice.call("イ", ["学習したことの量や難度", "評価の場面や方法", "客観性や統一性", "各教師の判断に基づく個別的"]),
      fill_in_choice.call("ウ", ["学習したことの意義や価値", "評価の場面や方法", "妥当性や信頼性", "組織的かつ計画的"], true),
      fill_in_choice.call("エ", ["学習したことの量や難度", "評価の時期や基準", "妥当性や信頼性", "組織的かつ計画的"]),
    ],
    explanation_blocks: [
      text_block.call("生徒が学習の意義を実感できる評価と，評価の質を高める学校としての取組を区別する。場面・方法を工夫し，妥当性・信頼性を組織的かつ計画的に高める。"),
      text_block.call("ア：②で工夫するのは「評価の場面や方法」である。時期や基準も評価に関係するが，この箇所の原文ではない。 ③は測りたい資質・能力を適切に評価する「妥当性」と，評価の一貫性に関わる「信頼性」である。 ④は教師ごとの個別的な取組ではなく，「組織的かつ計画的」な取組で評価の質を高める。"),
      text_block.call("イ：①は学習の「量や難度」ではなく，学習したことの「意義や価値」を実感できるようにする。 ③は測りたい資質・能力を適切に評価する「妥当性」と，評価の一貫性に関わる「信頼性」である。 ④は教師ごとの個別的な取組ではなく，「組織的かつ計画的」な取組で評価の質を高める。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：①は学習の「量や難度」ではなく，学習したことの「意義や価値」を実感できるようにする。 ②で工夫するのは「評価の場面や方法」である。時期や基準も評価に関係するが，この箇所の原文ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第3款 2(1)・(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）学習や生活の基盤として，教師と生徒との信頼関係及び{{①}}を育てるため，日頃からホームルーム経営の充実を図ること。また，主に集団の場面で必要な指導や援助を行うガイダンスと，{{②}}を踏まえ，一人一人が抱える課題に個別に対応した指導を行うカウンセリングの双方により，生徒の発達を支援すること。\n\n（2）生徒が，自己の存在感を実感しながら，よりよい人間関係を形成し，有意義で充実した学校生活を送る中で，{{③}}における自己実現を図っていくことができるよう，生徒理解を深め，{{④}}と関連付けながら，生徒指導の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生徒相互のよりよい人間関係", "個々の生徒の多様な実態", "現在及び将来", "学習指導"], true),
      fill_in_choice.call("イ", ["生徒集団の共通の規律", "集団としての共通の課題", "現在の学校生活", "学習指導"]),
      fill_in_choice.call("ウ", ["生徒集団の共通の規律", "集団としての共通の課題", "現在及び将来", "進路指導"]),
      fill_in_choice.call("エ", ["生徒相互のよりよい人間関係", "個々の生徒の多様な実態", "現在の学校生活", "進路指導"]),
    ],
    explanation_blocks: [
      text_block.call("ホームルーム経営を通して信頼関係と人間関係を育て，集団へのガイダンスと個別のカウンセリングを組み合わせる。生徒指導は現在と将来の自己実現を支え，学習指導とも関連付ける。"),
      text_block.call("ア：全ての空欄が原文と一致する。"),
      text_block.call("イ：①は教師との信頼関係に加え，「生徒相互のよりよい人間関係」を育てることであり，共通の規律への置換ではない。 ②はカウンセリングの前提となる「個々の生徒の多様な実態」である。集団に共通する課題に焦点を当てるガイダンスとの違いを押さえる。 ③は「現在及び将来」の自己実現であり，現在の学校生活に範囲を限った語句ではない。"),
      text_block.call("ウ：①は教師との信頼関係に加え，「生徒相互のよりよい人間関係」を育てることであり，共通の規律への置換ではない。 ②はカウンセリングの前提となる「個々の生徒の多様な実態」である。集団に共通する課題に焦点を当てるガイダンスとの違いを押さえる。 ④は「学習指導」と生徒指導との関連である。進路指導も重要だが，この箇所の原文ではない。"),
      text_block.call("エ：③は「現在及び将来」の自己実現であり，現在の学校生活に範囲を限った語句ではない。 ④は「学習指導」と生徒指導との関連である。進路指導も重要だが，この箇所の原文ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第5款 1(1)・(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第3章 総合的な探究の時間の目標 第2節 目標の趣旨」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("本文中の①〜④は原文の列挙番号であり，枠で囲んだ番号が空欄である。"),
      { type: "fill_in_quote", text: "生徒は，①日常生活や社会に目を向けた時に湧き上がってくる{{①}}に基づいて，自ら課題を見付け，\n\n②そこにある具体的な問題について{{②}}し，\n\n③その情報を{{③}}したり，知識や技能に結び付けたり，考えを出し合ったりしながら問題の解決に取り組み，\n\n④明らかになった考えや意見などをまとめ・表現し，そこからまた新たな課題を見付け，更なる問題の解決を始めるといった学習活動を{{④}}。\n\n要するに探究とは，物事の本質を自己との関わりで探り見極めようとする一連の知的営みのことである。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["疑問や関心", "解決方法を確定", "記録・保存", "段階ごとに完結させていく"]),
      fill_in_choice.call("イ", ["教科・科目ごとの目標", "情報を収集", "記録・保存", "段階ごとに完結させていく"]),
      fill_in_choice.call("ウ", ["教科・科目ごとの目標", "解決方法を確定", "整理・分析", "発展的に繰り返していく"]),
      fill_in_choice.call("エ", ["疑問や関心", "情報を収集", "整理・分析", "発展的に繰り返していく"], true),
    ],
    explanation_blocks: [
      text_block.call("生徒の疑問・関心から課題を見付け，情報収集，整理・分析，まとめ・表現へと進む。新たな課題を見付け，問題解決を発展的に繰り返す点まで押さえる。本文の①～④は原文の列挙番号，枠で囲まれた番号が空欄である。"),
      text_block.call("ア：②は具体的な問題について「情報を収集」する段階であり，その前に解決方法を確定するのではない。 ③は収集した情報の「整理・分析」である。記録・保存だけに置き換えると，問題解決へ結び付ける働きが異なる。 ④は新たな課題の発見を通して「発展的に繰り返していく」であり，各段階を完結させて終える構成ではない。"),
      text_block.call("イ：①は生徒自身の「疑問や関心」である。教科別の目標から探究を始めるとする語句ではない。 ③は収集した情報の「整理・分析」である。記録・保存だけに置き換えると，問題解決へ結び付ける働きが異なる。 ④は新たな課題の発見を通して「発展的に繰り返していく」であり，各段階を完結させて終える構成ではない。"),
      text_block.call("ウ：①は生徒自身の「疑問や関心」である。教科別の目標から探究を始めるとする語句ではない。 ②は具体的な問題について「情報を収集」する段階であり，その前に解決方法を確定するのではない。"),
      text_block.call("エ：全ての空欄が原文と一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』・第3章第2節 1(1)探究の過程（印刷12頁） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=20",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "２ 道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する道徳的諸価値についての理解を基にしながら，様々な体験や思索の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，自立心や自律性を高め，{{①}}をすること，生命を尊重する心を育てること，社会連帯の自覚を高め，{{②}}意欲と態度を養うこと，義務を果たし責任を重んずる態度及び人権を尊重し{{③}}を実現しようとする態度を養うこと，伝統と文化を尊重し，それらを育んできた{{④}}を愛するとともに，他国を尊重すること，国際社会に生きる日本人としての自覚を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自律的な生活", "主体的に社会の動向を把握する", "個人の能力を十分に生かす社会", "我が国と郷土"]),
      fill_in_choice.call("イ", ["規律ある生活", "主体的に社会の形成に参画する", "差別のないよりよい社会", "我が国と郷土"], true),
      fill_in_choice.call("ウ", ["自律的な生活", "主体的に社会の動向を把握する", "差別のないよりよい社会", "地域社会と国際社会"]),
      fill_in_choice.call("エ", ["規律ある生活", "主体的に社会の形成に参画する", "個人の能力を十分に生かす社会", "地域社会と国際社会"]),
    ],
    explanation_blocks: [
      text_block.call("中学校までに深めた道徳的諸価値の理解を基に，人間としての在り方生き方を考える。自律性と規律，社会形成への参画，人権尊重と差別のない社会，伝統・文化と我が国・郷土への愛着をそれぞれ対応させる。"),
      text_block.call("ア：①は自立心や自律性を高めることに続く「規律ある生活」である。「自律的な生活」はこの箇所の原語ではない。 ②は社会の動向を把握するだけでなく，「主体的に社会の形成に参画する」意欲と態度を養うことである。 ③は人権尊重と結び付く「差別のないよりよい社会」である。個人の能力の発揮を述べる語句とは区別する。"),
      text_block.call("イ：全ての空欄が原文と一致する。"),
      text_block.call("ウ：①は自立心や自律性を高めることに続く「規律ある生活」である。「自律的な生活」はこの箇所の原語ではない。 ②は社会の動向を把握するだけでなく，「主体的に社会の形成に参画する」意欲と態度を養うことである。 ④は伝統と文化を育んできた「我が国と郷土」である。地域社会と国際社会に置き換えない。"),
      text_block.call("エ：③は人権尊重と結び付く「差別のないよりよい社会」である。個人の能力の発揮を述べる語句とは区別する。 ④は伝統と文化を育んできた「我が国と郷土」である。地域社会と国際社会に置き換えない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第7款 2 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』の「第3章 各活動・学校行事の目標と内容 第1節 ホームルーム活動 1 ホームルーム活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ホームルーム活動の内容「（2）日常の生活や学習への適応と自己の成長及び健康安全」，内容「（3）一人一人のキャリア形成と自己実現」においては，（2）は現在及び将来における{{①}}，（3）は現在及び将来を見通した{{②}}という違いがあるが，問題の発見・確認，解決方法の話合い，解決方法の決定，決めたことの実践，振り返りという基本的な学習過程は同じである。\n\nなお，ホームルーム経営や生徒の発達段階を踏まえ，{{③}}がこれらの活動で取り上げたいことをあらかじめ年間指導計画に即して設定したものを「{{④}}」と称す。\n\nここで言う「問題の発見・確認」とは，「{{④}}」に基づいた資料やアンケート結果から生徒一人一人が日常生活や将来に向けた自己の生き方，進路等の問題を確認し，取り組むべき課題を見いだして，解決の見通しをもつことを示している。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生活上の課題", "学習や在り方生き方に関する課題", "教師", "題材"], true),
      fill_in_choice.call("イ", ["生活上の課題", "人間関係や社会参画に関する課題", "生徒", "議題"]),
      fill_in_choice.call("ウ", ["学校や地域社会の課題", "学習や在り方生き方に関する課題", "生徒", "議題"]),
      fill_in_choice.call("エ", ["学校や地域社会の課題", "人間関係や社会参画に関する課題", "教師", "題材"]),
    ],
    explanation_blocks: [
      text_block.call("内容(2)は現在・将来の生活上の課題，内容(3)は将来を見通した学習や在り方生き方に関する課題を扱う。両方に共通する過程があり，教師が年間指導計画に即して設定するのは「題材」である。"),
      text_block.call("ア：全ての空欄が原文と一致する。"),
      text_block.call("イ：②は「学習や在り方生き方に関する課題」である。「人間関係形成」「社会参画」は特別活動全体に関わる視点だが，内容(3)の説明の原語ではない。 ③は年間指導計画に即して題材を設定する「教師」である。 ④は「題材」である。内容(1)の集団生活の改善に関わる「議題」と区別する。"),
      text_block.call("ウ：①は一人一人の「生活上の課題」である。学校・地域社会の集団的な課題に置き換えない。 ③は年間指導計画に即して題材を設定する「教師」である。 ④は「題材」である。内容(1)の集団生活の改善に関わる「議題」と区別する。"),
      text_block.call("エ：①は一人一人の「生活上の課題」である。学校・地域社会の集団的な課題に置き換えない。 ②は「学習や在り方生き方に関する課題」である。「人間関係形成」「社会参画」は特別活動全体に関わる視点だが，内容(3)の説明の原語ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 特別活動編』・第3章第1節 1（印刷39頁） | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=47",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{②}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "児童生徒の教育活動の大半は、集団一斉型か小集団型で展開されます。そのため、{{①}}してしまう危険性があります。そうならないようにするには、学校生活のあらゆる場面で、「自分も一人の人間として大切にされている」という自己存在感を、児童生徒が実感することが大切です。また、ありのままの自分を肯定的に捉える{{②}}や、他者のために役立った、認められたという自己有用感を育むことも極めて重要です。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["集団に個が埋没", "自己効力感"]),
      fill_in_choice.call("イ", ["集団が個に従属", "自己効力感"]),
      fill_in_choice.call("ウ", ["集団に個が埋没", "自己肯定感"], true),
      fill_in_choice.call("エ", ["集団が個に従属", "自己肯定感"]),
    ],
    explanation_blocks: [
      text_block.call("ウ：正しい。集団で教育活動を行う際にも一人一人が大切にされていると実感できることを重視する。ありのままの自分を肯定的に捉える感情は「自己肯定感」である。"),
      text_block.call("ア：①は正しいが、②が誤り。「自己効力感」は、ある行動や課題を自分が遂行できるという見込みに関わる概念であり、ここでの自己肯定感とは区別する。"),
      text_block.call("イ：①・②が誤り。原文は、集団が個人に従属する危険性ではなく、集団に個が埋没する危険性を指摘している。②は自己肯定感である。"),
      text_block.call("エ：②は正しいが、①が誤り。集団の中で個人の存在が埋没することへの配慮を述べた箇所である。"),
    ],
    source_text: "『生徒指導提要』第1章 1.1.2 生徒指導の実践上の視点（1）自己存在感の感受（14頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=17\n三重大学教育心理学研究室「自己効力感について」（誤答解説の補助資料） | https://educational-psychology.edu.mie-u.ac.jp/thesis/2023/ogawa/forth.html",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "text", text: "文部科学省『障害のある子供の教育支援の手引』に示される，知的障害のある生徒の特性と指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "生活場面で知識や技能を使えるようにする指導には，日常生活の指導や生活単元学習などがある。これらは，自立活動を独立した領域として行う指導の形態であり，各教科や特別活動の内容を合わせて指導する形態とは区別される。"),
      text_choice.call("イ", "ボタンの着脱やはさみの操作に困難がある場合には，使いやすい道具や素材を用い，扱う経験を積めるようにする。この手引では，こうした困難の要因となる手指の巧緻性と目と手の協応は，ともに認知面の課題として整理されている。"),
      text_choice.call("ウ", "学んだ知識や技能が断片的になり，生活場面で使いにくいことがある。具体的な生活場面に即して，考え，判断し，表現する活動を継続的，段階的に行い，知識や技能を実際に生かせるようにする。", true),
      text_choice.call("エ", "失敗経験によって自信を失い，活動への参加をためらう場合には，その状態を知的機能の発達の遅れの程度を示すものと捉える。成功経験の後の意欲の向上は，知的機能の発達の遅れが軽減したことを示す指標となる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：指導形態が誤り。日常生活の指導，生活単元学習などは，各教科等を合わせた指導の実践として示されている。自立活動を独立して行う指導の別名称ではない。"),
      text_block.call("イ：支援方法は適切だが，要因の整理が誤り。手引は手指の巧緻性を運動面の困難，目と手の協応動作を認知面の課題として挙げ，持続性や経験不足なども含めて検討している。"),
      text_block.call("ウ：適切。知識や技能の習得だけでなく，実際の生活場面で活用できるようにする継続的，段階的な指導が重要である。"),
      text_block.call("エ：自信や意欲の変化を，知的機能の発達の遅れの程度に直接対応させる点が誤り。成功経験による自己肯定感の回復と，知的機能の評価は区別する。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅲ「知的障害」1(2)②イ・オ，2(1)②ウ・オ（129・136頁） | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_07.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "エリクソンが述べた青年期の同一性形成に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "幼児童期には，親や身近な大人との同一化を通して多様な自己像が形づくられる。青年期の同一性は，そこで得られた自己像を再検討せずに並存させることによって成立する。"),
      text_choice.call("イ", "青年期には，幼児童期に得られた同一化や自己像を，将来の職業や社会的役割との関係で捉え直す。それらを選択し，再統合していく過程が，同一性の形成に重要な意味をもつ。", true),
      text_choice.call("ウ", "青年期には，自分が何者であるかを問い，職業や価値観について考える過程で同一性の危機が生じる。この危機は，その過程で精神医学的な病気として判断される状態を指す。"),
      text_choice.call("エ", "青年期には，身体的な変化や社会からの期待を受けて，新しい役割や目標を検討する。同一性の形成は，幼児童期の同一化を捨てて，それとは切り離された新しい自己像に置き換える過程である。"),
    ],
    explanation_blocks: [
      text_block.call("ア：幼児童期の同一化の説明は適切だが，同一性は過去の自己像を未整理のまま並存させることではない。青年期には社会的役割との関係で再検討し，新しいまとまりへ統合する。"),
      text_block.call("イ：適切。過去の経験や同一化を基礎として，青年期にそれらを選択的に捉え直し，社会との関係で再統合する。"),
      text_block.call("ウ：「危機」を精神医学的な病気と同義にしている点が誤り。発達上の転換や分岐を意味し，概念自体が病気を指すわけではない。"),
      text_block.call("エ：同一性形成を過去との断絶にしている点が誤り。幼児童期の同一化を素材として選択・再統合するのであり，過去の経験を捨てる過程ではない。"),
    ],
    source_text: "仁科弥生「エリクソンと幼児教育（13）」〈同一性形成と青年期〉（34〜36頁） | https://teapot.lib.ocha.ac.jp/record/14535/files/19830101_012.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "強化スケジュールに関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "固定比率スケジュールでは，一定回数の反応ごとに強化が与えられる。固定時隔スケジュールでは，一定時間が経過するたびに，反応の有無にかかわらず強化が与えられる。"),
      text_choice.call("イ", "変動比率スケジュールでは，強化までに必要な反応回数が変化する。変動時隔スケジュールでは，一定時間内に生じた反応の総数を基準として，強化までに必要な反応回数を変化させる。"),
      text_choice.call("ウ", "比率スケジュールは反応回数を，時隔スケジュールは経過時間を基準とする。固定と変動の区別は，提示する強化子の量が一定か，その都度変化するかによる。"),
      text_choice.call("エ", "固定比率スケジュールでは，強化までに必要な反応回数を一定にする。変動時隔スケジュールでは，強化が可能になるまでの時間を変化させ，その時間が経過した後の最初の反応に強化を与える。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：固定比率は適切。固定時隔でも，設定された時間が経過した後の反応が必要である。時間の経過だけで強化子を提示する手続とは区別する。"),
      text_block.call("イ：変動比率は適切。変動時隔で変化するのは強化が可能になるまでの時間であり，必要な反応回数ではない。"),
      text_block.call("ウ：比率と時隔の区別は適切。固定・変動は，必要な反応回数又は時隔の値についての区別であり，強化子の量についての区別ではない。"),
      text_block.call("エ：適切。反応回数・経過時間という基準と，値を固定・変動させるという区別を正しく対応させている。"),
    ],
    source_text: "慶應義塾大学大学院社会学研究科紀要68号・丹野貴行「変動比率スケジュールと変動時隔スケジュールの比較検討」論文審査要旨（262頁） | https://koara.lib.keio.ac.jp/xoonips/modules/xoonips/download.php/AN0006957X-00000068-0260.pdf?file_id=40193",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅰ部 総論 2 日本型学校教育の成り立ちと成果，直面する課題と新たな動きについて」に示された学校教育の課題に関する記述である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "家庭をめぐる環境の変化や地域の社会関係資本の喪失によって，家庭や地域の教育力が低下する中，本来は家庭や地域でなすべきことまで学校に委ねられるようになり，学校及び教師が担う業務の範囲と負担が拡大してきた。", true),
      text_choice.call("イ", "相対的貧困とは，世帯の所得がその国の等価可処分所得の平均値の半分に満たない状態をいう。経済的困窮を背景として，子供が教育や体験の機会に乏しくなり，地域や社会から孤立するなどの不利な状況に置かれる傾向がある。"),
      text_choice.call("ウ", "日本語指導が必要な児童生徒の増加を，子供たちの多様化に関する課題として挙げている。答申に示された日本語指導が必要な児童生徒数は，外国籍を持つ児童生徒を対象として集計された人数である。"),
      text_choice.call("エ", "いじめの認知件数と重大事態の発生件数はいずれも増加傾向にある。答申は，両者の増加を，初期段階からいじめを積極的に認知し，解消に向けた取組が進んでいることを示すものとして，同じように評価している。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。家庭・地域の変化によって学校へ委ねられる業務が増え，学校及び教師の負担が増大したと説明されている。"),
      text_block.call("イ：基準は「平均値」ではなく「中央値」の半分である。教育や体験の機会の乏しさ，孤立等についての後半は適切。"),
      text_block.call("ウ：答申の人数には，日本語指導が必要な外国籍の児童生徒と日本国籍の児童生徒の双方が含まれる。"),
      text_block.call("エ：認知件数の増加は積極的な認知の表れとも評価できる一方，重大事態の発生件数の増加は「憂慮すべき状況」としている。二つの増加を同じように評価しているわけではない。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅰ部2(3)，本文8〜10頁・脚注20（PDF13〜15頁） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=13",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第2 情報Ⅱ 3 内容の取扱い」に示された内容に基づく記述である。文章中の空欄 {{①}}・{{②}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「コミュニケーションとコンテンツ」における，コミュニケーションの形態とメディアの特性との関係の理解や，目的や状況に応じた形態・素材の選択と組合せの検討では，コンテンツに対する{{①}}を整理する活動も取り入れるものとする。コンテンツの発信方法の理解や，発信の効果・影響を踏まえた評価・改善では，{{②}}双方の視点からコンテンツを評価する活動を取り入れるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["要求", "開発者，管理者"]),
      fill_in_choice.call("イ", ["要求", "発信者，受信者"], true),
      fill_in_choice.call("ウ", ["処理手順", "発信者，受信者"]),
      fill_in_choice.call("エ", ["処理手順", "開発者，管理者"]),
    ],
    explanation_blocks: [
      text_block.call("原典では「コンテンツに対する要求」を整理し，「発信者，受信者双方」の視点から評価する活動を示している。アは②，ウは①，エは①・②が異なる。制作側の開発・管理だけでなく，受け取る側からも評価する点を押さえる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第2章第10節 情報Ⅱ 3(2)，参照先2(2)ア(ｱ)・イ(ｱ)，ア(ｳ)・イ(ｳ)（193〜194頁／PDF195〜196頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=195",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第8 データベース 1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報に関する科学的な見方・考え方を働かせ，実践的・体験的な学習活動を行うことなどを通して，情報社会を支えるデータベースの{{①}}に必要な資質・能力を次のとおり育成することを目指す。\n\n（1） データベースについて体系的・系統的に理解するとともに，関連する技術を身に付けるようにする。\n\n（2） データベースに関する課題を発見し，情報産業に携わる者として{{②}}に解決する力を養う。\n\n（3） データの{{③}}な{{①}}を目指して自ら学び，データベースの利用，構築，運用及び保守などに主体的かつ協働的に取り組む態度を養う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["開発", "合理的かつ創造的", "迅速かつ安定的"]),
      fill_in_choice.call("イ", ["活用", "実験的・実証的", "迅速かつ安定的"]),
      fill_in_choice.call("ウ", ["活用", "合理的かつ創造的", "安全かつ効率的"], true),
      fill_in_choice.call("エ", ["開発", "実験的・実証的", "安全かつ効率的"]),
    ],
    explanation_blocks: [
      text_block.call("目標はデータベースの「活用」に必要な資質・能力であり，課題を「合理的かつ創造的」に解決する力，データの「安全かつ効率的」な活用を目指す態度を育てる。アは①・③，イは②・③，エは①・②が原文と異なる。①は冒頭と（3）の両方に同じ語句が入る。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第3章第7節 第8 データベース 1 目標（415頁／PDF417頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=417",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』の「第1部 各学科に共通する教科『情報』 第2章 共通教科情報科の各科目 第1節 情報Ⅰ 2 内容とその取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ア（ア） 情報通信ネットワークの仕組みや構成要素，{{①}}の役割及び情報セキュリティを確保するための方法や技術について理解することでは，コンピュータ等を使ってデータをやり取りするためにコンピュータ同士を接続する仕組みや情報通信ネットワークを構成するクライアントやサーバ，ハブ，ルータなどの構成要素の役割について理解するようにする。また，安全かつ効率的な通信を行うためにデータを{{②}}と呼ばれる小さな単位に分けて伝送すること，{{①}}には経路制御や伝送制御など様々な役割があり，これらは複数の{{③}}からなる構造を持つこと，個人認証や情報の暗号化，通信されるデータを暗号化する{{①}}，デジタル署名やデジタル証明書などの情報セキュリティを確保するために開発された技術の仕組みと必要性などについて理解するようにする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["インタフェース", "パケット", "段階"]),
      fill_in_choice.call("イ", ["プロトコル", "メッセージ", "段階"]),
      fill_in_choice.call("ウ", ["インタフェース", "メッセージ", "階層"]),
      fill_in_choice.call("エ", ["プロトコル", "パケット", "階層"], true),
    ],
    explanation_blocks: [
      text_block.call("通信の手順や規則は「プロトコル」，小さな伝送単位は「パケット」，役割を分けた構造は「階層」である。アは①・③，イは②・③，ウは①・②が異なる。接続や操作の接点を表すインタフェース，通信内容としてのメッセージ，時間的な段階と，原文で示す概念を区別する。①は3か所に同じ語句が入る。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』・第1部 情報Ⅰ（4）情報通信ネットワークとデータの活用 ア（ア）（36頁／PDF44頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=44",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次のプログラムは，配列 a の各要素を一つ右の位置へ移し，元の末尾の要素を先頭へ移すものである。空欄 {{①}}・{{②}} に当てはまるものの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "配列の添字は0から始まる。= は代入を表し，行頭の字下げは処理の範囲を表す。range(a, b) は a から b−1 までを1ずつ増やして取り出す。range(a, b, -1) は a から b より大きい整数を1ずつ減らして取り出す。print(a) は配列の要素を先頭から順に表示する。" },
      { type: "code", code: "01 a = [3, 8, 2, 7, 5]\n02 last = a[4]\n03 for i in 【①】:\n04     a[i] = a[i - 1]\n05 a[0] = 【②】\n06 print(a)" },
    ],
    choices: [
      fill_in_choice.call("ア", ["range(4, 0, -1)", "last"], true),
      fill_in_choice.call("イ", ["range(4, 0, -1)", "a[4]"]),
      fill_in_choice.call("ウ", ["range(1, 5)", "last"]),
      fill_in_choice.call("エ", ["range(1, 5)", "a[4]"]),
    ],
    explanation_blocks: [
      text_block.call("末尾の値5を last に退避し，後ろから順に要素を移す。前から移すと，まだ読み取る必要のある値を上書きしてしまう。"),
      {
        type: "table",
        headers: ["処理", "配列 a"],
        rows: [
          ["i = 4", "[3, 8, 2, 7, 7]"],
          ["i = 3", "[3, 8, 2, 2, 7]"],
          ["i = 2", "[3, 8, 8, 2, 7]"],
          ["i = 1", "[3, 3, 8, 2, 7]"],
          ["a[0] = last", "[5, 3, 8, 2, 7]"],
        ],
      },
      text_block.call("ア：正しい。元の全要素を保持しながら，一つ右へ移せる。"),
      text_block.call("イ：05行の時点で a[4] は7に変わっているため，結果は [7, 3, 8, 2, 7] となる。退避した last を使う必要がある。"),
      text_block.call("ウ：前から移すため，元の先頭の値3で後続の要素が順に上書きされ，結果は [5, 3, 3, 3, 3] となる。"),
      text_block.call("エ：前からの上書きと，変更後の a[4] の参照が重なり，結果は [3, 3, 3, 3, 3] となる。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習14（1）リスト（122頁／PDF28頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=28",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "次の表は，二つの学級A・Bにおける，同じ小テストの得点の最小値，第1四分位数，中央値，第3四分位数及び最大値を示したものである。範囲と四分位範囲を用いて得点の散らばりを比較した記述の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "table",
        headers: ["学級", "最小値", "第1四分位数", "中央値", "第3四分位数", "最大値"],
        rows: [
          ["A", "30", "45", "60", "80", "95"],
          ["B", "20", "50", "60", "70", "100"],
        ],
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "table",
            headers: ["範囲による比較", "四分位範囲による比較"],
            rows: [
              ["Aの方が大きい", "Aの方が大きい"],
            ],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "table",
            headers: ["範囲による比較", "四分位範囲による比較"],
            rows: [
              ["Bの方が大きい", "Aの方が大きい"],
            ],
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "table",
            headers: ["範囲による比較", "四分位範囲による比較"],
            rows: [
              ["Aの方が大きい", "Bの方が大きい"],
            ],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "table",
            headers: ["範囲による比較", "四分位範囲による比較"],
            rows: [
              ["Bの方が大きい", "Bの方が大きい"],
            ],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      text_block.call("範囲は「最大値−最小値」，四分位範囲は「第3四分位数−第1四分位数」で求める。"),
      {
        type: "table",
        headers: ["学級", "範囲", "四分位範囲"],
        rows: [
          ["A", "95−30＝65", "80−45＝35"],
          ["B", "100−20＝80", "70−50＝20"],
        ],
      },
      text_block.call("ア：四分位範囲の比較は正しいが，範囲はAよりBの方が大きい。"),
      text_block.call("イ：正しい。最小値から最大値までの広がりはBの方が大きい一方，第1四分位数から第3四分位数までの広がりはAの方が大きい。用いる指標によって比較結果が異なる。"),
      text_block.call("ウ：範囲と四分位範囲の比較が，どちらも逆になっている。"),
      text_block.call("エ：範囲の比較は正しいが，四分位範囲はBよりAの方が大きい。"),
    ],
    source_text: "総務省統計局「なるほど統計学園」データの散らばりを捉える・範囲／四分位数・四分位範囲 | https://www.stat.go.jp/naruhodo/5_tokucho/chirabari.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験21の承認済み問番号は1〜20です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験21 問#{number}は4択・正答1件にしてください"
  end
  if number <= 5 && question.fetch(:category_code) != (number <= 2 ? "education_foundations" : "education_system")
    raise "模擬試験21 問#{number}の分類が不正です"
  end
  expected_category = { 11 => "student_guidance_career", 12 => "special_support_education",
    13 => "educational_psychology", 14 => "educational_psychology", 15 => "education_system" }[number]
  if expected_category && question.fetch(:category_code) != expected_category
    raise "模擬試験21 問#{number}の分類が不正です"
  end
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  required_cloze = (4..10).cover?(number) || number == 11
  if required_cloze
    expected_labels = if number == 11
      %w[① ②]
    elsif number == 15
      %w[① ② ③]
    else
      %w[① ② ③ ④]
    end
    quote_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = if number >= 6
      prompt_labels == [expected_labels.first, expected_labels.last]
    else
      prompt.fetch(:text).match?(/空欄 ① ～ ④/)
    end
    unless prompt[:type] == "fill_in_text" && quotes.any? && (number <= 5 || quotes.size == 1) &&
        quote_labels == expected_labels && introduction_labels_match &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == expected_labels.size }
      raise "模擬試験21 問#{number}の空欄と選択肢の対応が不正です"
    end
    if [4, 5].include?(number) && !quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) }
      raise "模擬試験21 問#{number}の抜粋枠には条番号を表示してください"
    end
  elsif number >= 16 && choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } }
    labels = blocks.drop(1).flat_map do |block|
      block[:type] == "code" ? block.fetch(:code).scan(/【([①②③])】/).flatten : block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten
    end.uniq
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten.uniq
    quote_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten }.uniq
    valid_body = number == 19 ? blocks.count { |block| block[:type] == "code" } == 1 : quotes.size == 1 && quote_labels == labels
    unless [%w[① ②], %w[① ② ③]].include?(labels) && prompt[:type] == "fill_in_text" &&
        prompt_labels == [labels.first, labels.last] && valid_body &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == labels.size }
      raise "追加問題の空欄と選択肢の対応が不正です"
    end
  elsif !choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && (number == 20 ? %w[text table] : %w[text]).include?(choice.fetch(:content_blocks).first[:type]) }
    raise "模擬試験21 問#{number}の選択肢形式が不正です"
  end
  if [6, 7].include?(number)
    scope = number == 6 ? "第3款" : "第5款"
    unless prompt.fetch(:text).include?("第1章 総則 #{scope}") && question.fetch(:source_text).include?("第1章#{scope}")
      raise "模擬試験21 問#{number}の導入文と出典範囲が一致しません"
    end
  end
  entry = { exam_number: 21, attributes: question, publication_status: "published" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(21, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験21の全20問の正答位置は各記号5件にしてください"
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, section = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, "第1部"] : [3, "第2部"]
  elsif prompt.include?("第2章") && prompt.include?("第10節")
    [0, "第2章第10節"]
  else
    [1, "第3章第7節"]
  end
  unless source.include?(section) && prompt.include?("解説 情報編") == source.include?("解説 情報編") &&
      question.fetch(:major_category_code) == "information" && %w[information_education information_specialized].include?(question.fetch(:category_code))
    raise "情報科の導入文・出典範囲・分類が不正です"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "問16〜18は異なる3範囲を資料順に並べてください"
end
unless questions.last(2).all? { |question| question.fetch(:major_category_code) == "information" && question.fetch(:category_code) == "information_specialized" }
  raise "問19・20の分類が不正です"
end

QuestionSeedSync.import(exam_number: 21, questions: questions, publication_status: "published")

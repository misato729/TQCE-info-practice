text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験30（承認済みの全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "戦後日本の教育改革に関する次の①～④の出来事を，起こった時期が早いものから順に並べたものとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("①　内閣に教育刷新委員会が設置され，新しい学校制度や教育行政の在り方など，戦後の教育改革の基本方針について審議・建議を行った。"),
      text_block.call("②　内閣総理大臣の諮問機関として臨時教育審議会が発足し，教育の諸問題について文部省の所管にとどまらず政府全体で取り組む改革の検討が始まった。"),
      text_block.call("③　中央教育審議会が『21世紀を展望した我が国の教育の在り方について』の第一次答申をまとめ，自ら学び，自ら考える資質・能力などからなる「生きる力」を重視する方針を示した。"),
      text_block.call("④　中央教育審議会が『今後における学校教育の総合的な拡充整備のための基本的施策について』を答申し，幼稚園から大学までの学校教育の改革を総合的に提言した。"),
    ],
    choices: [
      text_choice.call("ア", "① → ② → ④ → ③"),
      text_choice.call("イ", "① → ④ → ③ → ②"),
      text_choice.call("ウ", "① → ② → ③ → ④"),
      text_choice.call("エ", "① → ④ → ② → ③", true),
    ],
    explanation_blocks: [
      text_block.call("①は昭和21年（1946年）の教育刷新委員会，④は昭和46年（1971年）の中央教育審議会答申，②は昭和59年（1984年）の臨時教育審議会の発足，③は平成8年（1996年）の中央教育審議会第一次答申である。"),
      text_block.call("ア：昭和46年の答申と，昭和59年の臨時教育審議会発足の順序が逆。"),
      text_block.call("イ：平成8年の「生きる力」の答申を，昭和59年の臨時教育審議会発足より前にしている。"),
      text_block.call("ウ：昭和46年の答申を，昭和59年及び平成8年の出来事より後にしている。"),
      text_block.call("エ：正しい。① → ④ → ② → ③となる。"),
    ],
    source_text: "文部科学省『学制百二十年史』「概説」・教育刷新委員会の設置 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318255.htm\n文部科学省『学制百年史』「結語」・中教審答申と教育改革 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317884.htm\n文部科学省『学制百二十年史』「二 臨時教育審議会の発足」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318296.htm\n文部科学省「新学習指導要領のねらいと［確かな学力］の育成について」・平成8年中央教育審議会答申 | https://www.mext.go.jp/a_menu/shotou/gakuryoku/reference.htm\n文部科学省「研究開発学校に関連する審議会答申等」・中央教育審議会第一次答申（平成8年7月19日） | https://curriculumdb.mext.go.jp/bc/kk/kk06/06",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "デュルケームとアリエスの教育及び子どもに関する研究について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "デュルケームは，教育を社会との関係から捉え，日常の共同生活の中で意図せず習慣が形成されることを「方法的社会化」とした。アリエスは，絵画や家族生活などを手掛かりに，子どもに対する見方の歴史的な変化を検討した。"),
      text_choice.call("イ", "デュルケームは，社会が求める資質を若い世代に形成することを教育の役割とした。そのうち「共通の教育」は，職業上の役割ごとに異なる専門的資質を育てるものである。アリエスは，家族や学校の変化と子ども観との関係を論じた。"),
      text_choice.call("ウ", "デュルケームは，教育を若い世代に対する意図的・組織的な社会化として捉えた。アリエスは，生物学的な成長と区別して，子どもに対する見方や，家族・学校の中での子どもの位置付けを歴史的に検討した。", true),
      text_choice.call("エ", "デュルケームは，『〈子供〉の誕生』で教育を社会的な事実として研究した。アリエスは，『教育と社会学』で家族や学校における子どもの扱いの変化を論じ，子ども観を歴史的に検討する視点を示した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：誤り。方法的社会化は，若い世代を対象とする意図的・計画的・組織的な教育を指す。日常生活で意図せず生じる社会化と取り違えている。アリエスに関する説明は適切。"),
      text_block.call("イ：誤り。共通の教育は，同じ社会の成員として共有する資質を育てるものである。職業などに応じた特有の役割に関わる資質は，専門的・特殊な教育の側面。アリエスに関する説明は適切。"),
      text_block.call("ウ：適切。教育の社会的性格と方法的社会化，子ども観の歴史的研究という両者の中心的な観点に対応している。「昔は子どもの年齢差を全く認識していなかった」という極端な一般化ではない。"),
      text_block.call("エ：誤り。著作の帰属が逆。『教育と社会学』がデュルケーム，『〈子供〉の誕生』がアリエスである。"),
    ],
    source_text: "黒田経子「デュルケーム・『教育と社会学』の再検討―社会・子ども・教育―」191〜192頁 | https://soka.repo.nii.ac.jp/record/37605/files/soudaikyoikukenkyu0_1_10.pdf\n名古屋大学OCW「人間発達科学Ⅰ」第4回「〈子ども〉の発見①」、2〜6ページ | https://ocw.nagoya-u.jp/files/246/yoshikawa-4.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次の①～④は，「教育基本法」（平成18年法律第120号）に関する記述である。正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "①　法律に定める学校では，教育を受ける者の心身の発達に応じ，体系的な教育を組織的に行わなければならない。その際，学校生活に必要な規律を重んずることと，自ら進んで学習に取り組む意欲を高めることを，ともに重視するものとされている。" },
      { type: "fill_in_quote", text: "②　国及び地方公共団体が設置する学校では，特定の宗教のための宗教教育その他宗教的活動をしてはならない。一方，宗教に関する寛容の態度，一般的な教養及び宗教の社会生活における地位は，教育上尊重されなければならない。" },
      { type: "fill_in_quote", text: "③　私立学校は，公の性質と学校教育における重要な役割を有するが，その自主性も尊重される。このため，特定の政党を支持し，又はこれに反対するための政治教育その他政治的活動については，その自主性に基づいて行うことが認められている。" },
      { type: "fill_in_quote", text: "④　法律に定める学校の教員については，その使命と職責の重要性にかんがみ，身分の尊重及び待遇の適正が確保されていることを要件として，養成と研修の充実を図ることが定められている。教員自身が研究と修養に励み，職責の遂行に努めることも定められている。" },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("①：正しい。第6条第2項の体系的・組織的な教育と，規律及び自発的な学習意欲の重視に一致する。"),
      text_block.call("②：正しい。第15条第2項の国公立学校における特定宗教のための宗教教育等の禁止と，第1項の宗教に関する寛容の態度，一般的な教養及び社会生活における地位の尊重に一致する。"),
      text_block.call("③：誤り。第8条による私立学校の自主性の尊重は，第14条第2項の政治教育等の禁止の例外を定めるものではない。第14条第2項の対象は「法律に定める学校」であり，私立学校も含まれる。"),
      text_block.call("④：誤り。第9条第2項は，使命と職責の重要性にかんがみ，身分の尊重・待遇の適正と，養成・研修の充実を併せて定めている。前者の確保を後者の法的要件とする規定ではない。後半の教員自身の研究・修養と職責の遂行は，第1項と一致する。"),
      text_block.call("正しいものは①②の二つなのでイが正答である。アは正しい記述を一つ多く，ウは一つ少なく数えている。エの「なし」でもない。"),
    ],
    source_text: "教育基本法・第6条第2項，第8条，第9条，第14条第2項，第15条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_14",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第43条\n\n小学校は、当該小学校に関する保護者及び地域住民その他の関係者の{{①}}を深めるとともに、これらの者との{{②}}の推進に資するため、当該小学校の{{③}}に関する情報を{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["理解","連携及び協力","教育活動その他の学校運営の状況","積極的に提供するものとする"], true),
      fill_in_choice.call("イ", ["理解","連携及び協力","教育課程の編成及び実施の状況","求めに応じて提供するものとする"]),
      fill_in_choice.call("ウ", ["認識","協議及び調整","教育活動その他の学校運営の状況","積極的に提供するものとする"]),
      fill_in_choice.call("エ", ["認識","協議及び調整","教育課程の編成及び実施の状況","求めに応じて提供するものとする"]),
    ],
    explanation_blocks: [
      text_block.call("第43条は、保護者・地域住民等の理解を深め、連携及び協力を進めるために、教育活動その他の学校運営の状況に関する情報を積極的に提供することを定める。教育課程に関する情報だけを、求められたときに提供するという規定ではない。"),
      text_block.call("ア：四つの語句が全て原文と一致する。"),
      text_block.call("イ：③は「教育活動その他の学校運営の状況」、④は「積極的に提供するものとする」。情報の対象を教育課程の編成・実施へ狭め、提供のあり方も求めに応じる形へ変更している。"),
      text_block.call("ウ：①は「理解」、②は「連携及び協力」。関係者との協議・調整が実践として不要という意味ではなく、この条文の目的として明記される語句が異なる。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第43条は第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法第43条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_43\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語・参照先の補足（抜粋枠外）：「研修実施者実施研修」は、研修実施者が実施する初任者研修、中堅教諭等資質向上研修その他の研修を指す。第26条第1項は、大学院等の課程に在学して履修するための休業とその許可の要件に関する規定である。「大学院の課程等」は、大学（短期大学を除く。）の大学院の課程若しくは専攻科の課程又はこれらに相当する外国の大学の課程を指す。" },
      { type: "fill_in_quote", text: "第22条の5　公立の小学校等の校長及び教員の任命権者は、文部科学省令で定めるところにより、当該校長及び教員ごとに、研修の受講その他の当該校長及び教員の資質の向上のための取組の状況に関する記録（以下この条及び次条第二項において「研修等に関する記録」という。）を作成しなければならない。\n\n２　研修等に関する記録には、次に掲げる事項を記載するものとする。\n\n一　当該校長及び教員が{{①}}研修実施者実施研修に関する事項\n\n二　第二十六条第一項に規定する{{②}}により当該教員が履修した同項に規定する大学院の課程等に関する事項\n\n三　認定講習等（教育職員免許法（昭和二十四年法律第百四十七号）別表第三備考第六号の文部科学大臣の認定する講習又は通信教育をいう。次条第一項及び第三項において同じ。）のうち{{③}}ものであつて、当該校長及び教員が単位を修得したものに関する事項\n\n四　前三号に掲げるもののほか、当該校長及び教員が行つた資質の向上のための取組のうち{{④}}ものに関する事項" },
    ],
    choices: [
      fill_in_choice.call("ア", ["受講した","大学院修学休業","文部科学大臣が開設した","当該校長及び教員が必要と認める"]),
      fill_in_choice.call("イ", ["受講を申し込んだ","現職のままで受ける長期研修","当該任命権者が開設した","当該校長及び教員が必要と認める"]),
      fill_in_choice.call("ウ", ["受講を申し込んだ","現職のままで受ける長期研修","文部科学大臣が開設した","当該任命権者が必要と認める"]),
      fill_in_choice.call("エ", ["受講した","大学院修学休業","当該任命権者が開設した","当該任命権者が必要と認める"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが、③は「当該任命権者が開設した」、④は「当該任命権者が必要と認める」。認定講習等を認定する文部科学大臣と、この号で記録対象となる講習等の開設者を取り違えている。その他の取組を必要と認める主体も、校長・教員本人ではなく任命権者である。"),
      text_block.call("イ：③は正しいが、①は実際に「受講した」研修、②は「大学院修学休業」、④は「当該任命権者が必要と認める」。申込みの段階を受講した状態と同一に扱い、現職のまま受ける長期研修を別に定められた休業と混同している。"),
      text_block.call("ウ：④は正しいが、①は「受講した」、②は「大学院修学休業」、③は「当該任命権者が開設した」である。認定する者と開設する者の区別にも注意する。"),
      text_block.call("エ：4語句が原文と一致する。記録する事項には、受講した所定の研修、大学院修学休業で履修した課程、任命権者が開設し単位を修得した認定講習等、その他任命権者が必要と認める資質向上の取組が含まれる。"),
    ],
    source_text: "教育公務員特例法・第22条の5第1項〜第2項、第22条の4第2項第1号・第26条第1項（補足）、第22条第3項（比較） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22_5",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒の{{①}}などを積極的に評価し，学習したことの意義や価値を実感できるようにすること。また，{{②}}に向けた学習状況を把握する観点から，単元や題材など内容や時間のまとまりを見通しながら評価の場面や方法を工夫して，{{③}}を評価し，指導の改善や学習意欲の向上を図り，{{④}}に生かすようにすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["よい点や進歩の状況", "各教科・科目等の内容の習得", "学習の過程や成果", "各教科・科目の単位の修得"]),
      fill_in_choice.call("イ", ["課題の達成度や学習の到達水準", "各教科・科目等の内容の習得", "課題の正誤や達成度", "資質・能力の育成"]),
      fill_in_choice.call("ウ", ["よい点や進歩の状況", "各教科・科目等の目標の実現", "学習の過程や成果", "資質・能力の育成"], true),
      fill_in_choice.call("エ", ["課題の達成度や学習の到達水準", "各教科・科目等の目標の実現", "課題の正誤や達成度", "各教科・科目の単位の修得"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は正しいが，②④が異なる。評価の観点は各教科・科目等の目標の実現に向けた学習状況を把握することであり，評価を資質・能力の育成に生かすと記されている。単位の修得認定と同一の規定ではない。"),
      text_block.call("イ：④は正しいが，①②③が異なる。肯定的に評価する対象はよい点・進歩の状況，状況把握の観点は目標の実現，評価する対象は学習の過程や成果である。課題の正誤や到達水準だけに語句を置き換えない。"),
      text_block.call("ウ：全て原文と一致する。生徒のよい点や進歩を捉え，目標の実現に向けた学習の過程・成果を評価し，指導改善や意欲向上を通じて資質・能力の育成に生かす。"),
      text_block.call("エ：②は正しいが，①③④が異なる。①はよい点や進歩，③は学習の過程や成果，④は資質・能力の育成である。評価の教育的な働きを，課題の達成度や単位認定に置き換えない。"),
    ],
    source_text: "高等学校学習指導要領 第1章 総則 第3款2 学習評価の充実（1）全文（印刷29頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）学習の遅れがちな生徒などについては，各教科・科目等の選択，その内容の取扱いなどについて必要な配慮を行い，{{①}}に応じ，例えば義務教育段階の学習内容の確実な定着を図るための指導を適宜取り入れるなど，{{②}}を工夫すること。\n\n２ 特別な配慮を必要とする生徒への指導\n\n（1）障害のある生徒などへの指導\n\nア 障害のある生徒などについては，特別支援学校等の{{③}}を活用しつつ，個々の生徒の障害の状態等に応じた{{②}}の工夫を{{④}}に行うものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生徒の実態", "指導内容や指導方法", "助言又は援助", "組織的かつ計画的"], true),
      fill_in_choice.call("イ", ["生徒の実態", "指導内容や指導方法", "施設や設備", "専門的かつ継続的"]),
      fill_in_choice.call("ウ", ["学校の指導計画", "評価規準や評価方法", "助言又は援助", "専門的かつ継続的"]),
      fill_in_choice.call("エ", ["学校の指導計画", "評価規準や評価方法", "施設や設備", "組織的かつ計画的"]),
    ],
    explanation_blocks: [
      text_block.call("ア：正しい。学習の遅れがちな生徒への指導は生徒の実態に応じて指導内容や指導方法を工夫する。障害のある生徒への指導も状態等に応じた内容・方法を工夫し，特別支援学校等の助言又は援助を活用して組織的かつ計画的に行う。"),
      text_block.call("イ：①②は正しいが，③④が原文と異なる。特別支援学校等から活用するものとして助言又は援助が示され，指導の工夫は組織的かつ計画的に行うものとされる。"),
      text_block.call("ウ：③は正しいが，①②④が原文と異なる。学校の指導計画ではなく生徒の実態に応じて工夫し，評価規準や評価方法ではなく指導内容や指導方法が示される。取組の構造も専門的かつ継続的ではなく組織的かつ計画的である。"),
      text_block.call("エ：④は正しいが，①②③が原文と異なる。個々の生徒に即した指導内容・方法の工夫と，特別支援学校等の助言又は援助の活用を，学校の計画・評価・施設設備へ置き換えている。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第1章第5款1（6）〜2（1）ア、印刷30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第9章 総合的な探究の時間の学習指導 第2節 総合的な探究の時間における『主体的・対話的で深い学び』」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「対話的な学び」とは，他者との協働や{{①}}を通じて，自らの考えを広げ深めるような学びである。以前より，他者とともに探究に取り組むことを大切にしてきたように，探究の過程を質的に高めていくためには，引き続き異なる多様な他者と力を合わせて課題の解決に向かうことが欠かせない。\nここで行われる異なる多様な他者と対話することには，次の三つの価値が考えられる。一つは，他者への説明による情報としての{{②}}の構造化である。生徒は身に付けた{{②}}を使って相手に説明して話すことで，つながりのある構造化された情報へと変容させていく。二つは，{{③}}である。多様な情報が他者から供給されることで，構造化は質的に高まるものと考えられる。三つは，他者とともに新たな知を創造する場の構築と{{④}}への期待などである。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["外界との相互作用", "考え方や方法", "他者からの多様な情報収集", "学習過程の振り返り"]),
      fill_in_choice.call("イ", ["自己の知識の体系化", "知識や技能", "他者との共通理解の形成", "学習過程の振り返り"]),
      fill_in_choice.call("ウ", ["自己の知識の体系化", "考え方や方法", "他者との共通理解の形成", "課題解決に向けた行動化"]),
      fill_in_choice.call("エ", ["外界との相互作用", "知識や技能", "他者からの多様な情報収集", "課題解決に向けた行動化"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は原文と一致するが，②は「知識や技能」，④は「課題解決に向けた行動化」である。説明を通して身に付けた知識・技能を構造化し，他者との知の創造を行動につなげることが示されている。"),
      text_block.call("イ：②は原文と一致するが，①③④が異なる。定義は外界との相互作用を挙げ，対話の価値として他者からの多様な情報収集と課題解決に向けた行動化を示している。共通理解や振り返りを原語に置き換えない。"),
      text_block.call("ウ：④は原文と一致するが，①②③が異なる。外界との相互作用，知識や技能の構造化，他者からの多様な情報収集が原語である。「考え方や方法」は両方の代入箇所で文章になるが，原典が構造化するものとして挙げた語句とは異なる。"),
      text_block.call("エ：全て原文と一致する。外界との相互作用を通して考えを広げ深め，説明による知識・技能の構造化，情報収集，新たな知の創造と行動化を対話の価値として示す。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編 第9章 総合的な探究の時間の学習指導 第2節 総合的な探究の時間における「主体的・対話的で深い学び」2「対話的な学び」の視点，冒頭から対話の三つの価値まで（印刷121頁） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=129",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "参考：抜粋中の「第1款の2の（2）に示す道徳教育の目標」は，人間としての在り方生き方を考え，主体的な判断の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことを指す。" },
      { type: "fill_in_quote", text: "各学校においては，第１款の２の（2）に示す道徳教育の目標を踏まえ，道徳教育の全体計画を作成し，{{①}}の下に，道徳教育の推進を主に担当する教師（「道徳教育推進教師」という。）を中心に，{{②}}が協力して道徳教育を展開すること。なお，道徳教育の全体計画の作成に当たっては，生徒や学校の実態に応じ，指導の方針や重点を明らかにして，{{③}}を明らかにすること。その際，公民科の「公共」及び「倫理」並びに特別活動が，人間としての在り方生き方に関する{{④}}の場面であることに配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["校長の方針", "各ホームルーム担任", "各教科・科目等との関係", "補完的な指導"]),
      fill_in_choice.call("イ", ["校長の方針", "全教師", "各教科・科目等との関係", "中核的な指導"], true),
      fill_in_choice.call("ウ", ["教育委員会の方針", "全教師", "教科等横断的な学習の評価基準", "補完的な指導"]),
      fill_in_choice.call("エ", ["教育委員会の方針", "各ホームルーム担任", "教科等横断的な学習の評価基準", "中核的な指導"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②④が異なる。道徳教育推進教師を中心に協力する範囲は「全教師」で，各ホームルーム担任に置き換えない。公民科の「公共」及び「倫理」並びに特別活動の位置付けは「中核的な指導」で，補完的な指導ではない。"),
      text_block.call("イ：全て原文と一致する。校長の方針の下に全教師が協力し，全体計画では各教科・科目等との関係を明らかにする。公民科の「公共」及び「倫理」並びに特別活動を，人間としての在り方生き方に関する中核的な指導の場面として位置付ける。"),
      text_block.call("ウ：①③④が異なる。①は「校長の方針」であり，教育委員会の方針への置換ではない。③は「各教科・科目等との関係」，④は「中核的な指導」である。評価基準を設定することの是非ではなく，全体計画で明らかにする対象と，指導場面の位置付けを区別する。"),
      text_block.call("エ：①②③が異なる。①は「校長の方針」，②は「全教師」，③は「各教科・科目等との関係」である。道徳教育を担当する教師の範囲を各ホームルーム担任へ狭めるものではなく，全体計画で明らかにするものも教科等横断的な学習の評価基準への置換ではない。"),
    ],
    source_text: "第1章 総則 第7款1全文（抜粋：PDF34頁／印刷32頁，目標の補足：第1款2(2)第2段落，PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34\n参照先の道徳教育の目標 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』（平成30年7月文部科学省）の「第4章 指導計画の作成と内容の取扱い 第1節 指導計画の作成に当たっての配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学校教育には，{{①}}には位置付けられていないが教育的意義が大きく，特別活動と関連が深い「ショートホームルーム」（朝の会や帰りの会など），日常に行われている清掃や日直などの当番の活動，さらに，放課後等に生徒の{{②}}な参加により行われる部活動などがあるが，これらとの関連などについても，特別活動の{{③}}に示しておくことも大切である。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育課程", "自主的，自発的", "各活動・学校行事の年間指導計画"]),
      fill_in_choice.call("イ", ["年間指導計画", "積極的，継続的", "各活動・学校行事の年間指導計画"]),
      fill_in_choice.call("ウ", ["年間指導計画", "積極的，継続的", "全体計画"]),
      fill_in_choice.call("エ", ["教育課程", "自主的，自発的", "全体計画"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③が異なる。教育課程外の活動との関連を示す先は，特別活動の「全体計画」であり，各活動・学校行事の年間指導計画に置き換えない。"),
      text_block.call("イ：全て原文と異なる。①は教育課程，②は自主的，自発的，③は全体計画である。活動の教育課程上の位置付け，参加の性格，全体計画の役割を区別する。"),
      text_block.call("ウ：③は正しいが，①②が異なる。これらは教育課程には位置付けられていないが教育的意義が大きい活動であり，部活動への参加は自主的，自発的と記される。"),
      text_block.call("エ：全て原文と一致する。教育課程に位置付けられていないが特別活動と関連の深い諸活動についても，全体計画に関連を示しておく。活動・行事別の年間指導計画と区別する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 特別活動編・第4章第1節2、印刷106〜107頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=114",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。下の表は，同資料の「第10章 不登校 10.2.2 教育相談を支える教職員の連携・協働」に列挙された校内の職名・役割名と，不登校児童生徒への支援における役割の一部を整理したものである。表中の空欄 {{①}}・{{②}}・{{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "日本の学校では、学級・ホームルーム担任が学習指導のみならず、学級・ホームルームで、児童生徒に寄り添い、生活面全般についての指導・援助も担当しています。このことは、集団の中において個別指導を行う上で、有効なシステムと言えます。\n\n不登校をはじめ、児童生徒への生徒指導においては、最も身近で密接な関わりを持つ学級・ホームルーム担任が、「いつでも」、「どこでも」、「だれにでも」、個別指導をする機会を持つことができます。また、深刻な悩みや課題を抱え、特別な指導や援助を必要とする児童生徒に対して第一義的に関わるのも、学級・ホームルーム担任です。しかし、学級・ホームルーム担任一人だけでは解決を図ることが困難な場合も少なくなく、不登校児童生徒への支援もその例外ではありません。\n\n学校内には、不登校児童生徒に関わる際の要とも言える役割を有する者がいます。その人たちが、学級・ホームルーム担任を支え、協力して不登校児童生徒を支援することが重要です。" },
      { type: "text", text: "以下の表は，原典に列挙された説明を整理したものであり，原典に掲載された表そのものではない。" },
      { type: "table", headers: ["職名・役割名", "不登校児童生徒への支援における役割"], rows: [["【①】", "心身両面から児童生徒の健康に関わる。学級・ホームルーム担任や保護者と連絡し，不登校の早期発見や保健室登校の提案・対応に関わる。"], ["【②】", "教職員という立場でカウンセリングや相談業務に関わる。即時的なニーズへの対応や，他の教職員との連携の行いやすさという利点を持つ。"], ["【③】", "主に発達障害等の特別な支援を必要とする児童生徒を支援する。校内委員会や研修会の企画・運営，関係諸機関との連絡・調整，保護者からの相談窓口等を担う。"]] },
    ],
    choices: [
      fill_in_choice.call("ア", ["保健主事", "教育相談コーディネーター", "生徒指導主事"]),
      fill_in_choice.call("イ", ["養護教諭", "スクールカウンセラー", "特別支援教育コーディネーター"]),
      fill_in_choice.call("ウ", ["養護教諭", "教育相談コーディネーター", "特別支援教育コーディネーター"], true),
      fill_in_choice.call("エ", ["保健主事", "スクールカウンセラー", "生徒指導主事"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③が異なる。原典の①の説明は養護教諭，③の説明は特別支援教育コーディネーターの役割として列挙されている。健康への直接的な関わりと，特別支援教育を推進する校内委員会・研修等の調整を，原典の対応に沿って区別する。"),
      text_block.call("イ：①③は原典の対応と一致するが，②が異なる。教職員という立場を活かし，即時的なニーズへの対応や他の教職員との連携を行いやすいという説明は，原典では教育相談コーディネーターに対応する。学校配置のスクールカウンセラーも教職員であることとは区別する。"),
      text_block.call("ウ：全て原典の対応と一致する。養護教諭による心身の健康への関わり，教育相談コーディネーターによる相談業務，特別支援教育コーディネーターによる特別な支援の推進を，学級・ホームルーム担任と協働する校内の役割として示している。"),
      text_block.call("エ：全て原典の対応と異なる。①は養護教諭，②は教育相談コーディネーター，③は特別支援教育コーディネーターの説明である。保健主事や生徒指導主事が健康・支援に関わらないという意味ではなく，原典が列挙した役割との対応を問う。"),
    ],
    source_text: "第10章 不登校 10.2.2 教育相談を支える教職員の連携・協働、本文227〜228頁（抜粋・表の根拠は227頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=230",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "text", text: "情緒障害のある生徒の状態の把握に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "怒り発作，離席や教室からの抜け出しは，外在化問題行動として把握する。これらは不注意・多動性に由来する状態として整理し，年齢に比べた活動性の高さを，情緒障害の程度を評価する中心的な基準とする。", true),
      text_choice.call("イ", "本人が困難を感じていても，それが目立つ行動として現れず，学校生活に適応しているようにみえる場合がある。周囲からみた行動に加え，本人の感じる負担や，その背景となる状況を把握する。"),
      text_choice.call("ウ", "爪かみや身体を揺らすといった行動には，習慣性の癖と考えられるものもある。長期間，頻回に続き，学習や集団行動に支障を生じているかを確かめ，その行動の形と生活への影響を併せて把握する。"),
      text_choice.call("エ", "感情や気分が不安定なときに，腹痛や気分の不快さなどを訴える場合がある。身体的な不調や医療機関の情報も把握し，対人関係，学校生活などの背景との関連を含めて状態を捉える。"),
    ],
    explanation_blocks: [
      text_block.call("ア：不適切。外在化問題行動にはこれらの行動が含まれるが，その原因を不注意・多動性に対応させる説明が誤り。手引は，環境からのストレスに伴う反応として内在化・外在化を整理している。活動性の高さをそのまま情緒障害の程度の基準にするものではない。"),
      text_block.call("イ：適切。外から目立つ問題が見えないことと，本人の困難が軽いことは同じではない。"),
      text_block.call("ウ：適切。行動があるという事実だけでなく，持続性，頻度，学習や集団行動への支障を把握する。"),
      text_block.call("エ：適切。情緒の不安定さは身体的な訴えに現れることもあり，身体面と心理・生活面の情報を併せて検討する。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅷ「情緒障害」冒頭，1(2)①ア(ア)c及び(イ)a・b（266〜269頁、分割PDF1〜4ページ） | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_12.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "コールバーグの道徳性発達理論において，行為が正しいと考える理由と発達水準との対応に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "他者からよい人と認められ，身近な人の期待に応えることを重視する判断は，前慣習的水準に位置付けられる。社会の秩序を保ち，法律や自分の義務を尊重する判断は，慣習的水準に位置付けられる。"),
      text_choice.call("イ", "集団や社会を維持するために，規則や法律を尊重する判断は，慣習的水準に位置付けられる。自分の利害や欲求を満たせることを行為の根拠とする判断は，脱慣習的水準に位置付けられる。"),
      text_choice.call("ウ", "規則や法律の正当性を，公正さや個人の尊厳などの原理から検討する判断は，脱慣習的水準に位置付けられる。罰を避けられることや自分の利害を満たせることを重視する判断は，前慣習的水準に位置付けられる。", true),
      text_choice.call("エ", "罰を避けられることを行為の根拠とする判断は，前慣習的水準に位置付けられる。社会にある規則そのものの正当性を，公正さや個人の尊厳などの原理に照らして検討する判断は，慣習的水準に位置付けられる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：後半は適切だが，前半が誤り。他者からの承認や身近な人の期待への応答を重視する判断は，前慣習的水準ではなく慣習的水準に位置付けられる。"),
      text_block.call("イ：前半は適切だが，後半が誤り。自分の利害や欲求の充足を根拠とする判断は，脱慣習的水準ではなく前慣習的水準に位置付けられる。"),
      text_block.call("ウ：適切。脱慣習的水準では，具体的な規則の背後にある公正さや人間の尊厳などの原理に判断の根拠を求める。前慣習的水準では，罰の回避や自分の利害・欲求が判断の根拠となる。"),
      text_block.call("エ：前半は適切だが，後半が誤り。社会の規則や法律を，より普遍的な道徳原理から検討するのは脱慣習的水準である。慣習的水準では，集団や社会の期待，秩序，規則を維持することが重視される。"),
    ],
    source_text: "折口量祐「コールバーグにおける教育目的と道徳的判断に関する考察」『早稲田大学大学院教育学研究科紀要 別冊』24号－1，3-2-1「分化」と「規範性」（54頁，PDF6ページ） | https://waseda.repo.nii.ac.jp/record/10589/files/KyoikugakuKenkyukaKiyoBetsu_24_1_Origuchi.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "セリグマンらの研究に基づく学習性無力感に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "学習性無力感は，自分の行動では結果を変えられない経験に関わる。その経験の後，行動によって結果を変えられる状況に移ると，先行経験が手掛かりとなり，結果を変える行動の学習が促進される。"),
      text_choice.call("イ", "学習性無力感は，自分の行動と結果とが結び付かない経験を通して，結果を統制できないという期待が形成されることに関わる。その期待が，後に結果を統制できる状況での行動や学習を妨げることがある。", true),
      text_choice.call("ウ", "学習性無力感は，ある結果を得るために必要な行動を，自分が遂行できるという見込みの低さを指す。行動を実行すれば結果を変えられるという期待が保たれている状態を，その定義の中心とする。"),
      text_choice.call("エ", "学習性無力感は，失敗した際の自己評価や他者からの評価を守るため，実力を発揮しにくい条件を自ら用意することを指す。その条件へ失敗の原因を帰属できるようにして，能力への評価を保とうとする。"),
    ],
    explanation_blocks: [
      text_block.call("ア：統制不可能な経験に関わる点は適切です。しかし，後に統制可能になった状況でも，試行や新しい学習が妨げられるというのが，学習性無力感の重要な点です。後の学習を促進するという説明が誤りです。"),
      text_block.call("イ：適切です。先行する経験から形成された統制不可能性の期待が，後の行動や学習へ影響するという説明です。実際には改善できる状況でも，働き掛けを試みる意欲や学習が損なわれることがあります。"),
      text_block.call("ウ：必要な行動を自分が遂行できるかという見込みは，自己効力感に関わります。学習性無力感で中心となるのは，行動によって結果を統制できるかという期待です。両者を同一の概念にはしません。"),
      text_block.call("エ：セルフ・ハンディキャッピングの説明です。失敗の理由となる条件を用意して能力への評価を守ることと，自分の行動では結果を変えられないと学習することとは区別されます。"),
    ],
    source_text: "日本心理学会『心理学ワールド』102号・市川伸一「学習意欲の心理学」，「学習性無力感」「結果期待と効力期待」「やる気を抑制する心のしくみ」。 | https://psych.or.jp/publication/world102/pw19/\n光浪睦美「統制不可能性とフィードバックが学習性無力感に及ぼす効果―情動と予期の変動に着目して―」日本心理学会第71回大会，本文「目的」の冒頭（行動と結果の非随伴性，統制不可能性の予期というLH理論の説明）。 | https://doi.org/10.4992/pacjpa.71.0_3AM119",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅱ部 各論 6 遠隔・オンライン教育を含むICTを活用した学びの在り方について」に示された対面指導と遠隔・オンライン教育の組合せに関する記述である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "学校の授業時間内に，対面指導と遠隔授業や動画教材を組み合わせる。小学校・中学校における同時双方向型の遠隔授業について，単位数の算定や対面授業の実施などの要件を見直すことを提言している。"),
      text_choice.call("イ", "学校の授業時間内にも，発達の段階や目的に応じ，対面指導に遠隔授業や動画教材を組み合わせる。高校の同時双方向型の遠隔授業は，要件の見直しによって対面との柔軟な融合を可能とすることを提言している。", true),
      text_choice.call("ウ", "児童生徒の発達の段階を踏まえ，対面指導と遠隔・オンライン教育を組み合わせる。答申が示す授業モデルでは，同時双方向型を学校の授業時間内に，オンデマンドの動画教材を授業時間外の家庭学習に区分している。"),
      text_choice.call("エ", "学校の授業時間内に，目的に応じて遠隔授業やオンデマンドの動画教材を取り入れる。高校のオンデマンドの動画教材について，単位数の算定や対面授業の実施などの要件を見直すことを提言している。"),
    ],
    explanation_blocks: [
      text_block.call("ア：授業時間内の組合せという前半は適切です。単位数の算定や対面授業の実施などの要件の見直しは，高等学校における同時双方向型の遠隔授業を対象とする提言です。小学校・中学校に対象を移している点が誤りです。"),
      text_block.call("イ：適切です。学校の授業時間内にも，教師の対面指導に遠隔授業やオンデマンドの動画教材を目的に応じて取り入れる授業モデルを示しています。また，高等学校の同時双方向型の遠隔授業では，対面指導との柔軟な融合を可能とする要件の見直しを提言しています。"),
      text_block.call("ウ：発達の段階を踏まえるという前半は適切です。答申は，オンデマンドの動画教材も学校の授業時間内に取り入れる授業モデルを示します。同期型を授業時間内，動画を授業時間外と区分した説明が誤りです。動画教材の家庭学習での利用自体を否定する問題ではありません。"),
      text_block.call("エ：学校の授業時間内に動画教材を取り入れるという前半は適切です。要件の見直しの対象として示されるのは，同時双方向型の遠隔授業です。その提言をオンデマンドの動画教材へ移している点が誤りです。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅱ部6(2)④・⑤，本文78頁（PDF83ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=83",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第2 情報Ⅱ 1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1） {{①}}コミュニケーションの実現，{{②}}の活用について理解を深め技能を習得するとともに，{{③}}について理解を深めるようにする。\n\n（2） 様々な事象を情報とその結び付きとして捉え，問題の発見・解決に向けて情報と情報技術を適切かつ効果的，創造的に活用する力を養う。\n\n（3） 情報と情報技術を適切に活用するとともに，新たな価値の創造を目指し，情報社会に主体的に参画し，その発展に寄与する態度を養う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["多様な","コンピュータやデータ","情報社会と人との関わり"]),
      fill_in_choice.call("イ", ["効果的な","情報システムや多様なデータ","情報社会と人との関わり"]),
      fill_in_choice.call("ウ", ["効果的な","コンピュータやデータ","情報技術の発展と社会の変化"]),
      fill_in_choice.call("エ", ["多様な","情報システムや多様なデータ","情報技術の発展と社会の変化"], true),
    ],
    explanation_blocks: [
      text_block.call("「情報Ⅱ」の知識・技能の目標は「多様な」コミュニケーションの実現，「情報システムや多様なデータ」の活用，「情報技術の発展と社会の変化」の理解である。対して「情報Ⅰ」の同じ柱の目標には，効果的なコミュニケーション，コンピュータやデータ，情報社会と人との関わりという表現が用いられている。両科目の目標の組合せを区別する。"),
      text_block.call("ア：②・③が誤り。「情報Ⅰ」の表現を混ぜている。情報Ⅱでは情報システムや多様なデータと，情報技術の発展と社会の変化である。"),
      text_block.call("イ：①・③が誤り。これらは「情報Ⅰ」の表現であり，情報Ⅱでは多様なコミュニケーションと，情報技術の発展と社会の変化を示す。"),
      text_block.call("ウ：①・②が誤り。情報Ⅱでは多様なコミュニケーションと，情報システムや多様なデータを示す。③は一致する。"),
      text_block.call("エ：三つとも「情報Ⅱ」の原文に一致する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第2章第10節 第2款第2 情報Ⅱ 1 目標（1）〜（3）・192頁（PDF194頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=194\n高等学校学習指導要領（平成30年告示）・第2章第10節 第2款第1 情報Ⅰ 1 目標（1）・190頁（PDF192頁，誤答の帰属の確認） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=192",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第3 情報の表現と管理 3 内容の取扱い」に示された内容に基づく記述である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "「情報の管理」の「情報の管理とドキュメンテーション」については，情報を有効に共有し活用するために必要な情報の整理や分類の重要性及び様々なドキュメントの作成方法について扱うこと。「コンピュータによる情報の管理と活用」については，コンピュータを用いて，情報の{{①}}による整理や分類及び情報を活用するために必要な{{②}}などを扱うこと。「情報の保護とセキュリティ」については，情報の{{③}}，安全かつ有効な共有と活用について扱うこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["階層化や構造化","抽出や共有","適切な保護と管理"], true),
      fill_in_choice.call("イ", ["階層化や構造化","編集や配信","正確な更新と保存"]),
      fill_in_choice.call("ウ", ["時系列化や並列化","抽出や共有","正確な更新と保存"]),
      fill_in_choice.call("エ", ["時系列化や並列化","編集や配信","適切な保護と管理"]),
    ],
    explanation_blocks: [
      text_block.call("ア：原典に示す内容と一致する。整理・分類の階層化や構造化，活用のための抽出や共有，セキュリティのための適切な保護と管理を対応付ける。"),
      text_block.call("イ：②・③が異なる。「抽出や共有」と「適切な保護と管理」が入る。編集・配信や更新・保存という別の操作の組合せではない。"),
      text_block.call("ウ：①・③が異なる。「階層化や構造化」と「適切な保護と管理」が入る。②は一致する。"),
      text_block.call("エ：①・②が異なる。整理・分類の方法は階層化や構造化，活用のための方法は抽出や共有である。③は一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第3 情報の表現と管理 3 内容の取扱い 3（2）イ，参照先2（2）ア・イ・ウ（項番の参照を内容名に展開）（410頁／PDF412頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=412",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "text", text: "『高等学校学習指導要領（平成30年告示）解説 情報編』の「第1部 各学科に共通する教科『情報』 第2章 共通教科情報科の各科目」及び同部「第3章 各科目にわたる指導計画の作成と内容の取扱い」に示されている，情報科と数学科の学習内容の関連に関する次の①〜③の記述のうち，正しいものの個数を，下の選択肢ア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "①　「情報Ⅰ」の「情報通信ネットワークとデータの活用」については，「数学Ⅰ」の「データの分析」の内容と関連付けて扱うことが考えられるとしている。\n\n②　「情報Ⅱ」の「情報とデータサイエンス」については，確率や統計を応用する内容として，「数学A」の「場合の数と確率」との関連が深いとしている。\n\n③　「情報Ⅰ」の「コンピュータとプログラミング」におけるモデル化とシミュレーションについては，不確実な事象を扱うこととのつながりから，「数学B」の「統計的な推測」との関連が深いとしている。" },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ"),
      text_choice.call("ウ", "一つ", true),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("記述①が正しく，②・③は関連付ける数学科の科目と内容を取り違えている。したがって，正しいものは一つである。"),
      text_block.call("記述①：正しい。解説第3章の「他教科等との関連」は，情報Ⅰの情報通信ネットワークとデータの活用を，数学Ⅰのデータの分析と関連付ける例を示している。"),
      text_block.call("記述②：誤り。情報Ⅱの情報とデータサイエンスについて，関連が深いと示されているのは「数学B」の「統計的な推測」である。"),
      text_block.call("記述③：誤り。情報Ⅰのモデル化とシミュレーションについて，関連が深いと示されているのは「数学A」の「場合の数と確率」である。"),
      text_block.call("選択肢ア（三つ）：②・③の取り違えを見落としているため誤り。"),
      text_block.call("選択肢イ（二つ）：②又は③を正しいと判断しているため誤り。"),
      text_block.call("選択肢ウ（一つ）：正しい記述①を数えた正答。"),
      text_block.call("選択肢エ（なし）：記述①が正しいため誤り。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編・第1部 第3章1（4）他教科等との関連・63頁（PDF71頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=71\n高等学校学習指導要領（平成30年告示）解説 情報編・第1部 第2章第2節 情報Ⅱ 2（3）数学科との関連の説明・49頁（PDF57頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=57\n高等学校学習指導要領（平成30年告示）解説 情報編・第1部 第2章第1節 情報Ⅰ 2（3）数学科との関連の説明・32頁（PDF40頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=40",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次のプログラムを実行したとき，06行で表示される配列 out として正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("配列の添字は0から始まり，表示する配列は添字0，1，2，3，4の順に並べる。range(0, 5) は0から4までを順に取り出す。= は右辺の値を求めた後，その値を左辺へ代入することを表す。dest[i] は data の添字 i の値を書き込む先の，out の添字を表す。data と dest の要素は処理中に変更されない。行頭の字下げは処理の範囲を表す。"),
      { type: "code", code: "01 data = [5, 7, 2, 9, 4]\n02 dest = [2, 4, 1, 0, 3]\n03 out = [0, 0, 0, 0, 0]\n04 for i in range(0, 5):\n05     out[dest[i]] = data[i]\n06 print(out)" },
    ],
    choices: [
      text_choice.call("ア", "[9, 2, 5, 4, 7]", true),
      text_choice.call("イ", "[2, 4, 7, 5, 9]"),
      text_choice.call("ウ", "[5, 7, 2, 9, 4]"),
      text_choice.call("エ", "[7, 4, 5, 2, 9]"),
    ],
    explanation_blocks: [
      text_block.call("dest の値は読み取る位置ではなく，書き込む位置を指定する。各要素の対応は次のとおりである。"),
      {
        type: "table",
        headers: ["i", "data[i]", "dest[i]", "書込み"],
        rows: [["0", "5", "2", "out[2] = 5"], ["1", "7", "4", "out[4] = 7"], ["2", "2", "1", "out[1] = 2"], ["3", "9", "0", "out[0] = 9"], ["4", "4", "3", "out[3] = 4"]],
      },
      text_block.call("ア：正しい。書き込んだ値を out の添字0から順に並べると，9，2，5，4，7となる。"),
      text_block.call("イ：これは，05行を out[i] = data[dest[i]] とし，dest を読み取る位置の指定に使った場合の結果である。提示したコードとは代入先と参照先の対応が逆である。"),
      text_block.call("ウ：これは out[i] = data[i] とし，dest を使わず元の順番で書き込んだ場合の結果である。"),
      text_block.call("エ：正しい結果を逆順に表示したものであり，例えば out[4 - dest[i]] = data[i] として，書込先を反対側から数えた場合に得られる。指定は添字0から順の表示である。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習14（1）リスト（122頁／PDF28頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=28",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("データAの各値を2倍して，データBを作った。Bの平均値，分散及び標準偏差がAのそれぞれ何倍になるか，組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("ここでは，分散は各値と平均値との差の2乗を合計してデータの個数で割った値，標準偏差は分散の正の平方根とする。"),
      { type: "table", headers: ["データ", "値"], rows: [["A", "2，2，4，4"], ["B", "4，4，8，8"]] },
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: ["平均値", "分散", "標準偏差"], rows: [["1倍", "2倍", "2倍"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: ["平均値", "分散", "標準偏差"], rows: [["2倍", "4倍", "2倍"]] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "table", headers: ["平均値", "分散", "標準偏差"], rows: [["2倍", "2倍", "4倍"]] }], correct: false },
      { label: "エ", content_blocks: [{ type: "table", headers: ["平均値", "分散", "標準偏差"], rows: [["1倍", "4倍", "4倍"]] }], correct: false },
    ],
    explanation_blocks: [
      text_block.call("各値と平均値が2倍になるため，平均との差も2倍になる。その2乗を使う分散は4倍，分散の正の平方根である標準偏差は2倍になる。"),
      { type: "table", headers: ["データ", "平均値", "平均値からの差", "差の2乗の合計", "分散", "標準偏差"], rows: [["A", "3", "−1，−1，1，1", "4", "1", "1"], ["B", "6", "−2，−2，2，2", "16", "4", "2"]] },
      text_block.call("ア：平均値は3から6へ2倍になる。分散も，平均との差を2乗して求めるため，2倍ではなく4倍である。標準偏差が2倍になる点は正しい。"),
      text_block.call("イ：正しい。平均値6÷3＝2，分散4÷1＝4，標準偏差2÷1＝2となる。"),
      text_block.call("ウ：平均値が2倍になる点は正しいが，分散と標準偏差の倍率が逆になっている。"),
      text_block.call("エ：分散が4倍になる点は正しいが，平均値は変わらないのではなく2倍，標準偏差は4倍ではなく2倍となる。"),
    ],
    source_text: "総務省統計局「なるほど統計学園」データの散らばりを見る・分散と標準偏差 | https://www.stat.go.jp/naruhodo/10_tokucho/chirabari.html\n文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章・学習22（1）「量的データと質的データ」・量的データの散らばり（本文185頁／PDF33頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=33",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験30の承認済み問番号は1〜20です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "special_support_education",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
  11 => "student_guidance_career",
  12 => "special_support_education", 13 => "educational_psychology",
  14 => "educational_psychology", 15 => "education_system",
  16 => "information_education",
  17 => "information_education",
  18 => "information_education",
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
  elsif (6..11).cover?(number)
    count = [10, 11].include?(number) ? 3 : 4
    expected_labels = %w[① ② ③ ④].first(count)
    table_question = number == 11
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
    if number == 18
      unless blocks.first[:type] == "text" && quotes.size == 1 &&
          quotes.first.fetch(:text).scan(/^[①②③]　/).size == 3 &&
          quotes.first.fetch(:text).scan(/\{\{[①②③]\}\}/).empty? &&
          choices.map { |choice| choice.fetch(:content_blocks) } == %w[三つ 二つ 一つ なし].map { |text| [{ type: "text", text: text }] }
        raise "正しい記述の個数を問う問題の形式が不正です"
      end
    else
      labels = quotes.flat_map { |block| block.fetch(:text).scan(/{{([①②③])}}/).flatten }.uniq
      prompt = blocks.first
      unless quotes.size == 1 && labels == %w[① ② ③] && prompt[:type] == "fill_in_text" &&
          prompt.fetch(:text).scan(/{{([①②③])}}/).flatten.uniq == %w[① ③] &&
          choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
        raise "問#{number}の抜粋・空欄と選択肢の対応が不正です"
      end
      expected_wording = number == 17 ? "に示された内容に基づく記述である。" : "からの抜粋である。"
      unless prompt.fetch(:text).include?(expected_wording)
        raise "原文抜粋と項番を展開した記述を区別してください"
      end
    end
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 承認済みの全20問を公開する前に、投入元のデータを検査する。
  entry = { exam_number: 30, attributes: question, publication_status: "published" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(30, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験30の全20問の正答位置は各記号5件にしてください"
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

QuestionSeedSync.import(exam_number: 30, questions: questions, publication_status: "published")

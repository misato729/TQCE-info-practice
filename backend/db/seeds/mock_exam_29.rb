text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験29（承認済み問3〜11。20問完成までは下書き）
questions = [
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第17条 教育振興基本計画」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第17条　{{①}}は、教育の振興に関する施策の総合的かつ計画的な推進を図るため、教育の振興に関する施策についての基本的な方針及び講ずべき施策その他必要な事項について、基本的な計画を定め、これを{{②}}に報告するとともに、公表しなければならない。\n\n２　地方公共団体は、前項の計画を{{③}}し、その地域の実情に応じ、当該地方公共団体における教育の振興のための施策に関する基本的な計画を{{④}}。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["政府","国会","参酌","定めるよう努めなければならない"], true),
      fill_in_choice.call("イ", ["文部科学大臣","内閣","参酌","定めるよう努めなければならない"]),
      fill_in_choice.call("ウ", ["政府","国会","踏襲","定めなければならない"]),
      fill_in_choice.call("エ", ["文部科学大臣","内閣","踏襲","定めなければならない"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。政府には基本的な計画の策定・国会への報告・公表が義務付けられる。一方，地方公共団体は政府の計画を「参酌」し，地域の実情に応じた計画を定めるよう努めるものとされる。"),
      text_block.call("イ：③④は一致する。①は「政府」，②は「国会」である。文部科学大臣が定めて内閣に報告するという規定ではない。"),
      text_block.call("ウ：①②は一致する。③は「参酌」，④は「定めるよう努めなければならない」である。参酌は政府の計画を考慮に入れることであり，それをそのまま踏襲するという表現と区別する。また，地方公共団体については努力義務である。"),
      text_block.call("エ：①〜④の全てが原文と異なる。政府と地方公共団体の計画について，策定主体・報告先・計画間の関係・義務の強さを区別する。"),
    ],
    source_text: "教育基本法・第17条第1項，第2項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_3-At_17",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第37条第7項・第8項\n\n教頭は、校長（副校長を置く小学校にあつては、校長及び副校長）を助け、{{①}}、及び{{②}}児童の教育をつかさどる。\n\n８　教頭は、校長（副校長を置く小学校にあつては、校長及び副校長）に事故があるときは{{③}}、校長（副校長を置く小学校にあつては、校長及び副校長）が欠けたときは{{④}}。この場合において、教頭が二人以上あるときは、あらかじめ校長が定めた順序で、{{③}}、又は行う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["校務を整理し","必要に応じ","校長の職務を補佐し","校長の職務を代理する"]),
      fill_in_choice.call("イ", ["命を受けて校務をつかさどり","常時","校長の職務を代理し","校長の職務を行う"]),
      fill_in_choice.call("ウ", ["校務を整理し","必要に応じ","校長の職務を代理し","校長の職務を行う"], true),
      fill_in_choice.call("エ", ["命を受けて校務をつかさどり","常時","校長の職務を補佐し","校長の職務を代理する"]),
    ],
    explanation_blocks: [
      text_block.call("教頭は「校務を整理し」、必要に応じて児童の教育をつかさどる。「命を受けて校務をつかさどる」は第5項で定める副校長の職務との区別が必要である。また、校長等に事故があるときは校長の職務を代理し、欠けたときは校長の職務を行う。"),
      text_block.call("ア：③は「校長の職務を代理し」、④は「校長の職務を行う」。事故がある場合を単なる補佐とし、欠けた場合を代理としている点が原文と異なる。"),
      text_block.call("イ：①は「校務を整理し」、②は「必要に応じ」。教頭の職務を副校長の職務に置き換え、児童の教育をつかさどる条件も変更している。"),
      text_block.call("ウ：四つの語句が全て原文と一致する。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
      text_block.call("第37条第7項・第8項は第62条により高等学校にも準用される。"),
    ],
    source_text: "学校教育法第37条第5項・第7項・第8項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_37\n学校教育法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：「主幹教諭等」は、公立の小学校等の主幹教諭、指導教諭、主務教諭、教諭、養護教諭、栄養教諭、主幹保育教諭、指導保育教諭、主務保育教諭、保育教諭又は講師を指す。「大学院の課程等」は、大学（短期大学を除く。）の大学院の課程若しくは専攻科の課程又はこれらに相当する外国の大学の課程を指す。" },
      { type: "fill_in_quote", text: "第26条第2項　大学院修学休業の許可を受けようとする主幹教諭等は、取得しようとする{{①}}の種類、{{②}}及び{{③}}を明らかにして、{{④}}に対し、その許可を申請するものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["専修免許状","在学しようとする大学院の課程等","大学院修学休業をしようとする期間","本属長"]),
      fill_in_choice.call("イ", ["専修免許状","在学しようとする大学院の課程等","大学院修学休業をしようとする期間","任命権者"], true),
      fill_in_choice.call("ウ", ["一種免許状","大学院修学休業に至るまでの研修の経過","教員として在職した期間","任命権者"]),
      fill_in_choice.call("エ", ["一種免許状","大学院修学休業に至るまでの研修の経過","教員として在職した期間","本属長"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①〜③は正しいが、申請先は④「任命権者」であり「本属長」ではない。第22条第2項の、勤務場所を離れて研修を行う際の本属長の承認と区別する。"),
      text_block.call("イ：4語句が原文と一致する。取得を目指す専修免許状の種類、在学予定の課程、休業予定の期間を明らかにして、任命権者へ許可を申請する。"),
      text_block.call("ウ：④は正しいが、①は「専修免許状」、②は「在学しようとする大学院の課程等」、③は「大学院修学休業をしようとする期間」である。休業開始前の研修歴や在職期間を、この項が申請時に明らかにする事項として挙げているわけではない。"),
      text_block.call("エ：4語句が原文と異なる。取得を目指す免許状、申請で示す課程と期間、許可の申請先をいずれも取り違えている。"),
    ],
    source_text: "教育公務員特例法・第26条第2項、第26条第1項（用語の補足）、第22条第2項（比較） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_5-At_26",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特に，各教科・科目等において身に付けた{{①}}を活用したり，思考力，判断力，表現力等や{{②}}を発揮させたりして，学習の対象となる物事を捉え思考することにより，各教科・科目等の特質に応じた物事を捉える{{③}}（以下「見方・考え方」という。）が鍛えられていくことに留意し，生徒が各教科・科目等の特質に応じた見方・考え方を働かせながら，知識を相互に関連付けてより深く理解したり，{{④}}，問題を見いだして解決策を考えたり，思いや考えを基に創造したりすることに向かう過程を重視した学習の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["知識及び技能", "学習意欲，学習態度等", "方法や手順", "情報を精査して考えを形成したり"]),
      fill_in_choice.call("イ", ["知識及び技能", "学びに向かう力，人間性等", "視点や考え方", "情報を精査して考えを形成したり"], true),
      fill_in_choice.call("ウ", ["学習の方法及び技術", "学びに向かう力，人間性等", "方法や手順", "情報を整理して事実を確認したり"]),
      fill_in_choice.call("エ", ["学習の方法及び技術", "学習意欲，学習態度等", "視点や考え方", "情報を整理して事実を確認したり"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は正しいが，②③が異なる。発揮させる第三の柱は「学びに向かう力，人間性等」であり，「見方・考え方」は各教科等に固有の物事を捉える「視点や考え方」である。"),
      text_block.call("イ：全て原文と一致する。三つの柱を活用・発揮する中で見方・考え方が鍛えられる。情報については整理や事実確認にとどまる語句ではなく，精査して考えを形成する過程として示される。"),
      text_block.call("ウ：②は正しいが，①③④が異なる。活用するものは「知識及び技能」，見方・考え方の説明は「視点や考え方」，情報に関わる過程は「情報を精査して考えを形成したり」である。"),
      text_block.call("エ：③は正しいが，①②④が異なる。学習の方法・技術と，育成する知識・技能の柱を混同しない。学びに向かう力・人間性等を発揮させ，情報の精査から考えの形成へ進むことが示される。"),
    ],
    source_text: "高等学校学習指導要領 第1章 総則 第3款1（1）第2段落全文（印刷28頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）不登校生徒への配慮\n\nア 不登校生徒については，保護者や関係機関と連携を図り，心理や福祉の専門家の助言又は援助を得ながら，社会的自立を目指す観点から，{{①}}に応じた情報の提供その他の必要な支援を行うものとする。\n\nイ {{②}}を対象として，{{③}}が認める特別の教育課程を編成する場合には，生徒の実態に配慮した教育課程を編成するとともに，個別学習やグループ別学習など{{④}}の工夫改善に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校の教育目標", "相当の期間高等学校を欠席し引き続き欠席すると認められる生徒等", "文部科学大臣", "指導内容や指導体制"]),
      fill_in_choice.call("イ", ["個々の生徒の実態", "高等学校に在籍し学習面又は生活面で継続した支援を必要とする生徒等", "都道府県教育委員会", "指導方法や指導体制"]),
      fill_in_choice.call("ウ", ["学校の教育目標", "高等学校に在籍し学習面又は生活面で継続した支援を必要とする生徒等", "都道府県教育委員会", "指導内容や指導体制"]),
      fill_in_choice.call("エ", ["個々の生徒の実態", "相当の期間高等学校を欠席し引き続き欠席すると認められる生徒等", "文部科学大臣", "指導方法や指導体制"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②③は正しいが，①④が異なる。支援は「個々の生徒の実態」に応じて行い，個別学習やグループ別学習の工夫は「指導方法や指導体制」として示される。"),
      text_block.call("イ：①④は正しいが，②③が異なる。特別の教育課程の対象は相当の期間欠席し引き続き欠席すると認められる生徒等であり，認める主体は文部科学大臣である。一般の継続支援対象と，都道府県教育委員会へ置き換えない。"),
      text_block.call("ウ：全て原文と異なる。支援の基準は個々の生徒の実態，対象は継続して欠席が見込まれる生徒等，認める主体は文部科学大臣，工夫するのは指導方法や指導体制である。"),
      text_block.call("エ：全て原文と一致する。社会的自立に向けて個々の実態に応じた支援を行う。欠席状況を踏まえた特別の教育課程は文部科学大臣が認め，実態に配慮した課程と方法・体制を工夫する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第1章第5款2（3）ア・イ、印刷31頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第5章 指導計画の作成と内容の取扱い 第2節 内容の取扱いについての配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "なお，体験活動の具体例としては，例えば，職場での実習を通して実社会を垣間見ることにより勤労観・職業観を醸成する就業体験活動なども考えられる。この体験活動は，特別活動として実施する{{①}}として行うことも考えられるが，総合的な探究の時間に位置付けて実施する場合には，{{②}}に適切に位置付く学習活動でなければならない。\nこのように総合的な探究の時間において，学校行事と関連付けて体験活動を実施することもあり得る。しかし，その場合でも，必ず総合的な探究の時間の目標及び内容を踏まえたものであること，{{③}}に位置付いていることなどを満たさなければならない。その上で実際に{{④}}だけを正確に算出して，総合的な探究の時間の時数として計上することが求められる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["勤労生産・奉仕的行事", "学校行事の準備や運営", "探究の過程", "学校行事として実施した活動の時数"]),
      fill_in_choice.call("イ", ["勤労生産・奉仕的行事", "課題の解決や探究活動", "探究の過程", "総合的な探究の時間の要件を満たす活動の時数"], true),
      fill_in_choice.call("ウ", ["健康安全・体育的行事", "課題の解決や探究活動", "学校行事の計画", "学校行事として実施した活動の時数"]),
      fill_in_choice.call("エ", ["健康安全・体育的行事", "学校行事の準備や運営", "学校行事の計画", "総合的な探究の時間の要件を満たす活動の時数"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は一致するが，②は「課題の解決や探究活動」，④は「総合的な探究の時間の要件を満たす活動の時数」である。学校行事と関連付けても，学校行事として実施した時数全体をそのまま計上するのではない。"),
      text_block.call("イ：全て原文と一致する。就業体験は勤労生産・奉仕的行事としても考えられるが，総合的な探究の時間では課題の解決や探究活動に位置付けることが必要である。時数も総合的な探究の時間としての要件を満たす部分を算出する。"),
      text_block.call("ウ：②は一致するが，①は「勤労生産・奉仕的行事」，③は「探究の過程」，④は「総合的な探究の時間の要件を満たす活動の時数」である。就業体験の位置付けを健康安全・体育的行事と取り違えており，総合的な探究の時間の時数の算定条件も異なる。"),
      text_block.call("エ：④は一致するが，①②③はそれぞれ「勤労生産・奉仕的行事」「課題の解決や探究活動」「探究の過程」である。学校行事の計画や準備に位置付けたことだけで，総合的な探究の時間として成立するのではない。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編 第5章 指導計画の作成と内容の取扱い 第2節 内容の取扱いについての配慮事項（7）の説明中，就業体験活動と学校行事との関連についての連続2段落（印刷56頁） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=64",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，{{①}}，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する道徳的諸価値についての理解を基にしながら，様々な体験や思索の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，自立心や自律性を高め，{{②}}をすること，生命を尊重する心を育てること，社会連帯の自覚を高め，主体的に社会の形成に参画する意欲と態度を養うこと，義務を果たし責任を重んずる態度及び人権を尊重し差別のないよりよい社会を実現しようとする態度を養うこと，伝統と文化を尊重し，それらを育んできた{{③}}を愛するとともに，他国を尊重すること，{{④}}を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["人との関わり", "調和のとれた生活", "我が国と郷土", "文化の多様性を尊重する国際人としての態度"]),
      fill_in_choice.call("イ", ["地域との関わり", "規律ある生活", "世界の様々な国々と地域", "国際社会に生きる日本人としての自覚"]),
      fill_in_choice.call("ウ", ["人との関わり", "規律ある生活", "我が国と郷土", "国際社会に生きる日本人としての自覚"], true),
      fill_in_choice.call("エ", ["地域との関わり", "調和のとれた生活", "世界の様々な国々と地域", "文化の多様性を尊重する国際人としての態度"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②④が異なる。自立心・自律性を高めることに続く原語は「規律ある生活」である。末尾は「国際社会に生きる日本人としての自覚」を身に付けることを求めており，国際人としての態度に置き換えない。"),
      text_block.call("イ：①③が異なる。四つの関わりの一つは「人との関わり」で，地域との関わりではない。伝統と文化を育んできた対象として原文が挙げるのは「我が国と郷土」であり，世界の様々な国々と地域ではない。後続する他国の尊重と併せて押さえる。"),
      text_block.call("ウ：全て原文と一致する。道徳的諸価値の四つの関わりのうち「人との関わり」，自立心・自律性と結び付く「規律ある生活」，伝統・文化を育んだ「我が国と郷土」，「国際社会に生きる日本人としての自覚」を対応させる。"),
      text_block.call("エ：全て原文と異なる。①は「人との関わり」，②は「規律ある生活」，③は「我が国と郷土」，④は「国際社会に生きる日本人としての自覚」である。地域と人との関わり，生活の規律，文化への愛着の対象及び国際社会での自覚をそれぞれ区別する。"),
    ],
    source_text: "第1章 総則 第7款2全文（PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第2 各活動・学校行事の目標及び内容〔ホームルーム活動〕」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ウ 国際理解と国際交流の推進\n我が国と他国の{{①}}などについて理解し，よりよい交流の在り方を考えるなど，共に尊重し合い，主体的に国際社会に生きる日本人としての{{②}}を探求しようとすること。\n\nエ 青年期の悩みや課題とその解決\n{{③}}に関する正しい理解を基に，適切な行動をとり，悩みや不安に向き合い乗り越えようとすること。\n\nオ 生命の尊重と心身ともに健康で安全な生活態度や規律ある習慣の確立\n節度ある健全な生活を送るなど現在及び生涯にわたって心身の健康を保持増進することや，{{④}}から身を守り安全に行動すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["文化や生活習慣", "在り方生き方", "心や体", "事件や事故，災害等"], true),
      fill_in_choice.call("イ", ["歴史や地理", "社会的役割", "心や体", "事件や事故，災害等"]),
      fill_in_choice.call("ウ", ["文化や生活習慣", "社会的役割", "環境や制度", "疲労や疾病，感染症等"]),
      fill_in_choice.call("エ", ["歴史や地理", "在り方生き方", "環境や制度", "疲労や疾病，感染症等"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。国際理解は文化や生活習慣の理解と在り方生き方の探求，青年期の悩みは心や体の正しい理解，安全行動は事件・事故・災害等から身を守ることが示される。"),
      text_block.call("イ：③④は正しいが，①②が異なる。理解の対象は「文化や生活習慣」，探求するものは日本人としての「在り方生き方」である。国際理解の内容を歴史・地理と社会的役割に置き換えない。"),
      text_block.call("ウ：①は正しいが，②③④が異なる。②は在り方生き方，③は心や体，④は事件や事故，災害等である。社会的役割や環境・制度，疾病等が教育上不要という意味ではなく，この三項目の原語との対応が異なる。"),
      text_block.call("エ：②は正しいが，①③④が異なる。①は文化や生活習慣，③は心や体，④は事件や事故，災害等である。青年期の悩みに関する理解と，健康・安全の規定との対応を区別する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第5章第2〔ホームルーム活動〕2（2）ウ〜オ、印刷479頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=481",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "PDCAサイクルの推進に当たっては、管理職のリーダーシップと、{{①}}が不可欠です。その際の留意点は、以下のとおりです。\n\n① 生徒指導に関する明確なビジョンの提示\n校長は、組織マネジメントの観点から、学校、家庭、地域の実態に基づいて、生徒指導の目標や育成したい児童生徒像に関する明確なビジョンを学校内外で提示し、{{②}}を醸成することが大切です。\n\n② {{③}}と確実な情報共有\n実施段階では、管理職によるきめ細かい教職員の動静把握、すなわち、{{③}}を適確に行うことが求められます。そのためには、各教職員との確実な情報共有、委員会・部会・学年会等の議事内容の理解が不可欠です。" },
      { type: "text", text: "注：本文の①・②は原文の列挙番号，括弧付きの【①】〜【③】は問題の空欄を表す。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["保護者の学校理解や教職員理解", "一体感", "モニタリング"], true),
      fill_in_choice.call("イ", ["保護者の学校理解や教職員理解", "一体感", "アセスメント"]),
      fill_in_choice.call("ウ", ["児童生徒の学校理解や教職員理解", "達成感", "モニタリング"]),
      fill_in_choice.call("エ", ["児童生徒の学校理解や教職員理解", "達成感", "アセスメント"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。保護者の理解を得ること，明確なビジョンにより組織の一体感を醸成すること，実施段階で管理職が教職員の動静をモニタリングすることを示している。"),
      text_block.call("イ：③が異なる。実施段階での教職員の動静把握は『モニタリング』である。チーム支援で課題や危機の情報を収集・分析し，支援仮説や目標の決定につなげるアセスメントとは区別する。"),
      text_block.call("ウ：①②が異なる。原文は保護者による学校・教職員への理解を協力の基盤として挙げ，校長による明確なビジョンの提示を一体感の醸成へつなげている。児童生徒の理解や達成感が不要という意味ではない。"),
      text_block.call("エ：全て異なる。必要な理解の主体は保護者，ビジョン提示により醸成するものは一体感，実施段階での動静把握はモニタリングである。"),
    ],
    source_text: "『生徒指導提要』（令和4年12月）第1章1.4.2『生徒指導マネジメント』（2）導入及び①・②、印刷30頁（PDF33頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=33\n同書 第1章1.3.4注13（アセスメントの照合，印刷27頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=30",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (3..11).to_a
  raise "承認済みの問番号は3〜11です"
end

categories = {
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "student_guidance_career",
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
  entry = { exam_number: 29, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(29, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 29, questions: questions, publication_status: "draft")

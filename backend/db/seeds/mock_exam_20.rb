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

# 模擬試験20（承認済みの問1〜15・問20。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("大正新教育に関わる人物の著作と教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "木下竹次は，学習を生活と結び付け，他律的な教育から自律的な学習への転換を重視した。教師自身の成長と子どもの学習を関連付け，子どもの学習によって教師も学ぶという考え方を，著書『実際的教育学』にまとめた。"),
      text_choice.call("イ", "手塚岸衛は，自由教育を唱え，自学，自治，自育を重視した。児童が学ぶ目的を自ら定めることや，学校生活の中で自治に取り組むことを重んじ，自由を自覚と自律に結び付ける教育の考え方を，著書『学習原論』にまとめた。"),
      text_choice.call("ウ", "小原國芳は，八大教育主張の講演会で全人教育を唱え，『全人教育論』でも調和ある人格の形成を論じた。学問，道徳，芸術，宗教，身体，生活に対応する真，善，美，聖，健，富の六つの価値を，人格の中に調和的に形成することを重視した。", true),
      text_choice.call("エ", "澤柳政太郎は，教育の現実を研究する教育学の構築を目指し，教師にも教育者と研究者の役割を求めた。児童の自学自習や自治自律を学びの姿勢として重視し，教育を実証的に研究する考え方を，著書『自由教育真義』にまとめた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：著作の帰属が誤り。木下の自律的学習や「学習即生活」を論じる著作は『学習原論』。『実際的教育学』は澤柳の著作である。"),
      text_block.call("イ：著作の帰属が誤り。手塚の著作は『自由教育真義』。『学習原論』は木下の著作である。自学・自治・自育を重視したことは適切。"),
      text_block.call("ウ：適切。小原は大正10年（1921年）の八大教育主張で全人教育を提唱し，人間文化の六つの価値を調和的に形成することを重視した。"),
      text_block.call("エ：著作の帰属が誤り。澤柳は『実際的教育学』を著し，実際の教育を研究することを重視した。『自由教育真義』は手塚の著作である。"),
    ],
    source_text: "明治図書出版『学習原論』書籍案内 | https://www.meijitosho.co.jp/detail/4-18-056424-6\n千葉市『千葉市史』第2項『附属小学校の自由教育』 | https://adeac.jp/chiba-city/texthtml/d100020/mp200010-100020/ht021940\n玉川学園『全人教育』 | https://www.tamagawa.jp/introduction/history/detail_12629.html\n白石崇人『澤柳政太郎「実際的教育学」の実証主義再考』 | https://www.jstage.jst.go.jp/article/kyoiku/89/2/89_220/_article/-char/ja\n成城学園『建学の精神』 | https://www.seijogakuen.ed.jp/thought/founders-vision/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("西洋の教育思想及び教育実践について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ルソーは『エミール』で，子どもには子ども固有の感じ方や考え方があることを重視した。一人の子どもの成長を家庭教師との関係の中で描き，子どもの自然な発達を尊重する消極教育を論じた。これは，大人の価値観を早期に教え込む教育を問い直すものだった。"),
      text_choice.call("イ", "オーウェンは，紡績工場で働く人々の生活と子どもの教育の改善に取り組み，性格形成学院を設けた。人間の性格形成への環境の影響を重視し，幼児の自発的な活動を育てるため，球や立方体などの教育遊具を体系化した恩物を考案して教育に用いた。", true),
      text_choice.call("ウ", "ペスタロッチは，貧しい子どもたちの教育に尽力し，『隠者の夕暮れ』『リーンハルトとゲルトルート』などを著した。人間がもつ諸能力を調和的に発達させることを重視し，頭・心・手に関わる教育を，日常生活とも結び付けて展開しようとした。"),
      text_choice.call("エ", "モンテッソーリは，医学的な観察を教育へ生かし，子どもの発達に応じた環境と教具を整えた。子どもが自ら活動を選んで取り組むことを重視し，大人には，子どもの自発的な活動と成長を支える人的・物的な環境を用意して援助する役割があると考えた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。ルソーの『エミール』における家庭教育と，子ども期及び自然な発達を重視する考え方を説明している。"),
      text_block.call("イ：恩物を考案した人物が誤り。恩物を体系化したのはフレーベルである。オーウェンが労働者の生活改善，性格形成学院，性格形成への環境の影響を重視したことは適切。"),
      text_block.call("ウ：適切。ペスタロッチの著作，貧しい子どもたちへの教育，諸能力の調和的な発達に対応する。"),
      text_block.call("エ：適切。モンテッソーリ教育は，子どもの自由選択と自発的活動を支える環境を重視する。"),
    ],
    source_text: "長瀬啓子『保育内容五領域と育みたい資質・能力について』134頁 | https://tokaigakuin-u.repo.nii.ac.jp/record/3648/files/20181217.pdf\n筑波大学『近代教育学の源流』III『教育学と自然・人間・社会』 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html\n広島文教大学附属幼稚園『モンテッソーリ教育』 | https://www.h-bunkyo.ac.jp/kindergarten/about/montessori.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次の①～④のうち，「教育基本法」（平成18年法律第120号）の条文として正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "quote",
        text: "①　良識ある公民として必要な政治的教養は、教育上尊重されなければならない。\n\n②　すべて職員は、全体の奉仕者として公共の利益のために勤務し、且つ、職務の遂行に当つては、全力を挙げてこれに専念しなければならない。\n\n③　教育は、人格の完成を目指し、平和で民主的な国家及び社会の形成者として必要な資質を備えた心身ともに健康な国民の育成を期して行われなければならない。\n\n④　教育公務員には、研修を受ける機会が与えられなければならない。",
      },
    ],
    choices: [
      text_choice.call("ア", "二つ", true),
      text_choice.call("イ", "一つ"),
      text_choice.call("ウ", "三つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("①：教育基本法第14条第1項の政治教育に関する規定である。"),
      text_block.call("②：地方公務員法第30条の服務の根本基準であり，教育基本法の条文ではない。"),
      text_block.call("③：教育基本法第1条の教育の目的である。"),
      text_block.call("④：教育公務員特例法第22条第1項の規定であり，教育基本法の条文ではない。"),
      text_block.call("したがって，教育基本法の条文は①と③の二つ。イ・ウ・エは個数が一致しない。教育基本法第9条にも教員の研修の充実に関する規定があるが，提示された④そのものの出典は教育公務員特例法である。"),
    ],
    source_text: "教育基本法・第1条、第9条、第14条 | https://laws.e-gov.go.jp/law/418AC0000000120\n地方公務員法・第30条 | https://laws.e-gov.go.jp/law/325AC0000000261\n教育公務員特例法・第22条第1項 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "第9条\n\n次の各号のいずれかに該当する者は、{{①}}となることができない。\n\n一　{{②}}以上の刑に処せられた者\n\n二　教育職員免許法第十条第一項第二号又は第三号に該当することにより免許状がその効力を失い、当該失効の日から{{③}}を経過しない者\n\n三　教育職員免許法第十一条第一項から第三項までの規定により{{④}}の処分を受け、{{③}}を経過しない者\n\n四　日本国憲法施行の日以後において、日本国憲法又はその下に成立した政府を暴力で破壊することを主張する政党その他の団体を結成し、又はこれに加入した者",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["校長又は教員", "罰金", "五年", "免許状取上げ"]),
      fill_in_choice.call("イ", ["校長又は教諭", "拘禁刑", "三年", "懲戒免職"]),
      fill_in_choice.call("ウ", ["校長又は教諭", "罰金", "五年", "懲戒免職"]),
      fill_in_choice.call("エ", ["校長又は教員", "拘禁刑", "三年", "免許状取上げ"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：②は「拘禁刑」，③は「三年」。罰金以上の刑，五年という規定ではない。"),
      text_block.call("イ：①は「校長又は教員」，④は「免許状取上げ」。「教員」を「教諭」に限定せず，懲戒処分と免許状に関する処分を区別する。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも現行条文と一致する。第2号・第3号については，それぞれ条文に示された場合に，三年を経過しない者が対象となる。"),
    ],
    source_text: "学校教育法・第9条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第24条\n\n公立の小学校等の中堅教諭等（主務教諭（養護又は栄養の指導及び管理をつかさどる主務教諭を除く。）、主務保育教諭及び教諭等のうち、臨時的に任用された者その他の政令で定める者以外のものであつて、公立の小学校等における教育に関し相当の経験を有する者として文部科学省令で定めるものをいう。以下この項において同じ。）の{{①}}は、当該中堅教諭等に対して、個々の能力、適性等に応じて、教育活動その他の学校運営の円滑かつ効果的な実施において中核的な役割を果たすことが期待される中堅教諭等としての職務を遂行する上で必要とされる資質の向上を図るために必要な事項に関する研修（次項において「中堅教諭等資質向上研修」という。）を実施しなければならない。\n\n2　{{②}}は、中堅教諭等資質向上研修を実施するに当たり、中堅教諭等資質向上研修を受ける者の能力、適性等について{{③}}を行い、その結果に基づき、当該者ごとに中堅教諭等資質向上研修に関する{{④}}を作成しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "指導助言者", "認定", "指標"]),
      fill_in_choice.call("イ", ["研修実施者", "指導助言者", "評価", "計画書"], true),
      fill_in_choice.call("ウ", ["指導助言者", "研修実施者", "評価", "計画書"]),
      fill_in_choice.call("エ", ["指導助言者", "研修実施者", "認定", "指標"]),
    ],
    explanation_blocks: [
      text_block.call("ア：③は「評価」，④は「計画書」。受講者の能力・適性等を評価し，その結果に基づく受講者ごとの計画書を作成する。"),
      text_block.call("イ：四つとも原文と一致する。研修実施者が研修を実施し，指導助言者が受講者の評価と計画書の作成を行う。"),
      text_block.call("ウ：①と②の主体が逆になっている。"),
      text_block.call("エ：①〜④の全てが原文と異なる。受講者ごとの計画書と，教員等として向上を図るべき資質に関する指標は同じものではない。"),
    ],
    source_text: "教育公務員特例法・第24条 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特に，各教科・科目等において身に付けた知識及び技能を活用したり，思考力，判断力，表現力等や学びに向かう力，人間性等を発揮させたりして，{{①}}を捉え思考することにより，{{②}}に応じた物事を捉える視点や考え方（以下「{{③}}」という。）が鍛えられていくことに留意し，生徒が{{②}}に応じた{{③}}を働かせながら，知識を相互に関連付けてより深く理解したり，情報を精査して考えを形成したり，問題を見いだして解決策を考えたり，思いや考えを基に{{④}}したりすることに向かう過程を重視した学習の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習の対象となる物事", "各教科・科目等の特質", "見方・考え方", "創造"], true),
      fill_in_choice.call("イ", ["学習の成果や到達状況", "各教科・科目等の特質", "学習方略", "創造"]),
      fill_in_choice.call("ウ", ["学習の対象となる物事", "生徒の興味・関心", "見方・考え方", "再構成"]),
      fill_in_choice.call("エ", ["学習の成果や到達状況", "生徒の興味・関心", "学習方略", "再構成"]),
    ],
    explanation_blocks: [
      text_block.call("学習の対象となる物事を捉え思考することで，各教科・科目等の特質に応じた見方・考え方が鍛えられる。知識の関連付け，考えの形成，問題解決，創造に向かう過程を重視する。イは①・③が異なり，学習成果の把握や学習方略に置き換えている。ウは②・④が異なる。エは四つとも異なる。"),
    ],
    source_text: "『高等学校学習指導要領』第1章第3款1（1）第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（4）{{①}}を通じて，個々の生徒の特性等の的確な把握に努め，その伸長を図ること。また，生徒が適切な各教科・科目や類型を選択し学校やホームルームでの生活によりよく適応するとともに，{{②}}の生き方を考え行動する態度や能力を育成することができるようにすること。\n\n（5）生徒が，基礎的・基本的な知識及び技能の習得も含め，学習内容を確実に身に付けることができるよう，生徒や学校の実態に応じ，個別学習やグループ別学習，繰り返し学習，学習内容の習熟の程度に応じた学習，{{③}}に応じた課題学習，補充的な学習や発展的な学習などの学習活動を取り入れることや，教師間の協力による指導体制を確保することなど，指導方法や指導体制の工夫改善により，{{④}}の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校の教育活動全体", "卒業後", "生徒の進路希望等", "個に応じた指導"]),
      fill_in_choice.call("イ", ["総合的な探究の時間", "現在及び将来", "生徒の興味・関心等", "習熟度別指導"]),
      fill_in_choice.call("ウ", ["総合的な探究の時間", "卒業後", "生徒の進路希望等", "習熟度別指導"]),
      fill_in_choice.call("エ", ["学校の教育活動全体", "現在及び将来", "生徒の興味・関心等", "個に応じた指導"], true),
    ],
    explanation_blocks: [
      text_block.call("特性の把握と伸長は学校の教育活動全体を通じて行い，現在及び将来の生き方を考える態度や能力を育てる。興味・関心等に応じた課題学習などを取り入れ，個に応じた指導を充実する。アは②・③が異なる。イは①・④が異なり，活動範囲を総合的な探究の時間に狭め，個に応じた指導を習熟度別指導に置き換えている。ウは四つとも異なる。"),
    ],
    source_text: "『高等学校学習指導要領』第1章第5款1（4）・（5）第1文 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』の「第3章 総合的な探究の時間の目標 第2節 目標の趣旨」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "総合的な探究の時間で育成することを目指す資質・能力は，{{①}}を考えながら，よりよく課題を発見し解決していくための資質・能力である。こうした資質・能力を育むためには，{{①}}と{{②}}な課題を自ら発見し，よりよい解決に向けて主体的に取り組むことが重要である。他方，複雑な現代社会においては，いかなる問題についても，一人だけの力で何かを成し遂げることは困難である。これが協働的に探究を進めることが求められる理由である。例えば，他の生徒と協働的に取り組むことで，学習活動が発展したり課題への意識が高まったりする。{{③}}があることで解決への糸口もつかみやすくなる。また，他者と協働的に学習する態度を育てることが求められている。この協働は，単に協力して事に当たるという意味ではなく，それぞれのよさを生かしながら{{④}}を生み出すことを意味している。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己の在り方生き方", "相互に補完的", "共通する見方", "個人ではつくりだすことができない価値"]),
      fill_in_choice.call("イ", ["自己の在り方生き方", "一体的で不可分", "異なる見方", "個人ではつくりだすことができない価値"], true),
      fill_in_choice.call("ウ", ["自己の進路や職業", "一体的で不可分", "異なる見方", "合意した計画に沿って達成される成果"]),
      fill_in_choice.call("エ", ["自己の進路や職業", "相互に補完的", "共通する見方", "合意した計画に沿って達成される成果"]),
    ],
    explanation_blocks: [
      text_block.call("探究の課題は自己の在り方生き方と一体的で不可分であり，協働では異なる見方や互いのよさを生かして，個人ではつくりだせない価値を生む。アは②・③が異なる。ウは①・④が異なり，在り方生き方を進路や職業に狭め，協働の意義を計画に沿った成果へ置き換えている。エは四つとも異なる。"),
    ],
    source_text: "『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』第3章第2節2、学びに向かう力・人間性等の説明中「総合的な探究の時間で育成することを目指す資質・能力は」で始まる段落、本文19頁 | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=27",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育は，教育基本法及び学校教育法に定められた教育の根本精神に基づき，生徒が{{①}}に努め国家・社会の一員としての自覚に基づき行為しうる発達の段階にあることを考慮し，{{②}}を考え，主体的な判断の下に行動し，{{③}}として{{④}}ための基盤となる道徳性を養うことを目標とすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["自己探求と自己実現", "社会の形成者としての責任", "自立した人間", "社会の一員として役割を果たす"]),
      fill_in_choice.call("イ", ["自己理解と社会参加", "人間としての在り方生き方", "責任ある社会人", "他者と共によりよく生きる"]),
      fill_in_choice.call("ウ", ["自己探求と自己実現", "人間としての在り方生き方", "自立した人間", "他者と共によりよく生きる"], true),
      fill_in_choice.call("エ", ["自己理解と社会参加", "社会の形成者としての責任", "責任ある社会人", "社会の一員として役割を果たす"]),
    ],
    explanation_blocks: [
      text_block.call("自己探求と自己実現に努める発達の段階を考慮し，人間としての在り方生き方を考え，自立した人間として他者と共によりよく生きるための道徳性を養う。アは②・④が異なる。イは①・③が異なり，自己探求・自己実現と自立した人間という語句を置き換えている。エは四つとも異なる。"),
    ],
    source_text: "『高等学校学習指導要領』第1章第1款2（2）第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特別活動の各活動及び学校行事を見通して，その中で育む{{①}}の育成に向けて，生徒の主体的・対話的で深い学びの実現を図るようにすること。その際，よりよい人間関係の形成，よりよい集団生活の構築や社会への参画及び自己実現に資するよう，生徒が{{②}}としての見方・考え方を働かせ，様々な集団活動に自主的，実践的に取り組む中で，互いのよさや個性，{{③}}を認め合い，等しく{{④}}に関わり役割を担うようにすることを重視すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["資質・能力", "集団や社会の形成者", "多様な考え", "合意形成"], true),
      fill_in_choice.call("イ", ["各教科等の知識及び技能", "集団や社会の形成者", "個別の目標", "意思決定"]),
      fill_in_choice.call("ウ", ["資質・能力", "持続可能な社会の担い手", "多様な考え", "合意形成"]),
      fill_in_choice.call("エ", ["資質・能力", "集団や社会の形成者", "個別の目標", "意思決定"]),
    ],
    explanation_blocks: [
      text_block.call("資質・能力の育成を見通し，集団や社会の形成者としての見方・考え方を働かせ，多様な考えを認め合って合意形成に関わる。イは①・③・④が異なる。ウは②が異なり，特別活動固有の見方・考え方の主体を置き換えている。エは③・④が異なり，集団としての合意形成と個人の意思決定を混同している。"),
    ],
    source_text: "『高等学校学習指導要領』第5章第3の1（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=483",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。また，下の表は，同書の図13「児童虐待への対応における役割」の一部を表に整理したものである。図13に示される職名と役割の対応を踏まえ，表中の空欄 {{①}}，{{②}}，{{③}} に当てはまる職名の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "quote",
        text: "関係機関との連携を効果的なものにするためには、校内のチーム体制の充実が不可欠です。児童生徒の見守りと、状況の変化への対応、保護者への対応など学校が組織として取り組むべきことが多く、そのため図13のような、学校配置の専門職も交えた体制を確立することが有効です。\n\nまた、児童虐待の再発や虐待の影響から生じる様々な課題については、予防も含めた有効な対応をとるため、学校内及び関係機関を交えた丁寧なアセスメントにより、常に適切な支援を行うことが求められます。",
      },
      {
        type: "text",
        text: "原図中のSSWはスクールソーシャルワーカー，SCはスクールカウンセラーを指す。選択肢では職名を日本語で表している。",
      },
      {
        type: "table",
        headers: ["職名", "通常時", "通告時，通告後"],
        rows: [
          ["【①】", "校内体制整備状況への助言\n関係機関との連携体制について助言", "保護者との調整\n関係機関との連携"],
          ["【②】", "虐待に関する校内研修等の実施\n学級・ホームルーム担任等からの情報の収集・集約", "関係機関との連携（特に警察）"],
          ["【③】", "教育相談", "幼児児童生徒の心のケア\nカウンセリング"],
        ],
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["養護教諭", "生徒指導主事", "学校医"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["スクールソーシャルワーカー", "学級・ホームルーム担任", "学校医"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["養護教諭", "学級・ホームルーム担任", "スクールカウンセラー"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["スクールソーシャルワーカー", "生徒指導主事", "スクールカウンセラー"],
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "エが図13の対応と一致します。①はスクールソーシャルワーカー（SSW）、②は生徒指導主事、③はスクールカウンセラー（SC）です。",
      },
      {
        type: "text",
        text: "ア：①・③が異なります。図13で養護教諭の通常時の役割は、健康相談・健康診断・救急処置等における早期発見です。①は校内体制や関係機関との連携体制に助言するSSWに対応します。また、学校医・学校歯科医には健康診断等における早期発見・早期対応や専門的な指導助言が示され、③の教育相談・カウンセリングの欄はSCに対応します。",
      },
      {
        type: "text",
        text: "イ：②・③が異なります。学級・ホームルーム担任には、日常的な子供・保護者の観察・把握や相談窓口の案内・周知等が示されています。②の校内研修や担任等からの情報の収集・集約は生徒指導主事、③はSCに対応します。",
      },
      {
        type: "text",
        text: "ウ：①・②が異なります。①はSSW、②は生徒指導主事です。養護教諭や担任にも重要な役割がありますが、提示した図13の各欄との対応が異なります。",
      },
      {
        type: "text",
        text: "これは原図における役割の整理を問うものであり、各職種の業務が排他的に限定されるという意味ではありません。",
      },
    ],
    source_text: "『生徒指導提要』第7章7.6.1「虐待対応に関する校内体制とアセスメント」、図13「児童虐待への対応における役割」（本文183～184ページ） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=186",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      {
        type: "text",
        text: "次の①～④は，自閉症スペクトラム障害（ASD）のある生徒の理解及び指導に関する記述である。適切なものの組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\n① 興味のある一部分に注意が集中し，活動の全体像を把握しにくいことがある。手順などを視覚的に示し，順序に沿って全体を捉えられるようにすることが考えられる。\n② 経験した活動の手順を正確に記憶している場合には，その記憶の正確さを，別の場面でも状況に応じて行動できる水準として評価する。\n③ 構造化によって，課題で何を行い，どのように進めるかを理解しやすくする。予測できる手順を示すことは，見通しがもてないために生じる不安の軽減にもつながる。\n④ 話の中の特定の単語に注意が集中することは，その音を不快に感じる聴覚過敏の状態を示す。会話の全体的な意味を捉えにくい場合には，音量の調整を中心として支援を組み立てる。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "①・②",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "②・④",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "①・③",
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "③・④",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：②が誤りです。経験した手順を覚えていることと，それを別の場面の状況に結び付けて行動できることは同じではありません。場に応じた行動の仕方の指導が必要な場合があります。①は適切です。",
      },
      {
        type: "text",
        text: "イ：②・④が誤りです。②は手順の記憶と場面を越えた行動を混同しています。④の，特定の単語などに注意が集まり，他の情報に注意が向きにくい状態は刺激の過剰選択性に関わり，その音を不快に感じる聴覚過敏とは区別します。",
      },
      {
        type: "text",
        text: "ウ：適切です。①は全体像を捉えるための支援，③は構造化の目的と効果を説明しています。構造化は，課題の内容や遂行の手順を理解しやすくし，見通しを支えるために用います。",
      },
      {
        type: "text",
        text: "エ：④が誤りです。特定の語への注意集中や，全体的な文脈の処理の困難を，音の不快さとして判断することはできません。情報の整理・統合や，全体の関係を捉えるための支援も検討します。③は適切です。",
      },
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅶ「自閉症」1(2)②ウ・カ，3(3)⑤及び3(4)・本文250～251・261ページ，分割PDF8～9・19ページ | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_11.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "ヴィゴツキーの発達理論における言語の働きと，思考の発達に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "他者とのやり取りに用いられる外言が内化され，思考や行動を調整する内言へと発達する。自分に向けた独り言である自己中心的言語は，この移行を考える上で重要な働きを持つ。",
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "言語は，他者との関係で用いられる機能を，自分の思考や行動を調整する機能へと変化させていく。他者との伝達に用いる言語を内言，自分の思考に用いる言語を外言と呼ぶ。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "自己中心的言語は，独り言の形を取りながら自分の行動を調整する。発達に伴って音声として聞かれる程度が減るのは，思考を調整する機能も弱まり，この言語が消失するためである。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "内言は心の中で思考を進める言語であり，外言は他者との伝達に用いる言語である。この発達は，まず個人の内面に成立した思考の働きが，他者とのやり取りへと展開する過程として説明される。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：適切です。ヴィゴツキーは，社会的なやり取りで用いられる言語が内化され，個人の思考や行動を調整する働きになると考えました。自己中心的言語を，外言から内言への移行に関わるものとして捉えます。",
      },
      {
        type: "text",
        text: "イ：発達の方向の説明は適切ですが，外言と内言の名称が逆です。他者との伝達に用いられるのが外言，心の中で思考を進めるのが内言です。",
      },
      {
        type: "text",
        text: "ウ：自己中心的言語の機能の説明は適切です。しかし，音声として聞かれにくくなることを機能の消失とみなす部分が誤りです。ヴィゴツキーは，これを内言への移行として捉えました。",
      },
      {
        type: "text",
        text: "エ：外言と内言の定義は適切です。しかし，発達の方向が逆です。他者との社会的なやり取りにある働きが，個人の内面の働きへと内化されると考えます。",
      },
    ],
    source_text: "東京大学山内研究室『学者紹介 ヴィゴツキー』・②『心的機能の社会的起源』・精神間から精神内，外言から内言への内化；参考文献に日本語訳『思考と言語』等 | https://fukutake.iii.u-tokyo.ac.jp/ylab/2014/09/lsvygotsky.html\n人間環境大学『発達心理学』・言語の発達・幼児期Ⅰ 細目②・外言，内言，移行過程の自己中心的言語 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PSC22001&jn=2026",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "内発的動機づけ及びデシの認知的評価理論に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "内発的動機づけは，活動そのものへの興味や楽しみに基づく。活動の成績に応じた報酬を予告して取り組ませることは，行為の原因を自分の内側に位置付ける働きをもち，内発的動機づけを高める。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "外的報酬には，制御的側面と情報的側面がある。制御的側面は，自分の有能さを確認して意欲を高めることに，情報的側面は，報酬獲得を行動の目的として意識させることに関わる。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "活動の結果得られる利益や報酬を目的とする場合は，外発的動機づけに当たる。ただし，その目的を学習者自身が選び，自発的に取り組んでいる場合は，内発的動機づけとして分類する。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "外的報酬が行動を外部から制御するものとして働く場合と，有能さを知らせる情報として働く場合とを区別する。情報的側面が優位となり，自己の有能さを確認できる場合には，内発的動機づけを高め得る。",
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：内発的動機づけの定義は適切です。報酬を予告し，報酬を得るための活動として捉えさせる制御的な働きは，認知される行為の原因を外側へ移し，内発的動機づけを低下させることがあります。報酬が自律性を高めるとする後半が誤りです。",
      },
      {
        type: "text",
        text: "イ：二つの側面がある点は適切ですが，説明の対応が逆です。有能さを知らせることに関わるのは情報的側面であり，外部から行動を制御し，報酬を活動の理由として意識させることに関わるのは制御的側面です。",
      },
      {
        type: "text",
        text: "ウ：外発的動機づけの説明は適切です。自分で目的を選び自発的に行動していても，活動自体の楽しみではなく，活動によって得られる別の結果を目的とする場合は，外発的動機づけに分類され得ます。自発性と内発性を同一視してはいけません。",
      },
      {
        type: "text",
        text: "エ：適切です。認知的評価理論では，外的報酬がどのような機能をもつかによって効果を説明します。報酬があることだけから，内発的動機づけが必ず低下すると結論付けるものではありません。",
      },
    ],
    source_text: "桜井茂男『児童の内発的動機づけに及ぼす言語的報酬と物質的報酬の効果の比較―デシの認知的評価理論の検討―』・図1及び理論の説明・本文pp.71–72/PDF pp.1–2 | https://nara-edu.repo.nii.ac.jp/record/9844/files/ier26_71-78.pdf\n東京大学山内研究室『内発的動機づけと外発的動機づけ』・「外発的動機と内発的動機の違いとは？」・活動そのものの楽しみと別の目的の区別 | https://fukutake.iii.u-tokyo.ac.jp/ylab/2015/07/post-587.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「学校教育の質の向上に向けたICTの活用」に関する説明である。最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "各教科等で育成を目指す資質・能力を把握し，ICTを授業改善に生かす。ICTを「文房具」として自由な発想で使う主体は教師として位置付けられ，教師が教材を提示する方法を工夫できる環境を整えることが，学校教育の現代化として示されている。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "1人1台端末を日常的に活用し，学校外での学びにもICTを生かす。特別な支援が必要な児童生徒への対応を「高度な学びの機会の提供」とし，個々の才能を伸ばすことを「きめ細かな支援」として，ICTの活用先を整理している。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "学校教育の質を高めるため，育成を目指す資質・能力を把握し，ICTを授業改善や学校外での学びに生かす。個別最適な学びと協働的な学びの実現を支える「両輪」は，ICTの効果的活用とデジタル教科書・教材の整備とされ，両者によって学習活動・機会を充実させる。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "児童生徒がICTを「文房具」として自由な発想で使える環境を整え，授業をデザインする。特別な支援や個々の才能を伸ばす高度な学びにもICTを活用し，効果的な活用と少人数によるきめ細かな指導体制の整備を両輪として，学習活動・機会を充実させる。",
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：「文房具」として自由な発想でICTを使う主体の対応が誤り。この箇所で示されているのは児童生徒自身であり，教師には，そのための環境整備と授業のデザインが求められている。教師がICTを使って教材の提示を工夫する一般的な取組を否定するものではない。",
      },
      {
        type: "text",
        text: "イ：二つの活用先との対応が逆。答申は，特別な支援が必要な児童生徒に対する「きめ細かな支援」と，個々の才能を伸ばすための「高度な学びの機会の提供」を挙げている。これは，支援が必要な児童生徒には才能を伸ばす学びを提供しないという区分ではない。",
      },
      {
        type: "text",
        text: "ウ：前半は適切だが，「両輪」の第二の構成要素が誤り。本項が明示するのは「ICTの効果的活用」と「少人数によるきめ細かな指導体制の整備」であり，デジタル教科書・教材の整備との組合せではない。教材整備一般の必要性を否定するものではない。",
      },
      {
        type: "text",
        text: "エ：適切。ICTを児童生徒自身の自由な発想に基づく学習の道具として捉え，支援の必要性への対応と個々の才能の伸長の双方に生かす。ICTの効果的活用と少人数による指導体制を併せて進めることも，答申の内容に一致する。",
      },
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅰ部 総論5（1）「学校教育の質の向上に向けたICTの活用」・本文31ページ（PDF36ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=36",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次の二つのデータA，Bの平均値，分散及び標準偏差に関する記述として適切なものを，下のア～エの中から一つ選んで記号で答えなさい。なお，分散は，各値と平均値との差の2乗を合計し，それぞれのデータの個数で割った値とする。\n\nデータA：4，4，6，6\nデータB：2，4，5，6，8"),
    ],
    choices: [
      text_choice.call("ア", "AとBの平均値及び中央値は一致しているため，平均値からのばらつきも同程度である。"),
      text_choice.call("イ", "AとBの平均値は等しいが，Bの分散はAの4倍，標準偏差はAの2倍である。", true),
      text_choice.call("ウ", "Bの最大値と最小値の差はAの3倍であるため，Bの分散はAの3倍となる。"),
      text_choice.call("エ", "A，Bともに平均値からの偏差の合計が0であるため，いずれの分散も0となる。"),
    ],
    explanation_blocks: [
      {
        type: "code",
        title: "平均値・分散・標準偏差の計算",
        code: "平均値：Aは（4＋4＋6＋6）÷4＝5，Bは（2＋4＋5＋6＋8）÷5＝5\nAの分散：｛（－1）²＋（－1）²＋1²＋1²｝÷4＝1\nBの分散：｛（－3）²＋（－1）²＋0²＋1²＋3²｝÷5＝4\n標準偏差：Aは√1＝1，Bは√4＝2",
      },
      text_block.call("ア：誤り。平均値と中央値はいずれも5だが，分散はAが1，Bが4である。中心の位置が一致していても，ばらつきは同じとは限らない。"),
      text_block.call("イ：正しい。分散はAが1，Bが4なので4倍となる。標準偏差は分散の平方根であり，Aが1，Bが2なので2倍となる。"),
      text_block.call("ウ：誤り。最大値と最小値の差はAが6－4＝2，Bが8－2＝6なので3倍だが，その比が分散の比と一致するわけではない。実際の分散の比は4÷1＝4倍である。"),
      text_block.call("エ：誤り。分散は偏差そのものの合計ではなく，偏差の2乗の平均である。偏差の合計はどちらも0だが，2乗の合計はAが4，Bが20であり，分散は0ではない。"),
    ],
    source_text: "総務省統計局『Data StaRt』ゼミナール編（2）3-3-1 記述統計量（平均値・分散・標準偏差） | https://www.stat.go.jp/dstart/point/seminar/02/3-3-1.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..15).to_a + [20]
  raise "模擬試験20は承認済みの問1〜15・問20を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = case number
                      when 1..2 then "education_foundations"
                      when 3..5 then "education_system"
                      when 6..7 then "curriculum_organization"
                      when 8 then "integrated_inquiry"
                      when 9 then "moral_education"
                      when 10 then "special_activities"
                      when 11 then "student_guidance_career"
                      when 12 then "special_support_education"
                      when 13, 14 then "educational_psychology"
                      when 15 then "education_system"
                      when 20 then "information_specialized"
                      end
  expected_major_category = number == 20 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major_category && question.fetch(:category_code) == expected_category
    raise "模擬試験20 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験20 問#{number}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験20 問#{number}の出典リンク形式が不正です"
  end

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  if (6..10).cover?(number) && quotes.size != 1
    raise "模擬試験20 問#{number}は一つの連続した抜粋による原文穴埋めにしてください"
  end
  next if quotes.empty?

  blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
  valid_blank_labels = (3..4).cover?(blank_labels.size) && blank_labels == %w[① ② ③ ④].take(blank_labels.size)
  valid_blank_labels &&= blank_labels.size == 4 if [4, 5].include?(number)
  unless valid_blank_labels && choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first[:cells].size == blank_labels.size }
    raise "模擬試験20 問#{number}の空欄と選択肢の対応が不正です"
  end
  unless question.fetch(:content_blocks).first.fetch(:type) == "fill_in_text"
    raise "模擬試験20 問#{number}は原文穴埋めの導入文を表示してください"
  end
  if [4, 5].include?(number) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
    raise "模擬試験20 問#{number}は抜粋枠の冒頭に条番号を表示してください"
  end

  next unless (6..10).cover?(number)

  introduction = question.fetch(:content_blocks).first.fetch(:text)
  unless introduction.start_with?("次の文章は，") && introduction.include?("からの抜粋である。文章中の空欄 {{①}} ～ {{#{blank_labels.last}}}") && introduction.end_with?("に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。")
    raise "模擬試験20 問#{number}の抜粋穴埋め導入文が不正です"
  end
  expected_source = {
    6 => ["第1章 総則 第3款 教育課程の実施と学習評価", "第1章第3款"],
    7 => ["第1章 総則 第5款 生徒の発達の支援", "第1章第5款"],
    8 => ["解説 総合的な探究の時間編", "解説 総合的な探究の時間編"],
    9 => ["第1章 総則 第1款 高等学校教育の基本と教育課程の役割", "第1章第1款"],
    10 => ["第5章 特別活動", "第5章"],
  }.fetch(number)
  unless introduction.include?(expected_source.first) && question.fetch(:source_text).include?(expected_source.last)
    raise "模擬試験20 問#{number}の導入文または出典範囲が不正です"
  end
end

questions.select { |question| question.fetch(:question_number) >= 11 }.each do |question|
  number = question.fetch(:question_number)
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first.fetch(:text)
  unless blocks.any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験20 問#{number}の問題文または解説が空です"
  end
  if number == 11 && !prompt.start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
    raise "模擬試験20 問11の導入文が不正です"
  end
  if number == 15 && !prompt.include?("「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）")
    raise "模擬試験20 問15の答申名が不正です"
  end
  if number == 11 || (20 == 17 && number == 15)
    blank_labels = blocks.flat_map { |block| block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten }.uniq.sort
    unless blocks.first.fetch(:type) == "fill_in_text" && blank_labels == %w[① ② ③] &&
        question.fetch(:choices).all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
      raise "模擬試験20 問#{number}の空欄と選択肢の対応が不正です"
    end
  end
end

QuestionSeedSync.import(exam_number: 20, questions: questions, publication_status: "draft")

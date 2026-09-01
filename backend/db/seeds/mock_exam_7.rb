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

# 模擬試験7（全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("中世の足利学校に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "足利学校の創建時期には奈良時代、平安時代、鎌倉時代などの諸説があるが、歴史上の具体像が明確になるのは、室町時代に関東管領上杉憲実が書籍や学田を寄進し、僧の快元を招いて学校を再興してからである。戦国期にも学問の拠点として栄え、フランシスコ・ザビエルによって海外に紹介された。", true),
      text_choice.call("イ", "足利学校は奈良時代に地方官人を養成する国学として創設されたことが史料上確定しており、律令制の衰退後も一貫して朝廷の直轄学校として運営された。上杉憲実は学校を廃止し、その蔵書を鎌倉の寺院へ移した人物である。"),
      text_choice.call("ウ", "上杉憲実は15世紀に足利学校を再興したが、その際に江戸の林羅山を初代庠主として招き、朱子学以外の易学、兵学、本草学などを禁じた。この方針が後の寛政異学の禁へ直接引き継がれた。"),
      text_choice.call("エ", "ザビエルは足利学校を「坂東の大学」として紹介しただけでなく、自ら学校を創設して初代庠主となり、ラテン語とキリスト教神学を中心とする宣教師養成機関へ改編した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。足利学校の創建時期には諸説がありますが、上杉憲実による再興以後の歴史は比較的明確です。憲実は書籍や学田を寄進し、僧の快元を庠主として学校経営に当たらせました。イは、奈良時代の国学を起源とする説を確定した事実としている点と、上杉憲実を廃止者としている点が誤りです。ウは、江戸時代初期の林羅山を15世紀に招いたとしている時代関係が成り立たず、足利学校で易学、兵学、本草学などが学ばれたこととも反します。エは、ザビエルを創設者・庠主としている点が誤りです。ザビエルは足利学校の評判を海外へ伝えましたが、学校を宣教師養成機関へ改編したわけではありません。"),
    ],
    source_text: "足利市『史跡足利学校』 | https://www.city.ashikaga.tochigi.jp/education/000031/
文化庁日本遺産ポータル『足利学校跡』 | https://japan-heritage.bunka.go.jp/ja/culturalproperties/result/25/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("クインティリアヌス（Quintilian）の教育思想に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『弁論家の教育』では、弁論術の技法だけでなく、幼児期から完成された弁論家に至るまでの教育過程を扱った。理想の弁論家には優れた話術とともに徳性が必要であり、「善き人」であることを弁論家の重要な条件とした。"),
      text_choice.call("イ", "家庭での個人教授と学校教育を比較し、道徳上の危険が家庭にも学校にも存在し得ることを認めた上で、他者の長所や誤りから学び、仲間と競いながら公的生活に慣れることのできる学校教育を支持した。"),
      text_choice.call("ウ", "子供は理性的な説得では十分に規律を身に付けられないため、教師には日常的な鞭打ちと無制限の懲戒権を認めるべきであるとした。恐怖による服従を、将来の自由な市民と弁論家を形成する最も確実な方法と位置付けた。", true),
      text_choice.call("エ", "幼い子供の学習では、能力を超える課題を一度に課すことを避け、遊びや競争を取り入れることを認めた。文字の学習に象牙製の文字を用いるなど、子供が興味をもって扱える教材についても言及した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切でない記述です。アは適切です。クインティリアヌスは教育を弁論技法だけに限定せず、徳性を備えた理想的弁論家の形成として捉えました。イも適切です。学校の危険を無視したのではなく、家庭教育にも同様の問題があり得るとした上で、仲間の長所や誤りから学び、公的生活へ備えられる学校教育の利点を論じています。ウは誤りです。クインティリアヌスは鞭打ちを、自由人にふさわしくない屈辱的な罰であり、恐怖や羞恥によって子供の精神を損なうものとして批判しました。エは適切です。子供の受容可能な量を考慮すること、休息や教育的な遊びを認めること、文字を楽しく扱える教材を用いることなどを述べています。"),
    ],
    source_text: "クインティリアヌス著、森谷宇一ほか訳『弁論家の教育1』第1巻第1章〜第3章（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I000007736785",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第6条 学校教育」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第6条　法律に定める学校は、{{①}}を有するものであって、国、地方公共団体及び{{②}}のみが、これを設置することができる。\n2　前項の学校においては、教育の目標が達成されるよう、教育を受ける者の{{③}}に応じて、体系的な教育が{{④}}に行われなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["公共的性格", "学校法人", "年齢", "計画的"]),
      fill_in_choice.call("イ", ["公の性質", "法律に定める法人", "心身の発達", "組織的"], true),
      fill_in_choice.call("ウ", ["公の性質", "公益法人", "能力及び適性", "段階的"]),
      fill_in_choice.call("エ", ["公益性", "法律に定める法人", "個性", "継続的"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。教育基本法第6条の語句は「公の性質」「法律に定める法人」「心身の発達」「組織的」です。アの「公共的性格」「学校法人」「年齢」「計画的」はいずれも原文の表現ではありません。ウは設置主体を公益法人に限定し、教育を受ける者の能力及び適性に応じるとしている点が異なります。エは「公益性」「個性」「継続的」が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第6条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第57条　高等学校に入学することのできる者は、{{①}}若しくはこれに準ずる学校若しくは{{②}}を卒業した者若しくは中等教育学校の{{③}}を修了した者又は文部科学大臣の定めるところにより、これと{{④}}があると認められた者とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["小学校", "義務教育学校", "前期課程", "同等以上の学力"]),
      fill_in_choice.call("イ", ["中学校", "高等学校", "後期課程", "同等以上の学力"]),
      fill_in_choice.call("ウ", ["中学校", "義務教育学校", "後期課程", "同程度の学力"]),
      fill_in_choice.call("エ", ["中学校", "義務教育学校", "前期課程", "同等以上の学力"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。高等学校への入学資格として、中学校若しくはこれに準ずる学校若しくは義務教育学校の卒業、中等教育学校の前期課程の修了又はこれと同等以上の学力が認められることが定められています。アは小学校卒業としている点が誤りです。イは義務教育学校を高等学校、中等教育学校の前期課程を後期課程としている点が誤りです。ウは前期課程を後期課程とし、「同等以上」を「同程度」としている点が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第57条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第17条　教育公務員は、教育に関する{{①}}を兼ね、又は教育に関する他の事業若しくは事務に従事することが{{②}}の遂行に支障がないと{{③}}（地方教育行政の組織及び運営に関する法律第三十七条第一項に規定する県費負担教職員（以下「県費負担教職員」という。）については、市町村（特別区を含む。以下同じ。）の教育委員会）において認める場合には、{{④}}を受け、又は受けないで、その職を兼ね、又はその事業若しくは事務に従事することができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["他の職", "本務", "任命権者", "給与"], true),
      fill_in_choice.call("イ", ["他の職", "校務", "所属長", "報酬"]),
      fill_in_choice.call("ウ", ["営利企業の役員", "本務", "人事委員会", "給与"]),
      fill_in_choice.call("エ", ["他の職", "職務専念義務", "任命権者", "報酬"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。教育公務員は、教育に関する他の職の兼職等が本務の遂行に支障がないと任命権者に認められた場合、給与を受ける場合も受けない場合も兼職等ができます。イは「本務」を「校務」、「任命権者」を「所属長」、「給与」を「報酬」としている点が誤りです。ウは対象を営利企業の役員とし、認定者を人事委員会としている点が誤りです。エは判断対象を「職務専念義務の遂行」とし、「給与」を「報酬」としている点が原文と異なります。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第17条 | https://laws.e-gov.go.jp/law/324AC0000000001",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "特に，各教科・科目等において身に付けた{{①}}を活用したり，{{②}}や学びに向かう力，人間性等を発揮させたりして，学習の対象となる物事を捉え思考することにより，各教科・科目等の特質に応じた物事を捉える{{③}}（以下「見方・考え方」という。）が鍛えられていくことに留意し，生徒が各教科・科目等の特質に応じた見方・考え方を働かせながら，{{④}}，情報を精査して考えを形成したり，問題を見いだして解決策を考えたり，思いや考えを基に創造したりすることに向かう過程を重視した学習の充実を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["基礎的・基本的な知識", "問題発見・解決能力", "方法や手順", "知識を体系的に整理したり"]),
      fill_in_choice.call("イ", ["学習内容", "主体性・協働性", "観点や基準", "技能を反復して習熟したり"]),
      fill_in_choice.call("ウ", ["資質・能力", "知識及び技能", "概念や原理", "情報を収集して記録したり"]),
      fill_in_choice.call("エ", ["知識及び技能", "思考力，判断力，表現力等", "視点や考え方", "知識を相互に関連付けてより深く理解したり"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。各教科・科目等で身に付けた知識及び技能を活用し、思考力・判断力・表現力等を発揮して視点や考え方を鍛え、知識を相互に関連付けてより深く理解する過程が示されています。アは②・③・④、イは四語全て、ウは①～③の対応と④が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "education_methods",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "生徒が，{{①}}の習得も含め，学習内容を確実に身に付けることができるよう，生徒や学校の実態に応じ，個別学習やグループ別学習，繰り返し学習，{{②}}，生徒の興味・関心等に応じた課題学習，{{③}}などの学習活動を取り入れることや，教師間の協力による指導体制を確保することなど，{{④}}により，個に応じた指導の充実を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["基礎的知識と基本的技能", "学習内容の難易度に応じた学習", "個別的な学習や協働的な学習", "学習方法や評価方法の工夫改善"]),
      fill_in_choice.call("イ", ["基礎的・基本的な知識及び技能", "学習内容の習熟の程度に応じた学習", "補充的な学習や発展的な学習", "指導方法や指導体制の工夫改善"], true),
      fill_in_choice.call("ウ", ["知識及び技能", "学習進度に応じた学習", "補習的な学習や探究的な学習", "教育課程や学習評価の工夫改善"]),
      fill_in_choice.call("エ", ["基礎的・発展的な知識及び技能", "習熟度別学習", "基礎学習や応用学習", "指導計画や指導内容の工夫改善"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。基礎的・基本的な知識及び技能の習得を含め、習熟の程度に応じた学習、補充的・発展的な学習、指導方法や指導体制の工夫改善によって個に応じた指導を充実させます。アは「難易度」「評価方法」、ウは「学習進度」「補習的・探究的」、エは「基礎的・発展的」「習熟度別」などの表現が原文と異なります。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款1（5） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "年間や，{{①}}を見通して，その中で育む{{②}}の育成に向けて，生徒の主体的・対話的で深い学びの実現を図るようにすること。その際，生徒や学校，地域の実態等に応じて，生徒が{{③}}を働かせ，教科・科目等の枠を超えた横断的・総合的な学習や生徒の興味・関心等に基づく学習を行うなど{{④}}を生かした教育活動の充実を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["単元など内容や時間のまとまり", "資質・能力", "探究の見方・考え方", "創意工夫"], true),
      fill_in_choice.call("イ", ["教育課程全体", "学習内容", "各教科の見方・考え方", "カリキュラム・マネジメント"]),
      fill_in_choice.call("ウ", ["学年や学校段階", "知識及び技能", "総合的な見方・考え方", "主体性"]),
      fill_in_choice.call("エ", ["探究課題の解決過程", "思考力，判断力，表現力等", "課題発見・解決の方法", "協働性"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。年間や単元など内容や時間のまとまりを見通し、資質・能力の育成に向けて、探究の見方・考え方を働かせ、創意工夫を生かした教育活動を充実させます。イは①～④のいずれも原文の組合せではありません。ウは育成対象を知識・技能だけに限定しています。エの「探究課題の解決過程」「課題発見・解決の方法」「協働性」も原文と一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第4章第3の1（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "各学校においては，第1款の2の（2）に示す{{①}}を踏まえ，{{②}}を作成し，{{③}}の下に，道徳教育の推進を主に担当する教師（「道徳教育推進教師」という。）を中心に，{{④}}が協力して道徳教育を展開すること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間としての在り方生き方に関する教育", "道徳教育の年間指導計画", "教育委員会の方針", "道徳教育に関係する教師"]),
      fill_in_choice.call("イ", ["教育基本法第1条の目的", "教育課程の全体計画", "学校の教育目標", "公民科担当教師"]),
      fill_in_choice.call("ウ", ["道徳教育の重点", "道徳教育の指導計画", "道徳教育推進教師の方針", "ホームルーム担任"]),
      fill_in_choice.call("エ", ["道徳教育の目標", "道徳教育の全体計画", "校長の方針", "全教師"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。各学校は道徳教育の目標を踏まえて全体計画を作成し、校長の方針の下、道徳教育推進教師を中心に全教師が協力して道徳教育を展開します。アは計画名・方針の主体・協力する教師の範囲、イは四語全て、ウは「目標」「全体計画」「校長の方針」「全教師」のいずれとも一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款1前段 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第2 各活動・学校行事の目標及び内容〔ホームルーム活動〕」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "ア　学校生活と社会的・職業的自立の意義の理解\n現在及び将来の生活や学習と{{①}}とのつながりを考えたり，{{②}}の意義を意識したりしながら，学習の見通しを立て，振り返ること。\nイ　主体的な学習態度の確立と学校図書館等の活用\n自主的に学習する場としての{{③}}を活用し，自分にふさわしい{{④}}を身に付けること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["将来設計", "職業選択", "図書館や博物館", "学習計画や評価方法"]),
      fill_in_choice.call("イ", ["自己の在り方生き方", "社会参画", "教室や自習室", "知識及び技能"]),
      fill_in_choice.call("ウ", ["自己実現", "社会的・職業的自立", "学校図書館等", "学習方法や学習習慣"], true),
      fill_in_choice.call("エ", ["キャリア形成", "勤労", "学校図書館", "学習態度や読書習慣"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。現在及び将来の生活や学習と自己実現とのつながり、社会的・職業的自立の意義を考え、学校図書館等を活用しながら自分にふさわしい学習方法や学習習慣を身に付ける内容です。アは①～④のいずれも原文の表現ではありません。イは「自己実現」「社会的・職業的自立」等との対応が異なります。エは学校図書館「等」が欠け、④も原文と一致しません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第5章第2〔ホームルーム活動〕2（3）ア・イ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "法の見直し規定を踏まえ、平成29年に国の基本方針の改定が行われ、改めて学校のいじめ対応の基本的な在り方が示されました。重点事項は次のとおりです。\n\n・けんかやふざけ合いであっても、見えないところで被害が発生している場合もあることから、丁寧に調査した上でいじめに当たるか否かを判断する。\n・いじめは、{{①}}をもって安易に「解消」とすることはできない。\n・いじめが解消している状態とは、①被害者に対する心理的又は物理的な影響を与える行為が止んでいる状態が相当の期間（{{②}}が目安）継続している、②被害者が{{③}}（本人や保護者の面談等で心身の苦痛を感じていないかどうか確認する）、という二つの要件が満たされていることを指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["単に謝罪", "１か月", "通常どおり登校している"]),
      fill_in_choice.call("イ", ["対策組織への報告", "６か月", "加害者との関係が修復している"]),
      fill_in_choice.call("ウ", ["保護者間の合意", "３か月", "心身の苦痛を受けていない"]),
      fill_in_choice.call("エ", ["単に謝罪", "３か月", "心身の苦痛を受けていない"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。いじめは単に謝罪をもって解消とせず、行為が止んでいる状態がおおむね3か月継続していることと、被害者が心身の苦痛を受けていないことの両方を確認します。アは①のみ一致し、継続期間と確認内容が誤りです。イは、対策組織への報告や加害者との関係修復そのものを解消要件とする点が原文と異なります。ウは②・③が一致しますが、保護者間の合意だけで解消を判断することはできません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第4章4.1.3「国の基本方針の策定」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("注意欠陥多動性障害又は注意欠如・多動症（ADHD）のある生徒の状態の把握と支援に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "授業中に不注意や離席が一度でも見られれば、その教科を担当する教師がADHDと判断できる。家庭や他の授業における様子は、学校での支援方針を検討する際には考慮しない。"),
      text_choice.call("イ", "年齢又は発達に不釣り合いな不注意、衝動性、多動性が持続し、学業や社会生活に支障を生じているかを、家庭と学校など複数の場面から把握する必要がある。支援では、指示を分かりやすく示し、課題や環境を調整するとともに、努力や長所を具体的に認めることが重要である。", true),
      text_choice.call("ウ", "不注意や衝動的な行動は、本人の努力不足によって生じることが多い。繰り返し注意や叱責を与え、失敗に対する責任を本人に自覚させることを支援の中心とする。"),
      text_choice.call("エ", "LD又はASDの特徴が認められた場合には、ADHDが併存する可能性を除外できる。そのため、不注意や多動性についての情報を改めて収集する必要はない。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。特定の授業だけで即断せず、行動の持続性、複数場面での状態、学習・生活への影響などを把握します。教師が医学的診断を行うものでもありません。イが適切です。状態把握と支援の双方を正しく説明しています。叱責に偏らず、分かりやすい指示、視覚的な手掛かり、課題量や環境の調整、肯定的な評価などを組み合わせます。ウは適切ではありません。行動を単なる怠慢と捉えて叱責を重ねると、自信や自己評価を低下させるおそれがあります。エは適切ではありません。ADHD、LD、ASDの特徴は併存する場合があり、一つの障害の可能性だけで他を除外できません。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編「障害の状態等に応じた教育的対応」注意欠陥多動性障害 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_14.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ハヴィガーストの発達課題に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "発達課題は、人生の特定の時期に生じる課題であり、その達成は本人の幸福や後の課題の達成につながる一方、達成できない場合は本人の不幸や社会からの承認の得にくさ、後の課題の困難につながると考えられた。"),
      text_choice.call("イ", "発達課題の起源には、身体的成熟、社会や文化からの期待・圧力、個人の価値観や願望などがあり、発達課題は生物学的な成熟だけによって一律に決まるものではないとされた。"),
      text_choice.call("ウ", "発達課題は、文化、時代、社会的役割及び個人の価値観とは無関係に、人類に共通する内容と達成年齢が固定されているため、全ての者が同一の順序と時期で達成しなければならないとされた。", true),
      text_choice.call("エ", "青年期の発達課題には、自己の身体の受容、同年齢者との成熟した関係、親からの情緒的自立、職業選択への準備、社会的に責任ある行動及び行動の指針となる価値体系の形成などが含まれる。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。ハヴィガーストは、ある時期の発達課題の達成が、本人の幸福や後続する課題の達成に関係すると考えました。イは適切です。発達課題は、身体的成熟だけでなく、社会文化的要求及び個人の価値・願望からも生じます。ウが適切ではありません。発達課題には社会や文化、時代、個人の価値観などが影響し、全ての者に共通する固定的な達成年齢を示した理論ではありません。エは適切です。これらはハヴィガーストが青年期に位置付けた主要な発達課題です。"),
    ],
    source_text: "東京家政大学『中学生・高校生の自立とハヴィガーストの発達課題』 | https://www.tokyo-kasei.ac.jp/research/woman/2016_iaw.pdf\n大阪教育大学学術リポジトリ『ハヴィガーストの発達課題』 | https://osaka-kyoiku.repo.nii.ac.jp/record/2063602/files/kano_069707.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ブルーナーの学習理論及び教育課程論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教材の構造を学習者が自ら発見する発見学習を重視し、基本的な概念を発達段階に応じた表現で繰り返し学ぶ螺旋型カリキュラムを提唱した。また、知識の表象を活動的表象、映像的表象、記号的表象に整理した。", true),
      text_choice.call("イ", "学習内容よりも一般的で包括的な先行オーガナイザーを授業の冒頭で提示し、新しい内容を既有の認知構造へ取り込ませる有意味受容学習を、発見学習の中心的方法として提唱した。"),
      text_choice.call("ウ", "子どもが一定の認知発達段階へ自然に到達するまでは、その段階を超える内容を教えるべきではないとし、基本概念を一度だけ完全に学習させる直線型の教育課程を提唱した。"),
      text_choice.call("エ", "活動的表象、映像的表象、記号的表象は、年齢に応じて不可逆的に置き換わる三つの発達段階であり、記号的表象を獲得した成人は、活動や映像による表象を用いなくなるとした。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。発見学習、教材の構造、螺旋型カリキュラム、三つの表象形式はいずれもブルーナーに関係します。イは適切ではありません。先行オーガナイザーと有意味受容学習を提唱したのはオーズベルであり、ブルーナーの発見学習とは区別されます。ウは適切ではありません。ブルーナーは、教材の表現方法を適切にすれば、どの発達段階の子どもにも、その教科の基本的構造を教えられると考えました。また、基本概念を繰り返し扱う螺旋型カリキュラムを提唱しました。エは適切ではありません。三つの表象形式は、後の形式が現れると以前の形式が失われるような、相互排他的で不可逆的な段階ではありません。成人も活動や映像による表象を用います。"),
    ],
    source_text: "宮崎大学教職大学院年報『ブルーナーの表象理論』 | https://www.miyazaki-u.ac.jp/edu/graduate/kyosyokudaigakuinnenpou01.pdf\n京都大学教育学部紀要『発見学習について』 | https://repository.kulib.kyoto-u.ac.jp/dspace/bitstream/2433/282382/1/eda21_010.pdf\n熊本大学『先行オーガナイザ』 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/3Block/08/08-1_text.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された履修主義，修得主義，年齢主義及び課程主義と，学校教育における取扱いとの対応を，「指導の個別化」に生かす考え方／「学習の個性化」に生かす考え方／「協働的な学び」に生かす考え方／義務教育の進級・卒業要件の基本／高等学校で相対的に多く取り入れられている考え方，の順に並べたものである。答申の内容と一致する組合せとして最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "修得主義／修得主義と履修主義／履修主義／課程主義／修得主義と課程主義"),
      text_choice.call("イ", "修得主義／修得主義と履修主義／履修主義／年齢主義／修得主義と課程主義", true),
      text_choice.call("ウ", "履修主義／修得主義と履修主義／履修主義／年齢主義／修得主義と課程主義"),
      text_choice.call("エ", "修得主義／修得主義と履修主義／修得主義／年齢主義／履修主義と年齢主義"),
    ],
    explanation_blocks: [
      text_block.call("イが正しい組合せです。答申では，個々人の学習状況や成果を重視する修得主義を「指導の個別化」に生かします。「学習の個性化」には，修得主義と，一定期間の中で多様な成長を許容する履修主義を組み合わせます。「協働的な学び」には，一定期間をかけて集団へ教育を行う履修主義を生かします。義務教育の進級・卒業要件では年齢主義を基本としつつ，教育課程を履修したと判断する基準には履修主義と修得主義を組み合わせます。高等学校では，単位の修得認定や原級留置の運用があるため，修得主義・課程主義の要素が相対的に多く取り入れられています。アは，義務教育の進級・卒業要件の基本を課程主義としている点が誤りです。ウは，「指導の個別化」に生かす考え方を履修主義としている点が誤りです。エは，「協働的な学び」を修得主義に対応させ，高等学校で相対的に多い考え方を履修主義・年齢主義としている点が誤りです。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部 総論4（4）「履修主義・修得主義等を適切に組み合わせる」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第2 情報Ⅱ 2 内容（2）コミュニケーションとコンテンツ」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "多様なコミュニケーションの形態とメディアの特性に着目し，目的や状況に応じて{{①}}に配慮し，文字，音声，静止画，動画などを組み合わせたコンテンツを{{②}}，様々な手段で発信する活動を通して，次の事項を身に付けることができるよう指導する。\nア　次のような知識及び技能を身に付けること。\n（ア）多様なコミュニケーションの形態とメディアの特性との関係について理解すること。\n（イ）文字，音声，静止画，動画などを組み合わせたコンテンツを制作する技能を身に付けること。\n（ウ）コンテンツを様々な手段で{{③}}に社会に発信する方法を理解すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["ユーザビリティ", "個別に制作し", "効果的かつ創造的"]),
      fill_in_choice.call("イ", ["情報デザイン", "協働して制作し", "適切かつ効果的"], true),
      fill_in_choice.call("ウ", ["情報モラル", "共同で編集し", "適切かつ安全"]),
      fill_in_choice.call("エ", ["メディアリテラシー", "協働して評価し", "主体的かつ継続的"]),
    ],
    explanation_blocks: [text_block.call("イが原文と一致します。目的や状況に応じて情報デザインに配慮し，コンテンツを協働して制作し，様々な手段で適切かつ効果的に社会に発信します。アは，①のユーザビリティ，②の個別に制作し，③の効果的かつ創造的がいずれも原文と異なります。ウは，情報モラルではなく情報デザインに配慮し，「協働して制作し」「適切かつ効果的」とする点が異なります。エは，①をメディアリテラシー，②を協働して評価し，③を主体的かつ継続的とする点が原文と異なります。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第2「情報Ⅱ」2（2） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第3章 主として専門学科において開設される各教科 第7節 情報 第2款 各科目 第5 情報セキュリティ 3 内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）内容を取り扱う際には，次の事項に配慮するものとする。\nア　生徒や地域の実態，学科の特色等に応じて，適切な情報セキュリティ技術を選択し，{{①}}を効果的に取り入れるとともに，情報セキュリティ技術の{{②}}について考察するよう留意して指導すること。\nイ　情報セキュリティに関する諸問題について，{{③}}に考察する学習活動を取り入れ，情報技術者が情報セキュリティにおいて果たすべき{{④}}について理解できるよう留意して指導すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["演習", "有効性", "協働的", "権限及び義務"]),
      fill_in_choice.call("イ", ["実習", "安全性", "客観的", "使命及び倫理"]),
      fill_in_choice.call("ウ", ["実験", "必要性", "科学的", "役割及び責任"]),
      fill_in_choice.call("エ", ["実習", "必要性", "主体的", "役割及び責務"], true),
    ],
    explanation_blocks: [text_block.call("エが原文と一致します。適切な技術の実習を取り入れ，その必要性を考察します。また，諸問題を主体的に考察し，情報技術者の役割及び責務を理解します。アは演習・有効性・協働的・権限及び義務，イは安全性・客観的・使命及び倫理，ウは実験・科学的・役割及び責任が原文と異なります。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節第2款第5「情報セキュリティ」3（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文は，「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科『情報』 第1章 総説 第2節 専門教科情報科改訂の趣旨及び要点」に示された内容に基づく記述である。文中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "今回の改訂における専門教科情報科の科目構成では，「情報セキュリティ」及び「メディアとサービス」の2科目を{{①}}するとともに，「情報産業と社会」及び「情報と問題解決」を「情報産業と社会」に，「情報メディア」及び「情報デザイン」を「情報デザイン」に，「情報システム実習」及び「情報コンテンツ実習」を「情報実習」に{{②}}した。また，「アルゴリズムとプログラム」を「{{③}}」に，「表現メディアの編集と表現」を「{{④}}」へと科目の名称変更を行った。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["新設", "整理統合", "情報システムのプログラミング", "コンテンツの制作と発信"], true),
      fill_in_choice.call("イ", ["新設", "名称変更", "ネットワークシステム", "メディアとサービス"]),
      fill_in_choice.call("ウ", ["整理統合", "新設", "情報テクノロジー", "情報デザイン"]),
      fill_in_choice.call("エ", ["名称変更", "整理統合", "情報システムの設計", "コンテンツの制作"]),
    ],
    explanation_blocks: [text_block.call("アが示された内容と一致します。イは①のみ一致し，三つの科目群は名称変更ではなく整理統合されています。ウは新設と整理統合を逆にしており，③・④も名称変更後の科目名と異なります。エは②のみ一致しますが，「情報セキュリティ」と「メディアとサービス」は新設科目であり，③・④も正式な科目名ではありません。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部第1章第2節2「専門教科情報科改訂の要点」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次のプログラムA，Bは，配列を昇順に整列するプログラムである。交換を実行するたびに交換回数を1増やし，配列の要素同士の大小を判定するたびに比較回数を1増やすものとする。これらのプログラムについて述べた①～③のうち，正しいものを全て挙げているものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "code",
        title: "プログラムA",
        code: "end = n - 1\n比較回数A = 0\n交換回数A = 0\n\nend > 0 の間繰り返す:\n  swapped = false\n\n  j を 0 から end - 1 まで1ずつ増やしながら繰り返す:\n    比較回数A = 比較回数A + 1\n    もし A[j] > A[j + 1] なら:\n      A[j] と A[j + 1] を交換する\n      交換回数A = 交換回数A + 1\n      swapped = true\n\n  もし swapped = false なら:\n    繰返しを終了する\n\n  end = end - 1",
      },
      {
        type: "code",
        title: "プログラムB",
        code: "比較回数B = 0\n交換回数B = 0\n\ni を 0 から n - 2 まで1ずつ増やしながら繰り返す:\n  min = i\n\n  j を i + 1 から n - 1 まで1ずつ増やしながら繰り返す:\n    比較回数B = 比較回数B + 1\n    もし B[j] < B[min] なら:\n      min = j\n\n  もし min != i なら:\n    B[i] と B[min] を交換する\n    交換回数B = 交換回数B + 1",
      },
      text_block.call("① [1, 2, 3, 4, 5, 6]を処理すると，プログラムAの比較回数は5回，プログラムBの比較回数は15回となる。\n② [6, 5, 4, 3, 2, 1]を処理すると，プログラムA，Bの交換回数はいずれも15回となる。\n③ 要素数をnとすると，最大比較回数はいずれのプログラムもn²と同じ程度で増加する。ただし，プログラムAは既に昇順に並んでいる場合には途中で終了する。"),
    ],
    choices: [
      text_choice.call("ア", "①"),
      text_choice.call("イ", "②，③"),
      text_choice.call("ウ", "①，③", true),
      text_choice.call("エ", "①，②，③"),
    ],
    explanation_blocks: [
      text_block.call("ウが正しい組合せです。①は正しい記述です。プログラムAは最初の走査で交換が発生せず終了するため5回の比較で終わります。プログラムBは並び方にかかわらず5+4+3+2+1=15回比較します。②は誤りです。逆順の場合，プログラムAは15回交換しますが，プログラムBの交換は3回です。③は正しい記述です。最大比較回数は，どちらも(n-1)+(n-2)+…+1=n(n-1)/2と同じ程度になります。アは正しい③を含んでいません。イは誤っている②を含み，正しい①を含んでいません。ウは正しい①と③を過不足なく挙げています。エは誤っている②を含んでいます。"),
      {
        type: "code",
        title: "要素数6の場合の回数",
        code: "昇順:\n  プログラムA  比較5回・交換0回\n  プログラムB  比較15回・交換0回\n\n逆順:\n  プログラムA  比較15回・交換15回\n  プログラムB  比較15回・交換3回",
      },
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章 学習15「アルゴリズムの比較」 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf\n文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第2款第1「情報Ⅰ」2（3） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("二つの量的変数x，yについて，次の表のデータが得られた。このデータの相関係数は0である。この結果の解釈として最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      {
        type: "table",
        headers: ["x", "-3", "-2", "-1", "0", "1", "2", "3"],
        rows: [["y", "9", "4", "1", "0", "1", "4", "9"]],
      },
    ],
    choices: [
      text_choice.call("ア", "相関係数が0であるため，xとyの間には系統的な関係がなく，xを用いてyを推定するモデルを作ることはできない。"),
      text_choice.call("イ", "全ての点が一つの曲線上にあるため，関係の強さを表す相関係数は1となるはずであり，0という計算結果は誤っている。"),
      text_choice.call("ウ", "相関係数が0であることから直線的な関係は認めにくいが，散布図ではU字形の関係が確認できるため，相関係数だけでなく散布図も併せて検討する必要がある。", true),
      text_choice.call("エ", "原点の点（0，0）を除けば，xの増加に伴ってyも増加する強い正の相関が現れるため，外れ値としてこの点を除くのが適切である。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。このデータはy=x²の関係にあり，散布図はU字形になります。xが負の領域ではxの増加に伴ってyが減少し，正の領域では増加するため，直線的な関係の強さを測る相関係数は0になります。アは，相関係数0をあらゆる関係の不在と解釈している点が誤りです。イは，曲線上に点が並ぶことと，完全な正の直線関係を表す相関係数1とを混同しています。エは，（0，0）を根拠なく外れ値としており，この点を除いても左右対称なU字形の関係は保たれ，相関係数は0です。相関係数だけでは非線形の関係を捉えられないため，散布図による確認が必要です。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章 データの活用 | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf\n総務省統計局『なるほど統計学園高等部 複数の変数の関係性を見る』 | https://www.stat.go.jp/naruhodo/10_tokucho/hukusu.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験7には問1から問20を順番に登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験7 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験7 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
  end

  blank_labels = question.fetch(:content_blocks)
    .select { |block| block[:type] == "fill_in_quote" }
    .flat_map { |block| block[:text].scan(/\{\{([①②③④⑤])\}\}/).flatten }
    .uniq
  if blank_labels.any?
    valid_fill_in_choices = choices.all? do |choice|
      choice_blocks = choice.fetch(:content_blocks)
      choice_blocks.one? &&
        choice_blocks.first[:type] == "fill_in_choice" &&
        choice_blocks.first[:cells].size == blank_labels.size
    end
    unless valid_fill_in_choices
      raise "模擬試験7 問#{question.fetch(:question_number)}の空欄数と選択肢セル数が一致しません"
    end
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 7,
      question_number: attributes.fetch(:question_number),
    )

    content_changed =
      question.persisted? &&
        (
          question.content_blocks != question_attributes.fetch(:content_blocks).as_json ||
          question.explanation_blocks != question_attributes.fetch(:explanation_blocks).as_json ||
          question.source_text != question_attributes.fetch(:source_text)
        )
    question.answer_histories.destroy_all if content_changed

    question.assign_attributes(question_attributes.merge(publication_status: "published"))
    question.save!

    labels = choices.map { |choice| choice.fetch(:label) }
    question.question_choices.where.not(choice_label: labels).destroy_all
    question.question_choices.update_all(is_correct: false)

    choices.each_with_index do |choice_attributes, index|
      choice = question.question_choices.find_or_initialize_by(choice_label: choice_attributes.fetch(:label))
      choice.assign_attributes(
        content_blocks: choice_attributes.fetch(:content_blocks),
        is_correct: choice_attributes.fetch(:correct),
        display_order: index + 1,
      )
      choice.save!
    end

    unless question.question_choices.count == 4 && question.question_choices.where(is_correct: true).count == 1
      raise "模擬試験7 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

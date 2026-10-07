text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験18（承認済みの問1〜15・問20。全20問がそろうまでは非公開）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("明治期における教科書制度の変遷について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "明治19年の小学校令によって，小学校の教科書に文部大臣の検定を必要とする制度が定められた。民間で編纂された教科書が検定の対象となり，修身をはじめ各教科の教科書には，この制度の下で複数の編纂者や出版社によるものが用いられた。"),
      text_choice.call("イ", "明治23年の教育勅語の発布は，修身教科書の内容にも影響を及ぼした。この時点で小学校の教科書が国定に切り替わったわけではなく，教育勅語を受けた内容上の変化と，後の国定教科書制度への転換とは，時期を区別して捉える必要がある。"),
      text_choice.call("ウ", "教科書の採択をめぐる不正事件を背景として，明治36年に小学校令が改正され，国定教科書制度が成立した。翌年から国定教科書の使用が始まり，文部省が著作する一方，印刷・発行・供給には民間業者も関わる仕組みが採られた。"),
      text_choice.call("エ", "明治36年の国定教科書制度の成立により，修身，国語，日本歴史，地理などの教科書が文部省の著作となった。この転換は小学校に加えて中学校と高等女学校にも及び，これらの学校でも，国定教科書が従来の検定教科書に代わって使用されるようになった。", true),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。明治19年（1886年）の小学校令で検定制度が定められた。"),
      text_block.call("イ：適切。教育勅語は修身教科書の内容に影響したが，明治23年（1890年）に国定制度が成立したわけではない。"),
      text_block.call("ウ：適切。明治36年（1903年）に国定制度が成立し，明治37年（1904年）から国定教科書が使用された。民間の翻刻発行制度も採られていた。"),
      text_block.call("エ：国定制度の対象校種を広げている点が誤り。中学校，高等女学校，師範学校などでは，その後も検定制度が存続した。"),
    ],
    source_text: "文部科学省『学制百年史』五「国定教科書制度の成立」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317624.htm\n文部科学省『学制百年史』七「学科課程と教科書の制度」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317615.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ヘルバルトの教育思想について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育学を体系的な学問として構成するために，倫理学と心理学をその基礎に置いた。心理学によって，人間が目指すべき道徳的な価値と教育の目的を定め，倫理学によって，学習者の精神の働きに応じた教授の方法を明らかにしようとした。"),
      text_choice.call("イ", "教育学の基礎に倫理学と心理学を置き，教育の目的を倫理学に，目的を実現する方法を心理学に求めた。道徳的品性の形成を重視し，教授も，知識を内容や媒介として学習者の思想に働きかけ，道徳形成へ結び付くものとして捉えた。", true),
      text_choice.call("ウ", "教育学の基礎に倫理学と心理学を置き，道徳的品性の形成を教育の目的とした。教授は知識の習得を，訓育は道徳的な態度の形成を，それぞれ分担するものとし，道徳形成は，教科の教授を終えた後に行う訓育によって実現されると捉えた。"),
      text_choice.call("エ", "教育の目的と教授方法の関係を体系的に論じ，道徳的品性を形成するために多面的な興味を育てようとした。これらを述べた『ゲルトルート児童教授法』では，家庭教育における母親の教授を出発点として，教育学の体系化を進めた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：倫理学と心理学の役割が逆。教育目的を倫理学に，教育方法を心理学に求めた。"),
      text_block.call("イ：適切。道徳的品性の形成を，知識を媒介とする教授とも結び付けて考えている。"),
      text_block.call("ウ：教授を道徳形成から切り離している点が誤り。ヘルバルトは教授そのものにも道徳形成の働きを見いだした。"),
      text_block.call("エ：著作の帰属が誤り。『ゲルトルート児童教授法』はペスタロッチの著作である。ヘルバルトの代表的著作には『一般教育学』『教育学講義綱要』がある。"),
    ],
    source_text: "金築忠雄「教育学におけるさまざまな学的態度について」『島根農科大学研究報告』第6号B・35、40頁 | https://ir.lib.shimane-u.ac.jp/4282/files/1094\n筑波大学『近代教育学の源流』IV「ペスタロッチ・ヘルバルト」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，適切でないものを一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "大学は，学術の中心として高い教養と専門的能力を培い，深く真理を探究して新たな知見を創造するとともに，これらの成果を広く社会に提供することにより，社会の発展に寄与するものとされている。"),
      text_choice.call("イ", "幼児期の教育は，生涯にわたる人格形成の基礎を培う重要なものであることから，国及び地方公共団体は，幼児の健やかな成長に資する良好な環境の整備などによって，その振興に努めることとされている。"),
      text_choice.call("ウ", "国及び地方公共団体は，適切な役割分担及び相互の協力の下，義務教育の実施に責任を負う。また，授業料を徴収しないとする規定の対象は，法律に定める学校における義務教育である。", true),
      text_choice.call("エ", "国及び地方公共団体は，障害のある者がその障害の状態に応じ十分な教育を受けられるよう，教育上必要な支援を講じる義務を負う。また，能力があるにもかかわらず経済的理由で修学が困難な者に対し，奨学の措置を講じる義務を負う。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。第7条第1項の大学の教育・研究・社会貢献に関する規定に一致する。"),
      text_block.call("イ：適切。第11条は，幼児期の教育の重要性を踏まえ，国及び地方公共団体による振興の努力義務を定めている。"),
      text_block.call("ウ：後半の対象が誤り。第5条第4項は「国又は地方公共団体の設置する学校における義務教育」について，授業料を徴収しないと定める。「法律に定める学校」に置き換えると私立学校も含み，規定の対象に一致しない。"),
      text_block.call("エ：適切。障害の状態に応じた教育上必要な支援は第4条第2項，経済的理由で修学が困難な能力のある者への奨学の措置は同条第3項に定められている。"),
    ],
    source_text: "教育基本法・第4条、第5条、第6条、第7条、第11条 | https://laws.e-gov.go.jp/law/418AC0000000120",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "fill_in_quote",
        text: "第37条第4項\n校長は、{{①}}をつかさどり、{{②}}を監督する。\n\n第37条第5項\n副校長は、校長を助け、{{③}} {{①}}をつかさどる。\n\n第37条第6項\n副校長は、校長に事故があるときは{{④}}、校長が欠けたときはその職務を行う。この場合において、副校長が二人以上あるときは、あらかじめ校長が定めた順序で、{{④}}、又は行う。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["校務", "所属職員", "命を受けて", "その職務を代理し"], true),
      fill_in_choice.call("イ", ["校務", "教諭", "命を受けて", "その職務を代行し"]),
      fill_in_choice.call("ウ", ["教育課程", "所属職員", "任命権者の指示を受けて", "その職務を代理し"]),
      fill_in_choice.call("エ", ["教育課程", "教諭", "任命権者の指示を受けて", "その職務を代行し"]),
    ],
    explanation_blocks: [
      text_block.call("ア：四つとも原文と一致する。校長は校務をつかさどり，所属職員を監督する。副校長は校長を助け，命を受けて校務をつかさどる。"),
      text_block.call("イ：②は「所属職員」，④は「その職務を代理し」。監督の対象は教諭に限らない。"),
      text_block.call("ウ：①は「校務」，③は「命を受けて」。校務は教育課程に関する事項だけではない。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
      text_block.call("校長に事故がある場合の「代理」と，校長が欠けた場合に職務を「行う」ことは区別される。これらの規定は第62条によって高等学校にも準用される。"),
    ],
    source_text: "学校教育法・第37条第4項〜第6項、第62条 | https://laws.e-gov.go.jp/law/322AC0000000026",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      {
        type: "fill_in_quote",
        text: "第38条\n\n職員は、{{①}}の許可を受けなければ、商業、工業又は金融業その他{{②}}（以下この項及び次条第一項において「営利企業」という。）を営むことを目的とする会社その他の団体の役員その他人事委員会規則（人事委員会を置かない地方公共団体においては、地方公共団体の規則）で定める地位を兼ね、若しくは{{③}}、又は{{④}}を得ていかなる事業若しくは事務にも従事してはならない。ただし、非常勤職員（短時間勤務の職を占める職員及び第二十二条の二第一項第二号に掲げる職員を除く。）については、この限りでない。\n\n2　人事委員会は、人事委員会規則により前項の場合における{{①}}の許可の基準を定めることができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者", "営利を目的とする私企業", "自ら営利企業に出資し", "給与"]),
      fill_in_choice.call("イ", ["所属長", "公益を目的とする法人", "自ら営利企業を営み", "報酬"]),
      fill_in_choice.call("ウ", ["所属長", "公益を目的とする法人", "自ら営利企業に出資し", "給与"]),
      fill_in_choice.call("エ", ["任命権者", "営利を目的とする私企業", "自ら営利企業を営み", "報酬"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：③は「自ら営利企業を営み」，④は「報酬」。条文で挙げられているのは出資ではなく経営である。"),
      text_block.call("イ：①は「任命権者」，②は「営利を目的とする私企業」。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも原文と一致する。営利企業の役員等の地位を兼ねること，自ら営利企業を営むこと，報酬を得て事業・事務に従事することを規定している。"),
      text_block.call("許可基準を定めることができる主体は人事委員会だが，許可自体の主体は任命権者である。"),
    ],
    source_text: "地方公務員法・第38条 | https://laws.e-gov.go.jp/law/325AC0000000261",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）生徒のよい点や進歩の状況などを積極的に評価し，学習したことの意義や価値を実感できるようにすること。また，各教科・科目等の目標の実現に向けた学習状況を把握する観点から，単元や題材など内容や時間のまとまりを見通しながら評価の場面や方法を工夫して，学習の過程や成果を評価し，{{①}}や学習意欲の向上を図り，{{②}}の育成に生かすようにすること。\n\n（2）創意工夫の中で学習評価の{{③}}が高められるよう，組織的かつ計画的な取組を推進するとともに，{{④}}を越えて生徒の学習の成果が円滑に接続されるように工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育課程の編成", "知識及び技能", "妥当性や信頼性", "学年や学校段階"]),
      fill_in_choice.call("イ", ["指導の改善", "資質・能力", "妥当性や信頼性", "学年や学校段階"], true),
      fill_in_choice.call("ウ", ["指導の改善", "資質・能力", "客観性や公平性", "各教科・科目"]),
      fill_in_choice.call("エ", ["教育課程の編成", "知識及び技能", "客観性や公平性", "各教科・科目"]),
    ],
    explanation_blocks: [
      text_block.call("学習評価を指導の改善，学習意欲の向上，資質・能力の育成に生かす。評価の妥当性や信頼性を高め，学年や学校段階を越えた成果の接続を工夫する。アは①・②が異なる。ウは③・④が異なり，原文の評価の質と接続範囲を置き換えている。エは四つとも異なる。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款2（1）・（2） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "障害のある生徒などについては，家庭，地域及び医療や福祉，保健，労働等の業務を行う関係機関との連携を図り，{{①}}で生徒への教育的支援を行うために，個別の教育支援計画を作成し活用することに努めるとともに，{{②}}の指導に当たって，個々の生徒の実態を的確に把握し，個別の指導計画を作成し活用することに努めるものとする。特に，通級による指導を受ける生徒については，{{③}}の実態を的確に把握し，個別の教育支援計画や個別の指導計画を作成し，効果的に活用するものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["各学期の視点", "各教科・科目等", "個々の生徒の障害の状態等"]),
      fill_in_choice.call("イ", ["長期的な視点", "自立活動", "個々の生徒の学習の習熟の程度"]),
      fill_in_choice.call("ウ", ["長期的な視点", "各教科・科目等", "個々の生徒の障害の状態等"], true),
      fill_in_choice.call("エ", ["各学期の視点", "自立活動", "個々の生徒の学習の習熟の程度"]),
    ],
    explanation_blocks: [
      text_block.call("個別の教育支援計画は，関係機関と連携した長期的な視点での支援に用いる。個別の指導計画は各教科・科目等の指導に活用する。通級による指導では，個々の生徒の障害の状態等の把握を踏まえて両計画を作成する。アは①が異なる。イは②・③が異なり，指導範囲と実態把握の対象を置き換えている。エは三つとも異なる。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款2（1）ウ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（8）グループ学習や個人研究などの{{①}}，地域の人々の協力も得つつ，{{②}}指導に当たるなどの指導体制について工夫を行うこと。\n\n（9）学校図書館の活用，他の学校との連携，公民館，図書館，博物館等の{{③}}や社会教育関係団体等の各種団体との連携，地域の教材や学習環境の積極的な活用などの工夫を行うこと。\n\n（10）職業や自己の進路に関する学習を行う際には，探究に取り組むことを通して，{{④}}，将来の在り方生き方を考えるなどの学習活動が行われるようにすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["多様な学習形態", "担当する教師を中心として", "社会教育施設", "自己を理解し"]),
      fill_in_choice.call("イ", ["協働的な学習形態", "全教師が一体となって", "社会福祉施設", "進路先の特徴を理解し"]),
      fill_in_choice.call("ウ", ["多様な学習形態", "全教師が一体となって", "社会福祉施設", "進路先の特徴を理解し"]),
      fill_in_choice.call("エ", ["多様な学習形態", "全教師が一体となって", "社会教育施設", "自己を理解し"], true),
    ],
    explanation_blocks: [
      text_block.call("多様な学習形態と，全教師が一体となった指導体制を工夫する。公民館・図書館・博物館等は社会教育施設として挙げられ，進路に関する学習でも探究を通した自己理解を重視する。アは②が異なる。イは①・③・④が異なる。ウは③・④が異なり，施設の位置付けと学習で理解する対象を置き換えている。"),
    ],
    source_text: "高等学校学習指導要領・第4章第3の2（8）〜（10） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      text_block.call("参考：抜粋中で参照している目標は，人間としての在り方生き方を考え，主体的な判断の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる道徳性を養うことである。"),
      { type: "fill_in_quote", text: "各学校においては，第１款の２の（2）に示す{{①}}を踏まえ，道徳教育の全体計画を作成し，{{②}}の下に，道徳教育の推進を主に担当する教師（「道徳教育推進教師」という。）を中心に，全教師が協力して道徳教育を展開すること。なお，道徳教育の全体計画の作成に当たっては，{{③}}に応じ，{{④}}を明らかにして，各教科・科目等との関係を明らかにすること。その際，公民科の「公共」及び「倫理」並びに特別活動が，人間としての在り方生き方に関する中核的な指導の場面であることに配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["道徳教育の目標", "校長の方針", "生徒や学校の実態", "指導の方針や重点"], true),
      fill_in_choice.call("イ", ["道徳教育の目標", "教育委員会の方針", "生徒や学校の実態", "教育課程の編成方針"]),
      fill_in_choice.call("ウ", ["各学校の教育目標", "校長の方針", "家庭や地域の実態", "指導の方針や重点"]),
      fill_in_choice.call("エ", ["各学校の教育目標", "教育委員会の方針", "家庭や地域の実態", "教育課程の編成方針"]),
    ],
    explanation_blocks: [
      text_block.call("総則に示された道徳教育の目標を踏まえ，校長の方針の下で全教師が協力して展開する。全体計画では，生徒や学校の実態に応じた指導の方針や重点を明らかにする。イは②・④が異なる。ウは①・③が異なり，学校の教育目標や家庭・地域の実態に置き換えている。エは四つとも異なる。"),
    ],
    source_text: "高等学校学習指導要領・第1章第7款1 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』の「第2章 特別活動の目標 第1節 特別活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特別活動における「深い学び」の実現には，特別活動が重視している「実践」を，単に行動の場面と狭く捉えるのではなく，{{①}}から{{②}}までの一連の活動を「実践」と捉えることが大切である。特別活動において重視する「人間関係形成」，「社会参画」，「自己実現」の三つの視点のいずれについても各教科・科目等で育成する資質・能力と様々に関わっている。一連の実践過程で，各教科・科目等の特質に応じた見方・考え方を{{③}}に働かせ，各教科・科目で学んだ知識や技能などを，{{④}}の問題の解決のために活用していくことが大切である。\n\nそのためには，それぞれの学習過程において，どのような資質・能力を育むことが必要なのかを明確にした上で，意図的・計画的に指導に当たることが，「深い学び」の実現につながるのである。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["課題の設定", "振り返り", "総合的", "集団及び自己"], true),
      fill_in_choice.call("イ", ["活動計画の作成", "活動成果の発表", "総合的", "集団及び自己"]),
      fill_in_choice.call("ウ", ["課題の設定", "振り返り", "系統的", "学校及び地域"]),
      fill_in_choice.call("エ", ["活動計画の作成", "活動成果の発表", "系統的", "学校及び地域"]),
    ],
    explanation_blocks: [
      text_block.call("実践は行動する場面だけでなく，課題の設定から振り返りまでの一連の活動を指す。教科等の見方・考え方を総合的に働かせ，集団及び自己の問題解決に活用する。イは①・②が異なり，実践の範囲を狭めている。ウは③・④が異なり，原文の「総合的」「集団及び自己」を置き換えている。エは四つとも異なる。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 特別活動編・第2章第1節3、深い学びの説明末尾2段落、本文21頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=29",
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
        text: "集団指導と個別指導は、集団に支えられて個が育ち、個の成長が集団を発展させるという{{①}}により、児童生徒の力を最大限に伸ばし、児童生徒が社会で自立するために必要な力を身に付けることができるようにするという指導原理に基づいて行われます。そのためには、教職員は児童生徒を十分に理解するとともに、教職員間で指導についての{{②}}を図ることが必要です。\n\n(1) 集団指導\n集団指導では、社会の一員としての自覚と責任、他者との協調性、集団の目標達成に貢献する態度の育成を図ります。児童生徒は役割分担の過程で、各役割の重要性を学びながら、協調性を身に付けることができます。自らも{{③}}であることを自覚し、互いが支え合う社会の仕組みを理解するとともに、集団において、自分が大切な存在であることを実感します。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["相互評価", "共通理解", "集団の受益者"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["相互作用", "役割分担", "集団の受益者"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["相互作用", "共通理解", "集団の形成者"],
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["相互評価", "役割分担", "集団の形成者"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ウが原文と一致します。集団が個を支え、個の成長が集団を発展させる「相互作用」を基盤とし、教職員間の「共通理解」を図ることが必要です。児童生徒自身も「集団の形成者」として、集団や社会を支える存在であることを自覚します。",
      },
      {
        type: "text",
        text: "ア：①・③が異なります。「相互評価」は互いに評価することであり、この指導原理に示される「相互作用」とは異なります。③も、恩恵を受ける「受益者」ではなく、集団をつくり支える「形成者」です。",
      },
      {
        type: "text",
        text: "イ：②・③が異なります。教職員間で必要なのは、指導についての「共通理解」です。後半に役割分担の過程も述べられますが、それと教職員間の共通理解は区別します。③は「集団の形成者」に直します。",
      },
      {
        type: "text",
        text: "エ：①・②が異なります。①は「相互作用」、②は「共通理解」です。互いに評価することや担当を分けることを、この箇所の指導原理・教職員間の理解に置き換えることはできません。",
      },
    ],
    source_text: "生徒指導提要（令和4年12月）第1章 1.3.2「集団指導と個別指導」・24～25頁 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=27",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      {
        type: "text",
        text: "注意欠如・多動性障害（ADHD）のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "不注意の状態を把握する際は，課題の内容や場面を変えて集中の持続を確かめる。興味のある活動に長く集中できる場合には，活動を終えて次へ移ることにも，同程度の自己調整ができていると捉える。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "指示を聞き落とす場合には，作業の全体像が分かるように説明する。複数の手順を一度に口頭で示し，説明を最後まで保持してから着手する方法を，注意を持続するための中心的な手掛かりとする。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "必要な情報を見落とす場合には，視覚情報を併用する。関連する掲示を一つの場所へ集め，複数の情報を同時に見比べる量を増やすことで，注目すべき情報を選択する負担を軽減する。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "活動に過度に集中し，終了時刻になっても終えにくい場合には，活動の流れや時間を視覚的に示す。残り時間を確認し，活動の一覧表に優先順位を付けるなどして，行動を調整できるようにする。",
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：ある活動への集中の持続と，終了時刻に活動を切り替える力とは別です。ADHDでは，過度に集中することで活動を終えにくい状態もあり，集中できることから切替の自己調整まで判断できません。",
      },
      {
        type: "text",
        text: "イ：注意や記憶の負担を踏まえ，指示を段階に分けて順に示すこと，メモなどの視覚情報を使うことが考えられます。複数の口頭指示を一度に保持することを中心的な手掛かりとする点が適切ではありません。",
      },
      {
        type: "text",
        text: "ウ：掲示物は整理・精選して必要な情報が分かるようにします。関連情報を集めることが有用な場合もありますが，同時に見比べる情報量を増やすことが，選択の負担を軽減するとはいえません。",
      },
      {
        type: "text",
        text: "エ：適切です。活動の終了や順序を，時間と結び付けて捉えるための支援です。時計・スケジュールや優先順位を活用し，本人が時間に応じて行動を選択・調整できるようにします。",
      },
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅹ「注意欠陥多動性障害」1(2)②ア・キ及び③ア(イ)a・本文312～314ページ，分割PDF7～9ページ | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_14.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "青年期の心理的離乳及び親子関係の発達に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "青年期には，親の価値観を捉え直して自分の判断を求める動きが強まる。これに伴う親への反抗を第一次反抗期といい，幼児期に自分で行おうとして養育者へ反発する時期を第二次反抗期という。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "青年期には，親から自立したい気持ちと親に依存したい気持ちが併存し，葛藤が生じることがある。親への反抗や親密な友人を求める動きも，親との依存的な関係を捉え直す過程に関わる。",
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "青年期には，親から教えられた価値観を吟味し，職業や生き方について試行錯誤する。このとき，社会的責任を一定期間猶予されて役割を探索する状態を，心理的離乳と呼ぶ。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "青年期には，自立への希望と，慣れ親しんだ親との関係を保ちたい気持ちとの間に葛藤が生じる。この葛藤の中心は，親の価値観を自分の内面へ定着させ，親と同じ判断基準を確立することにある。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：第一・第二反抗期の対応が逆です。幼児期に自分で行おうとして反発する時期が第一次反抗期，思春期・青年期の親や周囲の大人への反発が第二次反抗期です。",
      },
      {
        type: "text",
        text: "イ：適切です。心理的離乳では，自立への欲求と依存への欲求が葛藤し得ます。親への反抗や友人との親密な関係を求める動きも，この過程を理解する手掛かりになります。",
      },
      {
        type: "text",
        text: "ウ：職業や生き方を試行錯誤する点は適切ですが，後半はエリクソンの心理社会的モラトリアムの説明です。社会的責任を一定期間猶予されて役割を探索することと，親から心理的に自立する過程である心理的離乳とを取り違えています。",
      },
      {
        type: "text",
        text: "エ：自立と依存が葛藤する点は適切です。しかし，その中心を親と同じ判断基準の定着とする部分が誤りです。親の価値観を捉え直し，自分自身の価値観や判断を獲得することが関わります。",
      },
    ],
    source_text: "人間環境大学『対人関係の心理学』・青年期の対人関係・第9回 細目①『親からの自立』・自立欲求と依存欲求の葛藤，反抗と友人関係 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PS40101&jn=2022\n人間環境大学『発達心理学』・幼児期Ⅱ・幼児期Ⅱ 細目①『自己概念の発達』・第一次反抗期 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PSC22001&jn=2026\n人間環境大学『教育・学校心理学』・第13回 発達（3）・細目①・第二反抗期，心理的離乳と依存／自立の葛藤 | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=PSC22101&jn=2022\n片瀬一男『モラトリアム人間の就職事情』・8頁『モラトリアムの変容言説』・エリクソンの心理社会的モラトリアムを，役割実験と職業等の成人役割を見出すための猶予期間として説明（東北学院大学教養学部論集 第156号） | https://www.tohoku-gakuin.ac.jp/research/journal/bk2010/pdf/bk2010no07_02.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      {
        type: "text",
        text: "メタ認知に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "教材に含まれる定義や法則を理解していることは，課題についてのメタ認知的知識に当たる。自分がその内容をどの程度理解できたかを点検することは，メタ認知的モニタリングに当たる。",
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "メタ認知的知識には，人間の認知特性，課題の性質，課題を解決する方略などに関する知識が含まれる。自分の得意・不得意や，課題による難しさの違いについての知識も関係する。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "学習した内容を後でどの程度思い出せそうかを判断することは，メタ認知的モニタリングに当たる。その判断を基に学習時間の配分や再学習の実施を調整することは，コントロールに当たる。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "ある方略が学習に有効だという知識をもつことと，現在の課題に応じてその方略を選択・変更することとは区別される。前者はメタ認知的知識，後者はメタ認知的活動として捉えられる。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：不適切です。教材の定義や法則に関する知識は，学習対象そのものについての認知的知識です。課題についてのメタ認知的知識は，課題の性質や難しさ，どのような認知活動が求められるかなどに関する知識です。自分の理解度を点検する後半は適切です。",
      },
      {
        type: "text",
        text: "イ：適切です。人間の認知特性・課題・方略は，メタ認知的知識の代表的な分類です。知識の内容によって，認知活動の見通しや調整が支えられます。",
      },
      {
        type: "text",
        text: "ウ：適切です。自分の記憶や理解の状態を判断することがモニタリング，判断に基づいて学習の仕方や時間を調整することがコントロールです。",
      },
      {
        type: "text",
        text: "エ：適切です。方略の有効性について知っていることと，その知識を実際の学習の調整に使うこととは，同じではありません。知識成分と活動成分を区別しています。",
      },
    ],
    source_text: "愛媛大学教職大学院・栗林音菜『中学校数学科の授業におけるメタ認知支援の検討』・II1及び図1「メタ認知の分類」・本文p.2/PDF p.2 | https://ed.ehime-u.ac.jp/kyoushoku/wp-content/uploads/2021/03/4d418672f5312107f8f9a68a78d64826.pdf\n山根嵩史『学習中のメタ認知的活動の相互関係―交差遅延モデルを用いた検討―』・抄録・抄録 | https://www.jstage.jst.go.jp/article/cogpsy/2022/0/2022_104/_article/-char/ja/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「協働的な学び」に関する記述として，適切でないものを，次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "同一学年・学級に加え，異学年や他校の子供との学び合いも含む。個別最適な学びと協働的な学びの一体的な充実は，個人で学んだ成果を集団の学びに生かす一方向の関係として位置付けられ，協働の成果を集団としての到達へ結び付ける。",
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "ICTを活用すると，自分のペースを大事にしながら共同で作成・編集する活動や，多様な意見を共有して合意形成を図る活動を発展させられる。時間的・空間的制約を緩和し，遠隔地の専門家や他の学校・地域，海外との交流にも生かす。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "異学年間の交流を，学校行事や児童会・生徒会活動等を含む学校の様々な活動で充実させることも重視する。こうした機会を通して，子供がこれまでの成長を振り返り，将来への展望を培うとともに，自己肯定感を育むことにつなげる。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "ICTによる交流の可能性を生かす一方，同じ空間で時間を共にし，互いの感性や考え方に触れて刺激し合う意義も捉える。教師と子供や子供同士の関わり，実習・実験，地域での体験や専門家との交流など，リアルな体験を通じた学びを重視する。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：不適切。協働する相手に関する前半は適切だが，一体的な充実を「一方向の関係」とする部分が誤り。答申は，個別最適な学びの成果を協働的な学びに生かし，更にその成果を個別最適な学びへ還元することを求めている。個人から集団へ成果を持ち寄ることだけで関係が完結するわけではない。",
      },
      {
        type: "text",
        text: "イ：適切。答申は，ICTを使った共同作成・編集や意見共有・合意形成に加え，時間的・空間的制約の緩和による専門家や他校・他地域・海外との交流を挙げている。",
      },
      {
        type: "text",
        text: "ウ：適切。異学年間の交流は教科の授業にとどまらず，学校行事や児童会・生徒会活動等にも位置付けられる。成長の振り返り，将来への展望，自己肯定感に関する説明も答申に対応している。",
      },
      {
        type: "text",
        text: "エ：適切。ICTによる交流の拡充と，同じ空間・時間を共有して関わることの重要性は両立する。答申は，実習・実験，体験活動，専門家との交流など，リアルな体験を通じて学ぶ重要性が，AI技術が高度に発達する時代にこそ一層高まるとしている。",
      },
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部3(1)「子供の学び」・本文18～19ページ（PDF23～24ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=23",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("ある集団について，身長X（cm）と100点満点のテストの得点Y（点）を調べたところ，二つの変量の相関係数は0.60であった。次の①～③の処理を，それぞれ元のデータに対して独立に行うとき，処理後の相関係数の組合せとして適切なものを，下のア～エの中から一つ選んで記号で答えなさい。ここで，相関係数はピアソンの積率相関係数をいう。"),
      text_block.call("① XとYの順序を入れ替え，YとXの相関係数を求める。"),
      text_block.call("② 身長の単位をcmからmに換算し，X/100とYの相関係数を求める。"),
      text_block.call("③ 得点を100−Yに置き換え，Xと100−Yの相関係数を求める。"),
    ],
    choices: [
      { label: "ア", content_blocks: [{ type: "table", headers: %w[① ② ③], rows: [["−0.60", "0.60", "0.60"]] }], correct: false },
      { label: "イ", content_blocks: [{ type: "table", headers: %w[① ② ③], rows: [["0.60", "0.60", "−0.60"]] }], correct: true },
      { label: "ウ", content_blocks: [{ type: "table", headers: %w[① ② ③], rows: [["0.60", "0.006", "0.60"]] }], correct: false },
      { label: "エ", content_blocks: [{ type: "table", headers: %w[① ② ③], rows: [["−0.60", "0.006", "−0.60"]] }], correct: false },
    ],
    explanation_blocks: [
      text_block.call("① 相関係数は二つの変量について対称であり，XとYを入れ替えても値は変わらないので，0.60である。"),
      text_block.call("② 相関係数は，共分散を二つの変量の標準偏差の積で割った値である。Xを100分の1にすると，共分散とXの標準偏差がともに100分の1になるため，比である相関係数は0.60のままである。"),
      text_block.call("③ 100−Yの平均との差は，Yの平均との差の符号を反転させたものになる。標準偏差は変わらず，共分散の符号が反転するため，相関係数は−0.60である。"),
      {
        type: "table",
        headers: ["処理", "相関係数"],
        rows: [["① 変量の順序を入れ替える", "0.60"], ["② 身長をmへ換算する", "0.60"], ["③ 得点を100−Yにする", "−0.60"]],
      },
      text_block.call("ア：②は適切だが，①で変量を入れ替えたことによる符号反転は起こらず，③では得点の向きを反転させたことによる符号反転が起こる。"),
      text_block.call("イ：①～③の全てが適切である。"),
      text_block.call("ウ：①は適切だが，②で相関係数自体を100分の1にしている点と，③で符号を反転させていない点が誤りである。"),
      text_block.call("エ：③は適切だが，①で相関係数の符号を反転させている点と，②で相関係数自体を100分の1にしている点が誤りである。"),
    ],
    source_text: "総務省統計局『なるほど統計学園』複数の変数の関係性を見る・相関係数 | https://www.stat.go.jp/naruhodo/10_tokucho/hukusu.html\n名古屋市立大学 講義資料『相関行列を計算するEXCELマクロ』相関係数の定義と対称性 | https://www.econ.nagoya-cu.ac.jp/~kamiyama/siryou/corel.html",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..15).to_a + [20]
  raise "模擬試験18は承認済みの問1〜15・問20を順番に登録してください"
end

questions.each do |question|
  number = question.fetch(:question_number)
  expected_category = case number
  when 1, 2 then "education_foundations"
  when 3, 4, 5 then "education_system"
  when 6 then "curriculum_organization"
  when 7 then "special_support_education"
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
    raise "模擬試験18 問#{number}の分類が不正です"
  end

  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験18 問#{number}の選択肢または正答数が不正です"
  end
  unless question.fetch(:content_blocks).any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験18 問#{number}の問題文または解説が空です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験18 問#{number}の出典リンク形式が不正です"
  end

  next unless [4, 5].include?(number) || (6..10).cover?(number)

  quotes = question.fetch(:content_blocks).select { |block| block[:type] == "fill_in_quote" }
  blank_labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
  expected_blank_labels = number == 7 ? %w[① ② ③] : %w[① ② ③ ④]
  prompt = question.fetch(:content_blocks).first
  unless prompt.fetch(:type) == "fill_in_text" && quotes.size == 1 && blank_labels == expected_blank_labels &&
      choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == blank_labels.size }
    raise "模擬試験18 問#{number}の空欄または選択肢の対応が不正です"
  end
  if [4, 5].include?(number) && !quotes.first.fetch(:text).match?(/\A第\d+条/)
    raise "模擬試験18 問#{number}の条番号がありません"
  end
  next unless (6..10).cover?(number)

  expected_heading = {
    6 => "第1章 総則 第3款 教育課程の実施と学習評価",
    7 => "第1章 総則 第5款 生徒の発達の支援 2 特別な配慮を必要とする生徒への指導",
    8 => "第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い",
    9 => "第1章 総則 第7款 道徳教育に関する配慮事項",
    10 => "第2章 特別活動の目標 第1節 特別活動の目標",
  }.fetch(number)
  expected_source = {
    6 => "第1章第3款",
    7 => "第1章第5款",
    8 => "第4章第3",
    9 => "第1章第7款",
    10 => "解説 特別活動編・第2章第1節",
  }.fetch(number)
  unless prompt.fetch(:text).include?("「#{expected_heading}」からの抜粋である。") &&
      prompt.fetch(:text).include?("空欄 {{①}} ～ {{#{blank_labels.last}}}") &&
      question.fetch(:source_text).include?(expected_source)
    raise "模擬試験18 問#{number}の導入文または出典範囲が不正です"
  end
end

questions.select { |question| question.fetch(:question_number) >= 11 }.each do |question|
  number = question.fetch(:question_number)
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first.fetch(:text)
  unless blocks.any? && question.fetch(:explanation_blocks).any?
    raise "模擬試験18 問#{number}の問題文または解説が空です"
  end
  if number == 11 && !prompt.start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
    raise "模擬試験18 問11の導入文が不正です"
  end
  if number == 15 && !prompt.include?("「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）")
    raise "模擬試験18 問15の答申名が不正です"
  end
  if number == 11 || (18 == 17 && number == 15)
    blank_labels = blocks.flat_map { |block| block.fetch(:text, "").scan(/\{\{([①②③])\}\}/).flatten }.uniq.sort
    unless blocks.first.fetch(:type) == "fill_in_text" && blank_labels == %w[① ② ③] &&
        question.fetch(:choices).all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
      raise "模擬試験18 問#{number}の空欄と選択肢の対応が不正です"
    end
  end
end

QuestionSeedSync.import(exam_number: 18, questions: questions, publication_status: "draft")

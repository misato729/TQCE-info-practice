text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験24（承認済みの問1〜10。全20問が揃うまで下書き）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "次の①～④は，小学校学習指導要領の改訂に関する記述である。改訂が告示された年代の古いものから順に配列したものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "①　児童の側に立った教育内容の見直しを行い，基礎的・基本的事項を確実に身に付けさせることを重視した。ゆとりある充実した学校生活を実現するため，教育内容を精選し，各教科の標準授業時数を削減した。" },
      { type: "text", text: "②　それまでの「試案」と異なり，文部省告示として教育課程の基準を示した。道徳の時間を教育課程の一領域に位置付け，国語・算数の基礎学力や科学技術教育の充実，地理・歴史教育の改善を重視した。" },
      { type: "text", text: "③　生涯学習の基盤を培う観点から，自己教育力の育成や個性を生かす教育を重視した。低学年では社会科と理科に代えて生活科を新設し，直接体験を学習活動の基本に据えて，自立への基礎を培うこととした。" },
      { type: "text", text: "④　教育内容の改善・充実を図り，基本的な知識・技能とともに判断力や創造性，健康・体力の育成を重視した。従来の四領域を，各教科，道徳，特別活動の三領域に整理し，年間授業時数を最低時数ではなく標準時数として示した。" },
    ],
    choices: [
      text_choice.call("ア", "② → ① → ④ → ③"),
      text_choice.call("イ", "④ → ② → ① → ③"),
      text_choice.call("ウ", "② → ④ → ① → ③", true),
      text_choice.call("エ", "② → ④ → ③ → ①"),
    ],
    explanation_blocks: [
      text_block.call("②は1958（昭和33）年，④は1968（昭和43）年，①は1977（昭和52）年，③は1989（平成元）年の小学校学習指導要領の改訂である。したがって，②→④→①→③となる。"),
      text_block.call("ア：1977年の「ゆとりと充実」を，1968年の改訂より前に置いている。"),
      text_block.call("イ：1968年の改訂を，1958年の告示による基準化より前に置いている。"),
      text_block.call("ウ：四つの改訂を年代順に正しく並べている。"),
      text_block.call("エ：1989年の生活科新設を，1977年の内容精選・授業時数削減より前に置いている。"),
    ],
    source_text: "文部科学省『学制百年史』「二 教育内容・方法の改善」―昭和三十三年の小学校教育課程の改訂／昭和四十三年の小学校教育課程の改訂 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317805.htm\n文部科学省『学制百二十年史』「一 教育課程の改訂」―昭和五十二年の小・中学校の教育課程の改訂／平成元年の小・中学校の教育課程の改訂 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318313.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "近代以降の教育思想及び教育実践について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "フレーベルは，『人間の教育』において子どもの内にある力を引き出すことを重視した。幼児の遊びや自己活動を教育上の重要な営みと捉え，恩物を用いた活動を通して子どもの内面が表現されるようにし，幼稚園を創設した。"),
      text_choice.call("イ", "モンテッソーリは，子どもが自ら成長しようとする力をもち，発達に適した時期と環境の下で自発的に活動すると考えた。敏感期に応じた環境を整えるとともに，教師が子どもの活動を観察し，その要求を理解して援助することを重視した。"),
      text_choice.call("ウ", "オーウェンは，人間の性格形成に環境が及ぼす影響を重視し，労働者の子どもたちの教育に取り組んだ。紡績工場の経営と関わって性格形成学院を設け，幼児期から望ましい環境を整えることによって，人間の性格を形成できると考えた。"),
      text_choice.call("エ", "ニイルは，サマーヒル・スクールで子どもの自由と自治を重視し，自律的な共同生活を目指した。生活上の規則を決める自治の会合では，子どもが討議して原案をつくり，それを教師集団が最終的に決定することで，子どもの意見を教育判断へ反映させた。", true),
    ],
    explanation_blocks: [
      text_block.call("エは，自治における決定権の説明が誤りである。サマーヒルでは，生活上の規則を決める場で教師と子どもが平等に決める権利をもち，子どもの討議を教師集団の最終決定に従わせる制度ではない。自由は，他者と暮らす生活における自治や，自分の生活を営む自律とも結び付けられる。アは，フレーベルの著作，内的な力，遊び・自己活動，恩物，幼稚園の対応として適切である。イは，モンテッソーリの子ども観，敏感期及び援助者としての教師の説明として適切である。ウは，オーウェンによる性格形成学院の開設と，幼児期の環境が性格形成に与える影響を重視した思想の説明として適切である。"),
    ],
    source_text: "八戸学院大学短期大学部『教育原理13配布資料』II「多様な教育実践」2「モンテッソーリ」 | https://jc.hachinohe-u.ac.jp/wp-content/uploads/2022/09/73e0601b3df3e2bed7e3aead156eaa01.pdf#page=18\n八戸学院大学短期大学部『教育原理13配布資料』II「多様な教育実践」7「サマーヒル」 | https://jc.hachinohe-u.ac.jp/wp-content/uploads/2022/09/73e0601b3df3e2bed7e3aead156eaa01.pdf#page=23\n畑中千光「A.S.ニイルにおける『自由教育』の理論と実践に関する研究」上越教育大学・第1節「研究の目的」及び「論文の概要」 | https://www.juen.ac.jp/lab/takada/itigo/hatanag.htm\n筑波大学『近代教育学の源流』IV「教育学と家庭・学校・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n長瀬啓子「保育内容五領域と育みたい資質・能力について―セルフ・エフィカシーとの関連性から―」『東海学院大学紀要』第12号・134頁，第2節1）「歴史による保育内容の考察」（4）オーウェン | https://tokaigakuin-u.repo.nii.ac.jp/record/3648/files/20181217.pdf#page=2",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第16条 教育行政」からの抜粋である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第16条　教育は、不当な支配に服することなく、この法律及び他の法律の定めるところにより行われるべきものであり、教育行政は、国と地方公共団体との適切な役割分担及び相互の協力の下、{{①}}に行われなければならない。\n\n2　国は、全国的な教育の機会均等と教育水準の維持向上を図るため、教育に関する施策を総合的に{{②}}しなければならない。\n\n3　地方公共団体は、その地域における教育の振興を図るため、{{③}}に応じた教育に関する施策を{{②}}しなければならない。\n\n4　国及び地方公共団体は、教育が円滑かつ継続的に実施されるよう、必要な{{④}}を講じなければならない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["公正かつ適正", "認定し、監督", "その実情", "人事上の措置"]),
      fill_in_choice.call("イ", ["円滑かつ継続的", "策定し、実施", "国の計画", "財政上の措置"]),
      fill_in_choice.call("ウ", ["円滑かつ継続的", "認定し、監督", "国の計画", "人事上の措置"]),
      fill_in_choice.call("エ", ["公正かつ適正", "策定し、実施", "その実情", "財政上の措置"], true),
    ],
    explanation_blocks: [
      text_block.call("原語は①「公正かつ適正」，②「策定し、実施」，③「その実情」，④「財政上の措置」である。国と地方公共団体がそれぞれ教育施策を策定・実施することと，両者の財政上の責任を捉える。"),
      text_block.call("ア：②は「策定し、実施」，④は「財政上の措置」。教育施策を「認定し、監督する」ではなく，「策定し、実施する」と定めている。財政措置を人事措置へ置き換えた点も原文と異なる。"),
      text_block.call("イ：①は「公正かつ適正」，③は「その実情」。第4項の「円滑かつ継続的」は教育の実施についての表現であり，第1項の教育行政の表現と区別する。"),
      text_block.call("ウ：①〜④の全てが原文と異なる。"),
      text_block.call("エ：四つとも原文と一致する。②は第2項と第3項の双方で同じ語句になる。"),
    ],
    source_text: "教育基本法・第16条第1項〜第4項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_3-At_16",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第51条\n\n高等学校における教育は、前条に規定する目的を実現するため、次に掲げる目標を達成するよう行われるものとする。\n\n一　義務教育として行われる普通教育の成果を更に発展拡充させて、{{①}}、{{②}}及び健やかな身体を養い、国家及び社会の形成者として必要な資質を養うこと。\n\n二　社会において果たさなければならない使命の自覚に基づき、{{③}}に応じて将来の進路を決定させ、一般的な教養を高め、{{④}}を習得させること。\n\n三　{{③}}の確立に努めるとともに、社会について、広く深い理解と健全な批判力を養い、社会の発展に寄与する態度を養うこと。" },
      { type: "text", text: "※前条（第50条）は，高等学校が，中学校における教育の基礎の上に，心身の発達及び進路に応じて，高度な普通教育及び専門教育を施すことを目的とすると定めている。この注は参照先の説明であり，抜粋本文には含めない。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["豊かな人間性", "創造性", "個性", "専門的な知識、技術及び技能"], true),
      fill_in_choice.call("イ", ["豊かな人間性", "創造性", "適性", "基礎的な知識及び技能"]),
      fill_in_choice.call("ウ", ["豊かな情操", "主体性", "個性", "専門的な知識、技術及び技能"]),
      fill_in_choice.call("エ", ["豊かな情操", "主体性", "適性", "基礎的な知識及び技能"]),
    ],
    explanation_blocks: [
      text_block.call("第51条第1号では，「豊かな人間性，創造性及び健やかな身体」を養うことを定めている。第2号は「個性」に応じた進路決定と「専門的な知識，技術及び技能」の習得を定め，第3号も「個性」の確立を目標としている。"),
      text_block.call("ア：4語句が原文と一致する。"),
      text_block.call("イ：③は「個性」，④は「専門的な知識、技術及び技能」。進路決定の基準を「適性」とする語句，又は習得の対象を「基礎的な知識及び技能」とする語句ではない。"),
      text_block.call("ウ：①は「豊かな人間性」，②は「創造性」。第1号の組合せを「豊かな情操，主体性」と置き換えている。"),
      text_block.call("エ：①〜④が全て原文と異なる。第1号の人間性・創造性と，第2号・第3号の個性，第2号の専門的な知識・技術・技能を区別して押さえる。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第51条（第1号〜第3号） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_51\ne-Gov法令検索『学校教育法』第50条（参照先） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_50",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "用語の補足（抜粋枠外）：本文の「指標」は、校長及び教員の職責、経験及び適性に応じて向上を図るべき校長及び教員としての資質に関する指標を指す（第22条の3第1項）。" },
      { type: "fill_in_quote", text: "第22条の3第3項　公立の小学校等の校長及び教員の任命権者は、指標を定め、又はこれを変更したときは、遅滞なく、これを{{①}}。\n\n４　{{②}}は、{{③}}に対して、当該指標の策定に関する{{④}}を行うものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["公表しなければならない", "独立行政法人教職員支援機構", "研修を受ける校長及び教員", "内容の審査及び承認"]),
      fill_in_choice.call("イ", ["公表するよう努めるものとする", "独立行政法人教職員支援機構", "指標を策定する者", "専門的な助言"], true),
      fill_in_choice.call("ウ", ["公表するよう努めるものとする", "文部科学大臣", "研修を受ける校長及び教員", "内容の審査及び承認"]),
      fill_in_choice.call("エ", ["公表しなければならない", "文部科学大臣", "指標を策定する者", "専門的な助言"]),
    ],
    explanation_blocks: [
      text_block.call("正答はイ。原語は①「公表するよう努めるものとする」、②「独立行政法人教職員支援機構」、③「指標を策定する者」、④「専門的な助言」。任命権者が定める指標の公表は努力義務であり、指標の策定者に対する専門的な助言を教職員支援機構が行う。アは①を公表義務へ強め、③を研修受講者、④を審査・承認へ取り違えている。ウは②を文部科学大臣とし、③・④も誤り。エは①・②が誤り。文部科学大臣が定める「指針」は第22条の2第3項により公表しなければならないが、任命権者が定める「指標」の公表に同じ義務表現を当てはめることはできない。"),
    ],
    source_text: "教育公務員特例法・第22条の3第1項・第3項〜第4項、第22条の2第3項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_22_3",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（4）生徒が学習の見通しを立てたり{{①}}活動を，計画的に取り入れるように工夫すること。\n\n（5）生徒が生命の有限性や{{②}}，主体的に挑戦してみることや{{③}}の重要性などを実感しながら理解することができるよう，各教科・科目等の特質に応じた{{④}}を重視し，家庭や地域社会と連携しつつ体系的・継続的に実施できるよう工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習したことを振り返ったりする", "自然の大切さ", "多様な他者と協働すること", "体験活動"], true),
      fill_in_choice.call("イ", ["学習の成果を比較したりする", "自然の仕組み", "同じ目標をもつ仲間と競い合うこと", "体験活動"]),
      fill_in_choice.call("ウ", ["学習の成果を比較したりする", "自然の仕組み", "多様な他者と協働すること", "言語活動"]),
      fill_in_choice.call("エ", ["学習したことを振り返ったりする", "自然の大切さ", "同じ目標をもつ仲間と競い合うこと", "言語活動"]),
    ],
    explanation_blocks: [
      text_block.call("学習の見通しと振り返りを計画的に取り入れ，体験活動を通して生命・自然や他者との協働の大切さを実感を伴って理解する構成である。"),
      text_block.call("ア：全ての空欄が原文と一致する。"),
      text_block.call("イ：①は「学習したことを振り返ったりする」活動である。成果の比較一般とは異なる。 ②は生命の有限性と並ぶ「自然の大切さ」である。自然の仕組みを学ぶこともあり得るが，この原文の空欄には入らない。 ③は「多様な他者と協働すること」の重要性であり，仲間との競争を示す語句ではない。"),
      text_block.call("ウ：①は「学習したことを振り返ったりする」活動である。成果の比較一般とは異なる。 ②は生命の有限性と並ぶ「自然の大切さ」である。自然の仕組みを学ぶこともあり得るが，この原文の空欄には入らない。 ④は実感を伴う理解を重視した「体験活動」である。言語活動も重要だが，ここでは体験活動の規定を問う。"),
      text_block.call("エ：③は「多様な他者と協働すること」の重要性であり，仲間との競争を示す語句ではない。 ④は実感を伴う理解を重視した「体験活動」である。言語活動も重要だが，ここでは体験活動の規定を問う。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第3款 1(4)・(5) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（2）海外から帰国した生徒などの学校生活への適応や，日本語の習得に困難のある生徒に対する日本語指導\n\nア 海外から帰国した生徒などについては，学校生活への適応を図るとともに，{{①}}を生かすなどの適切な指導を行うものとする。\n\nイ 日本語の習得に困難のある生徒については，{{②}}に応じた指導内容や指導方法の工夫を組織的かつ計画的に行うものとする。\n\nウ 日本語の修得に困難のある生徒に対して，学校教育法施行規則第86条の２の規定に基づき，特別の教育課程を編成し，日本語の能力に応じた特別の指導（以下「{{③}}」という。）を行う場合には，教師間の連携に努め，指導についての{{④}}ことなどにより，効果的な指導に努めるものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["外国における生活経験", "生徒の在留資格", "通級による指導", "共通の指導計画を作成する"]),
      fill_in_choice.call("イ", ["外国における生活経験", "個々の生徒の実態", "通級による日本語指導", "計画を個別に作成する"], true),
      fill_in_choice.call("ウ", ["我が国の生活習慣", "個々の生徒の実態", "通級による指導", "共通の指導計画を作成する"]),
      fill_in_choice.call("エ", ["我が国の生活習慣", "生徒の在留資格", "通級による日本語指導", "計画を個別に作成する"]),
    ],
    explanation_blocks: [
      text_block.call("帰国生徒の外国での生活経験を生かすこと，日本語の習得に困難のある生徒の実態に応じて指導を工夫することを述べる。日本語の能力に応じる特別の指導は「通級による日本語指導」と呼び，個別の計画を作成する。"),
      text_block.call("ア：②の指導上の判断基準は「個々の生徒の実態」であり，在留資格を基準とする記述ではない。 ③は「通級による日本語指導」である。障害に応じる「通級による指導」と名称・根拠規定を区別する。 ④は指導についての「計画を個別に作成する」であり，共通の計画への置換ではない。"),
      text_block.call("イ：全ての空欄が原文と一致する。"),
      text_block.call("ウ：①は帰国生徒の「外国における生活経験」を生かす規定である。 ③は「通級による日本語指導」である。障害に応じる「通級による指導」と名称・根拠規定を区別する。 ④は指導についての「計画を個別に作成する」であり，共通の計画への置換ではない。"),
      text_block.call("エ：①は帰国生徒の「外国における生活経験」を生かす規定である。 ②の指導上の判断基準は「個々の生徒の実態」であり，在留資格を基準とする記述ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第5款 2(2)ア・イ・ウ第1段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=33",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）{{①}}における総合的な探究の時間の名称については，{{①}}において適切に定めること。\n\n（7）障害のある生徒などについては，学習活動を行う場合に生じる{{②}}に応じた指導内容や指導方法の工夫を計画的，組織的に行うこと。\n\n（8）{{③}}においては，総合的な探究の時間の学習活動として，原則として生徒が興味・関心，進路等に応じて設定した課題について知識や技能の{{④}}を図る学習活動を含むこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["各学校の設置者", "障害の種類", "普通科", "深化，総合化"]),
      fill_in_choice.call("イ", ["各学校", "困難さ", "総合学科", "深化，総合化"], true),
      fill_in_choice.call("ウ", ["各学校の設置者", "障害の種類", "総合学科", "反復，定着"]),
      fill_in_choice.call("エ", ["各学校", "困難さ", "普通科", "反復，定着"]),
    ],
    explanation_blocks: [
      text_block.call("名称は各学校で定める。障害のある生徒への工夫は障害名だけでなく，活動で生じる困難さに対応する。総合学科では生徒の興味・関心や進路等に関する課題で知識・技能の深化・総合化を図る。"),
      text_block.call("ア：①は名称を定める主体である「各学校」であり，設置者への置換ではない。 ②は学習活動で生じる「困難さ」である。障害の種類だけを基準とする表現ではない。 ③の学科は「総合学科」である。普通科一般に対する規定ではない。"),
      text_block.call("イ：全ての空欄が原文と一致する。"),
      text_block.call("ウ：①は名称を定める主体である「各学校」であり，設置者への置換ではない。 ②は学習活動で生じる「困難さ」である。障害の種類だけを基準とする表現ではない。 ④は「深化，総合化」であり，反復による定着を述べた語句ではない。"),
      text_block.call("エ：③の学科は「総合学科」である。普通科一般に対する規定ではない。 ④は「深化，総合化」であり，反復による定着を述べた語句ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第4章第3の1(6)～(8) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=478",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "学校における道徳教育は，人間としての在り方生き方に関する教育を学校の教育活動全体を通じて行うことによりその充実を図るものとし，各教科に属する科目（以下「{{①}}」という。），総合的な探究の時間及び特別活動（以下「{{②}}」という。）のそれぞれの特質に応じて，適切な指導を行うこと。\n\n道徳教育は，教育基本法及び学校教育法に定められた教育の根本精神に基づき，生徒が自己探求と自己実現に努め国家・社会の一員としての自覚に基づき行為しうる発達の段階にあることを考慮し，人間としての在り方生き方を考え，{{③}}の下に行動し，自立した人間として他者と共によりよく生きるための基盤となる{{④}}を養うことを目標とすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["各教科・科目", "各教科等", "共通の判断基準", "実践的な技能"]),
      fill_in_choice.call("イ", ["各教科", "各教科・科目等", "共通の判断基準", "実践的な技能"]),
      fill_in_choice.call("ウ", ["各教科・科目", "各教科・科目等", "主体的な判断", "道徳性"], true),
      fill_in_choice.call("エ", ["各教科", "各教科等", "主体的な判断", "道徳性"]),
    ],
    explanation_blocks: [
      text_block.call("「各教科・科目」は各教科に属する科目を指す。「各教科・科目等」には総合的な探究の時間と特別活動も含まれる。教育活動全体を通して，主体的な判断に基づく行動と，よりよく生きる基盤としての道徳性を育てる。"),
      text_block.call("ア：②は総合的な探究の時間・特別活動を含む「各教科・科目等」である。「各教科等」はこの箇所の定義ではない。 ③は「主体的な判断」の下に行動することであり，共通の判断基準に従うという語句ではない。 ④は生きるための基盤となる「道徳性」であり，実践的な技能への置換ではない。"),
      text_block.call("イ：①の略称は「各教科・科目」であり，「科目」を落とした「各教科」ではない。 ③は「主体的な判断」の下に行動することであり，共通の判断基準に従うという語句ではない。 ④は生きるための基盤となる「道徳性」であり，実践的な技能への置換ではない。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：①の略称は「各教科・科目」であり，「科目」を落とした「各教科」ではない。 ②は総合的な探究の時間・特別活動を含む「各教科・科目等」である。「各教科等」はこの箇所の定義ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第1款 2(2)第1・第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第3 指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）ホームルーム活動については，主としてホームルームごとに{{①}}が指導することを原則とし，活動の内容によっては他の教師などの協力を得ること。\n\n２ 内容の取扱いに当たっては，次の事項に配慮するものとする。\n\n（1）ホームルーム活動及び生徒会活動の指導については，指導内容の特質に応じて，{{②}}の下に，生徒の{{③}}な活動が効果的に展開されるようにすること。その際，よりよい生活を築くために{{④}}活動などを充実するよう工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生徒会担当の教師", "生徒会役員の自主的な判断", "自主的，実践的", "自分たちできまりをつくって守る"]),
      fill_in_choice.call("イ", ["生徒会担当の教師", "生徒会役員の自主的な判断", "自発的，自治的", "既存のきまりを理解して守る"]),
      fill_in_choice.call("ウ", ["ホームルーム担任の教師", "教師の適切な指導", "自主的，実践的", "既存のきまりを理解して守る"]),
      fill_in_choice.call("エ", ["ホームルーム担任の教師", "教師の適切な指導", "自発的，自治的", "自分たちできまりをつくって守る"], true),
    ],
    explanation_blocks: [
      text_block.call("ホームルーム活動は原則として担任が指導する。適切な教師の指導の下に生徒の自発的・自治的活動を展開し，自分たちできまりをつくり守る活動を充実する。"),
      text_block.call("ア：①の原則的な指導者は「ホームルーム担任の教師」である。活動によって他の教師の協力を得ることも認める。 ②は「教師の適切な指導」の下に行う規定である。生徒会役員の判断に置き換えない。 ③はこの箇所では「自発的，自治的」である。「自主的，実践的」も特別活動で使われるが，この原文の空欄とは異なる。"),
      text_block.call("イ：①の原則的な指導者は「ホームルーム担任の教師」である。活動によって他の教師の協力を得ることも認める。 ②は「教師の適切な指導」の下に行う規定である。生徒会役員の判断に置き換えない。 ④は「自分たちできまりをつくって守る」活動である。既存のきまりの理解・遵守にとどまる語句とは区別する。"),
      text_block.call("ウ：③はこの箇所では「自発的，自治的」である。「自主的，実践的」も特別活動で使われるが，この原文の空欄とは異なる。 ④は「自分たちできまりをつくって守る」活動である。既存のきまりの理解・遵守にとどまる語句とは区別する。"),
      text_block.call("エ：全ての空欄が原文と一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第5章第3の1(6)・2(1) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=483",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..10).to_a
  raise "模擬試験24の承認済み問番号は1〜10です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験24 問#{number}は4択・正答1件にしてください"
  end
  if number <= 5 && question.fetch(:category_code) != (number <= 2 ? "education_foundations" : "education_system")
    raise "模擬試験24 問#{number}の分類が不正です"
  end
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  required_cloze = number >= 4 || (number == 3 && [22, 24].include?(24))
  if required_cloze
    expected_labels = %w[① ② ③ ④]
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
      raise "模擬試験24 問#{number}の空欄と選択肢の対応が不正です"
    end
    if [4, 5].include?(number) && !quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) }
      raise "模擬試験24 問#{number}の抜粋枠には条番号を表示してください"
    end
  elsif !choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "text" }
    raise "模擬試験24 問#{number}の選択肢形式が不正です"
  end
  if [6, 7].include?(number)
    scope = number == 6 ? "第3款" : "第5款"
    unless prompt.fetch(:text).include?("第1章 総則 #{scope}") && question.fetch(:source_text).include?("第1章#{scope}")
      raise "模擬試験24 問#{number}の導入文と出典範囲が一致しません"
    end
  end
  entry = { exam_number: 24, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(24, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } <= 3 }
  raise "模擬試験24の問1〜10の正答位置が偏っています"
end

QuestionSeedSync.import(exam_number: 24, questions: questions, publication_status: "draft")

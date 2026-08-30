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

# 模擬試験9は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("幕末の洋学教育機関に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "蕃書調所は『解体新書』刊行直後の1774（安永3）年に設けられ、昌平坂学問所の一部として儒学経典の校訂だけを行った。外国語を教授する生徒教育は行わず、幕末まで名称や組織も変更されなかった。"),
      text_choice.call("イ", "幕府は1856（安政3）年、洋学の中心機関として蕃書調所を正式に設置し、後に洋書調所、開成所へと改称した。開港後は蘭学だけでなく英学なども発達し、明治維新後には開成学校、大学南校などを経て、東京大学創設の母体の一つとなった。", true),
      text_choice.call("ウ", "長崎海軍伝習所は明治政府が横浜に設けた海軍士官学校であり、イギリス人教官が法学と倫理学だけを教授した。幕府関係者や諸藩の藩士が学ぶことは認められず、航海術、造船、砲術、測量なども教育対象外であった。"),
      text_choice.call("エ", "伊東玄朴らが設けた種痘所は幕府直轄となった後、西洋医学所、医学所へ改称されたが、開成所へ吸収された時点で西洋医学教育を廃止した。そのため、明治政府の大学や東京大学医学系組織には継承されなかった。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アは、蕃書調所の正式な設置を1774年とし、生徒教育や名称変更がなかったとしている点が誤りです。正式な設置は1856年で、その後、洋書調所、開成所へと名称を変更しました。イは、設置年、名称の変遷、蘭学から英学等への広がり、東京大学へつながる系譜を正しく説明しています。ウは、長崎海軍伝習所の設置主体、場所、教官及び教育内容のすべてが誤りです。幕府が長崎に設け、オランダ人から航海術、造船学、砲術、測量術などを学び、幕府関係者のほか諸藩からも参加者がありました。エは、種痘所から西洋医学所、医学所へ発展した系譜を開成所へ吸収されて消滅したとしている点が誤りです。この系譜は明治政府に引き継がれ、東京大学医学系組織の母体の一つとなりました。"),
    ],
    source_text: "文部科学省『学制百年史』序章「一 幕末期の教育―洋学および洋学校の発達」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("パーカースト（Parkhurst, H.）とドルトン・プランに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "パーカーストは、一斉教授と一律の進度を改めるためにラボラトリー・プランを構想し、1920年にマサチューセッツ州ドルトンの学校で実験した。生活と協同の拠点となる「ハウス」、一定期間の学習計画と課題を示す「アサインメント」、教師の助言を受けながら個別又は小集団で学ぶ「ラボラトリー」などを通して、生徒の自由・自立と社会的責任を両立させようとし、1922年に『ドルトン・プランの教育』を刊行した。", true),
      text_choice.call("イ", "ドルトン・プランでは、生徒ごとのアサインメントを設定する一方、その課題を毎日同じ順序・同じ時間に全員で処理することを義務付けた。生徒同士の協力は個人の独立を妨げるとして禁止し、教師による一斉説明をすべての学習の中心に置いた。"),
      text_choice.call("ウ", "パーカーストのいう自由とは、共通の教育内容や履行すべきアサインメントを設けず、生徒がその日の気分だけで活動を選ぶことを意味した。ラボラトリーでは教師の助言を排除し、課題を完了する責任や時間管理を生徒に求めなかった。"),
      text_choice.call("エ", "ドルトン・プランは、学習を完全に孤立した個人間の競争として組織するもので、学校を社会的共同体として捉えることを否定した。ハウス、アサインメント、ラボラトリーはいずれも生徒同士の交流を防ぎ、成績順位だけを高めるための仕組みとして設計された。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。パーカーストは、1920年にマサチューセッツ州ドルトンの学校でラボラトリー・プランを実施し、後にドルトン・プランとして知られる教育方法を発展させました。ドルトン・プランは、ハウス、アサインメント、ラボラトリーを通して、学習者の自由と責任、個人の自立と社会的協同を結び付ける構想です。イは、一律の時間割・進度と一斉説明を中心に据え、協力を禁止するとしている点が誤りです。ウは、自由を無制限な放任としている点と、アサインメントに対する責任、時間管理、教師の援助を否定している点が誤りです。エは、ドルトン・プランが学校を社会的共同体として捉え、自由と協同の両立を重視したことと反します。"),
    ],
    source_text: "パーカースト著、赤井米吉訳、中野光編『ドルトン・プランの教育』（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I000001190245
宮本健市郎『ドルトン・プランの成立過程とヘレン・パーカーストの思想形成』 | https://www.jstage.jst.go.jp/article/kyouikushigaku/42/0/42_KJ00009273870/_article/-char/ja/
長崎大学教育学部『長崎県に於ける新教育運動の展開―ドールトン・プランを主として』 | https://nagasaki-u.repo.nii.ac.jp/record/8289/files/kyoikuKyK00_16_02.pdf
河合塾学園ドルトンスクール『学校紹介』 | https://www.dalton-school.ed.jp/about/",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第16条 教育行政」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第16条　教育は、{{①}}に服することなく、この法律及び他の法律の定めるところにより行われるべきものであり、教育行政は、国と地方公共団体との{{②}}及び{{③}}の下、公正かつ適正に行われなければならない。\n2　国は、全国的な教育の機会均等と教育水準の{{④}}を図るため、教育に関する施策を総合的に策定し、実施しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["不当な介入", "明確な権限分配", "相互の監視", "均衡"]),
      fill_in_choice.call("イ", ["政治的支配", "対等な関係", "相互の連携", "保障"]),
      fill_in_choice.call("ウ", ["不当な支配", "適切な役割分担", "相互の協力", "維持向上"], true),
      fill_in_choice.call("エ", ["不当な支配", "適切な役割分担", "国の指導", "全国的統一"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。教育基本法第16条の語句は「不当な支配」「適切な役割分担」「相互の協力」「維持向上」です。アの「不当な介入」「明確な権限分配」「相互の監視」「均衡」は原文と一致しません。イは政治的支配に限っている点や、「対等な関係」「相互の連携」「保障」とする点が異なります。エは国の一方向的な指導や全国的統一を定めた規定ではありません。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第16条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第81条　幼稚園、小学校、中学校、義務教育学校、高等学校及び{{①}}においては、次項各号のいずれかに該当する幼児、児童及び生徒その他教育上{{②}}を必要とする幼児、児童及び生徒に対し、{{③}}の定めるところにより、障害による{{④}}の困難を克服するための教育を行うものとする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["高等専門学校", "合理的配慮", "教育委員会", "心身上"]),
      fill_in_choice.call("イ", ["中等教育学校", "特別の配慮", "都道府県の教育委員会", "学習上"]),
      fill_in_choice.call("ウ", ["特別支援学校", "特別の支援", "文部科学大臣", "教育上又は生活上"]),
      fill_in_choice.call("エ", ["中等教育学校", "特別の支援", "文部科学大臣", "学習上又は生活上"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。第81条第1項は、中等教育学校を含む各学校において、教育上特別の支援を必要とする幼児、児童及び生徒に対し、文部科学大臣の定めるところにより、障害による学習上又は生活上の困難を克服するための教育を行うことを定めています。アは学校種、必要とする支援、決定主体及び困難の表現が異なります。イは「特別の支援」「文部科学大臣」「学習上又は生活上」と一致しません。ウは列挙される学校を特別支援学校とし、「教育上又は生活上」としている点が誤りです。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第81条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第23条　公立の小学校等の教諭等の{{①}}は、当該教諭等（{{②}}その他の政令で定める者を除く。）に対して、その{{③}}（現に教諭等の職以外の職に任命されている者を教諭等の職に任命する場合を含む。）の日から{{④}}の教諭又は保育教諭の職務の遂行に必要な事項に関する実践的な研修（次項において「初任者研修」という。）を実施しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["任命権者", "条件付採用期間中の者", "昇任", "二年間"]),
      fill_in_choice.call("イ", ["研修実施者", "臨時的に任用された者", "採用", "一年間"], true),
      fill_in_choice.call("ウ", ["指導助言者", "臨時的に任用された者", "任用", "六月間"]),
      fill_in_choice.call("エ", ["研修実施者", "非常勤の講師", "採用", "三年間"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。初任者研修を実施する主体は研修実施者です。臨時的に任用された者等を除き、採用の日から一年間、職務の遂行に必要な事項に関する実践的な研修を実施します。アは実施主体、除外対象、起算事由及び期間が異なります。ウは実施主体を指導助言者、起算事由を任用、期間を六月間としている点が誤りです。エは除外対象と研修期間が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第23条 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "不登校児童生徒への支援の目標は、将来、児童生徒が{{①}}し、豊かな人生を送れるような、社会的自立を果たすことです。そのため、不登校児童生徒への支援においては、{{②}}を目標とするのではなく、児童生徒が自らの進路を主体的に捉え、社会的自立を目指せるように支援を行うことが求められます。\n\nこのことは、「児童生徒一人一人の個性の発見とよさや可能性の伸長と社会的資質・能力の発達を支えると同時に、自己の幸福追求と社会に受け入れられる自己実現を支える」という生徒指導の目的そのものと重なるものであると言えます。\n\n人が社会で充実した人生を歩んでいくためには、自分と関わる人たちとの関係性を保ちながら、自らの意志と判断で主体的に社会に参画していくことができるようになることが重要です。そのため、ここでいう社会的自立は、依存しないことや支援を受けないということではなく、{{③}}しながら、社会の中で自己実現していくという意味であると捉えることができます。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["精神的にも経済的にも自立", "学校に登校するという結果のみ", "適切に他者に依存したり、自らが必要な支援を求めたり"], true),
      fill_in_choice.call("イ", ["学力面でも生活面でも標準に到達", "在籍校への復帰だけ", "支援を受けず、自分だけで判断したり行動したり"]),
      fill_in_choice.call("ウ", ["健康面でも学習面でも安定", "欠席日数を減らすことだけ", "できる限り他者への依存を避けたり、援助を断ったり"]),
      fill_in_choice.call("エ", ["保護者から完全に独立", "進路を早期に確定することだけ", "周囲が決めた支援をそのまま受け入れたり、指示に従ったり"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。不登校児童生徒への支援では、登校という結果だけではなく、将来、精神的にも経済的にも自立して社会の中で自己実現していくことを目標とします。また、社会的自立は他者への依存や支援の利用を否定する概念ではありません。イは一律の標準への到達や在籍校への復帰だけを目標にし、支援を受けないことを自立とみなす点が誤りです。ウは欠席日数の減少だけに目標を限定し、他者への適切な依存を否定しています。エは保護者からの完全な独立や早期の進路確定を一律に求め、本人が必要な支援を求めることを扱っていません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第10章10.1.4「支援の目標」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("学習障害（LD）のある生徒の状態の把握と教育的対応に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "LDは全般的な知的発達の遅れを必須とし、聞く、話す、読む、書く、計算する、推論するという全ての能力に同程度の困難が生じることを特徴とする。"),
      text_choice.call("イ", "LDに対する教材や回答方法の調整は、医療機関による診断が確定してから開始する。読み上げや情報機器の使用は学習目標を引き下げるため、評価場面では原則として認めない。"),
      text_choice.call("ウ", "全般的な知的発達に遅れはないものの、聞く、話す、読む、書く、計算する又は推論する能力のうち、特定のものの習得や使用に著しい困難を示すことがある。困難の状態に応じ、文字の大きさや間隔、音声情報、視覚的手掛かり、文章構成の補助などを調整する。", true),
      text_choice.call("エ", "文章の読みが遅い場合は、視力の問題又は学習意欲の不足によるものと判断できる。読む量を増やして同じ方法を反復すればよく、語のまとまりを示したり音と文字との対応を指導したりする必要はない。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。LDは全般的な知的発達の遅れを必須とせず、特定の能力に顕著な困難が現れる点が特徴です。イは適切ではありません。診断名だけを支援開始の条件とせず、実際の学習上の困難と教育的ニーズに基づいて支援します。回答手段の調整は、学ぶ内容そのものを引き下げることとは異なります。ウが適切です。LDの状態像と、読み書き等の困難に応じた具体的な支援を正しく組み合わせています。エは適切ではありません。読みにくさの背景を把握し、音と文字の対応、語のまとまり、文字間隔、読み上げなど、困難に応じた方法を検討します。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編「障害の状態等に応じた教育的対応」学習障害 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_13.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("レヴィンの青年期に関する考え方として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "青年は、子どもの集団から離れようとしながら、大人の集団にはまだ完全に受け入れられていないため、二つの集団の境界に位置する周辺人として捉えられた。"),
      text_choice.call("イ", "青年は、自分が子どもと大人のどちらに所属するのか確信をもちにくく、社会的地位や生活空間の変化に伴って、過度に敏感になったり極端な考え方を示したりすることがあると説明された。"),
      text_choice.call("ウ", "周辺人という概念は青年だけに限定されたものではなく、二つの集団の境界にいて、どちらに所属するのかが不確かな者にも当てはまる。レヴィンは青年の置かれた状態を、このような集団間の境界状況との類似から捉えた。"),
      text_choice.call("エ", "青年期の心理社会的危機を同一性対同一性混乱とし、大人としての責任を猶予されながら職業や価値観を探索する期間を心理社会的モラトリアムと名付けた。", true),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。レヴィンは、青年を子どもと大人という二つの集団の境界に位置する周辺人として捉えました。イは適切です。所属の不確かさや生活空間の変化が、青年の不安定さ、敏感さ、極端な行動などに関係すると説明しました。ウは適切です。周辺人は、複数の集団の境界に置かれ、所属が不確かな者を表す概念であり、青年はその一例として論じられました。エが適切ではありません。同一性対同一性混乱及び心理社会的モラトリアムはエリクソンに関係します。"),
    ],
    source_text: "大学入試センター『令和7年度本試験 旧倫理』 | https://www.dnc.ac.jp/albums/abm.php?d=771&f=abm00005968.pdf&n=2025_op_17_kyuurinri.pdf\n教栄学院『西洋教育史・教育心理 重要人物・事項一覧』 | https://www.kyoueigakuin.com/kyou-kyouikusi.html",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ケーラー及びトールマンの学習理論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ケーラーは、チンパンジーが問題状況の要素間の関係を捉え直して解決へ至る洞察学習を示した。トールマンは、直ちに報酬が与えられなくても迷路の構造が潜在的に学習され、認知地図が形成され得ると考えた。", true),
      text_choice.call("イ", "ケーラーは、ネコの問題箱における脱出時間が試行ごとに徐々に短くなることから試行錯誤説を提唱した。トールマンは、その結果に基づいて効果の法則を定式化した。"),
      text_choice.call("ウ", "トールマンは、音と餌を繰り返し対提示することで、音だけでも唾液反応が生じることを示し、中性刺激が条件刺激へ変化する古典的条件づけを提唱した。"),
      text_choice.call("エ", "ケーラーとトールマンは、ともに観察可能な刺激と反応との直接的結合だけで学習を説明し、問題状況の認知的な把握や、生体内部の期待・表象を説明から排除した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。ケーラーは問題状況の再構成による洞察を、トールマンは潜在学習や認知地図を重視しました。いずれも単純な刺激―反応の反復だけでは説明しにくい学習を扱っています。イは適切ではありません。ネコの問題箱、試行錯誤説、効果の法則はいずれもソーンダイクに関係します。ウは適切ではありません。犬の唾液反応を用いた古典的条件づけはパブロフに関係します。トールマンはネズミの迷路学習などを通じて、目的や期待を含む認知的な学習理論を展開しました。エは適切ではありません。ケーラーもトールマンも、単純な刺激―反応の直接的結合だけではなく、問題状況の認知的構造や期待などを重視しました。"),
    ],
    source_text: "関西学院大学学術リポジトリ掲載資料『ソーンダイクの試行錯誤とケーラーの洞察』 | https://kwansei.repo.nii.ac.jp/record/15842/files/524-3.pdf\n法政大学通信教育部『教育心理学』スタディガイド | https://www.tsukyo.hosei.ac.jp/wp/wp-content/uploads/2025/06/92e0ccbc8be59c69e6525fb1e7de87b0.pdf\n日本心理学会『古典的条件づけとは何か』 | https://psych.or.jp/publication/world083/pw03/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「普通教育を主とする学科」の弾力化・大綱化に関する記述である。最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学校長の判断により，特色・魅力ある教育内容を表現する名称を学科名とする。教育課程では必履修教科・科目等を基盤とし，学校設定教科・科目や総合的な探究の時間を各年次にわたって体系的に開設し，関係機関との連携・協働体制を整える。"),
      text_choice.call("イ", "各設置者の判断により，特色・魅力ある教育内容を表現する名称を学科名とする。教育課程では必履修教科・科目等を基盤とし，学校設定教科・科目や総合的な探究の時間を，学科の中心的な課題に取り組む重点学年へ集中的に配置する。"),
      text_choice.call("ウ", "各設置者の判断により，特色・魅力ある教育内容を表現する名称を学科名とする。関係機関との連携・協働体制を構築する際に配置するコーディネーターは，学科内の教科・科目間における授業時数の調整や成績処理を担う校内調整役として位置付ける。"),
      text_choice.call("エ", "各設置者の判断により，特色・魅力ある教育内容を表現する名称を学科名とする。教育課程では必履修教科・科目等を基盤とし，学校設定教科・科目や総合的な探究の時間を各年次にわたって体系的に開設する。また，高等学校と関係機関とのコーディネート機能を担う人材の配置も考えられる。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは，学科名を定める主体を学校長としている点が誤りです。答申では，各設置者の判断によるものとされています。教育課程と関係機関との連携に関する部分は適切です。イは，学校設定教科・科目や総合的な探究の時間を重点学年へ集中させている点が誤りです。答申では，各年次にわたって体系的に開設することが求められています。ウは，コーディネーターの役割が異なります。答申が示すのは，授業時数や成績処理を調整する校内調整役ではなく，高等学校と高等教育機関，研究機関，地方公共団体，企業・経済団体等の関係機関とのコーディネート機能を担う者です。エは，学科名の決定主体，教育課程の構成及びコーディネーターの役割が答申の内容と一致しています。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅱ部 各論3（2）③「『普通教育を主とする学科』の弾力化・大綱化」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 3, 4, 5, 11, 12, 13, 14, 15]
  raise "作成中の模擬試験9には承認済みの問1から問5、問11から問15だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験9 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験9 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
      raise "模擬試験9 問#{question.fetch(:question_number)}の空欄数と選択肢セル数が一致しません"
    end
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 9,
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

    question.assign_attributes(question_attributes.merge(publication_status: "draft"))
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
      raise "模擬試験9 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

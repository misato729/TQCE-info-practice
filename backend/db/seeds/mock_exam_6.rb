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

# 模擬試験6は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("古代日本の官人養成と教育施設に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "律令制下の大学寮は中務省に属し、身分を問わず全国の庶民を官人として養成する中央教育機関であった。一方、国学は都に置かれ、皇族・上級貴族の子弟だけを対象として大学寮への進学準備を行った。"),
      text_choice.call("イ", "平安時代の大学別曹は、衰退した国学に代えて各国に設置された国営の地方学校であり、藤原氏の学館院、橘氏の勧学院などが代表例である。入学者は氏族との関係を問われず、大学寮とは独立した教育課程で学んだ。"),
      text_choice.call("ウ", "空海が設けた綜芸種智院は、大学寮の附属施設として官人候補者に儒学だけを教授した学校であり、入学は貴族の子弟に限られ、僧侶や庶民が学ぶことは認められていなかった。"),
      text_choice.call("エ", "律令制下では、中央に式部省管轄の大学寮が置かれて主として貴族・官人の子弟を教育し、地方には国ごとに国学が置かれて郡司の子弟などを教育した。平安時代には有力氏族が一族の子弟を支援する大学別曹を設け、藤原氏の勧学院、橘氏の学館院などが成立した。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは、大学寮を中務省管轄とし、国学を都に置かれた施設としている点が誤りです。大学寮は式部省の管轄で、国学は地方の各国に置かれました。イは、大学別曹を国営の地方学校としている点に加え、氏族と施設の対応を逆にしている点が誤りです。大学別曹は、大学寮で学ぶ一族の子弟を寄宿・経済面などから支援するため、有力氏族が設けた施設で、藤原氏の勧学院、橘氏の学館院などが知られています。ウは、綜芸種智院を大学寮の附属施設及び貴族子弟だけを対象とする儒学専門校としている点が誤りです。綜芸種智院は空海が設けた私的な教育施設で、僧俗を問わず庶民にも学問を開こうとしました。エは、大学寮、国学、大学別曹の性格と具体例を正しく組み合わせています。"),
    ],
    source_text: "拓殖大学論集『日本古代における大学・国学教育と釈奠』 | https://takushoku-u.repo.nii.ac.jp/record/214/files/%E6%97%A5%E6%9C%AC%E5%8F%A4%E4%BB%A3%E3%81%AB%E3%81%8A%E3%81%91%E3%82%8B%E5%A4%A7%E5%AD%A6%E3%83%BB%E5%9B%BD%E5%AD%A6%E6%95%99%E8%82%B2%E3%81%A8%E9%87%88%E5%A5%A0.pdf\n名桜大学教員養成講座資料『日本の教育史』 | https://www2.meio-u.ac.jp/ext-center/TTC/files/5-13_4.pdf",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("次の各文は、教育史上の人物の教育思想や教育実践に関する記述である。プラトンの教育思想及び教育実践についての記述として最も適切なものを、下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "対話を通して相手の意見を引き出して吟味し、自らの無知を自覚させることによって、普遍的な概念の探究へ導こうとした。知識を一方的に授けるのではなく、相手の内にある知を生み出すのを助ける働きを、産婆の働きになぞらえた。"),
      text_choice.call("イ", "ソクラテスの弟子として哲学的探究を発展させ、アカデメイアを創設した。真理の探究に必要な学習として数論、幾何学、天文学、音楽理論などを重視するとともに、哲学的訓練を受けた者を国家の統治者として養成することを構想した。", true),
      text_choice.call("ウ", "すべての人が広く体系的な知識を学ぶことのできる教育を唱え、人の発達段階に応じた学校制度を構想した。また、『世界図絵』を著し、観察や経験を重視して、事物や事象を感覚器官を通して学ばせようとした。"),
      text_choice.call("エ", "子供を固有の発達段階にある存在として捉え、『エミール』において自然の歩みに即した教育を論じた。幼少期には徳や真理を直接教え込むのではなく、悪徳や誤った判断から子供を守りながら、経験を通して学ばせる消極教育を重視した。"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。アはソクラテスの問答法と産婆術についての説明です。ソクラテスは、対話によって相手の考えを吟味し、無知を自覚させながら、相手自身が知を生み出すのを援助しようとしました。イはプラトンについての適切な説明です。プラトンはアカデメイアを創設し、真理の探究のために数論、幾何学、天文学、音楽理論などを重視しました。また、哲学的訓練を受けた統治者の養成を教育目的の一つとしました。ウはコメニウスについての説明です。コメニウスは、すべての人を対象とする体系的な教育を構想し、『世界図絵』では感覚を通した学習を重視しました。エはルソーについての説明です。ルソーは『エミール』で子供の自然な発達を尊重し、幼少期には大人の価値観や知識を早急に教え込まない消極教育を論じました。"),
    ],
    source_text: "八戸学院大学短期大学部『教育原理⑥配布資料』Ⅰ『西洋の教育制度』 | https://jc.hachinohe-u.ac.jp/wp-content/uploads/2022/09/d3f727f70b2e4f333b41e75aeb6896c9.pdf\n茨城キリスト教大学『教育史Ⅰ』授業計画『プラトン―哲人王と教育』 | https://www.icc.ac.jp/kyoumu/syllabus/pdf/1301201001.pdf\n広島大学『第57回 ソクラテスメソッド』 | https://www.hiroshima-u.ac.jp/node/56937\n北海道大学 橋本努講義レジュメ『ルソー「エミール」』 | https://www.econ.hokudai.ac.jp/~hasimoto/Resume%20on%20Rousseau%20Emile.htm",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「教育基本法」（平成18年法律第120号）の政治教育及び宗教教育に関する記述である。正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "宗教に関する寛容の態度、宗教に関する一般的な教養及び宗教の社会生活における地位は、教育上尊重されなければならない。また、国及び地方公共団体が設置する学校は、特定の宗教のための宗教教育その他宗教的活動をしてはならない。", true),
      text_choice.call("イ", "特定の政党を支持し、又はこれに反対するための政治教育その他政治的活動をしてはならないとする規定は、国及び地方公共団体が設置する学校だけに適用され、私立学校には適用されない。"),
      text_choice.call("ウ", "学校における政治的中立性を確保するため、政治に関する内容は教育から排除されなければならず、良識ある公民として必要な政治的教養についても学校教育で取り扱ってはならない。"),
      text_choice.call("エ", "特定の宗教のための宗教教育その他宗教的活動の禁止は、法律に定めるすべての学校に適用され、宗教に関する一般的な教養を取り扱うことも一律に禁止される。"),
    ],
    explanation_blocks: [
      text_block.call("アが正しい記述です。アは、教育基本法第15条第1項及び第2項の内容と一致します。イは誤りです。政治教育に関する禁止の対象は「法律に定める学校」であり、国公立学校だけに限定されません。ウは誤りです。第14条第1項は、良識ある公民として必要な政治的教養を教育上尊重すると定めています。エは誤りです。特定の宗教のための宗教教育等が禁止されるのは国及び地方公共団体が設置する学校です。また、宗教に関する一般的な教養は教育上尊重されます。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第14条・第15条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第55条　高等学校の{{①}}の課程又は{{②}}の課程に在学する生徒が、技能教育のための施設で当該施設の所在地の{{③}}の指定するものにおいて教育を受けているときは、校長は、文部科学大臣の定めるところにより、当該施設における学習を当該高等学校における{{④}}とみなすことができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["全日制", "定時制", "市町村の教育委員会", "単位の修得"]),
      fill_in_choice.call("イ", ["定時制", "通信制", "文部科学大臣", "教科の全部の履修"]),
      fill_in_choice.call("ウ", ["定時制", "通信制", "都道府県の教育委員会", "教科の一部の履修"], true),
      fill_in_choice.call("エ", ["全日制", "通信制", "都道府県知事", "学校外における学修"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。第55条は、定時制又は通信制の課程に在学する生徒について、都道府県の教育委員会が指定する技能教育施設での学習を、校長が高等学校における教科の一部の履修とみなすことができると定めています。アは対象に全日制を含め、指定者を市町村の教育委員会としている点などが誤りです。イは指定者を文部科学大臣、みなしの対象を教科の全部としている点が誤りです。エは全日制、都道府県知事及び「学校外における学修」の部分が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第55条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第12条　公立の小学校、中学校、義務教育学校、高等学校、中等教育学校、特別支援学校、幼稚園及び幼保連携型認定こども園（以下「小学校等」という。）の{{①}}、助教諭、保育教諭、助保育教諭及び{{②}}（以下「教諭等」という。）に係る地方公務員法第二十二条に規定する採用については、同条中「{{③}}」とあるのは「{{④}}」として同条の規定を適用する。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["教諭", "講師", "一年", "二年"]),
      fill_in_choice.call("イ", ["教諭", "講師", "六月", "一年"], true),
      fill_in_choice.call("ウ", ["養護教諭", "実習助手", "六月", "一年"]),
      fill_in_choice.call("エ", ["教頭", "講師", "三月", "六月"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。教育公務員特例法第12条は、教諭、助教諭、保育教諭、助保育教諭及び講師を「教諭等」とし、地方公務員法第22条の条件付任用期間について「六月」を「一年」と読み替えます。アは読み替え前後の期間がいずれも誤りです。ウは対象職を養護教諭及び実習助手としている点が誤りです。エは対象職及び読み替える期間が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第12条 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "「{{①}}」は、教育相談コーディネーターをはじめ、生徒指導主事、特別支援教育コーディネーター、養護教諭、SC、SSW などが集まり、{{②}}を見いだし、必要な支援体制を整備するために開催される会議です。\n\nこの会議では、悩みや不安を抱える児童生徒を広く網に掛けるようにスクリーニングします。会議で取り上げることによって、児童生徒のリスク要因を理解し意識的に見守る教職員の目が増えます。欠席日数、遅刻・早退の回数、保健室の利用回数などスクリーニングにかける際の基準を決めておくことと、学級・ホームルーム担任以外も対象の児童生徒を認識しておくことが重要です。そうすることで、学級・ホームルーム担任の抱え込みなどによる{{③}}を防ぐことができます。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["ケース会議", "援助ニーズの高い児童生徒", "問題の深刻化"]),
      fill_in_choice.call("イ", ["教育相談部会", "支援を希望する児童生徒", "情報共有の不足"]),
      fill_in_choice.call("ウ", ["スクリーニング会議", "リスクの高い児童生徒", "支援の遅れ"], true),
      fill_in_choice.call("エ", ["スクリーニング会議", "重大な危険行為の予兆がある児童生徒", "初期対応の混乱"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。スクリーニング会議は、複数の教職員や専門職がリスクの高い児童生徒を見いだし、必要な支援体制を整えるための会議です。対象を担任以外の教職員も認識することにより、担任の抱え込みによる支援の遅れを防ぎます。アのケース会議は、スクリーニング後、特に集中的な関わりが必要と判断された事例についてアセスメントや支援計画を検討する場であり、この箇所の会議名とは異なります。イの教育相談部会は、この箇所で示された早期対応方法の名称ではありません。エは①だけが一致しますが、②を重大な危険行為の予兆がある場合に限定する点と、③を初期対応の混乱とする点が原文と異なります。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第3章3.3.2「教育相談活動の全校的展開」(3)「課題予防的教育相談：課題早期発見対応」②「早期対応の方法」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("知的障害のある生徒の状態の把握と教育的対応に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "知的障害については、知的機能の発達の遅れだけでなく、概念的スキル、社会的スキル及び実用的スキルに関する適応行動の困難性も併せて把握する必要がある。また、適応行動の状態は、周囲の環境や支援の状況によって変化する可能性がある。", true),
      text_choice.call("イ", "知能検査で一定の数値を下回った場合には、適応行動に困難が認められなくても知的障害と判断できる。知能検査の結果は検査時の心理状態や検査者との関係の影響を受けないため、原則として再検討する必要はない。"),
      text_choice.call("ウ", "適応行動とは、読み書きや数量処理などの概念的スキルだけを意味する。対人関係や社会的ルールの理解、日常生活における自己管理などは、知的障害の状態を把握する際の対象には含まれない。"),
      text_choice.call("エ", "知的障害のある生徒に対しては、同年齢の生徒と同一の学習内容を反復させることを優先する。学習環境や教材の提示方法を調整すると生徒本来の能力を把握できなくなるため、補助的な手段の使用は避ける。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。知的機能と適応行動の双方を把握し、生徒を取り巻く環境や支援との関係を含めて教育的ニーズを検討します。イは適切ではありません。知能検査の数値だけで判断するのではなく、適応行動の状態と併せて検討します。検査結果は心身の状態、検査への意欲、検査者との関係などの影響も受けます。ウは適切ではありません。適応行動には、概念的スキルだけでなく、社会的スキルや、日常生活に必要な実用的スキルも含まれます。エは適切ではありません。どのような条件や支援があれば力を発揮できるかを把握し、教材、指示、学習環境などを調整することが必要です。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編「障害の状態等に応じた教育的対応」知的障害 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_07.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("エリクソンの心理社会的発達理論と、マーシャのアイデンティティ・ステイタス論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "エリクソンは、探索とコミットメントの有無によって青年を四つのアイデンティティ・ステイタスに分類し、探索もコミットメントもない状態を心理社会的モラトリアムと呼んだ。"),
      text_choice.call("イ", "マーシャは、人間の生涯を八つの心理社会的発達段階に分け、青年期を「同一性対同一性混乱」、成人期初期を「親密性対孤立」の段階として位置付けた。"),
      text_choice.call("ウ", "マーシャの分類では、十分な探索を経ずに親や周囲の価値観を受け入れている状態がモラトリアムであり、探索を続けているが特定の選択へのコミットメントがない状態が早期完了である。"),
      text_choice.call("エ", "エリクソンは青年期の心理社会的危機を同一性対同一性混乱とし、社会的責任を一定期間猶予されながら役割を探索できる時期を心理社会的モラトリアムと捉えた。マーシャは、このアイデンティティ形成を探索とコミットメントの観点から四つの状態に整理した。", true),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。探索とコミットメントによる四分類を示したのはマーシャです。また、探索もコミットメントも乏しい状態はアイデンティティ拡散に当たります。イは適切ではありません。八つの心理社会的発達段階を示したのはエリクソンです。マーシャは、エリクソンのアイデンティティ論を踏まえて四つの状態を整理しました。ウは適切ではありません。十分な探索を経ずにコミットメントがある状態が早期完了であり、探索中でコミットメントが確定していない状態がモラトリアムです。エが適切です。エリクソンの発達理論と、これを探索及びコミットメントの観点から具体化したマーシャの分類との関係を正しく説明しています。"),
    ],
    source_text: "三重大学教育心理学研究室『アイデンティティ・ステイタス』 | https://educational-psychology.edu.mie-u.ac.jp/thesis/2006/nakahara/houhou.html\n創価大学掲載論文『女子青年のアイデンティティ・ステイタス』 | https://www.soka.ac.jp/files/ja/20170512_160201.pdf\nCiNii Books エリクソン著・岩瀬庸理訳『アイデンティティ―青年と危機』 | https://ci.nii.ac.jp/ncid/BN0147722X",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("古典的条件づけ及びオペラント条件づけに関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "パブロフの古典的条件づけは、自発的な行動の直後に生じる結果によって、その行動の頻度が変化する過程を指す。一方、スキナーのオペラント条件づけは、中性刺激と無条件刺激との対提示によって反応が形成される過程を指す。"),
      text_choice.call("イ", "古典的条件づけでは、条件刺激と無条件刺激との関係が学習される。オペラント条件づけでは、行動とその結果との関係が学習され、嫌悪刺激の除去によって行動が増加する場合は負の強化に当たる。", true),
      text_choice.call("ウ", "正の強化と負の強化の「正」と「負」は、結果が学習者にとって望ましいか望ましくないかを表す。したがって、負の強化は望ましくない結果によって行動を減少させる手続である。"),
      text_choice.call("エ", "罰は行動を減少させるため、行動を増加させることを扱うオペラント条件づけには含まれない。また、ある働き掛けが罰であるかどうかは、その後の行動変化ではなく、働き掛けを行った者の意図によって決まる。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。説明が逆です。刺激同士の対応関係を学習するのが古典的条件づけであり、自発的な行動とその結果との関係を学習するのがオペラント条件づけです。イが適切です。負の強化では、行動に伴って嫌悪刺激が除去又は回避される結果、その行動が増加します。「負」は刺激の除去を意味し、行動の減少を意味しません。ウは適切ではありません。「正」は刺激の提示、「負」は刺激の除去を表します。「強化」は行動が増加することであり、負の強化も行動を増加させます。エは適切ではありません。罰もオペラント条件づけに含まれます。また、強化や罰は、働き掛けを行った者の意図ではなく、その後に対象行動が増加したか減少したかによって区別されます。"),
    ],
    source_text: "日本心理学会『古典的条件づけとは何か』 | https://psych.or.jp/publication/world083/pw03/\nものつくり大学講義資料『オペラント条件づけ』 | https://www.iot.ac.jp/building/hasegawa/pdf/2015004pre.pdf",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された「学校教育の質と多様性，包摂性を高め，教育の機会均等を実現する」ための方向性に関する記述である。最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "様々な背景により多様な教育的ニーズのある子供に対し，自立と社会参加を見据え，その時点の教育的ニーズに的確に応える多様で柔軟な仕組みを整える。十分な人的配置や情報通信技術も活用しながら個別化と協働化を適切に組み合わせ，教育水準を上げる方向で機会均等を実現する。", true),
      text_choice.call("イ", "多様な教育的ニーズに応じた学びを保障するため，地域や家庭による教育条件の差を域内で調整し，教材，指導方法及び情報通信技術の利用時期をそろえた上で，教育水準を段階的に引き上げる。この順序によって，新たな教育手段の導入に伴う格差を抑えながら機会均等を実現する。"),
      text_choice.call("ウ", "一人一人の内的なニーズや自発性に応じた個別化を進めるとともに，協働化では学習進度や興味・関心の近い児童生徒による集団編成を軸とする。共通の基礎を身に付けた段階で異なる背景をもつ他者との対話へ発展させることで，個性の伸長と社会性の育成を両立させる。"),
      text_choice.call("エ", "入学時の教育相談やアセスメントを通じて教育的ニーズに最も適した学びの場を決定し，同じ学校段階では継続性のある指導を行う。進学時に学びの場を改めて検討する仕組みを整えることにより，指導の一貫性と学びの場の柔軟性を両立させる。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。答申は，多様な教育的ニーズに対し，「その時点」で最も的確に応える多様で柔軟な仕組みを整えること，個別化と協働化を適切に組み合わせること，教育水準を上げる方向で機会均等を実現することを示しています。イは，教育条件をそろえてから活用するという順序が異なります。答申は，情報通信環境が整った家庭を対象にまず実施し，整っていない家庭への支援を考えることを「積極的な配慮」の例としています。ウは，協働化の中心を学習進度や関心の近い者による集団に置き，異質な他者との対話を後の段階に位置付けている点が異なります。答申は，個の確立と異質な他者との対話を促すことの弱さを課題として挙げています。エは，学びの場を同じ学校段階で継続するという部分が異なります。答申は，入学時に固定するのではなく，その時点の教育的ニーズに応じられる多様で柔軟な仕組みを求めています。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部 総論4（1）「学校教育の質と多様性，包摂性を高め，教育の機会均等を実現する」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 3, 4, 5, 11, 12, 13, 14, 15]
  raise "作成中の模擬試験6には承認済みの問1から問5、問11から問15だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験6 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験6 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
      raise "模擬試験6 問#{question.fetch(:question_number)}の空欄数と選択肢セル数が一致しません"
    end
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 6,
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
      raise "模擬試験6 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

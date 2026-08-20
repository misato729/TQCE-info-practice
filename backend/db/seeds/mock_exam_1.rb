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

questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_history",
    content_blocks: [
      text_block.call("ペスタロッチ（Pestalozzi, J. H.）の教育思想に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "子供の自然な発達を妨げないため、社会的な働きかけをできる限り排する消極教育を重視した。"),
      text_choice.call("イ", "学校を小さな社会と捉え、経験を通して問題を解決する学習を教育の中心に据えた。"),
      text_choice.call("ウ", "知・徳・体に相当する諸能力を調和的に発達させることを重視し、直観に基づく教育を実践した。", true),
      text_choice.call("エ", "人間の心を生まれた時には白紙であると捉え、経験によって観念が形成されると論じた。"),
    ],
    explanation_blocks: [
      text_block.call("ペスタロッチは、人間に備わる諸能力の調和的発達を目指し、頭・心・手に象徴される知的・道徳的・身体的な力を一体として育てる教育を重視しました。アはルソー、イはデューイ、エはロックに対応する説明です。"),
    ],
    source_text: "ペスタロッチ『隠者の夕暮』ほか／令和6・7年度 科目Ⅰの教育史分野の出題傾向",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_history",
    content_blocks: [
      text_block.call("次の日本の教育制度に関する出来事を、古いものから順に並べたものとして最も適切なものを選びなさい。\n\n① 教育令の公布\n② 学制の公布\n③ 教育基本法の公布\n④ 教育ニ関スル勅語の発布"),
    ],
    choices: [
      text_choice.call("ア", "① → ② → ④ → ③"),
      text_choice.call("イ", "② → ① → ④ → ③", true),
      text_choice.call("ウ", "④ → ② → ① → ③"),
      text_choice.call("エ", "② → ④ → ① → ③"),
    ],
    explanation_blocks: [
      text_block.call("学制は1872（明治5）年、教育令は1879（明治12）年、教育ニ関スル勅語は1890（明治23）年、教育基本法は1947（昭和22）年に公布されました。したがって②、①、④、③の順です。"),
    ],
    source_text: "文部科学省『学制百年史』／教育基本法（昭和22年法律第25号）",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は、『教育基本法』（平成18年法律第120号）第4条第1項の条文である。文章中の空欄 {{①}} 〜 {{③}} に当てはまる語句の組合せとして正しいものを、下のア〜エの中から一つ選びなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第4条　すべて国民は、{{①}}、その{{②}}に応じた教育を受ける機会を与えられなければならず、人種、信条、性別、社会的身分、経済的地位又は{{③}}によって、教育上差別されない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["ひとしく", "能力", "門地"], true),
      fill_in_choice.call("イ", ["ひとしく", "適性", "国籍"]),
      fill_in_choice.call("ウ", ["等しく", "能力", "国籍"]),
      fill_in_choice.call("エ", ["等しく", "適性", "門地"]),
    ],
    explanation_blocks: [
      text_block.call("教育基本法第4条第1項の文言は、『ひとしく、その能力に応じた教育を受ける機会』および『経済的地位又は門地によって、教育上差別されない』です。したがって、①は『ひとしく』、②は『能力』、③は『門地』となります。"),
    ],
    source_text: "教育基本法 第4条第1項（教育の機会均等）",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      text_block.call("学校教育法に基づく児童生徒への懲戒と体罰に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "校長だけが懲戒を行うことができ、教員が懲戒を行うことは認められていない。"),
      text_choice.call("イ", "教育上必要であれば、けがを生じさせない範囲で体罰を行うことができる。"),
      text_choice.call("ウ", "懲戒と体罰はいずれも法律上禁止されており、指導上の措置を講じることはできない。"),
      text_choice.call("エ", "校長および教員は教育上必要と認めるときに懲戒を加えることができるが、体罰を加えることはできない。", true),
    ],
    explanation_blocks: [
      text_block.call("学校教育法第11条は、校長および教員による教育上必要な懲戒を認める一方、体罰を明確に禁止しています。懲戒が認められることと、身体への侵害を伴う体罰が禁止されることを区別する必要があります。"),
    ],
    source_text: "学校教育法 第11条",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_law",
    content_blocks: [
      text_block.call("教育公務員特例法に定める公立学校教員の研修に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "授業のない時間であれば、承認を受けずに勤務場所を離れて研修できる。"),
      text_choice.call("イ", "任命権者の承認を受ければ、授業への支障の有無にかかわらず勤務場所を離れて研修できる。"),
      text_choice.call("ウ", "授業に支障のない限り、本属長の承認を受けて勤務場所を離れて研修できる。", true),
      text_choice.call("エ", "勤務場所を離れて行える研修は、長期研修として任命権者が命じたものに限られる。"),
    ],
    explanation_blocks: [
      text_block.call("教育公務員特例法第22条第2項は、『授業に支障のない限り』かつ『本属長の承認を受けて』勤務場所を離れて研修できると定めています。いずれか一方だけでは要件を満たしません。"),
    ],
    source_text: "教育公務員特例法 第22条（研修の機会）",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      text_block.call("高等学校学習指導要領における、育成を目指す資質・能力の三つの柱の組合せとして、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "基礎的な学力／専門的な学力／社会で活用する力"),
      text_choice.call("イ", "知識及び技能／思考力・判断力・表現力等／学びに向かう力・人間性等", true),
      text_choice.call("ウ", "関心・意欲・態度／知識・理解／技能・表現"),
      text_choice.call("エ", "個別最適な学び／協働的な学び／探究的な学び"),
    ],
    explanation_blocks: [
      text_block.call("資質・能力は、『何を理解しているか、何ができるか』『理解していること・できることをどう使うか』『どのように社会・世界と関わり、よりよい人生を送るか』に対応する三つの柱で整理されています。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第1章 総則 第1款",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      text_block.call("高等学校におけるカリキュラム・マネジメントの説明として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教科等横断的な視点で教育内容を組み立て、実施状況を評価・改善し、人的・物的資源も効果的に組み合わせる取組である。", true),
      text_choice.call("イ", "各教科が独立性を保つため、他教科との関連を設けずに年間指導計画を作成する取組である。"),
      text_choice.call("ウ", "教育課程の編成を教育委員会に一任し、学校は定められた時間割だけを管理する取組である。"),
      text_choice.call("エ", "学習評価を年度末の評定処理に限定し、教育課程の改善とは切り離す取組である。"),
    ],
    explanation_blocks: [
      text_block.call("カリキュラム・マネジメントには、教科等横断的な教育内容の組織、教育課程の実施状況の評価と改善、必要な人的・物的資源の活用という観点があります。学校全体で教育課程を継続的に改善する考え方です。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第1章 総則 第1款",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      text_block.call("総合的な探究の時間における探究の過程を、学習の進行に沿って並べたものとして最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "情報の収集 → 課題の設定 → まとめ・表現 → 整理・分析"),
      text_choice.call("イ", "整理・分析 → 情報の収集 → 課題の設定 → まとめ・表現"),
      text_choice.call("ウ", "課題の設定 → 整理・分析 → 情報の収集 → まとめ・表現"),
      text_choice.call("エ", "課題の設定 → 情報の収集 → 整理・分析 → まとめ・表現", true),
    ],
    explanation_blocks: [
      text_block.call("探究では、課題を設定し、必要な情報を収集し、集めた情報を整理・分析して、考えをまとめ・表現する過程が基本です。この過程は一度で終わらず、振り返りを通して繰り返されます。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第4章 総合的な探究の時間",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      text_block.call("高等学校におけるキャリア教育の進め方として、学習指導要領の趣旨に最も合致するものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "卒業学年の進路希望調査と面接指導だけをキャリア教育として実施する。"),
      text_choice.call("イ", "就職を希望する生徒だけを対象に、職業技能の習得を中心として実施する。"),
      text_choice.call("ウ", "特別活動を要としながら各教科・科目等の特質に応じて、学校の教育活動全体を通して組織的・計画的に実施する。", true),
      text_choice.call("エ", "生徒が自由に進路を選べるよう、学校から職業や進学に関する情報を提供しない。"),
    ],
    explanation_blocks: [
      text_block.call("キャリア教育は、学ぶことと自己の将来とのつながりを見通し、社会的・職業的自立に必要な基盤を育てるものです。特別活動を要としつつ、各教科等を含む学校教育全体で組織的・計画的に行います。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第1章 総則 第5款",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "curriculum_guideline",
    content_blocks: [
      text_block.call("高等学校の特別活動で育成する資質・能力を捉える三つの視点として、最も適切な組合せを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "集団統率／規則遵守／進路決定"),
      text_choice.call("イ", "人間関係形成／社会参画／自己実現", true),
      text_choice.call("ウ", "知識習得／技能向上／態度形成"),
      text_choice.call("エ", "学級経営／生徒会運営／学校行事"),
    ],
    explanation_blocks: [
      text_block.call("特別活動では、様々な集団活動を通して育てる資質・能力を『人間関係形成』『社会参画』『自己実現』の三つの視点で整理しています。エは活動内容の例であり、資質・能力を捉える視点ではありません。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 特別活動編 第1章",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance",
    content_blocks: [
      text_block.call("生徒指導の重層的支援構造に照らした取組として、発達支持的生徒指導に当たるものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "全ての生徒を対象に、日常の授業や学級活動で自己決定の機会を設け、互いのよさを認め合える関係づくりを進める。", true),
      text_choice.call("イ", "いじめの兆候が見られた生徒について、関係教職員が情報を共有し、早期対応を行う。"),
      text_choice.call("ウ", "長期欠席が続く生徒について、専門機関と連携した個別の支援計画を作成する。"),
      text_choice.call("エ", "暴力行為を繰り返す生徒について、校内支援チームが継続的な個別指導を行う。"),
    ],
    explanation_blocks: [
      text_block.call("発達支持的生徒指導は、第1層として全ての児童生徒を対象に、発達を支える働きかけを日常の教育活動で行うものです。イは課題早期発見対応、ウとエは困難課題対応的生徒指導に位置付けられます。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ヴィゴツキー（Vygotsky, L. S.）の『発達の最近接領域』の説明として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学習者が既に一人で完全に遂行できる課題だけで構成された領域である。"),
      text_choice.call("イ", "成熟によって自然に獲得されるため、他者からの援助が影響しない領域である。"),
      text_choice.call("ウ", "学習者の知能検査得点と、同年齢集団の平均得点との差を示す領域である。"),
      text_choice.call("エ", "一人では解決できないが、より有能な他者の援助があれば解決できる課題を含む領域である。", true),
    ],
    explanation_blocks: [
      text_block.call("発達の最近接領域は、独力で可能な現在の発達水準と、援助を受けて可能となる潜在的な発達水準との間を指します。教師や仲間による適切な足場かけが学習を支えます。"),
    ],
    source_text: "ヴィゴツキー『思考と言語』／令和7年度 科目Ⅰの教育思想・心理分野の出題傾向",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ある教師は、提出期限を守った生徒に対して、直後に具体的な称賛を与えた。その後、その生徒が期限を守る行動が増えた。この説明として最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "罰によって不適切な行動が減少した。"),
      text_choice.call("イ", "負の強化によって適切な行動が増加した。"),
      text_choice.call("ウ", "正の強化によって適切な行動が増加した。", true),
      text_choice.call("エ", "消去によって適切な行動が増加した。"),
    ],
    explanation_blocks: [
      text_block.call("行動の直後に好ましい刺激である称賛を加え、その行動の生起頻度が増えているため、オペラント条件づけにおける正の強化です。負の強化は、不快な刺激を取り除くことで行動が増える場合を指します。"),
    ],
    source_text: "スキナーのオペラント条件づけ理論／令和6・7年度 科目Ⅰの学習理論分野の出題傾向",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("オーズベル（Ausubel, D. P.）の有意味受容学習に関する記述として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "学習者には教材を示さず、試行錯誤だけで全ての規則を発見させることを重視する。"),
      text_choice.call("イ", "新しい内容を既有知識と関連付けて理解できるよう、学習に先立って包括的な枠組みを示す先行オーガナイザーを用いる。", true),
      text_choice.call("ウ", "正答するたびに即時強化を与え、教材を細かな段階に分割して個別に進める。"),
      text_choice.call("エ", "他者の行動とその結果を観察することによって、新しい行動を獲得させる。"),
    ],
    explanation_blocks: [
      text_block.call("有意味受容学習では、新しい知識を学習者の認知構造にある既有知識と関連付けて理解することを重視します。先行オーガナイザーは、新しい学習内容を位置付ける包括的な枠組みとして働きます。"),
    ],
    source_text: "オーズベルの有意味受容学習理論／令和6・7年度 科目Ⅰの学習理論分野の出題傾向",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "new_japanese_school_education",
    content_blocks: [
      text_block.call("『令和の日本型学校教育』における『個別最適な学び』と『協働的な学び』の関係について、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "両者を一体的に充実させ、主体的・対話的で深い学びの実現に向けた授業改善につなげる。", true),
      text_choice.call("イ", "個別最適な学びを優先し、協働的な学びは学習内容を理解できない生徒だけに行う。"),
      text_choice.call("ウ", "協働的な学びを全ての授業の中心とし、個々の学習状況に応じた指導は行わない。"),
      text_choice.call("エ", "個別最適な学びはICTによる自習、協働的な学びは対面授業に限定して実施する。"),
    ],
    explanation_blocks: [
      text_block.call("答申では、『個別最適な学び』と『協働的な学び』をそれぞれ孤立させず、一体的に充実させることが示されています。ICTはそのための手段になり得ますが、学びの形をICT自習や対面授業だけに限定するものではありません。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して』（令和3年1月26日答申）",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      text_block.call("共通必履修科目『情報Ⅰ』の内容を構成する四つの項目の組合せとして、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "情報社会と倫理／情報機器の操作／プログラミング／情報産業と社会"),
      text_choice.call("イ", "情報の表現と管理／情報テクノロジー／情報システム／課題研究"),
      text_choice.call("ウ", "情報社会の問題解決／コンテンツの制作と発信／情報システム／データサイエンス"),
      text_choice.call("エ", "情報社会の問題解決／コミュニケーションと情報デザイン／コンピュータとプログラミング／情報通信ネットワークとデータの活用", true),
    ],
    explanation_blocks: [
      text_block.call("『情報Ⅰ』は、問題解決、コミュニケーションと情報デザイン、コンピュータとプログラミング、情報通信ネットワークとデータ活用の四項目で構成されます。選択科目『情報Ⅱ』や専門教科情報の内容と混同しないことが重要です。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第2章 第10節 情報",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      text_block.call("『情報Ⅰ』の『コミュニケーションと情報デザイン』における学習活動として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "表計算ソフトの操作手順だけを暗記し、同じ形式の文書を繰り返し作成する。"),
      text_choice.call("イ", "情報量を増やすことだけを目的に、対象者を定めず複数のメディアへ同じ内容を掲載する。"),
      text_choice.call("ウ", "伝える目的と受け手を明確にし、メディアの特性を踏まえて表現を試作し、評価を基に改善する。", true),
      text_choice.call("エ", "見た目の美しさを優先し、情報の正確さや操作性は評価の対象にしない。"),
    ],
    explanation_blocks: [
      text_block.call("情報デザインでは、目的や状況、受け手を踏まえ、メディアの特性を生かして分かりやすく伝えることを重視します。制作して終わりではなく、表現を評価し改善する過程も学習内容に含まれます。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編『情報Ⅰ』(2)",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_curriculum_guideline",
    content_blocks: [
      text_block.call("情報セキュリティの三要素と具体例の対応として、最も適切なものを選びなさい。"),
    ],
    choices: [
      text_choice.call("ア", "機密性：必要なときに利用できること／完全性：許可された者だけが利用できること／可用性：改ざんされていないこと"),
      text_choice.call("イ", "機密性：許可された者だけが利用できること／完全性：情報が正確で改ざんされていないこと／可用性：必要なときに利用できること", true),
      text_choice.call("ウ", "機密性：情報が正確であること／完全性：必要なときに利用できること／可用性：匿名で利用できること"),
      text_choice.call("エ", "機密性：通信速度を保つこと／完全性：障害から復旧できること／可用性：パスワードを公開しないこと"),
    ],
    explanation_blocks: [
      text_block.call("機密性はアクセスを認められた者だけが情報を利用できる状態、完全性は破壊・改ざん・消去されていない状態、可用性は必要なときに情報やシステムを利用できる状態を指します。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編『情報Ⅰ』(1)(4)",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "algorithm",
    content_blocks: [
      text_block.call("次のプログラムは、昇順に整列済みの配列 a から値 x を二分探索するものである。a = [3, 8, 12, 17, 21, 29, 34]、x = 29 としたとき、条件『a[mid] == x』は何回評価されるか。なお、『//』は小数点以下を切り捨てる整数除算を表す。"),
      {
        type: "code",
        title: "二分探索",
        code: "low = 0\nhigh = aの要素数 - 1\n\nlow <= high の間繰り返す:\n  mid = (low + high) // 2\n  もし a[mid] == x ならば:\n    mid を返して終了する\n  そうでなく a[mid] < x ならば:\n    low = mid + 1\n  そうでなければ:\n    high = mid - 1",
      },
    ],
    choices: [
      text_choice.call("ア", "3回"),
      text_choice.call("イ", "1回"),
      text_choice.call("ウ", "4回"),
      text_choice.call("エ", "2回", true),
    ],
    explanation_blocks: [
      text_block.call("最初は low=0、high=6 なので mid=3となり、a[3]=17はxと一致しないため探索範囲を4〜6へ移します。次に mid=5となり、a[5]=29がxと一致するため、一致条件の評価は合計2回です。"),
      {
        type: "code",
        title: "探索範囲の変化",
        code: "1回目: low=0, high=6, mid=3, a[mid]=17\n2回目: low=4, high=6, mid=5, a[mid]=29（発見）",
      },
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編『情報Ⅰ』(3) コンピュータとプログラミング",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "data_science",
    content_blocks: [
      text_block.call("ある店舗で、5か月分の広告費と売上高を調べたところ、次の表が得られた。このデータから直接いえることとして、最も適切なものを選びなさい。"),
      {
        type: "table",
        headers: ["月", "広告費（万円）", "売上高（万円）"],
        rows: [
          ["1", "1", "12"],
          ["2", "2", "15"],
          ["3", "3", "17"],
          ["4", "4", "20"],
          ["5", "5", "23"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "広告費と売上高には強い負の相関が見られる。"),
      text_choice.call("イ", "広告費を増やせば、他の条件にかかわらず必ず売上高が増える。"),
      text_choice.call("ウ", "広告費と売上高には正の相関が見られるが、このデータだけで広告費が売上増加の原因だとは断定できない。", true),
      text_choice.call("エ", "売上高が広告費を決定しているという因果関係が証明された。"),
    ],
    explanation_blocks: [
      text_block.call("広告費が大きい月ほど売上高も大きく、二つの変数には正の相関が見られます。ただし、季節、客数、価格施策など別の要因が影響している可能性があるため、観察された相関だけから因果関係は断定できません。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編『情報Ⅰ』(4) データの活用",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験1は問1から問20までの20問で構成してください"
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 1,
      question_number: attributes.fetch(:question_number),
    )
    question.assign_attributes(question_attributes.merge(publication_status: "draft"))
    question.save!

    labels = choices.map { |choice| choice.fetch(:label) }
    question.question_choices.where.not(choice_label: labels).destroy_all

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
      raise "模擬試験1 問#{question.question_number}の選択肢または正答数が不正です"
    end

    question.update!(publication_status: "published")
  end
end

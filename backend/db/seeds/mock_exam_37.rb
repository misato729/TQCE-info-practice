# 模擬試験37（承認済み問1〜5のみ・未完成のため下書き）
# 承認正本：document/模試36〜40_問1〜2草案_2026-10-16.md／document/模試36〜40_問3〜5草案_2026-10-16.md
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      {
        type: "text",
        text: "明治19年の師範学校令に基づく教員養成の仕組みについて述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "尋常師範学校は公立小学校の校長・教員を，高等師範学校は尋常師範学校の校長・教員を養成することを基本とした。生徒に学資を支給するとともに卒業後の服務義務を設け，教員を計画的に確保しようとした。"
          }
        ],
        correct: true
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "尋常師範学校は各府県に設け，高等師範学校は文部大臣の管理に置いた。高等師範学校では小学校の校長・教員を養成し，尋常師範学校ではその教員を養成するという分担により，二段階の養成体系を構成した。"
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "尋常師範学校を府県に設け，生徒には在学中の学資を支給した。生徒募集と卒業後の服務に関する規則は，府県が学校を設置する責任に対応させ，各府県の地方長官が定めるものとされた。"
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "尋常師範学校と高等師範学校を設け，教員となる者の気質の形成を重視した。高等師範学校の経費を府県の地方税から，尋常師範学校の経費を国庫から支弁することにより，両者の役割に応じた財政負担を定めた。"
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：適切。法令上の基本となる養成対象，学資支給と卒業後の服務義務を対応させている。時宜により他の学校の校長・教員となることも認められていた。"
      },
      {
        type: "text",
        text: "イ：設置・管理の説明は適切だが，基本となる養成対象が逆。尋常師範学校が公立小学校の校長・教員を，高等師範学校が尋常師範学校の校長・教員を養成した。"
      },
      {
        type: "text",
        text: "ウ：設置と学資支給の説明は適切だが，生徒募集及び卒業後の服務に関する規則を定める主体が誤り。師範学校令第8条では文部大臣が定めるものとされ，府県ごとの地方長官に委ねられていたのではない。"
      },
      {
        type: "text",
        text: "エ：財政負担が逆。高等師範学校は国庫，尋常師範学校は地方税から経費を支弁する仕組みであった。"
      }
    ],
    source_text: "文部科学省『学制百年史』「一 師範学校制度の整備」―師範学校令の公布 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317635.htm\n文部科学省『学制百年史』資料編「師範学校令（明治十九年四月十日勅令第十三号）」第4・8〜11条 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318073.htm"
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      {
        type: "text",
        text: "カントの教育に関する考え方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "カントは，人間は教育によって人間になるとし，養育・訓練・教授と指導を区別した。養育とは，動物的衝動が人間性の法則から逸脱することを予防する働きであり，訓練とは，子どもが自らの能力を上手に使うための配慮であるとした。"
          }
        ],
        correct: false
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "カントは，子どもを養育し，訓練を通して人間性の法則からの逸脱を予防することを重視した。子どもの啓蒙は，養育と訓練によって，自分の判断を成熟した他者の判断へ置き換えて行動できるようになることで達成されるとした。"
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "カントは，教育による人間形成を重視し，動物的な衝動を抑える訓練を教育に位置付けた。そのため，教育の対象となる未成年状態を，身体の成長が完了する以前の時期として捉え，身体の成熟に伴って自ら考える力も成立するとした。"
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "カントは，養育によって能力の適切な使用を助け，訓練によって人間性の法則からの逸脱を予防することを重視した。さらに，子どもが自ら思考することを学び，学んだことを実践するよう積極的に指導する必要があると考えた。"
          }
        ],
        correct: true
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：養育と訓練の役割が逆。能力を上手に使えるように配慮することが養育であり，動物的衝動による逸脱を予防し，法則の拘束を感じさせることが訓練に関わる。"
      },
      {
        type: "text",
        text: "イ：啓蒙を他者の判断への依存の完成とした点が誤り。他者に判断を委ねる状態から抜け出して自ら思考することが重要であり，養育・訓練だけで十分とはしていない。"
      },
      {
        type: "text",
        text: "ウ：未成年状態を身体の成長段階に限った点が誤り。身体が成熟していても，他人に身を委ねて自分で考えない状態は生じる。身体的成熟と自律的な思考の成立を同一視しない。"
      },
      {
        type: "text",
        text: "エ：適切。養育・訓練と積極的な教授・指導を区別し，衝動の抑制にとどまらず，自ら思考して実践することへつなぐ関係を述べている。"
      }
    ],
    source_text: "白石崇人『資料から考える教育原理』第9章・105頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf"
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第10条 家庭教育」からの抜粋である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"
      },
      {
        type: "fill_in_quote",
        text: "第10条　父母その他の保護者は、子の教育について{{①}}を有するものであって、生活のために必要な習慣を身に付けさせるとともに、{{②}}を育成し、心身の調和のとれた発達を図るよう努めるものとする。\n\n２　{{③}}は、家庭教育の自主性を尊重しつつ、保護者に対する学習の機会及び情報の提供その他の家庭教育を支援するために必要な施策を{{④}}。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "第一義的責任",
              "自立心",
              "学校の設置者",
              "講じなければならない"
            ]
          }
        ],
        correct: false
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "補完的責任",
              "公共心",
              "国及び地方公共団体",
              "講じなければならない"
            ]
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "第一義的責任",
              "自立心",
              "国及び地方公共団体",
              "講ずるよう努めなければならない"
            ]
          }
        ],
        correct: true
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "補完的責任",
              "公共心",
              "学校の設置者",
              "講ずるよう努めなければならない"
            ]
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：①②は一致する。③は「国及び地方公共団体」，④は「講ずるよう努めなければならない」である。学校の設置者に支援施策を講ずる直接の義務を課す条文としてはいない。第1項の保護者の責任と，第2項の公的支援の主体・義務の強さを区別する。"
      },
      {
        type: "text",
        text: "イ：③は一致する。①は「第一義的責任」，②は「自立心」，④は「講ずるよう努めなければならない」である。家庭教育を他の教育の補完として位置付けるのではなく，保護者が子の教育について第一義的責任を有する。公共心を育てる教育一般の是非ではなく，この条文の原語を問う。"
      },
      {
        type: "text",
        text: "ウ：全て原文と一致する。保護者の第一義的責任，自立心の育成，国及び地方公共団体による家庭教育の自主性を尊重した支援施策の努力義務が，二つの項に対応している。"
      },
      {
        type: "text",
        text: "エ：④は一致する。①は「第一義的責任」，②は「自立心」，③は「国及び地方公共団体」である。支援施策の努力義務を定める対象も学校の設置者ではない。"
      }
    ],
    source_text: "教育基本法第10条第1項・第2項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_10"
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
      },
      {
        type: "fill_in_quote",
        text: "第34条第1項〜第3項\n\n小学校においては、文部科学大臣の検定を経た教科用図書又は文部科学省が著作の名義を有する教科用図書を使用しなければならない。\n\n２　前項に規定する教科用図書（以下この条において「教科用図書」という。）の内容を文部科学大臣の定めるところにより記録した電磁的記録（電子的方式、磁気的方式その他人の知覚によつては認識することができない方式で作られる記録であつて、電子計算機による情報処理の用に供されるものをいう。）である教材がある場合には、同項の規定にかかわらず、文部科学大臣の定めるところにより、児童の教育の充実を図るため必要があると認められる教育課程の一部において、教科用図書に代えて当該教材を使用することができる。\n\n３　前項に規定する場合において、視覚障害、発達障害その他の文部科学大臣の定める事由により{{①}}に対し、教科用図書に用いられた{{②}}その他の同項に規定する教材を電子計算機において用いることにより可能となる方法で指導することにより当該児童の学習上の困難の程度を{{③}}させる必要があると認められるときは、文部科学大臣の定めるところにより、{{④}}において、教科用図書に代えて当該教材を使用することができる。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "教科用図書を使用して学習することが困難な児童",
              "内容の要約又は平易な表現への書換え",
              "低減",
              "教育課程の一部"
            ]
          }
        ],
        correct: false
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "特別支援学校の小学部に在籍する児童",
              "文字、図形等の拡大又は音声への変換",
              "解消",
              "教育課程の全部又は一部"
            ]
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "特別支援学校の小学部に在籍する児童",
              "内容の要約又は平易な表現への書換え",
              "解消",
              "教育課程の一部"
            ]
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "教科用図書を使用して学習することが困難な児童",
              "文字、図形等の拡大又は音声への変換",
              "低減",
              "教育課程の全部又は一部"
            ]
          }
        ],
        correct: true
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：①③は一致する。②は「文字、図形等の拡大又は音声への変換」，④は「教育課程の全部又は一部」が正しい。第3項は学習上の困難を低減するための方法と，条件を満たす場合の代替使用の範囲を定めている。第2項の「教育課程の一部」と第3項の範囲を混同している。要約等の支援が一般に不適切だという意味ではない。"
      },
      {
        type: "text",
        text: "イ：②④は一致するが，①③が誤り。第3項の対象は，所定の事由により教科用図書を使用して学習することが困難な児童であり，特別支援学校小学部への在籍を要件にしていない。必要性の判断も困難の程度の「低減」であり，完全な「解消」を条件とはしていない。"
      },
      {
        type: "text",
        text: "ウ：四つとも原文と異なる。対象を特別支援学校小学部の在籍者へ置き換え，原文の方法を要約・書換えへ，困難の程度の低減を解消へ，第3項の範囲を第2項と同じ一部へ取り違えている。"
      },
      {
        type: "text",
        text: "エ：四つとも原文と一致する。学習上の困難のある児童に対し，拡大・音声変換等によって困難の程度を低減させる必要が認められる場合に，第3項は教育課程の全部又は一部で代替使用を可能としている。"
      },
      {
        type: "text",
        text: "第34条は第62条によって高等学校にも準用される。抜粋は準用元の原文であり，「小学校」「児童」をそのまま掲載した。"
      }
    ],
    source_text: "e-Gov法令検索「学校教育法」第34条第1項〜第3項（令和8年6月17日施行版） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_4-At_34\n同法第62条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_62"
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。"
      },
      {
        type: "text",
        text: "参照先の補足（抜粋枠外）：地方公務員法第38条第2項は、人事委員会が営利企業等への従事に関する許可の基準を定めることができる旨の規定である。本文の「第二十二条の四第一項に規定する短時間勤務の職」及び「第二十二条の二第一項第二号」に掲げる者は、地方公務員法上の任用区分を示す。"
      },
      {
        type: "fill_in_quote",
        text: "第17条第1項〜第3項\n\n教育公務員は、教育に関する他の職を兼ね、又は教育に関する他の事業若しくは事務に従事することが{{①}}の遂行に支障がないと{{②}}（地方教育行政の組織及び運営に関する法律第三十七条第一項に規定する県費負担教職員（以下「県費負担教職員」という。）については、市町村（特別区を含む。以下同じ。）の教育委員会）において認める場合には、{{③}}を受け、又は受けないで、その職を兼ね、又はその事業若しくは事務に従事することができる。\n\n２　前項の規定は、非常勤の講師（地方公務員法第二十二条の四第一項に規定する短時間勤務の職を占める者及び同法第二十二条の二第一項第二号に掲げる者を除く。）については、適用しない。\n\n３　第一項の場合においては、地方公務員法第三十八条第二項の規定により人事委員会が定める許可の基準によることを{{④}}。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "本務",
              "任命権者",
              "給与",
              "要しない"
            ]
          }
        ],
        correct: true
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "本務",
              "本属長",
              "報酬",
              "要する"
            ]
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "兼職",
              "任命権者",
              "報酬",
              "要する"
            ]
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "兼職",
              "本属長",
              "給与",
              "要しない"
            ]
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：四つとも原文と一致する。教育に関する兼職等について、本務の遂行への支障がないと所定の主体が認める場合には、給与の有無を問わず兼職等ができる。その場合、人事委員会が定める地方公務員法第38条第2項の許可基準によることは要しない。"
      },
      {
        type: "text",
        text: "イ：①は一致する。②は「任命権者」、③は「給与」、④は「要しない」が正しい。勤務場所を離れた研修に関する本属長の承認と、兼職等の認定主体を混同している。兼職について他の制度で「報酬」が使われることと、この条文の原語は区別する。"
      },
      {
        type: "text",
        text: "ウ：②は一致する。①は「本務」、③は「給与」、④は「要しない」が正しい。支障の有無を判断する対象は兼職の遂行ではなく本務の遂行であり、第3項は人事委員会の許可基準によることを要求した規定ではない。"
      },
      {
        type: "text",
        text: "エ：③④は一致する。①は「本務」、②は「任命権者」が正しい。ただし、県費負担教職員については、原文の括弧書きどおり市町村等の教育委員会が認める。人事委員会の許可基準による必要がないことは、本務への支障の確認や第1項所定の認定まで不要になるという意味ではない。"
      }
    ],
    source_text: "e-Gov法令検索「教育公務員特例法」第17条第1項〜第3項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_3-At_17\ne-Gov法令検索「地方公務員法」第38条第2項（参照先） | https://laws.e-gov.go.jp/law/325AC0000000261/20250601_504AC0000000068#Mp-Ch_3-Se_6-At_38"
  }
]

unless questions.map { |question| question.fetch(:question_number) } == (1..5).to_a
  raise "承認済みの問1〜5だけを下書き登録してください"
end
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1 && choices.map { |choice| choice.fetch(:content_blocks) }.uniq.size == 4
    raise "問#{number}は異なる4択・正答1件にしてください"
  end
  texts = question.fetch(:explanation_blocks).map { |block| block.fetch(:text) }
  unless %w[ア イ ウ エ].all? { |label| texts.any? { |text| text.start_with?("#{label}：") } }
    raise "問#{number}は全肢解説が必要です"
  end
  unless question.fetch(:source_text).lines.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
    raise "問#{number}の出典形式が不正です"
  end
  cells = choices.first.fetch(:content_blocks).first
  if cells[:type] == "fill_in_choice"
    blocks = question.fetch(:content_blocks)
    quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten }.uniq
    unless blocks.first[:type] == "fill_in_text" && labels == %w[① ② ③ ④] && choices.all? { |choice| choice[:content_blocks].size == 1 && choice[:content_blocks].first[:type] == "fill_in_choice" && choice[:content_blocks].first[:cells].size == 4 }
      raise "問#{number}の4空欄・選択肢の対応が不正です"
    end
    unless quotes.all? { |quote| quote.fetch(:text).match?(/\A第\d+条/) }
      raise "問#{number}の抜粋枠は条番号から始めてください"
    end
    choices.map { |choice| choice[:content_blocks].first[:cells] }.transpose.each do |column|
      raise "問#{number}の空欄候補は各列2対2にしてください" unless column.group_by { |v| v }.values.map(&:size).sort == [2, 2]
    end
  elsif (4..5).cover?(number)
    raise "問#{number}は4空欄の条文穴埋めにしてください"
  end
end
QuestionSeedSync.import(exam_number: 37, questions: questions, publication_status: "draft")

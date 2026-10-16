# 模擬試験38（承認済み問1〜5のみ・未完成のため下書き）
# 承認正本：document/模試36〜40_問1〜2草案_2026-10-16.md／document/模試36〜40_問3〜5草案_2026-10-16.md
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      {
        type: "text",
        text: "明治期の小学校教科書の制度について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "明治19年の小学校令は，文部大臣の検定を経た教科書を使用する制度を定めた。この検定は府県内で実際に用いる一種類の教科書を選ぶ手続も兼ね，地方長官は文部大臣の決定に従って各学校へ供給した。"
          }
        ],
        correct: false
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "小学校教科書の検定では，地方長官が任命した審査委員が図書の適否を審査し，その結果を文部省へ届け出た。文部大臣は，各府県で適当と認められた図書の中から，当該府県の学校で使用する教科書を採択した。"
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "小学校では検定に加えて府県単位の採択が行われ，採択をめぐる贈収賄事件が国定化を進める契機となった。国定化後も民間の出版社が教科書を著作し，文部省がその翻刻発行と学校への供給を担当した。"
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "文部省の検定を経ることと，検定済みの図書から実際に用いるものを採択することは別の手続であった。府県単位の採択が行われた後，その採択をめぐる不正事件などを背景として小学校教科書の国定化が進んだ。"
          }
        ],
        correct: true
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：検定と採択を同一の手続としている点が誤り。検定済みの複数の教科書から，地方長官が任命する審査委員による審査を踏まえて府県単位で採択した。"
      },
      {
        type: "text",
        text: "イ：検定と採択の主体の対応が逆。文部省の検定を経た教科書について，府県単位で使用する図書を採択した。"
      },
      {
        type: "text",
        text: "ウ：前半は適切だが，国定化後の著作と発行・供給の役割が逆。文部省が著作を行い，翻刻発行・供給は民間に委ねる仕組みが採られた。"
      },
      {
        type: "text",
        text: "エ：適切。全国的な検定と府県単位の採択を区別し，国定化へ至る経緯を述べている。"
      }
    ],
    source_text: "文部科学省『学制百年史』「五 国定教科書制度の成立」―教科書の検定制度／教科書問題 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317624.htm\n文部科学省『学制百年史』「七 学科課程と教科書の制度」―教科書検定制度の実施／小学校国定教科書の成立 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317615.htm"
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      {
        type: "text",
        text: "近代の教育思想について述べた次のア～エのうち，適切でないものを一つ選んで記号で答えなさい。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "ヘルバルトは，教授を通して多面的な興味を育て，道徳的な品性の形成へ結び付けることを重視した。その際，教材を媒介として学習者の思想圏を広げる働きを訓育，教材を媒介とせず学習者の心情へ直接働き掛ける働きを教授と区別した。"
          }
        ],
        correct: true
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "ペスタロッチは，生活や親子の関係を人間形成の基礎に置き，具体的な事物を捉える直観を重視した。数・形・語を認識の基礎とするとともに，自ら数え，測り，読もうとする活動を援助して，知的な理解を発展させようとした。"
          }
        ],
        correct: false
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "コメニウスは，人間性の回復への期待を教育に託し，合理的で組織的な人間形成の方法を，教授方法や学校の仕組みとして構想した。『世界図絵』では，事物の絵と言葉を結び付け，感覚を通して理解することを助けようとした。"
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "ルソーは，『エミール』で一人の子どもの成長を描き，子ども期を充実させることに教育上の意義を認めた。身体や感覚を使った活動への欲求を尊重し，後に理性を備えて自立して生きる人間の形成へつなげようとした。"
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：教授と訓育の対応が逆。教材を媒介として思想圏を広げるのが教授であり，教材を媒介とせず心情へ直接働き掛けるのが訓育である。多面的な興味を育てる教授を道徳的な品性の形成へつなぐという前半は適切であり，教授を道徳形成と無関係な知識伝達とする説明でもない。"
      },
      {
        type: "text",
        text: "イ：適切。生活や親子関係を基礎にすることと，数・形・語の直観を踏まえる自己活動によって概念的理解へ進むことを対応させている。"
      },
      {
        type: "text",
        text: "ウ：適切。コメニウスの宗教的な人間観を背景とする学校・教授方法の構想と，絵と言語による直観的な教材との対応である。"
      },
      {
        type: "text",
        text: "エ：適切。子ども期を単なる未完成な大人の時期として扱わず，その活動を充実させることと，後の自立や理性の形成を結び付けている。子どもの活動を尊重することを，教育の目的を持たない放任とはしていない。"
      }
    ],
    source_text: "筑波大学附属図書館『近代教育学の源流』I | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap1.html\nIII | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap3.html\nIV | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n白石崇人『資料から考える教育原理』第9章・107頁，第10章・120頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n大武茂樹「フェレンベルグとヘルバルト―ホフヴィルにおける相剋（1）―」『常磐短期大学研究紀要』32号，2003年，40〜49頁のうち47頁 | https://www.tokiwa.ac.jp/tokiwa/publication/college/pdf/college_32.pdf#page=50\n花井信「『Didaktik＝教授学』と『didactic＝訓話的』との間―アダム・スミスに拠りながら―」47頁 | https://shizuoka.repo.nii.ac.jp/record/11244/files/69-0033.pdf#page=16"
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "text",
        text: "次の①～③は，「教育基本法」（平成18年法律第120号）に関する記述である。正しいものが幾つあるかを，下のア～エの中から一つ選んで記号で答えなさい。"
      },
      {
        type: "fill_in_quote",
        text: "①　教育は，人格の完成を目指し，平和で民主的な国家及び社会の形成者として必要な資質を備えた国民の育成を期して行われる。また，生涯学習の理念では，生涯にわたり学習できることと，その成果を適切に生かすことのできる社会の実現が定められている。\n\n②　教育の目標は，学問の自由を尊重しつつ達成するよう行われるものとされている。その目標の一つとして，個人の価値を尊重し，能力や創造性を伸ばすことと併せて，職業及び生活との関連を重視し，協同を重んずる態度を養うことが掲げられている。\n\n③　国及び地方公共団体は，障害のある者がその障害の状態に応じ十分な教育を受けられるよう，教育上必要な支援を講じなければならない。また，能力があるにもかかわらず経済的理由で修学が困難な者に対して，奨学の措置を講じなければならない。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "三つ"
          }
        ],
        correct: false
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "二つ"
          }
        ],
        correct: true
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "一つ"
          }
        ],
        correct: false
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "なし"
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "①：正しい。教育の目的に関する前半は第1条，生涯学習の理念に関する後半は第3条に対応する。学習する機会を生涯にわたって確保することに加え，成果を適切に生かせる社会の実現までが理念に含まれている。"
      },
      {
        type: "text",
        text: "②：誤り。学問の自由の尊重，個人の価値，能力・創造性，職業及び生活との関連という部分は第2条本文・第2号に対応するが，同号が重んずる態度として掲げるのは「勤労」であり，「協同」ではない。協同的な活動が教育上不適切という意味ではなく，同号の職業・生活との関連に続く法定目標を取り違えている。"
      },
      {
        type: "text",
        text: "③：正しい。前半は第4条第2項，後半は同条第3項に対応する。いずれも国及び地方公共団体に「講じなければならない」とする義務を定めており，家庭教育の支援施策や幼児期の教育の振興における努力義務と区別する。"
      },
      {
        type: "text",
        text: "ア：①③の二つが正しく，②は誤りであるため，三つではない。"
      },
      {
        type: "text",
        text: "イ：正しい記述は①③の二つなので，正答である。"
      },
      {
        type: "text",
        text: "ウ：①に加えて③も正しく，一つではない。"
      },
      {
        type: "text",
        text: "エ：正しい記述が①③にあるため，「なし」ではない。"
      }
    ],
    source_text: "教育基本法第1条，第2条本文・第2号，第3条，第4条第2項・第3項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_1-At_1"
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
        text: "第61条\n\n高等学校に、全日制の課程、定時制の課程又は通信制の課程のうち{{①}}の課程を置くときは、それぞれの課程に関する校務を{{②}}教頭を{{③}}。ただし、{{④}}当該課程に関する校務をつかさどる副校長が置かれる一の課程については、この限りでない。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "二以上",
              "分担して整理する",
              "置かなければならない",
              "命を受けて"
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
              "二以上",
              "統括してつかさどる",
              "置くことができる",
              "自己の判断により"
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
              "三以上",
              "分担して整理する",
              "置くことができる",
              "命を受けて"
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
              "三以上",
              "統括してつかさどる",
              "置かなければならない",
              "自己の判断により"
            ]
          }
        ],
        correct: false
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：四つとも原文と一致する。二以上の課程を置くときは，各課程に関する校務を分担して整理する教頭が原則として必要になる。ただし，命を受けてその課程の校務をつかさどる副校長を置いた一の課程については例外となる。"
      },
      {
        type: "text",
        text: "イ：①は一致するが，②③④が誤り。課程ごとの教頭の職務は「分担して整理する」で，単に置くことができるという任意設置ではない。例外に当たる副校長の校務は「命を受けて」つかさどると規定されている。"
      },
      {
        type: "text",
        text: "ウ：②④は一致する。①は「二以上」，③は「置かなければならない」が正しい。全日制・定時制・通信制の三つが全て揃う場合だけを対象とせず，そのうち二つ以上を置く場合にも規定が適用される。"
      },
      {
        type: "text",
        text: "エ：③は一致するが，①②④が誤り。対象となる課程数は二以上で，教頭は校務を分担して整理する。また，副校長が自己の判断で校務をつかさどることを例外の要件としているのではない。"
      }
    ],
    source_text: "e-Gov法令検索「学校教育法」第61条（令和8年6月17日施行版） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_61"
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
        text: "用語・参照先の補足（抜粋枠外）：第1項は、児童、生徒又は幼児（「児童等」）に対する指導が不適切であると認定した教諭等に対して、その指導の改善に必要な研修を実施する規定であり、この研修を「指導改善研修」という。"
      },
      {
        type: "fill_in_quote",
        text: "第25条第3項〜第5項\n\n３　{{①}}は、指導改善研修を実施するに当たり、指導改善研修を受ける者の能力、適性等に応じて、{{②}}指導改善研修に関する計画書を作成しなければならない。\n\n４　{{①}}は、指導改善研修の{{③}}において、指導改善研修を受けた者の児童等に対する指導の改善の程度に関する認定を行わなければならない。\n\n５　{{①}}は、第一項及び前項の認定に当たつては、教育委員会規則（幼保連携型認定こども園にあつては、地方公共団体の規則。次項において同じ。）で定めるところにより、教育学、医学、心理学その他の児童等に対する指導に関する専門的知識を有する者及び当該{{①}}の属する都道府県又は市町村の区域内に居住する保護者（親権を行う者及び未成年後見人をいう。）である者の{{④}}。"
      }
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: [
              "任命権者",
              "所属する学校ごとに",
              "開始時",
              "意見を聴かなければならない"
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
              "研修実施者",
              "その者ごとに",
              "開始時",
              "同意を得なければならない"
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
              "研修実施者",
              "所属する学校ごとに",
              "終了時",
              "同意を得なければならない"
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
              "任命権者",
              "その者ごとに",
              "終了時",
              "意見を聴かなければならない"
            ]
          }
        ],
        correct: true
      }
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：①④は一致する。②は「その者ごとに」、③は「終了時」が正しい。指導改善研修の計画書は所属校単位ではなく受講者ごとに作成し、改善の程度の認定は研修の終了時に行う。"
      },
      {
        type: "text",
        text: "イ：②は一致する。①は「任命権者」、③は「終了時」、④は「意見を聴かなければならない」が正しい。第5項は専門的知識を有する者及び区域内の保護者の意見を聴く手続を定めており、これらの者の同意を得ることを認定の要件としているのではない。"
      },
      {
        type: "text",
        text: "ウ：③は一致する。①は「任命権者」、②は「その者ごとに」、④は「意見を聴かなければならない」が正しい。任命権者による受講者ごとの計画作成、改善の程度の認定、意見聴取の対応を押さえる。"
      },
      {
        type: "text",
        text: "エ：四つとも原文と一致する。任命権者は能力・適性等に応じて受講者ごとの計画書を作成し、研修終了時に改善の程度を認定する。第1項の不適切な指導の認定と第4項の改善の程度の認定の双方で、第5項に定める者の意見を聴く。"
      }
    ],
    source_text: "e-Gov法令検索「教育公務員特例法」第25条第3項〜第5項、第1項（参照先） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_25"
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
QuestionSeedSync.import(exam_number: 38, questions: questions, publication_status: "draft")

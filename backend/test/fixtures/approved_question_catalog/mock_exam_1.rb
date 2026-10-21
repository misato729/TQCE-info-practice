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

fill_in_prompt = lambda do |document, section, blanks|
  "次の文章は，#{document}の「#{section}」からの抜粋である。文章中の空欄 #{blanks} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"
end

questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      {
        type: "text",
        text: "明治期の学校制度と森有礼の教育政策に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "森有礼は、内閣制度の創設に伴って初代文部大臣となった。翌年の学校制度改革では、学校種別ごとの規定を一つの教育令にまとめ、小学校から大学までを同じ法令によって整備した。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "森有礼は、国家を支える教員の養成を重視し、師範学校に軍隊式の教育を取り入れた。また、小学校教育の普及のため、公立小学校では授業料を徴収しないことを原則とした。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "森有礼は、1885（明治18）年に初代文部大臣となり、翌年に帝国大学令、師範学校令、小学校令及び中学校令を公布して、学校種別ごとの制度整備を進めた。",
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "森有礼の下で公布された小学校令は、小学校を尋常科と高等科に分けた。保護者は児童に高等科を卒業させる義務を負うものとされ、高等科までを就学義務の対象に位置付けた。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：初代文部大臣への就任は適切ですが、法令の構成が誤りです。1886年には、小学校令・中学校令・師範学校令・帝国大学令という学校種別ごとの法令が公布されました。",
      },
      {
        type: "text",
        text: "イ：師範学校の軍隊式教育は適切ですが、授業料の扱いが誤りです。森文相は、公立小学校では授業料を徴収することを原則としました。",
      },
      {
        type: "text",
        text: "ウ：適切です。1885年の内閣制度創設に伴う就任と、1886年の四つの学校令による制度整備を正しく対応させています。",
      },
      {
        type: "text",
        text: "エ：尋常科と高等科の区分は適切ですが、就学義務の範囲が誤りです。就学義務は尋常科の卒業までとされ、高等科までではありませんでした。",
      },
    ],
    source_text: "文部科学省『学制百年史』第一編第二章第一節「一 森文相と諸学校令の公布」―初代文部大臣の任命／森文相の教育政策／諸学校令の公布 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1317609.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("デューイ（Dewey, J.）の教育思想と教育実践に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "シカゴ大学に実験学校を設け、子供の経験と探究を重視する教育を実践した。また、『民主主義と教育』では、教育と民主的社会との関係を論じた。", true),
      text_choice.call("イ", "幼児の自己活動と遊びを教育の中心に置き、幼稚園を創設するとともに、教育遊具である恩物を考案した。"),
      text_choice.call("ウ", "観念の結合による道徳的品性の形成を教育の目的とし、明瞭・連合・系統・方法という教授段階を中心とする授業を提唱した。"),
      text_choice.call("エ", "感覚教育のための教具を用意し、教師が直接教え込むのではなく、子供が自発的に教具を操作することで知的独立を獲得する教育法を創始した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。デューイはシカゴ大学に実験学校を設け、子供の経験に基づく活動と探究を重視しました。『民主主義と教育』も代表作です。"),
      text_block.call("イ：幼稚園の創設と恩物の考案はフレーベルの業績であり、デューイのものではありません。"),
      text_block.call("ウ：道徳的品性の形成と、明瞭・連合・系統・方法の四段階はヘルバルト本人の教授論に対応します。後世のヘルバルト派が発展させた五段階教授法とは区別します。"),
      text_block.call("エ：感覚教育のための教具を用意し、子供の自発的な操作による自己教育を援助する説明は、モンテッソーリの教育法に対応します。"),
    ],
    source_text: "白石崇人『資料から考える教育原理』（広島文教女子大学、2017年）第13章「教育はどのような社会を生み出し得るか？―デューイの教育思想―」152〜162頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n白石崇人『資料から考える教育原理』第11章（フレーベル）・第12章（モンテッソーリ）128〜151頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n奥山和夫「情意的学習法の理論とその試み」『共栄学園短期大学研究紀要』第16号（2000年）2頁・表1「ヘルバルト派の形式的教授段階論」 | https://kyoei.repo.nii.ac.jp/record/484/files/KJ00000173172.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「教育基本法」（平成18年法律第120号）", "第2条第3号", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}、男女の平等、{{②}}を重んずるとともに、{{③}}に基づき、{{④}}社会の形成に参画し、その発展に寄与する態度を養うこと。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["正義と責任", "相互の敬愛と協力", "公共の精神", "積極的に"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["正義と責任", "自他の敬愛と協力", "公共の精神", "主体的に"],
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["権利と義務", "自他の敬愛と協力", "公共の福祉", "積極的に"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["権利と義務", "相互の敬愛と協力", "公共の福祉", "主体的に"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "イ：正しい。第2条第3号は、正義と責任、男女の平等、自他の敬愛と協力を重んじ、公共の精神に基づく主体的な社会参画を目標にする。権利と義務の関係を一般に否定する問題ではなく、この号の社会参画の位置付けと法定語句を比較する。",
      },
      {
        type: "text",
        text: "ア：②は「相互の敬愛と協力」ではなく「自他の敬愛と協力」、④は「積極的に」ではなく「主体的に」である。",
      },
      {
        type: "text",
        text: "ウ：①は「権利と義務」ではなく「正義と責任」、③は「公共の福祉」ではなく「公共の精神」、④は「積極的に」ではなく「主体的に」である。",
      },
      {
        type: "text",
        text: "エ：①は「権利と義務」ではなく「正義と責任」、②は「相互の敬愛と協力」ではなく「自他の敬愛と協力」、③は「公共の福祉」ではなく「公共の精神」である。",
      },
    ],
    source_text: "e-Gov法令検索『教育基本法』第2条第3号（原文を抜粋し空欄化して作成） | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第50条　高等学校は、{{①}}における教育の基礎の上に、{{②}}の発達及び{{③}}に応じて、{{④}}を施すことを目的とする。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["小学校", "人格", "適性", "高度な普通教育及び専門教育"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["中学校", "心身", "適性", "広い普通教育及び専門教育"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["小学校", "人格", "進路", "広い普通教育及び専門教育"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["中学校", "心身", "進路", "高度な普通教育及び専門教育"],
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "エ：正しい。第50条は、中学校教育の基礎の上に、心身の発達及び進路に応じ、高度な普通教育及び専門教育を施すことを高校の目的とする。",
      },
      {
        type: "text",
        text: "ア：①は「小学校」ではなく「中学校」、②は「人格」ではなく「心身」、③は「適性」ではなく「進路」である。",
      },
      {
        type: "text",
        text: "イ：③は「適性」ではなく「進路」、④は「広い普通教育及び専門教育」ではなく「高度な普通教育及び専門教育」である。",
      },
      {
        type: "text",
        text: "ウ：①は「小学校」ではなく「中学校」、②は「人格」ではなく「心身」、④は「広い普通教育及び専門教育」ではなく「高度な普通教育及び専門教育」である。",
      },
    ],
    source_text: "e-Gov法令検索『学校教育法』第50条（原文を抜粋し空欄化して作成） | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037",
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
        text: "第21条　教育公務員は、その{{①}}を遂行するために、{{②}}{{③}}と{{④}}に努めなければならない。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["職責", "絶えず", "研究", "修養"],
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["職務", "絶えず", "研修", "修養"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["職責", "計画的に", "研修", "実践"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["職務", "計画的に", "研究", "実践"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：正しい。第21条第1項の責務は、その職責を遂行するため、絶えず研究と修養に努めることである。研修・実践の重要性の是非ではなく、本人の研究修養の責務を定めた条文の語句を比較する。",
      },
      {
        type: "text",
        text: "イ：①は「職務」ではなく「職責」、③は「研修」ではなく「研究」である。",
      },
      {
        type: "text",
        text: "ウ：②は「計画的に」ではなく「絶えず」、③は「研修」ではなく「研究」、④は「実践」ではなく「修養」である。",
      },
      {
        type: "text",
        text: "エ：①は「職務」ではなく「職責」、②は「計画的に」ではなく「絶えず」、④は「実践」ではなく「修養」である。",
      },
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第21条第1項・第22条（原文を抜粋し空欄化して作成） | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "{{①}}の育成を図るため，各学校において必要な{{②}}を整えるとともに，{{③}}を要としつつ各教科・科目等の特質に応じて，生徒の{{④}}を充実すること。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["言語能力", "情報環境", "国語科", "表現活動"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["読解力", "情報環境", "外国語科", "言語活動"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["言語能力", "言語環境", "国語科", "言語活動"],
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["読解力", "言語環境", "外国語科", "表現活動"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ウ：正しい。言語能力の育成のため、言語環境を整え、国語科を要に各教科・科目等で言語活動を充実する規定である。",
      },
      {
        type: "text",
        text: "ア：②は「情報環境」ではなく「言語環境」、④は「表現活動」ではなく「言語活動」である。",
      },
      {
        type: "text",
        text: "イ：①は「読解力」ではなく「言語能力」、②は「情報環境」ではなく「言語環境」、③は「外国語科」ではなく「国語科」である。",
      },
      {
        type: "text",
        text: "エ：①は「読解力」ではなく「言語能力」、③は「外国語科」ではなく「国語科」、④は「表現活動」ではなく「言語活動」である。",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第3款1(2)（原文を抜粋し空欄化して作成） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第5款 生徒の発達の支援 1 生徒の発達を支える指導の充実", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "生徒が，{{①}}を実感しながら，{{②}}を形成し，有意義で充実した学校生活を送る中で，現在及び将来における{{③}}を図っていくことができるよう，生徒理解を深め，学習指導と関連付けながら，{{④}}を図ること。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習の成果", "協働的な学習集団", "進路実現", "教育相談の充実"]),
      fill_in_choice.call("イ", ["自己の存在感", "よりよい人間関係", "自己実現", "生徒指導の充実"], true),
      fill_in_choice.call("ウ", ["自己有用感", "望ましい集団規律", "社会的自立", "進路指導の充実"]),
      fill_in_choice.call("エ", ["所属感", "相互扶助的な関係", "人格の完成", "学習評価の充実"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。生徒が『自己の存在感』を実感しながら『よりよい人間関係』を形成し、現在及び将来の『自己実現』を図れるよう、生徒理解を深め、学習指導と関連付けて『生徒指導の充実』を図ります。ア、ウ、エはいずれも関連し得る語を含みますが、この連続した原文の組合せではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第5款1(2) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）の「第3章 総合的な探究の時間の目標 2 目標の趣旨」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "総合的な探究の時間において，各教科・科目等における見方・考え方を{{①}}に活用するということは，社会で生きて働く資質・能力を育成する上で，{{②}}と{{③}}を{{④}}することが重要であることを意味している。系統的に構造化された内容を，それぞれの特質に応じた見方・考え方を働かせて学ぶ{{②}}と，総合的な探究の時間において，各教科・科目等で育成された見方・考え方を，実社会や実生活における複雑な文脈の中に存在する問題において，{{①}}に活用する{{③}}の両方が重要なのである。このような{{②}}と{{③}}の両方が示されていることは，我が国の教育課程の大きな特色であり，今回の改訂では改めてその趣旨を明示している。",
      },
    ],
    choices: [
      {
        label: "ア",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["横断的・総合的", "教科・科目等の学習", "教科・科目等横断的な学習", "一体化"],
          },
        ],
      },
      {
        label: "イ",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["総合的・統合的", "教科・科目等横断的な学習", "教科・科目等の学習", "一体化"],
          },
        ],
      },
      {
        label: "ウ",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["横断的・総合的", "教科・科目等横断的な学習", "教科・科目等の学習", "往還"],
          },
        ],
      },
      {
        label: "エ",
        correct: true,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["総合的・統合的", "教科・科目等の学習", "教科・科目等横断的な学習", "往還"],
          },
        ],
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "エ：正しい。教科・科目等の学習では系統的に構造化された内容を学び、総合的な探究の時間では、そこで育成された見方・考え方を実社会・実生活の問題に総合的・統合的に活用する。どちらかに一本化するのではなく、二つの学習を往還することが重要である。②③が繰り返される箇所も、それぞれ同じ学習を指している。",
      },
      {
        type: "text",
        text: "ア：①は「横断的・総合的」ではなく「総合的・統合的」、④は「一体化」ではなく「往還」である。",
      },
      {
        type: "text",
        text: "イ：②は「教科・科目等横断的な学習」ではなく「教科・科目等の学習」、③は「教科・科目等の学習」ではなく「教科・科目等横断的な学習」、④は「一体化」ではなく「往還」である。",
      },
      {
        type: "text",
        text: "ウ：①は「横断的・総合的」ではなく「総合的・統合的」、②は「教科・科目等横断的な学習」ではなく「教科・科目等の学習」、③は「教科・科目等の学習」ではなく「教科・科目等横断的な学習」である。",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』第3章2(1)末尾（PDF21頁／冊子13頁、原文を抜粋し空欄化して作成） | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=21",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第1章 総則 第1款 高等学校教育の基本と教育課程の役割", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "学校における道徳教育は，{{①}}に関する教育を{{②}}を通じて行うことによりその充実を図るものとし，各教科に属する科目（以下「各教科・科目」という。），総合的な探究の時間及び特別活動（以下「各教科・科目等」という。）のそれぞれの特質に応じて，{{③}}を行うこと。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間としての在り方生き方", "学校の教育活動全体", "適切な指導"], true),
      fill_in_choice.call("イ", ["人間としての在り方生き方", "公民科及び特別活動", "中核的な指導"]),
      fill_in_choice.call("ウ", ["道徳的諸価値", "学校の教育活動全体", "中核的な指導"]),
      fill_in_choice.call("エ", ["道徳的諸価値", "公民科及び特別活動", "適切な指導"]),
    ],
    explanation_blocks: [
      text_block.call("アが正答です。①は「人間としての在り方生き方」、②は「学校の教育活動全体」、③は「適切な指導」です。「それぞれ」は、各教科に属する科目、総合的な探究の時間及び特別活動を指します。高等学校の道徳教育は、学校の教育活動全体を通じて行い、これらの特質に応じた指導によって充実させる位置付けです。"),
      text_block.call("イは②③が誤りです。公民科と特別活動は重要な指導の場ですが、道徳教育を行う範囲を示す②の原語は「学校の教育活動全体」です。また、各教科・科目等について一律に「中核的な指導」とするのではなく、それぞれの特質に応じて「適切な指導」を行います。"),
      text_block.call("ウは①③が誤りです。「道徳的諸価値」は、第7款2で中学校までの学習等を通じて深めた理解として扱われます。この抜粋で道徳教育の充実を図る教育を示す①は「人間としての在り方生き方」であり、③は「適切な指導」です。"),
      text_block.call("エは①②が誤りです。①は「人間としての在り方生き方」、②は「学校の教育活動全体」です。第7款1は、公民科の「公共」及び「倫理」並びに特別活動を中核的な指導の場面としていますが、それは道徳教育を行う範囲全体と同じ意味ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第1款2(2)第1段落（PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21\n文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款1・2（中核的な指導の場面及び道徳的諸価値、PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 特別活動編」（平成30年7月文部科学省）の「第2章 特別活動の目標 第1節 特別活動の目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "「集団や自己の生活上の課題を解決する」とは，様々な集団活動を通して集団や個人の課題を見いだし，解決するための方法や内容を話し合って，{{①}}をするとともに，それを協働して成し遂げたり強い意志をもって実現したりする生徒の活動内容や学習過程を示したものである。\n\n「{{②}}」ことを方法原理としている特別活動においては，ホームルームや学校の生活には自分たちで解決できる課題があること，その課題を自分たちで見いだすことが必要であること，単に話し合えば解決するのではなく，その後の実践に取り組み，{{③}}，{{④}}に向かうことなどが大切であることに気付いたり，その方法や手順を体得できるようにしたりすることが求められる。",
      },
    ],
    choices: [
      {
        label: "ア",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["合意形成や意思決定", "なすことによって学ぶ", "成果を数量的に測定して到達度を確かめ", "活動計画の具体化"],
          },
        ],
      },
      {
        label: "イ",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["課題設定や情報収集", "発見によって学ぶ", "振り返って成果や課題を明らかにし", "活動計画の具体化"],
          },
        ],
      },
      {
        label: "ウ",
        correct: true,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["合意形成や意思決定", "なすことによって学ぶ", "振り返って成果や課題を明らかにし", "次なる課題解決"],
          },
        ],
      },
      {
        label: "エ",
        correct: false,
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["課題設定や情報収集", "発見によって学ぶ", "成果を数量的に測定して到達度を確かめ", "次なる課題解決"],
          },
        ],
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ウ：正しい。特別活動は「なすことによって学ぶ」を方法原理とし、課題を見いだして話し合い、合意形成や意思決定を行い、実践し、振り返って次の課題解決へつなぐ。話合いだけで完結せず、自分たちによる実践と省察を含む学習過程である。",
      },
      {
        type: "text",
        text: "ア：③は「成果を数量的に測定して到達度を確かめ」ではなく「振り返って成果や課題を明らかにし」、④は「活動計画の具体化」ではなく「次なる課題解決」である。",
      },
      {
        type: "text",
        text: "イ：①は「課題設定や情報収集」ではなく「合意形成や意思決定」、②は「発見によって学ぶ」ではなく「なすことによって学ぶ」、④は「活動計画の具体化」ではなく「次なる課題解決」である。",
      },
      {
        type: "text",
        text: "エ：①は「課題設定や情報収集」ではなく「合意形成や意思決定」、②は「発見によって学ぶ」ではなく「なすことによって学ぶ」、③は「成果を数量的に測定して到達度を確かめ」ではなく「振り返って成果や課題を明らかにし」である。",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 特別活動編』第2章第1節1(3)④「集団や自己の生活上の課題を解決する」（PDF24頁／冊子16頁、原文を抜粋し空欄化して作成） | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=24",
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
        text: "学校教育の目的は、「人格の完成を目指し、平和で民主的な国家及び社会の形成者として必要な資質を備えた心身ともに健康な国民の育成」（教育基本法第1条）を期することであり、また、「個人の価値を尊重して、その能力を伸ばし、創造性を培い、自主及び自律の精神を養う」（同法第2条第2号）ことが目標の一つとして掲げられています。この学校教育の目的や目標達成に寄与する生徒指導を定義すると、次のようになります。\n\n生徒指導の定義\n\n生徒指導とは、児童生徒が、{{①}}の中で自分らしく生きることができる存在へと、{{②}}に成長や発達する過程を支える教育活動のことである。なお、生徒指導上の課題に対応するために、必要に応じて{{③}}を行う。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["社会", "意図的・計画的", "指導や評価"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["社会", "自発的・主体的", "指導や援助"],
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["集団", "自発的・主体的", "指導や評価"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["集団", "意図的・計画的", "指導や援助"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "イ：イが原文と一致します。児童生徒が社会の中で自分らしく生き、自発的・主体的に成長・発達する過程を支え、課題への対応として必要に応じて指導や援助を行います。",
      },
      {
        type: "text",
        text: "ア：①は一致します。②は教職員の計画的な働きかけと児童生徒の成長の在り方を取り違え、③は『指導や援助』を『指導や評価』へ置き換えています。評価も教育では重要ですが、この定義の課題対応の組合せとは異なります。",
      },
      {
        type: "text",
        text: "ウ：②は一致しますが、①は『社会』、③は『指導や援助』です。学級等の集団内部に対象を限る定義ではありません。",
      },
      {
        type: "text",
        text: "エ：③は一致しますが、①と②が異なります。原典は社会の中での自発的・主体的な成長を述べており、教師の意図的・計画的な働きかけの重要性を否定する趣旨ではありません。",
      },
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第1章1.1.1(1)「生徒指導の定義」、本文12頁（原文を抜粋し空欄化して作成） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=15",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      {
        type: "text",
        text: "次の①～④は、LD、ADHD及びASDのある生徒の教育的ニーズと指導に関する記述である。適切なものの組合せを、下のア～エの中から一つ選んで記号で答えなさい。\n① LDで読み書きに困難がある場合、音と文字の対応や語のまとまりの理解を支え、必要に応じて行間の調整、分かち書き、文字入力などの手段の活用を指導する。\n② ADHDで注意の持続が難しい場合、注目すべき箇所を分かりやすくし、指示を段階に分けて示すなどして、自分に合う注意集中の方法を身に付けられるようにする。\n③ ASDで周囲の状況や相手の意図を捉えることが難しい場合、場面の状況や行動の意味を具体的に示し、相手とのやり取りの仕方を理解できるようにする。\n④ LDの『推論する能力』は、数の概念を理解して暗算や筆算を行う能力を指す。その状態を把握する際は、数の概念の理解と計算の正確さを中心に整理する。",
      },
    ],
    choices: [
      text_choice.call("ア", "①・②・④"),
      text_choice.call("イ", "①・③・④"),
      text_choice.call("ウ", "②・③・④"),
      text_choice.call("エ", "①・②・③", true),
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "①〜③が適切、④が不適切で、正答はエです。①は読み書きの困難に応じた指導・代替手段、②は注意の持続と自己調整を支える指導、③は状況・他者の意図の理解を支える指導です。診断名だけで一律に適用するのではなく、本人の状態に応じて検討します。",
      },
      {
        type: "text",
        text: "④：説明しているのは主に『計算する能力』です。『推論する能力』は、事実を基に結果を予測したり、結果から原因を推し量ったりする能力を指します。暗算・筆算や数の概念と区別して把握します。",
      },
      {
        type: "text",
        text: "ア：④が不適切で③を欠くため、正しい組合せではありません。",
      },
      {
        type: "text",
        text: "イ：④が不適切で②を欠くため、正しい組合せではありません。",
      },
      {
        type: "text",
        text: "ウ：④が不適切で①を欠くため、正しい組合せではありません。",
      },
      {
        type: "text",
        text: "エ：適切です。①②③がいずれも適切であり、この三つの組合せが正答です。",
      },
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』（令和3年6月）第3編Ⅸ「学習障害」通級による指導及び困難を示す領域、本文299〜301頁 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_13.pdf#page=15\n文部科学省『障害のある子供の教育支援の手引』（令和3年6月）第3編Ⅹ「注意欠陥多動性障害」特別な指導内容・合理的配慮、本文312〜314頁 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_14.pdf#page=7\n文部科学省『障害のある子供の教育支援の手引』（令和3年6月）第3編Ⅶ「自閉症」障害の状態等の把握及び特別な指導内容、本文246〜250頁 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_11.pdf#page=4",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ピアジェ（Piaget, J.）の認知発達理論における形式的操作期の思考に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "外界への働きかけを感覚と運動によって調整し、目の前から物が見えなくなっても存在し続けることを理解するが、仮説を立てて複数の条件を比較することはできない段階である。"),
      text_choice.call("イ", "言語やイメージによる象徴的な表象が可能になる一方、対象の一つの側面に注意が集中しやすく、操作を逆方向にたどることが困難な段階である。"),
      text_choice.call("ウ", "現実に観察された事実だけでなく、起こり得る可能性を組み合わせて仮説を立て、他の条件を一定に保ちながら一つの変数を操作して、その仮説を体系的に検証できる段階である。", true),
      text_choice.call("エ", "保存、分類、系列化などの論理的操作が可能になるが、その操作は具体的な事物や実際に経験できる状況に強く依存している段階である。"),
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：感覚と運動によって対象を捉え、対象の永続性を獲得していく感覚運動期の説明で、形式的操作期とは異なります。",
      },
      {
        type: "text",
        text: "イ：象徴的な表象、中心化や不可逆性は、主に前操作期の特徴です。",
      },
      {
        type: "text",
        text: "ウ：適切です。形式的操作期には、可能な仮説を考え、その論理的帰結を導き、条件を統制して体系的に検証する思考が可能になります。到達時期を個々人へ機械的に当てはめる趣旨ではありません。",
      },
      {
        type: "text",
        text: "エ：具体的な対象や経験への依存を残す具体的操作期の説明です。形式的操作期では、与えられた前提や命題間の関係も推論の対象になります。",
      },
    ],
    source_text: "中垣啓「ピアジェ発達段階論の意義と射程」『発達心理学研究』22巻4号、2011年、372〜373頁「形式的操作期の知的新しさ」（PDF4〜5頁） | https://www.jstage.jst.go.jp/article/jjdp/22/4/22_KJ00007731435/_pdf/-char/ja#page=4\n松山彩香「【学者紹介】Jean Piaget」東京大学山内研究室、2014年10月3日「認知発達段階」「自己中心性」 | https://fukutake.iii.u-tokyo.ac.jp/ylab/2014/10/post-504.html",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ジグソー法に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "同じ部分資料を担当する学習者がホームグループをつくって理解を深める。その後、異なる部分の担当者が集まるエキスパートグループで各部分を説明し、全体の理解を組み立てる。",
          },
        ],
        correct: true,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "元のグループで分担した同じ部分を担当する者同士がエキスパートグループをつくる。担当部分の要点について話し合い、元のグループで説明する準備を行う。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "各成員が元のグループへ戻り、担当部分を説明し合う。異なる情報をもつ者同士が互いに質問することを通して、それぞれの部分と課題全体との関係を考える。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "各成員の担当が全体の理解に必要になるように教材や課題を構成する。教師はグループの学習過程を観察し、特定の成員の発言に偏る等の状況に必要な支援を行う。",
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：適切ではありません。同じ部分を担当する者が理解を深めるのがエキスパートグループ、異なる部分の担当者が説明し合うのが元のジグソー（ホーム）グループです。二つのグループの役割が逆です。",
      },
      {
        type: "text",
        text: "イ：適切です。同じ担当者が理解を深め、説明を準備するエキスパート活動を述べています。",
      },
      {
        type: "text",
        text: "ウ：適切です。異なる担当者が説明・質問し、部分の情報を関連付けて全体を理解する活動です。",
      },
      {
        type: "text",
        text: "エ：適切です。相互依存と成員の責任が生じる課題構成及び、学習過程を観察する教師の支援を述べています。",
      },
    ],
    source_text: "教育環境デザイン研究所CoREF「知識構成型ジグソー法」STEP2・3（共通するエキスパート活動・異なる担当者間の説明と統合） | https://ni-coref.or.jp/archives/5515\nジグソー法公式サイト「The Jigsaw Classroom」『Jigsaw in 10 Easy Steps』STEP6〜9（原型のグループ構成と教師の支援） | https://www.jigsaw.org/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示されたICT活用に関する記述である。最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "ICTを学校教育の基盤的なツールとして用い、教育実践と組み合わせる。その際のハイブリッド化とは、遠隔・オンライン教育における同時双方向の授業と録画教材による学習とを組み合わせることを指す。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "AI技術が高度に発達する時代には、ICTによる学習を充実させる。それに伴って教師による対面指導や子供同士の学び合い、地域社会での体験活動の重要性は、相対的に低下していくと捉える。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "ICTは授業改善を進めるための基盤的なツールであり、端末を日常的に使うことを重視する。ICTを活用する授業の教育的効果は、端末を使った時間の増加を、資質・能力の向上を表す指標として判定する。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "ICTを学校教育に必要不可欠な基盤的なツールとして最大限活用する。その活用自体を目的とはせず、対面指導等のこれまでの実践と適切に組み合わせ、教育の質の向上につなげる。",
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：基盤的なツールという位置付けは適切ですが、ハイブリッド化の説明が異なります。この箇所では、対面指導と家庭・地域社会と連携した遠隔・オンライン教育とを使いこなすことを示しています。",
      },
      {
        type: "text",
        text: "イ：重要性の変化が逆です。答申は、AI技術が高度に発達する時代にこそ、対面指導、子供同士の学び合い、地域での体験活動の重要性が一層高まると述べています。",
      },
      {
        type: "text",
        text: "ウ：日常的な活用は重要ですが、利用時間の増加と資質・能力の向上を同一視しています。活用は手段であり、教科等で育成する資質・能力や学習の質に照らして効果を捉える必要があります。",
      },
      {
        type: "text",
        text: "エ：適切です。必要不可欠なツールとしての最大限の活用と、活用そのものを目的にしないこと、これまでの実践との最適な組合せをともに述べています。",
      },
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』（令和3年1月26日）第Ⅰ部4(3)、本文26〜27頁 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=31",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第1款 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "情報に関する{{①}}を働かせ，情報技術を活用して{{②}}を行う学習活動を通して，{{②}}に向けて情報と情報技術を{{③}}に活用し，情報社会に{{④}}するための資質・能力を次のとおり育成することを目指す。\n\n（1）情報と情報技術及びこれらを活用して問題を発見・解決する方法について理解を深め技能を習得するとともに，情報社会と人との関わりについての理解を深めるようにする。\n\n（2）様々な事象を情報とその結び付きとして捉え，{{②}}に向けて情報と情報技術を{{③}}に活用する力を養う。\n\n（3）情報と情報技術を適切に活用するとともに，情報社会に{{④}}する態度を養う。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["科学的な見方・考え方", "情報の収集・発信", "安全かつ効率的", "主体的に参画"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["科学的な見方・考え方", "問題の発見・解決", "適切かつ効果的", "主体的に参画"],
          },
        ],
        correct: true,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["数学的な見方・考え方", "問題の発見・解決", "適切かつ効果的", "責任をもって貢献"],
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["数学的な見方・考え方", "情報の収集・発信", "安全かつ効率的", "責任をもって貢献"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "アは，②の「情報の収集・発信」が異なる。学習活動を問題の発見・解決として位置付け，個別の情報収集・発信だけに置き換えない。③の「安全かつ効率的」が異なる。目標が定める活用の観点は適切さと効果である。",
      },
      {
        type: "text",
        text: "イが原文と一致する。①は「科学的な見方・考え方」，②は「問題の発見・解決」，③は「適切かつ効果的」，④は「主体的に参画」となる。",
      },
      {
        type: "text",
        text: "ウは，①の「数学的な見方・考え方」が異なる。情報科では情報に関する科学的な見方・考え方を働かせる。④の「責任をもって貢献」が異なる。情報社会との関わりは主体的に参画することとして示される。",
      },
      {
        type: "text",
        text: "エは，①の「数学的な見方・考え方」が異なる。情報科では情報に関する科学的な見方・考え方を働かせる。②の「情報の収集・発信」が異なる。学習活動を問題の発見・解決として位置付け，個別の情報収集・発信だけに置き換えない。③の「安全かつ効率的」が異なる。目標が定める活用の観点は適切さと効果である。④の「責任をもって貢献」が異なる。情報社会との関わりは主体的に参画することとして示される。",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第1款（原文を抜粋し空欄化して作成） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）", "第3章 主として専門学科において開設される各教科 第7節 情報 目標", "{{①}} ～ {{④}}"),
      },
      {
        type: "fill_in_quote",
        text: "情報に関する科学的な見方・考え方を働かせ，{{①}}な学習活動を行うことなどを通して，情報産業を通じ，地域産業をはじめ情報社会の{{②}}で持続的な発展を担う職業人として必要な資質・能力を次のとおり育成することを目指す。\n(1) 情報の各分野について体系的・系統的に理解するとともに，関連する技術を身に付けるようにする。\n(2) 情報産業に関する課題を発見し，職業人に求められる{{③}}を踏まえ合理的かつ創造的に解決する力を養う。\n(3) 職業人として必要な豊かな人間性を育み，よりよい社会の構築を目指して自ら学び，情報産業の創造と発展に{{④}}に取り組む態度を養う。",
      },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["実践的・体験的", "健全", "使命感", "主体的"],
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["探究的・協働的", "豊か", "倫理観", "主体的かつ協働的"],
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["実践的・体験的", "健全", "倫理観", "主体的かつ協働的"],
          },
        ],
        correct: true,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "fill_in_choice",
            cells: ["探究的・協働的", "豊か", "使命感", "主体的"],
          },
        ],
        correct: false,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ウ：全て原文と一致する。専門教科情報科の教科目標は、実践的・体験的な学習活動、情報社会の健全で持続的な発展、職業人に求められる倫理観、主体的かつ協働的に取り組む態度を対応させている。",
      },
      {
        type: "text",
        text: "ア：①②は一致する。③は『倫理観』、④は『主体的かつ協働的』である。使命感と倫理観を同じ語とせず、自ら取り組むことと他者と協働することの双方を含む目標を確認する。",
      },
      {
        type: "text",
        text: "イ：③④は一致する。①は『実践的・体験的』、②は『健全』である。探究や協働を一般に否定するのではなく、この教科目標が示す学習活動の性格と発展の表現を問う。",
      },
      {
        type: "text",
        text: "エ：四つとも異なる。実践的・体験的な学習を通し、健全で持続的な発展を担い、倫理観を踏まえて課題を解決し、主体的かつ協働的に取り組むという組合せになる。",
      },
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第3章第7節『情報』第1款『目標』、印刷407頁（PDF409頁）、原文を抜粋し空欄化して作成 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=409",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      {
        type: "fill_in_text",
        text: fill_in_prompt.call("「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）", "第1部 各学科に共通する教科「情報」 第1章 総説 第3節 情報教育の中での共通教科情報科の位置付け 2 3観点による情報活用能力の整理", "{{①}} ～ {{③}}"),
      },
      {
        type: "fill_in_quote",
        text: "共通教科情報科の目標や内容を正しく理解し，授業を通して確実に実現するためには，小・中・高等学校を通して体系的・系統的に行われる情報教育の目標について正しく理解する必要がある。\n平成11年改訂の高等学校学習指導要領において情報科を新設するに当たって，「情報化の進展に対応した初等中等教育における情報教育の推進等に関する調査研究協力者会議」は，平成9年10月の第1次報告「体系的な情報教育の実施に向けて」（以下，「第1次報告」という。）において，情報教育の目標の観点を「{{①}}」，「{{②}}」，「{{③}}」の三つに整理している。平成21年改訂の高等学校学習指導要領では，情報教育の目標の観点として引き続きこの3観点を位置付けている。今回の改訂においては，これを資質・能力の三つの柱に沿って再整理した。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["情報活用の実践力", "情報の科学的な理解", "情報社会に参画する態度"], true),
      fill_in_choice.call("イ", ["情報機器の操作力", "情報の技術的な理解", "情報社会を管理する能力"]),
      fill_in_choice.call("ウ", ["問題発見・解決能力", "情報の批判的な理解", "情報社会を評価する態度"]),
      fill_in_choice.call("エ", ["情報収集の実践力", "情報の倫理的な理解", "情報産業に従事する態度"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。情報教育の目標は「情報活用の実践力」「情報の科学的な理解」「情報社会に参画する態度」の3観点で整理され、今回の改訂では同じ情報活用能力を資質・能力の三つの柱に沿って再整理しています。イの「情報機器の操作力」等、ウの「問題発見・解決能力」等、エの「情報収集の実践力」等は、3観点の正式な名称ではありません。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部第1章第3節2「3観点による情報活用能力の整理」 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次のプログラムは、二つの正の整数の最大公約数をユークリッドの互除法で求めるものである。実行終了時に表示される a と count の組合せとして正しいものを選びなさい。なお、「%」は整数除算の余りを表す。"),
      {
        type: "code",
        title: "最大公約数を求めるプログラム",
        code: "a = 1071\nb = 462\ncount = 0\n\nb != 0 の間繰り返す:\n  r = a % b\n  a = b\n  b = r\n  count = count + 1\n\na と count を表示する",
      },
    ],
    choices: [
      text_choice.call("ア", "a = 7、count = 4"),
      text_choice.call("イ", "a = 21、count = 2"),
      text_choice.call("ウ", "a = 147、count = 3"),
      text_choice.call("エ", "a = 21、count = 3", true),
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "エが正しい組合せです。余りは147、21、0と変わり、3回目でbが0になります。この時点のaは21です。",
      },
      {
        type: "code",
        title: "変数の変化",
        code: "1回目: 1071 % 462 = 147 → a=462, b=147, count=1\n2回目: 462 % 147 = 21   → a=147, b=21,  count=2\n3回目: 147 % 21 = 0     → a=21,  b=0,   count=3",
      },
      {
        type: "text",
        text: "ア：7は二つの数の公約数ですが、最大公約数は21です。また、bが0になった後は反復しないため、countは4になりません。",
      },
      {
        type: "text",
        text: "イ：2回目の終了時点ではa=147、b=21、count=2です。aが21になるのは3回目なので、a=21とcount=2は同じ時点の値ではありません。",
      },
      {
        type: "text",
        text: "ウ：a=147は2回目終了時の値です。3回目にはaが21へ更新されるため、終了時のa=147という記述は誤りです。",
      },
      {
        type: "text",
        text: "エ：3回の反復の後、a=21、b=0となり、count=3で終了するため正しい。",
      },
    ],
    source_text: "文部科学省『高等学校情報科「情報I」教員研修用教材』第3章 コンピュータとプログラミング | https://www.mext.go.jp/a_menu/shotou/zyouhou/detail/1416756.htm",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("ある量的データについて、第1四分位数 Q1=18、第3四分位数 Q3=30 であった。外れ値の候補を「Q1−1.5×IQRより小さい値、またはQ3＋1.5×IQRより大きい値」（IQRは四分位範囲）とする。この基準による下側境界、上側境界、および外れ値の候補の組合せとして正しいものを選びなさい。"),
      {
        type: "table",
        headers: ["観測値"],
        rows: [
          ["9"],
          ["18"],
          ["18"],
          ["22"],
          ["24"],
          ["26"],
          ["30"],
          ["30"],
          ["52"],
        ],
      },
    ],
    choices: [
      text_choice.call("ア", "下側境界6、上側境界42、外れ値の候補は52"),
      text_choice.call("イ", "下側境界0、上側境界48、外れ値の候補は52", true),
      text_choice.call("ウ", "下側境界0、上側境界48、外れ値の候補は9と52"),
      text_choice.call("エ", "下側境界12、上側境界36、外れ値の候補は9と52"),
    ],
    explanation_blocks: [
      text_block.call("イが適切です。IQR=Q3−Q1=30−18=12なので、下側境界は18−1.5×12=0、上側境界は30＋1.5×12=48です。観測値のうち48より大きい52だけが外れ値の候補であり、9は境界内です。アは、IQRを1.5倍せず、Q1−IQRとQ3＋IQRを境界としている点が誤りです。ウは境界の計算は正しいものの、0以上48以下の範囲にある9まで外れ値の候補としている点が誤りです。エは、IQRの0.5倍を用いた境界となっており、指定された1.5倍という基準を満たしません。"),
      {
        type: "code",
        title: "境界と候補の確認",
        code: "IQR = 30 - 18 = 12\n下側境界 = 18 - 1.5 × 12 = 0\n上側境界 = 30 + 1.5 × 12 = 48\n0未満の観測値: なし\n48を超える観測値: 52",
      },
      text_block.call("外れ値の候補であることと、誤ったデータであることは同じではありません。候補を機械的に削除せず、入力誤りか、意味のある極端値かを確認することも重要です。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章 学習22（1）「量的データと質的データ」・図表2「箱ひげ図（外れ値を表示）」（185頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=33",
  },
]

unless questions.size == 20 && questions.map { |question| question[:question_number] } == (1..20).to_a
  raise "模擬試験1は問1から問20までの20問で構成してください"
end

QuestionSeedSync.import(exam_number: 1, questions: questions, publication_status: "published")

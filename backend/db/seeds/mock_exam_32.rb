text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end

fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験32（承認済みの問1・2及び問6〜10。全20問がそろうまで下書き）
# 教育史の事実を根拠資料で確認した独自の記述問題。過去問の本文・選択肢の転記ではない。
# 承認正本：document/模試31〜35_問1〜2草案_2026-10-14.md
# 問6〜10承認正本：document/模試31〜35_問6〜10草案_2026-10-14.md
# 文部科学省の公式原典を空欄化した独自の予想問題。原典の連続性・全肢代入は独立fixtureで検証する。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の教育施設における学習内容や学習の進め方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "寺子屋では，師匠が示す手本による手習とともに，往来物が読み書きの教材として使われた。往来物には，手紙文，地理や産業に関わる内容などが盛り込まれていたが，これらは中国の儒学の経書を日本語に翻訳して成立した教材であった。"),
      text_choice.call("イ", "廣瀬淡窓が開いた咸宜園では，入門時の学歴・年齢・身分による区別を設けない三奪法が採られた。門下生の学習意欲を高めるために月旦評も行われたが，これは学力試験の成績ではなく，門下生の生活態度を中心とする人物評価を公表する制度であった。"),
      text_choice.call("ウ", "寺子屋では，庶民の生活に必要な手習や読物の学習が行われた。算用は家庭生活の中やそろばん塾で学ぶことも多かったが，幕末には読み・書き・算を併せて教える寺子屋も増え，近代の小学校に近い学習内容を持つようになった。", true),
      text_choice.call("エ", "緒方洪庵が大坂に開いた適塾では，蘭学や医学が教授され，福澤諭吉などが学んだ。学習を進めるに当たっては，月初めに門下生の成績を評価して公表する月旦評を制度化し，門下生の学力に応じた等級によって競争を促した。"),
    ],
    explanation_blocks: [
      text_block.call("ア：往来物の成立が誤り。往来物は，教材としての目的をもって日本で作られたもので，もともと往復の手紙文を集めた形式から多様な内容へ発展した。中国の儒学の経書の翻訳から成立したものではない。手習・読物の双方の教材として用いられた点は適切。"),
      text_block.call("イ：三奪法の説明は適切だが，月旦評の内容が誤り。月旦評は門下生の学力・学業成績を評価し，成績を公表する制度である。生活態度を中心とする人物評価という説明と取り違えている。"),
      text_block.call("ウ：適切。寺子屋の基本的な学習と，算用を家庭・そろばん塾で学ぶ場合，幕末に読み・書き・算を扱う寺子屋が増えたことを区別している。"),
      text_block.call("エ：適塾の創設者，学問分野及び門人は適切だが，制度の帰属が誤り。月旦評は咸宜園の制度である。適塾でも蘭書の会読や成績に応じた競争が行われたが，それを咸宜園の月旦評と同一の制度として扱うことはできない。"),
    ],
    source_text: "文部科学省『学制百年史』「一 幕末期の教育」―庶民の教育 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html\n日田市咸宜園教育研究センター「咸宜園とは」―咸宜園の教育 | https://www.city.hita.oita.jp/site/kangien/1736.html\n大阪大学適塾記念センター「概要」 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku\n大阪大学適塾記念センター「適塾の教育・塾生」 | https://www.tekijuku.osaka-u.ac.jp/ja/tekijuku/education",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ペスタロッチの教育思想及び教授方法について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "人間の知的・道徳的・身体的な諸力の調和的発達を重視し，これを頭・心・手に関わる教育として捉えた。また，直観を知的な学習の基礎に置き，数・形・語を，事物を明瞭に認識するための基本的な要素として位置付けた。", true),
      text_choice.call("イ", "人間の諸力を調和的に発達させることを目指し，家庭における親子の関係を重視した。数・形・語は知的・道徳的・身体的な諸力をそれぞれ表すもので，頭・心・手は事物を認識するための教授方法の基本的な要素を表すものとした。"),
      text_choice.call("ウ", "頭・心・手に関わる諸力の調和と，数・形・語を基礎とする教授を重視した。直観とは，新しい表象を既有の表象群へ取り入れて結び付ける心の働きであり，教師はその結合を導くことで子どもの認識を明瞭にすると考えた。"),
      text_choice.call("エ", "貧しい子どもの教育に取り組み，知的・道徳的・身体的な諸力の調和と，生活に根ざす教授を重視した。『人間の教育』では，具体的な事物を直観することを出発点として，知識の基礎となる数・形・語の教育を体系的に論じた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。頭・心・手は人間の諸力の調和的発達に，数・形・語は直観を基礎とする知的な認識・教授に関わる。二つの三要素を同じ分類として扱わない。"),
      text_block.call("イ：二つの三要素の位置付けが逆。知的・道徳的・身体的な諸力の調和が頭・心・手に対応し，数・形・語は事物の認識の基本的な要素として位置付けられる。"),
      text_block.call("ウ：直観を，ヘルバルトの統覚の説明へ置き換えた点が誤り。ペスタロッチの直観は，具体的な事物を直接捉えることに関わる。新しい表象を既有の表象群へ取り入れて結び付ける心の働きは，ヘルバルトが重視した統覚である。"),
      text_block.call("エ：著作の帰属が誤り。『人間の教育』はフレーベルの著作。ペスタロッチが数・形・語の教授を論じた著作には『ゲルトルート児童教授法』がある。"),
    ],
    source_text: "玉川学園『玉川豆知識 No.136 小原國芳がペスタロッチ賞を受賞』1「ペスタロッチ」 | https://www.tamagawa.jp/introduction/tamagawa_trivia/tamagawa_trivia-136.html\n筑波大学附属図書館『近代教育学の源流』IV「教育学と家庭・学校・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n白石崇人『資料から考える教育原理』第10章・120頁 | https://h-bunkyo.repo.nii.ac.jp/record/1355/files/20Siryokyoiku.pdf\n白石陽一「ヘルバルトにおける教授技術の性格―『教える』ことの技術の教授学的検討（その2）―」23頁 | https://www.jstage.jst.go.jp/article/nasemjournal/11/0/11_KJ00006621998/_pdf/-char/ja#page=5",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（4）生徒が学習の見通しを立てたり学習したことを振り返ったりする活動を，{{①}}に取り入れるように工夫すること。\n（5）生徒が{{②}}，主体的に挑戦してみることや多様な他者と協働することの重要性などを実感しながら理解することができるよう，{{③}}に応じた体験活動を重視し，{{④}}と連携しつつ体系的・継続的に実施できるよう工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["計画的", "自己の可能性や社会の多様性", "生徒の希望する進路", "家庭や地域社会"]),
      fill_in_choice.call("イ", ["計画的", "生命の有限性や自然の大切さ", "各教科・科目等の特質", "家庭や地域社会"], true),
      fill_in_choice.call("ウ", ["弾力的", "生命の有限性や自然の大切さ", "各教科・科目等の特質", "大学や研究機関"]),
      fill_in_choice.call("エ", ["弾力的", "自己の可能性や社会の多様性", "生徒の希望する進路", "大学や研究機関"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は原文と一致する。②は「生命の有限性や自然の大切さ」、③は「各教科・科目等の特質」である。体験を通して実感する内容と、体験活動を組み立てる際の教科・科目等との対応を取り違えている。"),
      text_block.call("イ：全て原文と一致する。見通しと振り返りを計画的に取り入れること、各教科・科目等の特質に応じた体験活動、家庭・地域との連携を示す。"),
      text_block.call("ウ：②③は原文と一致する。①は「計画的」、④は「家庭や地域社会」である。学習の見通し・振り返りをあらかじめ指導へ位置付けることと、体験活動の連携相手を確認する。"),
      text_block.call("エ：全て原文と異なる。大学や研究機関と連携する活動が一般に不適切なのではなく、この連続箇所では家庭や地域社会と連携することを規定している。"),
    ],
    source_text: "高等学校学習指導要領・第1章第3款1（4）〜（5）全文、PDF30頁／印刷28頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（1）学習や生活の基盤として，{{①}}及び生徒相互のよりよい人間関係を育てるため，日頃から{{②}}の充実を図ること。また，主に集団の場面で必要な指導や援助を行う{{③}}と，個々の生徒の多様な実態を踏まえ，一人一人が抱える課題に個別に対応した指導を行う{{④}}の双方により，生徒の発達を支援すること。\n（2）生徒が，自己の存在感を実感しながら，よりよい人間関係を形成し，有意義で充実した学校生活を送る中で，現在及び将来における自己実現を図っていくことができるよう，生徒理解を深め，学習指導と関連付けながら，生徒指導の充実を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教師と生徒との信頼関係", "ホームルーム経営", "カウンセリング", "ガイダンス"]),
      fill_in_choice.call("イ", ["教師相互の信頼関係", "教科指導", "ガイダンス", "カウンセリング"]),
      fill_in_choice.call("ウ", ["教師相互の信頼関係", "教科指導", "カウンセリング", "ガイダンス"]),
      fill_in_choice.call("エ", ["教師と生徒との信頼関係", "ホームルーム経営", "ガイダンス", "カウンセリング"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は原文と一致する。③は「ガイダンス」、④は「カウンセリング」である。集団の場面での指導・援助と、一人一人の課題への個別の対応の位置付けを逆にしている。"),
      text_block.call("イ：③④は原文と一致する。①は「教師と生徒との信頼関係」、②は「ホームルーム経営」である。教師同士の信頼関係も教育上必要だが、この箇所では学習・生活の基盤となる教師と生徒、生徒相互の関係を日常のホームルーム経営で育てる。"),
      text_block.call("ウ：全て原文と異なる。教師と生徒との関係及びホームルーム経営と、ガイダンス・カウンセリングの双方の役割を確認する。"),
      text_block.call("エ：全て原文と一致する。日常の人間関係づくりを基盤とし、ガイダンスとカウンセリングの双方で発達を支え、学習指導と関連付けて生徒指導を充実する。"),
    ],
    source_text: "高等学校学習指導要領・第1章第5款1（1）〜（2）全文、PDF31〜32頁／印刷29〜30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編」（平成30年7月文部科学省）の「第3章 総合的な探究の時間の目標 第2節 目標の趣旨」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "総合的な探究の時間における探究の過程では，生徒は，教科・科目等の枠組みを超えて，長時間じっくり課題に取り組む中で，様々な事柄を知り，{{①}}に出会う。その中で，具体的・個別的な事実だけでなく，それらが複雑に絡み合っている状況についても理解するようになる。その知識は，教科書や資料集に整然と整理されているものを取り込んで獲得するものではなく，探究の過程を通して，自分自身で取捨・選択し，整理し，{{②}}と結び付けながら，構造化し，身に付けていくものである。こうした過程を経ることにより，獲得された知識は，{{③}}における様々な課題の解決に活用可能な生きて働く知識，すなわち概念が形成されるのである。\n\n各教科・科目等においても，「主体的・対話的で深い学び」を通して，事実的な知識から概念を獲得することを目指すものである。総合的な探究の時間では，各教科・科目等で習得した概念を実生活の課題解決に活用することを通して，それらが統合され，より一般化されることにより，{{④}}を形成することができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["様々な人の考え", "既にもっている知識や体験", "実社会や実生活", "汎用的に活用できる概念"], true),
      fill_in_choice.call("イ", ["専門的な研究成果", "探究で得られた結論や解決策", "実社会や実生活", "汎用的に活用できる概念"]),
      fill_in_choice.call("ウ", ["様々な人の考え", "既にもっている知識や体験", "各教科・科目の学習", "各教科・科目に固有の知識"]),
      fill_in_choice.call("エ", ["専門的な研究成果", "探究で得られた結論や解決策", "各教科・科目の学習", "各教科・科目に固有の知識"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て一致する。様々な人の考えに出会い，既有の知識・体験との結び付きから知識を構造化する。各教科・科目の概念を実生活の課題解決へ用い，統合・一般化によって汎用的な概念を形成する。"),
      text_block.call("イ：③④は一致する。①は「様々な人の考え」，②は「既にもっている知識や体験」。専門的な研究成果との出会いや得られた結論の整理だけを述べるのではなく，人の考えとの出会いと既有の知識・体験による知識形成を述べている。"),
      text_block.call("ウ：①②は一致する。③は「実社会や実生活」，④は「汎用的に活用できる概念」。獲得した知識を教科の学習の中だけで用いるのではなく，実際の課題へ活用する。概念の統合・一般化により，教科固有の知識にとどまらない概念を形成する。"),
      text_block.call("エ：全て異なる。①は人の考え，②は既有の知識・体験，③は実社会・実生活，④は汎用的な概念である。知識を探究で構造化し，教科で習得した概念をより広く活用できるものにする過程を押さえる。"),
    ],
    source_text: "高等学校学習指導要領解説 総合的な探究の時間編 第3章 第2節2，知識・概念形成の連続2段落，印刷16頁／PDF24頁 | https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf#page=24",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第7款 道徳教育に関する配慮事項」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "２ 道徳教育を進めるに当たっては，中学校までの特別の教科である道徳の学習等を通じて深めた，主として自分自身，人との関わり，集団や社会との関わり，生命や自然，崇高なものとの関わりに関する{{①}}についての理解を基にしながら，様々な{{②}}の機会等を通して，人間としての在り方生き方についての考えを深めるよう留意すること。また，{{③}}を高め，規律ある生活をすること，生命を尊重する心を育てること，社会連帯の自覚を高め，主体的に社会の形成に参画する意欲と態度を養うこと，{{④}}態度及び人権を尊重し差別のないよりよい社会を実現しようとする態度を養うこと，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛するとともに，他国を尊重すること，国際社会に生きる日本人としての自覚を身に付けることに関する指導が適切に行われるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["道徳的諸価値", "講義や討論", "自立心や自律性", "権利を行使し自由を重んずる"]),
      fill_in_choice.call("イ", ["社会生活の規範", "体験や思索", "自主性や自発性", "権利を行使し自由を重んずる"]),
      fill_in_choice.call("ウ", ["道徳的諸価値", "体験や思索", "自立心や自律性", "義務を果たし責任を重んずる"], true),
      fill_in_choice.call("エ", ["社会生活の規範", "講義や討論", "自主性や自発性", "義務を果たし責任を重んずる"]),
    ],
    explanation_blocks: [
      text_block.call("①は「道徳的諸価値」、②は「体験や思索」、③は「自立心や自律性」、④は「義務を果たし責任を重んずる」である。中学校までの学習等を通じて深めた価値理解を基に、体験や思索を通じて人間としての在り方生き方への考えを深める。後半では自立・自律、生命、社会連帯、義務・責任と人権等への配慮を具体的に示している。"),
      text_block.call("ア：②④が誤り。ここで考えを深める機会を表す原語は「体験や思索」である。また、後半で人権の尊重と併せて記す態度は「義務を果たし責任を重んずる」態度である。"),
      text_block.call("イ：①③④が誤り。理解の基礎は「道徳的諸価値」であり、規律ある生活に結び付けて高めるものは「自立心や自律性」である。④も原典の義務・責任を表す語句と異なる。"),
      text_block.call("ウ：全て原文と一致する。中学校までに深めた価値理解と、高等学校で考えを深める機会及び具体的な配慮事項との対応が正しい。"),
      text_block.call("エ：①②③が誤り。④は正しいが、価値理解、考えを深める機会及び自立・自律に関する語句が原文と異なる。"),
      text_block.call("「講義や討論」「自主性や自発性」「権利を行使し自由を重んずる」を一般に否定する問題ではなく、原典のこの箇所に記された語句の組合せを問う。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第1章第7款2全文（PDF34頁／印刷32頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=34",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第1 目標」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "{{①}}としての見方・考え方を働かせ，様々な集団活動に自主的，実践的に取り組み，互いのよさや可能性を発揮しながら集団や自己の生活上の課題を解決することを通して，次のとおり資質・能力を育成することを目指す。\n（1）{{②}}と協働する様々な集団活動の意義や活動を行う上で必要となることについて理解し，行動の仕方を身に付けるようにする。\n（2）集団や自己の生活，人間関係の課題を見いだし，解決するために話し合い，{{③}}を図ったり，意思決定したりすることができるようにする。\n（3）自主的，実践的な集団活動を通して身に付けたことを生かして，主体的に集団や社会に参画し，{{④}}をよりよく形成するとともに，人間としての在り方生き方についての自覚を深め，自己実現を図ろうとする態度を養う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["集団や社会の形成者", "共通の考えをもつ仲間", "合意形成", "生活及び学習環境"]),
      fill_in_choice.call("イ", ["社会における職業の担い手", "多様な他者", "共通理解", "生活及び人間関係"]),
      fill_in_choice.call("ウ", ["社会における職業の担い手", "共通の考えをもつ仲間", "共通理解", "生活及び学習環境"]),
      fill_in_choice.call("エ", ["集団や社会の形成者", "多様な他者", "合意形成", "生活及び人間関係"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は一致する。②は「多様な他者」，④は「生活及び人間関係」。共通の考えをもつ仲間だけを対象とせず，多様な他者との協働を扱う。形成する対象も学習環境という表現ではない。"),
      text_block.call("イ：②④は一致する。①は「集団や社会の形成者」であり，職業上の役割に限定した見方・考え方ではない。③は「合意形成」であり，話合いにおける理解の共有と，実践につなげる合意の形成を区別する。"),
      text_block.call("ウ：全て異なる。①は集団・社会の形成者，②は多様な他者，③は合意形成，④は生活・人間関係。特別活動の目標を職業や学習環境だけの改善に置き換えない。"),
      text_block.call("エ：全て一致する。総括目標の見方・考え方と，（1）の協働の対象，（2）の話合いに基づく判断，（3）の生活・人間関係の形成を対応させた組合せである。"),
    ],
    source_text: "高等学校学習指導要領 第5章 第1 目標 全文，印刷478頁／PDF480頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=480",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 6, 7, 8, 9, 10]
  raise "模擬試験32の承認済み問番号は1・2及び6〜10です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",

  6 => "curriculum_organization", 7 => "student_guidance_career",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
}
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless question.fetch(:major_category_code) == "teacher_education" && question.fetch(:category_code) == categories.fetch(number)
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  if number <= 3
    unless blocks.all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "text" && !choice.fetch(:content_blocks).first.fetch(:text).strip.empty? }
      raise "問#{number}の本文と選択肢は通常の文章ブロックにしてください"
    end
  else
    quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([^{}]+)\}\}/).flatten }.uniq
    expected_blocks = %w[fill_in_text fill_in_quote]
    unless blocks.map { |block| block[:type] } == expected_blocks && quotes.size == 1 &&
        blocks.first.fetch(:text).include?(number <= 5 ? "空欄 ① ～ ④" : "空欄 {{①}} ～ {{④}}") && labels == %w[① ② ③ ④] &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 && choice.fetch(:content_blocks).first.fetch(:cells).all? { |cell| !cell.strip.empty? } }
      raise "問#{number}の抜粋・4空欄と選択肢の対応が不正です"
    end
    if number <= 5 && !quotes.first.fetch(:text).match?(/\A第\d+条第\d+項/)
      raise "問#{number}の抜粋枠の冒頭に条番号・項番号を表示してください"
    end
    if (6..10).cover?(number)
      cells = choices.map { |choice| choice.fetch(:content_blocks).first.fetch(:cells) }
      unless cells.transpose.all? { |column| column.group_by { |cell| cell }.values.map(&:size).sort == [2, 2] }
        raise "問#{number}の選択肢は各列の語句を2対2にしてください"
      end
      if number == 6 && !(blocks.first.fetch(:text).include?("第1章 総則 第3款 教育課程の実施と学習評価") && question.fetch(:source_text).include?("第3款"))
        raise "問6は総則第3款から出題してください"
      end
      if number == 7 && !(blocks.first.fetch(:text).include?("第1章 総則 第5款 生徒の発達の支援") && question.fetch(:source_text).include?("第5款"))
        raise "問7は総則第5款から出題してください"
      end
    end
  end
  explanation = question.fetch(:explanation_blocks)
  unless explanation.all? { |block| block[:type] == "text" && !block.fetch(:text).strip.empty? } &&
      %w[ア イ ウ エ].all? { |label| explanation.any? { |block| block.fetch(:text).start_with?("#{label}：") } }
    raise "問#{number}は全ての選択肢の解説を記載してください"
  end
  sources = question.fetch(:source_text).lines
  unless sources.any? && sources.all? { |line| line.strip.match?(/\A.+ \| https:\/\/\S+\z/) }
    raise "問#{number}の出典は資料名・章節とURLを記載してください"
  end
end

QuestionSeedSync.import(exam_number: 32, questions: questions, publication_status: "draft")

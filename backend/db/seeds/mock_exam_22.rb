text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験22（承認済みの問1〜10。全20問が揃うまで下書き）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "江戸時代の教育思想とその担い手について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "貝原益軒は，『和俗童子訓』で子どもの年齢に応じた教育を論じ，幼いときからの教育を重視した。また，『翁問答』を著して親への孝を中心とする道徳を説き，子どもの養育と庶民の教化の双方について，平易な日本語で著作を残した。"),
      text_choice.call("イ", "石田梅岩は，京都で聴講自由の講話を始め，庶民の生活に即した石門心学を広めた。商業の社会的役割と利潤追求の正当性を認める一方，忠孝，正直，倹約などの実践を重視し，日常生活と結び付いた道徳を説いた。", true),
      text_choice.call("ウ", "中江藤樹は，近江に私塾を開き，近郷の人々や藩士に儒学を教え，後に近江聖人と称された。初めに王陽明の致良知説に傾倒し，その後に『四書大全』を読んで朱子学へと転じたことが，門人の熊沢蕃山にも受け継がれた。"),
      text_choice.call("エ", "幕府に登用された林羅山の学問は林家に継承され，林家は幕府の学問所の教学を担った。寛政期の異学の禁では，朱子学と陽明学をともに正学とし，この二つの学派を基準として幕府の学問所における儒学教育を整えた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：『和俗童子訓』と早期教育・年齢に応じた教育の説明は適切だが，『翁問答』の著者が誤り。『翁問答』は中江藤樹の著作である。"),
      text_block.call("イ：適切。石田梅岩は，商業と利潤の社会的意義を認め，庶民に忠孝，正直，倹約などの実践的道徳を説いた。心学は講話などを通じて広まった。"),
      text_block.call("ウ：私塾，近江聖人，熊沢蕃山という人物関係は適切だが，思想の変化が逆。藤樹は初め朱子学に傾倒し，後に王陽明の致良知説へと傾倒した。"),
      text_block.call("エ：林家が幕府の教学を担ったことは適切だが，正学の範囲が誤り。寛政異学の禁で正学とされたのは朱子学であり，陽明学も正学に含まれたとする記述は誤り。"),
    ],
    source_text: "名古屋大学公開講義『人間発達科学Ⅰ 第5回〈子ども〉の発見②』―貝原益軒『和俗童子訓』（PDF8ページ） | https://ocw.nagoya-u.jp/files/246/yoshikawa-5.pdf#page=8\n東京学芸大学教育コンテンツアーカイブ『心学資料』―心学資料とは | https://d-archive.u-gakugei.ac.jp/collection/shingaku/description\n高島市『中江藤樹』―どんなひと？ | https://www.city.takashima.lg.jp/soshiki/bunkasports/bunkazaika/1/1/670.html\n文部科学省『学制百年史』「一 幕末期の教育」―武家の教育（昌平坂学問所・寛政異学の禁） | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "ペスタロッチの教育思想と教授方法について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "『ゲルトルート児童教授法』で，直観を手掛かりとして知識の基礎となる数・形・語の教育を論じた。子どもが具体的な事物を捉えることから知的な諸能力を育てる教授を構想し，家庭における親子の関係や生活を，人間形成の基礎として重視した。", true),
      text_choice.call("イ", "『ゲルトルート児童教授法』で，数・形・語を知識の基礎として位置付けた。直観教授では，事物の一般的な定義を教師が言葉で説明し，子どもがその定義を理解した後に，観察した具体的な事物を定義へ当てはめる順序を教授の出発点とした。"),
      text_choice.call("ウ", "貧しい子どもの教育に取り組み，生活に結び付いた教授と諸能力の調和的な発達を重視した。『世界図絵』では数・形・語を学ぶために事物の図と名称を対応させ，その図を用いることによって，家庭における母親の教育を助けようとした。"),
      text_choice.call("エ", "家庭的な共同生活と，具体的な事物を手掛かりにする直観教授を重視した。『ゲルトルート児童教授法』に示された教授を，予備・提示・比較・総括・応用の五段階として体系化し，教師が新しい観念を既有の観念群へ結び付ける方法を構想した。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切である。ペスタロッチは，直観を基礎として数・形・語の教育を展開し，生活や親子の関係を人間形成の基礎とした。イは，一般的な定義の説明を先に行う順序が誤りである。具体的な事物を直接捉える直観を出発点にする。ウは著作の帰属が誤りで，『世界図絵』はコメニウスの著作である。エの五段階教授法は，ヘルバルトの教授理論をツィラーやラインらのヘルバルト派が展開したものであり，ペスタロッチの同書の教授方法とするのは誤りである。"),
    ],
    source_text: "筑波大学『近代教育学の源流』IV「教育学と家庭・学校・社会」 | https://www.tulips.tsukuba.ac.jp/exhibition/kindai-kyoiku-genryu/chap4.html\n国立国会図書館「コメニウス『世界図絵』」 | https://ndlsearch.ndl.go.jp/rnavi/children/post_237\n奥山和夫「情意的学習法の理論とその試み」『共栄学園短期大学研究紀要』第16号・2頁，表1「ヘルバルト派の形式的教授段階」 | https://kyoei.repo.nii.ac.jp/record/484/files/KJ00000173172.pdf#page=2",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第2条 教育の目標」からの抜粋である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第2条　教育は、その目的を実現するため、{{①}}を尊重しつつ、次に掲げる目標を達成するよう行われるものとする。\n\n一　{{②}}を身に付け、真理を求める態度を養い、豊かな情操と道徳心を培うとともに、健やかな身体を養うこと。\n\n二　{{③}}を尊重して、その能力を伸ばし、創造性を培い、自主及び自律の精神を養うとともに、職業及び生活との関連を重視し、{{④}}を重んずる態度を養うこと。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習の機会均等", "幅広い知識と教養", "個人の人格", "勤労"]),
      fill_in_choice.call("イ", ["学問の自由", "高い教養と専門的能力", "個人の価値", "協同"]),
      fill_in_choice.call("ウ", ["学問の自由", "幅広い知識と教養", "個人の価値", "勤労"], true),
      fill_in_choice.call("エ", ["学習の機会均等", "高い教養と専門的能力", "個人の人格", "協同"]),
    ],
    explanation_blocks: [
      text_block.call("原語は①「学問の自由」，②「幅広い知識と教養」，③「個人の価値」，④「勤労」である。第2条の柱書，第1号，第2号にそれぞれ置かれた語句を区別する。"),
      text_block.call("ア：①は「学問の自由」，③は「個人の価値」。学習の機会均等や人格の尊重が重要であることを否定するのではなく，この条文に明記された語句を問う。"),
      text_block.call("イ：②は「幅広い知識と教養」，④は「勤労」。「高い教養と専門的能力」は第7条の大学についての語句である。"),
      text_block.call("ウ：四つとも原文と一致する。"),
      text_block.call("エ：①〜④の全てが原文と異なる。"),
    ],
    source_text: "教育基本法・第2条柱書、第1号、第2号、第7条第1項 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_1-At_2",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第53条\n\n高等学校には、{{①}}の課程のほか、{{②}}の課程を置くことができる。\n\n２　高等学校には、{{②}}の課程のみを置くことができる。" },
      { type: "fill_in_quote", text: "第56条\n\n高等学校の修業年限は、{{①}}の課程については、{{③}}とし、{{②}}の課程及び通信制の課程については、{{④}}とする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["全日制", "夜間制", "四年", "三年以上"]),
      fill_in_choice.call("イ", ["昼間制", "定時制", "三年", "四年以上"]),
      fill_in_choice.call("ウ", ["昼間制", "夜間制", "四年", "四年以上"]),
      fill_in_choice.call("エ", ["全日制", "定時制", "三年", "三年以上"], true),
    ],
    explanation_blocks: [
      text_block.call("第53条は，全日制の課程のほかに定時制の課程を置くことができ，定時制の課程だけを置くこともできると定める。第56条の修業年限は，全日制が「三年」，定時制・通信制が「三年以上」である。定時制には夜間に学ぶものに加えて昼間に学ぶものもあり，「全日制・定時制」という法定の課程名を，単なる授業時間帯を表す「昼間制・夜間制」へ置き換えることはできない。実際に4年で修了する定時制課程があることと，法定の修業年限を「四年以上」とすることも異なる。"),
      text_block.call("ア：②は「定時制」，③は「三年」。定時制を夜間制とする原文ではなく，全日制の修業年限を4年とする規定でもない。"),
      text_block.call("イ：①は「全日制」，④は「三年以上」。第53条の冒頭は昼間制ではなく全日制であり，定時制・通信制の法定の修業年限は4年以上ではない。"),
      text_block.call("ウ：①〜④が全て原文と異なる。"),
      text_block.call("エ：4語句が原文と一致する。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第53条第1項・第2項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_53\ne-Gov法令検索『学校教育法』第56条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_56\n愛知県『定時制・通信制教育』「定時制教育」（昼間定時制・修業年限の解説根拠） | https://www.pref.aichi.jp/soshiki/kotogakko/0000027113.html\n文部科学省『平成18年度版 高等学校教育の改革に関する推進状況』第2章3（1）「多部制の定時制課程」（昼間定時制・3年修了の解説根拠） | https://www.mext.go.jp/a_menu/shotou/kaikaku/detail/1376217.htm",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「教育公務員特例法」 （昭和24年法律第1号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第23条第2項　{{①}}は、初任者研修を受ける者（次項において「初任者」という。）の{{②}}の副校長、教頭、主幹教諭（養護又は栄養の指導及び管理をつかさどる主幹教諭を除く。）、指導教諭、主務教諭（養護又は栄養の指導及び管理をつかさどる主務教諭を除く。）、教諭、主幹保育教諭、指導保育教諭、主務保育教諭、保育教諭又は講師のうちから、{{③}}を命じるものとする。\n\n３　{{③}}は、初任者に対して教諭又は保育教諭の職務の遂行に必要な事項について{{④}}を行うものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["研修実施者", "所属する学校", "指導主事", "能力及び適性の評価"]),
      fill_in_choice.call("イ", ["指導助言者", "所属する学校", "指導教員", "指導及び助言"], true),
      fill_in_choice.call("ウ", ["指導助言者", "任命権者が所管する学校", "指導主事", "能力及び適性の評価"]),
      fill_in_choice.call("エ", ["研修実施者", "任命権者が所管する学校", "指導教員", "指導及び助言"]),
    ],
    explanation_blocks: [
      text_block.call("正答はイ。原語は①「指導助言者」、②「所属する学校」、③「指導教員」、④「指導及び助言」。指導助言者は初任者の所属校にいる列挙された職の者から指導教員を命じ、指導教員は初任者の職務遂行に必要な事項を指導・助言する。アは①を研修実施者、③を教育委員会の専門的教育職員である指導主事、④を中堅教諭等資質向上研修における能力・適性の評価へ取り違えている。ウは②の範囲を任命権者の所管校全体へ広げ、③・④も誤り。エは①・②が誤り。同じ任命権者が所管する学校であれば、初任者の所属校以外からこの項の指導教員を命じられるという規定ではない。③は第3項にも同じ空欄番号を用い、原語が本文に残って正答を示さないようにした。"),
    ],
    source_text: "教育公務員特例法・第23条第2項〜第3項、第2条第5項、第24条第2項 | https://laws.e-gov.go.jp/law/324AC0000000001/20260401_507AC0000000068#Mp-Ch_4-At_23",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価 1 主体的・対話的で深い学びの実現に向けた授業改善」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）学校図書館を計画的に利用し{{①}}を図り，生徒の主体的・対話的で深い学びの実現に向けた授業改善に生かすとともに，生徒の{{②}}な学習活動や読書活動を充実すること。また，地域の図書館や博物館，美術館，劇場，音楽堂等の施設の活用を{{③}}に図り，{{④}}情報の収集や鑑賞等の学習活動を充実すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["その施設の公開", "協同的，組織的", "補助的", "資料を活用した"]),
      fill_in_choice.call("イ", ["その施設の公開", "協同的，組織的", "積極的", "教科書に準拠した"]),
      fill_in_choice.call("ウ", ["その機能の活用", "自主的，自発的", "補助的", "教科書に準拠した"]),
      fill_in_choice.call("エ", ["その機能の活用", "自主的，自発的", "積極的", "資料を活用した"], true),
    ],
    explanation_blocks: [
      text_block.call("学校図書館の機能を授業改善に生かすことと，生徒自身による学習・読書活動を充実することを結び付けている。地域の文化施設も積極的に活用する。"),
      text_block.call("ア：①は施設の公開ではなく，学校図書館の「機能の活用」である。 ②は生徒自身が学ぶ「自主的，自発的」な活動であり，「協同的，組織的」はこの原文の語句ではない。 ③は地域の文化施設の活用を「積極的」に図るとする。「補助的」に位置付ける記述ではない。"),
      text_block.call("イ：①は施設の公開ではなく，学校図書館の「機能の活用」である。 ②は生徒自身が学ぶ「自主的，自発的」な活動であり，「協同的，組織的」はこの原文の語句ではない。 ④は「資料を活用した」情報収集や鑑賞である。教科書への準拠を条件とする箇所ではない。"),
      text_block.call("ウ：③は地域の文化施設の活用を「積極的」に図るとする。「補助的」に位置付ける記述ではない。 ④は「資料を活用した」情報収集や鑑賞である。教科書への準拠を条件とする箇所ではない。"),
      text_block.call("エ：全ての空欄が原文と一致する。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第3款 1(6) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "ウ 障害のある生徒などについては，家庭，地域及び医療や福祉，保健，労働等の業務を行う関係機関との連携を図り，長期的な視点で生徒への教育的支援を行うために，個別の教育支援計画を{{①}}とともに，各教科・科目等の指導に当たって，個々の生徒の実態を的確に把握し，個別の指導計画を{{①}}ものとする。特に，{{②}}については，個々の生徒の障害の状態等の実態を的確に把握し，個別の教育支援計画や個別の指導計画を{{③}}ものとする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["作成し，効果的に活用する", "通級による指導を受ける生徒", "作成し活用することに努める"]),
      fill_in_choice.call("イ", ["作成し，効果的に活用する", "障害のある全ての生徒", "作成し，効果的に活用する"]),
      fill_in_choice.call("ウ", ["作成し活用することに努める", "通級による指導を受ける生徒", "作成し，効果的に活用する"], true),
      fill_in_choice.call("エ", ["作成し活用することに努める", "障害のある全ての生徒", "作成し活用することに努める"]),
    ],
    explanation_blocks: [
      text_block.call("障害のある生徒など一般については二つの計画を「作成し活用することに努める」とする。一方，特に通級による指導を受ける生徒については，二つの計画を「作成し，効果的に活用する」と定めている。"),
      text_block.call("ア：①は一般の障害のある生徒などを対象とする努力事項の表現であり，末尾の通級の規定と入れ替えない。 ③は通級による指導を受ける生徒についての「作成し，効果的に活用する」であり，努力事項の表現ではない。"),
      text_block.call("イ：①は一般の障害のある生徒などを対象とする努力事項の表現であり，末尾の通級の規定と入れ替えない。 ②は「通級による指導を受ける生徒」である。一般の障害のある生徒などへの規定と，特に通級を受ける生徒への規定を区別する。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：②は「通級による指導を受ける生徒」である。一般の障害のある生徒などへの規定と，特に通級を受ける生徒への規定を区別する。 ③は通級による指導を受ける生徒についての「作成し，効果的に活用する」であり，努力事項の表現ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第5款 2(1)ウ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=32",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第2 各学校において定める目標及び内容」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（5）目標を実現するにふさわしい探究課題については，地域や学校の実態，生徒の特性等に応じて，例えば，国際理解，情報，環境，福祉・健康などの現代的な諸課題に対応する横断的・総合的な課題，地域や学校の特色に応じた課題，{{①}}に基づく課題，職業や自己の進路に関する課題などを踏まえて設定すること。\n\n（6）探究課題の解決を通して育成を目指す具体的な資質・能力については，次の事項に配慮すること。\n\nア {{②}}については，他教科等及び総合的な探究の時間で習得する{{②}}が相互に関連付けられ，社会の中で生きて働くものとして形成されるようにすること。\n\nイ {{③}}については，課題の設定，情報の収集，整理・分析，まとめ・表現などの探究の過程において発揮され，{{④}}において活用できるものとして身に付けられるようにすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生徒の興味・関心", "知識及び技能", "思考力，判断力，表現力等", "未知の状況"], true),
      fill_in_choice.call("イ", ["教師の専門性や研究課題", "学びに向かう力，人間性等", "知識及び技能", "未知の状況"]),
      fill_in_choice.call("ウ", ["教師の専門性や研究課題", "学びに向かう力，人間性等", "思考力，判断力，表現力等", "既習の課題"]),
      fill_in_choice.call("エ", ["生徒の興味・関心", "知識及び技能", "知識及び技能", "既習の課題"]),
    ],
    explanation_blocks: [
      text_block.call("探究課題の設定は生徒の興味・関心等を踏まえる。知識・技能は相互に関連付けて社会で生きて働くものにし，思考力・判断力・表現力等は探究の過程で発揮し，未知の状況でも活用できるものにする。"),
      text_block.call("ア：全ての空欄が原文と一致する。"),
      text_block.call("イ：①は「生徒の興味・関心」に基づく課題である。教師の専門性等も指導に関係するが，この列挙の原文ではない。 ②は他教科等と探究で習得したものを関連付ける「知識及び技能」である。 ③は探究の過程で発揮される「思考力，判断力，表現力等」であり，②の柱とは役割が異なる。"),
      text_block.call("ウ：①は「生徒の興味・関心」に基づく課題である。教師の専門性等も指導に関係するが，この列挙の原文ではない。 ②は他教科等と探究で習得したものを関連付ける「知識及び技能」である。 ④は「未知の状況」でも活用できるようにすることである。既習の課題への適用に範囲を限らない。"),
      text_block.call("エ：③は探究の過程で発揮される「思考力，判断力，表現力等」であり，②の柱とは役割が異なる。 ④は「未知の状況」でも活用できるようにすることである。既習の課題への適用に範囲を限らない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第4章第2の3(5)・(6)ア・イ | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=477",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育は，教育基本法及び学校教育法に定められた{{①}}に基づき，生徒が自己探求と自己実現に努め{{②}}に基づき行為しうる発達の段階にあることを考慮し，人間としての在り方生き方を考え，{{③}}の下に行動し，自立した人間として他者と共によりよく生きるための{{④}}となる道徳性を養うことを目標とすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["教育の根本精神", "将来の職業人としての自覚", "集団としての判断", "指針"]),
      fill_in_choice.call("イ", ["教育の基本方針", "国家・社会の一員としての自覚", "集団としての判断", "指針"]),
      fill_in_choice.call("ウ", ["教育の根本精神", "国家・社会の一員としての自覚", "主体的な判断", "基盤"], true),
      fill_in_choice.call("エ", ["教育の基本方針", "将来の職業人としての自覚", "主体的な判断", "基盤"]),
    ],
    explanation_blocks: [
      text_block.call("教育基本法・学校教育法に定める根本精神に基づき，高校生の発達段階を考慮する。主体的な判断による行動と，他者と共によりよく生きる基盤としての道徳性を目標とする。"),
      text_block.call("ア：②は「国家・社会の一員としての自覚」である。将来の職業人に対象を絞った語句ではない。 ③は本人による「主体的な判断」であり，集団としての判断への置換ではない。 ④は他者と共によりよく生きるための「基盤」となる道徳性である。原文は「指針」ではない。"),
      text_block.call("イ：①は両法に定められた「教育の根本精神」であり，各学校の方針を指す語句ではない。 ③は本人による「主体的な判断」であり，集団としての判断への置換ではない。 ④は他者と共によりよく生きるための「基盤」となる道徳性である。原文は「指針」ではない。"),
      text_block.call("ウ：全ての空欄が原文と一致する。"),
      text_block.call("エ：①は両法に定められた「教育の根本精神」であり，各学校の方針を指す語句ではない。 ②は「国家・社会の一員としての自覚」である。将来の職業人に対象を絞った語句ではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第1章第1款 2(2)第2段落 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第5章 特別活動 第2 各活動・学校行事の目標及び内容 〔学校行事〕」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（3）{{①}}\n\n心身の健全な発達や健康の保持増進，事件や事故，災害等から身を守る安全な行動や規律ある集団行動の体得，運動に親しむ態度の育成，責任感や連帯感の涵養，体力の向上などに資するようにすること。\n\n（4）旅行・集団宿泊的行事\n\n平素と異なる生活環境にあって，見聞を広め，自然や文化などに親しむとともに，よりよい人間関係を築くなどの集団生活の在り方や{{②}}などについての体験を積むことができるようにすること。\n\n（5）勤労生産・奉仕的行事\n\n勤労の尊さや創造することの喜びを体得し，就業体験活動などの{{③}}の形成や進路の選択決定などに資する体験が得られるようにするとともに，共に助け合って生きることの喜びを体得し，ボランティア活動などの{{④}}を養う体験が得られるようにすること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["儀式的行事", "公共の精神", "勤労意欲・職業能力", "社会奉仕の精神"]),
      fill_in_choice.call("イ", ["健康安全・体育的行事", "公衆道徳", "勤労観・職業観", "社会奉仕の精神"], true),
      fill_in_choice.call("ウ", ["儀式的行事", "公共の精神", "勤労観・職業観", "社会参画の意欲"]),
      fill_in_choice.call("エ", ["健康安全・体育的行事", "公衆道徳", "勤労意欲・職業能力", "社会参画の意欲"]),
    ],
    explanation_blocks: [
      text_block.call("健康安全・体育的行事では健康・安全や集団行動等，旅行・集団宿泊的行事では見聞・人間関係・公衆道徳等，勤労生産・奉仕的行事では勤労観・職業観や社会奉仕の精神等を扱う。各行事のねらいと原文の語句を対応させる。"),
      text_block.call("ア：①は健康・安全，運動や体力等に関わる「健康安全・体育的行事」である。学校生活の節目に関わる儀式的行事ではない。 ②は集団生活を体験する旅行・集団宿泊的行事の「公衆道徳」である。「公共の精神」は学校行事の目標にも見られるが，この空欄の原語ではない。 ③は就業体験活動等による「勤労観・職業観」の形成である。意欲や能力の語に置き換えない。"),
      text_block.call("イ：全ての空欄が原文と一致する。"),
      text_block.call("ウ：①は健康・安全，運動や体力等に関わる「健康安全・体育的行事」である。学校生活の節目に関わる儀式的行事ではない。 ②は集団生活を体験する旅行・集団宿泊的行事の「公衆道徳」である。「公共の精神」は学校行事の目標にも見られるが，この空欄の原語ではない。 ④はボランティア活動等を通して養う「社会奉仕の精神」である。社会参画の意欲も関連するが，原文の語句は異なる。"),
      text_block.call("エ：③は就業体験活動等による「勤労観・職業観」の形成である。意欲や能力の語に置き換えない。 ④はボランティア活動等を通して養う「社会奉仕の精神」である。社会参画の意欲も関連するが，原文の語句は異なる。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』・第5章第2〔学校行事〕2(3)～(5) | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=482",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..10).to_a
  raise "模擬試験22の承認済み問番号は1〜10です"
end

questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験22 問#{number}は4択・正答1件にしてください"
  end
  if number <= 5 && question.fetch(:category_code) != (number <= 2 ? "education_foundations" : "education_system")
    raise "模擬試験22 問#{number}の分類が不正です"
  end
  blocks = question.fetch(:content_blocks)
  prompt = blocks.first
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  required_cloze = number >= 4 || (number == 3 && [22, 24].include?(22))
  if required_cloze
    expected_labels = number == 7 ? %w[① ② ③] : %w[① ② ③ ④]
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
      raise "模擬試験22 問#{number}の空欄と選択肢の対応が不正です"
    end
    if [4, 5].include?(number) && !quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) }
      raise "模擬試験22 問#{number}の抜粋枠には条番号を表示してください"
    end
  elsif !choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "text" }
    raise "模擬試験22 問#{number}の選択肢形式が不正です"
  end
  if [6, 7].include?(number)
    scope = number == 6 ? "第3款" : "第5款"
    unless prompt.fetch(:text).include?("第1章 総則 #{scope}") && question.fetch(:source_text).include?("第1章#{scope}")
      raise "模擬試験22 問#{number}の導入文と出典範囲が一致しません"
    end
  end
  entry = { exam_number: 22, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(22, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } <= 3 }
  raise "模擬試験22の問1〜10の正答位置が偏っています"
end

QuestionSeedSync.import(exam_number: 22, questions: questions, publication_status: "draft")

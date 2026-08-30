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

# 模擬試験8は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("江戸時代の教育機関に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "藩校は主として藩士の教育機関として設けられ、儒学、特に朱子学を中心とするものが多かった。幕末には国学、洋学、西洋医学、武芸などを加え、庶民の入学を認める学校も現れるなど、総合的な教育機関へ発展した例があった。"),
      text_choice.call("イ", "寺子屋は庶民の日常生活に必要な初歩的・実用的教育を行う私設の施設であり、手習を中心に、往来物などを教材として用いた。幕末には読み・書き・算術を併せて教える寺子屋も増え、学制公布後の小学校設置を支える基盤の一つとなった。"),
      text_choice.call("ウ", "郷校は、民間の学者が自宅に設けた施設だけを指し、幕府、藩主、代官などの保護や監督を受けることはなかった。したがって教育対象、教育内容、経営形態のいずれにおいても私塾と同一であり、藩校や寺子屋との中間的性格をもつものは存在しなかった。", true),
      text_choice.call("エ", "私塾は一般に教師の私宅などで学問や芸能を門弟へ授ける施設で、漢学塾、国学塾、洋学塾、算学塾など多様な形態をとった。幕末には身分上の区別が比較的少ない私塾もあり、近代の私立学校につながる源流の一つとなった。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切でない記述です。アは適切です。藩校は武士教育を基本としましたが、幕末には教育内容を国学、洋学、西洋医学、武芸などへ広げ、教育対象を拡張した例もありました。イも適切です。寺子屋は手習と往来物を中心とする庶民の教育機関で、読み・書き・算術を扱うものも増え、近代の小学校設置を支える社会的基盤の一つとなりました。ウは誤りです。郷校には、藩校の延長として武士を対象とするもの、藩主や代官の保護・監督下で庶民を教育するもの、武士と庶民の双方を受け入れるものなどがあり、すべてを私塾と同一視することはできません。エは適切です。私塾は学問分野も入学者の身分も比較的多様で、近代私立学校の母体となったものもあります。"),
    ],
    source_text: "文部科学省『学制百年史』序章「一 幕末期の教育」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/mext_03454.html
文化庁日本遺産ポータル『近世日本の教育遺産群』 | https://japan-heritage.bunka.go.jp/ja/stories/story001/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("ヘルバルト（Herbart, J. F.）の教育思想及びヘルバルト派の教授理論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教育の目的を知識量の増大と職業的技能の獲得だけに置き、道徳的品性の形成を家庭や宗教の領域に委ねた。したがって、教授が生徒の意志や行為に影響することを避け、価値から中立な知識伝達を理想とした。"),
      text_choice.call("イ", "統覚とは、新しい表象を既有の表象から切り離し、過去の経験を意識から排除して受け入れる過程であるとした。そのため、教師は生徒の既有知識や興味を確認せず、未知の教材を最初から提示するべきだと考えた。"),
      text_choice.call("ウ", "予備・提示・比較・総括・応用という五段階教授法を、ヘルバルト自身が変更不可能な授業手順として完成させた。ヘルバルトが示した明瞭・連合・系統・方法という四つの契機は、この五段階教授法とは無関係であり、後世のヘルバルト派には継承されなかった。"),
      text_choice.call("エ", "教育の中心的な目的を道徳的品性の形成に置き、教授を通じて多面的な興味を育てようとした。新しい表象が既有の表象群と関連付けられて理解される統覚を重視し、明瞭・連合・系統・方法という教授上の契機は、後にツィラーやラインらによって五段階教授法へ展開された。", true),
    ],
    explanation_blocks: [
      text_block.call("エが適切です。アは、ヘルバルトが教育の目的を道徳性から切り離したとしている点が誤りです。ヘルバルトは道徳的品性の形成を教育の中心に据えました。イは、統覚を既有の表象や経験から切り離す過程としている点が誤りです。統覚は、新しい表象が既有の表象群と結び付いて理解される過程を指します。ウは、ヘルバルト本人と後世のヘルバルト派の理論を取り違えています。ヘルバルト自身が示したのは明瞭・連合・系統・方法という四つの契機であり、予備・提示・比較・総括・応用の五段階教授法は、ツィラーやラインらによる展開です。エは、道徳的品性、多面的興味、統覚、ヘルバルト本人の理論と後世の五段階教授法との関係を正しく説明しています。"),
    ],
    source_text: "ヘルバルト著、三枝孝弘訳『一般教育学』（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000001-I40111100048707
共栄学園短期大学研究紀要第16号『ヘルバルト派の形式的教授段階』 | https://kyoei.repo.nii.ac.jp/record/484/files/KJ00000173172.pdf",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次の①～④は，「教育基本法」（平成18年法律第120号）第10条から第12条までに関する記述である。正しいものはいくつあるか。下のア～エの中から一つ選んで記号で答えなさい。\n① 父母その他の保護者は、子の教育について第一義的責任を有し、生活に必要な習慣を身に付けさせるとともに、自立心を育成し、心身の調和のとれた発達を図るよう努めるものとされている。\n② 国及び地方公共団体は、家庭教育の自主性を尊重しつつ家庭教育を支援する施策を講ずる義務を負い、条文は「必要な施策を講じなければならない」と規定している。\n③ 幼児期の教育は生涯にわたる人格形成の基礎を培う重要なものであり、国及び地方公共団体は、良好な環境の整備その他適当な方法によって、その振興に努めなければならない。\n④ 国及び地方公共団体が社会教育の振興に用いる方法には、図書館、博物館及び公民館等の設置や学習機会・情報の提供が含まれるが、学校施設の利用は学校教育との区別から含まれない。"),
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "ない"),
    ],
    explanation_blocks: [
      text_block.call("正しいものは①と③の二つであるため、正答はイです。①は第10条第1項と一致します。②は誤りです。第10条第2項は「必要な施策を講ずるよう努めなければならない」とする努力義務であり、「講じなければならない」とは規定していません。③は第11条と一致します。④は誤りです。第12条第2項は、社会教育振興の方法として「学校の施設の利用」も明記しています。ア、ウ、エは正しい記述の数と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第10条～第12条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第61条　高等学校に、全日制の課程、定時制の課程又は通信制の課程のうち{{①}}の課程を置くときは、それぞれの課程に関する{{②}}を分担して整理する{{③}}を置かなければならない。ただし、命を受けて当該課程に関する校務をつかさどる{{④}}が置かれる一の課程については、この限りでない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["二以上", "校務", "教頭", "副校長"], true),
      fill_in_choice.call("イ", ["二以上", "教育課程", "副校長", "教頭"]),
      fill_in_choice.call("ウ", ["三以上", "校務", "教頭", "主幹教諭"]),
      fill_in_choice.call("エ", ["三以上", "学校運営", "副校長", "主幹教諭"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。第61条は、高等学校に二以上の課程を置く場合、原則として各課程の校務を分担して整理する教頭を置くことを求めます。ただし、当該課程の校務をつかさどる副校長が置かれる一の課程は例外となります。イは教頭と副校長の役割を逆にし、「校務」を「教育課程」としている点が誤りです。ウは「二以上」を「三以上」、「副校長」を「主幹教諭」としている点が誤りです。エは必要な課程数、職務及び職名のいずれも原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第61条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第22条の5　公立の小学校等の校長及び教員の{{①}}は、{{②}}で定めるところにより、当該校長及び教員ごとに、研修の受講その他の当該校長及び教員の{{③}}のための取組の状況に関する記録（以下この条及び次条第二項において「{{④}}」という。）を作成しなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["指導助言者", "政令", "職務能率の増進", "研修受講記録"]),
      fill_in_choice.call("イ", ["任命権者", "条例", "服務規律の確保", "職務履歴"]),
      fill_in_choice.call("ウ", ["任命権者", "文部科学省令", "資質の向上", "研修等に関する記録"], true),
      fill_in_choice.call("エ", ["研修実施者", "教育委員会規則", "勤務成績の評定", "研修計画"]),
    ],
    explanation_blocks: [
      text_block.call("ウが原文と一致します。研修等に関する記録を作成するのは任命権者であり、その方法は文部科学省令で定められます。記録の対象は、研修の受講その他の資質の向上のための取組状況です。アは作成主体、根拠法令、記録の目的及び名称が異なります。イは根拠を条例とし、服務規律に関する職務履歴としている点が誤りです。エは作成主体を研修実施者とし、勤務成績の評定や研修計画としている点が原文と異なります。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第22条の5 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "児童生徒が自殺をほのめかしたり、深刻な自傷行為に及んだり、遺書のような手紙やメモを残して家出をしたりといった状況は、自殺やその他の重大な危険行為の「予兆」段階であると捉える必要があります。そのときには、教育相談体制の構成メンバーを基盤に、校長をリーダーとする「{{①}}」を組織し、危険度に応じた対応を行います（{{②}}）。\n\n児童生徒との関わりが密接な学級・ホームルーム担任や部活動顧問などを加え、アセスメントに基づいて対応方針や役割分担を決定し、緊密に「報告・連絡・相談」を行うことを心がけます。その際、誰が児童生徒や保護者と直接関わるのが適切なのかを見極め、その人を中心としてチームで対応します。平常時に、危機対応のための態勢づくりやマニュアルづくりなどを進めておくことが大切です。\n\n実際に自殺や自殺未遂が発生した場合には、校長のリーダーシップの下、「{{①}}」を中心に、教育委員会等や専門家、関係機関のサポートを受けながら、全教職員の力を結集して対応することが必要です（{{③}}）。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["校内連携型支援チーム", "クライシスマネジメント", "リスクマネジメント"]),
      fill_in_choice.call("イ", ["校内連携型危機対応チーム", "リスクマネジメント", "クライシスマネジメント"], true),
      fill_in_choice.call("ウ", ["ネットワーク型緊急支援チーム", "リスクマネジメント", "クライシスマネジメント"]),
      fill_in_choice.call("エ", ["校内連携型危機対応チーム", "クライシスマネジメント", "リスクマネジメント"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。自殺等の予兆段階では、校内連携型危機対応チームを組織してリスクマネジメントを行い、実際に自殺又は自殺未遂が発生した場合にはクライシスマネジメントとして対応します。アはチーム名が異なる上、二つのマネジメントを逆にしています。ウのネットワーク型緊急支援チームは、学校や地域に重大な混乱を招く危険性のある事態で関係機関等と危機対応に当たる形態ですが、この箇所で校長を中心に組織するとされるチーム名ではありません。エは①のみ一致し、②と③が逆です。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第8章8.2.2「自殺のリスクマネジメントとクライシスマネジメント」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("肢体不自由のある生徒の状態の把握と教育的対応に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "同じ診断名の生徒には同程度の運動・動作上の困難が生じるため、診断名に応じて体育、実験、実習などへの参加範囲を一律に定めることが望ましい。"),
      text_choice.call("イ", "知能検査の得点が低い場合には、運動面や言語表出面の制約を考慮せず、その得点を生徒の知的能力そのものとして評価する。"),
      text_choice.call("ウ", "自立を促すためには、筆記用具の加工、補装具、情報機器などに頼らず、自力だけで動作を完了させることを優先する。援助を受けて活動できることは、自立の評価には含めない。"),
      text_choice.call("エ", "姿勢、移動、筆記等の速度・正確さ・持続性、休息の必要性などを具体的に把握する。必要に応じて用具の形状や教材の提示方法を調整し、補装具や情報機器等を活用して、学習活動への参加と本人の意思表出を支える。", true),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。肢体不自由の状態や必要な支援は一人一人異なるため、診断名だけで活動範囲を一律に決めません。イは適切ではありません。検査結果には運動面や言語表出面の困難が影響することがあるため、検査方法や反応手段を考慮して評価します。ウは適切ではありません。補助的手段を適切に活用して主体的に活動できることも、自立を支える重要な要素です。エが適切です。動作の可否だけでなく、速度、正確さ、持続性、姿勢、疲れやすさなどを把握し、支援技術や環境調整によって参加を保障します。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編「障害の状態等に応じた教育的対応」肢体不自由 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_08.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ピアジェの認知発達理論における青年期の思考に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "形式的操作期には、現実に観察された事実だけでなく、起こり得る可能性を仮定し、そこから論理的な結論を導く思考が可能になる。複数の条件を体系的に組み合わせ、関連する要因を特定したり、比例関係を理解したりする思考も発達するが、その習得時期や程度には課題領域や個人による違いがある。", true),
      text_choice.call("イ", "形式的操作期には、保存、分類、系列化などの論理的操作が初めて可能になるが、推論の対象は直接操作できる具体物に限られ、現実に反する仮定や抽象的な命題を扱うことはできない。"),
      text_choice.call("ウ", "形式的操作期には、言語やイメージを用いて対象を表象できるようになる一方、一つの目立つ特徴だけに注意が集中する中心化や、操作を逆方向にたどれない不可逆性が思考の中心となる。"),
      text_choice.call("エ", "形式的操作期は生物学的成熟だけによって全ての青年に同じ年齢で成立するため、文化的経験、教育、課題への習熟度にかかわらず、形式的操作を必要とする全ての課題を同じ時期から遂行できるようになる。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。形式的操作期では、現実だけでなく可能性を扱い、仮説から結論を導く仮説演繹的思考が可能になります。組合せ的思考、関連要因の発見、比例概念なども特徴とされます。ただし、形式的操作の現れ方には個人差や課題領域による違いがあります。イは適切ではありません。保存、分類、系列化などを具体的な事物について行えるのは、主として具体的操作期の特徴です。形式的操作期には、抽象的な命題や仮定も扱えるようになります。ウは適切ではありません。言語やイメージによる表象、中心化及び不可逆性は、主として前操作期の特徴です。エは適切ではありません。形式的操作の発達には個人差があり、経験している領域、文化的環境、教育、課題内容などによって遂行の程度が異なり得ます。一定の年齢になれば全員があらゆる課題で一律に形式的操作を行えるという意味ではありません。"),
    ],
    source_text: "筑波大学学術リポジトリ掲載資料『青年期の知的発達』 | https://tsukuba.repo.nii.ac.jp/record/31168/files/DA06697.pdf\n大阪教育大学学術リポジトリ『発達段階と発達課題』 | https://osaka-kyoiku.repo.nii.ac.jp/record/2063602/files/kano_069707.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ソーンダイクの学習理論に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "ネコを問題箱に入れ、試行を重ねるにつれて脱出に要する時間が徐々に短くなることを示し、成功に至るまでの試行錯誤によって学習が成立すると考えた。"),
      text_choice.call("イ", "チンパンジーが箱を積んだり複数の棒を組み合わせたりして餌を取る行動を観察し、問題状況の全体的な関係が再構成されることで、解決が突然成立する洞察学習を提唱した。", true),
      text_choice.call("ウ", "ある状況で生じた反応に満足をもたらす結果が伴うと、その状況と反応との結合が強められ、反対に不満足をもたらす結果が伴うと結合が弱められるという効果の法則を示した。"),
      text_choice.call("エ", "刺激となる状況と反応との結合を学習の基本単位とする結合主義の立場を採り、初期の学習法則として、準備の法則、練習の法則、効果の法則を整理した。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。問題箱からの脱出時間が試行とともに徐々に短縮されたことが、試行錯誤学習の根拠となりました。イが適切ではありません。チンパンジーを用いた実験から洞察学習を提唱したのはケーラーです。ソーンダイクの問題解決は、突然の洞察よりも、試行錯誤による漸進的な学習として説明されました。ウは適切です。これは効果の法則の説明であり、後のオペラント条件づけにも影響を与えました。エは適切です。ソーンダイクは刺激と反応との結合を重視し、初期の体系では準備、練習、効果の三法則を示しました。なお、後に練習の法則などには修正を加えています。"),
    ],
    source_text: "東京大学先端科学技術研究センター講義資料『試行錯誤学習と効果の法則』 | https://www.brain.rcast.u-tokyo.ac.jp/education/class/2015-tsukuba/tsukuba-2.pdf\n日本大学教育学会掲載論文『ソーンダイクの結合主義学習論』 | https://www.jstage.jst.go.jp/article/nihondaigakukyouikugakkai/26/0/26_KJ00009738982/_pdf/-char/ja",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された高等学校のスクール・ミッション及びスクール・ポリシーに関する記述である。最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "スクール・ミッションは，校長のリーダーシップの下，全教職員が当事者意識をもって策定し，学校の設置者へ報告する。スクール・ポリシーは，設置者が学校や地方公共団体等の関係者と連携して策定し，各高等学校の教育活動を評価するための共通の指針とする。"),
      text_choice.call("イ", "学校の設置者は，生徒の状況や学校の歴史，地域の実情，将来の社会像等を踏まえてスクール・ミッションを再定義する。各高等学校はこれに基づき，育成を目指す資質・能力，教育課程の編成及び実施，教育活動の評価及び改善に関する三つの方針をスクール・ポリシーとして策定・公表する。"),
      text_choice.call("ウ", "学校の設置者は，学校や地方公共団体等の関係者と連携してスクール・ミッションを再定義する。各高等学校はこれに基づき，育成を目指す資質・能力，教育課程の編成及び実施，入学者の受入れに関する三つのスクール・ポリシーを策定・公表し，それを起点としてカリキュラム・マネジメントを行う。", true),
      text_choice.call("エ", "各高等学校は，現在行っている教育活動と入学者選抜の状況を整理して三つのスクール・ポリシーを策定する。設置者は，複数の学校が策定した方針と地域の将来像を総合し，各学校の存在意義や社会的役割をスクール・ミッションとして明確化する。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切です。スクール・ミッションの再定義は各学校の設置者が行い，三つのスクール・ポリシーは各高等学校が策定・公表します。スクール・ポリシーは，①育成を目指す資質・能力に関する方針，②教育課程の編成及び実施に関する方針，③入学者の受入れに関する方針です。アは，スクール・ミッションとスクール・ポリシーの策定主体を入れ替えています。校長のリーダーシップと全教職員の参画は，スクール・ポリシーの策定過程について示された内容です。イは，三つ目の方針を「教育活動の評価及び改善に関する方針」としている点が誤りです。正しくは「入学者の受入れに関する方針」です。エは，策定の基礎となる関係を逆にしています。スクール・ミッションに基づいて各高等学校がスクール・ポリシーを策定します。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅱ部 各論3（2）①「各高等学校の存在意義・社会的役割等の明確化」・②「各高等学校の入口から出口までの教育活動の指針の策定」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第3款 各科目にわたる指導計画の作成と内容の取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "各科目の指導においては，情報の{{①}}や{{②}}を見極めたり確保したりする能力の育成を図るとともに，知的財産や個人情報の{{③}}をはじめ，科学的な理解に基づく{{④}}の育成を図ること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["正確性", "客観性", "保護と管理", "情報倫理"]),
      fill_in_choice.call("イ", ["信頼性", "妥当性", "保護と利用", "情報セキュリティ"]),
      fill_in_choice.call("ウ", ["信頼性", "信憑性", "保護と活用", "情報モラル"], true),
      fill_in_choice.call("エ", ["完全性", "可用性", "管理と共有", "情報リテラシー"]),
    ],
    explanation_blocks: [text_block.call("ウが原文と一致します。情報の信頼性や信憑性を見極めたり確保したりする能力を育て，知的財産や個人情報の保護と活用をはじめ，科学的な理解に基づく情報モラルを育成します。アの正確性・客観性・保護と管理・情報倫理，イの妥当性・保護と利用・情報セキュリティ，エの完全性・可用性・管理と共有・情報リテラシーは原文の組合せではありません。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）』第2章第10節第3款2（1） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）の「第1部 各学科に共通する教科『情報』 第2章 共通教科情報科の各科目 第1節 情報Ⅰ」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "アルゴリズムを表現する手段，プログラミングによってコンピュータや情報通信ネットワークを活用する方法について理解し技能を身に付けることでは，コンピュータを効率よく活用するために，アルゴリズムを文章，{{①}}，アクティビティ図などによって表現する方法，データや{{②}}，プログラムの構造，外部のプログラムとの連携を含めたプログラミングについて理解するとともに，必要な技能を身に付けるようにする。その際，アルゴリズムによって処理の結果や{{③}}に違いが出ること，アルゴリズムを{{④}}ことの重要性，プログラミングの意義や可能性について理解するようにする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["フローチャート", "データ構造", "効率", "正確に記述する"], true),
      fill_in_choice.call("イ", ["状態遷移図", "データ型", "実行時間", "簡潔に記述する"]),
      fill_in_choice.call("ウ", ["ユースケース図", "データモデル", "可読性", "構造的に設計する"]),
      fill_in_choice.call("エ", ["クラス図", "配列", "再利用性", "論理的に説明する"]),
    ],
    explanation_blocks: [text_block.call("アが原文と一致します。アルゴリズムは文章，フローチャート，アクティビティ図などで表現し，データやデータ構造とプログラムの構造を扱います。アルゴリズムにより結果や効率に違いが出ること，正確に記述する重要性を理解します。イは，状態遷移図，データ型，実行時間，簡潔に記述するの全てが原文と異なります。ウは，ユースケース図，データモデル，可読性，構造的に設計するが原文の語句ではありません。エは，クラス図，配列，再利用性，論理的に説明するとする点が原文と異なります。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第1部第2章第1節2（3） | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文は，「高等学校学習指導要領（平成30年告示）解説 情報編」（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科『情報』 第2章 専門教科情報科の各科目 第5節 情報セキュリティ」に示された内容に基づく記述である。文中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "情報セキュリティ対策として，{{①}}セキュリティ対策，{{②}}セキュリティ対策，{{③}}セキュリティ対策を扱う。{{①}}については情報セキュリティの啓発など，{{②}}については不正アクセスや不正プログラムなど，{{③}}については情報を扱う場所の入退室管理などを扱う。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["技術的", "人的", "物理的"]),
      fill_in_choice.call("イ", ["人的", "技術的", "物理的"], true),
      fill_in_choice.call("ウ", ["人的", "物理的", "技術的"]),
      fill_in_choice.call("エ", ["物理的", "技術的", "人的"]),
    ],
    explanation_blocks: [text_block.call("イが示された内容と一致します。情報セキュリティの啓発は人的セキュリティ対策，不正アクセスや不正プログラムへの対応は技術的セキュリティ対策，入退室管理は物理的セキュリティ対策です。アは，啓発を技術的対策，不正アクセス等への対応を人的対策とする点が逆です。ウは，不正アクセス等への対応を物理的対策，入退室管理を技術的対策とする点が逆です。エは，啓発を物理的対策，入退室管理を人的対策としており，①と③の対応が異なります。")],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』第2部第2章第5節2（3） | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 3, 4, 5, 11, 12, 13, 14, 15, 16, 17, 18]
  raise "作成中の模擬試験8には承認済みの問1から問5、問11から問18だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験8 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験8 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
      raise "模擬試験8 問#{question.fetch(:question_number)}の空欄数と選択肢セル数が一致しません"
    end
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 8,
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
      raise "模擬試験8 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

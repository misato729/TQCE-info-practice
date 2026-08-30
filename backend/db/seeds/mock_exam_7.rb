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

# 模擬試験7は分野別に作成中のため、全20問がそろうまでは承認済みの問題も
# 下書きとして保存し、一般向けの問題一覧には公開しない。
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("中世の足利学校に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "足利学校の創建時期には奈良時代、平安時代、鎌倉時代などの諸説があるが、歴史上の具体像が明確になるのは、室町時代に関東管領上杉憲実が書籍や学田を寄進し、僧の快元を招いて学校を再興してからである。戦国期にも学問の拠点として栄え、フランシスコ・ザビエルによって海外に紹介された。", true),
      text_choice.call("イ", "足利学校は奈良時代に地方官人を養成する国学として創設されたことが史料上確定しており、律令制の衰退後も一貫して朝廷の直轄学校として運営された。上杉憲実は学校を廃止し、その蔵書を鎌倉の寺院へ移した人物である。"),
      text_choice.call("ウ", "上杉憲実は15世紀に足利学校を再興したが、その際に江戸の林羅山を初代庠主として招き、朱子学以外の易学、兵学、本草学などを禁じた。この方針が後の寛政異学の禁へ直接引き継がれた。"),
      text_choice.call("エ", "ザビエルは足利学校を「坂東の大学」として紹介しただけでなく、自ら学校を創設して初代庠主となり、ラテン語とキリスト教神学を中心とする宣教師養成機関へ改編した。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。足利学校の創建時期には諸説がありますが、上杉憲実による再興以後の歴史は比較的明確です。憲実は書籍や学田を寄進し、僧の快元を庠主として学校経営に当たらせました。イは、奈良時代の国学を起源とする説を確定した事実としている点と、上杉憲実を廃止者としている点が誤りです。ウは、江戸時代初期の林羅山を15世紀に招いたとしている時代関係が成り立たず、足利学校で易学、兵学、本草学などが学ばれたこととも反します。エは、ザビエルを創設者・庠主としている点が誤りです。ザビエルは足利学校の評判を海外へ伝えましたが、学校を宣教師養成機関へ改編したわけではありません。"),
    ],
    source_text: "足利市『史跡足利学校』 | https://www.city.ashikaga.tochigi.jp/education/000031/
文化庁日本遺産ポータル『足利学校跡』 | https://japan-heritage.bunka.go.jp/ja/culturalproperties/result/25/",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      text_block.call("クインティリアヌス（Quintilian）の教育思想に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "『弁論家の教育』では、弁論術の技法だけでなく、幼児期から完成された弁論家に至るまでの教育過程を扱った。理想の弁論家には優れた話術とともに徳性が必要であり、「善き人」であることを弁論家の重要な条件とした。"),
      text_choice.call("イ", "家庭での個人教授と学校教育を比較し、道徳上の危険が家庭にも学校にも存在し得ることを認めた上で、他者の長所や誤りから学び、仲間と競いながら公的生活に慣れることのできる学校教育を支持した。"),
      text_choice.call("ウ", "子供は理性的な説得では十分に規律を身に付けられないため、教師には日常的な鞭打ちと無制限の懲戒権を認めるべきであるとした。恐怖による服従を、将来の自由な市民と弁論家を形成する最も確実な方法と位置付けた。", true),
      text_choice.call("エ", "幼い子供の学習では、能力を超える課題を一度に課すことを避け、遊びや競争を取り入れることを認めた。文字の学習に象牙製の文字を用いるなど、子供が興味をもって扱える教材についても言及した。"),
    ],
    explanation_blocks: [
      text_block.call("ウが適切でない記述です。アは適切です。クインティリアヌスは教育を弁論技法だけに限定せず、徳性を備えた理想的弁論家の形成として捉えました。イも適切です。学校の危険を無視したのではなく、家庭教育にも同様の問題があり得るとした上で、仲間の長所や誤りから学び、公的生活へ備えられる学校教育の利点を論じています。ウは誤りです。クインティリアヌスは鞭打ちを、自由人にふさわしくない屈辱的な罰であり、恐怖や羞恥によって子供の精神を損なうものとして批判しました。エは適切です。子供の受容可能な量を考慮すること、休息や教育的な遊びを認めること、文字を楽しく扱える教材を用いることなどを述べています。"),
    ],
    source_text: "クインティリアヌス著、森谷宇一ほか訳『弁論家の教育1』第1巻第1章〜第3章（国立国会図書館書誌情報） | https://ndlsearch.ndl.go.jp/books/R100000002-I000007736785",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      {
        type: "fill_in_text",
        text: "次の文章は，「教育基本法」（平成18年法律第120号）の「第6条 学校教育」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。",
      },
      {
        type: "fill_in_quote",
        text: "第6条　法律に定める学校は、{{①}}を有するものであって、国、地方公共団体及び{{②}}のみが、これを設置することができる。\n2　前項の学校においては、教育の目標が達成されるよう、教育を受ける者の{{③}}に応じて、体系的な教育が{{④}}に行われなければならない。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["公共的性格", "学校法人", "年齢", "計画的"]),
      fill_in_choice.call("イ", ["公の性質", "法律に定める法人", "心身の発達", "組織的"], true),
      fill_in_choice.call("ウ", ["公の性質", "公益法人", "能力及び適性", "段階的"]),
      fill_in_choice.call("エ", ["公益性", "法律に定める法人", "個性", "継続的"]),
    ],
    explanation_blocks: [
      text_block.call("イが原文と一致します。教育基本法第6条の語句は「公の性質」「法律に定める法人」「心身の発達」「組織的」です。アの「公共的性格」「学校法人」「年齢」「計画的」はいずれも原文の表現ではありません。ウは設置主体を公益法人に限定し、教育を受ける者の能力及び適性に応じるとしている点が異なります。エは「公益性」「個性」「継続的」が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『教育基本法』第6条 | https://laws.e-gov.go.jp/law/418AC0000000120",
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
        text: "第57条　高等学校に入学することのできる者は、{{①}}若しくはこれに準ずる学校若しくは{{②}}を卒業した者若しくは中等教育学校の{{③}}を修了した者又は文部科学大臣の定めるところにより、これと{{④}}があると認められた者とする。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["小学校", "義務教育学校", "前期課程", "同等以上の学力"]),
      fill_in_choice.call("イ", ["中学校", "高等学校", "後期課程", "同等以上の学力"]),
      fill_in_choice.call("ウ", ["中学校", "義務教育学校", "後期課程", "同程度の学力"]),
      fill_in_choice.call("エ", ["中学校", "義務教育学校", "前期課程", "同等以上の学力"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。高等学校への入学資格として、中学校若しくはこれに準ずる学校若しくは義務教育学校の卒業、中等教育学校の前期課程の修了又はこれと同等以上の学力が認められることが定められています。アは小学校卒業としている点が誤りです。イは義務教育学校を高等学校、中等教育学校の前期課程を後期課程としている点が誤りです。ウは前期課程を後期課程とし、「同等以上」を「同程度」としている点が原文と一致しません。"),
    ],
    source_text: "e-Gov法令検索『学校教育法』第57条 | https://laws.e-gov.go.jp/law/322AC0000000026",
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
        text: "第17条　教育公務員は、教育に関する{{①}}を兼ね、又は教育に関する他の事業若しくは事務に従事することが{{②}}の遂行に支障がないと{{③}}（地方教育行政の組織及び運営に関する法律第三十七条第一項に規定する県費負担教職員（以下「県費負担教職員」という。）については、市町村（特別区を含む。以下同じ。）の教育委員会）において認める場合には、{{④}}を受け、又は受けないで、その職を兼ね、又はその事業若しくは事務に従事することができる。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["他の職", "本務", "任命権者", "給与"], true),
      fill_in_choice.call("イ", ["他の職", "校務", "所属長", "報酬"]),
      fill_in_choice.call("ウ", ["営利企業の役員", "本務", "人事委員会", "給与"]),
      fill_in_choice.call("エ", ["他の職", "職務専念義務", "任命権者", "報酬"]),
    ],
    explanation_blocks: [
      text_block.call("アが原文と一致します。教育公務員は、教育に関する他の職の兼職等が本務の遂行に支障がないと任命権者に認められた場合、給与を受ける場合も受けない場合も兼職等ができます。イは「本務」を「校務」、「任命権者」を「所属長」、「給与」を「報酬」としている点が誤りです。ウは対象を営利企業の役員とし、認定者を人事委員会としている点が誤りです。エは判断対象を「職務専念義務の遂行」とし、「給与」を「報酬」としている点が原文と異なります。"),
    ],
    source_text: "e-Gov法令検索『教育公務員特例法』第17条 | https://laws.e-gov.go.jp/law/324AC0000000001",
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
        text: "法の見直し規定を踏まえ、平成29年に国の基本方針の改定が行われ、改めて学校のいじめ対応の基本的な在り方が示されました。重点事項は次のとおりです。\n\n・けんかやふざけ合いであっても、見えないところで被害が発生している場合もあることから、丁寧に調査した上でいじめに当たるか否かを判断する。\n・いじめは、{{①}}をもって安易に「解消」とすることはできない。\n・いじめが解消している状態とは、①被害者に対する心理的又は物理的な影響を与える行為が止んでいる状態が相当の期間（{{②}}が目安）継続している、②被害者が{{③}}（本人や保護者の面談等で心身の苦痛を感じていないかどうか確認する）、という二つの要件が満たされていることを指す。",
      },
    ],
    choices: [
      fill_in_choice.call("ア", ["単に謝罪", "１か月", "通常どおり登校している"]),
      fill_in_choice.call("イ", ["対策組織への報告", "６か月", "加害者との関係が修復している"]),
      fill_in_choice.call("ウ", ["保護者間の合意", "３か月", "心身の苦痛を受けていない"]),
      fill_in_choice.call("エ", ["単に謝罪", "３か月", "心身の苦痛を受けていない"], true),
    ],
    explanation_blocks: [
      text_block.call("エが原文と一致します。いじめは単に謝罪をもって解消とせず、行為が止んでいる状態がおおむね3か月継続していることと、被害者が心身の苦痛を受けていないことの両方を確認します。アは①のみ一致し、継続期間と確認内容が誤りです。イは、対策組織への報告や加害者との関係修復そのものを解消要件とする点が原文と異なります。ウは②・③が一致しますが、保護者間の合意だけで解消を判断することはできません。"),
    ],
    source_text: "文部科学省『生徒指導提要』（令和4年12月）第4章4.1.3「国の基本方針の策定」 | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      text_block.call("注意欠陥多動性障害又は注意欠如・多動症（ADHD）のある生徒の状態の把握と支援に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "授業中に不注意や離席が一度でも見られれば、その教科を担当する教師がADHDと判断できる。家庭や他の授業における様子は、学校での支援方針を検討する際には考慮しない。"),
      text_choice.call("イ", "年齢又は発達に不釣り合いな不注意、衝動性、多動性が持続し、学業や社会生活に支障を生じているかを、家庭と学校など複数の場面から把握する必要がある。支援では、指示を分かりやすく示し、課題や環境を調整するとともに、努力や長所を具体的に認めることが重要である。", true),
      text_choice.call("ウ", "不注意や衝動的な行動は、本人の努力不足によって生じることが多い。繰り返し注意や叱責を与え、失敗に対する責任を本人に自覚させることを支援の中心とする。"),
      text_choice.call("エ", "LD又はASDの特徴が認められた場合には、ADHDが併存する可能性を除外できる。そのため、不注意や多動性についての情報を改めて収集する必要はない。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切ではありません。特定の授業だけで即断せず、行動の持続性、複数場面での状態、学習・生活への影響などを把握します。教師が医学的診断を行うものでもありません。イが適切です。状態把握と支援の双方を正しく説明しています。叱責に偏らず、分かりやすい指示、視覚的な手掛かり、課題量や環境の調整、肯定的な評価などを組み合わせます。ウは適切ではありません。行動を単なる怠慢と捉えて叱責を重ねると、自信や自己評価を低下させるおそれがあります。エは適切ではありません。ADHD、LD、ASDの特徴は併存する場合があり、一つの障害の可能性だけで他を除外できません。"),
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編「障害の状態等に応じた教育的対応」注意欠陥多動性障害 | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_14.pdf",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ハヴィガーストの発達課題に関する記述として、適切でないものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "発達課題は、人生の特定の時期に生じる課題であり、その達成は本人の幸福や後の課題の達成につながる一方、達成できない場合は本人の不幸や社会からの承認の得にくさ、後の課題の困難につながると考えられた。"),
      text_choice.call("イ", "発達課題の起源には、身体的成熟、社会や文化からの期待・圧力、個人の価値観や願望などがあり、発達課題は生物学的な成熟だけによって一律に決まるものではないとされた。"),
      text_choice.call("ウ", "発達課題は、文化、時代、社会的役割及び個人の価値観とは無関係に、人類に共通する内容と達成年齢が固定されているため、全ての者が同一の順序と時期で達成しなければならないとされた。", true),
      text_choice.call("エ", "青年期の発達課題には、自己の身体の受容、同年齢者との成熟した関係、親からの情緒的自立、職業選択への準備、社会的に責任ある行動及び行動の指針となる価値体系の形成などが含まれる。"),
    ],
    explanation_blocks: [
      text_block.call("アは適切です。ハヴィガーストは、ある時期の発達課題の達成が、本人の幸福や後続する課題の達成に関係すると考えました。イは適切です。発達課題は、身体的成熟だけでなく、社会文化的要求及び個人の価値・願望からも生じます。ウが適切ではありません。発達課題には社会や文化、時代、個人の価値観などが影響し、全ての者に共通する固定的な達成年齢を示した理論ではありません。エは適切です。これらはハヴィガーストが青年期に位置付けた主要な発達課題です。"),
    ],
    source_text: "東京家政大学『中学生・高校生の自立とハヴィガーストの発達課題』 | https://www.tokyo-kasei.ac.jp/research/woman/2016_iaw.pdf\n大阪教育大学学術リポジトリ『ハヴィガーストの発達課題』 | https://osaka-kyoiku.repo.nii.ac.jp/record/2063602/files/kano_069707.pdf",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      text_block.call("ブルーナーの学習理論及び教育課程論に関する記述として、最も適切なものを、次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "教材の構造を学習者が自ら発見する発見学習を重視し、基本的な概念を発達段階に応じた表現で繰り返し学ぶ螺旋型カリキュラムを提唱した。また、知識の表象を活動的表象、映像的表象、記号的表象に整理した。", true),
      text_choice.call("イ", "学習内容よりも一般的で包括的な先行オーガナイザーを授業の冒頭で提示し、新しい内容を既有の認知構造へ取り込ませる有意味受容学習を、発見学習の中心的方法として提唱した。"),
      text_choice.call("ウ", "子どもが一定の認知発達段階へ自然に到達するまでは、その段階を超える内容を教えるべきではないとし、基本概念を一度だけ完全に学習させる直線型の教育課程を提唱した。"),
      text_choice.call("エ", "活動的表象、映像的表象、記号的表象は、年齢に応じて不可逆的に置き換わる三つの発達段階であり、記号的表象を獲得した成人は、活動や映像による表象を用いなくなるとした。"),
    ],
    explanation_blocks: [
      text_block.call("アが適切です。発見学習、教材の構造、螺旋型カリキュラム、三つの表象形式はいずれもブルーナーに関係します。イは適切ではありません。先行オーガナイザーと有意味受容学習を提唱したのはオーズベルであり、ブルーナーの発見学習とは区別されます。ウは適切ではありません。ブルーナーは、教材の表現方法を適切にすれば、どの発達段階の子どもにも、その教科の基本的構造を教えられると考えました。また、基本概念を繰り返し扱う螺旋型カリキュラムを提唱しました。エは適切ではありません。三つの表象形式は、後の形式が現れると以前の形式が失われるような、相互排他的で不可逆的な段階ではありません。成人も活動や映像による表象を用います。"),
    ],
    source_text: "宮崎大学教職大学院年報『ブルーナーの表象理論』 | https://www.miyazaki-u.ac.jp/edu/graduate/kyosyokudaigakuinnenpou01.pdf\n京都大学教育学部紀要『発見学習について』 | https://repository.kulib.kyoto-u.ac.jp/dspace/bitstream/2433/282382/1/eda21_010.pdf\n熊本大学『先行オーガナイザ』 | https://www.gsis.kumamoto-u.ac.jp/opencourses/pf/3Block/08/08-1_text.html",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      text_block.call("次のア～エは，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）に示された履修主義，修得主義，年齢主義及び課程主義と，学校教育における取扱いとの対応を，「指導の個別化」に生かす考え方／「学習の個性化」に生かす考え方／「協働的な学び」に生かす考え方／義務教育の進級・卒業要件の基本／高等学校で相対的に多く取り入れられている考え方，の順に並べたものである。答申の内容と一致する組合せとして最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。"),
    ],
    choices: [
      text_choice.call("ア", "修得主義／修得主義と履修主義／履修主義／課程主義／修得主義と課程主義"),
      text_choice.call("イ", "修得主義／修得主義と履修主義／履修主義／年齢主義／修得主義と課程主義", true),
      text_choice.call("ウ", "履修主義／修得主義と履修主義／履修主義／年齢主義／修得主義と課程主義"),
      text_choice.call("エ", "修得主義／修得主義と履修主義／修得主義／年齢主義／履修主義と年齢主義"),
    ],
    explanation_blocks: [
      text_block.call("イが正しい組合せです。答申では，個々人の学習状況や成果を重視する修得主義を「指導の個別化」に生かします。「学習の個性化」には，修得主義と，一定期間の中で多様な成長を許容する履修主義を組み合わせます。「協働的な学び」には，一定期間をかけて集団へ教育を行う履修主義を生かします。義務教育の進級・卒業要件では年齢主義を基本としつつ，教育課程を履修したと判断する基準には履修主義と修得主義を組み合わせます。高等学校では，単位の修得認定や原級留置の運用があるため，修得主義・課程主義の要素が相対的に多く取り入れられています。アは，義務教育の進級・卒業要件の基本を課程主義としている点が誤りです。ウは，「指導の個別化」に生かす考え方を履修主義としている点が誤りです。エは，「協働的な学び」を修得主義に対応させ，高等学校で相対的に多い考え方を履修主義・年齢主義としている点が誤りです。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』第Ⅰ部 総論4（4）「履修主義・修得主義等を適切に組み合わせる」 | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == [1, 2, 3, 4, 5, 11, 12, 13, 14, 15]
  raise "作成中の模擬試験7には承認済みの問1から問5、問11から問15だけを登録してください"
end

questions.each do |question|
  choices = question.fetch(:choices)
  unless choices.size == 4 && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "模擬試験7 問#{question.fetch(:question_number)}の選択肢または正答数が不正です"
  end

  source_lines = question.fetch(:source_text).lines.map(&:strip).reject(&:empty?)
  unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
    raise "模擬試験7 問#{question.fetch(:question_number)}の出典リンク形式が不正です"
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
      raise "模擬試験7 問#{question.fetch(:question_number)}の空欄数と選択肢セル数が一致しません"
    end
  end
end

Question.transaction do
  questions.each do |attributes|
    choices = attributes.fetch(:choices)
    question_attributes = attributes.except(:choices)
    question = Question.find_or_initialize_by(
      exam_number: 7,
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
      raise "模擬試験7 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

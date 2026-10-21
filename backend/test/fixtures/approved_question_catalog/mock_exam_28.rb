text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験28（承認済みの全20問）
questions = [
  {
    question_number: 1,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "日本における障害のある子どもの教育の制度史について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。なお，学校などの名称は，当時の名称を用いている。" },
    ],
    choices: [
      text_choice.call("ア", "昭和22年の学校教育法は，盲学校，聾学校及び養護学校を位置付け，小学部・中学部への就学を義務とした。盲学校・聾学校では翌年度の新入学児から学年進行で義務制が実施され，養護学校では昭和54年に義務制が実施された。", true),
      text_choice.call("イ", "大正12年の盲学校及聾唖学校令は，北海道及び府県に盲学校・聾唖学校の設置を義務付け，公立校の初等部及び予科の授業料徴収を禁じた。この設置義務とともに，盲児・聾児の就学義務も同年から実施された。"),
      text_choice.call("ウ", "明治11年に京都で開設された盲唖院では，古河太四郎の指導の下で教育が行われた。その後，大正12年の盲学校及聾唖学校令は，盲教育と聾唖教育を一つの学校の共通課程に統合することを制度の基本とした。"),
      text_choice.call("エ", "昭和54年の養護学校の義務制実施は，それまで就学を猶予・免除されていた子どもの教育機会を保障する転機となった。都道府県に盲学校・聾学校を設置する義務が初めて法制化されたのも，この義務制実施の時期であった。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。昭和22年（1947年）の学校教育法上の規定と，盲・聾学校の昭和23年度（1948年度）からの学年進行，養護学校の昭和54年（1979年）の実施を区別している。"),
      text_block.call("イ：誤り。大正12年（1923年）の学校設置義務と，子どもの就学義務の実施は別である。盲・聾学校の義務制が実施され始めたのは戦後の昭和23年度。"),
      text_block.call("ウ：誤り。京都の盲唖院と古河の関係は適切だが，盲学校及聾唖学校令は，盲学校と聾唖学校の分立を確認した。共通課程への統合ではない。"),
      text_block.call("エ：誤り。養護学校の義務制実施の意義は適切だが，盲・聾学校の設置義務は大正12年の規定に遡る。昭和54年に初めて定められたものではない。"),
    ],
    source_text: "文部科学省『学制百二十年史』「第六節 特殊教育」・盲学校及聾唖学校令の制定（戦前期） | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318248.htm\n文部科学省『学制百二十年史』「第六節 特殊教育」・盲学校・聾学校教育の義務化 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318265.htm\n文部科学省『学制百二十年史』「二 養護学校の義務制実施と養護学校の整備」 | https://www.mext.go.jp/b_menu/hakusho/html/others/detail/1318339.htm",
  },
  {
    question_number: 2,
    major_category_code: "teacher_education",
    category_code: "education_foundations",
    content_blocks: [
      { type: "text", text: "ロックの認識及び教育に関する考え方について述べたものとして最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "ロックは，人間の心を白紙にたとえ，観念は経験から得られると考えた。外の事物から受ける経験を「反省」，自分の心の働きを捉える経験を「感覚」とし，これらを観念が生じる二つの源泉として説明した。"),
      text_choice.call("イ", "ロックは，生得観念を否定し，外の事物についての感覚と，自分の心の働きについての反省を観念の源泉とした。また，紳士の教育を論じる中では，身体の健康や，習慣を通した自己抑制の形成を重視した。", true),
      text_choice.call("ウ", "ロックは，観念の起源を経験に求める考え方と，紳士を育てる教育の考え方を著作にまとめた。『人間知性論』では身体の鍛錬や子どものしつけを具体的に論じ，『教育に関する考察』では認識の起源を体系的に論じた。"),
      text_choice.call("エ", "ロックは，幼児期に受ける印象や日々の習慣が，その後の人格に影響すると考えた。心の白紙説に基づき，生来の才能や素質の違いも習慣づけの後に成立するものと捉え，共通の方法で紳士の教育を進めることを求めた。"),
    ],
    explanation_blocks: [
      text_block.call("ア：誤り。外の事物から得るのが「感覚」，自分の心の働きを捉えるのが「反省」であり，対応が逆。"),
      text_block.call("イ：適切。認識の源泉に関する経験論と，身体・習慣・自己抑制を重視する教育の説明が対応している。"),
      text_block.call("ウ：誤り。二つの著作の主題が逆。認識論を論じるのは『人間知性論』，身体の養護や紳士の教育を論じるのは『教育に関する考察』。後者は『教育論』などの日本語名でも知られる。"),
      text_block.call("エ：誤り。生得観念の否定と，生来の才能・素質の違いの否定は同じではない。ロックは子どもの生来の特性を見極め，その子に適した方法を見いだすことも求めている。"),
    ],
    source_text: "金築忠雄「ジョン・ロックと貝原益軒との児童教育論」『島根農科大学研究報告』9（1961年）、57〜62頁、特に59・61頁 | https://ir.lib.shimane-u.ac.jp/4168/files/4084",
  },
  {
    question_number: 3,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "text", text: "「教育基本法」（平成18年法律第120号）に関する次のア～エの記述のうち，適切でないものを一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "国及び地方公共団体は，障害のある者がその障害の状態に応じて十分な教育を受けられるよう，教育上必要な支援を講じなければならない。また，能力があるにもかかわらず経済的理由で修学が困難な者に対し，奨学の措置を講じなければならない。"),
      text_choice.call("イ", "国及び地方公共団体は，家庭教育の自主性を尊重しつつ，保護者への学習機会や情報の提供などの支援施策を講ずるよう努めることとされている。また，幼児期の教育について，幼児の健やかな成長に資する良好な環境の整備などによって振興に努めることとされている。"),
      text_choice.call("ウ", "私立学校の有する公の性質と学校教育における重要な役割を踏まえ，その自主性を尊重しつつ，助成その他の適当な方法によって私立学校教育の振興に努めることが定められている。同法がこの義務を課している主体は，私立学校の設置者である。", true),
      text_choice.call("エ", "個人の要望や社会の要請にこたえ，社会において行われる教育は，国及び地方公共団体によって奨励されることとされている。その振興方法として，図書館，博物館及び公民館等の設置，学校の施設の利用，学習の機会及び情報の提供などが挙げられている。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切。第4条第2項の障害の状態に応じた教育上必要な支援と，第3項の奨学の措置について，主体・対象・義務を正しく説明している。"),
      text_block.call("イ：適切。前半は第10条第2項，後半は第11条の内容である。家庭教育の自主性を尊重すること，保護者への学習機会や情報の提供，幼児期の教育を振興するための環境整備を区別する。"),
      text_block.call("ウ：不適切。第8条で私立学校教育の振興に努める義務を課されている主体は「国及び地方公共団体」であり，「私立学校の設置者」ではない。公の性質，重要な役割，自主性の尊重及び助成等の方法という要素は正しく，義務主体を取り違えている。"),
      text_block.call("エ：適切。第12条第1項は社会教育の奨励を，第2項はその振興の努力義務と方法を定めている。学校の施設の利用も，社会教育の振興方法として含まれる。"),
    ],
    source_text: "教育基本法・第4条，第8条，第10条第2項，第11条，第12条 | https://laws.e-gov.go.jp/law/418AC0000000120#Mp-Ch_2-At_8",
  },
  {
    question_number: 4,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「学校教育法」（昭和22年法律第26号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第54条第1項・第2項\n\n高等学校には、{{①}}のほか、{{②}}の課程を置くことができる。\n\n２　高等学校には、{{②}}の課程のみを置くことができる。" },
      { type: "fill_in_quote", text: "第59条\n\n高等学校に関する{{③}}その他必要な事項は、{{④}}が、これを定める。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["全日制の課程及び定時制の課程","単位制","入学、退学、転学","文部科学大臣"]),
      fill_in_choice.call("イ", ["全日制の課程又は定時制の課程","通信制","入学、退学、転学","文部科学大臣"], true),
      fill_in_choice.call("ウ", ["全日制の課程又は定時制の課程","通信制","入学、休学、留学","都道府県の教育委員会"]),
      fill_in_choice.call("エ", ["全日制の課程及び定時制の課程","単位制","入学、休学、留学","都道府県の教育委員会"]),
    ],
    explanation_blocks: [
      text_block.call("第54条は、全日制又は定時制の課程のほかに通信制の課程を置くことができ、通信制の課程だけを置くこともできると定める。第59条に列挙される事項は「入学、退学、転学」であり、これらの必要な事項を定める主体は文部科学大臣である。"),
      text_block.call("ア：①は「全日制の課程又は定時制の課程」、②は「通信制」。全日制と定時制の双方が必要という文言ではなく、単位制を課程の種類として加える規定でもない。"),
      text_block.call("イ：四つの語句が全て原文と一致する。"),
      text_block.call("ウ：③は「入学、退学、転学」、④は「文部科学大臣」。この条文で明示的に列挙する語句と、それらに関する必要事項を定める主体が異なる。休学や留学が学校制度上存在しないという意味ではない。"),
      text_block.call("エ：①〜④が全て原文と異なる。"),
    ],
    source_text: "学校教育法第54条第1項・第2項 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_54\n学校教育法第59条 | https://laws.e-gov.go.jp/law/322AC0000000026/20260617_508AC0000000037#Mp-Ch_6-At_59",
  },
  {
    question_number: 5,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の各文は，「地方公務員法」 （昭和25年法律第261号）の条文である。文章中の空欄 ① ～ ④ に当てはまる語句の組合せとして正しいものを下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "第39条　職員には、その{{①}}のために、研修を受ける機会が与えられなければならない。\n\n２　前項の研修は、{{②}}が行うものとする。\n\n３　{{③}}は、研修の目標、研修に関する計画の指針となるべき事項その他研修に関する基本的な方針を定めるものとする。\n\n４　{{④}}は、研修に関する計画の立案その他研修の方法について{{②}}に勧告することができる。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["勤務能率の発揮及び増進","任命権者","任命権者","教育委員会"]),
      fill_in_choice.call("イ", ["職務上の義務の履行","地方公共団体","地方公共団体","教育委員会"]),
      fill_in_choice.call("ウ", ["職務上の義務の履行","地方公共団体","任命権者","人事委員会"]),
      fill_in_choice.call("エ", ["勤務能率の発揮及び増進","任命権者","地方公共団体","人事委員会"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが、研修に関する基本的な方針を定める主体は③「地方公共団体」、研修の方法について任命権者へ勧告できる主体は④「人事委員会」である。"),
      text_block.call("イ：③は正しいが、①は「勤務能率の発揮及び増進」、②は「任命権者」、④は「人事委員会」。職務上の義務の履行は地方公務員の服務に関する論点だが、この条文の研修目的を示す語句ではない。"),
      text_block.call("ウ：④は正しいが、①は「勤務能率の発揮及び増進」、②は「任命権者」、③は「地方公共団体」。研修の実施主体と基本方針の策定主体を逆にしている。"),
      text_block.call("エ：4語句が原文と一致する。任命権者が研修を実施し、地方公共団体が基本方針を定め、人事委員会が計画の立案や方法について任命権者へ勧告できる。"),
    ],
    source_text: "地方公務員法・第39条第1項〜第4項 | https://laws.e-gov.go.jp/law/325AC0000000261/20250601_504AC0000000068#Mp-Ch_3-Se_7-At_39",
  },
  {
    question_number: 6,
    major_category_code: "teacher_education",
    category_code: "curriculum_organization",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第3款 教育課程の実施と学習評価」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "生徒が{{①}}，主体的に挑戦してみることや多様な他者と協働することの重要性などを{{②}}することができるよう，各教科・科目等の特質に応じた{{③}}を重視し，家庭や地域社会と連携しつつ{{④}}に実施できるよう工夫すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["生命の有限性や自然の大切さ", "実感しながら理解", "体験活動", "体系的・継続的"], true),
      fill_in_choice.call("イ", ["生命の有限性や自然の大切さ", "実感しながら理解", "探究活動", "横断的・総合的"]),
      fill_in_choice.call("ウ", ["自己の適性や将来の進路", "学習内容として整理", "体験活動", "横断的・総合的"]),
      fill_in_choice.call("エ", ["自己の適性や将来の進路", "学習内容として整理", "探究活動", "体系的・継続的"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。生命・自然や挑戦・協働の重要性を実感を伴って理解できるよう体験活動を重視し，家庭・地域との連携の下に体系的・継続的に実施する。"),
      text_block.call("イ：①②は正しいが，③④が異なる。重視するのは「体験活動」で，実施の在り方は「体系的・継続的」である。総合的な探究の時間における横断的・総合的な学習との位置付けを区別する。"),
      text_block.call("ウ：③は正しいが，①②④が異なる。理解の対象は生命の有限性や自然の大切さ等で，実感を伴う理解を求めている。実施は体系的・継続的に工夫する。"),
      text_block.call("エ：④は正しいが，①②③が異なる。適性・進路の整理を中心とした規定ではなく，生命・自然・挑戦・協働の重要性を実感しながら理解するための体験活動を示している。"),
    ],
    source_text: "高等学校学習指導要領 第1章 総則 第3款1（5）全文（印刷28頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=30",
  },
  {
    question_number: 7,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第5款 生徒の発達の支援」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "{{①}}として，{{②}}及び生徒相互のよりよい人間関係を育てるため，{{③}}ホームルーム経営の充実を図ること。また，主に集団の場面で必要な指導や援助を行うガイダンスと，{{④}}を踏まえ，一人一人が抱える課題に個別に対応した指導を行うカウンセリングの双方により，生徒の発達を支援すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学習や生活の基盤", "学校と家庭との協力関係", "日頃から", "個々の生徒の将来の進路希望"]),
      fill_in_choice.call("イ", ["学習や生活の基盤", "教師と生徒との信頼関係", "日頃から", "個々の生徒の多様な実態"], true),
      fill_in_choice.call("ウ", ["学校運営の基盤", "教師と生徒との信頼関係", "入学当初に", "個々の生徒の多様な実態"]),
      fill_in_choice.call("エ", ["学校運営の基盤", "学校と家庭との協力関係", "入学当初に", "個々の生徒の将来の進路希望"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①③は正しいが，②④が原文と異なる。ホームルーム経営では教師と生徒との信頼関係及び生徒相互の人間関係を育てる。カウンセリングでは将来の進路希望に限らず個々の生徒の多様な実態を踏まえる。"),
      text_block.call("イ：正しい。ホームルーム経営は学習や生活の基盤として日頃から充実を図り，教師と生徒との信頼関係を育てる。集団の場面のガイダンスと，多様な実態に基づく個別のカウンセリングの双方で発達を支援する。"),
      text_block.call("ウ：②④は正しいが，①③が原文と異なる。学校運営の基盤ではなく学習や生活の基盤とされ，入学当初の対応ではなく日頃からホームルーム経営の充実を図ることが示される。"),
      text_block.call("エ：①〜④がいずれも原文と異なる。ホームルーム経営の位置付けと継続的な取組，信頼関係の当事者，カウンセリングで踏まえる実態の範囲をそれぞれ取り違えている。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第1章第5款1（1）、印刷29〜30頁 | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=31",
  },
  {
    question_number: 8,
    major_category_code: "teacher_education",
    category_code: "integrated_inquiry",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第4章 総合的な探究の時間 第2 各学校において定める目標及び内容」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "（6）探究課題の解決を通して育成を目指す具体的な資質・能力については，次の事項に配慮すること。\nア 知識及び技能については，他教科等及び総合的な探究の時間で習得する知識及び技能が相互に関連付けられ，社会の中で生きて働くものとして形成されるようにすること。\nイ 思考力，判断力，表現力等については，課題の設定，情報の収集，整理・分析，まとめ・表現などの探究の過程において発揮され，未知の状況において活用できるものとして身に付けられるようにすること。\nウ {{①}}については，自分自身に関すること及び他者や社会との関わりに関することの両方の視点を踏まえること。\n（7）目標を実現するにふさわしい探究課題及び探究課題の解決を通して育成を目指す具体的な資質・能力については，{{②}}を越えた{{③}}となる資質・能力が育まれ，活用されるものとなるよう配慮すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学びに向かう力，人間性等", "学年や学校段階", "各教科の専門性の基礎"]),
      fill_in_choice.call("イ", ["学習への関心，意欲，態度", "教科・科目等", "各教科の専門性の基礎"]),
      fill_in_choice.call("ウ", ["学びに向かう力，人間性等", "教科・科目等", "全ての学習の基盤"], true),
      fill_in_choice.call("エ", ["学習への関心，意欲，態度", "学年や学校段階", "全ての学習の基盤"]),
    ],
    explanation_blocks: [
      text_block.call("ア：①は一致するが，②は「教科・科目等」，③は「全ての学習の基盤」である。この規定は学校段階間の接続や各教科の専門性に限定せず，教科横断的に基盤となる資質・能力を育み活用することを求めている。"),
      text_block.call("イ：②は一致するが，①は資質・能力の三つの柱の一つである「学びに向かう力，人間性等」，③は「全ての学習の基盤」である。ここでは三つの柱の名称を用いており，「学習への関心，意欲，態度」とは記していない。"),
      text_block.call("ウ：全て原文と一致する。学びに向かう力，人間性等では自己と他者・社会の両方の視点を踏まえる。探究課題と具体的な資質・能力を設定する際には，教科・科目等を越えた全ての学習の基盤となる資質・能力が育まれ，活用されるよう配慮する。"),
      text_block.call("エ：③は一致するが，①は「学びに向かう力，人間性等」，②は「教科・科目等」である。学年・学校段階を越えた接続ではなく，教科・科目等を越えるという対象範囲を正確に捉える。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）第4章 総合的な探究の時間 第2の3（6）〜（7）（印刷475〜476頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=477",
  },
  {
    question_number: 9,
    major_category_code: "teacher_education",
    category_code: "moral_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第1章 総則 第1款 高等学校教育の基本と教育課程の役割」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "道徳教育を進めるに当たっては，{{①}}と{{②}}を家庭，学校，その他社会における具体的な生活の中に生かし，豊かな心をもち，伝統と文化を尊重し，それらを育んできた我が国と郷土を愛し，個性豊かな文化の創造を図るとともに，{{③}}として，公共の精神を尊び，社会及び国家の発展に努め，他国を尊重し，国際社会の平和と発展や{{④}}に貢献し未来を拓く主体性のある日本人の育成に資することとなるよう特に留意すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["人間尊重の精神", "生命に対する畏敬の念", "平和で民主的な国家及び社会の形成者", "環境の保全"], true),
      fill_in_choice.call("イ", ["人間尊重の精神", "生命に対する畏敬の念", "国際社会で活躍する職業人", "文化間の相互理解"]),
      fill_in_choice.call("ウ", ["国家及び社会への帰属意識", "生命に関する科学的な理解", "平和で民主的な国家及び社会の形成者", "文化間の相互理解"]),
      fill_in_choice.call("エ", ["国家及び社会への帰属意識", "生命に関する科学的な理解", "国際社会で活躍する職業人", "環境の保全"]),
    ],
    explanation_blocks: [
      text_block.call("ア：全て原文と一致する。人間尊重の精神と生命への畏敬を具体的な生活に生かし，平和で民主的な国家・社会の形成者として育つこと，国際社会の平和と発展及び環境の保全に貢献することを結び付けている。"),
      text_block.call("イ：③④が異なる。③は「平和で民主的な国家及び社会の形成者」であり，国際社会で活躍する職業人への置換は育成する人間像を取り違えている。④は「環境の保全」で，「文化間の相互理解」はこの空欄の原語ではない。"),
      text_block.call("ウ：①②④が異なる。具体的な生活に生かすのは「人間尊重の精神」と「生命に対する畏敬の念」で，帰属意識と科学的な理解ではない。④は「環境の保全」である。他国や文化を尊重することも本文にあるが，この空欄で国際社会の平和と発展と並べる原語は「文化間の相互理解」ではない。"),
      text_block.call("エ：①②③が異なる。①は「人間尊重の精神」，②は「生命に対する畏敬の念」，③は「平和で民主的な国家及び社会の形成者」である。生活に生かす価値と，育成する人間像の両方を取り違えている。"),
    ],
    source_text: "第1章 総則 第1款2(2)第3段落（PDF21頁／印刷19頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=21",
  },
  {
    question_number: 10,
    major_category_code: "teacher_education",
    category_code: "special_activities",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 特別活動編』（平成30年7月文部科学省）の「第2章 特別活動の目標 第2節 特別活動の基本的な性格と教育活動全体における意義」からの抜粋である。文章中の空欄 {{①}} ～ {{④}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "特別活動は，学校生活を送る上での基盤となる力や，社会で他者と関わって生きて働く力を育む活動として機能し，人間形成の中でも特に，{{①}}の資質・能力の育成について強調してきた。今回の改訂では，各教科・科目等を通して育成することを目指す資質・能力として「{{②}}」，「{{③}}」，「{{④}}」をバランスよく育むことを重視している。そのために重要なことは，目標に「様々な集団活動に自主的，実践的に取り組み」とあるように，自主的，実践的な活動を重視するということである。様々な集団活動の中で，「{{③}}」を活用しながら他者と協力して実践することを通して，「{{②}}」は実感を伴って体得され，活動を通して得られたことを生涯にわたって積極的に生かそうとする「{{④}}」が育成されていく。特別活動の内容は，各教科・科目等に広く関わるものであるが，こうした特徴をもつ特別活動だからこそ目指すことができる資質・能力を育むことが大切である。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["情意面や態度面", "思考力・判断力・表現力等", "知識及び技能", "学びに向かう力，人間性等"]),
      fill_in_choice.call("イ", ["認知面や技能面", "知識及び技能", "思考力・判断力・表現力等", "自己調整力，協働性等"]),
      fill_in_choice.call("ウ", ["認知面や技能面", "思考力・判断力・表現力等", "知識及び技能", "自己調整力，協働性等"]),
      fill_in_choice.call("エ", ["情意面や態度面", "知識及び技能", "思考力・判断力・表現力等", "学びに向かう力，人間性等"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①④は正しいが，②③が逆である。原文は，思考力・判断力・表現力等を活用して他者と協力し実践する中で，知識及び技能が実感を伴って体得されると説明している。"),
      text_block.call("イ：②③は正しいが，①④が原文と異なる。特別活動が人間形成の中で特に強調してきたのは情意面や態度面であり，三つの柱のうち活動を生涯に生かそうとするものは学びに向かう力，人間性等である。"),
      text_block.call("ウ：①④が原文と異なり，②③も逆である。情意面や態度面を重視してきたことと，知識及び技能，思考力・判断力・表現力等，学びに向かう力，人間性等の三つの柱をバランスよく育むことを混同している。"),
      text_block.call("エ：正しい。情意面や態度面を重視してきた特別活動の特質を踏まえつつ，実践を通して三つの柱を関連させて育成する構造になっている。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 特別活動編・第2章第2節2（1）、印刷25頁 | https://www.mext.go.jp/content/1407196_22_1_1_2.pdf#page=33",
  },
  {
    question_number: 11,
    major_category_code: "teacher_education",
    category_code: "student_guidance_career",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "リスクマネジメントは、事件・事故の発生を未然に防止し、災害の影響を回避、緩和するための取組です。安全管理では、定期的に学校の施設や設備を点検し、事件や事故につながらないように{{①}}、ルールやきまりの遵守の徹底などを通して、発生の防止に取り組みます。また、安全教育では、児童生徒が危険に気付いて回避したり、被害に遭わないように{{②}}を育成するための予防的な指導を行います。その際、安全管理と安全教育は密接に関連させて進めていくことが大切です。\n\n例えば、安全点検の結果を{{③}}として活用したり、望ましくない行動を取り上げ、適切な行動の仕方を考えさせたりすることによって、進んで安全な行動が実践できるような資質・能力を身に付けるように働きかけます。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["修理したり使用停止にしたり", "自ら判断したりする力", "学校安全計画の改善資料"]),
      fill_in_choice.call("イ", ["見回りを強化したり使用を制限したり", "互いに注意を促したりする態度", "学校安全計画の改善資料"]),
      fill_in_choice.call("ウ", ["見回りを強化したり使用を制限したり", "互いに注意を促したりする態度", "安全教育の具体的な資料"]),
      fill_in_choice.call("エ", ["修理したり使用停止にしたり", "自ら判断したりする力", "安全教育の具体的な資料"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①②は正しいが，③が異なる。原文の例は安全点検の結果を『安全教育の具体的な資料』として活用することである。学校安全計画を改善することの是非ではなく，点検結果を児童生徒の学習へつなげる例との相違である。"),
      text_block.call("イ：全て原文と異なる。施設・設備への具体的な対応は修理や使用停止，安全教育で育てるのは自ら判断する力，点検結果の利用先は安全教育の具体的な資料として示される。"),
      text_block.call("ウ：③は正しいが，①②が異なる。設備の修理や使用停止を挙げ，児童生徒自身が危険を回避し被害に遭わないよう判断する力を育成する。巡視の強化や互いへの注意が不要という意味ではなく，ここで示された具体的な対応と育成対象が異なる。"),
      text_block.call("エ：全て原文と一致する。設備の安全管理と，自ら判断して安全に行動できるようにする教育を関連させる。点検結果を児童生徒の安全教育に使うことが，両者をつなぐ例として示されている。"),
    ],
    source_text: "『生徒指導提要』第3章3.5.2「学校危機への介入」（1）リスクマネジメント，第1・第2段落（印刷97頁／PDF100頁） | https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf#page=100",
  },
  {
    question_number: 12,
    major_category_code: "teacher_education",
    category_code: "special_support_education",
    content_blocks: [
      { type: "text", text: "言語障害のうち，構音障害のある生徒の理解及び指導に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      {
        label: "ア",
        content_blocks: [
          {
            type: "text",
            text: "音を作る位置や息の使い方を把握して，構音の仕方を指導する。構音器官の位置や動きを示して発音を導く方法は，正しい音と誤った音を聞き分ける聴覚的な認知を評価する方法として整理する。",
          },
        ],
        correct: false,
      },
      {
        label: "イ",
        content_blocks: [
          {
            type: "text",
            text: "指導する音を，単音，単語，文章や会話へと広げていく。単語の中で正しい音を使う指導では，音の習得を確かめるため，単語の中の位置や前後の音をそろえた一つの条件で定着を判定する。",
          },
        ],
        correct: false,
      },
      {
        label: "ウ",
        content_blocks: [
          {
            type: "text",
            text: "正しい構音の仕方を習得するため，構音できる音や，正しく発音できる語を手掛かりにする。構音の誤りには音の置換や省略が含まれ，特定の音の置換は吃音の流暢性の指導として扱う。",
          },
        ],
        correct: false,
      },
      {
        label: "エ",
        content_blocks: [
          {
            type: "text",
            text: "正しい音と自分の発音を比較し，違いを聞き分ける力を把握する。音の認知を支える指導と構音の仕方の指導を組み合わせ，個別の練習で得た発音を日常会話でも使えるように工夫する。",
          },
        ],
        correct: true,
      },
    ],
    explanation_blocks: [
      {
        type: "text",
        text: "ア：構音器官の位置や動きを示す指導は，正しい構音運動を導くためのものである。音を聞き分ける聴覚的な認知の把握・指導とは，目的と方法を区別する。",
      },
      {
        type: "text",
        text: "イ：一つの音でも，単語の中の位置や前後の音との関係によって誤りが異なるため，一つの条件に固定した確認で単語段階の定着を判定する点が不適切。様々な条件や日常会話での使用を把握する。",
      },
      {
        type: "text",
        text: "ウ：構音可能な音や語を利用する点は適切だが，音の置換という構音の誤りと吃音を取り違えている。吃音では音の繰り返し，引き伸ばし，声の出にくさなど，話し言葉の流暢性の問題を扱う。",
      },
      {
        type: "text",
        text: "エ：適切。聴覚的な認知と構音運動の双方を把握し，特別な指導場面の習得を日常会話での使用へつなげる。",
      },
    ],
    source_text: "文部科学省『障害のある子供の教育支援の手引』第3編Ⅵ「言語障害」1(2)②ア(イ)・(ウ)，3(2)②・3(3)①・3(4)①ア(イ)，本文225〜226・237・239頁（PDF9〜10・21・23頁） | https://www.mext.go.jp/content/20211014-mxt_tokubetu02-000018454_10.pdf#page=9",
  },
  {
    question_number: 13,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "青年期の進路選択で生じる葛藤を，レヴィンの葛藤の類型から捉える。次の二つの状況に関する記述として，最も適切なものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "text", text: "状況A：ある大学で希望する分野を学びたいが，その大学への進学に必要な多額の費用を負担することに不安も感じ，進学するかどうか迷っている。" },
      { type: "text", text: "状況B：学びたい内容や生活環境の異なる二つの大学に，それぞれ同じ程度の魅力を感じている。どちらか一方へ入学する必要があり，進学先を決めかねている。" },
    ],
    choices: [
      text_choice.call("ア", "Aは接近－接近型であり，同じ大学の学習内容と費用という二つの目標が競合している。Bは接近－接近型であり，魅力のある二つの進学先から一方を選ぶことが問題になる。"),
      text_choice.call("イ", "Aは接近－回避型であり，一つの進学先に魅力と負担の両面がある。Bは接近－接近型であり，それぞれ魅力のある二つの進学先を同時には選べないことが問題になる。", true),
      text_choice.call("ウ", "Aは回避－回避型であり，学習を望む気持ちと費用への不安という二つの目標が競合している。Bは接近－接近型であり，魅力のある二つの進学先から一方を選ぶことが問題になる。"),
      text_choice.call("エ", "Aは接近－回避型であり，一つの進学先に魅力と負担の両面がある。Bは回避－回避型であり，いずれを選んでも他方を見送るため，二つの進学先は回避したい目標になる。"),
    ],
    explanation_blocks: [
      text_block.call("ア：Bの説明は適切だが，Aの説明が誤り。Aは，一つの進学先に向かいたい気持ちと，その進学に伴う負担を避けたい気持ちが競合する接近－回避型である。"),
      text_block.call("イ：適切。Aは単一の目標が魅力と負担の両面をもち，Bは二つの異なる目標がともに魅力をもつ。目標の数と，それぞれの目標に対する接近・回避の方向を区別している。"),
      text_block.call("ウ：Bの説明は適切だが，Aを回避－回避型とする点が誤り。学習を望む気持ちは目標への接近であり，二つの避けたい目標に挟まれた状況ではない。"),
      text_block.call("エ：Aの説明は適切だが，Bの説明が誤り。一方を見送ることへの残念さがあっても，二つの進学先自体はともに魅力的な目標である。回避－回避型は，二つの避けたい目標の間で選択を迫られる状況を指す。"),
    ],
    source_text: "人間環境大学「葛藤解決の心理学(自由とルールの狭間で生じるトラブルの解決方法)」コマシラバス，第2回「個人内葛藤の心理的メカニズム」細目②（レヴィンの三つの葛藤の類型） | https://irweb.kawahara.ac.jp/uhe_syllabus/SyllabusDetail.aspx?jc=SD301001&jn=2026",
  },
  {
    question_number: 14,
    major_category_code: "teacher_education",
    category_code: "educational_psychology",
    content_blocks: [
      { type: "text", text: "記憶の過程及び記憶を測定する方法に関する記述として，最も適切なものを，次のア～エの中から一つ選んで記号で答えなさい。" },
    ],
    choices: [
      text_choice.call("ア", "符号化は情報を記憶へ取り込み，貯蔵はその情報を保持し，検索は保持された情報を取り出すことに関わる。自由再生と再認はいずれも検索に関わるが，再認では，提示された項目が学習したものかどうかを判断する。", true),
      text_choice.call("イ", "貯蔵は，符号化された情報を保持する過程である。自由再生では，提示された候補が以前学習した項目かどうかを判断し，再認では，候補の提示を受けずに学習した項目を思い出す。"),
      text_choice.call("ウ", "符号化は，情報を記憶へ取り込む過程であり，検索は，保持された情報を取り出す過程である。再認は，検索とは区別され，提示された情報を新たに記憶へ取り込む符号化の働きを測定する方法である。"),
      text_choice.call("エ", "再認では，提示された項目が以前学習したものかどうかを判断する。自由再生で項目を思い出せなかった場合は，その項目の貯蔵が失われたことを示しており，同じ項目に対する再認も失敗する。"),
    ],
    explanation_blocks: [
      text_block.call("ア：適切です。情報を取り込む，保持する，取り出すという過程を区別しています。記憶の測定では，学習した情報を生成する再生と，提示された情報を識別する再認を区別します。"),
      text_block.call("イ：貯蔵の説明は適切です。自由再生と再認の説明が逆です。自由再生では学習した項目を自分で取り出し，再認では提示された項目について学習済みかどうかを判断します。"),
      text_block.call("ウ：符号化と検索の説明は適切です。再認も，既に学習した情報に基づいて判断する検索に関わる方法です。新しい情報を取り込めるかだけを測定する方法ではありません。"),
      text_block.call("エ：再認の説明は適切です。自由再生に失敗しても，項目の提示などの手掛かりによって再認できる場合があります。再生の失敗と，記憶が保持されていないこととは同一ではありません。"),
    ],
    source_text: "電子情報通信学会『知識ベース』S3群2編15章「記憶の符号化と検索」，15-1-1「符号化の性質」（PDF2頁）。 | https://ieice-hbkb.org/files/S3/S3gun_02hen_15.pdf\n京都大学広報誌『紅萠』「人文・社会科学系科目群 教育・心理・社会（各論）神経心理学I」，「憶える、憶えておく、思い出す」及び「損傷した部位ごとに異なる健忘症状」（再生・再認の方法の区別と，再生が困難でも再認によって改善する例）。 | https://www.kyoto-u.ac.jp/kurenai/201609/gakumon/",
  },
  {
    question_number: 15,
    major_category_code: "teacher_education",
    category_code: "education_system",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）の「第Ⅰ部 総論 4 『令和の日本型学校教育』の構築に向けた今後の方向性 （3）これまでの実践とICTとの最適な組合せを実現する」からの抜粋である。文章中の空欄{{①}}～{{③}}に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "・ 全ての子供たちの可能性を引き出す，個別に最適な学びや支援（例えば，子供の学習状況に応じた教材等の提供により，知識・技能の習得等に効果的な学びを行うこと，子供の学習や生活，{{①}}を含む心身の健康状況等に関する様々な情報を把握・分析し，抱える問題を早期発見・解決すること，障害のある子供たちにとっての情報保障やコミュニケーションツールとなること）\n\n・ 可視化が難しかった学びの知見の共有やこれまでにない知見の生成（例えば，教育データの収集・分析により，各教師の実践知や{{②}}の可視化・定式化や新たな知見を生成すること，{{③}}の検証や個々の子供の効果的な学習方法等を特定すること）" },
    ],
    choices: [
      fill_in_choice.call("ア", ["学校健康診断結果", "形式知", "統一的な評価基準"]),
      fill_in_choice.call("イ", ["保健室の来室記録", "形式知", "経験的な仮説"]),
      fill_in_choice.call("ウ", ["保健室の来室記録", "暗黙知", "統一的な評価基準"]),
      fill_in_choice.call("エ", ["学校健康診断結果", "暗黙知", "経験的な仮説"], true),
    ],
    explanation_blocks: [
      text_block.call("ア：①は原文に一致します。②は「暗黙知」，③は「経験的な仮説」です。原文は，教師の知見を可視化・定式化することと，経験に基づく仮説を検証することを挙げています。"),
      text_block.call("イ：③は原文に一致します。①は「学校健康診断結果」，②は「暗黙知」です。原文で具体的に挙げられた健康情報は学校健康診断結果であり，保健室の来室記録ではありません。来室記録の活用そのものが不適切という意味ではありません。"),
      text_block.call("ウ：②は原文に一致します。①は「学校健康診断結果」，③は「経験的な仮説」です。子供の心身の状態を含む情報の把握・分析と，教師の経験に基づく仮説の検証という二つの対応を確認します。"),
      text_block.call("エ：全て原文に一致します。ICTの活用により，学習・生活・健康の情報に基づく支援，障害のある子供の情報保障，教師の知見の可視化・共有や新しい知見の生成へつなげることを述べています。"),
    ],
    source_text: "中央教育審議会『「令和の日本型学校教育」の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）』・第Ⅰ部4(3)，本文26頁（PDF31ページ） | https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf#page=31",
  },
  {
    question_number: 16,
    major_category_code: "information",
    category_code: "information_education",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，「高等学校学習指導要領」（平成30年3月文部科学省告示第68号）の「第2章 各学科に共通する各教科 第10節 情報 第2款 各科目 第1 情報Ⅰ 2 内容 情報社会の問題解決」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "イ 次のような思考力，判断力，表現力等を身に付けること。\n\n（ｱ） 目的や状況に応じて，情報と情報技術を{{①}}に活用して問題を発見・解決する方法について考えること。\n\n（ｲ） 情報に関する法規や制度及びマナーの意義，情報社会において個人の果たす役割や責任，情報モラルなどについて，それらの背景を{{②}}に捉え，考察すること。\n\n（ｳ） 情報と情報技術の{{①}}な活用と{{③}}について考察すること。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["適切かつ効果的","経験的","新たな価値の創造"]),
      fill_in_choice.call("イ", ["迅速かつ効率的","科学的","新たな価値の創造"]),
      fill_in_choice.call("ウ", ["適切かつ効果的","科学的","望ましい情報社会の構築"], true),
      fill_in_choice.call("エ", ["迅速かつ効率的","経験的","望ましい情報社会の構築"]),
    ],
    explanation_blocks: [
      text_block.call("原典は「適切かつ効果的」な活用，法規・制度やマナーなどの背景を「科学的」に捉えること，「望ましい情報社会の構築」を考察することを示す。①は（ｱ）と（ｳ）の両方に同じ語句が入る。"),
      text_block.call("ア：②・③が誤り。経験的ではなく科学的，この規定の対象は新たな価値の創造ではなく望ましい情報社会の構築である。"),
      text_block.call("イ：①・③が誤り。速さや効率に限定した表現ではなく適切かつ効果的な活用と，望ましい情報社会の構築を示している。"),
      text_block.call("ウ：三つとも原文に一致する。"),
      text_block.call("エ：①・②が誤り。適切かつ効果的，科学的が入る。③は一致する。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）・第2章第10節 第2款第1 情報Ⅰ 2（1）イ（ｱ）〜（ｳ）・190〜191頁（PDF192〜193頁） | https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf#page=192",
  },
  {
    question_number: 17,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "text", text: "『高等学校学習指導要領（平成30年告示）解説 情報編』の「第1部 各学科に共通する教科『情報』 第2章 共通教科情報科の各科目 第1節 情報Ⅰ 2 内容とその取扱い コンピュータとプログラミング」に示されている内容に関する次の①〜③の記述のうち，正しいものの個数を，下の選択肢ア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "①　オペレーティングシステムが入力装置や出力装置などのハードウェアを抽象化して扱う考え方と，ソフトウェアがオペレーティングシステムの機能を利用して動作することを理解するようにする。\n\n②　CPUが機械語のプログラムをデータとして読みながら実行することと，CPU，メモリ，周辺装置の間でデータがやり取りされることを扱う。\n\n③　メモリについては，機械語のプログラムをデータとして読みながら実行する役割を扱い，コンピュータの基本的な構成や演算の仕組みについて理解するようにする。" },
    ],
    choices: [
      text_choice.call("ア", "三つ"),
      text_choice.call("イ", "二つ", true),
      text_choice.call("ウ", "一つ"),
      text_choice.call("エ", "なし"),
    ],
    explanation_blocks: [
      text_block.call("記述①・②が正しく，③が誤りであるため，正しいものは二つである。"),
      text_block.call("記述①：正しい。オペレーティングシステムによるハードウェアの抽象化と，ソフトウェアがその機能を利用して動作するという関係が示されている。"),
      text_block.call("記述②：正しい。機械語のプログラムを読みながら実行するCPUの働きと，CPU・メモリ・周辺装置の間のデータのやり取りが具体例に示されている。"),
      text_block.call("記述③：誤り。原典は，コンピュータがデータを処理する「作業場所」としてメモリを位置付ける。機械語のプログラムをデータとして読みながら実行するのはCPUであり，メモリの役割との対応を取り違えている。"),
      text_block.call("選択肢ア（三つ）：記述③も正しいと判断しているため誤り。"),
      text_block.call("選択肢イ（二つ）：記述①・②を数えた正答。"),
      text_block.call("選択肢ウ（一つ）：記述①・②のうち一つを誤りとしているため誤り。"),
      text_block.call("選択肢エ（なし）：記述①・②が正しいため誤り。"),
    ],
    source_text: "高等学校学習指導要領（平成30年告示）解説 情報編・第1部 第2章第1節 情報Ⅰ 2（3）ア（ア）・イ（ア）の説明と具体例・32頁（PDF40頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=40",
  },
  {
    question_number: 18,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      { type: "fill_in_text", text: "次の文章は，『高等学校学習指導要領（平成30年告示）解説 情報編』（平成30年7月文部科学省）の「第2部 主として専門学科において開設される教科「情報」 第2章 専門教科情報科の各科目 第6節 情報システムのプログラミング 第2 内容とその取扱い」からの抜粋である。文章中の空欄 {{①}} ～ {{③}} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。" },
      { type: "fill_in_quote", text: "イ 情報システムのモデル化\n\nここでは，社会で具体的に運用されているPOS（Point of Sales）システムやチケット予約システムなどを取り上げ，{{①}}，情報システムの機能や構造を扱う。その際，{{②}}などを用い，必要に応じて使い分けられるようにする。\n\nまた，要求定義された情報システムをモデル化し，{{③}}をコントロールすることによって，情報システムの概要や機能を分かりやすく伝えることができるようにする。" },
    ],
    choices: [
      fill_in_choice.call("ア", ["入出力やデータの流れ","フローチャート，構造化チャート及びアクティビティ図","複雑度"]),
      fill_in_choice.call("イ", ["命令の実行や制御の流れ","データフロー図，実態関連図及び状態遷移図","複雑度"]),
      fill_in_choice.call("ウ", ["入出力やデータの流れ","データフロー図，実態関連図及び状態遷移図","抽象度"], true),
      fill_in_choice.call("エ", ["命令の実行や制御の流れ","フローチャート，構造化チャート及びアクティビティ図","抽象度"]),
    ],
    explanation_blocks: [
      text_block.call("ア：②・③が異なる。原文はデータフロー図・実態関連図・状態遷移図を挙げ，モデルの「抽象度」を調整する。"),
      text_block.call("イ：①・③が異なる。情報システムの「入出力やデータの流れ」を捉え，「抽象度」を調整して概要や機能を伝える。"),
      text_block.call("ウ：原文に一致する。データの流れと機能・構造を適切な図で表し，モデルの抽象度を調整する。「実態関連図」は原典の表記を維持した。"),
      text_block.call("エ：①・②が異なる。原典が挙げるのは情報システムの入出力・データの流れと，データフロー図等の組合せである。フローチャート等の利用自体を否定するものではない。"),
    ],
    source_text: "文部科学省『高等学校学習指導要領（平成30年告示）解説 情報編』・第2部 主として専門学科において開設される教科「情報」 第2章 専門教科情報科の各科目 第6節 情報システムのプログラミング 第2 内容とその取扱い 2（1）イ「情報システムのモデル化」全文（123頁／PDF130頁） | https://www.mext.go.jp/content/1407073_11_1_2.pdf#page=130",
  },
  {
    question_number: 19,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("次のプログラムは，配列 data の5個の値の平均値について，小数点以下を切り捨てた整数を表示するために作成したものである。しかし，このままでは意図した表示にならない。修正方法として正しいものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      text_block.call("= は代入を表し，非負の整数について a // b は a を b で割った商の小数点以下を切り捨てた値を表す。for x in data は各要素の値を先頭から順に x へ代入して繰り返す。行頭の字下げは処理の範囲を表す。"),
      { type: "code", code: "01 data = [3, 8, 4, 6, 9]\n02 total = 0\n03 for x in data:\n04     total = total + x\n05     total = total // 5\n06 print(total)" },
    ],
    choices: [
      text_choice.call("ア", "05行の位置はそのままとし，06行を字下げして，繰返しの中で05行の直後に実行する。"),
      text_choice.call("イ", "05行を03行の直前へ移し，字下げをなくして，繰返しが始まる前に実行する。"),
      text_choice.call("ウ", "05行の字下げをなくし，繰返しが終了してから06行の直前に実行する。", true),
      text_choice.call("エ", "05行を04行の直前へ移し，字下げはそのままとして，繰返しの中で加算の前に実行する。"),
    ],
    explanation_blocks: [
      text_block.call("全ての値の合計30を求めた後，一度だけ5で割ると，平均値の整数部分6が得られる。加算の途中で除算すると，それまでの合計自体が変更され，切捨ても繰り返される。"),
      { type: "code", code: "加算後の total：3 → 11 → 15 → 21 → 30\n繰返し終了後：30 // 5 = 6" },
      text_block.call("ア：加算と整数除算を繰り返す点は変わらず，途中の値0，1，1，1，2を順に表示する。平均値の整数部分を一つ表示する処理にはならない。"),
      text_block.call("イ：初期値0を5で割った後，全要素を加算するため，表示は合計の30となる。"),
      text_block.call("ウ：正しい。除算を全要素の加算後に一度だけ行い，6を表示する。"),
      text_block.call("エ：直前の total を5で割ってから次の値を加えるため，total は3，8，5，7，10と変わり，表示は10となる。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第3章・学習14（1）リスト「リストを用いたプログラムの例2」（122頁／PDF28頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_005.pdf#page=28",
  },
  {
    question_number: 20,
    major_category_code: "information",
    category_code: "information_specialized",
    content_blocks: [
      text_block.call("4人の通学時間を，次の区分に従って符号1～3へ変換した。元の通学時間と，変換後のデータの性質に関する記述として適切なものを，下のア～エの中から一つ選んで記号で答えなさい。"),
      { type: "table", headers: ["区分", "通学時間", "記録する符号"], rows: [["短い", "0分以上30分未満", "1"], ["中程度", "30分以上60分未満", "2"], ["長い", "60分以上", "3"]] },
      { type: "table", headers: ["生徒", "A", "B", "C", "D"], rows: [["元の通学時間（分）", "20", "30", "55", "90"], ["変換後の符号", "1", "2", "2", "3"]] },
    ],
    choices: [
      text_choice.call("ア", "変換後の符号は順序尺度である。符号2となったBとCについて，どちらの通学時間が長いか，何分違うかを，符号だけから判断することはできない。", true),
      text_choice.call("イ", "変換後の符号は順序尺度である。符号の平均値2を中程度の区分の中央45分に対応させれば，元の4人の平均通学時間が得られる。"),
      text_choice.call("ウ", "符号には1，2，3の順序があり，隣り合う符号の差は1であるため，変換後のデータは間隔尺度である。符号の差が等しければ，元の通学時間の差も等しい。"),
      text_choice.call("エ", "変換後の符号は順序尺度である。符号2の生徒の人数が符号1の生徒の2倍であるため，それぞれの区分に属する生徒の通学時間の合計も同じ2倍の関係になる。"),
    ],
    explanation_blocks: [
      text_block.call("量的な値をいくつかの区分に分け，順序を持つ質的データへ変換することを，教材では水準化（レベル化）と説明している。"),
      text_block.call("ア：正しい。区分間の短い・長いという順序は残るが，同じ区分に入った元の値の差は符号だけでは分からない。Bは30分，Cは55分だが，どちらも符号2となる。"),
      text_block.call("イ：尺度の分類は正しいが，符号の平均から元の時間の平均を求める処理が誤りである。元の平均は（20＋30＋55＋90）÷4＝48.75分であり，45分とは一致しない。同じ符号でも，区分内で元の値は異なり得る。"),
      text_block.call("ウ：隣り合う符号の差が1でも，元の時間の差が等しいことは保証されない。BとCは符号の差が0なのに，元の時間の差は25分である。符号は順序尺度であり，間隔尺度ではない。"),
      text_block.call("エ：尺度の分類と人数の比較は正しいが，人数の比を通学時間の合計の比と取り違えている。符号2の生徒の通学時間の合計は30＋55＝85分，符号1の生徒は20分であり，2倍ではない。人数は区分化後も集計できるが，時間の合計には元の量的な値が必要である。"),
    ],
    source_text: "文部科学省『高等学校情報科「情報Ⅰ」教員研修用教材（本編）』第4章・学習22（1）「量的データと質的データ」・尺度水準（本文184頁／PDF32頁）及び水準化（本文185頁／PDF33頁） | https://www.mext.go.jp/content/20200722-mxt_jogai02-100013300_006.pdf#page=33",
  },
]

unless questions.map { |question| question.fetch(:question_number) } == (1..20).to_a
  raise "模擬試験28の承認済み問番号は1〜20です"
end

categories = {
  1 => "education_foundations", 2 => "education_foundations",
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "student_guidance_career",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
  11 => "student_guidance_career",
  12 => "special_support_education", 13 => "educational_psychology",
  14 => "educational_psychology", 15 => "education_system",
  16 => "information_education",
  17 => "information_specialized",
  18 => "information_specialized",
  19 => "information_specialized", 20 => "information_specialized",
}
questions.each do |question|
  number = question.fetch(:question_number)
  choices = question.fetch(:choices)
  expected_major = number >= 16 ? "information" : "teacher_education"
  unless question.fetch(:major_category_code) == expected_major && question.fetch(:category_code) == categories.fetch(number)
    raise "問#{number}の分類が不正です"
  end
  unless choices.map { |choice| choice.fetch(:label) } == %w[ア イ ウ エ] && choices.count { |choice| choice.fetch(:correct) } == 1
    raise "問#{number}は4択・正答1件にしてください"
  end
  blocks = question.fetch(:content_blocks)
  if number <= 2 && (blocks.any? { |block| %w[fill_in_text fill_in_quote].include?(block[:type]) } ||
      choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    raise "問1・2の原文列挙番号は空欄として扱わないでください"
  end
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  if (3..5).include?(number) && (number >= 4 || choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt = blocks.first
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = number >= 4 ? prompt.fetch(:text).include?("空欄 ① ～ ④") : prompt_labels == %w[① ④]
    unless labels == %w[① ② ③ ④] && prompt[:type] == "fill_in_text" && introduction_labels_match &&
        quotes.any? && quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
      raise "問#{number}の条番号・空欄と選択肢の対応が不正です"
    end
  elsif (6..11).cover?(number)
    count = [8, 11].include?(number) ? 3 : 4
    expected_labels = %w[① ② ③ ④].first(count)
    table_question = false
    labels = if table_question
      blocks.select { |block| block[:type] == "table" }.flat_map { |block| block.fetch(:rows).flatten.join.scan(/【([①②③④])】/).flatten }.uniq
    else
      quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    end
    prompt = blocks.first
    prompt_labels = table_question ? expected_labels : [expected_labels.first, expected_labels.last]
    unless quotes.size == 1 && labels == expected_labels && prompt[:type] == "fill_in_text" &&
        prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq == prompt_labels &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == count }
      raise "問#{number}の抜粋・空欄と選択肢の対応が不正です"
    end
    if number == 6 && !(prompt.fetch(:text).include?("第1章 総則 第3款 教育課程の実施と学習評価") && question.fetch(:source_text).include?("第3款"))
      raise "問6は総則第3款から出題してください"
    end
    if number == 11 && !prompt.fetch(:text).start_with?("次の文章は，『生徒指導提要』 （令和4年12月文部科学省）からの抜粋である。")
      raise "問11の資料名・書き出しが不正です"
    end
  elsif number == 15
    prompt = blocks.first
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten }.uniq
    unless quotes.size == 1 && labels == %w[① ② ③] && prompt[:type] == "fill_in_text" &&
        prompt.fetch(:text).scan(/\{\{([①②③])\}\}/).flatten.uniq == %w[① ③] &&
        prompt.fetch(:text).include?("「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）") &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
      raise "問15の資料名・抜粋・空欄と選択肢の対応が不正です"
    end
  elsif (16..18).include?(number)
    if number == 17
      unless blocks.first[:type] == "text" && quotes.size == 1 &&
          quotes.first.fetch(:text).scan(/^[①②③]　/).size == 3 &&
          quotes.first.fetch(:text).scan(/\{\{[①②③]\}\}/).empty? &&
          choices.map { |choice| choice.fetch(:content_blocks) } == %w[三つ 二つ 一つ なし].map { |text| [{ type: "text", text: text }] }
        raise "正しい記述の個数を問う問題の形式が不正です"
      end
    else
      labels = quotes.flat_map { |block| block.fetch(:text).scan(/{{([①②③])}}/).flatten }.uniq
      prompt = blocks.first
      unless quotes.size == 1 && labels == %w[① ② ③] && prompt[:type] == "fill_in_text" &&
          prompt.fetch(:text).scan(/{{([①②③])}}/).flatten.uniq == %w[① ③] &&
          choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 3 }
        raise "問#{number}の抜粋・空欄と選択肢の対応が不正です"
      end
    end
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 承認済みの全20問を公開する前に、投入元のデータを検査する。
  entry = { exam_number: 28, attributes: question, publication_status: "published" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(28, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

unless %w[ア イ ウ エ].all? { |label| questions.count { |question| question.fetch(:choices).any? { |choice| choice.fetch(:label) == label && choice.fetch(:correct) } } == 5 }
  raise "模擬試験28の全20問の正答位置は各記号5件にしてください"
end

information_source_order = questions.select { |question| (16..18).cover?(question.fetch(:question_number)) }.map do |question|
  prompt = question.fetch(:content_blocks).first.fetch(:text)
  source = question.fetch(:source_text)
  index, source_pattern = if prompt.include?("解説 情報編")
    prompt.include?("第1部") ? [2, /第1部/] : [3, /第2部/]
  elsif prompt.include?("第2章") && prompt.include?("第10節")
    [0, /第2章.*第10節/]
  elsif prompt.include?("第3章") && prompt.include?("第7節")
    [1, /第3章.*第7節/]
  else
    raise "問16〜18の導入文には出典の資料・章節を明示してください"
  end
  unless source.match?(source_pattern) && prompt.include?("解説 情報編") == source.include?("解説 情報編")
    raise "問16〜18の導入文と出典範囲が一致しません"
  end
  index
end
unless information_source_order.size == 3 && information_source_order.uniq.size == 3 && information_source_order == information_source_order.sort
  raise "問16〜18は異なる3範囲を資料順に並べてください"
end

QuestionSeedSync.import(exam_number: 28, questions: questions, publication_status: "published")

text_block = ->(text) { { type: "text", text: text } }
text_choice = lambda do |label, text, correct = false|
  { label: label, content_blocks: [{ type: "text", text: text }], correct: correct }
end
fill_in_choice = lambda do |label, cells, correct = false|
  { label: label, content_blocks: [{ type: "fill_in_choice", cells: cells }], correct: correct }
end

# 模擬試験28（承認済み問3〜11。20問完成までは下書き）
questions = [
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
]

unless questions.map { |question| question.fetch(:question_number) } == (3..11).to_a
  raise "承認済みの問番号は3〜11です"
end

categories = {
  3 => "education_system", 4 => "education_system", 5 => "education_system",
  6 => "curriculum_organization", 7 => "student_guidance_career",
  8 => "integrated_inquiry", 9 => "moral_education", 10 => "special_activities",
  11 => "student_guidance_career",
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
  quotes = blocks.select { |block| block[:type] == "fill_in_quote" }
  if number <= 5 && (number >= 4 || choices.any? { |choice| choice.fetch(:content_blocks).any? { |block| block[:type] == "fill_in_choice" } })
    labels = quotes.flat_map { |block| block.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten }.uniq
    prompt = blocks.first
    prompt_labels = prompt.fetch(:text).scan(/\{\{([①②③④])\}\}/).flatten.uniq
    introduction_labels_match = number >= 4 ? prompt.fetch(:text).include?("空欄 ① ～ ④") : prompt_labels == %w[① ④]
    unless labels == %w[① ② ③ ④] && prompt[:type] == "fill_in_text" && introduction_labels_match &&
        quotes.any? && quotes.all? { |block| block.fetch(:text).match?(/\A第\d+条(?:の\d+)?/) } &&
        choices.all? { |choice| choice.fetch(:content_blocks).size == 1 && choice.fetch(:content_blocks).first[:type] == "fill_in_choice" && choice.fetch(:content_blocks).first.fetch(:cells).size == 4 }
      raise "問#{number}の条番号・空欄と選択肢の対応が不正です"
    end
  elsif number >= 6
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
  end
  if blocks.any? { |block| block[:type] == "quote" }
    raise "問#{number}の試験抜粋枠にはfill_in_quoteを使ってください"
  end
  # 部分seedはdraftで保存するが、承認済み問題の内容は公開時と同じ品質で検査する。
  entry = { exam_number: 28, attributes: question, publication_status: "draft" }
  preview = QuestionSeedSync.preview(entry)
  payload = QuestionPayload.from_seed(28, question)
  QuestionWriter.validate_choices!(preview, payload.fetch("choices").map(&:deep_symbolize_keys))
  QuestionWriter.validate_publication!(preview, payload.fetch("choices").map(&:symbolize_keys))
end

QuestionSeedSync.import(exam_number: 28, questions: questions, publication_status: "draft")

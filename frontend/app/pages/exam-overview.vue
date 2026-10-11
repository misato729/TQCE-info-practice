<script setup lang="ts">
useSeoMeta({
  title: '試験概要｜高等学校（情報）教員資格認定試験',
  description: '高等学校（情報）教員資格認定試験 科目Ⅰの正式な出題範囲と、令和6年度から令和8年度までの過去問から見た出題傾向を紹介します。',
})

const officialLinks = {
  guide: 'https://www.nits.go.jp/shiken/2026/files/juken_johoAnnai_20260123_002.pdf',
  answers: 'https://www.nits.go.jp/shiken/2026/files/index_johoSeito_001.pdf',
  criteria: 'https://www.nits.go.jp/shiken/2026/kijyun.html',
  pastExams: 'https://www.nits.go.jp/shiken/kako.html',
  questions2024: 'https://www.nits.go.jp/shiken/2024/files/mondai_joho1_003.pdf',
  questions2025: 'https://www.nits.go.jp/shiken/2025/files/mondai_joho1_001.pdf',
  answers2024: 'https://www.nits.go.jp/shiken/2024/files/index_johoSeito_001.pdf',
  answers2025: 'https://www.nits.go.jp/shiken/2025/files/index_johoSeito_002.pdf',
  correction2025: 'https://www.nits.go.jp/shiken/notice/20250512_001.html',
  licenseRegulation: 'https://laws.e-gov.go.jp/law/329M50000080026?occasion_date=20260401#Mp-Ch_1-At_5-Pr_1',
  schoolEducationAct: 'https://laws.e-gov.go.jp/law/322AC0000000026?occasion_date=20260714',
  wasedaCourses: 'https://www.waseda.jp/fedu/tec/assets/uploads/2023/03/8933f55190b55806e327a3195b083192.pdf',
  curriculumGuideline: 'https://www.mext.go.jp/a_menu/shotou/new-cs/1384661.htm',
  curriculumText: 'https://www.mext.go.jp/content/20230120-mxt_kyoiku02-100002604_03.pdf',
  inquiryGuidance: 'https://www.mext.go.jp/content/20260115-mxt__kyoiku01_2_9.pdf',
  activitiesGuidance: 'https://www.mext.go.jp/content/1407196_22_1_1_2.pdf',
  curriculumGeneral: 'https://www.mext.go.jp/content/20211102-mxt_kyoiku02-100002620_1.pdf',
  studentGuidance: 'https://www.mext.go.jp/content/20230220-mxt_jidou01-000024699-201-1.pdf',
  reiwaEducation: 'https://www.mext.go.jp/content/20210126-mxt_syoto02-000012321_2-4.pdf',
  informationGuidance: 'https://www.mext.go.jp/content/1407073_11_1_2.pdf',
  qiitaAnalysis: 'https://qiita.com/misato729/items/c9e35ab0141ab87932dc',
}

const foundationSubjects = [
  {
    code: '1.1',
    scope: '教育の理念並びに教育に関する歴史及び思想',
    course: '教育基礎総論1（中・高）',
    displayName: '教育基礎総論',
  },
  {
    code: '1.2',
    scope: '教職の意義及び教員の役割・職務内容（チーム学校運営への対応を含む。）',
    course: '教職概論（中・高）',
    displayName: '教職概論',
  },
  {
    code: '1.3',
    scope: '教育に関する社会的、制度的又は経営的事項（学校と地域との連携及び学校安全への対応を含む。）',
    course: '教育制度総論（中・高）',
    displayName: '教育制度総論',
  },
  {
    code: '1.4',
    scope: '幼児、児童及び生徒の心身の発達及び学習の過程',
    course: '教育心理学（中・高）',
    displayName: '教育心理学',
  },
  {
    code: '1.5',
    scope: '特別の支援を必要とする幼児、児童及び生徒に対する理解',
    course: '特別支援教育（中・高）',
    displayName: '特別支援教育',
  },
  {
    code: '1.6',
    scope: '教育課程の意義及び編成の方法（カリキュラム・マネジメントを含む。）',
    course: '教育課程編成論（中・高）',
    displayName: '教育課程編成論',
  },
]

const guidanceSubjects = [
  {
    code: '2.0',
    scope: '道徳の理論及び指導法（参考：中学校の表）',
    course: '道徳教育論（中・高）',
    displayName: '道徳教育論',
  },
  {
    code: '2.1',
    scope: '総合的な探究の時間の指導法',
    course: '総合的な学習・探究論（中・高）',
    displayName: '総合的な学習・探究論',
  },
  {
    code: '2.2',
    scope: '特別活動の指導法',
    course: '特別活動論（中・高）',
    displayName: '特別活動論',
  },
  {
    code: '2.3',
    scope: '教育の方法及び技術',
    course: '教育方法・技術論（中・高）',
    displayName: '教育方法・技術論',
  },
  {
    code: '2.4',
    scope: '情報通信技術を活用した教育の理論及び方法',
    course: '教育におけるICT活用（中・高）',
    displayName: '教育におけるICT活用',
  },
  {
    code: '2.5',
    scope: '生徒指導の理論及び方法',
    course: '生徒指導・進路指導論（中・高）',
    displayName: '生徒指導・進路指導論',
  },
  {
    code: '2.6',
    scope: '教育相談（カウンセリングに関する基礎的な知識を含む。）の理論及び方法',
    course: '生徒理解と教育相談（中・高）',
    displayName: '生徒理解と教育相談',
  },
  {
    code: '2.7',
    scope: '進路指導及びキャリア教育の理論及び方法',
    course: '生徒指導・進路指導論（中・高）',
    displayName: '生徒指導・進路指導論',
  },
]

const informationFields = [
  '情報社会（職業に関する内容を含む。）・情報倫理',
  'コンピュータ・情報処理',
  '情報システム',
  '情報通信ネットワーク',
  'マルチメディア表現・マルチメディア技術',
]

const teacherCategories = [
  ...foundationSubjects.map(subject => `${subject.code} ${subject.displayName}`),
  ...guidanceSubjects.map(subject => `${subject.code} ${subject.displayName}`),
]

const informationCategories = [
  '3.1 情報科専門科目',
  '3.2 情報科教育法',
]

const questionGroups = [
  { questions: '問1〜2', category: '1.1 教育基礎総論', details: '日本教育史、西洋教育史・教育思想。人物・制度・理念・実践など' },
  { questions: '問3〜5', category: '1.3 教育制度総論', details: '問3：教育基本法、問4：学校教育法、問5：教育公務員特例法・地方公務員法' },
  { questions: '問6', category: '1.6 教育課程編成論', details: '総則第3款「教育課程の実施と学習評価」：授業改善、学習評価' },
  { questions: '問7', category: '内容に応じて分類', details: '総則第5款「生徒の発達の支援」：キャリア教育、通級による指導、不登校生徒への配慮など' },
  { questions: '問8', category: '2.1 総合的な学習・探究論', details: '総合的な探究の時間、学習指導要領解説' },
  { questions: '問9', category: '2.0 道徳教育論', details: '道徳教育の目標、人間尊重・生命への畏敬、道徳的諸価値を深める際の配慮' },
  { questions: '問10', category: '2.2 特別活動論', details: '特別活動、学習指導要領解説' },
  { questions: '問11', category: '2.5 生徒指導・進路指導論', details: '生徒指導提要、生徒指導の基本的な考え方' },
  { questions: '問12', category: '1.5 特別支援教育', details: '令和6年度：LD、令和7年度：ASD、令和8年度：ADHD' },
  { questions: '問13', category: '1.4 教育心理学', details: '青年期の発達課題・心理、アイデンティティ、友人関係' },
  { questions: '問14', category: '1.4 教育心理学', details: '学習理論、学習方法、教授・学習過程' },
  { questions: '問15', category: '1.3 教育制度総論', details: '「令和の日本型学校教育」答申' },
  { questions: '問16〜18', category: '内容に応じて分類', details: '学習指導要領第2章第10節・第3章第7節「情報」、解説情報編第1部。内容に応じて3.1又は3.2' },
  { questions: '問19', category: '3.1 情報科専門科目', details: 'アルゴリズム、プログラムの読解・実行' },
  { questions: '問20', category: '3.1 情報科専門科目', details: '尺度水準、量的データの関係、データクレンジング' },
]

const references = [
  { label: '令和8年度 高等学校（情報）教員資格認定試験 受験案内', href: officialLinks.guide },
  { label: '過去の試験問題・正答・合格判定基準（NITS）', href: officialLinks.pastExams },
  { label: '令和6年度 科目Ⅰの問題（令和7年1月10日訂正版）', href: officialLinks.questions2024 },
  { label: '令和6年度 科目Ⅰの正答', href: officialLinks.answers2024 },
  { label: '令和7年度 科目Ⅰの問題', href: officialLinks.questions2025 },
  { label: '令和7年度 科目Ⅰの正答（令和7年5月12日訂正版）', href: officialLinks.answers2025 },
  { label: '令和8年度 高等学校（情報）教員資格認定試験 第1次試験択一式試験の正答', href: officialLinks.answers },
  { label: '令和8年度教員資格認定試験の合格判定基準', href: officialLinks.criteria },
  { label: '教育職員免許法施行規則', href: officialLinks.licenseRegulation },
  { label: '学校教育法', href: officialLinks.schoolEducationAct },
  { label: '早稲田大学 教職課程科目一覧', href: officialLinks.wasedaCourses },
  { label: '高等学校学習指導要領及び解説', href: officialLinks.curriculumGuideline },
  { label: '生徒指導提要（令和4年12月）', href: officialLinks.studentGuidance },
  { label: '「令和の日本型学校教育」答申（令和3年1月26日）', href: officialLinks.reiwaEducation },
  { label: '高等学校（情報）教員資格認定試験 科目Ⅰ 過去問分析', href: officialLinks.qiitaAnalysis },
]
</script>

<template>
  <div class="page-wrap exam-overview-page">
    <header class="page-intro">
      <p class="page-label">科目Ⅰ</p>
      <h1>試験概要</h1>
      <p>
        高等学校（情報）教員資格認定試験の「教科及び教職に関する科目（Ⅰ）」について、
        試験の形式、正式な出題範囲、令和6〜8年度の出題傾向をまとめています。
      </p>
      <p class="updated-at">情報確認日：<time datetime="2026-10-11">2026年10月11日</time>／令和8年度の公表資料に基づく内容</p>
    </header>
    <dl class="exam-facts" aria-label="科目Ⅰの基本情報">
      <div><dt>試験時間</dt><dd><strong>70</strong>分</dd></div>
      <div><dt>問題数・形式</dt><dd><strong>20</strong>問・4択</dd></div>
      <div><dt>科目Ⅰの合格基準</dt><dd><strong>60</strong>点以上／100点</dd></div>
    </dl>
    <p class="fact-note">
      マークシート方式で、1問5点。20問中12問以上の正答が科目Ⅰの合格基準に相当します。
      これは試験全体の最終合格を意味するものではなく、科目Ⅱや第2次試験にも合格する必要があります（免除が認められた科目を除く）。
    </p>
    <p class="fact-note">
      参照：<a class="text-link" :href="officialLinks.guide" target="_blank" rel="noopener noreferrer">受験案内</a>、
      <a class="text-link" :href="officialLinks.answers" target="_blank" rel="noopener noreferrer">正答・配点</a>、
      <a class="text-link" :href="officialLinks.criteria" target="_blank" rel="noopener noreferrer">合格判定基準</a>
    </p>

    <section class="overview-section">
      <h2>受験案内に記載された正式な出題範囲</h2>
      <p>
        <a class="text-link" :href="officialLinks.guide" target="_blank" rel="noopener noreferrer">令和8年度受験案内</a>では、
        教育職員免許法施行規則第5条第1項表における次の科目に関する専門的事項と、高等学校「情報」に関する事項が示されています。
      </p>
      <ol class="scope-list">
        <li>教育の基礎的理解に関する科目</li>
        <li>道徳、総合的な学習の時間等の指導法及び生徒指導、教育相談等に関する科目</li>
        <li>高等学校「情報」に関する事項</li>
      </ol>
      <p>
        この三つは、受験案内の記載を学習しやすい形に整理した範囲区分です。
        本サイトでは、1と2を大分類「教職教養」、3を大分類「情報科特有」として扱います。
      </p>
    </section>

    <details class="overview-section supplementary-section">
      <summary>出題範囲の詳細と大学科目名の例</summary>
      <p>
        <a class="text-link" :href="officialLinks.licenseRegulation" target="_blank" rel="noopener noreferrer">教育職員免許法施行規則第5条第1項表</a>に記載された事項を、
        <a class="text-link" :href="officialLinks.wasedaCourses" target="_blank" rel="noopener noreferrer">早稲田大学の教職課程科目一覧（2022年度以降入学者向け）</a>を参考に整理します。
        科目名は学習分野を理解するための例であり、試験で指定された履修科目や教材ではありません。
      </p>

      <div class="subsection">
        <h3>1．教育の基礎的理解に関する科目</h3>
        <ol class="subject-list">
          <li v-for="subject in foundationSubjects" :key="subject.code">
            <h4>{{ subject.scope }}</h4>
            <p>
              大学科目名の例：{{ subject.course }}
            </p>
            <p class="site-category">本サイトでは「{{ subject.code }} {{ subject.displayName }}」と表示します。</p>
          </li>
        </ol>
      </div>

      <div class="subsection">
        <h3>2．指導法及び生徒指導・教育相談等に関する科目</h3>
        <p>
          教育職員免許法施行規則第5条の高等学校の表には「道徳の理論及び指導法」は含まれていませんが、
          第4条の中学校の表には含まれ、高等学校（情報）教員資格認定試験でも高等学校における道徳教育が実際に出題されています。
          そのため、本サイトでは道徳教育を「2.0 道徳教育論」として分類に含めます。
        </p>
        <ol class="subject-list subject-list-guidance">
          <li v-for="subject in guidanceSubjects" :key="subject.code">
            <h4>{{ subject.scope }}</h4>
            <p>
              大学科目名の例：{{ subject.course }}
            </p>
            <p class="site-category">本サイトでは「{{ subject.code }} {{ subject.displayName }}」と表示します。</p>
          </li>
        </ol>
        <p class="source-note">
          「2.5」と「2.7」は同じ表示名ですが、2.5は生徒指導、2.7は進路指導及びキャリア教育という別の法令上の事項に対応しています。
        </p>
      </div>

      <div class="subsection">
        <h3>3．高等学校「情報」に関する事項</h3>
        <p>
          受験案内では、高等学校「情報」に関する事項の法令上の出典までは明記されていません。
          本サイトでは、出題範囲を整理するため、教育職員免許法施行規則第5条第1項表の「教科及び教科の指導法に関する科目」に対応するものとして扱います。
          これは本サイトにおける整理であり、NITSが法令上の対応関係を明示したものではありません。
        </p>

        <div class="information-detail">
          <h4>3.1 教科に関する専門的事項</h4>
          <p>同表の備考一「カ 情報」では、情報の教科に関する専門的事項として、次の分野が示されています。</p>
          <ul class="plain-list compact-list">
            <li v-for="field in informationFields" :key="field">{{ field }}</li>
          </ul>
          <p>本サイトでは、これらをまとめて「3.1 情報科専門科目」と表示します。</p>
        </div>

        <div class="information-detail">
          <h4>3.2 各教科の指導法（情報通信技術の活用を含む。）</h4>
          <p>
            大学科目名の例は「情報科教育法」です。
          </p>
          <p>本サイトでは「3.2 情報科教育法」と表示します。</p>
        </div>
      </div>
    </details>

    <details class="overview-section supplementary-section">
      <summary>本サイトの分野分類</summary>
      <p>
        大分類は「教職教養」と「情報科特有」の二つです。小分類には、法令上の区分を踏まえた大学の教職課程科目名を使用します。
      </p>
      <div class="classification-block">
        <h3>教職教養</h3>
        <ul class="classification-list">
          <li v-for="category in teacherCategories" :key="category">{{ category }}</li>
        </ul>
      </div>
      <div class="classification-block">
        <h3>情報科特有</h3>
        <ul class="classification-list">
          <li v-for="category in informationCategories" :key="category">{{ category }}</li>
        </ul>
      </div>
      <p class="source-note">
        問7及び問16〜問18は、年度や問題内容によって該当する小分類が変わるため、問番号だけで分類を固定しません。
      </p>
    </details>

    <section class="overview-section">
      <div class="section-heading">
        <h2>過去問から見た出題構成</h2>
        <p>令和6〜8年度の3年度分を整理しています。</p>
      </div>

      <div class="question-balance" aria-label="問題構成">
        <div class="teacher-area">
          <strong>問1〜15</strong>
          <span>教職教養</span>
        </div>
        <div class="information-area">
          <strong>問16〜20</strong>
          <span>情報科特有</span>
        </div>
      </div>

      <div class="table-scroll" tabindex="0" role="region" aria-label="問番号ごとの出題分野">
        <table>
          <thead>
            <tr>
              <th scope="col">問題</th>
              <th scope="col">分野</th>
              <th scope="col">過去問で確認した内容・出典</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="group in questionGroups" :key="group.questions">
              <td>{{ group.questions }}</td>
              <th scope="row">{{ group.category }}</th>
              <td>{{ group.details }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <p class="trend-intro">
        以下では、令和6年度から令和8年度までの過去問と正答及び
        <a class="text-link" :href="officialLinks.qiitaAnalysis" target="_blank" rel="noopener noreferrer">過去問分析記事</a>をもとに、問番号ごとの傾向を詳しく確認します。
        確認できる過去問は3年度分に限られるため、今後の出題範囲を限定するものではありません。
        以下の「本サイトの予想問題」は、この傾向を踏まえた独自の学習範囲であり、公式な出題予定ではありません。
      </p>

      <div class="trend-list">
        <article class="trend-item">
          <h3>問1〜問2：日本教育史・西洋教育史</h3>
          <p>
            日本教育史から1問、西洋教育史・教育思想から1問という構成が続いています。
            人物名だけでなく、著作・制度・思想・実践の内容を組み合わせた問題や、出来事を年代順に並べる問題が出ています。
          </p>
          <p class="prediction-note"><strong>本サイトの予想問題：</strong>日本教育史は近代を中心に古代から現代まで、西洋教育史は主要な人物・著作・教育思想を扱います。</p>
        </article>

        <article class="trend-item">
          <h3>問3〜問5：教育に関する法令</h3>
          <p>
            令和6年度から令和8年度までに、教育基本法、学校教育法、地方公務員法及び教育公務員特例法から出題されています。
          </p>
          <div class="question-detail">
            <h4>問3：教育基本法</h4>
            <p>令和6年度は適切でない条文、令和7年度は正しい条文、令和8年度は正しい記述の個数を選ぶ問題です。教育基本法の規定と、憲法や他の法律の似た表現を区別することが問われています。</p>
            <p class="prediction-note"><strong>本サイトの予想問題：</strong>記述の正誤に加え、条文の穴埋めも扱います。</p>
          </div>
          <div class="question-detail">
            <h4>問4：学校教育法</h4>
            <p>3年度とも条文の穴埋めです。高等学校の目的・目標だけでなく、令和7年度は懲戒と体罰、令和8年度は教科用図書・デジタル教科書に関する規定が出ています。</p>
          </div>
          <div class="question-detail">
            <h4>問5：教育公務員特例法・地方公務員法</h4>
            <p>教育公務員特例法を中心に、条文の穴埋めや内容の正誤が問われています。令和6年度は地方公務員法と組み合わせて出題されました。研修、採用、服務などの具体的な規定を確認することが大切です。</p>
          </div>
          <p>
            <a class="text-link" :href="officialLinks.schoolEducationAct" target="_blank" rel="noopener noreferrer">学校教育法</a>は、第1章「総則」と第6章「高等学校」だけに限定されません。
            第34条は小学校の章にありますが、第62条によって高等学校にも準用されます。
            条文の置かれた章だけで対象を判断せず、高等学校に適用される規定も確認しましょう。
          </p>
        </article>

        <article class="trend-item">
          <h3>問6〜問10：高等学校学習指導要領及び解説</h3>
          <p>
            主に
            <a class="text-link" :href="officialLinks.curriculumGuideline" target="_blank" rel="noopener noreferrer">『高等学校学習指導要領』及び『高等学校学習指導要領（平成30年告示）解説』</a>から出題されています。
            過去3年度の問6〜問10は全て原文の一部を空欄にした穴埋め問題であるため、内容の概要だけでなく、章、款、項及び原文の表現を確認する必要があります。
          </p>

          <div class="question-detail">
            <h4>問6：教育課程の実施と学習評価</h4>
            <p>
              令和6年度から令和8年度まで3年連続で、第1章「総則」第3款「教育課程の実施と学習評価」から出題されています。
              授業改善や学習評価について、内容と原文の表現を確認しておきたい範囲です。
            </p>
          </div>

          <div class="question-detail">
            <h4>問7：生徒の発達の支援</h4>
            <p>
              主な出題箇所は、第1章「総則」第5款「生徒の発達の支援」です。
              令和6年度はキャリア教育・進路指導、令和7年度は障害のある生徒への通級による指導、令和8年度は不登校生徒への配慮が出ています。
            </p>
          </div>

          <div class="question-detail">
            <h4>問8：総合的な探究の時間</h4>
            <p>
              主な出題元は、第4章「総合的な探究の時間」及び『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』です。
              探究の過程、探究課題の設定、自己の在り方生き方との関係などを確認しましょう。
            </p>
            <p>参照：<a class="text-link" :href="officialLinks.inquiryGuidance" target="_blank" rel="noopener noreferrer">総合的な探究の時間編</a></p>
          </div>

          <div class="question-detail">
            <h4>問9：道徳教育</h4>
            <p>過去3年度で確認した出題箇所は、次のとおりです。</p>
            <ul class="plain-list compact-list">
              <li>令和6年度：第1章「総則」第1款「高等学校教育の基本と教育課程の役割」2（2）の第2段落</li>
              <li>令和7年度：第1章「総則」第1款「高等学校教育の基本と教育課程の役割」2（2）の第2・第3段落</li>
              <li>令和8年度：第1章「総則」第7款「道徳教育に関する配慮事項」2</li>
            </ul>
            <p>
              道徳教育の目標に加え、人間尊重や生命への畏敬、体験や思索を通して道徳的諸価値を深める際の配慮まで問われています。
            </p>
            <p class="prediction-note">
              <strong>本サイトの予想問題：</strong>上記に加え、道徳教育の位置付けを示す第1款2（2）の第1段落も扱います。
              また、全体計画・指導体制を定める第7款1も関連する範囲として扱います。これらは過去問で直接確認した箇所とは区別しています。
            </p>
            <p>
              参照：
              <a class="text-link" :href="officialLinks.curriculumText" target="_blank" rel="noopener noreferrer">高等学校学習指導要領</a>、
              <a class="text-link" :href="officialLinks.curriculumGeneral" target="_blank" rel="noopener noreferrer">解説 総則編</a>
            </p>
          </div>

          <div class="question-detail">
            <h4>問10：特別活動</h4>
            <p>
              主な出題元は、第5章「特別活動」及び『高等学校学習指導要領（平成30年告示）解説 特別活動編』です。
              目標や指導上の視点、ホームルーム活動・生徒会活動・学校行事の内容を確認しておきたい範囲です。
            </p>
            <p>参照：<a class="text-link" :href="officialLinks.activitiesGuidance" target="_blank" rel="noopener noreferrer">特別活動編</a></p>
          </div>
        </article>

        <article class="trend-item">
          <h3>問11：生徒指導提要</h3>
          <p>
            <a class="text-link" :href="officialLinks.studentGuidance" target="_blank" rel="noopener noreferrer">『生徒指導提要』</a>から出題されています。
            生徒指導の定義、重層的支援構造、実践上の視点などが問われています。原文の穴埋めに加え、令和7年度には4層の構造を表で確認する問題も出ています。
          </p>
          <p>用語の名前だけでなく、誰を対象に、何を目的として、どのように支援するのかを関連付けて押さえましょう。</p>
        </article>

        <article class="trend-item">
          <h3>問12：特別支援教育</h3>
          <p>令和6年度から令和8年度までは、LD、ASD、ADHDに関する問題が出題されています。</p>
          <p>ただし、正式な出題範囲は発達障害だけに限定されていません。障害の特徴と教育的な支援を結び付けて理解することが大切です。</p>
          <p class="prediction-note"><strong>本サイトの予想問題：</strong>発達障害に加え、視覚障害・聴覚障害・知的障害など、その他の障害や合理的配慮、通級による指導も扱います。</p>
        </article>

        <article class="trend-item">
          <h3>問13：青年期の発達・心理</h3>
          <p>
            3年度とも青年期に関する問題です。発達課題、アイデンティティ、友人関係など、青年期の特徴と主要な発達理論を確認しましょう。
          </p>
          <p class="prediction-note"><strong>本サイトの予想問題：</strong>青年期を中心に、他の発達段階や理論との比較も一部扱います。</p>
        </article>

        <article class="trend-item">
          <h3>問14：学習理論・学習方法</h3>
          <p>
            これまで、学習理論や学習方法そのものに関する問題が出題されています。
            発見学習、プログラム学習、有意味受容学習などについて、提唱者・目的・特徴や、理論どうしの違いを押さえておきたい範囲です。
          </p>
        </article>

        <article class="trend-item">
          <h3>問15：「令和の日本型学校教育」答申</h3>
          <p>
            <a class="text-link" :href="officialLinks.reiwaEducation" target="_blank" rel="noopener noreferrer">「『令和の日本型学校教育』の構築を目指して～全ての子供たちの可能性を引き出す，個別最適な学びと，協働的な学びの実現～（答申）」 （令和3年1月26日中央教育審議会）</a>から出題されています。
          </p>
          <p>過去3年度は記述の正誤を判断する形式です。個別最適な学びと協働的な学び、教師の役割、連携と分担による学校マネジメントなど、答申が示す考え方を確認しましょう。</p>
          <p class="prediction-note"><strong>本サイトの予想問題：</strong>記述の正誤に加え、原文の穴埋めも扱います。</p>
        </article>

        <article class="trend-item">
          <h3>問16〜問18：情報の学習指導要領及び解説</h3>
          <p>過去3年度で確認した出題元は、次の3範囲です。</p>
          <ul class="plain-list compact-list">
            <li>『高等学校学習指導要領』第2章第10節「情報」</li>
            <li>『高等学校学習指導要領』第3章第7節「情報」</li>
            <li>『高等学校学習指導要領（平成30年告示）解説 情報編』第1部「各学科に共通する教科『情報』」</li>
          </ul>
          <p>
            令和6・7年度は解説情報編第1部から出題され、令和8年度には学習指導要領本体の共通教科・専門教科からの出題も加わりました。
            穴埋めだけでなく、原典に示された内容を選ぶ問題や記述の正誤を判断する問題もあります。令和8年度問18は、正しい記述の個数を選ぶ形式です。
          </p>
          <p>
            学習指導要領本体と解説の両方で、目標・内容・内容の取扱いの関係を確認しましょう。
          </p>
          <p class="prediction-note">
            <strong>本サイトの予想問題：</strong>上記に加え、解説情報編第2部「主として専門学科において開設される教科『情報』」も扱います。
            本体で専門教科からの出題があったことを踏まえた予想であり、第2部からの直接の出題実績を確認したという意味ではありません。
          </p>
          <p>
            参照：
            <a class="text-link" :href="officialLinks.informationGuidance" target="_blank" rel="noopener noreferrer">高等学校学習指導要領解説 情報編</a>
          </p>
        </article>

        <article class="trend-item">
          <h3>問19：アルゴリズム・プログラムの読解</h3>
          <p>
            アルゴリズムやプログラムの読解に関する問題です。年度ごとの主な論点は次のとおりです。
          </p>
          <ul class="plain-list compact-list">
            <li>令和6年度：二分探索の処理回数</li>
            <li>令和7年度：二つの整列アルゴリズムの処理回数などの比較</li>
            <li>令和8年度：代入による値の更新、繰り返し内の処理位置の修正</li>
          </ul>
          <p>変数の値、繰り返しの範囲、条件分岐、添字、インデントを順に追って読むことが大切です。</p>
          <p class="source-note">令和7年度問19には正答の訂正があります。過去問を確認する際は、<a class="text-link" :href="officialLinks.correction2025" target="_blank" rel="noopener noreferrer">NITSの訂正案内</a>と訂正版の正答表をご確認ください。</p>
        </article>

        <article class="trend-item">
          <h3>問20：データの性質・分析</h3>
          <p>
            データの性質や分析に関する基本概念を問う問題です。過去3年度で直接確認した論点は次のとおりです。
          </p>
          <ul class="plain-list compact-list">
            <li>令和6年度：データと尺度水準の組合せ</li>
            <li>令和7年度：量的データの関係に関する記述の正誤</li>
            <li>令和8年度：データクレンジングに関する記述の正誤</li>
          </ul>
          <p class="prediction-note"><strong>本サイトの予想問題：</strong>これらに加え、代表値・四分位数などの関連する基礎的な分析も扱います。用語の区別や結果の解釈を中心に、計算を含む場合も短い手順の問題としています。</p>
        </article>
      </div>
    </section>

    <section class="overview-section">
      <h2>本サイトの予想問題について</h2>
      <p>令和6〜8年度の過去問を参考に、令和8年度の問題の内容・形式・選択肢の情報量を目安として作成しています。過去問そのものの再掲載ではなく、本サイト独自の予想問題です。</p>
      <p>本番の出題や合格を保証するものではありません。予想問題で確認した内容は、解説の出典から公式資料にも当たり、前後の文脈とあわせて理解を深めてください。</p>
    </section>

    <aside class="notice" aria-labelledby="notice-title">
      <UIcon name="i-lucide-info" aria-hidden="true" />
      <div>
        <h2 id="notice-title">出題傾向について</h2>
        <p>
          このページの分析対象は令和6〜8年度の3年度分です。今後、問題構成、出題元、難易度及び出題分野が変わる可能性があります。
          本サイトの分類は、正式な出題範囲を変更又は限定するものではありません。
        </p>
        <p>
          早稲田大学の科目名は学習分野を具体化するための参考であり、NITSが指定又は推奨している教材ではありません。
          Qiitaの記事は出題傾向の分析に使用し、法令や学習指導要領の最終的な根拠には公式原典を使用します。
        </p>
        <p>受験資格、日程、免除、合格基準などは、受験する年度のNITSの案内を必ずご確認ください。</p>
      </div>
    </aside>

    <section class="overview-section references-section">
      <h2>主な参考資料</h2>
      <ul class="reference-list">
        <li v-for="reference in references" :key="reference.href">
          <a :href="reference.href" target="_blank" rel="noopener noreferrer">
            {{ reference.label }}
            <UIcon name="i-lucide-external-link" aria-hidden="true" />
          </a>
        </li>
      </ul>
    </section>

    <section class="practice-cta">
      <div>
        <h2>問題を解いて確認する</h2>
        <p>出題分野を確認したら、予想問題に取り組んでみましょう。</p>
      </div>
      <NuxtLink class="primary-link" to="/#practice-launcher">
        問題演習を始める
        <UIcon name="i-lucide-arrow-right" aria-hidden="true" />
      </NuxtLink>
    </section>
  </div>
</template>

<style scoped>
.exam-overview-page {
  padding-bottom: 8px;
}

.page-label {
  margin: 0 0 8px;
  color: var(--teal-dark);
  font-size: 13px;
  font-weight: 800;
}

.exam-facts {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  margin: 0;
  border-top: 1px solid var(--line);
  border-bottom: 1px solid var(--line);
}

.exam-facts div {
  min-height: 116px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 8px;
  padding: 20px;
}

.exam-facts div + div {
  border-left: 1px solid var(--line);
}

.exam-facts dt {
  color: var(--muted);
  font-size: 13px;
  font-weight: 700;
}

.exam-facts dd {
  margin: 0;
  color: var(--ink);
  font-size: 15px;
  font-weight: 700;
}

.exam-facts strong {
  margin-right: 3px;
  color: var(--teal-dark);
  font-size: 30px;
  line-height: 1;
}

.fact-note {
  margin: 16px 0 0;
  color: var(--muted);
  font-size: 14px;
  line-height: 1.8;
}

.overview-section {
  padding: 42px 0;
  border-bottom: 1px solid var(--line);
}

.page-intro .updated-at {
  margin-top: 14px;
  font-size: 13px;
}

.supplementary-section {
  padding: 22px 0;
}

.supplementary-section summary {
  color: var(--ink);
  font-size: 17px;
  font-weight: 700;
  line-height: 1.6;
  cursor: pointer;
}

.supplementary-section summary:focus-visible,
.table-scroll:focus-visible {
  outline: 2px solid var(--teal-dark);
  outline-offset: 5px;
}

.prediction-note strong {
  color: var(--ink);
}

.overview-section h2,
.notice h2,
.practice-cta h2 {
  margin: 0;
  font-size: 23px;
  line-height: 1.4;
}

.overview-section > p,
.section-heading p,
.notice p,
.practice-cta p {
  color: var(--muted);
  line-height: 1.9;
}

.overview-section > p {
  max-width: 820px;
  margin: 16px 0 0;
}

.plain-list {
  display: grid;
  gap: 8px;
  margin: 18px 0 0;
  padding-left: 22px;
  color: #42555d;
  line-height: 1.7;
}

.scope-list {
  display: grid;
  gap: 10px;
  margin: 20px 0;
  padding-left: 24px;
  color: #42555d;
  line-height: 1.8;
}

.scope-list,
.subject-list {
  list-style: decimal;
}

.plain-list,
.classification-list {
  list-style: disc;
}

.scope-list li::marker,
.subject-list li::marker {
  color: var(--teal-dark);
  font-weight: 800;
}

.text-link,
.subject-list a,
.information-detail a {
  color: var(--teal-dark);
  font-weight: 700;
  text-decoration: underline;
  text-decoration-thickness: 1px;
  text-underline-offset: 3px;
}

.subsection {
  margin-top: 36px;
}

.subsection + .subsection {
  padding-top: 36px;
  border-top: 1px solid var(--line);
}

.subsection h3,
.classification-block h3,
.trend-item h3 {
  margin: 0;
  color: var(--ink);
  font-size: 19px;
  line-height: 1.5;
}

.subsection > p,
.information-detail p,
.classification-block + p,
.trend-item p,
.question-detail p,
.trend-intro {
  color: var(--muted);
  line-height: 1.9;
}

.subsection > p {
  margin: 14px 0 0;
}

.subject-list {
  display: grid;
  gap: 0;
  margin: 20px 0 0;
  padding-left: 28px;
}

.subject-list > li {
  padding: 0 0 22px 8px;
}

.subject-list > li + li {
  padding-top: 22px;
  border-top: 1px solid var(--line);
}

.subject-list h4,
.information-detail h4,
.question-detail h4 {
  margin: 0;
  color: var(--ink);
  font-size: 16px;
  line-height: 1.65;
}

.subject-list p {
  margin: 8px 0 0;
  color: var(--muted);
  line-height: 1.8;
}

.subject-list .site-category {
  color: #42555d;
  font-weight: 700;
}

.source-note {
  margin: 18px 0 0;
  padding: 14px 16px;
  border-left: 3px solid #a9b9bd;
  background: #f4f7f7;
  color: #4f6169;
  font-size: 14px;
  line-height: 1.8;
}

.information-detail {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid var(--line);
}

.information-detail p {
  margin: 10px 0 0;
}

.compact-list {
  margin-top: 12px;
}

.classification-block {
  margin-top: 28px;
}

.classification-block + .classification-block {
  padding-top: 28px;
  border-top: 1px solid var(--line);
}

.classification-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 9px 28px;
  margin: 16px 0 0;
  padding-left: 22px;
  color: #42555d;
  line-height: 1.7;
}

.section-heading {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 24px;
}

.section-heading p {
  margin: 0;
  font-size: 14px;
}

.question-balance {
  display: grid;
  grid-template-columns: 3fr 1fr;
  margin-bottom: 20px;
  border-radius: 6px;
  overflow: hidden;
}

.question-balance > div {
  min-height: 76px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 3px;
  padding: 12px;
}

.teacher-area {
  background: #dceeee;
  color: var(--teal-dark);
}

.information-area {
  background: #f8e8e3;
  color: #8c3f31;
}

.question-balance span {
  font-size: 13px;
  font-weight: 700;
}

.table-scroll {
  overflow-x: auto;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--surface);
}

table {
  width: 100%;
  min-width: 680px;
  border-collapse: collapse;
  text-align: left;
}

th,
td {
  padding: 15px 18px;
  border-bottom: 1px solid var(--line);
  font-size: 14px;
  line-height: 1.65;
  vertical-align: top;
}

thead th {
  background: #eef4f4;
  color: #41555c;
  font-size: 13px;
}

tbody tr:last-child th,
tbody tr:last-child td {
  border-bottom: 0;
}

tbody td:first-child {
  width: 110px;
  color: var(--teal-dark);
  font-weight: 800;
  white-space: nowrap;
}

tbody th {
  width: 220px;
  color: var(--ink);
}

tbody td:last-child {
  color: var(--muted);
}

.trend-intro {
  margin: 28px 0 0;
}

.trend-list {
  display: grid;
  margin-top: 30px;
}

.trend-item {
  padding: 30px 0;
  border-top: 1px solid var(--line);
}

.trend-item:last-child {
  padding-bottom: 0;
}

.trend-item > p {
  margin: 12px 0 0;
}

.trend-item .plain-list {
  margin-top: 12px;
}

.article-list {
  display: grid;
  gap: 10px;
  margin: 16px 0 0;
  padding: 0;
  list-style: none;
}

.article-list li {
  display: grid;
  grid-template-columns: 78px 1fr;
  gap: 10px;
  color: #42555d;
  line-height: 1.7;
}

.article-list strong {
  color: var(--teal-dark);
}

.question-detail {
  margin-top: 22px;
  padding-left: 18px;
  border-left: 3px solid #d5e2e2;
}

.question-detail p {
  margin: 9px 0 0;
}

.support-list {
  margin-top: 16px;
}

.notice {
  display: grid;
  grid-template-columns: 24px 1fr;
  gap: 14px;
  margin-top: 42px;
  padding: 22px;
  border-left: 4px solid var(--yellow);
  background: #fffaf0;
}

.notice > :deep(svg) {
  width: 24px;
  height: 24px;
  color: #8a6412;
}

.notice h2 {
  font-size: 18px;
}

.notice p {
  margin: 7px 0 0;
  font-size: 14px;
}

.notice p + p {
  margin-top: 10px;
}

.reference-list {
  display: grid;
  gap: 10px;
  margin: 18px 0 0;
  padding: 0;
  list-style: none;
}

.reference-list a {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: var(--teal-dark);
  font-weight: 700;
  line-height: 1.7;
}

.reference-list :deep(svg) {
  width: 16px;
  height: 16px;
  flex: 0 0 16px;
}

.practice-cta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
  padding: 42px 0 16px;
}

.practice-cta p {
  margin: 8px 0 0;
}

.practice-cta .primary-link {
  flex: 0 0 auto;
}

@media (max-width: 720px) {
  .exam-facts {
    grid-template-columns: 1fr;
  }

  .exam-facts div {
    min-height: 90px;
  }

  .exam-facts div + div {
    border-top: 1px solid var(--line);
    border-left: 0;
  }

  .overview-section {
    padding: 34px 0;
  }

  .supplementary-section {
    padding: 20px 0;
  }

  .classification-list {
    grid-template-columns: 1fr;
  }

  .subsection {
    margin-top: 30px;
  }

  .subsection + .subsection {
    padding-top: 30px;
  }

  .subject-list {
    padding-left: 24px;
  }

  .article-list li {
    grid-template-columns: 1fr;
    gap: 2px;
  }

  .question-detail {
    padding-left: 14px;
  }

  .section-heading,
  .practice-cta {
    align-items: flex-start;
    flex-direction: column;
  }

  .section-heading {
    gap: 8px;
  }

  .question-balance > div {
    min-height: 88px;
  }

  .notice {
    margin-top: 34px;
    padding: 18px;
  }

  .practice-cta .primary-link {
    width: 100%;
  }
}
</style>

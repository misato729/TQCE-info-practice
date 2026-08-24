<script setup lang="ts">
useSeoMeta({
  title: '試験概要｜高等学校（情報）教員資格認定試験',
  description: '高等学校（情報）教員資格認定試験 科目Ⅰの正式な出題範囲と、令和6年度から令和8年度までの過去問から見た出題傾向を紹介します。',
})

const officialLinks = {
  guide: 'https://www.nits.go.jp/shiken/2026/files/juken_johoAnnai_20260123_002.pdf',
  answers: 'https://www.nits.go.jp/shiken/2026/files/index_johoSeito_001.pdf',
  criteria: 'https://www.nits.go.jp/shiken/2026/kijyun.html',
  licenseRegulation: 'https://laws.e-gov.go.jp/law/329M50000080026?occasion_date=20260401#Mp-Ch_1-At_5-Pr_1',
  schoolEducationAct: 'https://laws.e-gov.go.jp/law/322AC0000000026?occasion_date=20260714',
  wasedaCourses: 'https://www.waseda.jp/fedu/tec/assets/uploads/2023/03/8933f55190b55806e327a3195b083192.pdf',
  curriculumGuideline: 'https://www.mext.go.jp/a_menu/shotou/new-cs/1384661.htm',
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
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905L012026150000905L15&pLng=jp',
  },
  {
    code: '1.2',
    scope: '教職の意義及び教員の役割・職務内容（チーム学校運営への対応を含む。）',
    course: '教職概論（中・高）',
    displayName: '教職概論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=1500009052012026150000905215&pLng=jp',
  },
  {
    code: '1.3',
    scope: '教育に関する社会的、制度的又は経営的事項（学校と地域との連携及び学校安全への対応を含む。）',
    course: '教育制度総論（中・高）',
    displayName: '教育制度総論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905M012026150000905M15&pLng=jp',
  },
  {
    code: '1.4',
    scope: '幼児、児童及び生徒の心身の発達及び学習の過程',
    course: '教育心理学（中・高）',
    displayName: '教育心理学',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905N012026150000905N15&pLng=jp',
  },
  {
    code: '1.5',
    scope: '特別の支援を必要とする幼児、児童及び生徒に対する理解',
    course: '特別支援教育（中・高）',
    displayName: '特別支援教育',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905P012026150000905P15&pLng=jp',
  },
  {
    code: '1.6',
    scope: '教育課程の意義及び編成の方法（カリキュラム・マネジメントを含む。）',
    course: '教育課程編成論（中・高）',
    displayName: '教育課程編成論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905E012026150000905E15&pLng=jp',
  },
]

const guidanceSubjects = [
  {
    code: '2.0',
    scope: '道徳の理論及び指導法',
    course: '道徳教育論（中・高）',
    displayName: '道徳教育論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905K012026150000905K15&pLng=jp',
  },
  {
    code: '2.1',
    scope: '総合的な学習の時間の指導法（高等学校では総合的な探究の時間の指導法）',
    course: '総合的な学習・探究論（中・高）',
    displayName: '総合的な学習・探究論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905I012026150000905I15&pLng=jp',
  },
  {
    code: '2.2',
    scope: '特別活動の指導法',
    course: '特別活動論（中・高）',
    displayName: '特別活動論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=1500009058012026150000905815&pLng=jp',
  },
  {
    code: '2.3',
    scope: '教育の方法及び技術',
    course: '教育方法・技術論（中・高）',
    displayName: '教育方法・技術論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905H012026150000905H15&pLng=jp',
  },
  {
    code: '2.4',
    scope: '情報通信技術を活用した教育の理論及び方法',
    course: '教育におけるICT活用（中・高）',
    displayName: '教育におけるICT活用',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905Q012026150000905Q15&pLng=jp',
  },
  {
    code: '2.5',
    scope: '生徒指導の理論及び方法',
    course: '生徒指導・進路指導論（中・高）',
    displayName: '生徒指導・進路指導論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905B012026150000905B15&pLng=jp',
  },
  {
    code: '2.6',
    scope: '教育相談（カウンセリングに関する基礎的な知識を含む。）の理論及び方法',
    course: '生徒理解と教育相談（中・高）',
    displayName: '生徒理解と教育相談',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905J012026150000905J15&pLng=jp',
  },
  {
    code: '2.7',
    scope: '進路指導及びキャリア教育の理論及び方法',
    course: '生徒指導・進路指導論（中・高）',
    displayName: '生徒指導・進路指導論',
    syllabus: 'https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=150000905B012026150000905B15&pLng=jp',
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
  { questions: '問1〜2', category: '1.1 教育基礎総論', details: '日本教育史、西洋教育史、教育の理念・思想' },
  { questions: '問3〜5', category: '1.3 教育制度総論', details: '教育基本法、学校教育法、地方公務員法、教育公務員特例法' },
  { questions: '問6', category: '1.6 教育課程編成論', details: '教育課程の実施、学習評価、カリキュラム・マネジメント' },
  { questions: '問7', category: '内容に応じて分類', details: '1.5、1.6、2.5、2.7などから問題内容に合わせて分類' },
  { questions: '問8', category: '2.1 総合的な学習・探究論', details: '総合的な探究の時間、学習指導要領解説' },
  { questions: '問9', category: '2.0 道徳教育論', details: '高等学校における道徳教育、全体計画、指導体制' },
  { questions: '問10', category: '2.2 特別活動論', details: '特別活動、学習指導要領解説' },
  { questions: '問11', category: '2.5 生徒指導・進路指導論', details: '生徒指導提要、生徒指導の基本的な考え方' },
  { questions: '問12', category: '1.5 特別支援教育', details: '発達障害に限定しない、特別支援教育における障害全般' },
  { questions: '問13', category: '1.4 教育心理学', details: '青年期の発達課題・心理、発達理論' },
  { questions: '問14', category: '1.4 教育心理学', details: '学習理論、学習方法、教授・学習過程' },
  { questions: '問15', category: '1.3 教育制度総論', details: '「令和の日本型学校教育」答申' },
  { questions: '問16〜18', category: '内容に応じて分類', details: '3.1 情報科専門科目、3.2 情報科教育法' },
  { questions: '問19', category: '3.1 情報科専門科目', details: 'アルゴリズム、プログラムの読解・実行' },
  { questions: '問20', category: '3.1 情報科専門科目', details: 'データサイエンス、統計、データの分析' },
]

const relatedSchoolEducationArticles = [
  { article: '第70条', detail: '中等教育学校及びその後期課程に対する関係規定の準用' },
  { article: '第71条', detail: '同じ設置者が設置する中学校と高等学校における一貫教育' },
  { article: '第72条', detail: '特別支援学校における高等学校に準ずる教育' },
  { article: '第74条', detail: '特別支援学校による高等学校等への助言又は援助' },
  { article: '第77条', detail: '特別支援学校高等部の学科及び教育課程' },
  { article: '第81条', detail: '高等学校等における特別支援教育及び特別支援学級' },
  { article: '第82条', detail: '特別支援学校に対する高等学校関係規定などの準用' },
  { article: '第137条', detail: '学校施設の社会教育その他公共のための利用' },
]

const specialSupportAreas = [
  '視覚障害',
  '聴覚障害',
  '知的障害',
  '肢体不自由',
  '病弱・身体虚弱',
  '言語障害',
  '情緒障害',
  'LD、ADHD、ASDなどの発達障害',
  '特別支援学級',
  '通級による指導',
  '合理的配慮',
  '校内支援体制や関係機関との連携',
]

const references = [
  { label: '令和8年度 高等学校（情報）教員資格認定試験 受験案内', href: officialLinks.guide },
  { label: '令和8年度 高等学校（情報）教員資格認定試験 第1次試験択一式試験の正答', href: officialLinks.answers },
  { label: '令和8年度教員資格認定試験の合格判定基準', href: officialLinks.criteria },
  { label: '教育職員免許法施行規則', href: officialLinks.licenseRegulation },
  { label: '学校教育法', href: officialLinks.schoolEducationAct },
  { label: '早稲田大学 教職課程科目一覧', href: officialLinks.wasedaCourses },
  { label: '高等学校学習指導要領及び解説', href: officialLinks.curriculumGuideline },
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
        受験案内に記載された正式な出題範囲と、令和6年度から令和8年度までの過去問から見た出題傾向を整理します。
      </p>
    </header>
    <p class="fact-note">
      試験時間は70分、マークシート方式の択一式です。令和8年度は1問5点、合計100点で、20問中12問以上の正答が合格基準に相当します。
    </p>

    <section class="overview-section">
      <h2>資料の使い分け</h2>
      <p>
        正式な出題範囲は教職員支援機構（NITS）の受験案内、範囲の細分化は教育職員免許法施行規則、
        大学科目との対応は早稲田大学の教職課程科目一覧とシラバス、問番号ごとの傾向は過去問と正答及び過去問分析記事を参照しています。
      </p>
      <p>
        早稲田大学の科目名は、法令上の事項を具体的な学習分野へ置き換えるための参考です。
        また、過去問分析は今後の出題範囲を限定するものではありません。
      </p>
    </section>

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

    <section class="overview-section">
      <h2>法令上の事項と大学科目との対応</h2>
      <p>
        <a class="text-link" :href="officialLinks.licenseRegulation" target="_blank" rel="noopener noreferrer">教育職員免許法施行規則第5条第1項表</a>に記載された事項を、
        <a class="text-link" :href="officialLinks.wasedaCourses" target="_blank" rel="noopener noreferrer">早稲田大学の教職課程科目一覧</a>及びシラバスを参考に整理します。
      </p>

      <div class="subsection">
        <h3>1．教育の基礎的理解に関する科目</h3>
        <ol class="subject-list">
          <li v-for="subject in foundationSubjects" :key="subject.code">
            <h4>{{ subject.scope }}</h4>
            <p>
              対応する科目は、
              <a :href="subject.syllabus" target="_blank" rel="noopener noreferrer">{{ subject.course }}</a>です。
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
              対応する科目は、
              <a :href="subject.syllabus" target="_blank" rel="noopener noreferrer">{{ subject.course }}</a>です。
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
            対応する科目は、
            <a href="https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=1500009255012026150000925515&pLng=jp" target="_blank" rel="noopener noreferrer">情報科教育法</a>です。
          </p>
          <p>本サイトでは「3.2 情報科教育法」と表示します。</p>
        </div>
      </div>
    </section>

    <section class="overview-section">
      <h2>本サイトで使用する分類</h2>
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
    </section>

    <section class="overview-section">
      <div class="section-heading">
        <h2>過去問から見た出題構成</h2>
        <p>令和6年度から令和8年度までの過去問をもとに整理しています。</p>
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

      <div class="table-scroll">
        <table>
          <thead>
            <tr>
              <th scope="col">問題</th>
              <th scope="col">分野</th>
              <th scope="col">主な内容・出典</th>
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
      </p>

      <div class="trend-list">
        <article class="trend-item">
          <h3>問1〜問2：「1.1 教育基礎総論」</h3>
          <p>
            日本教育史から1問、西洋教育史・教育思想から1問という構成が続いています。
            西洋教育史では、人物名や著作だけでなく、教育理論や教育実践の詳しい内容が問われることがあります。
          </p>
          <p>今後も同様の構成が考えられますが、問番号ごとの出題分野が公式に固定されているわけではありません。</p>
        </article>

        <article class="trend-item">
          <h3>問3〜問5：「1.3 教育制度総論」</h3>
          <p>
            令和6年度から令和8年度までに、教育基本法、学校教育法、地方公務員法及び教育公務員特例法から出題されています。
          </p>
          <p>学校教育法については、まず次の範囲を確認する必要があります。</p>
          <ul class="plain-list compact-list">
            <li>第1章「総則」（第1条〜第15条）</li>
            <li>第6章「高等学校」（第50条〜第62条）</li>
          </ul>
          <p>
            ただし、出題範囲はこの二つの章だけに限られません。
            <a class="text-link" :href="officialLinks.schoolEducationAct" target="_blank" rel="noopener noreferrer">学校教育法第62条</a>により、次の規定が高等学校に準用されます。
          </p>
          <ul class="plain-list compact-list">
            <li>第30条第2項</li>
            <li>第31条</li>
            <li>第34条</li>
            <li>第37条第4項から第18項まで及び第20項</li>
            <li>第42条から第44条まで</li>
          </ul>
          <p>
            そのため、小学校の章に置かれている条文でも、第62条によって高等学校へ準用される場合は出題対象になり得ます。
            実際に令和8年度試験では、教科用図書及びデジタル教科書に関係する第34条から出題されました。
          </p>
          <p>また、次の条文も高等学校又は高等学校段階の教育と直接関係しています。</p>
          <ul class="article-list">
            <li v-for="item in relatedSchoolEducationArticles" :key="item.article">
              <strong>{{ item.article }}</strong><span>{{ item.detail }}</span>
            </li>
          </ul>
          <p>
            第137条は高等学校だけを対象にした条文ではありませんが、高等学校を含む学校一般に適用されます。
            学校教育法は、第1章と第6章に加えて、第62条の準用先や高等学校段階の教育を扱う周辺条文も確認する必要があります。
          </p>
        </article>

        <article class="trend-item">
          <h3>問6〜問10：高等学校学習指導要領及び解説</h3>
          <p>
            主に
            <a class="text-link" :href="officialLinks.curriculumGuideline" target="_blank" rel="noopener noreferrer">『高等学校学習指導要領』及び『高等学校学習指導要領（平成30年告示）解説』</a>から出題されています。
            原文の一部を空欄にした穴埋め問題もあるため、内容の概要だけでなく、章、款、項及び原文の表現を確認する必要があります。
          </p>

          <div class="question-detail">
            <h4>問6：「1.6 教育課程編成論」</h4>
            <p>
              主な出題箇所は、第1章「総則」第3款「教育課程の実施と学習評価」です。
              教育課程の実施、主体的・対話的で深い学び、学習評価、カリキュラム・マネジメントなどが関係します。
            </p>
          </div>

          <div class="question-detail">
            <h4>問7：問題内容に応じて分類</h4>
            <p>
              主な出題箇所は、第1章「総則」第5款「生徒の発達の支援」です。
              生徒指導、進路指導、キャリア教育、特別支援教育、教育課程上の配慮など、複数分野にまたがる内容が含まれます。
            </p>
            <p>
              「1.5 特別支援教育」「1.6 教育課程編成論」「2.5 生徒指導・進路指導論」「2.7 生徒指導・進路指導論」などから、実際に問う知識に合わせて分類します。
            </p>
          </div>

          <div class="question-detail">
            <h4>問8：「2.1 総合的な学習・探究論」</h4>
            <p>
              主な出題元は、第4章「総合的な探究の時間」及び『高等学校学習指導要領（平成30年告示）解説 総合的な探究の時間編』です。
            </p>
          </div>

          <div class="question-detail">
            <h4>問9：「2.0 道徳教育論」</h4>
            <p>出題箇所は、次の二つです。</p>
            <ul class="plain-list compact-list">
              <li>第1章「総則」第1款「高等学校教育の基本と教育課程の役割」2（2）の第2段落</li>
              <li>第1章「総則」第7款「道徳教育に関する配慮事項」1の前段</li>
            </ul>
            <p>
              第1款2（2）では、高等学校における道徳教育を学校の教育活動全体で行い、「人間としての在り方生き方に関する教育」を通して充実させることが示されています。
            </p>
            <p>
              第7款1では、道徳教育の全体計画を作成し、校長の方針の下、道徳教育推進教師を中心として全教師が協力する指導体制が示されています。
              いずれの箇所からも出題実績があるため、道徳教育の位置付けだけでなく、全体計画や校内の指導体制まで確認する必要があります。
            </p>
            <p>
              参照：
              <a class="text-link" :href="officialLinks.curriculumGeneral" target="_blank" rel="noopener noreferrer">高等学校学習指導要領解説 総則編</a>
            </p>
          </div>

          <div class="question-detail">
            <h4>問10：「2.2 特別活動論」</h4>
            <p>
              主な出題元は、第5章「特別活動」及び『高等学校学習指導要領（平成30年告示）解説 特別活動編』です。
            </p>
          </div>
        </article>

        <article class="trend-item">
          <h3>問11：「2.5 生徒指導・進路指導論」</h3>
          <p>
            <a class="text-link" :href="officialLinks.studentGuidance" target="_blank" rel="noopener noreferrer">『生徒指導提要』</a>から出題されています。
            原文の一部を空欄にした穴埋め問題も出題されているため、生徒指導の定義、目的、重層的支援構造、発達支持的生徒指導などの主要概念と原文の表現を確認する必要があります。
          </p>
        </article>

        <article class="trend-item">
          <h3>問12：「1.5 特別支援教育」</h3>
          <p>令和6年度から令和8年度までは、LD、ASD、ADHDに関する問題が出題されています。</p>
          <p>ただし、正式な出題範囲は発達障害だけに限定されていません。本サイトでは、次の内容を含む特別支援教育全般を学習対象とします。</p>
          <ul class="classification-list support-list">
            <li v-for="area in specialSupportAreas" :key="area">{{ area }}</li>
          </ul>
          <p>過去3年度の出題が発達障害に集中していたことと、今後の出題範囲を発達障害に限定することは区別する必要があります。</p>
        </article>

        <article class="trend-item">
          <h3>問13：「1.4 教育心理学」</h3>
          <p>
            これまで、青年期の発達課題や心理に関する問題が継続して出題されています。
            青年期の特徴だけでなく、発達段階、発達課題、アイデンティティ、主要な発達理論及び具体的な生徒理解への適用も学習対象となります。
          </p>
        </article>

        <article class="trend-item">
          <h3>問14：「1.4 教育心理学」</h3>
          <p>
            これまで、学習理論や学習方法に関する問題が出題されています。
            条件付け、認知、記憶、動機付け、メタ認知、教授・学習過程などの隣接分野から出題される可能性もあるため、特定の学習方法だけに範囲を限定しません。
          </p>
        </article>

        <article class="trend-item">
          <h3>問15：「1.3 教育制度総論」</h3>
          <p>
            中央教育審議会答申
            <a class="text-link" :href="officialLinks.reiwaEducation" target="_blank" rel="noopener noreferrer">『「令和の日本型学校教育」の構築を目指して―全ての子供たちの可能性を引き出す、個別最適な学びと、協働的な学びの実現―』</a>から出題されています。
          </p>
          <p>個別最適な学び、協働的な学び、ICTの活用、教師の役割など、答申の主要概念と原文の関係を確認する必要があります。</p>
        </article>

        <article class="trend-item">
          <h3>問16〜問18：問題内容に応じて「3.1」又は「3.2」</h3>
          <p>主な出題元は、次のとおりです。</p>
          <ul class="plain-list compact-list">
            <li>『高等学校学習指導要領』第2章第10節「情報」</li>
            <li>『高等学校学習指導要領』第3章第7節「情報」</li>
            <li>『高等学校学習指導要領（平成30年告示）解説 情報編』第1部「各教科に共通する教科『情報』」</li>
          </ul>
          <p>
            原文の一部を空欄にした穴埋め問題も出題されています。
            教科「情報」の専門的な内容を問う場合は「3.1 情報科専門科目」、教科の指導、授業設計、評価などを問う場合は「3.2 情報科教育法」として、実際の問題内容に合わせて分類します。
          </p>
          <p>
            参照：
            <a class="text-link" :href="officialLinks.informationGuidance" target="_blank" rel="noopener noreferrer">高等学校学習指導要領解説 情報編</a>
          </p>
        </article>

        <article class="trend-item">
          <h3>問19：「3.1 情報科専門科目」</h3>
          <p>
            アルゴリズムやプログラムの読解・実行に関する問題が出題されています。
            変数、配列、スタックなどの状態変化、繰り返し、条件分岐、添字、演算順序、終了条件を正確に追跡できることが求められます。
          </p>
        </article>

        <article class="trend-item">
          <h3>問20：「3.1 情報科専門科目」</h3>
          <p>
            データサイエンス、統計及びデータ分析に関する問題が出題されています。
            四分位数、代表値、確率、統計量、データの読み取りなどについて、計算方法と結果を正確に確認できることが求められます。
          </p>
        </article>
      </div>
    </section>

    <aside class="notice" aria-labelledby="notice-title">
      <UIcon name="i-lucide-info" aria-hidden="true" />
      <div>
        <h2 id="notice-title">出題傾向について</h2>
        <p>
          この試験は令和6年度に始まり、確認できる過去問はまだ3年度分です。今後、問題構成、出題元、難易度及び出題分野が変わる可能性があります。
          本サイトの分類は、正式な出題範囲を変更又は限定するものではありません。
        </p>
        <p>
          早稲田大学の科目名は学習分野を具体化するための参考であり、NITSが指定又は推奨している教材ではありません。
          Qiitaの記事は出題傾向の分析に使用し、法令や学習指導要領の最終的な根拠には公式原典を使用します。
        </p>
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
      <NuxtLink class="primary-link" to="/practice/1/1">
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
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--surface);
  overflow: hidden;
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
  font-size: 16px;
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

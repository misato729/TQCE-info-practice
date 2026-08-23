<script setup lang="ts">
useSeoMeta({
  title: '試験概要｜高等学校（情報）教員資格認定試験',
  description: '高等学校（情報）教員資格認定試験 科目Ⅰの基本情報と、過去問から見た出題範囲を紹介します。',
})

const questionGroups = [
  { questions: '問1〜2', category: '1.1 教育基礎総論', details: '日本教育史、西洋教育史、教育の理念・思想' },
  { questions: '問3〜5', category: '1.3 教育制度総論', details: '教育基本法、学校教育法、地方公務員法、教育公務員特例法' },
  { questions: '問6', category: '1.6 教育課程編成論', details: '教育課程の編成、実施、学習評価、カリキュラム・マネジメント' },
  { questions: '問7', category: '内容に応じて分類', details: '1.5 特別支援教育、1.6 教育課程編成論、2.5・2.7 生徒指導・進路指導論など' },
  { questions: '問8', category: '2.1 総合的な学習・探究論', details: '総合的な探究の時間、学習指導要領解説' },
  { questions: '問9', category: '2.0 道徳教育論', details: '高等学校における道徳教育' },
  { questions: '問10', category: '2.2 特別活動論', details: '特別活動、学習指導要領解説' },
  { questions: '問11', category: '2.5 生徒指導・進路指導論', details: '生徒指導提要、生徒指導の基本的な考え方' },
  { questions: '問12', category: '1.5 特別支援教育', details: '特別支援教育における障害全般' },
  { questions: '問13〜14', category: '1.4 教育心理学', details: '青年期の発達、発達理論、学習理論' },
  { questions: '問15', category: '1.3 教育制度総論', details: '「令和の日本型学校教育」答申' },
  { questions: '問16〜18', category: '内容に応じて分類', details: '3.1 情報科専門科目、3.2 情報科教育法' },
  { questions: '問19〜20', category: '3.1 情報科専門科目', details: 'アルゴリズム、プログラム、データサイエンス、統計' },
]
</script>

<template>
  <div class="page-wrap exam-overview-page">
    <header class="page-intro">
      <p class="page-label">科目Ⅰ</p>
      <h1>試験概要</h1>
      <p>
        高等学校（情報）教員資格認定試験の科目Ⅰについて、基本情報と過去問から見た出題傾向をまとめています。
      </p>
    </header>

    <dl class="exam-facts" aria-label="科目Ⅰの基本情報">
      <div>
        <dt>問題数</dt>
        <dd><strong>20</strong>問</dd>
      </div>
      <div>
        <dt>出題形式</dt>
        <dd><strong>4</strong>択</dd>
      </div>
      <div>
        <dt>合格ライン</dt>
        <dd><strong>60</strong>％以上</dd>
      </div>
    </dl>

    <section class="overview-section">
      <h2>受験案内上の出題範囲</h2>
      <p>
        科目Ⅰは、教職専門科目に関する内容と、高等学校「情報」に関する事項から出題されます。
        教職専門科目では、主に次の内容が対象です。
      </p>
      <ul class="plain-list">
        <li>教育の基礎的理解に関する科目</li>
        <li>道徳、総合的な学習の時間等の指導法</li>
        <li>生徒指導、教育相談等に関する科目</li>
      </ul>
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
    </section>

    <aside class="notice" aria-labelledby="notice-title">
      <UIcon name="i-lucide-info" aria-hidden="true" />
      <div>
        <h2 id="notice-title">出題傾向について</h2>
        <p>
          この試験は令和6年度に始まり、過去問がまだ多くありません。今後、問題構成や出題分野が変わる可能性があります。
          上記は出題範囲を限定するものではなく、学習しやすいように整理した本サイト独自の分類です。
        </p>
      </div>
    </aside>

    <section class="overview-section references-section">
      <h2>参考資料</h2>
      <ul class="reference-list">
        <li>
          <a href="https://www.nits.go.jp/shiken/2026/files/juken_johoAnnai_20260123_002.pdf" target="_blank" rel="noopener noreferrer">
            令和8年度 高等学校（情報）教員資格認定試験 受験案内
            <UIcon name="i-lucide-external-link" aria-hidden="true" />
          </a>
        </li>
        <li>
          <a href="https://qiita.com/misato729/items/c9e35ab0141ab87932dc" target="_blank" rel="noopener noreferrer">
            高等学校（情報）教員資格認定試験 科目Ⅰ 過去問分析
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

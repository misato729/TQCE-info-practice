<script setup lang="ts">
const config = useRuntimeConfig()

const { data, pending, error } = await useFetch('/api/v1/health', {
  baseURL: config.public.apiBase,
  server: false,
})

const apiBase = computed(() => String(config.public.apiBase).replace(/\/$/, ''))

const primaryLinks = [
  { label: '問題を解く', to: '/practice/settings', variant: 'primary' },
  { label: '問題一覧を見る', to: '/questions', variant: 'secondary' },
]

const navigationLinks = [
  { label: '試験概要', to: '/exam-overview' },
  { label: '問題一覧', to: '/questions' },
  { label: 'ログイン', to: '/login' },
  { label: '会員登録', to: '/signup' },
]

const features = [
  {
    title: '分野を選んで演習',
    text: '教職教養、情報科特有、小分類、難易度を組み合わせて、弱点に絞って取り組めます。',
  },
  {
    title: '本番形式の模擬試験',
    text: '20問構成、12問以上正解を目標に、科目Iの配分に近い形で演習できます。',
  },
  {
    title: '復習しやすい記録',
    text: '正解回数、不正解回数、連続正解数を残し、間違えた問題へ戻りやすくします。',
  },
]

const examPoints = [
  { value: '20問', label: '科目Iの想定問題数' },
  { value: '4択', label: '選択式でテンポよく確認' },
  { value: '12問', label: '合格ラインの目安' },
]

const categories = [
  '教育史',
  '教育法規',
  '学習指導要領',
  '生徒指導',
  '教育心理',
  '情報の学習指導要領',
  'アルゴリズム',
  'データサイエンス',
]
</script>

<template>
  <main class="top-page">
    <header class="site-header">
      <NuxtLink class="brand" to="/" aria-label="TQCE トップページ">
        <span class="brand-mark">T</span>
        <span>TQCE Info Practice</span>
      </NuxtLink>

      <nav class="nav" aria-label="主要ナビゲーション">
        <NuxtLink
          v-for="link in navigationLinks"
          :key="link.to"
          :to="link.to"
        >
          {{ link.label }}
        </NuxtLink>
      </nav>
    </header>

    <section class="hero-section">
      <p class="eyebrow">高等学校「情報」教員資格認定試験 科目I</p>
      <h1>出題範囲を整理しながら、合格ラインまで演習を積み上げる。</h1>
      <p class="lead">
        教職教養と情報科特有の問題を、分類別の演習・本番形式の模擬試験・復習記録で進める学習支援サイトです。
      </p>

      <div class="hero-actions" aria-label="主要アクション">
        <NuxtLink
          v-for="link in primaryLinks"
          :key="link.to"
          class="button-link"
          :class="link.variant"
          :to="link.to"
        >
          {{ link.label }}
        </NuxtLink>
      </div>

      <div class="hero-meta" aria-label="模擬試験の構成">
        <span>本番形式 20問</span>
        <span>教職教養 15問</span>
        <span>情報科特有 5問</span>
      </div>
    </section>

    <section class="stats-band" aria-label="試験の基本情報">
      <div v-for="point in examPoints" :key="point.label">
        <strong>{{ point.value }}</strong>
        <span>{{ point.label }}</span>
      </div>
    </section>

    <section class="content-section">
      <div class="section-heading">
        <p class="eyebrow">Features</p>
        <h2>毎日の演習に必要な流れを、ひとつの場所に。</h2>
      </div>

      <div class="feature-grid">
        <article v-for="feature in features" :key="feature.title" class="feature-card">
          <h3>{{ feature.title }}</h3>
          <p>{{ feature.text }}</p>
        </article>
      </div>
    </section>

    <section class="content-section split-section">
      <div>
        <p class="eyebrow">Scope</p>
        <h2>過去問分析をもとに、出題範囲を分類。</h2>
        <p class="section-text">
          科目Iの傾向は年度によって変わる可能性があります。このサイトでは分類を固定しすぎず、問題や解説をあとから追加・調整しやすい構成で扱います。
        </p>
        <NuxtLink class="text-link" to="/exam-overview">
          試験概要を確認する
        </NuxtLink>
      </div>

      <div class="category-cloud" aria-label="対応分野">
        <span v-for="category in categories" :key="category">
          {{ category }}
        </span>
      </div>
    </section>

    <section class="cta-section">
      <div>
        <p class="eyebrow">Start</p>
        <h2>まずは公開問題から、解ける範囲を広げましょう。</h2>
      </div>

      <div class="cta-actions">
        <NuxtLink class="button-link primary" to="/questions">
          問題一覧へ
        </NuxtLink>
        <NuxtLink class="button-link secondary" to="/mock-exams">
          模擬試験を始める
        </NuxtLink>
      </div>
    </section>

    <footer class="site-footer">
      <p>
        生成AIで作成した問題には誤りが含まれる可能性があります。根拠資料と解説を確認しながら学習してください。
      </p>
      <div class="api-status">
        <span class="dot" :class="{ ok: data?.status === 'ok' }" />
        <span v-if="pending">API 接続を確認中...</span>
        <span v-else-if="error">API に接続できません（接続先: {{ apiBase }}）</span>
        <span v-else>Rails API: {{ data?.status }}</span>
      </div>
    </footer>
  </main>
</template>

<style scoped>
.top-page {
  min-height: 100vh;
  background: #f4f7f6;
  color: #18212f;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.site-header {
  width: min(1120px, calc(100% - 32px));
  min-height: 76px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}

.brand,
.nav,
.hero-actions,
.cta-actions,
.api-status {
  display: flex;
  align-items: center;
}

.brand {
  gap: 10px;
  color: #172033;
  font-weight: 800;
  text-decoration: none;
  white-space: nowrap;
}

.brand-mark {
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border-radius: 8px;
  background: #1f6f68;
  color: #ffffff;
}

.nav {
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 8px 18px;
}

.nav a,
.text-link {
  color: #334155;
  font-size: 14px;
  font-weight: 700;
  text-decoration: none;
}

.nav a:hover,
.text-link:hover {
  color: #1f6f68;
}

.content-section,
.cta-section,
.site-footer {
  width: min(1120px, calc(100% - 32px));
  margin: 0 auto;
}

.hero-section {
  width: 100%;
  min-height: calc(100vh - 76px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 72px max(24px, calc((100vw - 1120px) / 2)) 108px;
  position: relative;
  overflow: hidden;
  background:
    linear-gradient(90deg, rgba(247, 250, 249, 0.98) 0%, rgba(247, 250, 249, 0.9) 34%, rgba(247, 250, 249, 0.34) 64%, rgba(247, 250, 249, 0.08) 100%),
    url("/images/top-hero-study.png") center / cover no-repeat;
}

.eyebrow {
  margin: 0 0 12px;
  color: #b45309;
  font-size: 13px;
  font-weight: 800;
  letter-spacing: 0;
  text-transform: uppercase;
}

h1,
h2,
h3,
p {
  margin: 0;
}

h1 {
  max-width: 9.5em;
  overflow-wrap: anywhere;
  font-size: clamp(38px, 6vw, 64px);
  line-height: 1.04;
  line-break: strict;
}

h2 {
  font-size: clamp(28px, 4vw, 44px);
  line-height: 1.14;
}

h3 {
  font-size: 20px;
  line-height: 1.35;
}

.lead,
.section-text,
.feature-card p,
.site-footer p {
  color: #526070;
  line-height: 1.8;
}

.lead {
  max-width: 640px;
  margin-top: 24px;
  font-size: 18px;
}

.hero-actions,
.cta-actions {
  flex-wrap: wrap;
  gap: 12px;
}

.hero-actions {
  margin-top: 34px;
}

.hero-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 26px;
}

.hero-meta span {
  min-height: 36px;
  display: inline-flex;
  align-items: center;
  padding: 0 12px;
  border: 1px solid rgba(203, 213, 225, 0.8);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.66);
  color: #263445;
  font-size: 13px;
  font-weight: 800;
  backdrop-filter: blur(8px);
}

.button-link {
  min-height: 48px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0 20px;
  border-radius: 8px;
  border: 1px solid transparent;
  font-size: 15px;
  font-weight: 800;
  text-decoration: none;
}

.button-link.primary {
  background: #1f6f68;
  color: #ffffff;
  box-shadow: 0 14px 30px rgba(31, 111, 104, 0.24);
}

.button-link.secondary {
  border-color: #cbd5df;
  background: rgba(255, 255, 255, 0.72);
  color: #263445;
}

.feature-card {
  border: 1px solid rgba(148, 163, 184, 0.38);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.8);
  box-shadow: 0 22px 60px rgba(37, 52, 77, 0.1);
}

.stats-band {
  width: min(1120px, calc(100% - 32px));
  margin: 24px auto 0;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  border: 1px solid rgba(148, 163, 184, 0.36);
  border-radius: 8px;
  background: #ffffff;
  box-shadow: 0 18px 48px rgba(37, 52, 77, 0.08);
}

.stats-band div {
  min-height: 104px;
  display: grid;
  align-content: center;
  gap: 6px;
  padding: 22px;
  border-right: 1px solid #e2e8f0;
}

.stats-band div:last-child {
  border-right: 0;
}

.stats-band strong {
  color: #1f6f68;
  font-size: 34px;
  line-height: 1;
}

.stats-band span {
  color: #526070;
  font-size: 14px;
  font-weight: 700;
}

.content-section {
  padding: 92px 0 0;
}

.section-heading {
  max-width: 650px;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
  margin-top: 30px;
}

.feature-card {
  min-height: 210px;
  padding: 24px;
}

.feature-card h3 {
  margin-bottom: 12px;
}

.split-section {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(320px, 1fr);
  align-items: center;
  gap: 54px;
}

.section-text {
  margin: 18px 0 24px;
  font-size: 16px;
}

.category-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-content: center;
}

.category-cloud span {
  padding: 10px 14px;
  border: 1px solid #d5dbe4;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.76);
  color: #334155;
  font-size: 14px;
  font-weight: 800;
}

.cta-section {
  margin-top: 92px;
  padding: 34px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  border-radius: 8px;
  background: #172033;
  color: #ffffff;
}

.cta-section .eyebrow {
  color: #f7c873;
}

.cta-section h2 {
  max-width: 680px;
}

.cta-section .button-link.secondary {
  border-color: rgba(255, 255, 255, 0.28);
  background: transparent;
  color: #ffffff;
}

.site-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 34px 0;
}

.site-footer p {
  max-width: 660px;
  font-size: 13px;
}

.api-status {
  flex-shrink: 0;
  gap: 10px;
  min-height: 38px;
  padding: 0 12px;
  border: 1px solid #d8dee8;
  border-radius: 8px;
  background: #ffffff;
  color: #2f3b4c;
  font-size: 13px;
  font-weight: 700;
}

.api-status span {
  overflow-wrap: anywhere;
}

.dot {
  width: 10px;
  height: 10px;
  flex: 0 0 auto;
  border-radius: 999px;
  background: #d1242f;
}

.dot.ok {
  background: #1a7f37;
}

@media (max-width: 860px) {
  .site-header {
    align-items: flex-start;
    flex-direction: column;
    padding: 18px 0;
  }

  .nav {
    justify-content: flex-start;
  }

  .split-section {
    grid-template-columns: 1fr;
  }

  .hero-section {
    min-height: auto;
    padding-top: 72px;
    background:
      linear-gradient(180deg, rgba(247, 250, 249, 0.96) 0%, rgba(247, 250, 249, 0.9) 48%, rgba(247, 250, 249, 0.6) 100%),
      url("/images/top-hero-study.png") 58% center / cover no-repeat;
  }

  h1 {
    max-width: none;
  }

  .stats-band,
  .feature-grid {
    grid-template-columns: 1fr;
  }

  .stats-band div {
    border-right: 0;
    border-bottom: 1px solid #e2e8f0;
  }

  .stats-band div:last-child {
    border-bottom: 0;
  }

  .cta-section,
  .site-footer {
    align-items: flex-start;
    flex-direction: column;
  }

  .api-status {
    flex-shrink: 1;
  }
}

@media (max-width: 520px) {
  .hero-section,
  .content-section {
    padding-top: 56px;
  }

  .hero-actions,
  .cta-actions {
    align-items: stretch;
    flex-direction: column;
  }

  .button-link {
    width: 100%;
  }

  .feature-card,
  .cta-section {
    padding: 20px;
  }
}
</style>

<script setup lang="ts">
const updates = [
  { date: '2026.08.20', text: '問題演習サイトの画面構成を更新しました。' },
  { date: '2026.08.10', text: '試験概要に出題範囲の解説を追加しました。' },
]
</script>

<template>
  <div class="home-main">
    <section class="overview-section">
      <div class="overview-copy">
        <p class="kicker">ABOUT</p>
        <h1>本サイトについて</h1>
        <p>
          高等学校（情報）教員資格認定試験の問題演習ができるサービスです。
        </p>
        <div class="overview-actions">
          <NuxtLink class="primary-link" to="/practice/1/1">
            <UIcon name="i-lucide-play" />
            問題演習を始める
          </NuxtLink>
          <NuxtLink class="secondary-link" to="/exam-overview">試験概要を見る</NuxtLink>
        </div>
      </div>
    </section>

    <section class="home-section updates-section">
      <div class="section-title">
        <span>NEWS</span>
        <h2>更新情報</h2>
      </div>
      <div class="update-list">
        <article v-for="update in updates" :key="update.date + update.text">
          <time>{{ update.date }}</time>
          <p>{{ update.text }}</p>
        </article>
      </div>
    </section>

    <section class="home-section policy-section">
      <div class="section-title">
        <span>POLICY</span>
        <h2>利用にあたって</h2>
      </div>
      <div class="policy-grid">
        <article>
          <UIcon name="i-lucide-user-check" />
          <h3>ログインなしで演習</h3>
          <p>問題演習はすぐに利用できます。解答履歴とお気に入りの保存にはログインが必要です。</p>
        </article>
        <article>
          <UIcon name="i-lucide-shield-alert" />
          <h3>根拠資料も確認</h3>
          <p>生成AIで作成した問題には誤りが含まれる可能性があります。解説と根拠資料を確認してください。</p>
        </article>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home-main { min-width: 0; background: #f8faf9; }
.overview-section {
  min-height: 280px;
  padding: 52px clamp(28px, 6vw, 86px);
  display: flex;
  align-items: center;
  background: #fff;
}
.overview-copy { max-width: 680px; }
.kicker, .section-title span { margin: 0 0 10px; color: var(--coral); font-size: 12px; font-weight: 900; letter-spacing: 0; }
h1 { margin: 0; font-size: 30px; line-height: 1.3; }
.overview-copy > p:not(.kicker) { margin: 22px 0 0; color: var(--muted); font-size: 16px; line-height: 1.9; }
.overview-actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 30px; }
.home-section { padding: 62px clamp(28px, 6vw, 86px); }
.section-title { display: flex; align-items: baseline; gap: 14px; margin-bottom: 26px; }
.section-title span { margin: 0; }
.section-title h2 { margin: 0; font-size: 30px; }
.updates-section { background: #f1f5f4; }
.update-list { border-top: 1px solid #cbd7d9; }
.update-list article { min-height: 68px; display: grid; grid-template-columns: 120px 1fr; align-items: center; gap: 18px; border-bottom: 1px solid #cbd7d9; }
.update-list time { color: var(--teal-dark); font-weight: 800; }
.update-list p { margin: 0; color: #4f6169; }
.policy-section { background: #fff; }
.policy-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
.policy-grid article { padding: 24px 0; border-top: 3px solid var(--yellow); }
.policy-grid article:nth-child(2) { border-color: var(--coral); }
.policy-grid :deep(svg) { width: 28px; height: 28px; color: var(--teal); }
.policy-grid h3 { margin: 14px 0 8px; }
.policy-grid p { margin: 0; color: var(--muted); line-height: 1.8; }

@media (max-width: 640px) {
  .overview-section { min-height: auto; padding: 36px 20px; }
  .overview-actions { align-items: stretch; flex-direction: column; }
  .home-section { padding: 44px 20px; }
  .update-list article { grid-template-columns: 1fr; gap: 5px; padding: 15px 0; }
  .policy-grid { grid-template-columns: 1fr; }
}
</style>

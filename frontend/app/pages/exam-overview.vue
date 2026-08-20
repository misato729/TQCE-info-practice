<template>
  <div class="page-wrap">
    <header class="page-intro">
      <h1>試験概要</h1>
      <p>高等学校（情報）教員資格認定試験 科目Iの基本情報と、過去問から見た出題範囲を確認できます。</p>
    </header>
    <section class="content-panel fact-grid">
      <div><strong>20問</strong><span>問題数</span></div>
      <div><strong>4択</strong><span>出題形式</span></div>
      <div><strong>60%</strong><span>合格ラインの目安</span></div>
    </section>
    <section class="content-panel">
      <h2>主な出題範囲</h2>
      <p>教職教養に関する内容と、高等学校「情報」に関する内容から出題されます。</p>
      <ul>
        <li>教育史、教育法規、学習指導要領、生徒指導、教育心理</li>
        <li>情報科の学習指導要領、アルゴリズム、データサイエンス</li>
      </ul>
      <NuxtLink class="primary-link" to="/practice/1">問題演習へ進む</NuxtLink>
    </section>
  </div>
</template>

<style scoped>
.fact-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1px; padding: 0; overflow: hidden; background: var(--line); }
.fact-grid div { min-height: 126px; display: grid; place-items: center; align-content: center; gap: 7px; background: #fff; }
.fact-grid strong { color: var(--teal); font-size: 30px; }
.fact-grid span { color: var(--muted); font-size: 13px; }
.content-panel ul { padding-left: 22px; margin-bottom: 24px; }
@media (max-width: 560px) { .fact-grid { grid-template-columns: 1fr; } .fact-grid div { min-height: 90px; } }
</style>

<script setup lang="ts">
const { isLoggedIn, logout } = useDemoAuth()
const handleLogout = async () => {
  logout()
  await navigateTo('/')
}
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>アカウント設定</h1><p>登録情報の確認とログアウト、アカウント削除を行います。</p></header>
    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>アカウント設定はログイン後に利用できます。</p>
      <NuxtLink class="primary-link" to="/login">ログインへ</NuxtLink>
    </div>
    <template v-else>
      <section class="content-panel account-info">
        <div><span>ユーザー名</span><strong>デモユーザー</strong></div>
        <div><span>メールアドレス</span><strong>demo@example.com</strong></div>
      </section>
      <section class="content-panel account-actions">
        <h2>ログイン状態</h2>
        <button class="secondary-link" type="button" @click="handleLogout">
          <UIcon name="i-lucide-log-out" />
          ログアウト
        </button>
      </section>
      <section class="content-panel danger-zone">
        <h2>アカウント削除</h2>
        <p>アカウントを削除すると、解答履歴とお気に入りも削除されます。</p>
        <button type="button">アカウントを削除</button>
      </section>
    </template>
  </div>
</template>

<style scoped>
.account-info { display: grid; gap: 18px; }
.account-info div { display: grid; grid-template-columns: 160px 1fr; gap: 20px; }
.account-info span { color: var(--muted); }
.account-actions h2, .danger-zone h2 { font-size: 20px; }
.danger-zone { border-color: #e8b9af; }
.danger-zone button { min-height: 42px; padding: 0 14px; border: 1px solid #d65e49; border-radius: 6px; background: #fff; color: #b33b29; font-weight: 700; cursor: pointer; }
@media (max-width: 520px) { .account-info div { grid-template-columns: 1fr; gap: 5px; } }
</style>

<script setup lang="ts">
const { login } = useDemoAuth()
const submit = async () => {
  login()
  await navigateTo('/practice/1')
}
</script>

<template>
  <div class="page-wrap auth-page">
    <header class="page-intro"><h1>ログイン</h1><p>解答履歴とお気に入りを保存できます。</p></header>
    <form class="content-panel auth-form" @submit.prevent="submit">
      <div class="field"><label for="email">メールアドレス</label><input id="email" type="email" value="demo@example.com" required></div>
      <div class="field"><label for="password">パスワード</label><input id="password" type="password" value="password" minlength="8" required></div>
      <button class="primary-link" type="submit">ログイン</button>
      <p class="auth-note">アカウントをお持ちでない方は <NuxtLink to="/signup">会員登録</NuxtLink></p>
    </form>
  </div>
</template>

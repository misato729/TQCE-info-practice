<script setup lang="ts">
const { login } = useDemoAuth()
const submit = async () => {
  login()
  await navigateTo('/practice/1')
}
</script>

<template>
  <div class="page-wrap auth-page">
    <header class="page-intro"><h1>会員登録</h1><p>登録後は、解答履歴とお気に入りを利用できます。</p></header>
    <form class="content-panel auth-form" @submit.prevent="submit">
      <div class="field"><label for="name">ユーザー名</label><input id="name" type="text" required></div>
      <div class="field"><label for="email">メールアドレス</label><input id="email" type="email" required></div>
      <div class="field"><label for="password">パスワード</label><input id="password" type="password" minlength="8" required></div>
      <div class="field"><label for="password-confirmation">確認用パスワード</label><input id="password-confirmation" type="password" minlength="8" required></div>
      <button class="primary-link" type="submit">登録する</button>
      <p class="auth-note">登録済みの方は <NuxtLink to="/login">ログイン</NuxtLink></p>
    </form>
  </div>
</template>

<script setup lang="ts">
const { isLoggedIn } = useDemoAuth()
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>お気に入り一覧</h1><p>解答後にお気に入り登録した問題を確認できます。</p></header>
    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>お気に入りはログインユーザーのみ利用できます。</p>
      <NuxtLink class="primary-link" to="/login">ログインへ</NuxtLink>
    </div>
    <div v-else class="empty-state">
      <UIcon class="empty-icon" name="i-lucide-star" />
      <h2>お気に入りはまだありません</h2>
      <p>問題の解答後に、お気に入りへ追加できます。</p>
      <NuxtLink class="primary-link" to="/practice/1">問題演習を始める</NuxtLink>
    </div>
  </div>
</template>

<style scoped>.empty-icon { width: 34px; height: 34px; color: #c78b00; }</style>

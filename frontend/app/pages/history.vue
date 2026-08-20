<script setup lang="ts">
const { isLoggedIn } = useDemoAuth()
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>解答履歴</h1><p>これまでに回答した問題を、新しい順に確認できます。</p></header>
    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>解答履歴はログインユーザーのみ利用できます。</p>
      <NuxtLink class="primary-link" to="/login">ログインへ</NuxtLink>
    </div>
    <div v-else class="empty-state">
      <UIcon class="empty-icon" name="i-lucide-history" />
      <h2>まだ解答履歴がありません</h2>
      <p>問題に回答すると、ここに記録されます。</p>
      <NuxtLink class="primary-link" to="/practice/1/1">問題演習を始める</NuxtLink>
    </div>
  </div>
</template>

<style scoped>.empty-icon { width: 34px; height: 34px; color: var(--teal); }</style>

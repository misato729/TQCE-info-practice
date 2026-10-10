<script setup lang="ts">
const route = useRoute()
const siteName = '高等学校（情報）教員資格認定試験　予想問題演習サイト'
const defaultDescription = '高等学校（情報）教員資格認定試験の予想問題を、解説と根拠資料付きで演習できる学習サイトです。'
const noIndexPatterns = [
  /^\/practice(?:\/|$)/,
  /^\/(?:history|favorites|account)(?:\/|$)/,
  /^\/premium\/complete(?:\/|$)/,
  /^\/admin(?:\/|$)/,
  /^\/(?:login|signup)(?:\/|$)/,
]
const robots = computed(() => (
  noIndexPatterns.some(pattern => pattern.test(route.path))
    ? 'noindex, nofollow'
    : 'index, follow'
))

useHead({
  htmlAttrs: { lang: 'ja' },
  title: siteName,
})

useSeoMeta({
  description: defaultDescription,
  ogTitle: siteName,
  ogDescription: defaultDescription,
  ogSiteName: siteName,
  ogLocale: 'ja_JP',
  ogType: 'website',
  twitterCard: 'summary',
  robots,
})
</script>

<template>
  <UApp>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </UApp>
</template>

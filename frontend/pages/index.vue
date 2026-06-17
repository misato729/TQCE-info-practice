<script setup lang="ts">
const config = useRuntimeConfig()

const { data, pending, error } = await useFetch('/api/v1/health', {
  baseURL: config.public.apiBase,
  server: false,
})
</script>

<template>
  <main class="page">
    <section class="workspace">
      <p class="eyebrow">TQCE</p>
      <h1>高等学校「情報」教員資格認定試験の問題演習サイト</h1>
      <p class="lead">
        Nuxt と Ruby on Rails API の開発環境が起動しています。
      </p>

      <div class="status">
        <span class="dot" :class="{ ok: data?.status === 'ok' }" />
        <span v-if="pending">API 接続を確認中...</span>
        <span v-else-if="error">API に接続できません</span>
        <span v-else>Rails API: {{ data?.status }}</span>
      </div>
    </section>
  </main>
</template>

<style scoped>
.page {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 32px;
  background: #f7f8fb;
  color: #172033;
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.workspace {
  width: min(760px, 100%);
}

.eyebrow {
  margin: 0 0 12px;
  color: #1f6feb;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0;
}

h1 {
  margin: 0;
  font-size: clamp(32px, 6vw, 58px);
  line-height: 1.08;
}

.lead {
  margin: 20px 0 32px;
  color: #526070;
  font-size: 18px;
  line-height: 1.7;
}

.status {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  min-height: 44px;
  padding: 0 16px;
  border: 1px solid #d8dee8;
  border-radius: 8px;
  background: #ffffff;
  color: #2f3b4c;
  font-weight: 600;
}

.dot {
  width: 10px;
  height: 10px;
  border-radius: 999px;
  background: #d1242f;
}

.dot.ok {
  background: #1a7f37;
}
</style>

<script setup lang="ts">
const config = useRuntimeConfig()
const apiBase = computed(() => String(config.public.apiBase).replace(/\/$/, ''))
const apiStatus = ref<'checking' | 'connected' | 'failed'>('checking')

onMounted(async () => {
  try {
    const response = await $fetch<{ status: string }>('/api/v1/health', {
      baseURL: apiBase.value,
    })
    apiStatus.value = response.status === 'ok' ? 'connected' : 'failed'
  } catch {
    apiStatus.value = 'failed'
  }
})
</script>

<template>
  <div class="app-shell">
    <SiteHeader />
    <div class="app-content">
      <ExamSidebar />
      <div class="main-column">
        <main><slot /></main>
        <footer class="site-footer">
          <div class="footer-inner">
            <div class="footer-main">
              <div class="footer-copy">
                <strong>高等学校（情報）教員資格認定試験　予想問題演習サイト</strong>
                <span>生成AIで作成した問題には誤りが含まれる可能性があります。</span>
              </div>
              <nav class="footer-links" aria-label="サイトポリシー">
                <NuxtLink to="/privacy-policy">プライバシーポリシー</NuxtLink>
                <NuxtLink to="/terms">利用規約</NuxtLink>
              </nav>
            </div>
            <div class="api-status" :class="apiStatus">
              <span class="status-dot" aria-hidden="true" />
              <span v-if="apiStatus === 'checking'">API接続を確認中</span>
              <span v-else-if="apiStatus === 'failed'">APIに接続できません</span>
              <span v-else>API接続：正常</span>
            </div>
          </div>
        </footer>
      </div>
    </div>
  </div>
</template>

<style scoped>
.app-shell { min-height: 100vh; display: flex; flex-direction: column; }
.app-content { flex: 1; display: grid; grid-template-columns: 260px minmax(0, 1fr); align-items: start; }
.main-column { min-width: 0; min-height: calc(100vh - var(--header-height)); display: flex; flex-direction: column; }
main { flex: 1; }
.site-footer { margin-top: 72px; border-top: 1px solid #d8e1e4; background: #e8eeee; }
.footer-inner {
  width: min(1080px, calc(100% - 40px));
  min-height: 88px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  color: #52636c;
  font-size: 13px;
}
.footer-main, .footer-copy { display: grid; gap: 6px; }
.footer-main { gap: 10px; }
.footer-copy strong { color: #31454c; }
.footer-links { display: flex; flex-wrap: wrap; gap: 8px 18px; }
.footer-links a { color: #40545b; font-weight: 700; text-underline-offset: 3px; }
.footer-links a:hover { color: var(--teal-dark); }
.api-status {
  min-height: 36px;
  flex: 0 0 auto;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 0 11px;
  border: 1px solid #c4d0d2;
  border-radius: 6px;
  background: #f7fafa;
  color: #52636c;
  font-weight: 700;
}
.status-dot { width: 9px; height: 9px; border-radius: 50%; background: #d29b21; }
.api-status.connected .status-dot { background: #198754; }
.api-status.failed .status-dot { background: #c94d3f; }
@media (max-width: 640px) {
  .site-footer { margin-top: 52px; }
  .footer-inner {
    width: min(100% - 28px, 1080px);
    align-items: flex-start;
    flex-direction: column;
    justify-content: center;
    gap: 6px;
  }
  .api-status { margin-top: 8px; }
}

@media (max-width: 760px) {
  .app-content { grid-template-columns: 1fr; }
  .main-column { min-height: auto; }
}
</style>

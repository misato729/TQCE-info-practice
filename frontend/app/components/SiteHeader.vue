<script setup lang="ts">
const route = useRoute()
const menuOpen = ref(false)
const { isLoggedIn } = useAuth()

const menuItems = computed(() => [
  { label: 'ホーム', to: '/', icon: 'i-lucide-house' },
  { label: '試験概要', to: '/exam-overview', icon: 'i-lucide-book-open' },
  { label: '問題演習', to: '/practice/1/1', icon: 'i-lucide-pencil-line' },
  ...(isLoggedIn.value
    ? [
        { label: '解答履歴', to: '/history', icon: 'i-lucide-history' },
        { label: 'お気に入り一覧', to: '/favorites', icon: 'i-lucide-star' },
        { label: 'アカウント設定', to: '/account', icon: 'i-lucide-user-round' },
      ]
    : []),
])

watch(() => route.fullPath, () => { menuOpen.value = false })

const closeOnEscape = (event: KeyboardEvent) => {
  if (event.key === 'Escape') menuOpen.value = false
}

onMounted(() => window.addEventListener('keydown', closeOnEscape))
onBeforeUnmount(() => window.removeEventListener('keydown', closeOnEscape))
</script>

<template>
  <header class="site-header">
    <div class="header-inner">
      <NuxtLink class="brand" to="/" aria-label="ホームへ戻る">
        <span class="brand-mark" aria-hidden="true"><UIcon name="i-lucide-graduation-cap" /></span>
        <span class="brand-copy">
          <strong>高等学校（情報）教員資格認定試験</strong>
          <small>予想問題演習サイト</small>
        </span>
      </NuxtLink>

      <div class="header-actions">
        <NuxtLink v-if="!isLoggedIn" class="login-link" to="/login">ログイン</NuxtLink>
        <NuxtLink v-else class="account-link" to="/account" title="アカウント設定">
          <UIcon name="i-lucide-circle-user-round" />
          <span>マイページ</span>
        </NuxtLink>
        <button
          class="menu-button"
          type="button"
          :aria-expanded="menuOpen"
          aria-controls="global-menu"
          title="メニューを開く"
          @click="menuOpen = true"
        >
          <UIcon name="i-lucide-menu" />
          <span class="sr-only">メニューを開く</span>
        </button>
      </div>
    </div>
  </header>

  <Transition name="fade">
    <button
      v-if="menuOpen"
      class="menu-backdrop"
      type="button"
      aria-label="メニューを閉じる"
      @click="menuOpen = false"
    />
  </Transition>

  <Transition name="slide">
    <aside v-if="menuOpen" id="global-menu" class="menu-drawer" aria-label="メインメニュー">
      <div class="drawer-head">
        <strong>メニュー</strong>
        <button type="button" title="メニューを閉じる" @click="menuOpen = false">
          <UIcon name="i-lucide-x" />
          <span class="sr-only">メニューを閉じる</span>
        </button>
      </div>
      <nav>
        <NuxtLink
          v-for="item in menuItems"
          :key="item.to"
          :to="item.to"
          :class="{ active: route.path === item.to }"
        >
          <UIcon :name="item.icon" />
          <span>{{ item.label }}</span>
          <UIcon class="chevron" name="i-lucide-chevron-right" />
        </NuxtLink>
      </nav>
    </aside>
  </Transition>
</template>

<style scoped>
.site-header { position: sticky; top: 0; z-index: 30; border-bottom: 1px solid rgba(5, 94, 98, .24); background: var(--aqua); }
.header-inner {
  width: min(1180px, calc(100% - 32px));
  height: var(--header-height);
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}
.brand, .header-actions, .account-link { display: flex; align-items: center; }
.brand { min-width: 0; gap: 12px; color: #082e32; text-decoration: none; }
.brand-mark {
  width: 46px;
  height: 46px;
  flex: 0 0 46px;
  display: grid;
  place-items: center;
  border-radius: 6px;
  background: #fff;
  color: var(--teal-dark);
  font-size: 27px;
}
.brand-copy { min-width: 0; display: flex; align-items: baseline; gap: 12px; }
.brand-copy strong { font-size: clamp(16px, 2.2vw, 24px); white-space: nowrap; }
.brand-copy small { font-size: 14px; font-weight: 700; white-space: nowrap; }
.header-actions { flex: 0 0 auto; gap: 18px; }
.login-link, .account-link { color: #082e32; font-weight: 800; text-decoration: none; }
.account-link { gap: 7px; }
.account-link :deep(svg) { width: 22px; height: 22px; }
.menu-button, .drawer-head button { display: grid; place-items: center; border: 0; cursor: pointer; }
.menu-button { width: 46px; height: 46px; border-radius: 6px; background: #087b80; color: #fff; font-size: 26px; }
.menu-backdrop { position: fixed; inset: 0; z-index: 40; border: 0; background: rgba(10, 31, 36, .42); }
.menu-drawer {
  position: fixed;
  inset: 0 0 0 auto;
  z-index: 50;
  width: min(360px, 88vw);
  padding: 22px;
  background: #f8fbfb;
  box-shadow: -18px 0 50px rgba(18, 42, 48, .2);
}
.drawer-head { min-height: 52px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--line); }
.drawer-head strong { font-size: 20px; }
.drawer-head button { width: 40px; height: 40px; border-radius: 6px; background: #e6eeee; color: var(--ink); font-size: 22px; }
nav { display: grid; gap: 4px; padding-top: 18px; }
nav a {
  min-height: 52px;
  display: grid;
  grid-template-columns: 24px 1fr 20px;
  align-items: center;
  gap: 12px;
  padding: 0 12px;
  border-radius: 6px;
  color: #263840;
  font-weight: 700;
  text-decoration: none;
}
nav a:hover, nav a.active { background: #dff2f2; color: var(--teal-dark); }
.chevron { color: #7d9097; }
.sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0; }
.fade-enter-active, .fade-leave-active, .slide-enter-active, .slide-leave-active { transition: opacity 180ms ease, transform 220ms ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.slide-enter-from, .slide-leave-to { transform: translateX(100%); }

@media (max-width: 760px) {
  .header-inner { width: min(100% - 24px, 1180px); }
  .brand-copy { display: block; }
  .brand-copy strong, .brand-copy small { display: block; }
  .brand-copy small { margin-top: 2px; font-size: 11px; }
  .account-link span, .login-link { display: none; }
  .header-actions { gap: 10px; }
}
@media (max-width: 420px) {
  .brand-mark { width: 40px; height: 40px; flex-basis: 40px; font-size: 23px; }
  .brand-copy strong { max-width: 185px; overflow: hidden; text-overflow: ellipsis; }
}
</style>

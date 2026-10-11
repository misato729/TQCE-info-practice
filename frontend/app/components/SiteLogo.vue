<template>
  <span class="site-logo">
    <span class="site-logo-symbol" aria-hidden="true">
      <img src="/images/logo-symbol.png" alt="" width="1254" height="1254" />
    </span>
    <span class="site-logo-wordmark">
      <img src="/images/logo-wordmark.png" alt="情報教認ラボ" width="2172" height="724" />
    </span>
  </span>
</template>

<style scoped>
.site-logo {
  display: inline-flex;
  flex: 0 0 auto;
  align-items: center;
  gap: 8px;
  padding: 4px;
  border-radius: 4px;
  background: #fff;
}
.site-logo-symbol, .site-logo-wordmark { position: relative; display: block; flex: 0 0 auto; overflow: hidden; }
.site-logo-symbol { width: var(--logo-symbol-size, 50px); aspect-ratio: 1; }
.site-logo-wordmark { width: var(--logo-wordmark-width, 212px); aspect-ratio: 4; }
.site-logo img { position: absolute; display: block; max-width: none; height: auto; }
/* Keep the supplied artwork intact while excluding its surrounding margins. */
.site-logo-symbol img { width: 125%; left: -12.5%; top: -12.5%; }
.site-logo-wordmark img { width: 140%; left: -20%; top: -44%; }
</style>

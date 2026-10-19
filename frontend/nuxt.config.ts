export default defineNuxtConfig({
  compatibilityDate: '2024-07-03',
  devtools: { enabled: true },
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      link: [{ rel: 'icon', type: 'image/png', href: '/images/logo-symbol.png' }],
    },
  },
  routeRules: {
    // User-specific application screens do not benefit from server rendering.
    '/practice/**': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/history': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/favorites': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/account': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/premium/complete': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/admin/**': { ssr: false, headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/login': { headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
    '/signup': { headers: { 'X-Robots-Tag': 'noindex, nofollow' } },
  },
  runtimeConfig: {
    apiBaseInternal: '',
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE || 'http://localhost:3001',
    },
  },
})

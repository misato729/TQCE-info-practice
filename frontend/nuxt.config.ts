export default defineNuxtConfig({
  compatibilityDate: '2024-07-03',
  devtools: { enabled: true },
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  routeRules: {
    // User-specific application screens do not benefit from server rendering.
    // Public content remains SSR while Basic authentication is enforced by
    // server/middleware/basic-auth.ts; prerendering it would bypass that guard.
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
    basicAuthUser: '',
    basicAuthPassword: '',
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE || 'http://localhost:3001',
    },
  },
})

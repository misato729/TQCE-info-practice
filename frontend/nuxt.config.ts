import { fileURLToPath } from 'node:url'
import { SITE, themeVariables } from './app/utils/examConfig.ts'
import { e2eBuildConfiguration } from './scripts/e2e-build.mjs'

const staticFrontend = process.env.NUXT_STATIC_FRONTEND === 'true'
const apiOnly = !staticFrontend && process.env.NUXT_API_ONLY === 'true'
const e2e = e2eBuildConfiguration()
const testFreeMode = process.env.APP_ENV === 'test' && process.env.TQCE_E2E_FREE_MODE === 'true'

export default defineNuxtConfig({
  ...e2e,
  compatibilityDate: '2024-07-03',
  devtools: { enabled: false },
  ui: { fonts: false, colorMode: false },
  modules: ['@nuxt/ui'],
  // Netlify serves generated public pages only. It never bundles the Fly API,
  // database clients, readiness plugin, or authentication secrets.
  ...(staticFrontend ? { serverDir: fileURLToPath(new URL('./.static-server', import.meta.url)) } : {}),
  nitro: {
    ...e2e.nitro,
    ...(apiOnly ? { noPublicDir: true } : {}),
    ...(staticFrontend ? { preset: 'static', prerender: { ignore: ['/api'] } } : {}),
  },
  vite: {
    // Match the explicitly isolated browser-test fixture in browser and server.
    // Production builds can never activate the free E2E configuration.
    define: {
      'process.env.APP_ENV': JSON.stringify(process.env.APP_ENV || process.env.NODE_ENV || 'development'),
      'process.env.TQCE_E2E_FREE_MODE': JSON.stringify(testFreeMode ? 'true' : 'false'),
    },
    // Nitro resolves shared modules after the intermediate SSR build.
    build: { rolldownOptions: { makeAbsoluteExternalsRelative: false } },
  },
  hooks: {
    'vite:extendConfig'(config, { isClient }) {
      if (!isClient) return
      // Nuxt UI transpiles Reka for SSR. Prebundle its client-side barrel to
      // keep development startup from loading hundreds of individual modules.
      const client = config.environments?.client ?? config
      if (!client.optimizeDeps) return
      client.optimizeDeps.exclude = (client.optimizeDeps.exclude ?? []).filter(dependency => dependency !== 'reka-ui')
      client.optimizeDeps.include = [...new Set([...(client.optimizeDeps.include ?? []), 'reka-ui'])]
    },
  },
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      link: [{ rel: 'icon', href: SITE.logo_path }],
      style: [{ innerHTML: themeVariables() }],
    },
  },
  routeRules: {
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
      apiBase: staticFrontend ? '' : (process.env.NUXT_PUBLIC_API_BASE || ''),
    },
  },
})

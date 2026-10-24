export default defineNuxtRouteMiddleware(async () => {
  // Static generation must not resolve request-specific sessions or call the live API.
  if (import.meta.prerender) return
  if (import.meta.client) {
    const nuxtApp = useNuxtApp()
    if (nuxtApp.isHydrating && nuxtApp.payload.serverRendered) {
      // Match the anonymous static HTML before personalizing shared links.
      const { ensureCurrentUser } = useAuth()
      onNuxtReady(() => { void ensureCurrentUser() })
      return
    }
  }
  const cacheControl = import.meta.server ? useResponseHeader('Cache-Control') : null
  const currentUser = await useAuth().ensureCurrentUser()
  if (currentUser && cacheControl) cacheControl.value = 'private, no-store'
})

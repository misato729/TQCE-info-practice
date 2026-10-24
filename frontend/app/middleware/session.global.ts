export default defineNuxtRouteMiddleware(async () => {
  // Static generation must not resolve request-specific sessions or call the live API.
  if (import.meta.prerender) return
  const cacheControl = import.meta.server ? useResponseHeader('Cache-Control') : null
  const currentUser = await useAuth().ensureCurrentUser()
  if (currentUser && cacheControl) cacheControl.value = 'private, no-store'
})

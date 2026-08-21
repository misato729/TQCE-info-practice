export default defineNuxtRouteMiddleware(async (to) => {
  const { isLoggedIn, ensureCurrentUser } = useAuth()
  if (!isLoggedIn.value) return

  const currentUser = await ensureCurrentUser()
  if (currentUser?.role !== 'admin') return

  const redirect = typeof to.query.redirect === 'string' ? to.query.redirect : ''
  const redirectPath = redirect.startsWith('/admin/') && !redirect.startsWith('//')
    ? redirect
    : '/admin/questions'

  return navigateTo(redirectPath)
})

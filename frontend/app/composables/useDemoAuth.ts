export const useDemoAuth = () => {
  const authState = useCookie<string | null>('tqce-demo-auth', {
    default: () => null,
    sameSite: 'lax',
  })
  const isLoggedIn = computed(() => authState.value === 'logged-in')
  const login = () => { authState.value = 'logged-in' }
  const logout = () => { authState.value = null }
  return { isLoggedIn, login, logout }
}

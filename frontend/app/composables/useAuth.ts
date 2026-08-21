export type AuthUser = {
  id: number
  name: string
  email: string
  role: 'user' | 'admin'
  created_at?: string
}

type AuthSession = {
  access_token: string
  token_type: 'Bearer'
  expires_in: number
  user: AuthUser
}

type ApiResponse<T> = { data: T }

export const useAuth = () => {
  const config = useRuntimeConfig()
  const accessToken = useCookie<string | null>('tqce-access-token', {
    default: () => null,
    maxAge: 60 * 60 * 24,
    sameSite: 'lax',
    secure: import.meta.env.PROD,
  })
  const user = useState<AuthUser | null>('auth-user', () => null)
  const isLoggedIn = computed(() => Boolean(accessToken.value))
  const authHeaders = computed<Record<string, string>>(() => (
    accessToken.value ? { Authorization: `Bearer ${accessToken.value}` } : {}
  ))

  const setSession = (session: AuthSession) => {
    accessToken.value = session.access_token
    user.value = session.user
  }

  const login = async (credentials: { email: string, password: string }) => {
    const response = await $fetch<ApiResponse<AuthSession>>('/api/v1/auth/login', {
      baseURL: config.public.apiBase,
      method: 'POST',
      body: credentials,
    })
    setSession(response.data)
  }

  const signup = async (attributes: {
    name: string
    email: string
    password: string
    password_confirmation: string
  }) => {
    const response = await $fetch<ApiResponse<AuthSession>>('/api/v1/auth/signup', {
      baseURL: config.public.apiBase,
      method: 'POST',
      body: attributes,
    })
    setSession(response.data)
  }

  const logout = () => {
    accessToken.value = null
    user.value = null
  }

  const ensureCurrentUser = async () => {
    if (!accessToken.value || user.value) return user.value

    try {
      const response = await $fetch<ApiResponse<AuthUser>>('/api/v1/me', {
        baseURL: config.public.apiBase,
        headers: authHeaders.value,
      })
      user.value = response.data
      return user.value
    }
    catch {
      logout()
      return null
    }
  }

  return {
    accessToken,
    user,
    isLoggedIn,
    authHeaders,
    login,
    signup,
    logout,
    ensureCurrentUser,
  }
}

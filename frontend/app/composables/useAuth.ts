import type { Ref } from 'vue'

export type AuthUser = {
  id: number
  name: string
  email: string
  role: 'user' | 'admin'
  paid_content_access: boolean
  membership: {
    status: 'free' | 'active' | 'revoked'
    purchased_at: string | null
    expires_at: null
  }
  created_at?: string
}

type AuthSession = {
  access_token: string
  token_type: 'Bearer'
  expires_in: number
  user: AuthUser
}

type ApiResponse<T> = { data: T }

const currentUserRequests = new WeakMap<object, { token: string, promise: Promise<AuthUser | null> }>()
const accessTokens = new WeakMap<object, Ref<string | null>>()

export const useAuth = () => {
  const nuxtApp = useNuxtApp()
  const accessToken = accessTokens.get(nuxtApp) ?? useCookie<string | null>('tqce-access-token', {
    default: () => null,
    maxAge: 60 * 60 * 24,
    sameSite: 'lax',
    secure: import.meta.env?.PROD,
  })
  accessTokens.set(nuxtApp, accessToken)
  const user = useState<AuthUser | null>('auth-user', () => null)
  const favoriteIds = useState<number[]>('favorite-question-ids', () => [])
  const isLoggedIn = computed(() => Boolean(accessToken.value))
  const authHeaders = computed<Record<string, string>>(() => {
    const headers: Record<string, string> = {}
    if (accessToken.value) headers.Authorization = `Bearer ${accessToken.value}`
    return headers
  })

  const setSession = (session: AuthSession) => {
    accessToken.value = session.access_token
    user.value = session.user
  }

  const login = async (credentials: { email: string, password: string }) => {
    const response = await nuxtApp.$api<ApiResponse<AuthSession>>('/api/v1/auth/login', {
      method: 'POST',
      body: credentials,
    })
    setSession(response.data)
    return response.data.user
  }

  const signup = async (attributes: {
    name: string
    email: string
    password: string
    password_confirmation: string
  }) => {
    const response = await nuxtApp.$api<ApiResponse<AuthSession>>('/api/v1/auth/signup', {
      method: 'POST',
      body: attributes,
    })
    setSession(response.data)
  }

  const logout = () => {
    accessToken.value = null
    user.value = null
    favoriteIds.value = []
  }

  const ensureCurrentUser = async (force = false) => {
    if (!accessToken.value) return null
    if (user.value && !force) return user.value

    const token = accessToken.value
    const pending = currentUserRequests.get(nuxtApp)
    if (pending?.token === token) return pending.promise

    const promise: Promise<AuthUser | null> = nuxtApp.$api<ApiResponse<AuthUser>>('/api/v1/me', {
      headers: authHeaders.value,
    }).then((response) => {
      if (accessToken.value !== token) return null
      user.value = response.data
      return user.value
    }).catch(() => null).finally(() => {
      if (currentUserRequests.get(nuxtApp)?.promise === promise) currentUserRequests.delete(nuxtApp)
    })
    currentUserRequests.set(nuxtApp, { token, promise })
    return promise
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

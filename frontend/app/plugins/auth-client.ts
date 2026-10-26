import { createAuthClient } from 'better-auth/vue'

export default defineNuxtPlugin({
  name: 'auth-client',
  setup() {
    const { beginRequest, finishRequest } = useApiStatus()
    return {
      provide: {
        authClient: createAuthClient({
          baseURL: useRequestURL().origin,
          basePath: '/api/auth',
          fetchOptions: {
            credentials: 'include',
            // Better Auth's fetch adapter also sees transport failures, which
            // its HTTP response hooks cannot observe. No extra request is made.
            customFetchImpl: async (input, options) => {
              beginRequest()
              try {
                const response = await fetch(input, options)
                finishRequest(response.status >= 500 ? 'failed' : 'connected')
                return response
              } catch (error) {
                finishRequest(options?.signal?.aborted ? undefined : 'failed')
                throw error
              }
            },
          },
        }),
      },
    }
  },
})

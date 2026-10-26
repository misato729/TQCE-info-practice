export default defineNuxtPlugin({
  name: 'auth-session',
  dependsOn: ['auth-client'],
  setup(nuxtApp) {
    // Mount the library subscription so its cross-tab and focus refreshes run.
    const session = nuxtApp.$authClient.useSession()
    const { user, authResolved, sessionVersion, authMutationPending, clearCurrentUser, ensureCurrentUser, consumeLocalSignInSession } = useAuth()
    const hydrationReady = ref(!(nuxtApp.isHydrating && nuxtApp.payload.serverRendered))
    // Subscribe during setup, but keep the first client tree equal to SSR HTML.
    if (!hydrationReady.value) onNuxtReady(() => { hydrationReady.value = true })
    let observed = false
    let previousKey: string | null = null
    let snapshotVersion = 0

    watch([session, authMutationPending, hydrationReady], ([current, mutations, ready]) => {
      if (!ready || mutations || current.isPending || current.isRefetching || (current.error && current.error.status !== 401)) return
      const identity = current.data?.user?.id
      const nextKey = identity == null ? null : JSON.stringify([identity, current.data?.session?.id])
      if (observed && nextKey === previousKey) return
      const initial = !observed
      const snapshot = ++snapshotVersion
      observed = true
      previousKey = nextKey

      const sameUser = identity != null && user.value != null && String(identity) === String(user.value.id)
      if (!initial && sameUser) {
        const localReceipt = consumeLocalSignInSession(identity, current.data?.session?.token)
        if (localReceipt) {
          const version = sessionVersion.value
          void localReceipt.then(alreadyHydrated => {
            // A newer native notification or local action owns the state now.
            if (snapshot !== snapshotVersion || version !== sessionVersion.value || authMutationPending.value) return
            if (!alreadyHydrated) {
              sessionVersion.value += 1
              void ensureCurrentUser(true)
            }
          })
          return
        }
      }
      if (initial) {
        // The first native snapshot must not invalidate the application's
        // initial /me lookup that route guards may already be awaiting.
        const knownAnonymous = identity == null && authResolved.value && user.value == null
        if (!sameUser && !knownAnonymous) void ensureCurrentUser(true)
        return
      }
      // Hide another account's data before the asynchronous application fetch.
      if (!sameUser) clearCurrentUser()
      if (identity != null) {
        if (sameUser) sessionVersion.value += 1
        void ensureCurrentUser(true)
      }
    }, { immediate: true, flush: 'sync' })
  },
})

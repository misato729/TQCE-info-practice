import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { stripTypeScriptTypes } from 'node:module'
import test from 'node:test'
import { ofetch } from 'ofetch'
import { computed, ref, watch } from 'vue'
import { useAuth, type AuthUser } from '../app/composables/useAuth.ts'
import { useFavorites } from '../app/composables/useFavorites.ts'
import { useApiStatus } from '../app/composables/useApiStatus.ts'

const globals = globalThis as any
globals.computed = computed
globals.ref = ref
globals.watch = watch
globals.useAuth = useAuth
globals.useFavorites = useFavorites
globals.useApiStatus = useApiStatus
globals.defineNuxtPlugin = (plugin: any) => typeof plugin === 'function' ? plugin : plugin.setup
globals.defineNuxtRouteMiddleware = (middleware: unknown) => middleware
globals.definePageMeta = () => {}
globals.onMounted = () => {}
globals.navigateTo = (target: unknown) => target
const { default: observeSession } = await import('../app/plugins/auth-session.client.ts')
const { default: protectRoute } = await import('../app/middleware/auth.ts')
const flush = () => new Promise<void>(done => setImmediate(done))
const member = (id: number): AuthUser => ({ id, name: `Member ${id}`, email: `member-${id}@example.invalid`, role: 'user',
  paid_content_access: true, favorite_questions: [{ id, exam_number: 1, question_number: 1 }],
  membership: { status: 'active', purchased_at: null, expires_at: null } })
const sessionFor = (id: number | null, sessionId = 'session-one') => ({
  data: id === null ? null : { user: { id: String(id) }, session: { id: sessionId } },
  isPending: false, isRefetching: false, error: null as null | { status: number },
})
function harness(initial: AuthUser | null, fetchUser: (path?: string) => Promise<unknown>, nativeIdentity = initial?.id ?? null, nativePending = false,
  hydration = { isHydrating: false, serverRendered: false }) {
  const native = ref({ ...sessionFor(nativeIdentity), isPending: nativePending })
  const states = new Map()
  const readyCallbacks: (() => void)[] = []
  const app = { isHydrating: hydration.isHydrating, payload: { serverRendered: hydration.serverRendered },
    $api: fetchUser, runWithContext: (action: () => unknown) => action(), $authClient: {
    useSession: () => native,
    signIn: { email: async () => ({ data: {} }) },
    signUp: { email: async () => ({ data: {} }) },
    signOut: async () => ({ data: {} }),
  } }
  globals.useNuxtApp = () => app
  globals.onNuxtReady = (callback: () => void) => { readyCallbacks.push(callback) }
  globals.useState = (key: string, init: () => unknown) => {
    if (!states.has(key)) states.set(key, ref(init()))
    return states.get(key)
  }
  const auth = useAuth()
  auth.user.value = initial
  auth.authResolved.value = initial !== null
  ;(observeSession as any)(app)
  const finishHydration = () => {
    app.isHydrating = false
    for (const callback of readyCallbacks.splice(0)) callback()
  }
  return { auth, native, app, finishHydration }
}

// Exercise each page's actual reactive loader without rendering or HTTP.
function listPage(name: 'favorites' | 'history') {
  const source = readFileSync(new URL(`../app/pages/${name}.vue`, import.meta.url), 'utf8')
  const script = source.match(/<script setup lang="ts">([\s\S]*?)<\/script>/)?.[1]
  assert.ok(script)
  const state = name === 'favorites' ? 'favorites' : 'histories'
  return new Function(`${stripTypeScriptTypes(script)}\nreturn { items: ${state}, loading };`)() as {
    items: { value: { id: number }[] }, loading: { value: boolean },
  }
}
const listResponse = (data: unknown[]) => ({ data, meta: { current_page: 1, per_page: 20, total_count: data.length, total_pages: 1 } })

test('the initial native session reuses matching SSR application identity', () => {
  let reads = 0
  const { auth } = harness(member(1), async () => { reads += 1; return { data: member(1) } })
  assert.equal(auth.user.value?.id, 1)
  assert.equal(reads, 0)
})

test('native session notifications preserve anonymous SSR state until Nuxt is ready, then use the latest identity', async () => {
  let reads = 0
  const { auth, native, finishHydration } = harness(null, async () => {
    reads += 1
    return { data: member(2) }
  }, 1, false, { isHydrating: true, serverRendered: true })
  assert.equal(reads, 0)
  assert.equal(auth.user.value, null)
  native.value = sessionFor(2, 'latest-before-hydration')
  await flush()
  assert.equal(reads, 0)
  assert.equal(auth.user.value, null)
  finishHydration()
  await flush()
  assert.equal(reads, 1)
  assert.equal(auth.user.value?.id, 2)
})

test('a CSR application can resolve native identity immediately while its initial route is mounting', async () => {
  let reads = 0
  const { auth } = harness(null, async () => {
    reads += 1
    return { data: member(1) }
  }, 1, false, { isHydrating: true, serverRendered: false })
  assert.equal(reads, 1)
  await flush()
  assert.equal(auth.user.value?.id, 1)
})

test('a late initial anonymous native snapshot does not repeat a completed application lookup', async () => {
  let reads = 0
  const { auth, native } = harness(null, async () => {
    reads += 1
    throw Object.assign(new Error('Anonymous session'), { statusCode: 401 })
  }, null, true)
  assert.equal(reads, 0)
  assert.equal(await auth.ensureCurrentUser(), null)
  native.value = sessionFor(null)
  await flush()
  assert.equal(await auth.ensureCurrentUser(), null)
  assert.equal(reads, 1)
})

test('a library cross-tab identity change hides old favorites before loading the replacement member', async () => {
  let resolve!: (value: unknown) => void
  const { auth, native } = harness(member(1), async () => new Promise(done => { resolve = done }))
  const favorites = useFavorites()
  native.value = sessionFor(2, 'session-two')
  assert.equal(auth.user.value, null)
  assert.deepEqual(favorites.favoriteIds.value, [])
  resolve({ data: member(2) }); await flush()
  assert.equal(auth.user.value?.id, 2)
  assert.deepEqual(favorites.favoriteIds.value, [2])
})

test('library cross-tab sign-out clears identity and prevents pending me from restoring it', async () => {
  let resolve!: (value: unknown) => void
  let reads = 0
  const { auth, native } = harness(member(1), async () => { reads += 1; return new Promise(done => { resolve = done }) })
  const stale = auth.ensureCurrentUser(true)
  native.value = sessionFor(null)
  assert.equal(auth.user.value, null)
  assert.deepEqual(useFavorites().favoriteIds.value, [])
  resolve({ data: member(1) })
  assert.equal(await stale, null)
  assert.equal(auth.user.value, null)
  assert.equal(reads, 1)
})

test('native session errors do not pretend a valid application session signed out', () => {
  const { auth, native } = harness(member(1), async () => ({ data: member(1) }))
  native.value = { ...sessionFor(null), error: { status: 503 } }
  assert.equal(auth.user.value?.id, 1)
})

test('native notifications wait for local auth mutations instead of superseding their hydration', async () => {
  let reads = 0
  const { auth, native } = harness(member(1), async () => { reads += 1; return { data: member(2) } })
  const login = auth.login({ email: 'member-2@example.invalid', password: 'test-password' })
  assert.equal(auth.authMutationPending.value, 1)
  native.value = sessionFor(2, 'session-two')
  assert.equal(auth.user.value?.id, 1)
  assert.equal(reads, 0)
  assert.equal((await login).id, 2)
  await flush()
  assert.equal(auth.user.value?.id, 2)
  assert.equal(auth.authMutationPending.value, 0)
  assert.equal(reads, 2)
})

test('a late same-user native session refresh retries the pending favorites page lookup', async () => {
  const requests: ((value: unknown) => void)[] = []
  const { auth, native } = harness(member(1), async path => {
    if (path === '/api/v1/favorites') return new Promise(done => { requests.push(done) })
    return { data: member(1) }
  })
  const page = listPage('favorites')
  assert.equal(requests.length, 1)
  const previousVersion = auth.sessionVersion.value
  native.value = sessionFor(1, 'replacement-session')
  await flush()
  assert.ok(auth.sessionVersion.value > previousVersion)
  assert.equal(requests.length, 2)
  requests[1]!(listResponse([{ id: 700, question: { id: 1, exam_number: 1, question_number: 1 } }]))
  await flush()
  assert.deepEqual(page.items.value.map(item => item.id), [700])
  requests[0]!(listResponse([]))
  await flush()
  assert.deepEqual(page.items.value.map(item => item.id), [700])
  assert.equal(page.loading.value, false)
})

test('a replacement session reloads history and ignores an older response arriving last', async () => {
  const requests: ((value: unknown) => void)[] = []
  const { native } = harness(member(1), async path => {
    if (path === '/api/v1/answer_histories') return new Promise(done => { requests.push(done) })
    return { data: member(1) }
  })
  const page = listPage('history')
  assert.equal(requests.length, 1)
  native.value = sessionFor(1, 'replacement-session')
  await flush()
  assert.equal(requests.length, 2)
  requests[1]!(listResponse([{ id: 702 }]))
  await flush()
  requests[0]!(listResponse([{ id: 701 }]))
  await flush()
  assert.deepEqual(page.items.value.map(item => item.id), [702])
  assert.equal(page.loading.value, false)
})

test('a same-user replacement native session still prevents an older API 401 from clearing it', async () => {
  const { auth, native, app } = harness(member(1), async () => ({ data: member(1) }))
  let staleResponse!: (response: Response) => void
  globals.useRuntimeConfig = () => ({ public: { apiBase: 'https://api.example.invalid' } })
  globals.useRoute = () => ({ fullPath: '/favorites', meta: { middleware: 'auth' } })
  globals.$fetch = ofetch.create({}, { fetch: async input => {
    const path = new URL(typeof input === 'string' ? input : input instanceof URL ? input.href : input.url).pathname
    if (path === '/api/v1/favorites') return new Promise<Response>(done => { staleResponse = done })
    return new Response(JSON.stringify({ data: member(1) }), { headers: { 'Content-Type': 'application/json' } })
  } })
  const { default: setupApi } = await import('../app/plugins/api.ts')
  app.$api = (setupApi as any)(app).provide.api
  const previousVersion = auth.sessionVersion.value
  const staleRequest = (app.$api as any)('/api/v1/favorites', { retry: 0 })
  await flush()
  native.value = sessionFor(1, 'replacement-session')
  await flush()
  assert.ok(auth.sessionVersion.value > previousVersion)
  staleResponse(new Response('{}', { status: 401, headers: { 'Content-Type': 'application/json' } }))
  await assert.rejects(staleRequest)
  assert.equal(auth.user.value?.id, 1)
  assert.deepEqual(useFavorites().favoriteIds.value, [1])
})

test('a deep-link guard waits for app me despite a first empty native snapshot', async () => {
  let resolve!: (value: unknown) => void
  let reads = 0
  const { auth, native } = harness(null, async () => {
    if (++reads === 1) return new Promise(done => { resolve = done })
    return { data: member(1) }
  })
  let settled = false
  const navigation = (protectRoute as any)({ fullPath: '/favorites' }).then((result: unknown) => { settled = true; return result })
  await flush()
  const earlyRedirect = settled
  native.value = sessionFor(1)
  resolve({ data: member(1) })
  assert.equal(await navigation, undefined)
  assert.equal(earlyRedirect, false)
  assert.equal(auth.user.value?.id, 1)
  assert.ok(reads >= 1)
})

test('a first valid native snapshot joins the initial guard lookup without superseding it', async () => {
  let resolve!: (value: unknown) => void
  let reads = 0
  const { auth } = harness(null, async () => { reads += 1; return new Promise(done => { resolve = done }) }, 1)
  const navigation = (protectRoute as any)({ fullPath: '/favorites' })
  assert.equal(reads, 1)
  resolve({ data: member(1) })
  assert.equal(await navigation, undefined)
  assert.equal(auth.user.value?.id, 1)
  assert.equal(reads, 1)
})

test('a guard follows a newer native identity instead of returning an obsolete anonymous result', async () => {
  const responses: ((value: unknown) => void)[] = []
  const { auth, native } = harness(null, async () => new Promise(done => { responses.push(done) }), 1)
  const navigation = (protectRoute as any)({ fullPath: '/favorites' })
  native.value = sessionFor(2, 'session-two')
  responses[0]!({ data: member(1) })
  await flush()
  responses[1]!({ data: member(2) })
  assert.equal(await navigation, undefined)
  assert.equal(auth.user.value?.id, 2)
})

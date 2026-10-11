import assert from 'node:assert/strict'
import test from 'node:test'
import { computed, ref } from 'vue'
import { useAuth, type AuthUser } from '../app/composables/useAuth.ts'

const globals = globalThis as any
globals.computed = computed

const user: AuthUser = {
  id: 1, name: 'Test User', email: 'test@example.invalid', role: 'user', paid_content_access: false,
  membership: { status: 'free', purchased_at: null, expires_at: null },
}

const createAuth = (token: string | null, api: (...args: any[]) => Promise<unknown>) => {
  const states = new Map()
  const cookie = ref(token)
  let cookieCalls = 0
  const app = { $api: api }
  globals.useNuxtApp = () => app
  globals.useCookie = () => { cookieCalls += 1; return cookie }
  globals.useState = (key: string, init: () => unknown) => {
    if (!states.has(key)) states.set(key, ref(init()))
    return states.get(key)
  }
  return { auth: useAuth(), states, cookieCalls: () => cookieCalls }
}

test('anonymous users do not trigger a current-user request', async () => {
  let requests = 0
  const { auth } = createAuth(null, async () => { requests += 1 })
  assert.equal(await auth.ensureCurrentUser(), null)
  assert.equal(requests, 0)
})

test('composables share the cookie and deduplicate concurrent user requests', async () => {
  let requests = 0
  let resolve!: (response: unknown) => void
  const harness = createAuth('session-token', async () => {
    requests += 1
    return await new Promise(done => { resolve = done })
  })
  const other = useAuth()
  assert.equal(harness.auth.accessToken, other.accessToken)
  assert.equal(harness.cookieCalls(), 1)
  const first = harness.auth.ensureCurrentUser()
  const second = other.ensureCurrentUser()
  assert.equal(requests, 1)
  resolve({ data: user })
  assert.deepEqual(await first, user)
  assert.deepEqual(await second, user)
  assert.deepEqual(await other.ensureCurrentUser(), user)
  assert.equal(requests, 1)
})

test('an old in-flight response cannot restore a logged-out session', async () => {
  let resolve!: (response: unknown) => void
  const { auth, states } = createAuth('session-token', async () => await new Promise(done => { resolve = done }))
  states.get('favorite-question-ids').value = [1, 2]
  const request = auth.ensureCurrentUser()
  auth.logout()
  resolve({ data: user })
  assert.equal(await request, null)
  assert.equal(auth.user.value, null)
  assert.equal(auth.accessToken.value, null)
  assert.deepEqual(states.get('favorite-question-ids').value, [])
})

test('user state and tokens are isolated between Nuxt app instances', async () => {
  const first = createAuth('first-token', async () => ({ data: user })).auth
  const secondUser = { ...user, id: 2 }
  const second = createAuth('second-token', async () => ({ data: secondUser })).auth
  await first.ensureCurrentUser()
  await second.ensureCurrentUser()
  assert.equal(first.user.value?.id, 1)
  assert.equal(second.user.value?.id, 2)
  first.logout()
  assert.equal(second.accessToken.value, 'second-token')
  assert.equal(second.user.value?.id, 2)
})

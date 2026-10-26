import assert from 'node:assert/strict'
import test, { afterEach } from 'node:test'
import { computed, ref } from 'vue'
import { useApiStatus } from '../app/composables/useApiStatus.ts'

const globals = globalThis as any
globals.computed = computed
globals.useApiStatus = useApiStatus
globals.useRequestURL = () => new URL('https://auth-status.example.invalid')
globals.defineNuxtPlugin = (plugin: any) => plugin.setup
const { default: setupClient } = await import('../app/plugins/auth-client.ts')
const originalFetch = globalThis.fetch
afterEach(() => { globalThis.fetch = originalFetch })

function harness(fetcher: typeof fetch) {
  const states = new Map()
  globals.useState = (key: string, init: () => unknown) => {
    if (!states.has(key)) states.set(key, ref(init()))
    return states.get(key)
  }
  globalThis.fetch = fetcher
  const status = useApiStatus()
  const client = (setupClient as any)().provide.authClient
  return { client, status }
}

const flush = () => new Promise<void>(resolve => setImmediate(resolve))
const json = (status = 200) => new Response('null', { status, headers: { 'Content-Type': 'application/json' } })

test('native auth requests share the in-flight status counter without a health request', async () => {
  const resolvers: ((response: Response) => void)[] = []
  const { client, status } = harness(async () => new Promise(resolve => { resolvers.push(resolve) }))
  assert.equal(status.apiStatus.value, 'idle')
  status.beginRequest() // An application API is already in flight.
  const request = client.getSession()
  await flush()
  assert.equal(resolvers.length, 1)
  assert.equal(status.apiStatus.value, 'checking')
  resolvers[0]!(json())
  await request
  assert.equal(status.apiStatus.value, 'checking')
  status.finishRequest('connected')
  assert.equal(status.apiStatus.value, 'connected')
})

test('native authentication and throttling errors are reachable but server errors are failed', async () => {
  for (const code of [401, 429, 503]) {
    let requests = 0
    const { client, status } = harness(async () => {
      requests += 1
      return new Response(JSON.stringify({ code: 'SYNTHETIC_FAILURE', message: 'Synthetic test response' }), {
        status: code, headers: { 'Content-Type': 'application/json' },
      })
    })
    const result = await client.signIn.email({ email: 'synthetic@example.test', password: 'Synthetic-test-password' })
    assert.equal(result.error.status, code)
    assert.equal(requests, 1)
    assert.equal(status.apiStatus.value, code >= 500 ? 'failed' : 'connected')
  }
})

test('a native transport failure clears checking and a later real response restores connected', async () => {
  let offline = true
  let requests = 0
  const { client, status } = harness(async () => {
    requests += 1
    if (offline) throw new TypeError('Synthetic offline transport')
    return json()
  })
  await assert.rejects(client.getSession(), /Synthetic offline/)
  assert.equal(status.apiStatus.value, 'failed')
  offline = false
  await client.getSession()
  assert.equal(status.apiStatus.value, 'connected')
  assert.equal(requests, 2)
})

test('canceling a native request does not overwrite the last connection result', async () => {
  const { client, status } = harness(async (_input, options) => {
    if (options?.signal?.aborted) throw new DOMException('Synthetic navigation cancellation', 'AbortError')
    return json()
  })
  await client.getSession()
  const controller = new AbortController()
  controller.abort()
  await assert.rejects(client.$fetch('/get-session', { signal: controller.signal }), { name: 'AbortError' })
  assert.equal(status.apiStatus.value, 'connected')
})

import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { stripTypeScriptTypes } from 'node:module'
import test, { type TestContext } from 'node:test'
import { computed, effectScope, ref, watch } from 'vue'
import { useFavorites } from '../app/composables/useFavorites.ts'
import type { AuthUser } from '../shared/types/auth.ts'

const globals = globalThis as any
globals.computed = computed
const flush = () => new Promise<void>(done => setImmediate(done))
const member = (id: number): AuthUser => ({
  id, name: `Member ${id}`, email: `member-${id}@example.test`, role: 'user',
  paid_content_access: true,
  favorite_questions: [{ id: 101, exam_number: 6, question_number: 1 }, { id: 102, exam_number: 6, question_number: 2 }],
  membership: { status: 'active', purchased_at: null, expires_at: null },
})
const item = (id: number, questionId = 101) => ({
  id, locked: false, question: { id: questionId, exam_number: 6, question_number: questionId === 101 ? 1 : 2 },
})
const response = (items: unknown[], total = items.length, page = 1) => ({
  data: items, meta: { current_page: page, per_page: 20, total_count: total, total_pages: Math.ceil(total / 20) },
})

type Request = {
  path: string
  method: string
  page?: number
  resolve: (value: unknown) => void
  reject: (reason: unknown) => void
}

function harness(t: TestContext, name: 'history' | 'favorites') {
  const user = ref<AuthUser | null>(member(1))
  const auth = {
    user, sessionVersion: ref(1), isLoggedIn: computed(() => user.value !== null),
    authHeaders: computed(() => ({})), ensureCurrentUser: async () => user.value,
  }
  const reads: Request[] = []
  const writes: Request[] = []
  const app = { $api: (path: string, options: { method?: string, query?: { page: number } } = {}) => new Promise((resolve, reject) => {
    const request = { path, method: options.method ?? 'GET', page: options.query?.page, resolve, reject }
    ;(request.method === 'GET' ? reads : writes).push(request)
  }) }
  globals.useAuth = () => auth
  globals.useNuxtApp = () => app
  const source = readFileSync(new URL(`../app/pages/${name}.vue`, import.meta.url), 'utf8')
  const script = source.match(/<script setup lang="ts">([\s\S]*?)<\/script>/)![1]!
  const setup = new Function('ref', 'computed', 'watch', 'definePageMeta', 'onMounted', 'useNuxtApp', 'useAuth', 'useFavorites',
    `${stripTypeScriptTypes(script)}\nreturn {
      items: ${name === 'history' ? 'histories' : 'favorites'}, meta, page, loading, loadError,
      ${name === 'favorites' ? 'toggleFromList, removingId, isFavorite,' : ''}
    }`)
  const scope = effectScope()
  const view = scope.run(() => setup(ref, computed, watch, () => {}, () => {}, () => app, () => auth, useFavorites))!
  t.after(() => scope.stop())
  return { auth, reads, writes, view }
}

test('history hides revoked content immediately and coalesces entitlement/session refreshes', async t => {
  const { auth, reads, view } = harness(t, 'history')
  reads[0]!.resolve(response([item(1)]))
  await flush()
  assert.equal(view.items.value.length, 1)

  auth.user.value!.paid_content_access = false
  assert.deepEqual(view.items.value, [])
  auth.sessionVersion.value += 1
  await flush()
  assert.equal(reads.length, 2)
  reads[1]!.reject(new Error('Replacement history lookup failed'))
  await flush()
  assert.deepEqual(view.items.value, [])
  assert.equal(view.loading.value, false)
  assert.match(view.loadError.value, /解答履歴を読み込めませんでした/)

  // Replacing an equivalent payload must not introduce another API request.
  auth.user.value = { ...auth.user.value!, name: 'Updated name' }
  await flush()
  assert.equal(reads.length, 2)
})

test('a replacement history owner starts on page one and rejects the previous page response', async t => {
  const { auth, reads, view } = harness(t, 'history')
  reads[0]!.resolve(response([item(1)], 40))
  await flush()
  view.page.value = 2
  await flush()
  assert.equal(reads[1]!.page, 2)

  auth.sessionVersion.value += 1
  auth.user.value = member(2)
  assert.equal(view.page.value, 1)
  assert.deepEqual(view.items.value, [])
  await flush()
  assert.equal(reads.length, 3)
  assert.equal(reads[2]!.page, 1)
  reads[1]!.resolve(response([item(11)], 40, 2))
  await flush()
  assert.deepEqual(view.items.value, [])
  reads[2]!.resolve(response([item(22)]))
  await flush()
  assert.deepEqual(view.items.value.map((entry: { id: number }) => entry.id), [22])
})

test('favorite removal and undo keep the card with exactly one write each and no list refetch', async t => {
  const { reads, writes, view } = harness(t, 'favorites')
  const favorite = item(1)
  reads[0]!.resolve(response([favorite]))
  await flush()
  const removing = view.toggleFromList(favorite)
  assert.equal(writes.length, 1)
  assert.equal(writes[0]!.method, 'DELETE')
  writes[0]!.resolve(undefined)
  await removing
  await flush()
  assert.equal(view.meta.value.total_count, 0)
  assert.equal(view.items.value.length, 1)
  assert.equal(view.isFavorite(favorite.question.id), false)

  const undoing = view.toggleFromList(favorite)
  assert.equal(writes.length, 2)
  assert.equal(writes[1]!.method, 'PUT')
  writes[1]!.resolve({ data: { question: favorite.question } })
  await undoing
  await flush()
  assert.equal(view.meta.value.total_count, 1)
  assert.equal(view.isFavorite(favorite.question.id), true)
  assert.equal(reads.length, 1)
})

test('a late favorite success cannot change a replacement account count or pending toggle', async t => {
  const { auth, reads, writes, view } = harness(t, 'favorites')
  const previous = item(1)
  reads[0]!.resolve(response([previous], 10))
  await flush()
  const previousToggle = view.toggleFromList(previous)

  auth.sessionVersion.value += 1
  auth.user.value = member(2)
  await flush()
  assert.equal(reads.length, 2)
  const current = item(2)
  reads[1]!.resolve(response([current], 7))
  await flush()
  const currentToggle = view.toggleFromList(current)
  assert.equal(writes.length, 2)
  writes[0]!.resolve(undefined)
  await previousToggle
  assert.equal(view.meta.value.total_count, 7)
  assert.equal(view.loadError.value, '')
  assert.equal(view.removingId.value, current.id)
  writes[1]!.resolve(undefined)
  await currentToggle
  assert.equal(view.meta.value.total_count, 6)
  assert.equal(view.removingId.value, null)
  assert.equal(reads.length, 2)
})

test('a late favorite failure from another page cannot replace the current error or pending state', async t => {
  const { reads, writes, view } = harness(t, 'favorites')
  reads[0]!.resolve(response([item(1)], 25))
  await flush()
  const previousToggle = view.toggleFromList(item(1))
  view.page.value = 2
  await flush()
  reads[1]!.resolve(response([item(2, 102)], 25, 2))
  await flush()
  const currentToggle = view.toggleFromList(item(2, 102))
  writes[0]!.reject(new Error('Old favorite request failed'))
  await previousToggle
  assert.equal(view.loadError.value, '')
  assert.equal(view.meta.value.total_count, 25)
  assert.equal(view.removingId.value, 2)
  writes[1]!.resolve(undefined)
  await currentToggle
  assert.equal(view.meta.value.total_count, 24)
  assert.equal(reads.length, 2)
})

test('a revoked and restored favorite entitlement does not revive an old mutation result', async t => {
  const { auth, reads, writes, view } = harness(t, 'favorites')
  reads[0]!.resolve(response([item(1)], 3))
  await flush()
  const oldToggle = view.toggleFromList(item(1))
  auth.user.value!.paid_content_access = false
  assert.deepEqual(view.items.value, [])
  assert.equal(view.removingId.value, null)
  await flush()
  assert.equal(reads.length, 1)
  auth.user.value!.paid_content_access = true
  await flush()
  reads[1]!.resolve(response([item(2, 102)], 2))
  await flush()
  const currentToggle = view.toggleFromList(item(2, 102))
  writes[0]!.reject(new Error('Old entitlement request failed'))
  await oldToggle
  assert.equal(view.meta.value.total_count, 2)
  assert.equal(view.loadError.value, '')
  assert.equal(view.removingId.value, 2)
  writes[1]!.resolve(undefined)
  await currentToggle
  assert.equal(view.meta.value.total_count, 1)
  assert.equal(reads.length, 2)
})

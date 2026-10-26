import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test, { type TestContext } from 'node:test'
import { computed, effectScope, ref, watch } from 'vue'
import { useIncorrectReview } from '../app/composables/useIncorrectReview.ts'
import {
  stableRandomizePracticeSequence,
  type PracticePosition,
} from '../app/utils/practiceSequence.ts'

const globals = globalThis as any
globals.computed = computed
globals.watch = watch

const flush = () => new Promise<void>(resolve => setImmediate(resolve))
const response = (positions: Array<[number, number, number]>) => ({
  data: positions.map(([question_id, exam_number, question_number]) => ({
    question_id, exam_number, question_number,
  })),
  meta: { total_count: positions.length },
})

type PendingRequest = {
  resolve: (value: unknown) => void
  reject: (reason: unknown) => void
}

function harness(t: TestContext) {
  const user = ref<any>({ id: 1, paid_content_access: false })
  const sessionVersion = ref(1)
  const states = new Map<string, any>()
  const requests: PendingRequest[] = []
  const navigations: unknown[] = []
  const app = {
    $api: () => new Promise((resolve, reject) => requests.push({ resolve, reject })),
  }
  const auth = {
    user,
    sessionVersion,
    isLoggedIn: computed(() => user.value !== null),
    authHeaders: computed(() => ({})),
  }

  globals.useNuxtApp = () => app
  globals.useAuth = () => auth
  globals.useState = (key: string, initialize: () => unknown) => {
    if (!states.has(key)) states.set(key, ref(initialize()))
    return states.get(key)
  }
  globals.navigateTo = async (target: unknown) => { navigations.push(target) }

  const scope = effectScope()
  const review = scope.run(() => useIncorrectReview())!
  t.after(() => scope.stop())
  return { auth, requests, navigations, review }
}

test('stable review order reproduces the same sparse sequence without mutating it', () => {
  const positions: PracticePosition[] = [
    { examNumber: 1, questionNumber: 1 },
    { examNumber: 2, questionNumber: 8 },
    { examNumber: 4, questionNumber: 3 },
    { examNumber: 7, questionNumber: 19 },
    { examNumber: 10, questionNumber: 2 },
  ]
  const original = structuredClone(positions)
  const first = stableRandomizePracticeSequence(positions, 123456789)
  const second = stableRandomizePracticeSequence(positions, 123456789)

  assert.deepEqual(first, second)
  assert.deepEqual(positions, original)
  assert.deepEqual(
    new Set(first.map(position => `${position.examNumber}:${position.questionNumber}`)),
    new Set(['1:1', '2:8', '4:3', '7:19', '10:2']),
  )
})

test('removing review targets preserves the relative order of every remaining pair', () => {
  const positions = Array.from({ length: 20 }, (_, index) => ({
    examNumber: (index % 5) + 1,
    questionNumber: index + 1,
  }))
  const complete = stableRandomizePracticeSequence(positions, 987654321)
  const remaining = positions.filter(position => position.questionNumber % 3 !== 0)
  const reranked = stableRandomizePracticeSequence(remaining, 987654321)
  const remainingKeys = new Set(remaining.map(position => `${position.examNumber}:${position.questionNumber}`))

  assert.deepEqual(
    reranked,
    complete.filter(position => remainingKeys.has(`${position.examNumber}:${position.questionNumber}`)),
  )
  assert.notDeepEqual(
    stableRandomizePracticeSequence(positions, 987654322),
    complete,
  )
})

test('review state caches exact pairs and starts without expanding them into a Cartesian product', async t => {
  const { requests, navigations, review } = harness(t)
  const loading = review.load()
  assert.equal(requests.length, 1)
  requests[0]!.resolve(response([
    [101, 1, 1],
    [202, 2, 2],
    [202, 2, 2],
  ]))
  assert.deepEqual(await loading, [
    { examNumber: 1, questionNumber: 1 },
    { examNumber: 2, questionNumber: 2 },
  ])
  assert.equal(review.totalCount.value, 2)

  assert.equal(await review.start(), true)
  assert.equal(requests.length, 1)
  assert.equal(navigations.length, 1)
  const target = navigations[0] as { path: string, query: Record<string, string> }
  assert.match(target.path, /^\/practice\/(1\/1|2\/2)$/)
  assert.deepEqual({ review: target.query.review, order: target.query.order }, {
    review: 'incorrect', order: 'random',
  })
  assert.match(target.query.seed, /^\d+$/)
})

test('a failed review lookup is retried when the history action is pressed again', async t => {
  const { requests, navigations, review } = harness(t)
  const failed = review.start()
  requests[0]!.reject({ statusCode: 503 })
  assert.equal(await failed, false)
  assert.match(review.error.value, /読み込めませんでした/)

  const retried = review.start()
  assert.equal(requests.length, 2)
  requests[1]!.resolve(response([[101, 1, 1]]))
  assert.equal(await retried, true)
  assert.equal(review.error.value, '')
  assert.equal(navigations.length, 1)
})

test('clearing review state makes the next entry point fetch updated answers', async t => {
  const { requests, review } = harness(t)
  const first = review.load()
  requests[0]!.resolve(response([[101, 1, 1]]))
  assert.deepEqual(await first, [{ examNumber: 1, questionNumber: 1 }])

  review.clear()
  assert.equal(review.loaded.value, false)
  assert.deepEqual(review.positions.value, [])

  const refreshed = review.load()
  assert.equal(requests.length, 2)
  requests[1]!.resolve(response([]))
  assert.deepEqual(await refreshed, [])
  assert.equal(review.loaded.value, true)
})

test('a response from an old user or entitlement generation cannot repopulate review state', async t => {
  const { auth, requests, review } = harness(t)
  const previousLoad = review.load()
  auth.user.value = { id: 2, paid_content_access: true }
  auth.sessionVersion.value += 1
  const currentLoad = review.load()
  assert.equal(requests.length, 2)

  requests[0]!.resolve(response([[101, 1, 1]]))
  await previousLoad
  assert.deepEqual(review.positions.value, [])

  requests[1]!.resolve(response([[620, 6, 20]]))
  await currentLoad
  await flush()
  assert.deepEqual(review.positions.value, [{ examNumber: 6, questionNumber: 20 }])

  auth.user.value!.paid_content_access = false
  assert.deepEqual(review.positions.value, [])
  assert.equal(review.loaded.value, false)
})

test('top and history entry points expose lazy review actions and completion feedback', () => {
  const top = readFileSync(new URL('../app/pages/index.vue', import.meta.url), 'utf8')
  const history = readFileSync(new URL('../app/pages/history.vue', import.meta.url), 'utf8')
  const practice = readFileSync(new URL('../app/pages/practice/[examNumber]/[questionNumber].vue', import.meta.url), 'utf8')

  assert.match(top, /間違えた問題/)
  assert.match(top, /mode === 'incorrect' && isLoggedIn\.value[^]*loadIncorrectReview\(\)/)
  assert.doesNotMatch(top, /loadIncorrectReview\([^)]*\)[^]*\{ immediate: true \}/)
  assert.match(top, /ランダムに復習を始める/)
  assert.match(history, /@click="startIncorrectReviewFromHistory"/)
  assert.match(history, /\$route\.query\.review === 'complete'/)
  assert.match(history, /間違えた問題をすべて正解しました/)
  assert.match(practice, /clear: clearIncorrectReview/)
  assert.match(practice, /reviewOwnerSession !== null && reviewOwnerSession === questionSession\.value[^]*clearIncorrectReview\(\)/)
  assert.match(practice, /\[isIncorrectReview, authResolved, isLoggedIn, questionSession, incorrectReviewQuerySignature\]/)
})

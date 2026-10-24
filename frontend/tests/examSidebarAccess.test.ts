import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { stripTypeScriptTypes } from 'node:module'
import test from 'node:test'
import { computed, effectScope, nextTick, ref, watch } from 'vue'
import { EXAM_CATALOG, FREE_EXAM_CATALOG } from '../app/utils/examCatalog.ts'
import { EXAM_CONFIG, hasFullExamAccess, type AccessUser } from '../app/utils/examConfig.ts'

const source = readFileSync(new URL('../app/components/ExamSidebar.vue', import.meta.url), 'utf8')
const script = source.match(/<script setup lang="ts">([\s\S]*?)<\/script>/)![1]!
// Exercise the component's actual reactive selection without a server or API.
const setup = new Function('ref', 'computed', 'watch', 'useRoute', 'useAuth', 'useFavorites',
  'EXAM_CATALOG', 'FREE_EXAM_CATALOG', 'hasFullExamAccess',
  `${stripTypeScriptTypes(script.replace(/^import[^\n]*\n/gm, ''), { mode: 'transform' })}
   return { exams, openExam, toggleExam, examTarget }`)

function sidebar(initial: AccessUser) {
  const user = ref<AccessUser>(initial)
  const scope = effectScope()
  const unexpectedRequest = () => { throw new Error('Sidebar must not make membership or question API requests') }
  const state = scope.run(() => setup(ref, computed, watch,
    () => ({ path: '/', fullPath: '/' }),
    () => ({ user, ensureCurrentUser: unexpectedRequest }),
    () => ({ isFavoriteAt: () => false }),
    EXAM_CATALOG, FREE_EXAM_CATALOG, hasFullExamAccess))!
  return { user, state, stop: () => scope.stop() }
}

test('anonymous and free members immediately use the configured free catalog', (t) => {
  for (const member of [null, { role: 'user', paid_content_access: false }]) {
    const view = sidebar(member)
    t.after(view.stop)
    assert.equal(view.state.exams.value, FREE_EXAM_CATALOG)
    assert.equal(view.state.exams.value.length, EXAM_CONFIG.payments.free_exam_count)
    assert.deepEqual(view.state.exams.value.map((exam: { exam_number: number }) => exam.exam_number), [1, 2, 3, 4, 5])
    assert.equal(view.state.examTarget(view.state.exams.value[4]), '/practice/5/1')
  }
})

test('premium, administrator and verification access use all static sets', (t) => {
  for (const member of [
    { role: 'user', paid_content_access: true },
    { role: 'admin', paid_content_access: true },
    // A verification grant can have free purchase status but full access.
    { role: 'user', paid_content_access: true, membership: { status: 'free' } },
  ]) {
    const view = sidebar(member)
    t.after(view.stop)
    assert.equal(view.state.exams.value, EXAM_CATALOG)
    assert.equal(view.state.exams.value.length, EXAM_CONFIG.exam.set_count)
    assert.equal(view.state.examTarget(view.state.exams.value.at(-1), 20), '/practice/50/20')
  }
})

test('membership resolution, revocation and logout update the catalog without fetching questions', async (t) => {
  const view = sidebar(null)
  t.after(view.stop)
  assert.equal(view.state.exams.value.length, 5)
  view.user.value = { role: 'user', paid_content_access: true }
  await nextTick()
  assert.equal(view.state.exams.value.length, 50)
  view.state.toggleExam(20)
  assert.equal(view.state.openExam.value, 20)

  view.user.value.paid_content_access = false
  await nextTick()
  assert.equal(view.state.exams.value.length, 5)
  assert.equal(view.state.openExam.value, null)

  view.user.value = { role: 'user', paid_content_access: true }
  await nextTick()
  view.state.toggleExam(50)
  view.user.value = null
  await nextTick()
  assert.equal(view.state.exams.value.length, 5)
  assert.equal(view.state.openExam.value, null)
})

test('opening and closing the static question links preserves the visible catalog', (t) => {
  const view = sidebar(null)
  t.after(view.stop)
  const before = view.state.exams.value
  view.state.toggleExam(1)
  assert.equal(view.state.openExam.value, 1)
  assert.equal(before[0].question_numbers.length, EXAM_CONFIG.exam.questions_per_exam)
  assert.equal(view.state.examTarget(before[0], 20), '/practice/1/20')
  view.state.toggleExam(1)
  assert.equal(view.state.openExam.value, null)
  assert.equal(view.state.exams.value, before)
})

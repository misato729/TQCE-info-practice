import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { stripTypeScriptTypes } from 'node:module'
import test from 'node:test'
import { computed, reactive, ref } from 'vue'

const source = readFileSync(new URL('../app/pages/admin/questions/[questionId]/edit.vue', import.meta.url), 'utf8')
const script = source.match(/<script setup lang="ts">([\s\S]*?)<\/script>/)![1]!
const AsyncFunction = Object.getPrototypeOf(async function () {}).constructor
const setup = new AsyncFunction('ref', 'computed', 'definePageMeta', 'useRoute', 'useNuxtApp', 'useAuth', 'useFetch',
  'apiFormErrors', 'questionFormFields', 'window',
  `${stripTypeScriptTypes(script.replace(/^import[^\n]*\n/gm, ''), { mode: 'transform' })}
   return { submit, response, question, successMessage, errorMessage }`)
const original = { id: 42, exam_number: 1, question_number: 1, content_blocks: [{ type: 'text', text: 'Synthetic draft' }], choices: [] }

async function harness(api: (path: string, options: any) => Promise<unknown>) {
  const route = reactive({ params: { questionId: '42' }, query: {}, fullPath: '/admin/questions/42/edit' })
  let reads = 0
  const state = await setup(ref, computed, () => {}, () => route, () => ({ $api: api }),
    () => ({ authHeaders: ref({}), clearCurrentUser() {} }),
    async () => {
      reads += 1
      return { data: ref({ data: original }), status: ref('success'), error: ref(null), refresh: async () => { reads += 1 } }
    }, () => [], [], { scrollTo() {} })
  return { state, route, reads: () => reads }
}

test('saving an admin edit applies the canonical PATCH response without another detail GET', async () => {
  const calls: unknown[] = []
  const canonical = { ...original, content_blocks: [{ type: 'text', text: 'Server-normalized draft' }], choices: [{ id: 99 }] }
  const { state, reads } = await harness(async (path, options) => {
    calls.push({ path, ...options })
    return { data: canonical }
  })
  const input = { ...original, content_blocks: [{ type: 'text', text: 'Edited draft' }] }
  await state.submit(input)
  assert.deepEqual(calls, [{ path: '/api/v1/admin/questions/42', method: 'PATCH', headers: {}, body: { question: input } }])
  assert.equal(reads(), 1)
  assert.deepEqual(state.question.value, canonical)
  assert.equal(state.successMessage.value, '編集内容を保存しました。')
})

test('failed saves retain the previous question and do not issue a verification GET', async () => {
  const { state, reads } = await harness(async () => {
    throw { statusCode: 422, data: { error: { message: 'Synthetic field validation failure' } } }
  })
  await state.submit(original)
  assert.deepEqual(state.question.value, original)
  assert.equal(state.successMessage.value, '')
  assert.equal(state.errorMessage.value, 'Synthetic field validation failure')
  assert.equal(reads(), 1)
})

test('a save finishing after the edit target changes cannot replace its new question', async () => {
  let finish!: (result: unknown) => void
  const { state, route, reads } = await harness(async () => new Promise(resolve => { finish = resolve }))
  const saving = state.submit(original)
  route.params.questionId = '43'
  const next = { ...original, id: 43 }
  state.response.value = { data: next }
  finish({ data: original })
  await saving
  assert.deepEqual(state.question.value, next)
  assert.equal(state.successMessage.value, '')
  assert.equal(reads(), 1)
})

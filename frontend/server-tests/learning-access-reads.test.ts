import assert from 'node:assert/strict'
import test from 'node:test'
import type { User } from '../server/core/auth.ts'
import { configuration, setConfigurationForTesting } from '../server/core/config.ts'
import type { Database } from '../server/core/db.ts'
import { ApiError } from '../server/core/errors.ts'
import { getQuestion, nextQuestion } from '../server/services/learning.ts'

const member: User = { id: 42, name: 'Synthetic member', email: 'learning-access@example.invalid', role: 'user', created_at: new Date('2026-01-01T00:00:00Z') }
type AccessState = { membership: 'active' | 'revoked' | null, grant: { expires_at: Date, revoked_at: Date | null } | null }
type QuestionWhere = { id?: number | { not: number }, publication_status?: string, exam_number?: number | { lte: number }, question_number?: { gt: number } }
const status = (code: number) => (error: unknown) => error instanceof ApiError && error.status === code

function databaseFor(state: AccessState, options: { missingAtLoad?: boolean } = {}) {
  const reads = { membership: 0, grant: 0, candidates: 0, questions: 0, favorites: 0 }
  const rows = ([[100, 1, 1, 'private'], [101, 1, 2, 'published'], [601, 6, 1, 'published']] as const).map(([id, exam, number, visibility]) => ({
    id: BigInt(id), exam_number: Number(exam), question_number: Number(number), publication_status: String(visibility),
    content_blocks: [{ type: 'text', text: 'Synthetic question' }], explanation_blocks: [{ type: 'text', text: 'Hidden explanation' }],
    source_text: 'Synthetic source | https://example.invalid/source', major_category_code: '1', category_code: '1.1',
    choices: ['ア', 'イ', 'ウ', 'エ'].map((choice_label, index) => ({ id: BigInt(Number(id) * 10 + index), question_id: BigInt(id), choice_label,
      display_order: index + 1, content_blocks: [{ type: 'text', text: 'Synthetic choice' }], is_correct: index === 0 })),
  }))
  const database = {
    membership: { async findFirst({ where }: { where: { user_id: number, status: string } }) {
      reads.membership += 1
      assert.deepEqual(where, { user_id: member.id, status: 'active' })
      return state.membership === 'active' ? { id: 1n } : null
    } },
    verificationAccessGrant: { async findFirst({ where }: { where: { user_id: number, revoked_at: null, expires_at: { gt: Date } } }) {
      reads.grant += 1
      assert.equal(where.user_id, member.id)
      assert.equal(where.revoked_at, null)
      assert.ok(where.expires_at.gt instanceof Date)
      return state.grant && !state.grant.revoked_at && state.grant.expires_at > where.expires_at.gt ? { id: 2n } : null
    } },
    question: { async findFirst({ where, select }: { where: QuestionWhere, select?: { id: boolean } }) {
      if (select) reads.candidates += 1
      else reads.questions += 1
      assert.equal(where.publication_status, 'published', 'candidate and body lookups must both exclude private questions')
      if (!select && options.missingAtLoad) return null
      const row = rows.find(row => row.publication_status === where.publication_status &&
        (where.id === undefined || (typeof where.id === 'number' ? Number(row.id) === where.id : Number(row.id) !== where.id.not)) &&
        (where.exam_number === undefined || (typeof where.exam_number === 'number' ? row.exam_number === where.exam_number : row.exam_number <= where.exam_number.lte)) &&
        (where.question_number === undefined || row.question_number > where.question_number.gt))
      return row ? select ? { id: row.id } : row : null
    } },
    favorite: { async findUnique({ where }: { where: { user_id_question_id: { user_id: number, question_id: number } } }) {
      reads.favorites += 1
      assert.equal(where.user_id_question_id.user_id, member.id)
      return { id: 3n }
    } },
  } as unknown as Database
  return { database, reads }
}

async function configured(action: () => Promise<void>, enabled = true) {
  const previous = configuration
  const previousEnvironment = process.env.APP_ENV
  process.env.APP_ENV = 'test'
  setConfigurationForTesting({ ...structuredClone(previous), exam: { ...previous.exam, set_count: 6 },
    payments: { ...previous.payments, enabled, free_exam_count: 5 } })
  try { await action() }
  finally {
    setConfigurationForTesting(previous)
    if (previousEnvironment === undefined) delete process.env.APP_ENV
    else process.env.APP_ENV = previousEnvironment
  }
}

test('direct and next-question responses resolve current membership and grant at most once', async () => configured(async () => {
  const cases: { name: string, membership: AccessState['membership'], grant: AccessState['grant'], user: User | null, fullAccess: boolean }[] = [
    { name: 'anonymous', membership: null, grant: null, user: null, fullAccess: false },
    { name: 'free', membership: null, grant: null, user: member, fullAccess: false },
    { name: 'premium', membership: 'active', grant: null, user: member, fullAccess: true },
    { name: 'verification', membership: null, grant: { expires_at: new Date(Date.now() + 60_000), revoked_at: null }, user: member, fullAccess: true },
    { name: 'administrator', membership: null, grant: null, user: { ...member, role: 'admin' }, fullAccess: true },
  ]
  for (const fixture of cases) for (const operation of ['direct', 'next', 'unfiltered', 'exclude'] as const) {
    const { database, reads } = databaseFor(fixture)
    const exam = fixture.fullAccess ? 6 : 1
    const result = operation === 'direct' ? await getQuestion(exam === 6 ? 601 : 101, fixture.user, database)
      : await nextQuestion(operation === 'next' ? { exam_number: exam, after_question_number: 0 }
        : operation === 'exclude' ? { exclude_question_id: 101 } : {}, fixture.user, database)
    assert.equal(result.data.id, operation === 'unfiltered' ? 101 : exam === 6 ? 601 : 101, `${fixture.name}/${operation}`)
    assert.equal('explanation_blocks' in result.data, false)
    assert.equal('source_text' in result.data, false)
    assert.equal('is_correct' in (result.data.choices as Record<string, unknown>[])[0]!, false)
    assert.equal(result.data.is_favorite, fixture.user ? fixture.fullAccess : undefined)
    const entitlementReads = fixture.user?.role === 'user' ? 1 : 0
    assert.deepEqual(reads, { membership: entitlementReads, grant: entitlementReads,
      candidates: operation === 'direct' ? 0 : operation === 'exclude' && !fixture.fullAccess ? 2 : 1,
      questions: 1, favorites: fixture.user && fixture.fullAccess ? 1 : 0 }, `${fixture.name}/${operation}`)
  }
}))

test('existence and publication precede direct authorization while paid next authorization precedes candidate queries and after validation', async () => configured(async () => {
  const { database, reads } = databaseFor({ membership: null, grant: null })
  await assert.rejects(getQuestion(999, member, database), status(404))
  await assert.rejects(getQuestion(100, member, database), status(404))
  assert.deepEqual(reads, { membership: 0, grant: 0, candidates: 0, questions: 2, favorites: 0 })
  await assert.rejects(nextQuestion({ exam_number: 6, after_question_number: 'invalid' }, member, database), status(403))
  assert.equal(reads.membership, 1)
  assert.equal(reads.grant, 1)
  await assert.rejects(nextQuestion({ exam_number: 6, after_question_number: 'invalid' }, null, database), status(401))
  await assert.rejects(nextQuestion({ exam_number: 'invalid' }, member, database), status(400))
  assert.deepEqual(reads, { membership: 1, grant: 1, candidates: 0, questions: 2, favorites: 0 })
  await assert.rejects(getQuestion(601, member, database), status(403))
  assert.deepEqual(reads, { membership: 2, grant: 2, candidates: 0, questions: 3, favorites: 0 })
}))

test('invalid or missing free next-question requests never read memberships or grants', async () => configured(async () => {
  for (const fixture of [
    { params: { exam_number: 1, after_question_number: 'invalid' }, status: 400, candidates: 0, questions: 0 },
    { params: { exam_number: 1, after_question_number: 20 }, status: 404, candidates: 1, questions: 0 },
    { params: { exam_number: 1 }, status: 404, candidates: 1, questions: 1, missingAtLoad: true },
  ]) {
    const { database, reads } = databaseFor({ membership: null, grant: null }, { missingAtLoad: fixture.missingAtLoad })
    await assert.rejects(nextQuestion(fixture.params, member, database), status(fixture.status))
    assert.deepEqual(reads, { membership: 0, grant: 0, candidates: fixture.candidates, questions: fixture.questions, favorites: 0 })
  }
}))

test('next-question permissions are reread after membership revocation and verification expiry', async () => configured(async () => {
  const state: AccessState = { membership: 'active', grant: null }
  const { database, reads } = databaseFor(state)
  assert.equal((await nextQuestion({ exam_number: 6 }, member, database)).data.id, 601)
  state.membership = 'revoked'
  await assert.rejects(nextQuestion({ exam_number: 6 }, member, database), status(403))
  state.grant = { expires_at: new Date(Date.now() + 60_000), revoked_at: null }
  assert.equal((await nextQuestion({ exam_number: 6 }, member, database)).data.id, 601)
  state.grant.expires_at = new Date(Date.now() - 60_000)
  await assert.rejects(nextQuestion({ exam_number: 6 }, member, database), status(403))
  assert.deepEqual(reads, { membership: 4, grant: 4, candidates: 2, questions: 2, favorites: 2 })
}))

test('disabled payments retain full anonymous access without entitlement or favorite queries', async () => configured(async () => {
  const { database, reads } = databaseFor({ membership: null, grant: null })
  assert.equal((await nextQuestion({ exam_number: 6 }, null, database)).data.id, 601)
  assert.deepEqual(reads, { membership: 0, grant: 0, candidates: 1, questions: 1, favorites: 0 })
}, false))

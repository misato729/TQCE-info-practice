import { installServerFixtureConfiguration } from './helpers/fixtures.ts'
import assert from 'node:assert/strict'
import { after, test } from 'node:test'
import { configuration, setConfigurationForTesting } from '../server/core/config.ts'
import { closeDatabase, isolatedTransaction, query, type Database } from '../server/core/db.ts'
import { canonical, digest, OperationError } from '../server/operations/content.ts'
import { IDENTITY_RESTORE_CONFIRMATION, parseQuestionIdentity, readQuestionIdentity, restoreQuestionIdentity,
  type QuestionIdentityDocument } from '../server/operations/question-identity.ts'
import { runCommand, safeOperationFailure } from '../server/operations/cli.ts'

process.env.APP_ENV = 'test'
if (process.env.TEST_DATABASE_URL) process.env.DATABASE_URL = process.env.TEST_DATABASE_URL
const integration = { skip: !Boolean(process.env.TEST_DATABASE_URL) }
const original = installServerFixtureConfiguration()
setConfigurationForTesting({ ...original, exam: { ...original.exam, set_count: 1, questions_per_exam: 2 },
  payments: { ...original.payments, enabled: false, free_exam_count: 1 } })
after(async () => { setConfigurationForTesting(original); await closeDatabase() })

function fixture(): QuestionIdentityDocument {
  const category = configuration.categories.minor[0]!
  const questions = [17, 83].map((id, index) => ({ id, exam_number: 1, question_number: index + 1,
    major_category_code: category.major_category_value, category_code: category.value,
    content_blocks: [{ type: 'code' as const, title: '', code: `value = ${index + 1}` }],
    explanation_blocks: [{ type: 'quote' as const, source: null, text: 'Synthetic explanation' }],
    source_text: 'Synthetic source | https://example.invalid/identity', publication_status: 'published' as const,
    created_at: '2020-01-02T03:04:05.123456Z', updated_at: '2021-02-03T04:05:06.654321Z' }))
  const question_choices = questions.flatMap((question, index) => configuration.exam.choice_labels.map((choice_label, order) => ({
    id: 501 + index * 100 + order, question_id: question.id, choice_label,
    content_blocks: [{ type: 'text' as const, text: `Synthetic choice ${order}` }], is_correct: order === index,
    display_order: order + 1, created_at: '2020-02-03T04:05:06.000001Z', updated_at: '2021-03-04T05:06:07.999999Z' })))
  return { schema_version: 1, questions, question_choices }
}

test('identity restore validates all columns and relations without changing JSON metadata or microseconds', () => {
  const original = fixture()
  const reversed = structuredClone(original)
  reversed.questions.reverse(); reversed.question_choices.reverse()
  assert.deepEqual(parseQuestionIdentity(reversed), original)
  assert.equal(digest(parseQuestionIdentity(reversed)), digest(original))
  assert.equal(original.questions[0]!.created_at, '2020-01-02T03:04:05.123456Z')
  assert.equal(original.questions[0]!.content_blocks[0]!.title, '')
  assert.equal(original.questions[0]!.explanation_blocks[0]!.source, null)
})

test('identity restore rejects unknown fields, duplicate IDs/coordinates, orphan choices and invalid timestamps before DB use', () => {
  const mutations: ((value: QuestionIdentityDocument) => void)[] = [
    value => { Object.assign(value, { unsupported: 'synthetic-private-value' }) },
    value => { Object.assign(value.questions[0]!, { unsupported: true }) },
    value => { Object.assign(value.question_choices[0]!, { unsupported: true }) },
    value => { value.questions[1]!.id = value.questions[0]!.id },
    value => { value.questions[1]!.question_number = value.questions[0]!.question_number },
    value => { value.question_choices[1]!.id = value.question_choices[0]!.id },
    value => { value.question_choices[0]!.question_id = 999 },
    value => { value.question_choices[0]!.is_correct = false },
    value => { value.question_choices[0]!.choice_label = 'unconfigured-label' },
    value => { value.questions[0]!.created_at = '2020-02-30T00:00:00.123456Z' },
    value => { value.questions[0]!.created_at = '2020-02-03T00:00:00.1234567Z' },
    value => { value.questions[0]!.id = Number.MAX_SAFE_INTEGER },
    value => { value.questions.pop(); value.question_choices = value.question_choices.filter(choice => choice.question_id === 17) },
  ]
  for (const mutate of mutations) {
    const document = fixture(); mutate(document)
    assert.throws(() => parseQuestionIdentity(document), OperationError)
  }
})

test('identity restore requires an explicit confirmation and CLI failures disclose no private row content', async () => {
  const db = { $queryRawUnsafe: async () => { throw new Error('DB must not be reached') } } as unknown as Database
  await assert.rejects(restoreQuestionIdentity(fixture(), undefined, db), OperationError)
  await assert.rejects(runCommand('questions:restore_identity', { INPUT: '/does/not/exist' }), OperationError)
  const invalid = fixture(); invalid.questions[0]!.source_text = 'synthetic-private-value'
  try { parseQuestionIdentity(invalid); assert.fail('Invalid source must be rejected') }
  catch (error) { assert.equal(JSON.stringify(safeOperationFailure(error)).includes('synthetic-private-value'), false) }
})

async function isolated(action: (db: Database) => Promise<void>) {
  return isolatedTransaction(async db => {
    await query("SET LOCAL lock_timeout='10s'", [], db)
    await db.user.deleteMany()
    await db.question.deleteMany()
    await db.payment.deleteMany()
    await db.stripeWebhookEvent.deleteMany()
    await db.authVerification.deleteMany()
    await db.apiRateLimitBucket.deleteMany()
    await db.rateLimiterFlexible.deleteMany()
    await action(db)
  })
}

test('PostgreSQL identity restore preserves every row and microsecond, rejects populated targets and advances both sequences', integration, async () => isolated(async db => {
  const document = fixture()
  const report = await restoreQuestionIdentity(document, IDENTITY_RESTORE_CONFIRMATION, db)
  assert.deepEqual(report, { question_count: 2, choice_count: document.question_choices.length, sha256: digest(document) })
  assert.deepEqual(canonical(await readQuestionIdentity(db)), canonical(document))
  await query('SAVEPOINT reject_populated_identity', [], db)
  await assert.rejects(restoreQuestionIdentity(document, IDENTITY_RESTORE_CONFIRMATION, db), OperationError)
  await query('ROLLBACK TO SAVEPOINT reject_populated_identity', [], db)
  assert.deepEqual(canonical(await readQuestionIdentity(db)), canonical(document))
  const [next] = await query<{ question_id: number, choice_id: number }>("SELECT nextval(pg_get_serial_sequence('questions','id')) AS question_id,nextval(pg_get_serial_sequence('question_choices','id')) AS choice_id", [], db)
  assert.equal(next!.question_id, Math.max(...document.questions.map(row => row.id)) + 1)
  assert.equal(next!.choice_id, Math.max(...document.question_choices.map(row => row.id)) + 1)
}))

test('PostgreSQL identity restoration rejects any existing user data before inserting learning rows', integration, async () => isolated(async db => {
  await query("INSERT INTO users(name,email,role,created_at,updated_at) VALUES('Synthetic identity test','identity-restore@example.invalid','user',NOW(),NOW())", [], db)
  await assert.rejects(restoreQuestionIdentity(fixture(), IDENTITY_RESTORE_CONFIRMATION, db), OperationError)
  assert.equal(await db.question.count(), 0)
  assert.equal(await db.questionChoice.count(), 0)
}))

test('PostgreSQL identity restoration detects modified database rows and rolls inserts back to the caller transaction savepoint', integration, async () => isolated(async db => {
  await query(`CREATE FUNCTION pg_temp.change_identity_fixture() RETURNS trigger LANGUAGE plpgsql AS $$
    BEGIN NEW.source_text := 'Synthetic modified value | https://example.invalid/changed'; RETURN NEW; END $$`, [], db)
  await query('CREATE TRIGGER identity_fixture_before_insert BEFORE INSERT ON questions FOR EACH ROW EXECUTE FUNCTION pg_temp.change_identity_fixture()', [], db)
  await query('SAVEPOINT failed_identity_restore', [], db)
  await assert.rejects(restoreQuestionIdentity(fixture(), IDENTITY_RESTORE_CONFIRMATION, db), OperationError)
  await query('ROLLBACK TO SAVEPOINT failed_identity_restore', [], db)
  assert.equal(await db.question.count(), 0)
  assert.equal(await db.questionChoice.count(), 0)
}))

import { lstat, readFile } from 'node:fs/promises'
import { z } from 'zod'
import { configuration } from '../core/config.ts'
import { query, transaction, type Database } from '../core/db.ts'
import { canonical, digest, MAX_CONTENT_BYTES, OperationError, QUESTION_LOCK } from './content.ts'
import { blocksSchema, parseQuestionInput } from '../../shared/schemas/content.ts'
import type { ExamConfiguration } from '../../shared/schemas/exam.ts'

export const IDENTITY_RESTORE_CONFIRMATION = 'RESTORE_QUESTION_IDENTITY_INTO_EMPTY_DATABASE'
const invalid = () => new OperationError('問題ID復元データの形式・関連・設定との整合を確認してください')
const identifier = z.number().int().min(1).max(Number.MAX_SAFE_INTEGER - 1)

/** Validate UTC timestamps without truncating PostgreSQL's six fractional digits. */
function timestamp(value: string): string {
  const match = /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})(?:\.(\d{1,6}))?Z$/.exec(value)
  if (!match || value.startsWith('0000-')) throw invalid()
  const date = new Date(value)
  if (!Number.isFinite(date.getTime()) || date.toISOString().slice(0, 19) !== match[1]) throw invalid()
  return `${match[1]}.${(match[2] || '').padEnd(6, '0')}Z`
}
const instant = z.string().transform(timestamp)
const questionRow = z.strictObject({
  id: identifier, exam_number: z.number().int(), question_number: z.number().int(),
  major_category_code: z.string(), category_code: z.string(),
  content_blocks: blocksSchema('question', false, true, true),
  explanation_blocks: blocksSchema('explanation', false, true, true),
  source_text: z.string().nullable(), publication_status: z.enum(['draft', 'published', 'private']),
  created_at: instant, updated_at: instant,
})
const choiceRow = z.strictObject({
  id: identifier, question_id: identifier, choice_label: z.string(),
  content_blocks: blocksSchema('choice', false, true, true), is_correct: z.boolean(),
  display_order: z.number().int(), created_at: instant, updated_at: instant,
})
const documentSchema = z.strictObject({
  schema_version: z.literal(1), questions: z.array(questionRow).min(1), question_choices: z.array(choiceRow).min(1),
})
export type QuestionIdentityDocument = z.output<typeof documentSchema>

/** Validation never normalizes the content or removes an optional JSON property. */
export function parseQuestionIdentity(value: unknown, config: ExamConfiguration = configuration): QuestionIdentityDocument {
  try {
    const document = documentSchema.parse(value)
    const ids = new Set<number>(), coordinates = new Set<string>(), choiceIds = new Set<number>()
    const choices = new Map<number, typeof document.question_choices>()
    for (const question of document.questions) {
      const coordinate = `${question.exam_number}/${question.question_number}`
      if (ids.has(question.id) || coordinates.has(coordinate)) throw invalid()
      ids.add(question.id); coordinates.add(coordinate)
    }
    for (const choice of document.question_choices) {
      if (choiceIds.has(choice.id) || !ids.has(choice.question_id)) throw invalid()
      choiceIds.add(choice.id)
      const group = choices.get(choice.question_id) ?? []
      group.push(choice); choices.set(choice.question_id, group)
    }
    for (const question of document.questions) {
      const { id, created_at, updated_at, ...input } = question
      const related = (choices.get(id) ?? []).sort((left, right) => left.display_order - right.display_order)
      const raw = { ...input, choices: related.map(({ choice_label, content_blocks, is_correct, display_order }) => ({ choice_label, content_blocks, is_correct, display_order })) }
      const validated = parseQuestionInput(raw, config, { strict: true, preserveOptionalAttributes: true })
      // A validator transform must never silently change a private restoration row.
      if (JSON.stringify(canonical(raw)) !== JSON.stringify(canonical(validated))) throw invalid()
    }
    const published = new Set(document.questions.filter(row => row.publication_status === 'published').map(row => row.exam_number))
    for (const exam of published) {
      for (let number = 1; number <= config.exam.questions_per_exam; number++) {
        if (!coordinates.has(`${exam}/${number}`)) throw invalid()
      }
    }
    return { schema_version: 1, questions: document.questions.sort((left, right) => left.id - right.id),
      question_choices: document.question_choices.sort((left, right) => left.id - right.id) }
  } catch { throw invalid() }
}

// Infrastructure migration ledgers may have rows. Every application table must be empty.
const applicationTables = ['questions', 'question_choices', 'users', 'answer_histories', 'favorites', 'payments', 'memberships',
  'stripe_webhook_events', 'verification_access_grants', 'api_rate_limit_buckets', 'rate_limiter_flexible',
  'auth_sessions', 'auth_accounts', 'auth_verifications'] as const

/** Read raw timestamp strings; Prisma Date/JS Date would discard microseconds. */
export async function readQuestionIdentity(db: Database): Promise<QuestionIdentityDocument> {
  const [questions, choices] = await Promise.all([
    query<{ row: QuestionIdentityDocument['questions'][number] }>(`SELECT to_jsonb(q) || jsonb_build_object(
      'created_at', to_char(q.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
      'updated_at', to_char(q.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')) AS row FROM questions q ORDER BY id`, [], db),
    query<{ row: QuestionIdentityDocument['question_choices'][number] }>(`SELECT to_jsonb(c) || jsonb_build_object(
      'created_at', to_char(c.created_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
      'updated_at', to_char(c.updated_at, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')) AS row FROM question_choices c ORDER BY id`, [], db),
  ])
  return { schema_version: 1, questions: questions.map(item => item.row), question_choices: choices.map(item => item.row) }
}

async function restartOwnedSequence(table: 'questions' | 'question_choices', next: number, db: Database) {
  const [sequence] = await query<{ schema_name: string, sequence_name: string }>(`SELECT n.nspname::text AS schema_name, c.relname::text AS sequence_name
    FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE c.oid=pg_get_serial_sequence($1,'id')::regclass AND c.relkind='S'`, [table], db)
  if (!sequence || !Number.isSafeInteger(next) || next < 1) throw new OperationError('問題IDの採番情報を確認できません')
  const quote = (value: string) => '"' + value.replaceAll('"', '""') + '"'
  // Unlike setval(), ALTER SEQUENCE RESTART is rolled back with the transaction.
  await query(`ALTER SEQUENCE ${quote(sequence.schema_name)}.${quote(sequence.sequence_name)} RESTART WITH ${next}`, [], db)
}

/** Explicit one-off migration only: no startup hook, no mutation of a source DB. */
export async function restoreQuestionIdentity(value: unknown, confirmation: string | undefined, db?: Database) {
  if (confirmation !== IDENTITY_RESTORE_CONFIRMATION) throw new OperationError('空DBへ問題IDを復元する明示的な確認が必要です')
  const document = parseQuestionIdentity(value)
  return transaction(async connection => {
    await query('SELECT pg_advisory_xact_lock($1)::text', [QUESTION_LOCK], connection)
    await query(`LOCK TABLE ${applicationTables.join(', ')} IN ACCESS EXCLUSIVE MODE`, [], connection)
    for (const table of applicationTables) {
      const [existing] = await query<{ present: boolean }>(`SELECT EXISTS(SELECT 1 FROM ${table} LIMIT 1) AS present`, [], connection)
      if (existing?.present) throw new OperationError('問題IDの復元は全業務テーブルが空のDBだけで実行できます')
    }
    // This limited import escape hatch preserves timestamp(6), IDs and JSONB verbatim.
    // Values are bound JSON parameters; table names and all SQL columns are fixed.
    await query(`INSERT INTO questions (id,exam_number,question_number,major_category_code,category_code,content_blocks,explanation_blocks,source_text,publication_status,created_at,updated_at)
      SELECT id,exam_number,question_number,major_category_code,category_code,content_blocks,explanation_blocks,source_text,publication_status,created_at,updated_at
      FROM jsonb_to_recordset($1::jsonb) AS q(id bigint,exam_number integer,question_number integer,major_category_code varchar(50),category_code varchar(100),
        content_blocks jsonb,explanation_blocks jsonb,source_text text,publication_status varchar(20),created_at timestamp(6),updated_at timestamp(6))`, [JSON.stringify(document.questions)], connection)
    await query(`INSERT INTO question_choices (id,question_id,choice_label,content_blocks,is_correct,display_order,created_at,updated_at)
      SELECT id,question_id,choice_label,content_blocks,is_correct,display_order,created_at,updated_at
      FROM jsonb_to_recordset($1::jsonb) AS c(id bigint,question_id bigint,choice_label varchar(10),content_blocks jsonb,is_correct boolean,display_order integer,created_at timestamp(6),updated_at timestamp(6))`, [JSON.stringify(document.question_choices)], connection)
    const restored = await readQuestionIdentity(connection)
    if (JSON.stringify(canonical(restored)) !== JSON.stringify(canonical(document))) throw new OperationError('復元した問題・選択肢の全行照合に失敗しました')
    await restartOwnedSequence('questions', document.questions.at(-1)!.id + 1, connection)
    await restartOwnedSequence('question_choices', document.question_choices.at(-1)!.id + 1, connection)
    return { question_count: document.questions.length, choice_count: document.question_choices.length, sha256: digest(restored) }
  }, db)
}

export async function restoreQuestionIdentityFile(path: string, confirmation: string | undefined) {
  if (confirmation !== IDENTITY_RESTORE_CONFIRMATION) throw new OperationError('空DBへ問題IDを復元する明示的な確認が必要です')
  let value: unknown
  try {
    if (!path || path.includes('\0')) throw invalid()
    const metadata = await lstat(path)
    if (!metadata.isFile() || metadata.size > MAX_CONTENT_BYTES) throw invalid()
    const bytes = await readFile(path)
    if (bytes.length > MAX_CONTENT_BYTES) throw invalid()
    value = JSON.parse(bytes.toString('utf8'))
  } catch { throw new OperationError('問題ID復元元の通常ファイル・サイズ・JSON形式を確認してください') }
  return restoreQuestionIdentity(value, confirmation)
}

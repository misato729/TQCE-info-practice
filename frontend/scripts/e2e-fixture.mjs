import { readFileSync } from 'node:fs'
import { createExamConfiguration } from '../shared/examConfig.ts'
import { contentDocumentSchema, parseQuestionArchiveEntries, isRecord } from '../shared/schemas/content.ts'

/** Runtime, browser bundles and fixture import all use the same explicitly isolated configuration. */
export function loadE2EFixture(environment = process.env) {
  if (environment.APP_ENV !== 'test' || environment.TQCE_E2E_FREE_MODE !== 'true') {
    throw new Error('E2E fixtures require explicit isolated test mode.')
  }
  let config
  let questions
  try {
    config = createExamConfiguration(JSON.parse(readFileSync(new URL('../../config/exam.json', import.meta.url), 'utf8')), environment)
    const document = contentDocumentSchema.parse(JSON.parse(readFileSync(new URL('../../content/questions.json', import.meta.url), 'utf8')))
    const entries = document.questions.filter(question => isRecord(question) && typeof question.exam_number === 'number' && question.exam_number <= config.exam.set_count)
    questions = parseQuestionArchiveEntries(entries, config)
  } catch { throw new Error('E2E fixture validation failed. Check the shared configuration and sample content.') }
  const question = questions.find(item => item.publication_status === 'published')
  if (!question || config.payments.enabled || questions.length !== config.exam.set_count * config.exam.questions_per_exam) {
    throw new Error('Core browser journeys require two complete published test sets in the isolated free-mode fixture.')
  }
  return { config, question, questions }
}

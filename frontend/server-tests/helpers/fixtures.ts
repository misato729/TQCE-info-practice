import { fileURLToPath } from 'node:url'
import { EXAM_CONFIG, type ExamConfiguration } from '../../shared/examConfig.ts'
import { setConfigurationForTesting } from '../../server/core/config.ts'

// Synthetic 2x3 fixtures keep API tests small and independent of published content.
export const serverFixtureContentPath = fileURLToPath(new URL('../fixtures/content.json', import.meta.url))
export function serverFixtureConfiguration(): ExamConfiguration {
  const config = structuredClone(EXAM_CONFIG)
  config.exam.set_count = 2
  config.exam.questions_per_exam = 3
  config.payments.enabled = false
  config.payments.free_exam_count = 2
  return config
}
export function installServerFixtureConfiguration(): ExamConfiguration {
  const config = serverFixtureConfiguration()
  setConfigurationForTesting(config)
  return config
}

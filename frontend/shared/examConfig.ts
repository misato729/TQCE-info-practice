import rawConfiguration from '../../config/exam.json' with { type: 'json' }

import { parseExamConfig } from './schemas/exam.ts'
export { parseExamConfig } from './schemas/exam.ts'
export type { ExamConfiguration } from './schemas/exam.ts'

/** An explicit isolated test flag is the only override; the public JSON remains the service configuration. */
export function createExamConfiguration(value: unknown, environment: { APP_ENV?: string, TQCE_E2E_FREE_MODE?: string } = {}) {
  const config = parseExamConfig(value)
  if (environment.APP_ENV !== 'test' || environment.TQCE_E2E_FREE_MODE !== 'true') return config
  const fixture = structuredClone(config)
  fixture.exam.set_count = 2
  fixture.payments.enabled = false
  fixture.payments.free_exam_count = 2
  return parseExamConfig(fixture)
}

export const EXAM_CONFIG = createExamConfiguration(rawConfiguration, {
  APP_ENV: process.env.APP_ENV,
  TQCE_E2E_FREE_MODE: process.env.TQCE_E2E_FREE_MODE,
})
export const SITE = EXAM_CONFIG.site
export const authCookieName = (config = EXAM_CONFIG) => `exam-${config.site.id}-access-token`
export const PAYMENTS_ENABLED = EXAM_CONFIG.payments.enabled
export const CHOICE_LABELS = EXAM_CONFIG.exam.choice_labels
export const PRICE_LABEL = `${new Intl.NumberFormat('ja-JP').format(EXAM_CONFIG.payments.amount)}円`

export type AccessUser = { role?: string, paid_content_access?: boolean } | null | undefined
export const hasFullExamAccess = (user: AccessUser, config = EXAM_CONFIG) => (
  !config.payments.enabled || user?.role === 'admin' || user?.paid_content_access === true
)
export const canUseFavoriteFeature = (loggedIn: boolean, user: AccessUser, config = EXAM_CONFIG) => (
  loggedIn && Boolean(user) && hasFullExamAccess(user, config)
)

export const themeVariables = (config = EXAM_CONFIG) => {
  const primary = config.site.primary_color
  const dark = '#' + [1, 3, 5].map(index => Math.round(parseInt(primary.slice(index, index + 2), 16) * 0.72).toString(16).padStart(2, '0')).join('')
  const pale = '#' + [1, 3, 5].map(index => Math.round(parseInt(primary.slice(index, index + 2), 16) * 0.15 + 255 * 0.85).toString(16).padStart(2, '0')).join('')
  return `:root{--brand-primary:${primary};--brand-primary-dark:${dark};--brand-header:${pale}}`
}

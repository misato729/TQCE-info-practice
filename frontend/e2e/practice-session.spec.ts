import { test, expect, type BrowserContext, type Page } from '@playwright/test'
import { EXAM_CONFIG } from '../app/utils/examConfig.ts'

// Synthetic browser contracts only: no real user, question or history is written.
async function sessionFixture(context: BrowserContext) {
  let identity = 'A'
  let heldAnswer: (() => void) | undefined
  let holdAnswer = false
  const questions: string[] = []
  const requests: string[] = []
  const question = (owner: string) => ({
    id: 991001, exam_number: 1, question_number: 1,
    major_category_code: EXAM_CONFIG.categories.major[0]!.value,
    category_code: EXAM_CONFIG.categories.minor[0]!.value,
    content_blocks: [{ type: 'text', text: `セッション確認用の合成問題 ${owner}` }],
    choices: EXAM_CONFIG.exam.choice_labels.map((choice_label, index) => ({
      id: 992001 + index, choice_label, display_order: index + 1,
      content_blocks: [{ type: 'text', text: `合成の選択肢 ${choice_label}` }],
    })),
    is_favorite: false,
  })
  const member = () => ({
    id: identity === 'A' ? 901 : 902, name: `合成会員${identity}`, email: `synthetic-${identity.toLowerCase()}@example.test`,
    role: 'user', paid_content_access: true, favorite_questions: [],
    membership: { status: 'active', purchased_at: '2026-01-01T00:00:00.000Z', expires_at: null }, verification_access: null,
  })
  await context.route('**/api/**', async route => {
    const path = new URL(route.request().url()).pathname
    requests.push(`${route.request().method()} ${path} ${identity}`)
    const respond = (body: unknown, status = 200) => route.fulfill({ status, contentType: 'application/json', body: JSON.stringify(body) })
    if (path === '/api/v1/me') return respond({ data: member() })
    if (path === '/api/auth/get-session') return respond({
      user: { ...member(), id: String(member().id), emailVerified: false, createdAt: '2026-01-01T00:00:00.000Z', updatedAt: '2026-01-01T00:00:00.000Z' },
      session: { id: `synthetic-session-${identity}`, userId: String(member().id), token: `synthetic-token-${identity}`, expiresAt: '2099-01-01T00:00:00.000Z' },
    })
    if (path === '/api/auth/sign-in/email') {
      identity = 'B'
      return respond({ user: { ...member(), id: String(member().id) }, token: 'synthetic-token-b' })
    }
    if (path === '/api/v1/questions/next') {
      questions.push(identity)
      return respond({ data: question(identity) })
    }
    if (path === '/api/v1/questions/991001/answer') {
      const owner = identity
      if (holdAnswer) await new Promise<void>(resolve => { heldAnswer = resolve })
      return respond({ data: {
        question_id: 991001, selected_choice_id: 992001, is_correct: true, correct_choice: question(owner).choices[0],
        explanation_blocks: [{ type: 'text', text: `合成会員${owner}の回答解説` }], source_text: null,
        answer_history_id: owner === 'A' ? 993001 : 993002,
      } })
    }
    return respond({}, 404)
  })
  return {
    questions,
    diagnostics: () => JSON.stringify({ requests, questions }),
    holdNextAnswer: () => { holdAnswer = true },
    answerWaiting: () => Boolean(heldAnswer),
    releaseAnswer: () => heldAnswer?.(),
  }
}

async function showPractice(page: Page) {
  await page.goto('/practice/1/1')
  // The mobile header may hide the account icon; its presence still proves
  // application identity has resolved before the initial question is answered.
  await expect(page.locator('.site-header .account-link')).toHaveCount(1)
  await expect(page.getByText('セッション確認用の合成問題 A', { exact: true })).toBeVisible()
}

async function switchAccount(context: BrowserContext) {
  const other = await context.newPage()
  await other.goto('/login')
  await other.getByLabel('メールアドレス', { exact: true }).fill('synthetic-b@example.test')
  await other.getByLabel('パスワード', { exact: true }).fill('Synthetic-password-123')
  await other.getByRole('button', { name: 'ログイン', exact: true }).click()
  await expect(other).toHaveURL('/')
  return other
}

async function submit(page: Page) {
  await page.locator('.choices label').first().click()
  await page.getByRole('button', { name: '回答する', exact: true }).click()
}

async function returnToPractice(page: Page) {
  // Better Auth broadcasts sign-out, but discovers another tab's sign-in on
  // visibility restoration. Its five-second focus throttle also applies here.
  // Advance Date only; timers and the application continue at their real rate.
  await page.clock.setFixedTime(new Date(Date.now() + 10_000))
  const session = page.waitForResponse(response => new URL(response.url()).pathname === '/api/auth/get-session' && response.ok())
  await page.bringToFront()
  // Headless/remote browsers do not always emit a visibility change when a tab
  // is brought forward. Exercise the same standard document event explicitly.
  await page.evaluate(() => document.dispatchEvent(new Event('visibilitychange')))
  await session
}

test('another-tab sign-in reloads a mounted practice page and clears the previous account answer', async ({ page, context }, testInfo) => {
  const fixture = await sessionFixture(context)
  await showPractice(page)
  await submit(page)
  await expect(page.getByText('合成会員Aの回答解説', { exact: true })).toBeVisible()
  const other = await switchAccount(context)
  try {
    await returnToPractice(page)
    await expect(page.getByText('セッション確認用の合成問題 B', { exact: true })).toBeVisible()
    await expect(page.getByRole('heading', { name: '解答解説', exact: true })).toHaveCount(0)
    await expect(page.getByRole('radio').first()).not.toBeChecked()
    expect(fixture.questions).toContain('B')
  } catch (error) {
    await testInfo.attach('synthetic-session-requests', { body: fixture.diagnostics(), contentType: 'application/json' })
    throw error
  } finally { await other.close() }
})

test('an answer finishing after an account switch cannot restore the previous account result', async ({ page, context }, testInfo) => {
  const fixture = await sessionFixture(context)
  await showPractice(page)
  fixture.holdNextAnswer()
  await submit(page)
  await expect.poll(fixture.answerWaiting).toBe(true)
  let other: Page | undefined
  try {
    other = await switchAccount(context)
    await returnToPractice(page)
    await expect(page.getByText('セッション確認用の合成問題 B', { exact: true })).toBeVisible()
    const finished = page.waitForResponse(response => new URL(response.url()).pathname === '/api/v1/questions/991001/answer')
    fixture.releaseAnswer()
    await (await finished).finished()
    await page.evaluate(() => new Promise<void>(resolve => requestAnimationFrame(() => requestAnimationFrame(() => resolve()))))
    await expect(page.getByRole('heading', { name: '解答解説', exact: true })).toHaveCount(0)
    await expect(page.getByRole('radio').first()).not.toBeChecked()
    await expect(page.getByRole('button', { name: '回答する', exact: true })).toBeDisabled()
  } catch (error) {
    await testInfo.attach('synthetic-session-requests', { body: fixture.diagnostics(), contentType: 'application/json' })
    throw error
  } finally {
    fixture.releaseAnswer()
    await other?.close()
  }
})

test('anonymous 401 responses do not cause a session-generation refetch loop', async ({ page, context }) => {
  let questionRequests = 0
  await context.route('**/api/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (path === '/api/auth/get-session') {
      return route.fulfill({ status: 200, contentType: 'application/json', body: 'null' })
    }
    if (path === '/api/v1/questions/next') questionRequests += 1
    return route.fulfill({ status: 401, contentType: 'application/json', body: JSON.stringify({ error: { code: 'unauthorized', message: 'ログインが必要です' } }) })
  })
  await page.goto('/practice/1/1')
  await expect(page.getByRole('heading', { name: '問題を表示できません', exact: true })).toBeVisible()
  await page.waitForLoadState('networkidle')
  expect(questionRequests).toBe(1)
  await page.getByRole('button', { name: '再読み込み', exact: true }).click()
  await expect(page.getByRole('heading', { name: '問題を表示できません', exact: true })).toBeVisible()
  await page.waitForLoadState('networkidle')
  expect(questionRequests).toBe(2)
})

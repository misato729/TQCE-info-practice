import { test, expect, type Page } from '@playwright/test'
import { EXAM_CONFIG } from '../app/utils/examConfig.ts'

type Access = 'free' | 'premium' | 'verification' | 'admin'
type ApiCall = { method: string, path: string }
const unhandledByPage = new WeakMap<Page, ApiCall[]>()
test.afterEach(({ page }) => { expect(unhandledByPage.get(page) ?? []).toEqual([]) })

// Only browser responses are synthesized here. The separate PostgreSQL/API
// suite verifies real authentication, authorization, persistence and grading.
async function syntheticApi(page: Page, access: Access, initiallySignedIn = true, options: { failMemberAfter?: number } = {}) {
  const calls: ApiCall[] = []
  const unhandled: ApiCall[] = []
  unhandledByPage.set(page, unhandled)
  let signedIn = initiallySignedIn
  const timestamp = '2026-01-01T00:00:00.000Z'
  const token = 'synthetic-request-budget-session-token'
  const member = {
    id: 910001, name: '通信回数確認用の合成会員', email: 'request-budget@example.test',
    role: access === 'admin' ? 'admin' : 'user', paid_content_access: access !== 'free', favorite_questions: [],
    membership: { status: access === 'premium' ? 'active' : 'free', purchased_at: access === 'premium' ? timestamp : null, expires_at: null },
    verification_access: access === 'verification' ? { expires_at: '2099-01-01T00:00:00.000Z' } : null,
    created_at: timestamp,
  }
  const nativeUser = { ...member, id: String(member.id), emailVerified: false, createdAt: timestamp, updatedAt: timestamp }
  let question = {
    id: 910101, exam_number: 1, question_number: 1,
    major_category_code: EXAM_CONFIG.categories.minor[0]!.major_category_value,
    category_code: EXAM_CONFIG.categories.minor[0]!.value,
    publication_status: 'draft', content_blocks: [{ type: 'text', text: '通信確認用の合成問題' }],
    explanation_blocks: [{ type: 'text', text: '合成の解説' }], source_text: '合成出典 | https://example.test/source',
    choices: EXAM_CONFIG.exam.choice_labels.map((choice_label, index) => ({
      id: 910201 + index, choice_label, display_order: index + 1, is_correct: index === 0,
      content_blocks: [{ type: 'text', text: `合成選択肢 ${choice_label}` }],
    })),
    created_at: timestamp, updated_at: timestamp,
  }
  const practiceQuestion = (exam: number, number: number) => {
    const id = 920000 + exam * 100 + number
    return {
      id, exam_number: exam, question_number: number,
      major_category_code: question.major_category_code, category_code: question.category_code,
      content_blocks: [{ type: 'text', text: `条件演習用の合成問題 ${exam}-${number}` }],
      choices: question.choices.map(({ is_correct: _answer, ...choice }, index) => ({ ...choice, id: id * 10 + index + 1 })),
      is_favorite: false,
    }
  }
  await page.route(url => /^\/api\/(?:v1|auth)(?:\/|$)/.test(url.pathname), async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname
    calls.push({ method: request.method(), path })
    const respond = (body: unknown, status = 200) => route.fulfill({ status, json: body })
    if (path === '/api/auth/get-session' && request.method() === 'GET') return respond(signedIn ? {
      user: nativeUser,
      session: { id: 'synthetic-request-budget-session', userId: nativeUser.id, token, createdAt: timestamp, updatedAt: timestamp, expiresAt: '2099-01-01T00:00:00.000Z' },
    } : null)
    if (request.method() === 'POST' && (path === '/api/auth/sign-in/email' || path === '/api/auth/sign-up/email')) {
      signedIn = true
      return respond({ user: nativeUser, token, redirect: false })
    }
    if (path === '/api/v1/me' && request.method() === 'GET') {
      if (options.failMemberAfter !== undefined && calls.filter(call => call.path === path).length > options.failMemberAfter) {
        return respond({ error: { code: 'service_unavailable', message: 'Synthetic unavailable profile' } }, 503)
      }
      return signedIn ? respond({ data: member }) : respond({ error: { code: 'unauthorized' } }, 401)
    }
    if (request.method() === 'GET' && (path === '/api/v1/favorites' || path === '/api/v1/answer_histories')) {
      return respond({ data: [], meta: { current_page: 1, per_page: 20, total_count: 0, total_pages: 0 } })
    }
    if (path === '/api/v1/questions/next' && request.method() === 'GET') {
      const query = new URL(request.url()).searchParams
      return respond({ data: practiceQuestion(Number(query.get('exam_number')), Number(query.get('after_question_number')) + 1) })
    }
    const answer = path.match(/^\/api\/v1\/questions\/(\d+)\/answer$/)
    if (answer && request.method() === 'POST') {
      const id = Number(answer[1])
      const position = id - 920000
      const current = practiceQuestion(Math.floor(position / 100), position % 100)
      const selected = request.postDataJSON().selected_choice_id
      return respond({ data: {
        question_id: id, selected_choice_id: selected, is_correct: selected === current.choices[0]!.id,
        correct_choice: current.choices[0], explanation_blocks: [{ type: 'text', text: '合成の解説' }],
        source_text: null, answer_history_id: null,
      } })
    }
    if (path === `/api/v1/admin/questions/${question.id}` && ['GET', 'PATCH'].includes(request.method())) {
      if (request.method() === 'PATCH') question = { ...question, ...request.postDataJSON().question }
      return respond({ data: question })
    }
    unhandled.push({ method: request.method(), path })
    return respond({}, 404)
  })
  return {
    count: (path: string, method = 'GET') => calls.filter(call => call.path === path && call.method === method).length,
    answerCount: () => calls.filter(call => call.method === 'POST' && /^\/api\/v1\/questions\/\d+\/answer$/.test(call.path)).length,
    assertNoCatalogRequests() {
      expect(calls.filter(call => ['/api/v1/health', '/api/v1/exams'].includes(call.path) || call.path.startsWith('/api/v1/questions'))).toEqual([])
    },
  }
}

async function openMenuLink(page: Page, name: string) {
  await page.getByRole('button', { name: 'メニューを開く', exact: true }).click()
  await page.getByRole('link', { name, exact: true }).click()
}

for (const action of ['login', 'signup'] as const) {
  test(`${action} hydrates the member once and static navigation adds no business API calls`, async ({ page }) => {
    const api = await syntheticApi(page, 'free', false)
    await page.goto(`/${action}`)
    await expect(page.locator('.api-status')).toHaveClass(/\bconnected\b/)
    await page.waitForLoadState('networkidle')
    const before = api.count('/api/v1/me')
    if (action === 'signup') await page.getByLabel('ユーザー名', { exact: true }).fill('合成会員')
    await page.getByLabel('メールアドレス', { exact: true }).fill('request-budget@example.test')
    await page.getByLabel('パスワード', { exact: true }).fill('Synthetic-request-budget-password')
    if (action === 'signup') await page.getByLabel('確認用パスワード', { exact: true }).fill('Synthetic-request-budget-password')
    await page.getByRole('button', { name: action === 'login' ? 'ログイン' : '登録する', exact: true }).click()
    await expect(page).toHaveURL('/')
    await expect(page.locator('.site-header .account-link')).toHaveCount(1)
    await page.waitForLoadState('networkidle')
    expect(api.count(`/api/auth/${action === 'login' ? 'sign-in' : 'sign-up'}/email`, 'POST')).toBe(1)
    expect(api.count('/api/v1/me') - before).toBe(1)
    const freeSets = EXAM_CONFIG.payments.enabled ? EXAM_CONFIG.payments.free_exam_count : EXAM_CONFIG.exam.set_count
    await expect(page.locator('.exam-row')).toHaveCount(freeSets)

    await openMenuLink(page, '試験概要')
    await expect(page).toHaveURL('/exam-overview')
    await page.locator('.footer-links').getByRole('link', { name: '利用規約', exact: true }).click()
    await expect(page).toHaveURL('/terms')
    await page.waitForLoadState('networkidle')
    expect(api.count('/api/v1/me') - before).toBe(1)
    api.assertNoCatalogRequests()
  })
}

for (const access of ['free', 'premium'] as const) {
  test(`${access} list pages share membership and fetch each permitted list once`, async ({ page }) => {
    const api = await syntheticApi(page, access)
    await page.goto('/favorites')
    const allowed = !EXAM_CONFIG.payments.enabled || access === 'premium'
    await expect(page.getByRole('heading', { name: allowed ? 'お気に入りはまだありません' : 'プレミアム会員向けの機能です', exact: true })).toBeVisible()
    await page.waitForLoadState('networkidle')
    expect(api.count('/api/v1/me')).toBe(1)
    expect(api.count('/api/v1/favorites')).toBe(allowed ? 1 : 0)
    await openMenuLink(page, '解答履歴')
    await expect(page.getByRole('heading', { name: 'まだ解答履歴がありません', exact: true })).toBeVisible()
    await page.waitForLoadState('networkidle')
    expect(api.count('/api/v1/answer_histories')).toBe(1)
    expect(api.count('/api/v1/me')).toBe(1)
    api.assertNoCatalogRequests()
  })
}

test('admin edit saves through one PATCH without refetching the same detail', async ({ page }) => {
  const api = await syntheticApi(page, 'admin')
  const path = '/api/v1/admin/questions/910101'
  await page.goto('/admin/questions/910101/edit')
  await expect(page.getByRole('heading', { name: '問題を編集', exact: true })).toBeVisible()
  await expect(page.getByLabel('問番号', { exact: true })).toHaveValue('1')
  await page.getByLabel('問番号', { exact: true }).fill('2')
  await page.getByRole('button', { name: '編集内容を保存', exact: true }).click()
  await expect(page.getByText('編集内容を保存しました。', { exact: true })).toBeVisible()
  await expect(page.getByLabel('問番号', { exact: true })).toHaveValue('2')
  await page.waitForLoadState('networkidle')
  expect(api.count(path)).toBe(1)
  expect(api.count(path, 'PATCH')).toBe(1)
  expect(api.count('/api/v1/me')).toBe(1)
})

for (const access of ['premium', 'verification', 'admin'] as const) {
  test(`${access} completion confirms fresh membership and distinguishes non-purchase access`, async ({ page }, testInfo) => {
    const api = await syntheticApi(page, access)
    await page.goto('/premium/complete')
    const title = access === 'premium' ? 'プレミアム会員になりました'
      : access === 'admin' ? '管理者権限で全問題を利用できます' : '検証用資格で全問題を利用できます'
    await expect(page.getByRole('heading', { name: title, exact: true })).toBeVisible()
    const purchase = page.getByText('500円の買い切り購入が確認できました。模擬試験6以降を利用できます。', { exact: true })
    await expect(purchase).toHaveCount(access === 'premium' ? 1 : 0)
    await page.waitForLoadState('networkidle')
    // One common authentication lookup plus one fresh payment confirmation.
    expect(api.count('/api/v1/me')).toBe(2)
    await page.screenshot({ path: testInfo.outputPath(`completion-${access}.png`), animations: 'disabled' })
  })
}

test('failed fresh payment checks cannot confirm a previously cached purchase', async ({ page }) => {
  const api = await syntheticApi(page, 'premium', true, { failMemberAfter: 1 })
  await page.goto('/premium/complete')
  await expect.poll(() => api.count('/api/v1/me')).toBeGreaterThanOrEqual(2)
  await expect(page.getByRole('heading', { name: 'プレミアム会員になりました', exact: true })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: '決済の反映を待っています', exact: true })).toBeVisible({ timeout: 20000 })
  expect(api.count('/api/v1/me')).toBe(9) // Authentication plus the bounded eight confirmation attempts.
  await expect(page.getByRole('heading', { name: 'プレミアム会員になりました', exact: true })).toHaveCount(0)
})

test('known-invalid practice positions and their retries never request a question', async ({ page }) => {
  const api = await syntheticApi(page, 'free', false)
  for (const path of ['/practice/0/1', '/practice/1/0', `/practice/${EXAM_CONFIG.exam.set_count + 1}/1`]) {
    await page.goto(path)
    await expect(page.getByRole('heading', { name: '問題を表示できません', exact: true })).toBeVisible()
    await page.getByRole('button', { name: '再読み込み', exact: true }).click()
    await expect(page.getByRole('heading', { name: '問題を表示できません', exact: true })).toBeVisible()
    await page.waitForLoadState('networkidle')
    api.assertNoCatalogRequests()
  }
})

for (const order of ['sequential', 'random'] as const) {
  test(`${order} selected practice keeps its sequence and uses one fetch and one answer per position`, async ({ page }) => {
    const api = await syntheticApi(page, 'free', false)
    await page.goto('/')
    await expect(page.locator('.api-status')).toHaveClass(/\bconnected\b/)
    await page.getByRole('tab', { name: '条件を指定', exact: true }).click()
    for (const group of ['exam', 'question']) {
      const all = page.locator('.condition-fieldset').nth(group === 'exam' ? 0 : 1).locator('.all-selector input')
      await all.check()
      await all.uncheck()
      for (const value of [1, 2]) await page.locator(`input[name="${group}-numbers"][value="${value}"]`).check()
    }
    api.assertNoCatalogRequests()
    await page.getByRole('button', { name: order === 'random' ? 'ランダムに始める' : '問題番号順に始める', exact: true }).click()
    await expect(page.locator('.practice-head h1')).toBeVisible()
    const firstUrl = new URL(page.url())
    const seed = firstUrl.searchParams.get('seed')
    if (order === 'random') {
      expect(seed).toMatch(/^\d+$/)
      await page.reload()
      await expect(page.locator('.practice-head h1')).toBeVisible()
      expect(page.url()).toBe(firstUrl.href)
    }
    const visited: string[] = []
    for (let index = 0; index < 4; index += 1) {
      const url = new URL(page.url())
      const position = url.pathname.replace('/practice/', '')
      visited.push(position)
      expect(url.searchParams.get('exams')).toBe('1,2')
      expect(url.searchParams.get('questions')).toBe('1,2')
      expect(url.searchParams.get('seed')).toBe(seed)
      await expect(page.getByText(`条件演習用の合成問題 ${position.replace('/', '-')}`, { exact: true })).toBeVisible()
      await page.locator('.choices label').first().click()
      await page.getByRole('button', { name: '回答する', exact: true }).click()
      await expect(page.getByText('正解です', { exact: true })).toBeVisible()
      expect(api.answerCount()).toBe(index + 1)
      expect(api.count('/api/v1/questions/next')).toBe(index + 1 + (order === 'random' ? 1 : 0))
      await page.getByRole('button', { name: '次の問題', exact: true }).click()
      if (index < 3) await expect(page).not.toHaveURL(url.href)
    }
    await expect(page.locator('.completed-message')).toBeVisible()
    expect([...visited].sort()).toEqual(['1/1', '1/2', '2/1', '2/2'])
    if (order === 'sequential') expect(visited).toEqual(['1/1', '1/2', '2/1', '2/2'])
    expect(api.count('/api/v1/questions/next')).toBe(order === 'random' ? 5 : 4)
    expect(api.count('/api/v1/exams')).toBe(0)
    expect(api.count('/api/v1/health')).toBe(0)
  })
}

import { test, expect, type Page } from '@playwright/test'
import { loadE2EFixture } from '../scripts/e2e-fixture.mjs'

const { question: fixtureQuestion } = loadE2EFixture()
const question = { ...fixtureQuestion, id: 991001,
  choices: fixtureQuestion.choices.map((choice: any, index: number) => ({ ...choice, id: 992001 + index })) }
const timestamp = '2026-01-01T00:00:00.000Z'
const richQuestion = {
  ...question,
  content_blocks: [
    { type: 'text', text: '次の資料と表を読み、記述として最も適切なものを選びなさい。' },
    { type: 'quote', text: 'これは文字サイズと文章の折り返しを確認するための合成資料です。'.repeat(3), source: '表示確認用の合成資料' },
    { type: 'fill_in_quote', text: '資料を比較するときは、{{①}}と{{②}}を確認する。' },
    { type: 'table', headers: ['資料', '対象', '確認事項'], rows: [['A', '高等学校', '文章と図表の対応を確認する。'], ['B', '中学校', '資料の対象と条件を比較する。']] },
    { type: 'code', title: '表示確認用プログラム', code: 'values = [2, 4, 6]\nfor value in values:\n    print(value)' },
  ],
  created_at: timestamp,
  updated_at: timestamp,
}

async function mockApi(page: Page, admin = false) {
  const mutations: string[] = []
  const member = {
    id: 91001, name: '文字サイズ確認用の合成会員', email: 'typography@example.test', role: 'admin',
    paid_content_access: true, favorite_questions: [], created_at: timestamp,
    membership: { status: 'active', purchased_at: timestamp, expires_at: null }, verification_access: null,
  }
  const questionSummary = { id: question.id, exam_number: question.exam_number, question_number: question.question_number,
    body_excerpt: '資料と表を比較するための合成問題です。'.repeat(3), major_category_code: question.major_category_code, category_code: question.category_code }
  const meta = { current_page: 1, per_page: 20, total_count: 1, total_pages: 1 }
  await page.route(url => url.pathname.startsWith('/api/'), async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname
    const respond = (json: unknown, status = 200) => route.fulfill({ status, json })
    if (!['GET', 'HEAD', 'OPTIONS'].includes(request.method())) {
      mutations.push(path)
      return respond({}, 403)
    }
    if (path === '/api/v1/me') return admin ? respond({ data: member }) : respond({ error: { code: 'unauthorized' } }, 401)
    if (path === '/api/auth/get-session') return respond(admin ? {
      user: { ...member, id: String(member.id), emailVerified: false, createdAt: timestamp, updatedAt: timestamp },
      session: { id: 'synthetic-typography-session', token: 'synthetic-typography-token', userId: String(member.id), expiresAt: '2099-01-01T00:00:00.000Z' },
    } : null)
    if (path === '/api/v1/health') return respond({ status: 'ok' })
    if (path === '/api/v1/payments/config') return respond({ data: {
      enabled: false, amount: 500, currency: 'jpy', purchase_type: 'one_time', free_exam_max: 5,
      seller: { name: '表示確認用運営者', representative: '表示確認用運営者', email: 'layout@example.test', address: '', phone: '', contact_disclosure_mode: 'on_request', contact_disclosure_ready: true },
    } })
    if (path === '/api/v1/questions/next' || path === `/api/v1/questions/${question.id}`) {
      const { explanation_blocks: _, source_text: __, publication_status: ___, ...publicQuestion } = richQuestion
      return respond({ data: { ...publicQuestion, choices: question.choices.map(({ is_correct: _, ...choice }: any) => choice) } })
    }
    if (path === '/api/v1/answer_histories') return respond({ data: [{ id: 1, locked: false, question: questionSummary,
      selected_choice: { id: question.choices[0]!.id, choice_label: question.choices[0]!.choice_label, body_excerpt: '表示確認用の選択肢' }, is_correct: false, answered_at: timestamp }], meta })
    if (path === '/api/v1/favorites') return respond({ data: [{ id: 1, locked: false, question: questionSummary, created_at: timestamp }], meta })
    if (path === '/api/v1/admin/questions') return respond({ data: [{ ...questionSummary, publication_status: 'published', updated_at: timestamp }], meta })
    if (path === `/api/v1/admin/questions/${question.id}`) return respond({ data: richQuestion })
    return respond({}, 404)
  })
  return mutations
}

async function assertLayout(page: Page, mobile: boolean) {
  await expect(page.locator('html')).toHaveCSS('font-size', '14.4px')
  const measurements = await page.evaluate(() => {
    const visible = (element: Element) => {
      const box = element.getBoundingClientRect()
      return element.getClientRects().length && getComputedStyle(element).visibility !== 'hidden'
        && box.right > 0 && box.left < window.innerWidth
    }
    const controls = [...document.querySelectorAll('button, input:not([type="checkbox"]):not([type="radio"]), select, textarea')].filter(visible)
    return {
      overflow: document.documentElement.scrollWidth > window.innerWidth + 1,
      clippedControls: controls.filter(element => {
        const box = element.getBoundingClientRect()
        return box.left < -1 || box.right > window.innerWidth + 1 || (element.tagName === 'BUTTON' && element.scrollWidth > element.clientWidth + 1)
      }).map(element => element.tagName + '.' + element.className),
      inputSizes: controls.filter(element => element.matches('input, select, textarea')).map(element => ({
        id: element.id || element.className, size: parseFloat(getComputedStyle(element).fontSize),
      })),
    }
  })
  expect(measurements.overflow).toBe(false)
  expect(measurements.clippedControls, page.url()).toEqual([])
  if (mobile) for (const input of measurements.inputSizes) expect(input.size, `${page.url()} ${input.id}`).toBeGreaterThanOrEqual(16)
}

test('public screens share the smaller typography without clipped navigation or forms', async ({ page }, testInfo) => {
  test.setTimeout(120000)
  const mutations = await mockApi(page)
  const mobile = testInfo.project.name.includes('mobile')
  for (const path of ['/', '/exam-overview', '/login', '/signup', '/premium', '/privacy-policy', '/terms', '/commercial-disclosure', '/admin/login']) {
    await page.goto(path)
    await expect(page.locator('h1').first()).toBeVisible()
    await assertLayout(page, mobile)
    if (path === '/') {
      await expect(page.locator('.overview-copy h1')).toHaveCSS('font-size', '27px')
      await expect(page.locator('.exam-card strong').first()).toHaveCSS('font-size', '18px')
      await page.screenshot({ path: testInfo.outputPath('home-overview.png'), scale: 'css' })
      await page.locator('#usage-guide').scrollIntoViewIfNeeded()
      await page.locator('#usage-guide').screenshot({ path: testInfo.outputPath('home-usage.png'), scale: 'css' })
    }
    if (path === '/signup') await page.screenshot({ path: testInfo.outputPath('signup.png'), fullPage: true, scale: 'css' })
  }
  expect(mutations).toEqual([])
})

test('practice, member and management screens keep readable blocks and usable controls', async ({ page }, testInfo) => {
  test.setTimeout(120000)
  const mutations = await mockApi(page, true)
  const mobile = testInfo.project.name.includes('mobile')
  const errors: string[] = []
  page.on('pageerror', error => errors.push(error.message))
  for (const path of [`/practice/${question.exam_number}/${question.question_number}`, '/history', '/favorites', '/account', '/premium/complete', '/admin/questions', '/admin/questions/new', `/admin/questions/${question.id}/edit`]) {
    await page.goto(path)
    await expect(page.locator('h1').first()).toBeVisible()
    await expect(page.locator('.api-status')).toHaveClass(/connected/)
    await assertLayout(page, mobile)
    if (path.startsWith('/practice/')) {
      await expect(page.locator('.question-text')).toHaveCSS('font-size', mobile ? '16.2px' : '17.1px')
      await expect(page.locator('.content-quote p').first()).toHaveCSS('font-size', '16.2px')
      await expect(page.locator('.content-table').first()).toHaveCSS('font-size', '14.4px')
      await expect(page.getByRole('radio')).toHaveCount(question.choices.length)
      await page.screenshot({ path: testInfo.outputPath('practice-blocks.png'), fullPage: true, scale: 'css' })
    }
    if (path.endsWith('/edit')) {
      await page.getByRole('button', { name: 'プレビュー', exact: true }).click()
      await expect(page.locator('.question-preview')).toBeVisible()
      await expect(page.locator('.preview-question')).toHaveCSS('font-size', mobile ? '14.4px' : '16.2px')
      await assertLayout(page, mobile)
      await page.locator('.question-preview').screenshot({ path: testInfo.outputPath('admin-preview.png'), scale: 'css' })
    }
  }
  expect(errors).toEqual([])
  expect(mutations).toEqual([])
})

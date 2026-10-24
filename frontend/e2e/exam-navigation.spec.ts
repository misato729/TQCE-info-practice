import { test, expect } from '@playwright/test'
import { EXAM_CONFIG } from '../app/utils/examConfig.ts'

const freeCount = EXAM_CONFIG.payments.enabled
  ? EXAM_CONFIG.payments.free_exam_count
  : EXAM_CONFIG.exam.set_count

for (const membership of ['anonymous', 'free', 'premium'] as const) {
  test(`${membership} exam navigation uses the static membership catalog without question API requests`, async ({ page }, testInfo) => {
    const requests: string[] = []
    const hydrationErrors: string[] = []
    const clientErrors: string[] = []
    const consoleErrors: string[] = []
    const failedScripts: string[] = []
    let signedIn = membership !== 'anonymous'
    const member = {
      id: membership === 'premium' ? 901 : 902,
      name: 'サイドバー確認用の合成会員', email: `sidebar-${membership}@example.test`, role: 'user',
      paid_content_access: membership === 'premium', favorite_questions: [],
      membership: { status: membership === 'premium' ? 'active' : 'free', purchased_at: null, expires_at: null },
      verification_access: null,
    }
    page.on('console', message => {
      if (/hydration.*mismatch/i.test(message.text())) hydrationErrors.push(message.text())
      if (message.type() === 'error') consoleErrors.push(message.text())
    })
    page.on('pageerror', error => clientErrors.push(error.message))
    page.on('requestfailed', request => {
      if (request.resourceType() === 'script') failedScripts.push(`${new URL(request.url()).pathname}: ${request.failure()?.errorText}`)
    })
    // These are only synthetic browser responses. The common membership lookup
    // is shared with the header; listing/opening sets must not fetch questions.
    await page.route(url => url.pathname.startsWith('/api/'), async route => {
      const path = new URL(route.request().url()).pathname
      requests.push(path)
      const respond = (body: unknown, status = 200) => route.fulfill({ status, contentType: 'application/json', body: JSON.stringify(body) })
      if (path === '/api/v1/me') {
        return signedIn
          ? respond({ data: member })
          : respond({ error: { code: 'unauthorized', message: 'ログインしてください' } }, 401)
      }
      if (path === '/api/auth/get-session') {
        return respond(signedIn ? {
          user: { ...member, id: String(member.id), emailVerified: false, createdAt: '2026-01-01T00:00:00.000Z', updatedAt: '2026-01-01T00:00:00.000Z' },
          session: { id: `synthetic-sidebar-${membership}`, userId: String(member.id), token: `synthetic-sidebar-token-${membership}`, expiresAt: '2099-01-01T00:00:00.000Z' },
        } : null)
      }
      if (path === '/api/auth/sign-out') {
        signedIn = false
        return respond({ success: true })
      }
      return respond({}, 404)
    })

    await page.goto('/')
    const status = page.locator('.api-status')
    try {
      await expect(status).toHaveClass(/\bconnected\b/)
    } catch (error) {
      const startup = await page.evaluate(() => {
        const root = document.querySelector('#__nuxt') as any
        const nuxt = root?.__vue_app__?.config?.globalProperties?.$nuxt
        return { mounted: !!root?.__vue_app__, hydrating: nuxt?.isHydrating, readyState: document.readyState }
      })
      await testInfo.attach('client-startup.json', {
        body: JSON.stringify({ requests, clientErrors, hydrationErrors, consoleErrors, failedScripts, startup }),
        contentType: 'application/json',
      })
      throw error
    }
    await expect(status).toContainText('API接続：正常')
    await expect(status.locator('.status-dot')).toHaveCSS('background-color', 'rgb(25, 135, 84)')
    await expect.poll(() => requests.includes('/api/auth/get-session')).toBe(true)
    await expect(page.locator(membership === 'anonymous' ? '.site-header .login-link' : '.site-header .account-link')).toHaveCount(1)

    const sidebar = page.locator('.exam-sidebar')
    const mobile = testInfo.project.name.includes('mobile')
    const mobileToggle = sidebar.locator('.mobile-exam-toggle')
    if (mobile) await mobileToggle.click()
    const rows = sidebar.locator('.exam-row')
    const visibleCount = membership === 'premium' ? EXAM_CONFIG.exam.set_count : freeCount
    await expect(rows).toHaveCount(visibleCount)
    await expect(sidebar.locator('.sidebar-loading')).toHaveCount(0)
    await expect(rows.last().locator('.exam-link')).toHaveAttribute('href', `/practice/${visibleCount}/1`)
    const before = await Promise.all([rows.nth(0).boundingBox(), rows.nth(1).boundingBox()])
    expect(before[0]!.width).toBeGreaterThan(mobile ? 140 : 220)
    const requestsBefore = requests.length

    await rows.nth(0).getByRole('button').click()
    await expect(sidebar.locator('#exam-1-questions a')).toHaveCount(EXAM_CONFIG.exam.questions_per_exam)
    await expect(sidebar.locator('#exam-1-questions a').last()).toBeVisible()
    const after = await Promise.all([rows.nth(0).boundingBox(), rows.nth(1).boundingBox()])
    expect(after[0]).toEqual(before[0])
    if (mobile) expect(after[1]).toEqual(before[1])
    await rows.nth(0).getByRole('button').click()
    await expect(sidebar.locator('#exam-1-questions')).toHaveCount(0)
    expect(requests.length).toBe(requestsBefore)
    // A static page can need the common /me lookup once; no sidebar lookup is added.
    const membershipRequests = requests.filter(path => path === '/api/v1/me').length
    expect(membershipRequests).toBeLessThanOrEqual(1)
    if (membership !== 'anonymous') expect(membershipRequests).toBe(1)

    if (mobile) {
      await page.keyboard.press('Escape')
      await expect(mobileToggle).toHaveAttribute('aria-expanded', 'false')
      await mobileToggle.click()
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`exam-navigation-${membership}.png`), animations: 'disabled' })

    if (membership === 'premium') {
      const firstPaidExam = freeCount + 1
      if (freeCount < EXAM_CONFIG.exam.set_count) {
        const beforeOpeningPaid = requests.length
        await rows.nth(freeCount).getByRole('button').click()
        await expect(sidebar.locator(`#exam-${firstPaidExam}-questions a`)).toHaveCount(EXAM_CONFIG.exam.questions_per_exam)
        expect(requests.length).toBe(beforeOpeningPaid)
      }
      await page.locator('.menu-button').click()
      await page.getByRole('button', { name: 'ログアウト', exact: true }).click()
      await expect(page.locator('.site-header .login-link')).toHaveCount(1)
      await expect(rows).toHaveCount(freeCount)
      await expect(rows.last().locator('.exam-link')).toHaveAttribute('href', `/practice/${freeCount}/1`)
      await expect(sidebar.locator(`#exam-${firstPaidExam}-questions`)).toHaveCount(0)
      expect(requests).toContain('/api/auth/sign-out')
      await page.screenshot({ path: testInfo.outputPath('exam-navigation-after-logout.png'), animations: 'disabled' })
    }

    expect(requests.filter(path => path === '/api/v1/exams' || path.startsWith('/api/v1/questions'))).toEqual([])
    expect(hydrationErrors).toEqual([])
    expect(clientErrors).toEqual([])
  })
}

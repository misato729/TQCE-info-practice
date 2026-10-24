import { test, expect } from '@playwright/test'
import { EXAM_CONFIG } from '../app/utils/examConfig.ts'

test('the fixed exam catalog keeps its width and opens questions without API requests', async ({ page }, testInfo) => {
  const requests: string[] = []
  const hydrationErrors: string[] = []
  page.on('console', message => {
    if (/hydration.*mismatch/i.test(message.text())) hydrationErrors.push(message.text())
  })
  // Anonymous sessions still prove that the API is reachable. No DB or real
  // account is needed to verify prerendered navigation and status hydration.
  await page.route('**/api/**', async route => {
    const path = new URL(route.request().url()).pathname
    requests.push(path)
    if (path === '/api/v1/me') {
      await route.fulfill({ status: 401, contentType: 'application/json', body: JSON.stringify({ error: { code: 'unauthorized', message: 'ログインしてください' } }) })
    } else if (path === '/api/auth/get-session') {
      await route.fulfill({ status: 200, contentType: 'application/json', body: 'null' })
    } else {
      await route.fulfill({ status: 404, contentType: 'application/json', body: '{}' })
    }
  })

  await page.goto('/')
  const status = page.locator('.api-status')
  await expect(status).toHaveClass(/\bconnected\b/)
  await expect(status).toContainText('API接続：正常')
  await expect(status.locator('.status-dot')).toHaveCSS('background-color', 'rgb(25, 135, 84)')
  await expect.poll(() => requests.includes('/api/auth/get-session')).toBe(true)
  expect(hydrationErrors).toEqual([])

  const sidebar = page.locator('.exam-sidebar')
  const mobile = testInfo.project.name.includes('mobile')
  const mobileToggle = sidebar.locator('.mobile-exam-toggle')
  if (mobile) await mobileToggle.click()
  const rows = sidebar.locator('.exam-row')
  await expect(rows).toHaveCount(EXAM_CONFIG.exam.set_count)
  await expect(sidebar.locator('.sidebar-loading')).toHaveCount(0)
  await expect(rows.last().locator('.exam-link')).toHaveAttribute('href', `/practice/${EXAM_CONFIG.exam.set_count}/1`)
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
  expect(requests).not.toContain('/api/v1/exams')
  // SSR may already have resolved the session; static pages need one lookup.
  expect(requests.filter(path => path === '/api/v1/me').length).toBeLessThanOrEqual(1)

  if (mobile) {
    await page.keyboard.press('Escape')
    await expect(mobileToggle).toHaveAttribute('aria-expanded', 'false')
    await mobileToggle.click()
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('exam-navigation.png'), animations: 'disabled' })
})

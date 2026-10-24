import { test, expect } from '@playwright/test'

test('admin login keeps leading icons clear of typed text on desktop and mobile', async ({ page }) => {
  const mutations: string[] = []
  // Geometry checks use an anonymous mocked session, never a real account.
  await page.route('**/api/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname
    if (!['GET', 'HEAD', 'OPTIONS'].includes(request.method())) mutations.push(path)
    if (path === '/api/v1/me') {
      return route.fulfill({ status: 401, json: { error: { code: 'unauthorized', message: 'ログインが必要です' } } })
    }
    if (path === '/api/auth/get-session') return route.fulfill({ json: null })
    return route.fulfill({ status: 404, json: {} })
  })

  await page.goto('/admin/login')
  await expect(page.getByRole('heading', { name: '管理画面ログイン', exact: true })).toBeVisible()

  for (const field of [
    { label: 'メールアドレス', value: 'layout@example.test' },
    { label: 'パスワード', value: 'Synthetic-layout-password' },
  ]) {
    const input = page.getByLabel(field.label, { exact: true })
    await input.fill(field.value)
    await expect(input).toHaveValue(field.value)
    const dimensions = await input.evaluate(element => {
      const input = element as HTMLInputElement
      const bounds = input.getBoundingClientRect()
      const style = getComputedStyle(input)
      const icon = input.closest('.admin-login-input')?.querySelector('[data-slot="leadingIcon"]')
      const iconBounds = icon?.getBoundingClientRect()
      return {
        textLeft: bounds.left + parseFloat(style.borderLeftWidth) + parseFloat(style.paddingLeft),
        inputLeft: bounds.left,
        inputRight: bounds.right,
        iconRight: iconBounds?.right,
        iconWidth: iconBounds?.width,
        viewport: window.innerWidth,
      }
    })
    expect(dimensions.iconWidth).toBeGreaterThan(0)
    expect(dimensions.textLeft).toBeGreaterThanOrEqual(dimensions.iconRight! + 6)
    expect(dimensions.inputLeft).toBeGreaterThanOrEqual(0)
    expect(dimensions.inputRight).toBeLessThanOrEqual(dimensions.viewport)
  }

  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  expect(mutations).toEqual([])
})

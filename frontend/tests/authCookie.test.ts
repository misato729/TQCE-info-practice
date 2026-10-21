import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'
import { runInNewContext } from 'node:vm'

const source = readFileSync(new URL('../app/composables/useAuth.ts', import.meta.url), 'utf8')
const cookieSource = source.match(/useCookie<string \| null>\('tqce-access-token', \{[\s\S]*?\n  \}\)/)?.[0]
assert.ok(cookieSource)

const cookieOptions = (production: boolean) => {
  const expression = cookieSource
    .replace('useCookie<string | null>', 'useCookie')
    .replace('import.meta.env?.PROD', String(production))
  return runInNewContext(expression, {
    useCookie: (name: string, options: Record<string, unknown>) => ({ name, ...options }),
  }) as { name: string, maxAge: number, sameSite: string, secure: boolean, domain?: string, default: () => null }
}

test('production authentication cookie is secure, same-site and host-only', () => {
  const options = cookieOptions(true)
  assert.equal(options.name, 'tqce-access-token')
  assert.equal(options.secure, true)
  assert.equal(options.sameSite, 'lax')
  assert.equal(options.maxAge, 60 * 60 * 24)
  assert.equal(options.domain, undefined)
  assert.equal(options.default(), null)
})

test('local development keeps the same lifetime and scope without requiring HTTPS', () => {
  const options = cookieOptions(false)
  assert.equal(options.secure, false)
  assert.equal(options.sameSite, 'lax')
  assert.equal(options.maxAge, 60 * 60 * 24)
  assert.equal(options.domain, undefined)
})

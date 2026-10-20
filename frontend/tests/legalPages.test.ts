import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'

const source = (name: string) => readFileSync(new URL(`../app/pages/${name}.vue`, import.meta.url), 'utf8')

test('legal pages stay accessible without an application login', () => {
  for (const name of ['terms', 'privacy-policy', 'commercial-disclosure']) {
    const page = source(name)
    assert.doesNotMatch(page, /middleware\s*:\s*['"](?:auth|admin)/)
    assert.doesNotMatch(page, /(?:authenticate|ensureCurrentUser|authHeaders)/)
  }
})

test('privacy policy names current hosting, encrypted backup storage and operations monitoring', () => {
  const page = source('privacy-policy')
  assert.match(page, /https:\/\/www\.netlify\.com\/privacy\//)
  assert.doesNotMatch(page, /Vercel|vercel\.com/)
  assert.match(page, /GitHub<\/a>：暗号化したバックアップの非公開保管/)
  assert.match(page, /Sentry<\/a>：運用処理の状態監視および障害通知/)
  assert.match(page, /最終改定日：2026年10月21日/)
})

test('terms disclose temporary request limits without enabling sales', () => {
  const page = source('terms')
  assert.match(page, /操作回数を一時的に制限/)
  assert.match(page, /500円（税込）の買い切り/)
  assert.match(page, /最終改定日：2026年10月21日/)
})

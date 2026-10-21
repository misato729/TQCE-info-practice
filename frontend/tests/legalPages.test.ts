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

test('on-request seller contacts explain how to request disclosure before purchase', () => {
  const page = source('commercial-disclosure')
  assert.match(page, /請求があった場合に遅滞なく開示します。/)
  assert.match(page, /開示の請求方法/)
  assert.match(page, /購入前の請求にも/)
  assert.match(page, /申込みの意思決定に先立って十分な時間的余裕/)
  assert.match(page, /電子メールで遅滞なく開示/)
  assert.match(page, /開示に費用はかかりません/)
  assert.match(page, /isSellerInformationComplete\(seller.value\)/)
  assert.match(page, /最終更新日：2026年10月21日/)
})

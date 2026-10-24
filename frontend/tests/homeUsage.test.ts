import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import test from 'node:test'

const source = readFileSync(new URL('../app/pages/index.vue', import.meta.url), 'utf8')
const section = source.match(/<section id="usage-guide"[\s\S]*?<\/section>/)?.[0]

test('home usage guide keeps its accessible heading and three information items', () => {
  assert.ok(section)
  assert.match(section, /aria-labelledby="usage-guide-title"/)
  assert.match(section, /<h2 id="usage-guide-title"[\s\S]*?利用にあたって/)
  assert.equal(section.match(/<dt>/g)?.length, 3)
  for (const title of ['模擬試験1〜5は無料', '500円の買い切り', '根拠資料も確認']) {
    assert.ok(section.includes(`<dt>${title}</dt>`))
  }
  assert.ok(section.includes('解答履歴の保存にはログインが必要です。お気に入りはプレミアム会員向けです。'))
  assert.ok(section.includes('月額料金や自動更新はありません。'))
  assert.ok(section.includes('各問題の解説と、出題の根拠となる資料を確認できます。'))
})

test('home usage guide retains the premium information link', () => {
  assert.ok(section)
  assert.match(section, /<NuxtLink[^>]*to="\/premium"[\s\S]*?プレミアム会員について[\s\S]*?<\/NuxtLink>/)
})

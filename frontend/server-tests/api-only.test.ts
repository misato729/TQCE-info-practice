import assert from 'node:assert/strict'
import { createServer, type Server } from 'node:http'
import { after, before, test } from 'node:test'
import { createApp, defineEventHandler, toNodeListener } from 'h3'
import { apiOnlyHandler } from '../server/middleware/api-only.ts'

const originalFlag = process.env.NUXT_API_ONLY
let server: Server
let base: string
before(async () => {
  const app = createApp().use(defineEventHandler(apiOnlyHandler)).use(defineEventHandler(() => ({ status: 'allowed' })))
  server = createServer(toNodeListener(app))
  await new Promise<void>(resolve => server.listen(0, '127.0.0.1', resolve))
  base = `http://127.0.0.1:${(server.address() as { port: number }).port}`
})
after(async () => {
  if (originalFlag === undefined) delete process.env.NUXT_API_ONLY
  else process.env.NUXT_API_ONLY = originalFlag
  if (server) await new Promise<void>((resolve, reject) => server.close(error => error ? reject(error) : resolve()))
})

test('API-only mode rejects UI, assets and lookalike paths for every method without reflecting query data', async () => {
  process.env.NUXT_API_ONLY = 'true'
  for (const method of ['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']) {
    for (const path of ['/', '/signup', '/_nuxt/app.js', '/images/logo.svg', '/apix/v1/health', '/api?private=synthetic-private']) {
      const response = await fetch(base + path, { method })
      assert.equal(response.status, 404, `${method} ${path}`)
      assert.equal(response.headers.get('cache-control'), 'no-store')
      assert.equal(response.headers.get('x-content-type-options'), 'nosniff')
      const text = await response.text()
      if (method === 'HEAD') assert.equal(text, '')
      else assert.deepEqual(JSON.parse(text), { error: { code: 'not_found', message: '対象が見つかりません' } })
      assert.equal(text.includes('synthetic-private'), false)
    }
  }
})

test('API-only mode permits API/auth paths and disabled mode preserves local/E2E frontend requests', async () => {
  process.env.NUXT_API_ONLY = 'true'
  for (const path of ['/api/v1/health', '/api/auth/get-session']) {
    const response = await fetch(base + path)
    assert.equal(response.status, 200)
    assert.deepEqual(await response.json(), { status: 'allowed' })
  }
  for (const flag of [undefined, 'false', 'TRUE']) {
    if (flag === undefined) delete process.env.NUXT_API_ONLY
    else process.env.NUXT_API_ONLY = flag
    const response = await fetch(base + '/practice/1/1')
    assert.equal(response.status, 200)
    assert.deepEqual(await response.json(), { status: 'allowed' })
  }
})

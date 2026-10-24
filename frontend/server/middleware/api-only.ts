import { defineEventHandler, getRequestURL, setHeader, setResponseStatus, type H3Event } from 'h3'

/** Fly serves API only; the private frontend remains behind Netlify's access control. */
export function apiOnlyHandler(event: H3Event) {
  if (process.env.NUXT_API_ONLY !== 'true' || getRequestURL(event).pathname.startsWith('/api/')) return
  setHeader(event, 'Cache-Control', 'no-store')
  setHeader(event, 'X-Content-Type-Options', 'nosniff')
  setResponseStatus(event, 404)
  return { error: { code: 'not_found', message: '対象が見つかりません' } }
}

export default defineEventHandler(apiOnlyHandler)

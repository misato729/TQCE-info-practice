export default defineEventHandler((event) => {
  const authorization = getHeader(event, 'authorization')
  const config = useRuntimeConfig(event)
  const configuredUser = String(config.basicAuthUser)
  const configuredPassword = String(config.basicAuthPassword)

  if (!configuredUser || !configuredPassword) {
    throw createError({
      statusCode: 503,
      statusMessage: 'Basic authentication is not configured',
    })
  }

  if (authorization?.startsWith('Basic ')) {
    const encodedCredentials = authorization.slice('Basic '.length)

    try {
      const credentials = Buffer.from(encodedCredentials, 'base64').toString('utf8')
      const separatorIndex = credentials.indexOf(':')
      const user = credentials.slice(0, separatorIndex)
      const password = credentials.slice(separatorIndex + 1)

      if (
        separatorIndex >= 0
        && user === configuredUser
        && password === configuredPassword
      ) {
        return
      }
    } catch {
      // Invalid credentials are handled by the authentication challenge below.
    }
  }

  setHeader(event, 'WWW-Authenticate', 'Basic realm="TQCE", charset="UTF-8"')
  throw createError({
    statusCode: 401,
    statusMessage: 'Authentication required',
  })
})

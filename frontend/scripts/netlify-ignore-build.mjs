import { spawnSync } from 'node:child_process'
import { fileURLToPath } from 'node:url'

const previous = process.env.CACHED_COMMIT_REF ?? ''
const current = process.env.COMMIT_REF ?? ''
const commit = /^(?:[a-f0-9]{40}|[a-f0-9]{64})$/i

// An unavailable comparison must build rather than leave application changes unpublished.
if (!commit.test(previous) || !commit.test(current)) process.exit(1)

const result = spawnSync('git', [
  'diff', '--quiet', previous, current, '--',
  '.', ':(exclude)tests/**',
  '../netlify.toml', '../package.json', '../package-lock.json',
  '../.npmrc', '../.nvmrc', '../.node-version',
  '../config', '../content', '../scripts',
], { cwd: fileURLToPath(new URL('../', import.meta.url)), stdio: 'ignore' })

// Netlify uses 0 to skip and 1 to continue; Git errors must also continue.
process.exit(result.status === 0 ? 0 : 1)

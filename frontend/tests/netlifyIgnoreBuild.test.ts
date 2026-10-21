import assert from 'node:assert/strict'
import { execFileSync, spawnSync } from 'node:child_process'
import { copyFileSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import test from 'node:test'

const script = new URL('../scripts/netlify-ignore-build.mjs', import.meta.url)

const fixture = () => {
  const root = mkdtempSync(join(tmpdir(), 'tqce-build-ignore-'))
  const git = (...args: string[]) => execFileSync('git', [
    '-c', 'user.name=Build test', '-c', 'user.email=build@example.invalid',
    '-c', 'core.hooksPath=/dev/null', '-c', 'commit.gpgsign=false', ...args,
  ], { cwd: root, stdio: ['ignore', 'pipe', 'pipe'] }).toString().trim()
  const write = (path: string, contents = 'fixture\n') => {
    mkdirSync(dirname(join(root, path)), { recursive: true })
    writeFileSync(join(root, path), contents)
  }
  git('init', '-q')
  write('frontend/app/app.vue')
  write('frontend/tests/example.test.ts')
  write('frontend/scripts/netlify-ignore-build.mjs')
  copyFileSync(script, join(root, 'frontend/scripts/netlify-ignore-build.mjs'))
  git('add', '.')
  git('commit', '-qm', 'Initial fixture')
  const previous = git('rev-parse', 'HEAD')
  const commit = () => {
    git('add', '--all')
    git('commit', '-qm', 'Change fixture')
    return git('rev-parse', 'HEAD')
  }
  const run = (current: string, cached = previous) => spawnSync(process.execPath,
    [join(root, 'frontend/scripts/netlify-ignore-build.mjs')], {
      cwd: root,
      env: { ...process.env, CACHED_COMMIT_REF: cached, COMMIT_REF: current },
      stdio: 'ignore',
    }).status
  return { root, git, write, commit, previous, run }
}

test('backend, documentation and frontend-test-only changes skip Netlify builds', () => {
  const repo = fixture()
  try {
    repo.write('backend/example.rb')
    repo.write('document/example.md')
    repo.write('frontend/tests/example.test.ts', 'updated test\n')
    assert.equal(repo.run(repo.commit()), 0)
  } finally { rmSync(repo.root, { recursive: true, force: true }) }
})

for (const path of ['frontend/app/app.vue', 'frontend/public/logo.png', 'frontend/package-lock.json',
  'frontend/nuxt.config.ts', 'frontend/netlify.toml', 'netlify.toml', 'package.json', '.npmrc']) {
  test(`a deployment-relevant change to ${path} continues the build`, () => {
    const repo = fixture()
    try {
      repo.write(path, 'deployment change\n')
      assert.equal(repo.run(repo.commit()), 1)
    } finally { rmSync(repo.root, { recursive: true, force: true }) }
  })
}

test('a test rename into the application and changes earlier in a multi-commit push still build', () => {
  const repo = fixture()
  try {
    repo.git('mv', 'frontend/tests/example.test.ts', 'frontend/app/example.ts')
    const application = repo.commit()
    repo.write('frontend/tests/later.test.ts')
    const current = repo.commit()
    assert.equal(repo.run(current), 1)
    assert.equal(repo.run(current, application), 0)
  } finally { rmSync(repo.root, { recursive: true, force: true }) }
})

test('missing, invalid or unavailable comparison commits continue the build', () => {
  const repo = fixture()
  try {
    assert.equal(repo.run(repo.previous, ''), 1)
    assert.equal(repo.run('', repo.previous), 1)
    assert.equal(repo.run(repo.previous, '--help'), 1)
    assert.equal(repo.run(repo.previous, 'f'.repeat(40)), 1)
    assert.equal(repo.run(repo.previous), 0)
  } finally { rmSync(repo.root, { recursive: true, force: true }) }
})

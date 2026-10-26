import assert from 'node:assert/strict'
import test from 'node:test'
import { hasPaidAccess, userPayload, type User } from '../server/core/auth.ts'
import { configuration, setConfigurationForTesting } from '../server/core/config.ts'
import type { Database } from '../server/core/db.ts'

type Membership = { status: 'active' | 'revoked', activated_at: Date } | null
type Grant = { expires_at: Date, revoked_at: Date | null } | null
type Entitlements = { membership: Membership, grant: Grant }
type Lookup = { where: { user_id: number, status?: string, revoked_at?: null, expires_at?: { gt: Date } } }
const member: User = { id: 42, name: 'Synthetic member', email: 'payload@example.invalid', role: 'user', created_at: new Date('2026-01-01T00:00:00Z') }
const purchasedAt = new Date('2026-01-02T00:00:00Z')

function databaseFor(state: Entitlements) {
  const reads = { membership: 0, grant: 0, favorites: 0 }
  const database = {
    membership: {
      async findUnique({ where }: Lookup) {
        reads.membership += 1
        assert.equal(where.user_id, member.id)
        return state.membership
      },
      async findFirst({ where }: Lookup) {
        reads.membership += 1
        assert.equal(where.user_id, member.id)
        return state.membership?.status === where.status ? state.membership : null
      },
    },
    verificationAccessGrant: {
      async findFirst({ where }: Lookup) {
        reads.grant += 1
        assert.equal(where.user_id, member.id)
        assert.equal(where.revoked_at, null)
        const cutoff = where.expires_at?.gt
        assert.ok(cutoff instanceof Date, 'verification lookup must reject expired grants')
        const grant = state.grant
        return grant && grant.revoked_at === where.revoked_at && grant.expires_at > cutoff ? grant : null
      },
    },
    favorite: {
      async findMany({ where }: { where: unknown }) {
        reads.favorites += 1
        assert.deepEqual(where, { user_id: member.id, question: { publication_status: 'published' } })
        return [{ question: { id: 501n, exam_number: 1, question_number: 3 } }]
      },
    },
  } as unknown as Database
  return { database, reads }
}

async function withPayments(enabled: boolean, action: () => Promise<void>) {
  const previous = configuration
  const previousEnvironment = process.env.APP_ENV
  process.env.APP_ENV = 'test'
  setConfigurationForTesting({ ...structuredClone(previous), payments: { ...previous.payments, enabled } })
  try { await action() }
  finally {
    setConfigurationForTesting(previous)
    if (previousEnvironment === undefined) delete process.env.APP_ENV
    else process.env.APP_ENV = previousEnvironment
  }
}

test('member payload reads each entitlement once and preserves free, premium, admin and verification access', async () => {
  const future = new Date(Date.now() + 60_000)
  const expired = new Date(Date.now() - 60_000)
  const cases: { name: string, role?: User['role'], enabled?: boolean, membership?: Membership, grant?: Grant, access: boolean }[] = [
    { name: 'free member', access: false },
    { name: 'premium member', membership: { status: 'active', activated_at: purchasedAt }, access: true },
    { name: 'revoked membership', membership: { status: 'revoked', activated_at: purchasedAt }, access: false },
    { name: 'administrator', role: 'admin', access: true },
    { name: 'verification grant', grant: { expires_at: future, revoked_at: null }, access: true },
    { name: 'expired grant', grant: { expires_at: expired, revoked_at: null }, access: false },
    { name: 'revoked grant', grant: { expires_at: future, revoked_at: purchasedAt }, access: false },
    { name: 'payments disabled', enabled: false, access: true },
  ]
  for (const fixture of cases) await withPayments(fixture.enabled ?? true, async () => {
    const state = { membership: fixture.membership ?? null, grant: fixture.grant ?? null }
    const { database, reads } = databaseFor(state)
    const user = { ...member, role: fixture.role ?? 'user' }
    const payload = await userPayload(user, database)
    assert.equal(payload.paid_content_access, fixture.access, fixture.name)
    assert.equal(payload.membership.status, state.membership?.status ?? 'free', fixture.name)
    assert.equal(payload.membership.purchased_at, state.membership?.activated_at.toISOString() ?? null, fixture.name)
    const validGrant = fixture.grant && !fixture.grant.revoked_at && fixture.grant.expires_at > new Date()
    assert.deepEqual(payload.verification_access, validGrant ? { expires_at: fixture.grant!.expires_at.toISOString() } : null, fixture.name)
    assert.deepEqual(payload.favorite_questions, fixture.access ? [{ id: 501, exam_number: 1, question_number: 3 }] : [], fixture.name)
    assert.deepEqual(reads, { membership: 1, grant: 1, favorites: fixture.access ? 1 : 0 }, fixture.name)
    // Independent authorization calls must retain the same current-DB policy.
    const fresh = databaseFor(state)
    assert.equal(await hasPaidAccess(user, fresh.database), fixture.access, fixture.name)
    const requiresEntitlements = (fixture.enabled ?? true) && user.role !== 'admin'
    assert.deepEqual(fresh.reads, { membership: requiresEntitlements ? 1 : 0, grant: requiresEntitlements ? 1 : 0, favorites: 0 }, fixture.name)
  })
})

test('later member payloads and authorization calls reread revoked and renewed entitlements', async () => {
  await withPayments(true, async () => {
    const state: Entitlements = { membership: { status: 'active', activated_at: purchasedAt }, grant: null }
    const { database, reads } = databaseFor(state)
    assert.equal((await userPayload(member, database)).paid_content_access, true)
    state.membership!.status = 'revoked'
    assert.equal((await userPayload(member, database)).paid_content_access, false)
    assert.equal(await hasPaidAccess(member, database), false)
    state.grant = { expires_at: new Date(Date.now() + 60_000), revoked_at: null }
    assert.equal((await userPayload(member, database)).paid_content_access, true)
    assert.equal(await hasPaidAccess(member, database), true)
    assert.deepEqual(reads, { membership: 5, grant: 5, favorites: 2 })
  })
})

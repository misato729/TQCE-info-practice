import { test, expect, type BrowserContext } from '@playwright/test'
import { EXAM_CONFIG } from '../app/utils/examConfig.ts'

const member = {
  id: 9801,
  name: '復習確認会員',
  email: 'incorrect-review@example.test',
  role: 'user',
  paid_content_access: true,
  favorite_questions: [],
  membership: { status: 'active', purchased_at: '2026-01-01T00:00:00.000Z', expires_at: null },
  verification_access: null,
}

const question = {
  id: 9811,
  exam_number: 1,
  question_number: 1,
  major_category_code: EXAM_CONFIG.categories.major[0]!.value,
  category_code: EXAM_CONFIG.categories.minor[0]!.value,
  content_blocks: [{ type: 'text', text: '誤答復習の合成確認問題' }],
  choices: EXAM_CONFIG.exam.choice_labels.map((choice_label, index) => ({
    id: 9821 + index,
    choice_label,
    display_order: index + 1,
    content_blocks: [{ type: 'text', text: `復習用の選択肢 ${choice_label}` }],
  })),
  is_favorite: false,
}

async function installReviewFixture(context: BrowserContext, options: { twoTargets?: boolean } = {}) {
  let reviewRequests = 0
  let answered = false

  await context.route(url => url.pathname.startsWith('/api/'), async (route) => {
    const path = new URL(route.request().url()).pathname
    const respond = (body: unknown, status = 200) => route.fulfill({
      status,
      contentType: 'application/json',
      body: JSON.stringify(body),
    })

    if (path === '/api/v1/me') return respond({ data: member })
    if (path === '/api/auth/get-session') return respond({
      user: {
        ...member,
        id: String(member.id),
        emailVerified: false,
        createdAt: '2026-01-01T00:00:00.000Z',
        updatedAt: '2026-01-01T00:00:00.000Z',
      },
      session: {
        id: 'incorrect-review-session',
        userId: String(member.id),
        token: 'incorrect-review-token',
        expiresAt: '2099-01-01T00:00:00.000Z',
      },
    })
    if (path === '/api/v1/review_questions/incorrect') {
      reviewRequests += 1
      const data = answered
        ? []
        : [
            { question_id: question.id, exam_number: 1, question_number: 1 },
            ...(options.twoTargets ? [{ question_id: 9899, exam_number: 2, question_number: 2 }] : []),
          ]
      return respond({ data, meta: { total_count: data.length } })
    }
    if (path === '/api/v1/questions/next') return respond({ data: question })
    if (path === `/api/v1/questions/${question.id}/answer`) {
      answered = true
      return respond({ data: {
        question_id: question.id,
        selected_choice_id: question.choices[0]!.id,
        is_correct: true,
        correct_choice: question.choices[0],
        explanation_blocks: [{ type: 'text', text: '誤答復習の合成解説' }],
        source_text: null,
        answer_history_id: 9831,
      } })
    }
    return respond({}, 404)
  })

  return { reviewRequests: () => reviewRequests }
}

test('the home review tab loads targets only after selection', async ({ page, context }) => {
  const fixture = await installReviewFixture(context, { twoTargets: true })
  await page.goto('/')
  await expect(page.getByRole('tab', { name: '間違えた問題', exact: true })).toBeVisible()
  expect(fixture.reviewRequests()).toBe(0)

  await page.getByRole('tab', { name: '間違えた問題', exact: true }).click()
  await expect(page.getByRole('heading', { name: '復習する問題が2問あります', exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: 'ランダムに復習を始める', exact: true })).toBeVisible()
  expect(fixture.reviewRequests()).toBe(1)
})

test('an incorrect-review round keeps its context and refreshes the remaining targets at completion', async ({ page, context }) => {
  const fixture = await installReviewFixture(context)
  await page.goto('/practice/1/1?review=incorrect&order=random&seed=12345')

  await expect(page.getByText('誤答復習の合成確認問題', { exact: true })).toBeVisible()
  await expect(page.getByText('間違えた問題を復習中', { exact: true })).toBeVisible()
  await expect(page.getByText('復習 1 / 全1問', { exact: true })).toBeVisible()

  await page.locator('.choices label').first().click()
  await page.getByRole('button', { name: '回答する', exact: true }).click()
  await expect(page.getByText('誤答復習の合成解説', { exact: true })).toBeVisible()
  await page.getByRole('button', { name: '復習結果を確認', exact: true }).click()

  await expect(page.getByText('間違えた問題をすべて正解しました', { exact: true })).toBeVisible()
  await expect(page.getByRole('link', { name: '解答履歴へ戻る', exact: true })).toHaveAttribute('href', '/history?review=complete')
  expect(fixture.reviewRequests()).toBe(2)
})

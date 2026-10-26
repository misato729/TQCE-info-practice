import { defineApiHandler } from '../../../core/api-handler.ts'
import { listIncorrectReviewQuestions } from '../../../services/learning.ts'

export default defineApiHandler((_event, user) => listIncorrectReviewQuestions(user), { authentication: 'required' })

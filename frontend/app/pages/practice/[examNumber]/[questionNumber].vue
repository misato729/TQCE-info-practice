<script setup lang="ts">
import { EXAM_CATALOG, QUESTIONS_PER_EXAM, FREE_EXAM_MAX } from '~/utils/examCatalog'
import {
  createPracticeSeed,
  createPracticeSequence,
  shufflePracticeSequence,
  type PracticeOrder,
  type PracticePosition,
} from '~/utils/practiceSequence'

type ContentBlock = {
  type: 'text' | 'quote' | 'fill_in_text' | 'fill_in_quote' | 'fill_in_choice' | 'table' | 'code' | 'code_group'
  text?: string
  source?: string
  title?: string
  code?: string
  headers?: string[]
  rows?: string[][]
  items?: { title: string, code: string }[]
  cells?: string[]
}

type Choice = {
  id: number
  choice_label: string
  content_blocks: ContentBlock[]
  display_order: number
}

type Question = {
  id: number
  exam_number: number
  question_number: number
  content_blocks: ContentBlock[]
  major_category_code: string
  category_code: string
  choices: Choice[]
  is_favorite?: boolean
}

type AnswerResult = {
  question_id: number
  selected_choice_id: number
  is_correct: boolean
  correct_choice: Choice
  explanation_blocks: ContentBlock[]
  source_text: string | null
  answer_history_id: number | null
}

type AnswerHistoryDetail = {
  id: number
  question: { id: number }
  selected_choice: { id: number }
  is_correct: boolean
  correct_choice: Choice
  explanation_blocks: ContentBlock[]
  source_text: string | null
}

type ApiResponse<T> = { data: T }

type PracticeScope = 'all' | 'teacher_education' | 'information'

type SourceReference = {
  label: string
  url: string | null
}

const route = useRoute()
const { $api: api } = useNuxtApp()
const { isLoggedIn, user, authResolved, authHeaders, sessionVersion } = useAuth()
const { canUseFavorites, isFavorite, setFavorite, toggleFavorite } = useFavorites()
const {
  loading: incorrectReviewLoading,
  error: incorrectReviewError,
  loaded: incorrectReviewLoaded,
  load: loadIncorrectReview,
  clear: clearIncorrectReview,
  createSequence: createIncorrectReviewSequence,
} = useIncorrectReview()
const updatingFavorite = ref(false)

const allExamNumbers = EXAM_CATALOG.map(exam => exam.exam_number)
const allQuestionNumbers = Object.freeze(Array.from({ length: QUESTIONS_PER_EXAM }, (_, index) => index + 1))

const parseNumberSelection = (value: unknown, allowedNumbers: readonly number[]) => {
  const serialized = Array.isArray(value) ? value.join(',') : typeof value === 'string' ? value : ''
  return [...new Set(
    serialized
      .split(',')
      .map(part => Number(part))
      .filter(number => Number.isInteger(number) && allowedNumbers.includes(number)),
  )].sort((left, right) => left - right)
}

const examNumber = computed(() => Number(route.params.examNumber))
const questionNumber = computed(() => Number(route.params.questionNumber))
const answerHistoryId = computed(() => {
  const value = Number(route.query.answer_history_id)
  return Number.isInteger(value) && value > 0 ? value : null
})
const isIncorrectReview = computed(() => route.query.review === 'incorrect' && answerHistoryId.value === null)
const practiceScope = computed<PracticeScope>(() => {
  const value = route.query.scope
  return value === 'teacher_education' || value === 'information' ? value : 'all'
})
const hasConditionSelection = computed(() => (
  route.query.exams !== undefined || route.query.questions !== undefined
))
const practiceOrder = computed<PracticeOrder>(() => (
  route.query.order === 'random' ? 'random' : 'sequential'
))
const practiceSeed = computed(() => {
  const value = Array.isArray(route.query.seed) ? route.query.seed[0] : route.query.seed
  if (typeof value !== 'string' || !/^\d+$/.test(value)) return null

  const seed = Number(value)
  return Number.isSafeInteger(seed) && seed >= 0 && seed <= 0xFFFFFFFF ? seed : null
})
const selectedPracticeExamNumbers = computed(() => {
  const selected = parseNumberSelection(route.query.exams, allExamNumbers)
  return selected.length > 0 ? selected : [examNumber.value]
})
const selectedPracticeQuestionNumbers = computed(() => {
  const selected = parseNumberSelection(route.query.questions, allQuestionNumbers)
  if (selected.length > 0) return selected
  if (practiceScope.value === 'teacher_education') return allQuestionNumbers.slice(0, 15)
  if (practiceScope.value === 'information') return allQuestionNumbers.slice(15)
  return [...allQuestionNumbers]
})
const basePracticeSequence = computed<PracticePosition[]>(() => createPracticeSequence(
  selectedPracticeExamNumbers.value,
  selectedPracticeQuestionNumbers.value,
))
const isRandomPractice = computed(() => (
  hasConditionSelection.value
  && practiceOrder.value === 'random'
  && practiceSeed.value !== null
))
const regularPracticeSequence = computed<PracticePosition[]>(() => (
  isRandomPractice.value
    ? shufflePracticeSequence(basePracticeSequence.value, practiceSeed.value!)
    : basePracticeSequence.value
))
const incorrectReviewSnapshot = ref<PracticePosition[]>([])
const incorrectReviewReady = ref(false)
const incorrectReviewRedirecting = ref(false)
const incorrectReviewRemainingCount = ref<number | null>(null)
const practiceSequence = computed<PracticePosition[]>(() => (
  isIncorrectReview.value ? incorrectReviewSnapshot.value : regularPracticeSequence.value
))
const currentPracticeIndex = computed(() => practiceSequence.value.findIndex(position => (
  position.examNumber === examNumber.value && position.questionNumber === questionNumber.value
)))
const nextPracticePosition = computed(() => (
  currentPracticeIndex.value >= 0
    ? practiceSequence.value[currentPracticeIndex.value + 1] ?? null
    : null
))
const practiceNavigationQuery = computed(() => {
  if (isIncorrectReview.value && practiceSeed.value !== null) {
    return {
      review: 'incorrect',
      order: 'random',
      seed: String(practiceSeed.value),
    }
  }
  if (hasConditionSelection.value) {
    const query: Record<string, string> = {
      exams: selectedPracticeExamNumbers.value.join(','),
      questions: selectedPracticeQuestionNumbers.value.join(','),
    }
    if (isRandomPractice.value) {
      query.order = 'random'
      query.seed = String(practiceSeed.value)
    }
    return query
  }
  return practiceScope.value === 'all' ? {} : { scope: practiceScope.value }
})
const basicPositionIsValid = computed(() => (
  Number.isInteger(examNumber.value)
  && allExamNumbers.includes(examNumber.value)
  && Number.isInteger(questionNumber.value)
  && allQuestionNumbers.includes(questionNumber.value)
))
const validPosition = computed(() => (
  basicPositionIsValid.value
  && (
    isIncorrectReview.value
      ? (!incorrectReviewReady.value || currentPracticeIndex.value >= 0)
      : currentPracticeIndex.value >= 0
  )
))

const requestQuery = computed(() => ({
  exam_number: validPosition.value ? examNumber.value : 0,
  after_question_number: validPosition.value ? questionNumber.value - 1 : -1,
}))
// Keep Nuxt's reactive fetch/error/retry handling, but reject positions already
// known to be invalid before reaching the shared API client or the network.
const questionApi = new Proxy(api, {
  apply(target, thisArg, args) {
    if (!validPosition.value) return Promise.reject(createError({
      statusCode: 422, message: '試験ナンバーまたは問番号が正しくありません。',
    }))
    return Reflect.apply(target as Function, thisArg, args)
  },
})
// HttpOnly credentials do not change authHeaders. Re-fetch when the native
// identity or its application entitlement changes, including another tab.
const questionSession = computed(() => JSON.stringify([
  // An anonymous paywall also returns 401. Repeated anonymous generations
  // must not trigger another identical denied request indefinitely.
  user.value ? sessionVersion.value : null,
  user.value?.id ?? null, user.value?.paid_content_access ?? false,
]))

const {
  data: questionResponse,
  status,
  error: questionError,
  refresh,
  clear,
} = await useFetch<ApiResponse<Question>>('/api/v1/questions/next', {
  $fetch: questionApi,
  query: requestQuery,
  headers: authHeaders,
  watch: [questionSession],
  server: false,
  // 画面遷移をAPIの応答待ちで止めず、起動待ち中も読み込み表示を出す。
  lazy: true,
})

const question = computed(() => {
  const loaded = questionResponse.value?.data
  if (!loaded || loaded.exam_number !== examNumber.value || loaded.question_number !== questionNumber.value) return null
  return loaded
})

const selectedChoiceId = ref<number | null>(null)
const answerResult = ref<AnswerResult | null>(null)
const answerError = ref('')
const submitting = ref(false)
const loadingNext = ref(false)
const completed = ref(false)
const favoriteModalOpen = ref(false)
const favoriteModalCloseButton = ref<HTMLButtonElement | null>(null)
const restoredHistoryId = ref<number | null>(null)
const incorrectReviewRouteError = ref('')
let answerGeneration = 0
let incorrectReviewGeneration = 0

const incorrectReviewQuerySignature = computed(() => JSON.stringify([
  route.query.review,
  route.query.order,
  route.query.seed,
  route.query.scope,
  route.query.exams,
  route.query.questions,
  route.query.answer_history_id,
]))

const initializeIncorrectReview = async (force = false) => {
  const generation = ++incorrectReviewGeneration
  incorrectReviewRouteError.value = ''

  if (!isIncorrectReview.value) {
    incorrectReviewSnapshot.value = []
    incorrectReviewRemainingCount.value = null
    incorrectReviewReady.value = false
    incorrectReviewRedirecting.value = false
    return
  }
  if (!authResolved.value) {
    incorrectReviewReady.value = false
    return
  }
  if (!isLoggedIn.value) {
    incorrectReviewReady.value = false
    incorrectReviewRedirecting.value = true
    await navigateTo({ path: '/login', query: { redirect: route.fullPath } })
    if (generation === incorrectReviewGeneration) incorrectReviewRedirecting.value = false
    return
  }

  incorrectReviewReady.value = false
  try {
    await loadIncorrectReview(force ? { force: true } : undefined)
    if (generation !== incorrectReviewGeneration || !isIncorrectReview.value) return
    if (incorrectReviewError.value || !incorrectReviewLoaded.value) {
      incorrectReviewRouteError.value = '復習する問題を読み込めませんでした。通信状況を確認して、もう一度お試しください。'
      return
    }

    const seed = practiceSeed.value ?? createPracticeSeed()
    const sequence = createIncorrectReviewSequence(seed)
    incorrectReviewSnapshot.value = sequence
    incorrectReviewRemainingCount.value = null

    if (sequence.length === 0) {
      incorrectReviewReady.value = true
      incorrectReviewRedirecting.value = true
      await navigateTo({ path: '/history', query: { review: 'complete' } }, { replace: true })
      return
    }

    const currentIsTarget = sequence.some(position => (
      position.examNumber === examNumber.value && position.questionNumber === questionNumber.value
    ))
    const target = currentIsTarget
      ? { examNumber: examNumber.value, questionNumber: questionNumber.value }
      : sequence[0]!
    const canonicalQuery = {
      review: 'incorrect',
      order: 'random',
      seed: String(seed),
    }
    const currentQueryKeys = Object.keys(route.query).sort().join(',')
    const queryIsCanonical = currentQueryKeys === 'order,review,seed'
      && route.query.review === canonicalQuery.review
      && route.query.order === canonicalQuery.order
      && route.query.seed === canonicalQuery.seed
    const pathIsCanonical = examNumber.value === target.examNumber
      && questionNumber.value === target.questionNumber

    incorrectReviewReady.value = true
    if (!queryIsCanonical || !pathIsCanonical) {
      incorrectReviewRedirecting.value = true
      await navigateTo({
        path: `/practice/${target.examNumber}/${target.questionNumber}`,
        query: canonicalQuery,
      }, { replace: true })
    }
  }
  catch {
    if (generation === incorrectReviewGeneration) {
      incorrectReviewRouteError.value = '復習する問題を読み込めませんでした。通信状況を確認して、もう一度お試しください。'
    }
  }
  finally {
    if (generation === incorrectReviewGeneration) incorrectReviewRedirecting.value = false
  }
}

const majorCategoryLabel = computed(() => (
  MAJOR_CATEGORIES.find(item => item.value === question.value?.major_category_code)?.label
  ?? question.value?.major_category_code
  ?? ''
))
const categoryLabel = computed(() => getCategoryLabel(question.value?.category_code ?? ''))
const questionIsFavorite = computed(() => (
  isLoggedIn.value && question.value ? isFavorite(question.value.id) : false
))
const sourceReferences = computed<SourceReference[]>(() => (
  (answerResult.value?.source_text ?? '')
    .split('\n')
    .map(line => line.trim())
    .filter(Boolean)
    .map((line) => {
      const separatorIndex = line.lastIndexOf('|')
      if (separatorIndex === -1) return { label: line, url: null }

      const label = line.slice(0, separatorIndex).trim()
      const url = line.slice(separatorIndex + 1).trim()
      if (!/^https:\/\/[^\s]+$/.test(url)) return { label: line, url: null }

      return { label: label || url, url }
    })
))

const questionErrorStatus = computed(() => {
  const error = questionError.value as any
  return error?.statusCode ?? error?.status
})
const questionErrorCode = computed(() => (questionError.value as any)?.data?.error?.code)
const paywallRequired = computed(() => (
  PAYMENTS_ENABLED && examNumber.value > FREE_EXAM_MAX
  && (questionErrorStatus.value === 401 || questionErrorCode.value === 'paid_membership_required')
))
const paywallNeedsLogin = computed(() => questionErrorStatus.value === 401)

const loadErrorMessage = computed(() => {
  if (!validPosition.value) return '試験ナンバーまたは問番号が正しくありません。'
  if (paywallRequired.value) return ''
  if (questionError.value || (questionResponse.value && !question.value)) return '指定された公開問題が見つかりませんでした。'
  return ''
})
const incorrectReviewPagePending = computed(() => (
  isIncorrectReview.value
  && !incorrectReviewRouteError.value
  && !incorrectReviewError.value
  && (
    !authResolved.value
    || incorrectReviewRedirecting.value
    || (!incorrectReviewReady.value && (incorrectReviewLoading.value || !incorrectReviewLoaded.value))
  )
))
const incorrectReviewPageError = computed(() => {
  if (!isIncorrectReview.value || incorrectReviewReady.value) return ''
  if (incorrectReviewRouteError.value) return incorrectReviewRouteError.value
  return incorrectReviewError.value ? '復習する問題を読み込めませんでした。通信状況を確認して、もう一度お試しください。' : ''
})
const incorrectReviewHasNoTargets = computed(() => (
  isIncorrectReview.value && incorrectReviewReady.value && incorrectReviewSnapshot.value.length === 0
))
const practiceProgress = computed(() => (
  isIncorrectReview.value && currentPracticeIndex.value >= 0
    ? `復習 ${currentPracticeIndex.value + 1} / 全${practiceSequence.value.length}問`
    : hasConditionSelection.value && currentPracticeIndex.value >= 0
      ? `${isRandomPractice.value ? 'ランダム ' : ''}${currentPracticeIndex.value + 1} / ${practiceSequence.value.length}`
    : ''
))
const completionHeading = computed(() => (
  isIncorrectReview.value
    ? incorrectReviewRemainingCount.value === 0
      ? '間違えた問題をすべて正解しました'
      : `まだ${incorrectReviewRemainingCount.value ?? 0}問あります`
    : hasConditionSelection.value
    ? '選択した問題をすべて解き終えました'
    : practiceScope.value === 'all' ? '公開中の問題はここまでです' : '指定した出題範囲はここまでです'
))
const completionMessage = computed(() => {
  if (isIncorrectReview.value) {
    return incorrectReviewRemainingCount.value === 0
      ? '今回の解答を反映した結果、復習対象の問題はなくなりました。'
      : '今回の解答を反映して、復習対象を更新しました。新しい順番でもう一度取り組めます。'
  }
  if (hasConditionSelection.value) {
    return `${selectedPracticeExamNumbers.value.length}模試、全${practiceSequence.value.length}問の演習が完了しました。`
  }
  if (practiceScope.value === 'teacher_education') return `模擬試験 ${examNumber.value} の教職教養を解き終えました。`
  if (practiceScope.value === 'information') return `模擬試験 ${examNumber.value} の情報科特有を解き終えました。`
  return `模擬試験 ${examNumber.value} の公開問題をすべて解き終えました。`
})
const nextActionLabel = computed(() => {
  if (!isIncorrectReview.value) return '次の問題'
  return nextPracticePosition.value ? '次の復習問題' : '復習結果を確認'
})

watch(
  () => [
    examNumber.value,
    questionNumber.value,
    route.query.exams,
    route.query.questions,
    route.query.order,
    route.query.seed,
    route.query.review,
    route.query.answer_history_id,
    practiceScope.value,
    questionSession.value,
  ],
  () => {
    answerGeneration += 1
    selectedChoiceId.value = null
    answerResult.value = null
    answerError.value = ''
    completed.value = false
    restoredHistoryId.value = null
    submitting.value = false
  },
  { flush: 'sync' },
)

watch(
  [isIncorrectReview, authResolved, isLoggedIn, questionSession, incorrectReviewQuerySignature],
  () => { void initializeIncorrectReview() },
  { immediate: true },
)
// Do not retain a previous account's question/error while the replacement
// request is pending. Nuxt also cancels the previous in-flight useFetch result.
watch(questionSession, () => { clear() }, { flush: 'sync' })

watch(question, (loaded) => {
  if (loaded && typeof loaded.is_favorite === 'boolean') setFavorite(loaded, loaded.is_favorite)
}, { immediate: true })

const choiceState = (choice: Choice) => {
  if (!answerResult.value) return { selected: selectedChoiceId.value === choice.id }

  return {
    selected: selectedChoiceId.value === choice.id,
    correct: answerResult.value.correct_choice.id === choice.id,
    incorrect: selectedChoiceId.value === choice.id && !answerResult.value.is_correct,
  }
}

const submitAnswer = async () => {
  if (!question.value || selectedChoiceId.value === null || submitting.value) return

  const generation = answerGeneration
  const questionId = question.value.id
  const reviewOwnerSession = isLoggedIn.value ? questionSession.value : null
  submitting.value = true
  answerError.value = ''

  try {
    const response = await api<ApiResponse<AnswerResult>>(
      `/api/v1/questions/${questionId}/answer`,
      {
        method: 'POST',
        headers: authHeaders.value,
        body: { selected_choice_id: selectedChoiceId.value },
      },
    )
    // An authenticated answer can change whether this question belongs to a
    // future review round. Keep the current round's local snapshot, but make
    // every later entry point fetch the latest target set.
    if (reviewOwnerSession !== null && reviewOwnerSession === questionSession.value) {
      clearIncorrectReview()
    }
    if (generation === answerGeneration && question.value?.id === questionId) answerResult.value = response.data
  }
  catch (error: any) {
    if (generation !== answerGeneration) return
    if (error?.statusCode === 401 || error?.status === 401) {
      answerError.value = 'ログインの有効期限が切れました。もう一度ログインしてください。'
      return
    }
    if (error?.data?.error?.code === 'paid_membership_required') {
      answerError.value = 'プレミアム会員資格を確認できません。プレミアム会員ページをご確認ください。'
      return
    }
    answerError.value = '回答を送信できませんでした。通信状況を確認して、もう一度お試しください。'
  }
  finally {
    if (generation === answerGeneration) submitting.value = false
  }
}

const restoreAnswerHistory = async () => {
  if (isIncorrectReview.value || status.value !== 'success' || !question.value || !isLoggedIn.value || !answerHistoryId.value) return
  if (restoredHistoryId.value === answerHistoryId.value) return

  const generation = answerGeneration
  const questionId = question.value.id
  const historyId = answerHistoryId.value
  try {
    const response = await api<ApiResponse<AnswerHistoryDetail>>(
      `/api/v1/answer_histories/${historyId}`,
      {
        headers: authHeaders.value,
      },
    )
    if (generation !== answerGeneration || question.value?.id !== questionId || answerHistoryId.value !== historyId) return
    const history = response.data
    if (history.question.id !== question.value.id) {
      answerError.value = 'この解答履歴は表示中の問題と一致しません。'
      return
    }

    selectedChoiceId.value = history.selected_choice.id
    answerResult.value = {
      question_id: history.question.id,
      selected_choice_id: history.selected_choice.id,
      is_correct: history.is_correct,
      correct_choice: history.correct_choice,
      explanation_blocks: history.explanation_blocks,
      source_text: history.source_text,
      answer_history_id: history.id,
    }
    restoredHistoryId.value = history.id
  }
  catch (error: any) {
    if (generation !== answerGeneration) return
    if (error?.statusCode !== 401 && error?.status !== 401) answerError.value = '解答履歴を読み込めませんでした。'
  }
}

watch(
  [question, answerHistoryId, isLoggedIn, status, questionSession],
  restoreAnswerHistory,
  { immediate: true },
)

const goToNextQuestion = async () => {
  if (!question.value || loadingNext.value) return

  if (!nextPracticePosition.value) {
    if (isIncorrectReview.value) {
      loadingNext.value = true
      answerError.value = ''
      try {
        const remaining = await loadIncorrectReview({ force: true })
        if (incorrectReviewError.value || !incorrectReviewLoaded.value) throw new Error('incorrect review load failed')
        incorrectReviewRemainingCount.value = remaining.length
        completed.value = true
      }
      catch {
        answerError.value = '復習結果を更新できませんでした。通信状況を確認して、もう一度お試しください。'
      }
      finally {
        loadingNext.value = false
      }
      return
    }
    completed.value = true
    return
  }

  loadingNext.value = true
  answerError.value = ''

  try {
    await navigateTo({
      path: `/practice/${nextPracticePosition.value.examNumber}/${nextPracticePosition.value.questionNumber}`,
      query: practiceNavigationQuery.value,
    })
  }
  catch (error: any) {
    answerError.value = '次の問題へ移動できませんでした。もう一度お試しください。'
  }
  finally {
    loadingNext.value = false
  }
}

const restartIncorrectReview = async () => {
  if (!isIncorrectReview.value || loadingNext.value) return

  loadingNext.value = true
  answerError.value = ''
  try {
    const seed = createPracticeSeed()
    const sequence = createIncorrectReviewSequence(seed)
    if (sequence.length === 0) {
      incorrectReviewRemainingCount.value = 0
      return
    }

    incorrectReviewSnapshot.value = sequence
    incorrectReviewRemainingCount.value = null
    completed.value = false
    await navigateTo({
      path: `/practice/${sequence[0]!.examNumber}/${sequence[0]!.questionNumber}`,
      query: { review: 'incorrect', order: 'random', seed: String(seed) },
    })
  }
  catch {
    answerError.value = '復習を再開できませんでした。もう一度お試しください。'
  }
  finally {
    loadingNext.value = false
  }
}

const closeFavoriteModal = () => {
  favoriteModalOpen.value = false
}

const handleFavoriteClick = async () => {
  if (!question.value || updatingFavorite.value || (isLoggedIn.value && !user.value)) return

  if (!canUseFavorites.value) {
    favoriteModalOpen.value = true
    await nextTick()
    favoriteModalCloseButton.value?.focus()
    return
  }

  updatingFavorite.value = true
  try {
    await toggleFavorite(question.value)
  }
  catch (error: any) {
    answerError.value = error?.data?.error?.message ?? 'お気に入りを更新できませんでした。'
  }
  finally {
    updatingFavorite.value = false
  }
}

const handleFavoriteModalKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape' && favoriteModalOpen.value) closeFavoriteModal()
}

onMounted(() => window.addEventListener('keydown', handleFavoriteModalKeydown))
onBeforeUnmount(() => window.removeEventListener('keydown', handleFavoriteModalKeydown))
</script>

<template>
  <div class="page-wrap practice-wrap">
    <div v-if="incorrectReviewPagePending" class="state-panel" role="status" aria-live="polite" aria-busy="true">
      <UIcon class="spin" name="i-lucide-loader-circle" aria-hidden="true" />
      <p>復習する問題を読み込んでいます</p>
    </div>

    <div v-else-if="incorrectReviewPageError" class="state-panel error-panel" role="alert">
      <UIcon name="i-lucide-circle-alert" />
      <h1>復習する問題を表示できません</h1>
      <p>{{ incorrectReviewPageError }}</p>
      <div class="state-actions">
        <button class="secondary-link" type="button" @click="() => initializeIncorrectReview(true)">再読み込み</button>
        <NuxtLink class="primary-link" to="/history">解答履歴へ戻る</NuxtLink>
      </div>
    </div>

    <div v-else-if="incorrectReviewHasNoTargets" class="state-panel review-complete-panel">
      <UIcon name="i-lucide-circle-check-big" />
      <h1>復習する問題はありません</h1>
      <p>最新の解答で間違えた問題は、すべて正解済みです。</p>
      <div class="state-actions">
        <NuxtLink class="secondary-link" to="/history">解答履歴を確認する</NuxtLink>
        <NuxtLink class="primary-link" to="/">トップへ戻る</NuxtLink>
      </div>
    </div>

    <div v-else-if="status === 'idle' || status === 'pending'" class="state-panel" role="status" aria-live="polite" aria-busy="true">
      <UIcon class="spin" name="i-lucide-loader-circle" aria-hidden="true" />
      <p>問題を読み込んでいます</p>
    </div>

    <div v-else-if="paywallRequired" class="state-panel paywall-panel">
      <UIcon name="i-lucide-lock-keyhole" />
      <h1>模擬試験{{ examNumber }}はプレミアム会員向けです</h1>
      <p v-if="paywallNeedsLogin">模擬試験{{ FREE_EXAM_MAX + 1 }}以降を利用するには、ログインしてプレミアム会員資格を確認してください。</p>
      <p v-else>{{ PRICE_LABEL }}の買い切りで、公開中および今後追加される模擬試験{{ FREE_EXAM_MAX + 1 }}以降を利用できます。</p>
      <div class="state-actions">
        <NuxtLink v-if="paywallNeedsLogin" class="secondary-link" :to="{ path: '/login', query: { redirect: route.fullPath } }">ログイン</NuxtLink>
        <NuxtLink class="primary-link" to="/premium">プレミアム会員について確認する</NuxtLink>
      </div>
    </div>

    <div v-else-if="loadErrorMessage || !question" class="state-panel error-panel">
      <UIcon name="i-lucide-circle-alert" />
      <h1>問題を表示できません</h1>
      <p>{{ loadErrorMessage || '指定された公開問題が見つかりませんでした。' }}</p>
      <div class="state-actions">
        <button class="secondary-link" type="button" @click="() => refresh()">再読み込み</button>
        <NuxtLink class="primary-link" to="/practice/1/1">問1から始める</NuxtLink>
      </div>
    </div>

    <template v-else>
      <header class="practice-head">
        <div>
          <div class="practice-context">
            <span class="exam-label">模擬試験 {{ question.exam_number }}</span>
            <span v-if="isIncorrectReview" class="review-label">間違えた問題を復習中</span>
            <span v-if="practiceProgress" class="practice-progress">{{ practiceProgress }}</span>
          </div>
          <h1>問{{ question.question_number }}</h1>
        </div>
        <div class="practice-meta">
          <button
            class="favorite-button"
            :class="{ active: questionIsFavorite }"
            type="button"
            :disabled="updatingFavorite || (isLoggedIn && !user)"
            :aria-pressed="isLoggedIn ? questionIsFavorite : false"
            :aria-label="questionIsFavorite ? 'お気に入りから解除する' : 'お気に入りに登録する'"
            :title="questionIsFavorite ? 'お気に入りから解除' : 'お気に入りに登録'"
            @click="handleFavoriteClick"
          >
            <FavoriteStarIcon :filled="questionIsFavorite" :size="34" />
          </button>
          <p>{{ majorCategoryLabel }} / {{ categoryLabel }}</p>
        </div>
      </header>

      <section class="question-panel">
        <div class="question-text">
          <QuestionContentBlocks :blocks="question.content_blocks" />
        </div>

        <div class="choices" role="radiogroup" aria-label="選択肢">
          <label
            v-for="choice in question.choices"
            :key="choice.id"
            :class="choiceState(choice)"
          >
            <input
              v-model="selectedChoiceId"
              type="radio"
              name="answer"
              :value="choice.id"
              :disabled="Boolean(answerResult) || submitting"
            >
            <span class="choice-label">{{ choice.choice_label }}</span>
            <QuestionContentBlocks class="choice-content" :blocks="choice.content_blocks" />
            <UIcon v-if="answerResult?.correct_choice.id === choice.id" class="choice-mark correct-mark" name="i-lucide-circle-check" />
            <UIcon
              v-else-if="answerResult && selectedChoiceId === choice.id"
              class="choice-mark incorrect-mark"
              name="i-lucide-circle-x"
            />
          </label>
        </div>

        <button
          v-if="!answerResult"
          class="primary-link answer-button"
          type="button"
          :disabled="selectedChoiceId === null || submitting"
          @click="submitAnswer"
        >
          <UIcon v-if="submitting" class="spin" name="i-lucide-loader-circle" />
          {{ submitting ? '採点中です' : '回答する' }}
        </button>

        <p v-if="answerError" class="inline-error" role="alert">{{ answerError }}</p>

        <section
          v-if="answerResult"
          class="answer-result"
          :class="{ correct: answerResult.is_correct }"
          aria-live="polite"
        >
          <div class="result-heading">
            <UIcon :name="answerResult.is_correct ? 'i-lucide-circle-check' : 'i-lucide-circle-x'" />
            <strong>{{ answerResult.is_correct ? '正解です' : '不正解です' }}</strong>
          </div>

          <div class="result-section">
            <h2>正答</h2>
            <div class="correct-answer">
              <span>{{ answerResult.correct_choice.choice_label }}</span>
              <QuestionContentBlocks :blocks="answerResult.correct_choice.content_blocks" />
            </div>
          </div>

          <div class="result-section">
            <h2>解答解説</h2>
            <QuestionContentBlocks :blocks="answerResult.explanation_blocks" />
          </div>

          <div v-if="answerResult.source_text" class="result-section source-section">
            <h2>根拠資料</h2>
            <ul>
              <li v-for="(source, index) in sourceReferences" :key="`${source.url ?? source.label}-${index}`">
                <a
                  v-if="source.url"
                  :href="source.url"
                  target="_blank"
                  rel="noopener noreferrer"
                >{{ source.label }}</a>
                <span v-else>{{ source.label }}</span>
              </li>
            </ul>
          </div>

          <div v-if="completed" class="completed-message">
            <strong>{{ completionHeading }}</strong>
            <p>{{ completionMessage }}</p>
            <div class="completed-actions">
              <button
                v-if="isIncorrectReview && (incorrectReviewRemainingCount ?? 0) > 0"
                class="primary-link"
                type="button"
                :disabled="loadingNext"
                @click="restartIncorrectReview"
              >{{ loadingNext ? '読み込み中です' : '残っている問題をもう一度復習' }}</button>
              <NuxtLink
                v-if="isIncorrectReview"
                class="secondary-link"
                :to="incorrectReviewRemainingCount === 0 ? { path: '/history', query: { review: 'complete' } } : '/history'"
              >解答履歴へ戻る</NuxtLink>
              <NuxtLink v-else class="secondary-link" to="/">トップへ戻る</NuxtLink>
            </div>
          </div>
          <button v-else class="primary-link next-button" type="button" :disabled="loadingNext" @click="goToNextQuestion">
            {{ loadingNext ? '読み込み中です' : nextActionLabel }}
            <UIcon name="i-lucide-arrow-right" />
          </button>
        </section>
      </section>
    </template>

    <Teleport to="body">
      <Transition name="favorite-modal">
        <div
          v-if="favoriteModalOpen"
          class="favorite-modal-backdrop"
          @click.self="closeFavoriteModal"
        >
          <section
            class="favorite-modal"
            role="dialog"
            aria-modal="true"
            aria-labelledby="favorite-modal-title"
          >
            <button
              ref="favoriteModalCloseButton"
              class="favorite-modal-close"
              type="button"
              aria-label="閉じる"
              @click="closeFavoriteModal"
            >
              <UIcon name="i-lucide-x" />
            </button>
            <span class="favorite-modal-icon" aria-hidden="true">
              <UIcon name="i-lucide-star" />
            </span>
            <h2 id="favorite-modal-title">お気に入り機能について</h2>
            <p>{{ PAYMENTS_ENABLED ? 'お気に入り登録は、プレミアム会員向けの機能です。' : 'お気に入り登録にはログインが必要です。' }}</p>
            <div class="favorite-modal-actions">
              <NuxtLink v-if="PAYMENTS_ENABLED" class="primary-link" to="/premium" @click="closeFavoriteModal">プレミアム会員について</NuxtLink>
              <NuxtLink v-if="!isLoggedIn" class="secondary-link" :to="{ path: '/login', query: { redirect: route.fullPath } }" @click="closeFavoriteModal">ログインへ</NuxtLink>
            </div>
          </section>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<style scoped>
.practice-wrap { max-width: 900px; }
.practice-head { padding: 46px 0 22px; display: flex; align-items: flex-end; justify-content: space-between; gap: 18px; }
.practice-context { display: flex; align-items: center; flex-wrap: wrap; gap: 8px 12px; }
.practice-head .exam-label { color: var(--teal); font-size: 0.875rem; font-weight: 800; }
.review-label { padding: 4px 9px; border-radius: 999px; background: #e5f3f1; color: var(--teal-dark); font-size: 0.75rem; font-weight: 800; }
.practice-progress { padding-left: 12px; border-left: 1px solid #bdcbcd; color: var(--muted); font-size: 0.8125rem; font-weight: 800; }
.practice-head h1 { margin: 5px 0 0; font-size: 2.25rem; }
.practice-head p { margin: 0; color: var(--muted); }
.practice-meta { display: flex; align-items: center; gap: 10px; }
.favorite-button {
  width: 42px;
  height: 42px;
  flex: 0 0 42px;
  display: grid;
  place-items: center;
  padding: 0;
  border: 0;
  background: transparent;
  color: #72838a;
  cursor: pointer;
  transition: color .15s, transform .15s;
}
.favorite-button:hover { color: #c78b00; transform: scale(1.08); }
.favorite-button.active { color: #f0b323; }
.favorite-button:disabled { opacity: .6; cursor: wait; }
.question-panel { padding: 32px; border: 1px solid var(--line); border-radius: 8px; background: #fff; }
.question-text { margin: 0; font-size: 1.1875rem; font-weight: 700; line-height: 1.8; }
.choices { display: grid; gap: 10px; margin-top: 28px; }
.choices label { position: relative; min-width: 0; min-height: 62px; display: grid; grid-template-columns: 20px 34px minmax(0, 1fr) 24px; align-items: start; gap: 10px; padding: 16px; border: 1px solid #c8d4d7; border-radius: 6px; cursor: pointer; transition: border-color .15s, background .15s; }
.choices label:hover:not(:has(input:disabled)) { border-color: var(--teal); }
.choices input,
.choice-label { margin-top: 3px; }
.choices label.selected { border-color: var(--teal); background: #eaf6f5; }
.choices label.correct { border-color: var(--teal); background: #eaf6f5; }
.choices label.incorrect { border-color: var(--coral); background: #fff4f1; }
.choice-label { min-width: 0; overflow-wrap: anywhere; color: var(--teal-dark); font-weight: 900; }
.choice-content { min-width: 0; line-height: 1.65; }
.choice-mark { width: 22px; height: 22px; margin-top: 1px; }
.correct-mark { color: var(--teal); }
.incorrect-mark { color: var(--coral); }
.answer-button { width: 180px; margin-top: 24px; }
.answer-button:disabled,
.next-button:disabled { opacity: .45; cursor: not-allowed; }
.inline-error { margin: 16px 0 0; color: #a23b2a; font-weight: 700; }
.answer-result { margin-top: 28px; padding: 24px; border-left: 4px solid var(--coral); background: #fff8f6; }
.answer-result.correct { border-color: var(--teal); background: #f3fbfa; }
.result-heading { display: flex; align-items: center; gap: 10px; color: var(--coral); }
.correct .result-heading { color: var(--teal-dark); }
.result-heading :deep(svg) { width: 26px; height: 26px; }
.result-heading strong { font-size: 1.375rem; }
.result-section { margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--line); }
.result-section h2 { margin: 0 0 12px; color: #30464d; font-size: 1rem; }
.correct-answer { display: grid; grid-template-columns: 34px minmax(0, 1fr); gap: 10px; align-items: start; }
.correct-answer > span { color: var(--teal-dark); font-weight: 900; }
.source-section ul { display: grid; gap: 8px; margin: 0; padding-left: 1.2em; color: #506168; line-height: 1.7; }
.source-section a { color: var(--teal-dark); font-weight: 700; text-underline-offset: 3px; }
.next-button { margin-top: 24px; }
.completed-message { margin-top: 24px; padding: 18px; border: 1px solid var(--line); background: #fff; }
.completed-message p { color: var(--muted); }
.completed-actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 16px; }
.completed-actions .primary-link,
.completed-actions .secondary-link { width: auto; }
.state-panel { min-height: 360px; display: flex; align-items: center; justify-content: center; flex-direction: column; gap: 12px; text-align: center; }
.state-panel :deep(svg) { width: 34px; height: 34px; color: var(--teal); }
.state-panel p { margin: 0; color: var(--muted); }
.error-panel h1 { margin: 4px 0 0; font-size: 1.625rem; }
.error-panel :deep(svg) { color: var(--coral); }
.paywall-panel h1 { margin: 4px 0 0; font-size: 1.625rem; }
.paywall-panel :deep(svg) { color: #64787e; }
.review-complete-panel h1 { margin: 4px 0 0; font-size: 1.625rem; }
.review-complete-panel :deep(svg) { color: var(--teal); }
.state-actions { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 12px; }
.spin { animation: spin 1s linear infinite; }
.favorite-modal-backdrop {
  position: fixed;
  inset: 0;
  z-index: 80;
  display: grid;
  place-items: center;
  padding: 20px;
  background: rgba(13, 34, 39, .55);
}
.favorite-modal {
  position: relative;
  width: min(460px, 100%);
  padding: 34px;
  border-radius: 10px;
  background: #fff;
  box-shadow: 0 22px 60px rgba(13, 34, 39, .24);
  text-align: center;
}
.favorite-modal-close {
  position: absolute;
  top: 14px;
  right: 14px;
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border: 0;
  border-radius: 50%;
  background: #edf2f2;
  color: #41555c;
  cursor: pointer;
}
.favorite-modal-icon {
  width: 58px;
  height: 58px;
  display: grid;
  place-items: center;
  margin: 0 auto 18px;
  border-radius: 50%;
  background: #fff4cf;
  color: #c78b00;
}
.favorite-modal-icon :deep(svg) { width: 29px; height: 29px; fill: currentColor; }
.favorite-modal h2 { margin: 0; font-size: 1.5rem; }
.favorite-modal p { margin: 14px 0 0; color: var(--muted); line-height: 1.8; }
.favorite-modal-actions { display: flex; justify-content: center; gap: 10px; margin-top: 26px; }
.favorite-modal-enter-active,
.favorite-modal-leave-active { transition: opacity .16s ease; }
.favorite-modal-enter-active .favorite-modal,
.favorite-modal-leave-active .favorite-modal { transition: transform .18s ease; }
.favorite-modal-enter-from,
.favorite-modal-leave-to { opacity: 0; }
.favorite-modal-enter-from .favorite-modal,
.favorite-modal-leave-to .favorite-modal { transform: translateY(8px) scale(.98); }
@keyframes spin { to { transform: rotate(360deg); } }
@media (max-width: 640px) {
  .practice-head { align-items: flex-start; flex-direction: column; }
  .question-panel { padding: 22px; }
  .question-text { font-size: 1.125rem; }
  .choices label { grid-template-columns: 18px 28px minmax(0, 1fr) 22px; padding: 11px; }
  .answer-result { padding: 20px 16px; }
  .completed-actions { flex-direction: column; }
  .completed-actions .primary-link,
  .completed-actions .secondary-link { width: 100%; }
  .favorite-modal { padding: 30px 20px 24px; }
  .favorite-modal-actions { flex-direction: column; }
  .favorite-modal-actions a { width: 100%; }
}
</style>

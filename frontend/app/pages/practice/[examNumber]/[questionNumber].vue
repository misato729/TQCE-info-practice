<script setup lang="ts">
type ContentBlock = {
  type: 'text' | 'quote' | 'table' | 'code' | 'code_group'
  text?: string
  source?: string
  title?: string
  code?: string
  headers?: string[]
  rows?: string[][]
  items?: { title: string, code: string }[]
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

type ApiResponse<T> = { data: T }

const route = useRoute()
const config = useRuntimeConfig()

const examNumber = computed(() => Number(route.params.examNumber))
const questionNumber = computed(() => Number(route.params.questionNumber))
const validPosition = computed(() => (
  Number.isInteger(examNumber.value)
  && examNumber.value >= 1
  && Number.isInteger(questionNumber.value)
  && questionNumber.value >= 1
  && questionNumber.value <= 20
))

const requestQuery = computed(() => ({
  exam_number: validPosition.value ? examNumber.value : 0,
  after_question_number: validPosition.value ? questionNumber.value - 1 : -1,
}))

const {
  data: questionResponse,
  status,
  error: questionError,
  refresh,
} = await useFetch<ApiResponse<Question>>('/api/v1/questions/next', {
  baseURL: config.public.apiBase,
  query: requestQuery,
  server: false,
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

const majorCategoryLabel = computed(() => (
  MAJOR_CATEGORIES.find(item => item.value === question.value?.major_category_code)?.label
  ?? question.value?.major_category_code
  ?? ''
))
const categoryLabel = computed(() => getCategoryLabel(question.value?.category_code ?? ''))

const loadErrorMessage = computed(() => {
  if (!validPosition.value) return '試験ナンバーまたは問番号が正しくありません。'
  if (questionError.value || (questionResponse.value && !question.value)) return '指定された公開問題が見つかりませんでした。'
  return ''
})

watch(
  () => [examNumber.value, questionNumber.value],
  () => {
    selectedChoiceId.value = null
    answerResult.value = null
    answerError.value = ''
    completed.value = false
  },
)

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

  submitting.value = true
  answerError.value = ''

  try {
    const response = await $fetch<ApiResponse<AnswerResult>>(
      `/api/v1/questions/${question.value.id}/answer`,
      {
        baseURL: config.public.apiBase,
        method: 'POST',
        body: { selected_choice_id: selectedChoiceId.value },
      },
    )
    answerResult.value = response.data
  }
  catch {
    answerError.value = '回答を送信できませんでした。通信状況を確認して、もう一度お試しください。'
  }
  finally {
    submitting.value = false
  }
}

const goToNextQuestion = async () => {
  if (!question.value || loadingNext.value) return

  loadingNext.value = true
  answerError.value = ''

  try {
    const response = await $fetch<ApiResponse<Question>>('/api/v1/questions/next', {
      baseURL: config.public.apiBase,
      query: {
        exam_number: question.value.exam_number,
        after_question_number: question.value.question_number,
      },
    })
    await navigateTo(`/practice/${response.data.exam_number}/${response.data.question_number}`)
  }
  catch (error: any) {
    if (error?.statusCode === 404 || error?.status === 404) completed.value = true
    else answerError.value = '次の問題を取得できませんでした。もう一度お試しください。'
  }
  finally {
    loadingNext.value = false
  }
}
</script>

<template>
  <div class="page-wrap practice-wrap">
    <div v-if="status === 'pending'" class="state-panel" aria-live="polite">
      <UIcon class="spin" name="i-lucide-loader-circle" />
      <p>問題を読み込んでいます</p>
    </div>

    <div v-else-if="loadErrorMessage || !question" class="state-panel error-panel">
      <UIcon name="i-lucide-circle-alert" />
      <h1>問題を表示できません</h1>
      <p>{{ loadErrorMessage || '指定された公開問題が見つかりませんでした。' }}</p>
      <div class="state-actions">
        <button class="secondary-link" type="button" @click="refresh">再読み込み</button>
        <NuxtLink class="primary-link" to="/practice/1/1">問1から始める</NuxtLink>
      </div>
    </div>

    <template v-else>
      <header class="practice-head">
        <div>
          <span>模擬試験 {{ question.exam_number }}</span>
          <h1>問{{ question.question_number }}</h1>
        </div>
        <p>{{ majorCategoryLabel }} / {{ categoryLabel }}</p>
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
            <p>{{ answerResult.source_text }}</p>
          </div>

          <p class="ai-note">
            <UIcon name="i-lucide-triangle-alert" />
            生成AIで作成した問題には誤りが含まれる可能性があります。解説と根拠資料もあわせて確認してください。
          </p>

          <div v-if="completed" class="completed-message">
            <strong>公開中の問題はここまでです</strong>
            <p>模擬試験 {{ question.exam_number }} の公開問題をすべて解き終えました。</p>
            <NuxtLink class="secondary-link" to="/">トップへ戻る</NuxtLink>
          </div>
          <button v-else class="primary-link next-button" type="button" :disabled="loadingNext" @click="goToNextQuestion">
            {{ loadingNext ? '読み込み中です' : '次の問題' }}
            <UIcon name="i-lucide-arrow-right" />
          </button>
        </section>
      </section>
    </template>
  </div>
</template>

<style scoped>
.practice-wrap { max-width: 900px; }
.practice-head { padding: 46px 0 22px; display: flex; align-items: flex-end; justify-content: space-between; gap: 18px; }
.practice-head span { color: var(--teal); font-size: 14px; font-weight: 800; }
.practice-head h1 { margin: 5px 0 0; font-size: 36px; }
.practice-head p { margin: 0; color: var(--muted); }
.question-panel { padding: 32px; border: 1px solid var(--line); border-radius: 8px; background: #fff; }
.question-text { margin: 0; font-size: 21px; font-weight: 700; line-height: 1.8; }
.choices { display: grid; gap: 10px; margin-top: 28px; }
.choices label { position: relative; min-width: 0; min-height: 62px; display: grid; grid-template-columns: 20px 34px minmax(0, 1fr) 24px; align-items: start; gap: 10px; padding: 16px; border: 1px solid #c8d4d7; border-radius: 6px; cursor: pointer; transition: border-color .15s, background .15s; }
.choices label:hover:not(:has(input:disabled)) { border-color: var(--teal); }
.choices input,
.choice-label { margin-top: 3px; }
.choices label.selected { border-color: var(--teal); background: #eaf6f5; }
.choices label.correct { border-color: var(--teal); background: #eaf6f5; }
.choices label.incorrect { border-color: var(--coral); background: #fff4f1; }
.choice-label { color: var(--teal-dark); font-weight: 900; }
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
.result-heading strong { font-size: 22px; }
.result-section { margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--line); }
.result-section h2 { margin: 0 0 12px; color: #30464d; font-size: 16px; }
.correct-answer { display: grid; grid-template-columns: 34px minmax(0, 1fr); gap: 10px; align-items: start; }
.correct-answer > span { color: var(--teal-dark); font-weight: 900; }
.source-section p { margin: 0; color: #506168; line-height: 1.7; }
.ai-note { display: flex; align-items: flex-start; gap: 8px; margin: 24px 0 0; padding: 13px 15px; background: #fff7dc; color: #685715; font-size: 13px; line-height: 1.65; }
.ai-note :deep(svg) { flex: 0 0 auto; margin-top: 2px; }
.next-button { margin-top: 24px; }
.completed-message { margin-top: 24px; padding: 18px; border: 1px solid var(--line); background: #fff; }
.completed-message p { color: var(--muted); }
.state-panel { min-height: 360px; display: flex; align-items: center; justify-content: center; flex-direction: column; gap: 12px; text-align: center; }
.state-panel :deep(svg) { width: 34px; height: 34px; color: var(--teal); }
.state-panel p { margin: 0; color: var(--muted); }
.error-panel h1 { margin: 4px 0 0; font-size: 26px; }
.error-panel :deep(svg) { color: var(--coral); }
.state-actions { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 12px; }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
@media (max-width: 640px) {
  .practice-head { align-items: flex-start; flex-direction: column; }
  .question-panel { padding: 22px; }
  .question-text { font-size: 18px; }
  .choices label { grid-template-columns: 18px 28px minmax(0, 1fr) 22px; padding: 11px; }
  .answer-result { padding: 20px 16px; }
}
</style>

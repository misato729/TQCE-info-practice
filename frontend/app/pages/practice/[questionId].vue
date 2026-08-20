<script setup lang="ts">
const route = useRoute()
const selectedChoice = ref<number | null>(null)
const answered = ref(false)
const examNumber = computed(() => Number(route.query.exam || 1))
const questionNumber = computed(() => Number(route.params.questionId || 1))

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
  contentBlocks: ContentBlock[]
}

const textChoice = (text: string): Choice => ({ contentBlocks: [{ type: 'text', text }] })

const questionContent = computed<ContentBlock[]>(() => {
  if (questionNumber.value === 19) {
    return [
      { type: 'text', text: '次のプログラムAとプログラムBについて、正しい説明の組合せを選びなさい。' },
      {
        type: 'code_group',
        items: [
          { title: 'プログラムA', code: '(01) i = 0\n(02) i < n - 1 の間繰り返す:\n(03)   x = i\n(04)   j = i + 1\n(05)   j < n の間繰り返す:' },
          { title: 'プログラムB', code: '(01) i = 1\n(02) i < n の間繰り返す:\n(03)   j = i\n(04)   j >= 1 の間繰り返す:\n(05)     もし a[j - 1] > a[j] ならば:' },
        ],
      },
    ]
  }

  if (questionNumber.value === 11) {
    return [{ type: 'text', text: '生徒指導の重層的支援構造として、最も適切なものを選びなさい。' }]
  }

  return [{ type: 'text', text: '教育基本法の目的に関する記述として、最も適切なものを選びなさい。' }]
})

const choices = computed<Choice[]>(() => {
  if (questionNumber.value === 11) {
    const headers = ['第1層', '第2層', '第3層', '第4層']
    const rows = [
      ['発達支持的生徒指導', '課題予防的生徒指導', '課題早期発見対応', '困難課題対応的生徒指導'],
      ['困難課題対応的生徒指導', '課題早期発見対応', '課題未然防止教育', '発達支持的生徒指導'],
      ['発達支持的生徒指導', '課題早期発見対応', '課題未然防止教育', '困難課題対応的生徒指導'],
      ['困難課題対応的生徒指導', '課題未然防止教育', '課題早期発見対応', '発達支持的生徒指導'],
    ]
    return rows.map(row => ({ contentBlocks: [{ type: 'table', headers, rows: [row] }] }))
  }

  if (questionNumber.value === 19) {
    return ['①②', '②③', '①③', '①②③'].map(textChoice)
  }

  return [
    '教育の目的は、人格の完成を目指して行われる。',
    '教育は学校教育だけを対象としている。',
    '教育の機会均等は法律上定められていない。',
    '教育行政は国だけが行う。',
  ].map(textChoice)
})

const categoryLabel = computed(() => questionNumber.value === 19 ? '情報科特有 / アルゴリズム' : questionNumber.value === 11 ? '教職教養 / 生徒指導提要' : '教職教養 / 教育法規')

watch(questionNumber, () => {
  selectedChoice.value = null
  answered.value = false
})

const answer = () => {
  if (selectedChoice.value !== null) answered.value = true
}
</script>

<template>
  <div class="page-wrap practice-wrap">
    <header class="practice-head">
      <div>
        <span>模擬試験 {{ examNumber }}</span>
        <h1>問{{ questionNumber }}</h1>
      </div>
      <p>{{ categoryLabel }}</p>
    </header>
    <section class="question-panel">
      <div class="question-text">
        <QuestionContentBlocks :blocks="questionContent" />
      </div>
      <div class="choices">
        <label v-for="(choice, index) in choices" :key="index" :class="{ selected: selectedChoice === index }">
          <input v-model="selectedChoice" type="radio" name="answer" :value="index" :disabled="answered">
          <span class="choice-label">{{ ['ア', 'イ', 'ウ', 'エ'][index] }}</span>
          <QuestionContentBlocks class="choice-content" :blocks="choice.contentBlocks" />
        </label>
      </div>
      <button v-if="!answered" class="primary-link answer-button" type="button" :disabled="selectedChoice === null" @click="answer">回答する</button>
      <div v-else class="answer-result" :class="{ correct: selectedChoice === 0 }">
        <strong>{{ selectedChoice === 0 ? '正解です' : '不正解です' }}</strong>
        <p>正答は「ア」です。教育基本法第1条では、教育の目的として人格の完成を目指すことが示されています。</p>
        <NuxtLink class="primary-link" :to="`/practice/${Math.min(questionNumber + 1, 20)}?exam=${examNumber}`">次の問題</NuxtLink>
      </div>
    </section>
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
.choices label { min-width: 0; min-height: 62px; display: grid; grid-template-columns: 20px 34px minmax(0, 1fr); align-items: start; gap: 10px; padding: 16px; border: 1px solid #c8d4d7; border-radius: 6px; cursor: pointer; }
.choices input,
.choice-label { margin-top: 3px; }
.choices label.selected { border-color: var(--teal); background: #eaf6f5; }
.choice-label { color: var(--teal-dark); font-weight: 900; }
.choice-content { min-width: 0; line-height: 1.65; }
.answer-button { width: 180px; margin-top: 24px; }
.answer-button:disabled { opacity: .45; cursor: not-allowed; }
.answer-result { margin-top: 24px; padding: 20px; border-left: 4px solid var(--coral); background: #fff4f1; }
.answer-result.correct { border-color: var(--teal); background: #eaf6f5; }
.answer-result strong { font-size: 20px; }
.answer-result p { color: #506168; line-height: 1.8; }
@media (max-width: 640px) { .practice-head { align-items: flex-start; flex-direction: column; } .question-panel { padding: 22px; } .question-text { font-size: 18px; } .choices label { grid-template-columns: 18px 28px 1fr; padding: 11px; } }
</style>

<script setup lang="ts">
type Exam = {
  exam_number: number
  question_numbers: number[]
  published_question_count: number
  access: 'available' | 'paid_membership_required'
}

type ApiResponse<T> = { data: T }

const route = useRoute()
const config = useRuntimeConfig()
const openExam = ref<number | null>(null)
const { authHeaders, user, accessToken } = useAuth()

const { data: examsResponse, status: examsStatus, refresh: refreshExams } = await useFetch<ApiResponse<Exam[]>>('/api/v1/exams', {
  baseURL: config.public.apiBase,
  headers: authHeaders,
  server: false,
})

const exams = computed(() => examsResponse.value?.data ?? [])
const isLoading = computed(() => examsStatus.value === 'idle' || examsStatus.value === 'pending')

const toggleExam = (exam: number) => {
  openExam.value = openExam.value === exam ? null : exam
}

const isCurrentQuestion = (exam: number, question: number) => {
  return route.path === `/practice/${exam}/${question}`
}

const examTarget = (exam: Exam, question?: number) => (
  exam.access === 'available'
    ? `/practice/${exam.exam_number}/${question ?? exam.question_numbers[0]}`
    : '/premium'
)

watch([accessToken, () => user.value?.paid_content_access], () => { void refreshExams() })
</script>

<template>
  <aside class="exam-sidebar" aria-label="模擬試験一覧">
    <div class="sidebar-heading">
      <UIcon name="i-lucide-files" />
      <span>試験セット</span>
    </div>

    <div v-if="isLoading" class="sidebar-loading" role="status" aria-live="polite">
      <UIcon class="loading-spinner" name="i-lucide-loader-circle" />
      <span>試験セットを読み込んでいます</span>
    </div>

    <template v-else>
      <section v-for="exam in exams" :key="exam.exam_number" class="exam-group">
        <div
          class="exam-row"
          :class="{ current: route.path.startsWith(`/practice/${exam.exam_number}/`) }"
        >
          <NuxtLink class="exam-link" :to="examTarget(exam)">
            模擬試験 {{ exam.exam_number }}
            <UIcon v-if="exam.access !== 'available'" class="lock-icon" name="i-lucide-lock-keyhole" />
          </NuxtLink>
          <button
            type="button"
            :aria-expanded="openExam === exam.exam_number"
            :aria-controls="`exam-${exam.exam_number}-questions`"
            :title="openExam === exam.exam_number ? `模擬試験${exam.exam_number}を閉じる` : `模擬試験${exam.exam_number}を開く`"
            @click="toggleExam(exam.exam_number)"
          >
            <UIcon
              :name="openExam === exam.exam_number ? 'i-lucide-chevron-up' : 'i-lucide-chevron-down'"
            />
            <span class="sr-only">
              {{ openExam === exam.exam_number ? `模擬試験${exam.exam_number}を閉じる` : `模擬試験${exam.exam_number}を開く` }}
            </span>
          </button>
        </div>

        <Transition name="questions">
          <nav
            v-if="openExam === exam.exam_number"
            :id="`exam-${exam.exam_number}-questions`"
            class="question-list"
            :aria-label="`模擬試験${exam.exam_number}の問題一覧`"
          >
            <NuxtLink
              v-for="question in exam.question_numbers"
              :key="question"
              :to="examTarget(exam, question)"
              :class="{ active: isCurrentQuestion(exam.exam_number, question) }"
            >
              問{{ question }}
            </NuxtLink>
          </nav>
        </Transition>
      </section>
    </template>
  </aside>
</template>

<style scoped>
.exam-sidebar {
  width: 260px;
  min-height: calc(100vh - var(--header-height));
  padding: 22px 16px;
  border-right: 1px solid #cdd9dc;
  background: #e3e9e9;
}

.sidebar-heading {
  min-height: 40px;
  display: flex;
  align-items: center;
  gap: 9px;
  padding: 0 10px 10px;
  color: #53676e;
  font-size: 13px;
  font-weight: 800;
}

.sidebar-loading {
  min-height: 120px;
  display: grid;
  place-items: center;
  align-content: center;
  gap: 10px;
  color: #53676e;
  font-size: 13px;
  font-weight: 700;
  text-align: center;
}

.loading-spinner {
  width: 28px;
  height: 28px;
  color: var(--teal-dark);
  animation: sidebar-spin 1s linear infinite;
}

@keyframes sidebar-spin {
  to { transform: rotate(360deg); }
}

.exam-group + .exam-group {
  margin-top: 10px;
}

.exam-row {
  min-height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 10px 10px 16px;
  border: 1px solid #c2ced1;
  border-radius: 6px;
  background: #fff;
}

.exam-link {
  align-self: stretch;
  flex: 1;
  display: flex;
  align-items: center;
  color: var(--ink);
  font-size: 15px;
  font-weight: 800;
  text-decoration: none;
}

.exam-link:hover {
  color: var(--teal-dark);
}

.lock-icon { width: 17px; height: 17px; margin-left: auto; color: #7a8c91; }

.exam-row.current {
  border-color: var(--teal);
}

.exam-row button {
  width: 38px;
  height: 38px;
  flex: 0 0 38px;
  display: grid;
  place-items: center;
  border: 0;
  border-radius: 5px;
  background: #e7f2f2;
  color: var(--teal-dark);
  font-size: 21px;
  cursor: pointer;
}

.exam-row button:hover {
  background: #d5ebeb;
}

.question-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 5px;
  padding: 10px 6px 4px;
}

.question-list a {
  min-height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 5px;
  color: #40545b;
  font-size: 13px;
  font-weight: 700;
  text-decoration: none;
}

.question-list a:hover,
.question-list a.active {
  background: #cce8e8;
  color: var(--teal-dark);
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

.questions-enter-active,
.questions-leave-active {
  transition: opacity 150ms ease, transform 180ms ease;
}

.questions-enter-from,
.questions-leave-to {
  opacity: 0;
  transform: translateY(-6px);
}

@media (min-width: 761px) {
  .exam-sidebar {
    position: sticky;
    top: var(--header-height);
    height: calc(100vh - var(--header-height));
    overflow-y: auto;
  }
}

@media (max-width: 760px) {
  .exam-sidebar {
    width: 100%;
    min-height: auto;
    padding: 14px;
    border-right: 0;
    border-bottom: 1px solid #cdd9dc;
  }

  .sidebar-heading {
    min-height: 32px;
  }

  .sidebar-loading {
    min-height: 76px;
  }

  .exam-row {
    min-height: 54px;
  }

  .question-list {
    grid-template-columns: repeat(5, minmax(0, 1fr));
  }
}
</style>

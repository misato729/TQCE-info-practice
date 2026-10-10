<script setup lang="ts">
import { EXAM_CATALOG, FREE_EXAM_CATALOG, type ExamCatalogEntry } from '~/utils/examCatalog'

type ApiStatus = 'idle' | 'checking' | 'connected' | 'failed'

const emit = defineEmits<{
  apiStatus: [status: ApiStatus]
}>()

const route = useRoute()
const openExam = ref<number | null>(null)
const { user, accessToken, ensureCurrentUser } = useAuth()
const accessStatus = ref<'ready' | 'pending' | 'error'>(
  accessToken.value && !user.value ? 'pending' : 'ready',
)
let resolvingAccess = false

const exams = computed(() => (
  user.value?.paid_content_access ? EXAM_CATALOG : FREE_EXAM_CATALOG
))
const isLoading = computed(() => accessStatus.value === 'pending')
const hasAccessError = computed(() => accessStatus.value === 'error')

const resolveAccess = async () => {
  if (resolvingAccess) return

  if (!accessToken.value) {
    accessStatus.value = 'ready'
    emit('apiStatus', 'idle')
    return
  }

  if (user.value) {
    accessStatus.value = 'ready'
    emit('apiStatus', 'connected')
    return
  }

  resolvingAccess = true
  accessStatus.value = 'pending'
  emit('apiStatus', 'checking')

  const currentUser = await ensureCurrentUser()
  resolvingAccess = false

  if (currentUser) {
    accessStatus.value = 'ready'
    emit('apiStatus', 'connected')
  }
  else if (accessToken.value) {
    accessStatus.value = 'error'
    emit('apiStatus', 'failed')
  }
  else {
    accessStatus.value = 'ready'
    emit('apiStatus', 'idle')
  }
}

onMounted(() => { void resolveAccess() })

watch(accessToken, () => { void resolveAccess() })
watch(user, (currentUser) => {
  if (!currentUser) return
  accessStatus.value = 'ready'
  emit('apiStatus', 'connected')
})

const toggleExam = (exam: number) => {
  openExam.value = openExam.value === exam ? null : exam
}

const isCurrentQuestion = (exam: number, question: number) => {
  return route.path === `/practice/${exam}/${question}`
}

const examTarget = (exam: ExamCatalogEntry, question?: number) => (
  `/practice/${exam.exam_number}/${question ?? exam.question_numbers[0]}`
)
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

    <div v-else-if="hasAccessError" class="sidebar-loading sidebar-error" role="alert">
      <UIcon name="i-lucide-circle-alert" />
      <span>利用資格を確認できません</span>
      <button type="button" @click="resolveAccess">再確認</button>
    </div>

    <template v-else>
      <section v-for="exam in exams" :key="exam.exam_number" class="exam-group">
        <div
          class="exam-row"
          :class="{ current: route.path.startsWith(`/practice/${exam.exam_number}/`) }"
        >
          <NuxtLink class="exam-link" :to="examTarget(exam)">
            模擬試験 {{ exam.exam_number }}
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

.sidebar-error :deep(svg) { width: 25px; height: 25px; color: #b54a3b; }
.sidebar-error button {
  min-height: 34px;
  padding: 0 12px;
  border: 1px solid #aebfc3;
  border-radius: 5px;
  background: #fff;
  color: var(--teal-dark);
  font-weight: 800;
  cursor: pointer;
}
.sidebar-error button:hover { background: #f2f7f7; }

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

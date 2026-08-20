<script setup lang="ts">
const route = useRoute()
const exams = [1, 2, 3]
const openExam = ref<number | null>(null)

const toggleExam = (exam: number) => {
  openExam.value = openExam.value === exam ? null : exam
}

const isCurrentQuestion = (exam: number, question: number) => {
  return route.path === `/practice/${exam}/${question}`
}
</script>

<template>
  <aside class="exam-sidebar" aria-label="模擬試験一覧">
    <div class="sidebar-heading">
      <UIcon name="i-lucide-files" />
      <span>試験セット</span>
    </div>

    <section v-for="exam in exams" :key="exam" class="exam-group">
      <div
        class="exam-row"
        :class="{ current: route.path.startsWith(`/practice/${exam}/`) }"
      >
        <NuxtLink class="exam-link" :to="`/practice/${exam}/1`">
          模擬試験 {{ exam }}
        </NuxtLink>
        <button
          type="button"
          :aria-expanded="openExam === exam"
          :aria-controls="`exam-${exam}-questions`"
          :title="openExam === exam ? `模擬試験${exam}を閉じる` : `模擬試験${exam}を開く`"
          @click="toggleExam(exam)"
        >
          <UIcon
            :name="openExam === exam ? 'i-lucide-chevron-up' : 'i-lucide-chevron-down'"
          />
          <span class="sr-only">
            {{ openExam === exam ? `模擬試験${exam}を閉じる` : `模擬試験${exam}を開く` }}
          </span>
        </button>
      </div>

      <Transition name="questions">
        <nav
          v-if="openExam === exam"
          :id="`exam-${exam}-questions`"
          class="question-list"
          :aria-label="`模擬試験${exam}の問題一覧`"
        >
          <NuxtLink
            v-for="question in 20"
            :key="question"
            :to="`/practice/${exam}/${question}`"
            :class="{ active: isCurrentQuestion(exam, question) }"
          >
            問{{ question }}
          </NuxtLink>
        </nav>
      </Transition>
    </section>
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

  .exam-row {
    min-height: 54px;
  }

  .question-list {
    grid-template-columns: repeat(5, minmax(0, 1fr));
  }
}
</style>

<script setup lang="ts">
const { isLoggedIn } = useDemoAuth()
const { favoriteIds, removeFavorite } = useDemoFavorites()
const config = useRuntimeConfig()

type Question = {
  id: number
  exam_number: number
  question_number: number
  major_category_code: string
  category_code: string
}

type ApiResponse<T> = { data: T }

const favoriteQuestions = ref<Question[]>([])
const loading = ref(false)
const loadError = ref('')

const loadFavorites = async () => {
  if (!isLoggedIn.value || favoriteIds.value.length === 0) {
    favoriteQuestions.value = []
    loadError.value = ''
    return
  }

  loading.value = true
  loadError.value = ''

  try {
    const responses = await Promise.allSettled(
      favoriteIds.value.map(questionId => $fetch<ApiResponse<Question>>(
        `/api/v1/questions/${questionId}`,
        { baseURL: config.public.apiBase },
      )),
    )
    const loadedQuestions = responses.flatMap(response => (
      response.status === 'fulfilled' ? [response.value.data] : []
    ))
    if (loadedQuestions.length === 0 && favoriteIds.value.length > 0) {
      throw new Error('Favorites could not be loaded')
    }
    favoriteQuestions.value = loadedQuestions
  }
  catch {
    loadError.value = 'お気に入りを読み込めませんでした。もう一度お試しください。'
  }
  finally {
    loading.value = false
  }
}

const majorCategoryLabel = (code: string) => (
  MAJOR_CATEGORIES.find(item => item.value === code)?.label ?? code
)

watch(
  [isLoggedIn, favoriteIds],
  loadFavorites,
  { immediate: true },
)

const remove = (questionId: number) => {
  removeFavorite(questionId)
  favoriteQuestions.value = favoriteQuestions.value.filter(question => question.id !== questionId)
}
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>お気に入り一覧</h1><p>星アイコンからお気に入り登録した問題を確認できます。</p></header>
    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>お気に入りはログインユーザーのみ利用できます。</p>
      <NuxtLink class="primary-link" to="/login">ログインへ</NuxtLink>
    </div>
    <div v-else-if="loading" class="empty-state" aria-live="polite">
      <UIcon class="empty-icon spin" name="i-lucide-loader-circle" />
      <p>お気に入りを読み込んでいます。</p>
    </div>
    <div v-else-if="loadError" class="empty-state">
      <h2>お気に入りを読み込めません</h2>
      <p>{{ loadError }}</p>
      <button class="secondary-link" type="button" @click="loadFavorites">再読み込み</button>
    </div>
    <div v-else-if="favoriteQuestions.length === 0" class="empty-state">
      <UIcon class="empty-icon" name="i-lucide-star" />
      <h2>お気に入りはまだありません</h2>
      <p>問題画面の星アイコンから、お気に入りへ追加できます。</p>
      <NuxtLink class="primary-link" to="/practice/1/1">問題演習を始める</NuxtLink>
    </div>
    <div v-else class="favorite-list">
      <article v-for="question in favoriteQuestions" :key="question.id" class="favorite-card">
        <NuxtLink :to="`/practice/${question.exam_number}/${question.question_number}`">
          <span>模擬試験 {{ question.exam_number }}</span>
          <strong>問{{ question.question_number }}</strong>
          <small>{{ majorCategoryLabel(question.major_category_code) }} / {{ getCategoryLabel(question.category_code) }}</small>
        </NuxtLink>
        <button type="button" :aria-label="`問${question.question_number}をお気に入りから解除`" @click="remove(question.id)">
          <FavoriteStarIcon filled :size="32" />
        </button>
      </article>
    </div>
  </div>
</template>

<style scoped>
.empty-icon { width: 34px; height: 34px; color: #c78b00; }
.favorite-list { display: grid; gap: 12px; }
.favorite-card {
  min-width: 0;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 46px;
  align-items: center;
  gap: 14px;
  padding: 18px 20px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: #fff;
}
.favorite-card a { min-width: 0; display: grid; grid-template-columns: auto 1fr; align-items: center; gap: 5px 12px; color: var(--ink); text-decoration: none; }
.favorite-card a > span { color: var(--teal-dark); font-size: 13px; font-weight: 800; }
.favorite-card strong { font-size: 20px; }
.favorite-card small { grid-column: 1 / -1; color: var(--muted); }
.favorite-card button {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  padding: 0;
  border: 0;
  background: transparent;
  color: #f0b323;
  cursor: pointer;
  transition: color .15s, transform .15s;
}
.favorite-card button:hover { color: #c78b00; transform: scale(1.08); }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
</style>

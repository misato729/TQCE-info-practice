<script setup lang="ts">
const { isLoggedIn } = useAuth()
const { favoriteIds, isFavorite, toggleFavorite } = useDemoFavorites()
const config = useRuntimeConfig()

type ContentBlock = {
  type: 'text' | 'quote' | 'fill_in_text' | 'fill_in_quote' | 'fill_in_choice' | 'table' | 'code' | 'code_group'
  text?: string
  cells?: string[]
}

type Question = {
  id: number
  exam_number: number
  question_number: number
  content_blocks: ContentBlock[]
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

const questionExcerpt = (blocks: ContentBlock[]) => {
  const textBlock = blocks.find(block => (
    ['text', 'quote', 'fill_in_text', 'fill_in_quote'].includes(block.type) && block.text
  ))
  const text = textBlock?.text?.replace(/\{\{([^{}]+)\}\}/g, '$1')
    ?? blocks.find(block => block.type === 'fill_in_choice')?.cells?.join(' / ')
    ?? '問題文を確認する'
  return text.length > 120 ? `${text.slice(0, 119)}…` : text
}

watch(isLoggedIn, loadFavorites, { immediate: true })

const toggleFromList = (questionId: number) => toggleFavorite(questionId)
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>お気に入り一覧</h1><p>星アイコンからお気に入り登録した問題を確認できます。</p></header>
    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>お気に入りはログインユーザーのみ利用できます。</p>
      <NuxtLink class="primary-link" to="/login?redirect=/favorites">ログインへ</NuxtLink>
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
    <template v-else>
      <div class="favorite-summary">
        <strong>{{ favoriteQuestions.length }}件のお気に入り</strong>
        <span>最近追加した順</span>
      </div>

      <div class="favorite-list">
        <article
          v-for="question in favoriteQuestions"
          :key="question.id"
          class="favorite-card"
          :class="{ 'pending-removal': !isFavorite(question.id) }"
        >
          <div class="favorite-card-head">
            <span>模擬試験 {{ question.exam_number }}・問{{ question.question_number }}</span>
            <button
              class="favorite-toggle"
              type="button"
              :class="{ active: isFavorite(question.id) }"
              :aria-label="isFavorite(question.id)
                ? `問${question.question_number}をお気に入りから解除`
                : `問${question.question_number}をお気に入りに戻す`"
              :title="isFavorite(question.id) ? 'お気に入りから解除' : 'お気に入りに戻す'"
              @click="toggleFromList(question.id)"
            >
              <FavoriteStarIcon :filled="isFavorite(question.id)" :size="34" />
            </button>
          </div>

          <NuxtLink
            class="favorite-card-link"
            :to="`/practice/${question.exam_number}/${question.question_number}`"
          >
            <div class="favorite-question">
              <strong>{{ questionExcerpt(question.content_blocks) }}</strong>
              <small>
                {{ majorCategoryLabel(question.major_category_code) }} /
                {{ getCategoryLabel(question.category_code) }}
              </small>
            </div>

            <span class="review-link">問題を確認する <UIcon name="i-lucide-arrow-right" /></span>
          </NuxtLink>
        </article>
      </div>
    </template>
  </div>
</template>

<style scoped>
.empty-icon { width: 34px; height: 34px; color: #c78b00; }
.favorite-summary { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 14px; color: var(--muted); }
.favorite-summary strong { color: var(--ink); }
.favorite-list { display: grid; gap: 14px; }
.favorite-card {
  min-width: 0;
  display: grid;
  gap: 18px;
  padding: 22px 24px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: #fff;
  transition: border-color .15s, transform .15s, box-shadow .15s, background-color .15s;
}
.favorite-card:hover { border-color: #9dbfc1; transform: translateY(-1px); box-shadow: 0 8px 24px rgba(20, 48, 54, .08); }
.favorite-card.pending-removal { border-color: #d7dee0; background: #fbfcfc; }
.favorite-card-head { min-width: 0; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
.favorite-card-head > span { color: var(--teal-dark); font-size: 14px; font-weight: 800; }
.favorite-toggle {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  justify-self: end;
  padding: 0;
  border: 0;
  background: transparent;
  color: #718287;
  cursor: pointer;
  transition: color .15s, transform .15s;
}
.favorite-toggle.active { color: #f0b323; }
.favorite-toggle:hover { color: #c78b00; transform: scale(1.08); }
.favorite-card-link { min-width: 0; display: grid; gap: 18px; color: var(--ink); text-decoration: none; }
.favorite-question { min-width: 0; display: grid; gap: 7px; }
.favorite-question strong { overflow-wrap: anywhere; font-size: 18px; line-height: 1.65; }
.favorite-question small { color: var(--muted); }
.review-link { display: inline-flex; align-items: center; justify-self: end; gap: 6px; color: var(--teal-dark); font-size: 14px; font-weight: 800; }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 640px) {
  .favorite-card { padding: 18px; }
  .favorite-question strong { font-size: 16px; }
}
</style>

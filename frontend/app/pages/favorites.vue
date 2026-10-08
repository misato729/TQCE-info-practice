<script setup lang="ts">
type FavoriteItem = {
  id: number
  locked: boolean
  question: {
    id: number
    exam_number: number
    question_number: number
    body_excerpt?: string
    major_category_code?: string
    category_code?: string
  }
  created_at: string
}

type ApiResponse<T> = { data: T }

const config = useRuntimeConfig()
const { isLoggedIn, authHeaders, logout } = useAuth()
const { isFavorite, replaceFavorites, toggleFavorite } = useDemoFavorites()
const favorites = ref<FavoriteItem[]>([])
const loading = ref(false)
const loadError = ref('')
const removingId = ref<number | null>(null)

const loadFavorites = async () => {
  if (!isLoggedIn.value) {
    favorites.value = []
    replaceFavorites([])
    return
  }

  loading.value = true
  loadError.value = ''
  try {
    const response = await $fetch<ApiResponse<FavoriteItem[]>>('/api/v1/favorites', {
      baseURL: config.public.apiBase,
      headers: authHeaders.value,
    })
    favorites.value = response.data
    replaceFavorites(response.data.map(item => item.question.id))
  }
  catch (error: any) {
    if ((error?.statusCode ?? error?.status) === 401) logout()
    else loadError.value = 'お気に入りを読み込めませんでした。もう一度お試しください。'
  }
  finally {
    loading.value = false
  }
}

const toggleFromList = async (item: FavoriteItem) => {
  if (removingId.value) return
  removingId.value = item.id
  try {
    await toggleFavorite(item.question.id)
  }
  catch (error: any) {
    if ((error?.statusCode ?? error?.status) === 401) logout()
    else loadError.value = 'お気に入りを更新できませんでした。もう一度お試しください。'
  }
  finally {
    removingId.value = null
  }
}

const majorCategoryLabel = (code?: string) => (
  code ? MAJOR_CATEGORIES.find(item => item.value === code)?.label ?? code : ''
)

watch(isLoggedIn, loadFavorites, { immediate: true })
</script>

<template>
  <div class="page-wrap">
    <header class="page-intro"><h1>お気に入り一覧</h1><p>星アイコンから登録した問題を確認できます。</p></header>

    <div v-if="!isLoggedIn" class="empty-state">
      <h2>ログインが必要です</h2>
      <p>お気に入りはログインユーザーのみ利用できます。</p>
      <NuxtLink class="primary-link" to="/login?redirect=/favorites">ログインへ</NuxtLink>
    </div>

    <div v-else-if="loading" class="empty-state" aria-live="polite">
      <UIcon class="empty-icon spin" name="i-lucide-loader-circle" />
      <p>お気に入りを読み込んでいます。</p>
    </div>

    <div v-else-if="loadError && favorites.length === 0" class="empty-state">
      <h2>お気に入りを読み込めません</h2>
      <p>{{ loadError }}</p>
      <button class="secondary-link" type="button" @click="loadFavorites">再読み込み</button>
    </div>

    <div v-else-if="favorites.length === 0" class="empty-state">
      <UIcon class="empty-icon" name="i-lucide-star" />
      <h2>お気に入りはまだありません</h2>
      <p>問題画面の星アイコンから、お気に入りへ追加できます。</p>
      <NuxtLink class="primary-link" to="/practice/1/1">問題演習を始める</NuxtLink>
    </div>

    <template v-else>
      <p v-if="loadError" class="form-error" role="alert">{{ loadError }}</p>
      <div class="favorite-summary"><strong>{{ favorites.length }}件のお気に入り</strong><span>最近追加した順</span></div>
      <div class="favorite-list">
        <article
          v-for="item in favorites"
          :key="item.id"
          class="favorite-card"
          :class="{ locked: item.locked, 'pending-removal': !isFavorite(item.question.id) }"
        >
          <div class="favorite-card-head">
            <span>模擬試験 {{ item.question.exam_number }}・問{{ item.question.question_number }}</span>
            <button
              class="favorite-toggle"
              :class="{ active: isFavorite(item.question.id) }"
              type="button"
              :disabled="removingId === item.id"
              :aria-label="isFavorite(item.question.id)
                ? `問${item.question.question_number}をお気に入りから解除`
                : `問${item.question.question_number}をお気に入りに戻す`"
              :title="isFavorite(item.question.id) ? 'お気に入りから解除' : 'お気に入りに戻す'"
              @click="toggleFromList(item)"
            >
              <FavoriteStarIcon :filled="isFavorite(item.question.id)" :size="34" />
            </button>
          </div>

          <template v-if="item.locked">
            <div class="locked-content">
              <UIcon name="i-lucide-lock-keyhole" />
              <div><strong>有料会員向けの問題です</strong><p>問題文と分類は、資格が有効になった後に表示されます。</p></div>
            </div>
            <NuxtLink class="primary-link premium-link" to="/premium">有料会員について確認する</NuxtLink>
          </template>

          <NuxtLink v-else class="favorite-card-link" :to="`/practice/${item.question.exam_number}/${item.question.question_number}`">
            <div class="favorite-question">
              <strong>{{ item.question.body_excerpt || '問題文を確認する' }}</strong>
              <small>{{ majorCategoryLabel(item.question.major_category_code) }} / {{ getCategoryLabel(item.question.category_code || '') }}</small>
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
.favorite-card { min-width: 0; display: grid; gap: 18px; padding: 22px 24px; border: 1px solid var(--line); border-radius: 8px; background: #fff; transition: border-color .15s, transform .15s, box-shadow .15s, background-color .15s; }
.favorite-card:not(.locked):hover { border-color: #9dbfc1; transform: translateY(-1px); box-shadow: 0 8px 24px rgba(20, 48, 54, .08); }
.favorite-card.locked { border-color: #cad3d5; background: #f8fafa; }
.favorite-card.pending-removal { border-color: #d7dee0; background: #fbfcfc; }
.favorite-card-head { min-width: 0; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
.favorite-card-head > span { color: var(--teal-dark); font-size: 14px; font-weight: 800; }
.favorite-toggle { width: 42px; height: 42px; display: grid; place-items: center; padding: 0; border: 0; background: transparent; color: #718287; cursor: pointer; transition: color .15s, transform .15s; }
.favorite-toggle.active { color: #f0b323; }
.favorite-toggle:hover { color: #c78b00; transform: scale(1.08); }
.favorite-toggle:disabled { opacity: .5; cursor: wait; }
.favorite-card-link { min-width: 0; display: grid; gap: 18px; color: var(--ink); text-decoration: none; }
.favorite-question { min-width: 0; display: grid; gap: 7px; }
.favorite-question strong { overflow-wrap: anywhere; font-size: 18px; line-height: 1.65; }
.favorite-question small { color: var(--muted); }
.review-link { display: inline-flex; align-items: center; justify-self: end; gap: 6px; color: var(--teal-dark); font-size: 14px; font-weight: 800; }
.locked-content { display: grid; grid-template-columns: 30px 1fr; gap: 12px; align-items: start; color: #53676e; }
.locked-content :deep(svg) { width: 27px; height: 27px; }
.locked-content strong { color: var(--ink); }
.locked-content p { margin: 5px 0 0; line-height: 1.7; }
.premium-link { justify-self: end; }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
@media (max-width: 640px) {
  .favorite-card { padding: 18px; }
  .favorite-question strong { font-size: 16px; }
}
</style>

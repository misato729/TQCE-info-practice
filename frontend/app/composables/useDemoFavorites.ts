type FavoriteResponse = {
  data: {
    question: { id: number }
  }
}

export const useDemoFavorites = () => {
  const config = useRuntimeConfig()
  const { authHeaders } = useAuth()
  const favoriteIds = useState<number[]>('favorite-question-ids', () => [])

  const isFavorite = (questionId: number) => favoriteIds.value.includes(questionId)

  const setFavorite = (questionId: number, favorite: boolean) => {
    favoriteIds.value = favorite
      ? Array.from(new Set([questionId, ...favoriteIds.value]))
      : favoriteIds.value.filter(id => id !== questionId)
  }

  const replaceFavorites = (questionIds: number[]) => {
    favoriteIds.value = Array.from(new Set(questionIds))
  }

  const toggleFavorite = async (questionId: number) => {
    if (isFavorite(questionId)) {
      await $fetch(`/api/v1/questions/${questionId}/favorite`, {
        baseURL: config.public.apiBase,
        method: 'DELETE',
        headers: authHeaders.value,
      })
      setFavorite(questionId, false)
      return false
    }

    const response = await $fetch<FavoriteResponse>(`/api/v1/questions/${questionId}/favorite`, {
      baseURL: config.public.apiBase,
      method: 'PUT',
      headers: authHeaders.value,
    })
    setFavorite(response.data.question.id, true)
    return true
  }

  const removeFavorite = async (questionId: number) => {
    if (isFavorite(questionId)) await toggleFavorite(questionId)
  }

  return {
    favoriteIds: readonly(favoriteIds),
    isFavorite,
    setFavorite,
    replaceFavorites,
    toggleFavorite,
    removeFavorite,
  }
}

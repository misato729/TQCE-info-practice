export const useDemoFavorites = () => {
  const favoriteIds = useCookie<number[]>('tqce-demo-favorites', {
    default: () => [],
    maxAge: 60 * 60 * 24 * 365,
    sameSite: 'lax',
  })

  const normalizedFavoriteIds = computed(() => (
    Array.isArray(favoriteIds.value)
      ? favoriteIds.value.filter(id => Number.isInteger(id) && id > 0)
      : []
  ))

  const isFavorite = (questionId: number) => normalizedFavoriteIds.value.includes(questionId)

  const toggleFavorite = (questionId: number) => {
    favoriteIds.value = isFavorite(questionId)
      ? normalizedFavoriteIds.value.filter(id => id !== questionId)
      : [questionId, ...normalizedFavoriteIds.value]
  }

  const removeFavorite = (questionId: number) => {
    favoriteIds.value = normalizedFavoriteIds.value.filter(id => id !== questionId)
  }

  return {
    favoriteIds: normalizedFavoriteIds,
    isFavorite,
    toggleFavorite,
    removeFavorite,
  }
}

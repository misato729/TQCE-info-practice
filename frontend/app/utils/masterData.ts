export type MasterDataItem<T extends string = string> = {
  value: T
  label: string
}

export const USER_ROLES = [
  { value: 'user', label: '一般ユーザー' },
  { value: 'admin', label: '管理者' },
] as const satisfies readonly MasterDataItem[]

export const MAJOR_CATEGORIES = [
  { value: 'teacher_education', label: '教職教養' },
  { value: 'information', label: '情報科特有' },
] as const satisfies readonly MasterDataItem[]

export const CATEGORIES = [
  { value: 'education_history', label: '教育史', majorCategoryValue: 'teacher_education' },
  { value: 'education_law', label: '教育法規', majorCategoryValue: 'teacher_education' },
  { value: 'curriculum_guideline', label: '学習指導要領', majorCategoryValue: 'teacher_education' },
  { value: 'student_guidance', label: '生徒指導提要', majorCategoryValue: 'teacher_education' },
  { value: 'educational_psychology', label: '教育心理', majorCategoryValue: 'teacher_education' },
  { value: 'new_japanese_school_education', label: '令和の日本型学校教育', majorCategoryValue: 'teacher_education' },
  { value: 'information_curriculum_guideline', label: '学習指導要領(情報)', majorCategoryValue: 'information' },
  { value: 'algorithm', label: 'アルゴリズム', majorCategoryValue: 'information' },
  { value: 'data_science', label: 'データサイエンス', majorCategoryValue: 'information' },
] as const

export const DIFFICULTIES = [
  { value: 'star1', label: '★' },
  { value: 'star2', label: '★★' },
  { value: 'star3', label: '★★★' },
] as const satisfies readonly MasterDataItem[]

export const PUBLICATION_STATUSES = [
  { value: 'draft', label: '下書き' },
  { value: 'published', label: '公開' },
  { value: 'private', label: '非公開' },
] as const satisfies readonly MasterDataItem[]

export const QUESTION_REPORT_STATUSES = [
  { value: 'unhandled', label: '未対応' },
  { value: 'in_progress', label: '対応中' },
  { value: 'fixed', label: '修正済み' },
  { value: 'rejected', label: '対応しない' },
] as const satisfies readonly MasterDataItem[]

export const PRACTICE_TYPES = [
  { value: 'practice', label: '通常演習' },
  { value: 'mock_exam', label: '模擬試験' },
] as const satisfies readonly MasterDataItem[]

export const QUESTION_CONDITION_TYPES = [
  { value: 'all', label: '全分野' },
  { value: 'major_category', label: '大分類指定' },
  { value: 'category', label: '小分類指定' },
] as const satisfies readonly MasterDataItem[]

export const EXTRA_CONDITIONS = [
  { value: 'none', label: '指定なし' },
  { value: 'favorite', label: 'お気に入り問題のみ' },
  { value: 'incorrect', label: '間違えた問題のみ' },
  { value: 'unanswered', label: '未回答の問題のみ' },
] as const satisfies readonly MasterDataItem[]

export const MEDALS = [
  { value: 'none', label: 'なし' },
  { value: 'bronze', label: '銅メダル' },
  { value: 'silver', label: '銀メダル' },
  { value: 'gold', label: '金メダル' },
] as const satisfies readonly MasterDataItem[]

export const MOCK_EXAM_CATEGORY_COUNTS = [
  { categoryCode: 'education_history', questionCount: 2 },
  { categoryCode: 'education_law', questionCount: 3 },
  { categoryCode: 'curriculum_guideline', questionCount: 5 },
  { categoryCode: 'student_guidance', questionCount: 1 },
  { categoryCode: 'educational_psychology', questionCount: 3 },
  { categoryCode: 'new_japanese_school_education', questionCount: 1 },
  { categoryCode: 'information_curriculum_guideline', questionCount: 3 },
  { categoryCode: 'algorithm', questionCount: 1 },
  { categoryCode: 'data_science', questionCount: 1 },
] as const

export const MOCK_EXAM_QUESTION_COUNT = 20
export const MOCK_EXAM_PASSING_SCORE = 12

export const getMasterDataLabel = <T extends string>(
  items: readonly MasterDataItem<T>[],
  value: T,
) => items.find((item) => item.value === value)?.label ?? value

export const getCategoryLabel = (value: string) =>
  CATEGORIES.find((category) => category.value === value)?.label ?? value

export const getCategoriesByMajorCategory = (majorCategoryValue: string) =>
  CATEGORIES.filter((category) => category.majorCategoryValue === majorCategoryValue)

export const getMedalByConsecutiveCorrectCount = (count: number) => {
  if (count >= 3) return 'gold'
  if (count === 2) return 'silver'
  if (count === 1) return 'bronze'
  return 'none'
}

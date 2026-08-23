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
  { value: 'education_foundations', label: '1.1 教育基礎総論', majorCategoryValue: 'teacher_education' },
  { value: 'teaching_profession', label: '1.2 教職概論', majorCategoryValue: 'teacher_education' },
  { value: 'education_system', label: '1.3 教育制度総論', majorCategoryValue: 'teacher_education' },
  { value: 'educational_psychology', label: '1.4 教育心理学', majorCategoryValue: 'teacher_education' },
  { value: 'special_support_education', label: '1.5 特別支援教育', majorCategoryValue: 'teacher_education' },
  { value: 'curriculum_organization', label: '1.6 教育課程編成論', majorCategoryValue: 'teacher_education' },
  { value: 'moral_education', label: '2.0 道徳教育論', majorCategoryValue: 'teacher_education' },
  { value: 'integrated_inquiry', label: '2.1 総合的な学習・探究論', majorCategoryValue: 'teacher_education' },
  { value: 'special_activities', label: '2.2 特別活動論', majorCategoryValue: 'teacher_education' },
  { value: 'education_methods', label: '2.3 教育方法・技術論', majorCategoryValue: 'teacher_education' },
  { value: 'ict_in_education', label: '2.4 教育におけるICT活用', majorCategoryValue: 'teacher_education' },
  { value: 'student_guidance_career', label: '2.5 生徒指導・進路指導論', majorCategoryValue: 'teacher_education' },
  { value: 'educational_counseling', label: '2.6 生徒理解と教育相談', majorCategoryValue: 'teacher_education' },
  { value: 'career_education', label: '2.7 生徒指導・進路指導論', majorCategoryValue: 'teacher_education' },
  { value: 'information_specialized', label: '3.1 情報科専門科目', majorCategoryValue: 'information' },
  { value: 'information_education', label: '3.2 情報科教育法', majorCategoryValue: 'information' },
] as const

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

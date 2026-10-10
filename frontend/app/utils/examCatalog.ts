export type ExamCatalogEntry = {
  exam_number: number
  question_numbers: readonly number[]
}

export const FREE_EXAM_MAX = 5

// サイドバー表示のためにRailsを起動しないよう、公開済み問題数をリリース時に固定する。
// 問題を公開・非公開にする変更では、この一覧も同じ変更内で更新すること。
const publishedQuestionCounts = [
  20, 20, 20, 20, 20,
  20, 20, 20, 20, 20,
  20, 20, 20, 20, 20,
  20, 20, 20, 20, 20,
  20, 20, 20, 20, 20,
] as const

export const EXAM_CATALOG: readonly ExamCatalogEntry[] = Object.freeze(
  publishedQuestionCounts.map((questionCount, index) => Object.freeze({
    exam_number: index + 1,
    question_numbers: Object.freeze(
      Array.from({ length: questionCount }, (_, questionIndex) => questionIndex + 1),
    ),
  })),
)

export const FREE_EXAM_CATALOG = EXAM_CATALOG.filter(
  exam => exam.exam_number <= FREE_EXAM_MAX,
)

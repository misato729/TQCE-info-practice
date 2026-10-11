export type ExamCatalogEntry = {
  exam_number: number
  question_numbers: readonly number[]
}

export const FREE_EXAM_MAX = 5
export const EXAM_SET_COUNT = 50
export const QUESTIONS_PER_EXAM = 20

// 問題データの登録前でも各模試へ遷移できるよう、1〜50の導線を固定で用意する。
// 実際に問題を表示できるかは、APIの公開状態と利用権限の判定に従う。

export const EXAM_CATALOG: readonly ExamCatalogEntry[] = Object.freeze(
  Array.from({ length: EXAM_SET_COUNT }, (_, index) => Object.freeze({
    exam_number: index + 1,
    question_numbers: Object.freeze(
      Array.from({ length: QUESTIONS_PER_EXAM }, (_, questionIndex) => questionIndex + 1),
    ),
  })),
)

export const FREE_EXAM_CATALOG = EXAM_CATALOG.filter(
  exam => exam.exam_number <= FREE_EXAM_MAX,
)

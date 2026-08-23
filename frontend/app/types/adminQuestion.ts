export type ContentBlockType =
  | 'text'
  | 'quote'
  | 'table'
  | 'code'
  | 'code_group'
  | 'fill_in_text'
  | 'fill_in_quote'
  | 'fill_in_choice'

export type ContentBlock = {
  type: ContentBlockType
  text?: string
  source?: string
  title?: string
  code?: string
  headers?: string[]
  rows?: string[][]
  items?: { title: string, code: string }[]
  cells?: string[]
}

export type AdminChoice = {
  id?: number
  choice_label: string
  content_blocks: ContentBlock[]
  is_correct: boolean
  display_order: number
}

export type AdminQuestionInput = {
  exam_number: number
  question_number: number
  content_blocks: ContentBlock[]
  major_category_code: string
  category_code: string
  explanation_blocks: ContentBlock[]
  source_text: string
  publication_status: string
  choices: AdminChoice[]
}

export type AdminQuestion = AdminQuestionInput & {
  id: number
  created_at: string
  updated_at: string
}

export type AdminQuestionSummary = {
  id: number
  exam_number: number
  question_number: number
  summary: string
  major_category_code: string
  category_code: string
  publication_status: string
  updated_at: string
}

export type ApiResponse<T> = { data: T }

export type PaginatedApiResponse<T> = {
  data: T[]
  meta: {
    current_page: number
    per_page: number
    total_count: number
    total_pages: number
  }
}

export const createEmptyQuestion = (): AdminQuestionInput => ({
  exam_number: 1,
  question_number: 1,
  content_blocks: [{ type: 'text', text: '' }],
  major_category_code: 'teacher_education',
  category_code: 'education_foundations',
  explanation_blocks: [{ type: 'text', text: '' }],
  source_text: '',
  publication_status: 'draft',
  choices: ['ア', 'イ', 'ウ', 'エ'].map((label, index) => ({
    choice_label: label,
    content_blocks: [{ type: 'text', text: '' }],
    is_correct: index === 0,
    display_order: index + 1,
  })),
})

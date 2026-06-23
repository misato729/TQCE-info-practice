# frozen_string_literal: true

module MasterData
  USER_ROLES = [
    { value: 'user', label: '一般ユーザー' },
    { value: 'admin', label: '管理者' }
  ].freeze

  MAJOR_CATEGORIES = [
    { value: 'teacher_education', label: '教職教養' },
    { value: 'information', label: '情報科特有' }
  ].freeze

  CATEGORIES = [
    { value: 'education_history', label: '教育史', major_category_value: 'teacher_education' },
    { value: 'education_law', label: '教育法規', major_category_value: 'teacher_education' },
    { value: 'curriculum_guideline', label: '学習指導要領', major_category_value: 'teacher_education' },
    { value: 'student_guidance', label: '生徒指導提要', major_category_value: 'teacher_education' },
    { value: 'educational_psychology', label: '教育心理', major_category_value: 'teacher_education' },
    { value: 'new_japanese_school_education', label: '令和の日本型学校教育', major_category_value: 'teacher_education' },
    { value: 'information_curriculum_guideline', label: '学習指導要領(情報)', major_category_value: 'information' },
    { value: 'algorithm', label: 'アルゴリズム', major_category_value: 'information' },
    { value: 'data_science', label: 'データサイエンス', major_category_value: 'information' }
  ].freeze

  DIFFICULTIES = [
    { value: 'star1', label: '★' },
    { value: 'star2', label: '★★' },
    { value: 'star3', label: '★★★' }
  ].freeze

  PUBLICATION_STATUSES = [
    { value: 'draft', label: '下書き' },
    { value: 'published', label: '公開' },
    { value: 'private', label: '非公開' }
  ].freeze

  QUESTION_REPORT_STATUSES = [
    { value: 'unhandled', label: '未対応' },
    { value: 'in_progress', label: '対応中' },
    { value: 'fixed', label: '修正済み' },
    { value: 'rejected', label: '対応しない' }
  ].freeze

  PRACTICE_TYPES = [
    { value: 'practice', label: '通常演習' },
    { value: 'mock_exam', label: '模擬試験' }
  ].freeze

  QUESTION_CONDITION_TYPES = [
    { value: 'all', label: '全分野' },
    { value: 'major_category', label: '大分類指定' },
    { value: 'category', label: '小分類指定' }
  ].freeze

  EXTRA_CONDITIONS = [
    { value: 'none', label: '指定なし' },
    { value: 'favorite', label: 'お気に入り問題のみ' },
    { value: 'incorrect', label: '間違えた問題のみ' },
    { value: 'unanswered', label: '未回答の問題のみ' }
  ].freeze

  MEDALS = [
    { value: 'none', label: 'なし' },
    { value: 'bronze', label: '銅メダル' },
    { value: 'silver', label: '銀メダル' },
    { value: 'gold', label: '金メダル' }
  ].freeze

  MOCK_EXAM_CATEGORY_COUNTS = [
    { category_code: 'education_history', question_count: 2 },
    { category_code: 'education_law', question_count: 3 },
    { category_code: 'curriculum_guideline', question_count: 5 },
    { category_code: 'student_guidance', question_count: 1 },
    { category_code: 'educational_psychology', question_count: 3 },
    { category_code: 'new_japanese_school_education', question_count: 1 },
    { category_code: 'information_curriculum_guideline', question_count: 3 },
    { category_code: 'algorithm', question_count: 1 },
    { category_code: 'data_science', question_count: 1 }
  ].freeze

  MOCK_EXAM_QUESTION_COUNT = 20
  MOCK_EXAM_PASSING_SCORE = 12

  module_function

  def values(items)
    items.map { |item| item[:value] }
  end

  def label_for(items, value)
    items.find { |item| item[:value] == value }&.fetch(:label) || value
  end

  def categories_by_major_category(major_category_value)
    CATEGORIES.select { |category| category[:major_category_value] == major_category_value }
  end

  def medal_by_consecutive_correct_count(count)
    return 'gold' if count >= 3
    return 'silver' if count == 2
    return 'bronze' if count == 1

    'none'
  end
end

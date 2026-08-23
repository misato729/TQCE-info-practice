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
    { value: 'education_foundations', label: '1.1 教育基礎総論', major_category_value: 'teacher_education' },
    { value: 'teaching_profession', label: '1.2 教職概論', major_category_value: 'teacher_education' },
    { value: 'education_system', label: '1.3 教育制度総論', major_category_value: 'teacher_education' },
    { value: 'educational_psychology', label: '1.4 教育心理学', major_category_value: 'teacher_education' },
    { value: 'special_support_education', label: '1.5 特別支援教育', major_category_value: 'teacher_education' },
    { value: 'curriculum_organization', label: '1.6 教育課程編成論', major_category_value: 'teacher_education' },
    { value: 'moral_education', label: '2.0 道徳教育論', major_category_value: 'teacher_education' },
    { value: 'integrated_inquiry', label: '2.1 総合的な学習・探究論', major_category_value: 'teacher_education' },
    { value: 'special_activities', label: '2.2 特別活動論', major_category_value: 'teacher_education' },
    { value: 'education_methods', label: '2.3 教育方法・技術論', major_category_value: 'teacher_education' },
    { value: 'ict_in_education', label: '2.4 教育におけるICT活用', major_category_value: 'teacher_education' },
    { value: 'student_guidance_career', label: '2.5 生徒指導・進路指導論', major_category_value: 'teacher_education' },
    { value: 'educational_counseling', label: '2.6 生徒理解と教育相談', major_category_value: 'teacher_education' },
    { value: 'career_education', label: '2.7 生徒指導・進路指導論', major_category_value: 'teacher_education' },
    { value: 'information_specialized', label: '3.1 情報科専門科目', major_category_value: 'information' },
    { value: 'information_education', label: '3.2 情報科教育法', major_category_value: 'information' }
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

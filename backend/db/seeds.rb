%w[mock_exam_1.rb mock_exam_2.rb mock_exam_3.rb].each do |seed_file|
  load Rails.root.join("db/seeds", seed_file).to_s
end

standard_expected_categories = [
  "education_foundations",
  "education_foundations",
  "education_system",
  "education_system",
  "education_system",
  "curriculum_organization",
  "curriculum_organization",
  "integrated_inquiry",
  "moral_education",
  "special_activities",
  "student_guidance_career",
  "special_support_education",
  "educational_psychology",
  "educational_psychology",
  "education_system",
  "information_education",
  "information_education",
  "information_education",
  "information_specialized",
  "information_specialized",
].freeze

expected_categories_by_exam = {
  1 => standard_expected_categories,
  2 => standard_expected_categories.dup.tap { |categories| categories[6] = "career_education" }.freeze,
  3 => standard_expected_categories,
}.freeze

fill_in_prompt_pattern = /\A次の文章は，.+の「.+」からの抜粋である。文章中の空欄 \{\{①\}\} ～ \{\{[②③④⑤]\}\} に当てはまる語句の組合せとして正しいものを，下のア～エの中から一つ選んで記号で答えなさい。\z/

(1..3).each do |exam_number|
  exam_questions = Question.where(exam_number: exam_number).includes(:question_choices).order(:question_number).to_a

  unless exam_questions.map(&:question_number) == (1..20).to_a
    raise "模擬試験#{exam_number}は問1から問20までの20問で構成してください"
  end

  unless exam_questions.map(&:category_code) == expected_categories_by_exam.fetch(exam_number)
    raise "模擬試験#{exam_number}の出題分野または問題順が不正です"
  end

  exam_questions.each do |question|
    source_lines = question.source_text.to_s.lines.map(&:strip).reject(&:blank?)
    unless source_lines.any? && source_lines.all? { |line| line.match?(/\A.+\s\|\shttps:\/\/\S+\z/) }
      raise "模擬試験#{exam_number} 問#{question.question_number}の出典リンク形式が不正です"
    end

    unless question.content_blocks.any? && question.explanation_blocks.any?
      raise "模擬試験#{exam_number} 問#{question.question_number}の問題文または解説が空です"
    end

    question.content_blocks.select { |block| block["type"] == "fill_in_text" }.each do |block|
      unless block["text"].to_s.match?(fill_in_prompt_pattern)
        raise "模擬試験#{exam_number} 問#{question.question_number}の抜粋穴埋め問題の体裁が不正です"
      end
    end

    unless question.question_choices.size == 4 && question.question_choices.count(&:is_correct?) == 1
      raise "模擬試験#{exam_number} 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

%w[mock_exam_1.rb mock_exam_2.rb mock_exam_3.rb].each do |seed_file|
  load Rails.root.join("db/seeds", seed_file).to_s
end

expected_categories = [
  "education_history",
  "education_history",
  "education_law",
  "education_law",
  "education_law",
  "curriculum_guideline",
  "curriculum_guideline",
  "curriculum_guideline",
  "curriculum_guideline",
  "curriculum_guideline",
  "student_guidance",
  "educational_psychology",
  "educational_psychology",
  "educational_psychology",
  "new_japanese_school_education",
  "information_curriculum_guideline",
  "information_curriculum_guideline",
  "information_curriculum_guideline",
  "algorithm",
  "data_science",
].freeze

(1..3).each do |exam_number|
  exam_questions = Question.where(exam_number: exam_number).includes(:question_choices).order(:question_number).to_a

  unless exam_questions.map(&:question_number) == (1..20).to_a
    raise "模擬試験#{exam_number}は問1から問20までの20問で構成してください"
  end

  unless exam_questions.map(&:category_code) == expected_categories
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

    unless question.question_choices.size == 4 && question.question_choices.count(&:is_correct?) == 1
      raise "模擬試験#{exam_number} 問#{question.question_number}の選択肢または正答数が不正です"
    end
  end
end

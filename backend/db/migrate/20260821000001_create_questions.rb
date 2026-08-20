class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.integer :exam_number, null: false
      t.integer :question_number, null: false
      t.string :major_category_code, null: false, limit: 50
      t.string :category_code, null: false, limit: 100
      t.jsonb :content_blocks, null: false, default: []
      t.jsonb :explanation_blocks, null: false, default: []
      t.string :difficulty, null: false, limit: 20
      t.text :source_text
      t.string :publication_status, null: false, default: "draft", limit: 20

      t.timestamps
    end

    add_index :questions, %i[exam_number question_number], unique: true
    add_index :questions, %i[exam_number publication_status question_number], name: "index_questions_for_practice"
    add_index :questions, :major_category_code
    add_index :questions, :category_code
    add_index :questions, :difficulty
    add_index :questions, %i[publication_status id]

    add_check_constraint :questions, "exam_number >= 1", name: "questions_exam_number_positive"
    add_check_constraint :questions, "question_number BETWEEN 1 AND 20", name: "questions_question_number_range"
  end
end

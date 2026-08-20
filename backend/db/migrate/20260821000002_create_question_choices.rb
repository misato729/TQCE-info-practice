class CreateQuestionChoices < ActiveRecord::Migration[7.1]
  def change
    create_table :question_choices do |t|
      t.references :question, null: false, foreign_key: { on_delete: :cascade }
      t.string :choice_label, null: false, limit: 10
      t.jsonb :content_blocks, null: false, default: []
      t.boolean :is_correct, null: false, default: false
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :question_choices, %i[question_id choice_label], unique: true
    add_index :question_choices, %i[question_id display_order], unique: true
    add_index :question_choices, :question_id,
      unique: true,
      where: "is_correct = true",
      name: "index_question_choices_one_correct_answer"
    add_check_constraint :question_choices, "display_order BETWEEN 1 AND 4", name: "question_choices_display_order_range"
  end
end

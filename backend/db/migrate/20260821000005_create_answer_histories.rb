class CreateAnswerHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :answer_histories do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :question, null: false, foreign_key: { on_delete: :cascade }
      t.bigint :selected_choice_id, null: false
      t.boolean :is_correct, null: false

      t.timestamps
    end

    add_foreign_key :answer_histories, :question_choices, column: :selected_choice_id
    add_index :answer_histories, %i[user_id created_at], order: { created_at: :desc }
    add_index :answer_histories, %i[user_id question_id]
    add_index :answer_histories, :selected_choice_id
  end
end

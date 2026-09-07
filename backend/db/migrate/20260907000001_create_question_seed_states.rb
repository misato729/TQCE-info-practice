class CreateQuestionSeedStates < ActiveRecord::Migration[7.1]
  def change
    create_table :question_seed_states do |t|
      t.integer :exam_number, null: false
      t.integer :question_number, null: false
      t.string :seed_digest
      t.string :seed_publication_status
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
    add_index :question_seed_states, [:exam_number, :question_number], unique: true
  end
end

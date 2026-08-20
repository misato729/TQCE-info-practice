class RemoveDifficultyFromQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :difficulty, :string
  end
end

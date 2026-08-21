class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 100
      t.string :email, null: false, limit: 255
      t.string :password_digest, null: false
      t.string :role, null: false, default: "user", limit: 20

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_check_constraint :users, "role IN ('user', 'admin')", name: "users_role_valid"
  end
end

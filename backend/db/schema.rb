# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_08_21_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.bigint "selected_choice_id", null: false
    t.boolean "is_correct", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answer_histories_on_question_id"
    t.index ["selected_choice_id"], name: "index_answer_histories_on_selected_choice_id"
    t.index ["user_id", "created_at"], name: "index_answer_histories_on_user_id_and_created_at", order: { created_at: :desc }
    t.index ["user_id", "question_id"], name: "index_answer_histories_on_user_id_and_question_id"
    t.index ["user_id"], name: "index_answer_histories_on_user_id"
  end

  create_table "question_choices", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "choice_label", limit: 10, null: false
    t.jsonb "content_blocks", default: [], null: false
    t.boolean "is_correct", default: false, null: false
    t.integer "display_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "choice_label"], name: "index_question_choices_on_question_id_and_choice_label", unique: true
    t.index ["question_id", "display_order"], name: "index_question_choices_on_question_id_and_display_order", unique: true
    t.index ["question_id"], name: "index_question_choices_on_question_id"
    t.index ["question_id"], name: "index_question_choices_one_correct_answer", unique: true, where: "(is_correct = true)"
    t.check_constraint "display_order >= 1 AND display_order <= 4", name: "question_choices_display_order_range"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "exam_number", null: false
    t.integer "question_number", null: false
    t.string "major_category_code", limit: 50, null: false
    t.string "category_code", limit: 100, null: false
    t.jsonb "content_blocks", default: [], null: false
    t.jsonb "explanation_blocks", default: [], null: false
    t.text "source_text"
    t.string "publication_status", limit: 20, default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_code"], name: "index_questions_on_category_code"
    t.index ["exam_number", "publication_status", "question_number"], name: "index_questions_for_practice"
    t.index ["exam_number", "question_number"], name: "index_questions_on_exam_number_and_question_number", unique: true
    t.index ["major_category_code"], name: "index_questions_on_major_category_code"
    t.index ["publication_status", "id"], name: "index_questions_on_publication_status_and_id"
    t.check_constraint "exam_number >= 1", name: "questions_exam_number_positive"
    t.check_constraint "question_number >= 1 AND question_number <= 20", name: "questions_question_number_range"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 255, null: false
    t.string "password_digest", null: false
    t.string "role", limit: 20, default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.check_constraint "role::text = ANY (ARRAY['user'::character varying, 'admin'::character varying]::text[])", name: "users_role_valid"
  end

  add_foreign_key "answer_histories", "question_choices", column: "selected_choice_id"
  add_foreign_key "answer_histories", "questions", on_delete: :cascade
  add_foreign_key "answer_histories", "users", on_delete: :cascade
  add_foreign_key "question_choices", "questions", on_delete: :cascade
end

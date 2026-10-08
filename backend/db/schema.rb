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

ActiveRecord::Schema[7.1].define(version: 2026_10_08_000002) do
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

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_favorites_on_question_id"
    t.index ["user_id", "created_at"], name: "index_favorites_on_user_id_and_created_at"
    t.index ["user_id", "question_id"], name: "index_favorites_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "source_payment_id", null: false
    t.string "status", limit: 20, default: "active", null: false
    t.datetime "activated_at", null: false
    t.datetime "revoked_at"
    t.string "revocation_reason", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_payment_id"], name: "index_memberships_on_source_payment_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id", unique: true
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying::text, 'revoked'::character varying::text])", name: "memberships_status_valid"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "stripe_checkout_session_id", null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_charge_id"
    t.string "stripe_price_id", null: false
    t.integer "amount", default: 500, null: false
    t.integer "refunded_amount", default: 0, null: false
    t.string "currency", limit: 3, default: "jpy", null: false
    t.string "status", limit: 30, default: "pending", null: false
    t.datetime "paid_at"
    t.datetime "refunded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_dispute_id"
    t.string "dispute_status", limit: 30
    t.datetime "dispute_closed_at"
    t.string "last_refund_failure_reason", limit: 100
    t.datetime "last_refund_failed_at"
    t.index ["status", "updated_at"], name: "index_payments_on_status_and_updated_at"
    t.index ["stripe_charge_id"], name: "index_payments_on_stripe_charge_id", unique: true, where: "(stripe_charge_id IS NOT NULL)"
    t.index ["stripe_checkout_session_id"], name: "index_payments_on_stripe_checkout_session_id", unique: true
    t.index ["stripe_dispute_id"], name: "index_payments_on_stripe_dispute_id", unique: true, where: "(stripe_dispute_id IS NOT NULL)"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id", unique: true, where: "(stripe_payment_intent_id IS NOT NULL)"
    t.index ["user_id", "created_at"], name: "index_payments_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_payments_on_user_id"
    t.index ["user_id"], name: "index_payments_one_pending_per_user", unique: true, where: "(((status)::text = 'pending'::text) AND (user_id IS NOT NULL))"
    t.check_constraint "amount > 0", name: "payments_amount_positive"
    t.check_constraint "currency::text = 'jpy'::text", name: "payments_currency_valid"
    t.check_constraint "refunded_amount >= 0 AND refunded_amount <= amount", name: "payments_refunded_amount_range"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying::text, 'paid'::character varying::text, 'expired'::character varying::text, 'partially_refunded'::character varying::text, 'refunded'::character varying::text, 'disputed'::character varying::text])", name: "payments_status_valid"
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

  create_table "question_seed_states", force: :cascade do |t|
    t.integer "exam_number", null: false
    t.integer "question_number", null: false
    t.string "seed_digest"
    t.string "seed_publication_status"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_number", "question_number"], name: "index_question_seed_states_on_exam_number_and_question_number", unique: true
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

  create_table "stripe_webhook_events", force: :cascade do |t|
    t.string "stripe_event_id", null: false
    t.string "event_type", null: false
    t.boolean "livemode", null: false
    t.datetime "processed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type", "processed_at"], name: "index_stripe_webhook_events_on_event_type_and_processed_at"
    t.index ["stripe_event_id"], name: "index_stripe_webhook_events_on_stripe_event_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 255, null: false
    t.string "password_digest", null: false
    t.string "role", limit: 20, default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.check_constraint "role::text = ANY (ARRAY['user'::character varying::text, 'admin'::character varying::text])", name: "users_role_valid"
  end

  add_foreign_key "answer_histories", "question_choices", column: "selected_choice_id"
  add_foreign_key "answer_histories", "questions", on_delete: :cascade
  add_foreign_key "answer_histories", "users", on_delete: :cascade
  add_foreign_key "favorites", "questions", on_delete: :cascade
  add_foreign_key "favorites", "users", on_delete: :cascade
  add_foreign_key "memberships", "payments", column: "source_payment_id"
  add_foreign_key "memberships", "users", on_delete: :cascade
  add_foreign_key "payments", "users", on_delete: :nullify
  add_foreign_key "question_choices", "questions", on_delete: :cascade
end

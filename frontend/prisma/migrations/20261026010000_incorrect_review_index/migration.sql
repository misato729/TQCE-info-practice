BEGIN;
CREATE INDEX "index_answer_histories_for_latest_by_question"
ON "answer_histories"("user_id", "question_id", "created_at" DESC, "id" DESC);
COMMIT;

# 承認済み問題の表示検査用fixture

`mock_exams_21_to_25_guidance_psychology_report_approved.json` は、模擬試験21〜25の問11〜15の承認済み草案を凍結した既存の検査資料です。旧 `backend/test/fixtures/` からバイト単位で変更せず移設しています。承認・原典検査の過去記録は [実装記録](../模試21〜25_問11〜15実装記録_2026-10-09.md) に残しています。

現行の `QuestionContentBlocks.vue` を使い、抜粋・空欄・選択肢・表・注記を表示できることを確認します。DBやAPIへの投入・同期は行いません。実問題の正本はDBであり、このfixtureを起動・seed・デプロイ時に取り込まないでください。

リポジトリルートで内容の同一性を検査できます。

```sh
cd document/question-review-fixtures
shasum -a 256 -c SHA256SUMS
```

表示検査は `frontend/` から実行します。

```sh
node scripts/check-mock-exams-21-to-25-question-11-to-15.mjs
```

旧Railsのコード・テスト一式はローカル保管先または削除前のGit履歴を参照します。この資料は現行の表示検査が直接必要とするJSONだけを保持するものです。

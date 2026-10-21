# 承認済み問題の凍結回帰資料

2026年10月21日の問題seed廃止に伴い、承認済み問題の品質・原典照合・変異検査を残すために旧問題ファイルを移設した。これは本番DBの正本、初期投入マスタ、復元元又は通常運用の同期元ではない。現在の問題の作成・編集・削除は管理画面から行う。

## 保存したもの

- `mock_exam_1.rb` から `mock_exam_50.rb`：承認時点の全50セット・1,000問・4,000選択肢。移設元は `backend/db/seeds/`、元コミットは `3aa6f15`。
- `legacy_digests_20260907.json`：旧移行前225問の固定比較値。現在の問題から作り直していない。
- `SHA256SUMS`：移設前に取得した上記51ファイルのSHA-256。移設後も全ファイルのバイト一致を確認した。

既存の原典fixture、承認snapshot及び改稿前後の固定ハッシュは従来の場所に保持している。これらの期待値を現在の問題に合わせて再生成していない。

## 実行の境界

旧Rubyファイル末尾の検証処理を含め、過去の承認内容と検出能力をそのまま確認する。`test/seeds/` という既存のテストフォルダ名も過去との対応を追うために維持するが、実行用seedへの依存はない。

- `test/support/legacy_question_catalog.rb` は旧収集・同期処理、旧状態モデル及び旧payload変換をテスト専用に保持する。`test_helper.rb` だけから読み込み、`Rails.env.test?` 以外では読み込みを拒否する。
- `test/support/legacy_question_catalog_validation.rb` は旧全体検査の凍結資料であり、同じテスト環境制限を持つ。
- これらはアプリケーションのautoload・管理API・デプロイ処理から呼び出さない。`backend/.dockerignore` で `test/` 全体を本番イメージから除外する。
- 古い再同期・競合検査は、当時の改稿・承認の回帰検査である。現在もseedを運用するという意味ではない。
- `question_seed_states` の実テーブルは旧リリースとのrolling互換性及び歴史検査のため当面保持する。現行アプリの問題編集・削除はこのテーブルを参照しない。

新しい問題の変更を反映させる目的で、この凍結資料や `SHA256SUMS` を書き換えない。管理画面での訂正について新しい検証記録が必要な場合は、その変更と独立した根拠・新しい回帰検査を追加する。

## 移設時の内容照合値

読み取り専用のcollectorで取得した1,000件を試験番号・問番号順に並べ、各問を次の配列へ変換して `JSON.generate` したSHA-256は以下のとおり。

```text
[exam_number, question_number, publication_status,
 QuestionPayload.digest(QuestionPayload.from_seed(exam_number, attributes))]

b2e67e8fc7adb766ca6d0bd0cd3df11545c49ecef526c296ce7a812c048b5c32
```

取得時は全1,000問が `published`。この値は本番内容との最終照合用であり、実際に本番DBが一致したという検証結果は別途記録する。

ファイル単位の照合は、このフォルダを作業ディレクトリとして次を実行する。

```sh
shasum -a 256 -c SHA256SUMS
```

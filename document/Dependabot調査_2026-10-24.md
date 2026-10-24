# Dependabotの失敗表示の調査（2026年10月24日）

## 結論

Dependabotの依存更新処理は正常に完了している。失敗していたのは、作成された更新PRに対する `Application checks` である。メジャー更新による非互換と、既存の認証同期に関するブラウザテストの競合を分けて扱う。

GitHubコネクタと公開Actions APIで、実行情報・ジョブ・失敗ログを読み取って確認した。以下は2026年10月24日の調査時点の結果である。

## Dependabot本体の実行結果

| 対象 | 実行ID・結果 |
| --- | --- |
| npm `/frontend` | [40090858912：成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090858912) |
| Docker `/frontend` | [40090858948：成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090858948) |
| Docker Compose `/` | [40090858893：成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090858893) |
| GitHub Actions `/` | [40090858853：成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090858853) |

4件とも20:40ごろ（日本時間）に開始された更新処理で、対象のmainは `b01370abafd73febca882a9a5fe4a552419deff3` だった。

## 更新PRのCI失敗

| PR | 確認した失敗と原因 |
| --- | --- |
| [#17：H3 1.15.11 → 2.0.7](https://github.com/misato729/TQCE-info-practice/pull/17) | [実行40090954746・verify](https://github.com/misato729/TQCE-info-practice/actions/runs/40090954746/job/120863325142)でAPIテストが失敗。`SyntaxError: The requested module 'h3' does not provide an export named 'toWebRequest'`。`createEvent` の不足も記録されており、H3 1向け実装・テストとの非互換である。 |
| [#16：TypeScript 5.9.3 → 7.0.2](https://github.com/misato729/TQCE-info-practice/pull/16) | [実行40090944970・verify](https://github.com/misato729/TQCE-info-practice/actions/runs/40090944970/job/120863298454)でフロントエンドテストが失敗。`TypeError: Cannot read properties of undefined (reading 'ESNext')`。`apiStatus.test.ts:137` と `authGuard.test.ts:50` が従来の `ts.ModuleKind.ESNext` などのコンパイラAPIを使用している。 |
| [#15：upload-artifact 4 → 7](https://github.com/misato729/TQCE-info-practice/pull/15) | [実行40090916462・browser](https://github.com/misato729/TQCE-info-practice/actions/runs/40090916462/job/120863212448)で、再ログイン後のお気に入り表示が失敗。`core-journeys.spec.ts:105` の `.favorite-card` は期待1件に対し0件。モバイルで再試行後も同じ結果だった。 |
| [#14：checkout 4 → 7](https://github.com/misato729/TQCE-info-practice/pull/14) | [実行40090907703・browser](https://github.com/misato729/TQCE-info-practice/actions/runs/40090907703/job/120863184734)で同じお気に入りテストが失敗。こちらはデスクトップで発生した。 |

#15は同じSHA `038c7533233ece28b6f4628993dab5f64125d35b` の[別実行40090912108が成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090912108)した。#14も同じSHA `7c55220471686193d1540b856ac28c8df2a977eb` の[別実行40090911598が成功](https://github.com/misato729/TQCE-info-practice/actions/runs/40090911598)している。この2件について、Actionsライブラリの更新自体が原因とは断定しない。

## お気に入り・履歴の競合への対応

失敗ログと実装は、次の競合と整合する。

1. 再ログイン後、お気に入りの取得が始まる。
2. Better Authから同じユーザーの新しいセッション通知が遅れて届き、`sessionVersion` が更新される。
3. 進行中のお気に入り応答は旧世代として破棄される。
4. 取得の監視対象がユーザーID・利用資格・ページ番号だけだったため、同じユーザーでは再取得されず、表示が0件のままになる。

お気に入りの監視対象へ `sessionVersion` を追加し、破棄した取得を新世代でやり直す。履歴にも同じ監視を追加し、取得番号・セッション世代が古い応答で新しい結果を上書きしないようにする。画面文言に関する別の変更は保持する。

同じユーザーへのセッション更新でも世代を進める処理は維持する。これを単純に削除すると、旧セッションで開始したAPIリクエストの401が、新しいセッションをログアウト扱いにする可能性があるためである。実際のページ取得処理を使う合成テストと、実際のAPIクライアントを使う旧401の回帰テストを追加した。既存の初期匿名セッションの重複取得対策も保持する。

## 更新方針

`groups.update-types: [minor, patch]` はPRのまとめ方を制御する。グループに一致しないメジャー更新は個別PRになるため、メジャーPRを禁止する設定ではない。[GitHub公式仕様](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#groups)

CIは無効化せず、H3やTypeScriptのメジャー更新は関連するNuxt/Nitro・型検査・テスト基盤を含む別の移行として確認する。[H3の移行資料](https://h3.dev/migration)にもAPI・動作の変更が示されている。失敗表示を消す目的で広い `ignore` を追加し、セキュリティ更新の提案まで見えなくしない。

今回の調査・修正では、リモート設定変更、PR作成・更新、ワークフロー再実行、コミット・push、Netlify操作、本番DB操作は行っていない。秘密値や実問題の本文も記録していない。

## 変更後の検証結果

ローカルの修正後、同一ユーザーのセッション更新・履歴の遅着応答・旧401ガードを含む合成テストが成功した。最終のPC/SPブラウザテスト20件もすべて成功し、再ログイン後のお気に入り保持と別タブログアウトを両端末幅で確認した。

これは現在の依存バージョンでのローカル検証結果であり、H3 2やTypeScript 7の互換性確認・GitHubの赤いCIの修正反映・PR更新を意味しない。リモート状態は変更していない。全点検の結果は [移行後総点検](移行後総点検_2026-10-24.md) に記録した。

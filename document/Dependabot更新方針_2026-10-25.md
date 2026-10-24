# Dependabotの失敗した更新PRへの対応

2026年10月25日、現在の機能を維持し、Netlifyへデプロイせずに更新PRへ対応する。

## PRの現状と判断

確認時点で開いているPRは0件。以前の更新PR #13〜17は `misato729` アカウントによって10月25日03:12ごろ（日本時間）に未マージで閉じられていた。閉じた理由の記録はなく、再開しない。旧PRの失敗表示は過去のコミットに対する結果であり、最新mainの成功とは区別する。

| 更新 | 確認結果と今回の対応 |
| --- | --- |
| [#14: actions/checkout 4 → 7](https://github.com/misato729/TQCE-info-practice/pull/14)、[#15: actions/upload-artifact 4 → 7](https://github.com/misato729/TQCE-info-practice/pull/15) | 同じコミットでも成功・失敗があり、お気に入り取得のセッション競合が原因と整合する。競合はmainの `da0366a` で修正済み。最新mainを元に、現行CIを保った修正PRでv7へ更新する。 |
| [#16: TypeScript 5.9.3 → 7.0.2](https://github.com/misato729/TQCE-info-practice/pull/16) | TS7は従来のコンパイラAPIを同梱しない。現行のテスト・表示検査とVueの型検査が必要とするため、5.9系を維持する。TS6への更新と、Vue側を含むTS7への移行は別途検証する。 |
| [#17: H3 1.15.11 → 2.0.7](https://github.com/misato729/TQCE-info-practice/pull/17) | ロック上のNuxt 4.6.2 / nitropack 2.13.5はH3 `^1.15.11` を使用する。H3 v2単独更新は認証・ルーティング・テストのAPIを壊すため採用せず、対応するNuxt/Nitroへの移行とまとめて検証する。 |
| [#13: Node 24 → 25](https://github.com/misato729/TQCE-info-practice/pull/13) | CIは成功していたが未マージで閉じられている。本件の失敗修正へ混ぜず、現行のNode 24を維持する。 |

実際の解決版は `frontend/package-lock.json` に従う。manifestのNuxt `^4.5.1` と、解決された4.6.2を混同しない。

## 再発防止

`.github/dependabot.yml` のnpmエントリで、通常のバージョン更新を `allow.update-types` のminor・patchへ限定する。これにより、単独でのH3・TypeScript等のメジャー更新を通常更新として繰り返し提案しない。既存の週次実行、3日のcooldown、グループ化、PR数上限は維持する。Docker・Compose・GitHub Actionsの更新設定は変更しない。

GitHub公式仕様では、`allow.update-types` は通常のversion updatesだけに適用され、security updatesには影響しない。`ignore` による依存関係全体やバージョン範囲の除外を追加せず、脆弱性に対する提案を残す。セキュリティ修正がメジャー移行を必要とする場合は、自動的に安全と判断せず、関連機能の検証を行って対応する。

- [GitHub公式: allow.update-types](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#update-types-allow)
- [GitHub公式: 更新対象のSemVerレベルを指定する](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/manage-your-dependency-security/controlling-dependencies-updated#allowing-specific-semantic-versioning-levels-for-updates)
- [H3公式: v1からv2への移行](https://h3.dev/migration)
- [Nitro公式: H3 v2を含む移行](https://nitro.build/docs/migration#h3-v2)
- [TypeScript公式: TS7とTS6の併用・コンパイラAPI](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/#running-side-by-side-with-typescript-6-0)

## GitHub Actionsの更新

`actions/checkout@v7` と `actions/upload-artifact@v7` はNode24で実行する。GitHubホステッドの `ubuntu-latest`、`contents: read`、`push` / `pull_request` のイベントを維持する。権限追加や `allow-unsafe-pr-checkout` は不要であり、認証・安全性の例外を追加しない。

失敗時だけのブラウザ診断アップロード、保存7日、ファイルなしの場合のignoreを維持する。CIが全成功した場合、診断アップロードは従来どおりスキップされる。アップロードAPIの実送信まで確認した結果として扱わない。

- [checkout v7.0.1](https://github.com/actions/checkout/releases/tag/v7.0.1)
- [checkoutの公式README](https://github.com/actions/checkout)
- [upload-artifact v7の変更](https://github.com/actions/upload-artifact/releases/tag/v7.0.0)

## 確認と反映の範囲

変更はDependabot設定、CIのAction参照、関連資料に限定する。アプリのコード、依存パッケージの解決版、DB・問題・選択肢、旧DBやバックアップは変更しない。

ローカルではYAML・差分を確認し、重いテストやビルドは重ねない。修正PRのGitHub Actionsで、DB・API・認証・フロントエンド・型・生成・PC/SPのブラウザ検査を確認する。閉じた旧PRのCI再実行や、成功した検査の削除は行わない。

Netlifyの自動ビルド停止と現在の公開版を確認し、コミットに `[skip netlify]` を付ける。新しい修正PRはCI確認とレビューのためのもので、自動マージ・Netlifyの再開・デプロイ・本番切替は行わない。

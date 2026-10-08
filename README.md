# 概要
「高等学校（情報）教員資格認定試験」の問題演習サイト   
※TQCE：教員資格認定試験 Teacher Qualification Certification Exam の略（非公式）   
本試験は令和6年度から始まった試験であり、演習サイトなどあるわけもなく、そもそも過去問自体が少ないという課題がある。   
そこで、過去問や指導要領等の原典をベースとして生成AIに問題を作成させ、多くの問題を解ける仕組みを作るべく開発に至った。

## 技術構成

- フロントエンド: Nuxt 4
- バックエンド: Ruby on Rails 7 API
- データベース: PostgreSQL 16
- 開発環境: Docker Compose

## 開発環境の起動

このプロジェクトは Nuxt、Rails API、PostgreSQL を Docker Compose で起動する構成です。
ローカルブラウザで http://localhost:3000 を開くには、Docker Desktop を起動したうえでコンテナを立ち上げておく必要があります。

通常は、プロジェクトルートから以下を実行します。

```sh
docker compose up
```

初回起動時、または Dockerfile、Gemfile、package.json を変更した後は、以下を実行します。

```sh
docker compose up --build
```

起動後、以下の URL にアクセスできます。

- Frontend: http://localhost:3000
- Backend health check: http://localhost:3001/api/v1/health
- Admin login: http://localhost:3000/admin/login
- Admin questions: http://localhost:3000/admin/questions

管理画面は `role = admin` のユーザーのみ利用できます。一般画面で管理者としてログイン済みの場合は、同じ認証セッションを使って管理画面へ遷移できます。

Docker Composeでは、Nuxtのサーバー側認証確認に `NUXT_API_BASE_INTERNAL=http://backend:3000` を使用します。ブラウザは従来どおり `NUXT_PUBLIC_API_BASE` を使用します。内部URLは非公開のruntime configで扱い、本番で未設定の場合は公開APIのURLへ接続します。Composeの設定変更後は `docker compose up -d frontend` でコンテナを再作成してください。Railsの開発用Host許可には `backend` のみ追加しています。

## Stripe有料会員の設定

有料会員は500円（税込）の買い切りです。模擬試験1〜5は無料、模擬試験6以降は有効な有料会員または管理者だけが利用できます。販売開始フラグの初期値は `false` です。

1. Stripeで「模擬試験6以降の利用資格（買い切り）」など提供内容が分かる名称のProductと、日本円500円の一回払い用Priceを作成します。Stripe Dashboardの公開情報に、本番サイトの利用規約URLとプライバシーポリシーURLも登録します。Checkoutでは利用規約への同意を必須にするため、URL未設定時はSessionを作成できません。
2. StripeのWebhook送信先を `https://<backend-host>/api/v1/webhooks/stripe` とし、次のイベントを登録します。
   - `checkout.session.completed`
   - `checkout.session.expired`
   - `refund.created`
   - `refund.updated`
   - `refund.failed`
   - `charge.dispute.created`
   - `charge.dispute.closed`
3. `.env.example` に記載したStripe設定、フロントエンドURL、販売事業者情報を設定します。シークレット値はリポジトリへ保存しません。
4. Stripeのテストモードで、購入、Webhook再送、全額返金、異議申立て、重複購入防止を確認します。
5. 利用規約、プライバシーポリシー、特定商取引法に基づく表記の実情報を確認した後、`PAID_MEMBERSHIP_ENABLED=true` にします。

販売事業者情報には、実際の氏名または登記上の名称、現に活動する正確な住所、確実に連絡できる電話番号及び問い合わせ先を設定してください。サイト名や未登記の屋号だけを販売事業者名として使用しないでください。

ローカルでは `STRIPE_LIVEMODE=false` を使用します。本番では本番用のキー、Price、Webhook署名シークレットにそろえて `STRIPE_LIVEMODE=true` とし、テスト環境の値と混在させないでください。カード番号等はStripe Checkoutが取り扱い、本アプリのDBには保存しません。

### Basic認証の入力欄が消える場合

フロントエンドのBasic認証は `frontend/server/middleware/basic-auth.ts` で処理します。未認証時は `401` と `WWW-Authenticate: Basic ...`、認証成功時は `200` を返すことを確認し、サイト側の認証処理とブラウザ側の入力画面を切り分けてください。認証情報・Authorizationヘッダー・`.env` の値はログや資料へ出力しないでください。

アプリ内ブラウザで入力欄がすぐ閉じる場合は、認証入力中の自動移動・再読み込みを止め、ユーザーの入力完了を待ちます。それでも入力できなければ、通常のChromeやSafariで同じローカルURLを開いて確認してください。通常のブラウザとアプリ内ブラウザの認証状態が共有されるとは限りません。認証を無効化したり、認証情報をURLへ埋め込んだりする方法は使いません。

HTTP取得が成功しても、表示や回答操作を確認したことにはなりません。HTTP確認、ユーザーの目視確認、エージェントの実操作確認を区別して記録します。模試20の表示不統一と認証確認時の切り分け記録は [原因と再発防止策](document/模試20_表示不統一の原因と再発防止_2026-10-08.md) を参照してください。

## 停止

```sh
docker compose down
```

データベースの内容も削除したい場合は、以下を実行します。

```sh
docker compose down -v
```

## バックエンドのデプロイ

バックエンドは Fly.io にデプロイします。Fly.io の設定は `backend/fly.toml` に置いています。

初回は Fly.io にログインしたうえで、バックエンドディレクトリからアプリを作成します。

```sh
cd backend
fly launch --no-deploy
```

`backend/fly.toml` の `app` 名と Fly.io 側のアプリ名が異なる場合は、どちらかに合わせてください。

本番で必要な環境変数は Fly.io の secrets に設定します。DB は Neon を使う想定です。

```sh
fly secrets set SECRET_KEY_BASE=<secret>
fly secrets set DATABASE_URL=<neon-production-database-url>
fly secrets set CORS_ORIGINS=https://tqce-info-practice.vercel.app
```

有料会員を販売する場合は、Stripeと公開事業者情報もFly.ioのsecretsへ設定します。実値はコマンド履歴や共有ログへ残さない方法で設定してください。

```sh
fly secrets set PAID_MEMBERSHIP_ENABLED=true
fly secrets set STRIPE_LIVEMODE=true
fly secrets set STRIPE_SECRET_KEY=<stripe-secret-key>
fly secrets set STRIPE_WEBHOOK_SECRET=<stripe-webhook-secret>
fly secrets set STRIPE_PRICE_ID=<stripe-price-id>
fly secrets set FRONTEND_URL=https://tqce-info-practice.vercel.app
```

`NUXT_PUBLIC_SELLER_NAME`、`NUXT_PUBLIC_SELLER_REPRESENTATIVE`、`NUXT_PUBLIC_SELLER_ADDRESS`、`NUXT_PUBLIC_SELLER_PHONE`、`NUXT_PUBLIC_SELLER_EMAIL` はFly.ioへ実情報を設定します。これらは秘密情報ではなく、公開販売設定APIを通じて特定商取引法に基づく表記へ表示されます。

バックエンドのルート画面に Basic 認証をかける場合は、以下も設定します。

```sh
fly secrets set BACKEND_BASIC_AUTH_USER=<user>
fly secrets set BACKEND_BASIC_AUTH_PASSWORD=<password>
```

デプロイは以下で実行します。

```sh
fly deploy
```

`backend/fly.toml` の `release_command` では、デプロイのたびに次の処理を実行します。

```sh
bin/rails db:prepare && bin/rails db:seed
```

そのため、Fly.io のGitHub自動デプロイを設定している場合は、seedファイルを含む変更をpushすると、アプリのリリース前に本番DBへ問題データが反映されます。`release_command` が失敗した場合は新しいリリースへ切り替わりません。

ローカルDBへ問題データを反映する場合は、コンテナ起動後にプロジェクトルートで以下を実行します。

```sh
docker compose exec backend bin/rails db:seed
```

seedは試験ナンバーと問番号をキーに再実行できます。管理画面とseedは共通の保存処理を使い、問題文・選択肢・正答・解説・出典・分類の変更時には、その問題の古い回答履歴を同じトランザクション内で削除します。公開状態だけの変更では履歴を残します。

作成途中の模擬試験は、承認済みの問題だけを `draft`（下書き）で登録します。下書きは管理画面で確認できますが、一般向けの模擬試験一覧や問題取得APIには表示されません。全20問がそろい、セット全体の検証が完了した後に公開へ切り替えます。

### 管理画面とseedの更新方針

- seedが変わっていなければ、管理画面での訂正・非公開化・削除は維持されます。
- seedだけが変わった場合は新しい内容を反映します。管理画面で変更した公開状態は維持します。
- 両方で本文等を変更した場合は、問題番号を示して競合エラーで停止します。全seedの反映はロールバックされます。管理画面の訂正とseedを比較し、採用する内容を両方にそろえてから再実行してください。DBを無条件で上書きするオプションはありません。
- 削除済みの問題は同期記録に残し、seedでは再作成しません。seed管理問題の番号変更も管理APIで拒否します。
- 初回移行では `backend/db/seeds/legacy_digests_20260907.json` の旧225問のハッシュとDBを比較します。このファイルは今後の改稿時にも変更しないでください。同期管理を導入する前に削除され、記録のない問題については削除意図を判別できません。
- 本番への初回反映では、新しい `question_seed_states` テーブルのマイグレーションが必要です。通常の `release_command` の `db:prepare` で適用されます。

デプロイ後、Vercel 側の `NUXT_PUBLIC_API_BASE` には Fly.io のバックエンド URL を設定します。

```text
https://tqce-info-practice.fly.dev
```

### release_command が失敗する場合

`release_command failed` が出た場合は、ほとんどの場合 `SECRET_KEY_BASE` または `DATABASE_URL` の未設定、あるいはDB接続エラーです。以下で secrets が入っているか確認してください。

```sh
fly secrets list -a tqce-info-practice
```

ログの詳細は以下で確認します。

```sh
fly logs -a tqce-info-practice
```

DB が Neon の場合、`DATABASE_URL` は本番用の接続文字列を設定します。接続文字列のパスワードやクエリ文字列にシェル特殊文字が含まれる場合は、値全体をシングルクォートで囲んで設定してください。

```sh
fly secrets set DATABASE_URL='<neon-production-database-url>' -a tqce-info-practice
```

## ディレクトリ構成

```text
.
├── frontend/   # Nuxt 4 app
│   ├── app/    # Nuxt 4 のアプリケーションコード
│   └── nuxt.config.ts
├── backend/    # Rails API
└── docker-compose.yml
```

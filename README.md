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

バックエンドのルート画面に Basic 認証をかける場合は、以下も設定します。

```sh
fly secrets set BACKEND_BASIC_AUTH_USER=<user>
fly secrets set BACKEND_BASIC_AUTH_PASSWORD=<password>
```

デプロイは以下で実行します。

```sh
fly deploy
```

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

# 概要
「高等学校（情報）教員資格認定試験」の問題演習サイト   
TQCE：教員資格認定試験 Teacher Qualification Certification Exam の略（非公式）

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

## ディレクトリ構成

```text
.
├── frontend/   # Nuxt 4 app
│   ├── app/    # Nuxt 4 のアプリケーションコード
│   └── nuxt.config.ts
├── backend/    # Rails API
└── docker-compose.yml
```

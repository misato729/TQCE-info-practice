# 概要
「高等学校（情報）教員資格認定試験」の問題演習サイト   
TQCE：教員資格認定試験 Teacher Qualification Certification Exam の略（非公式）

## 技術構成

- フロントエンド: Nuxt 3
- バックエンド: Ruby on Rails 7 API
- データベース: PostgreSQL 16
- 開発環境: Docker Compose

## 初回起動

Docker Desktop を起動した状態で、プロジェクトルートから以下を実行します。

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
├── frontend/   # Nuxt app
├── backend/    # Rails API
└── docker-compose.yml
```

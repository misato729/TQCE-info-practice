# API設計

## 設計方針

* Rails APIからNuxtフロントエンドへJSON形式でデータを提供する
* APIのベースパスは `/api/v1` とする
* JSONのキーはRails側に合わせて `snake_case` とする
* 日時はISO 8601形式のUTCで返す
    * 例: `2026-06-25T03:00:00Z`
* 一覧APIはページネーションに対応する
* 分野、公開状態などの固定値はDBから取得せず、フロントエンドとバックエンドの `utils` で管理する
* 問題は1問ずつ取得し、演習セッションや演習完了処理は設けない
* 問題は `exam_number` ごとに20問を配置し、各問を `question_number` で並べる
* 未ログインユーザーも問題に回答できるが、回答履歴は保存しない
* ログインユーザーが回答した場合のみ、回答履歴を1問単位で保存する
* 回答前のレスポンスには、正答や解答解説を含めない

## 認証方式

初期実装ではBearerトークン方式を採用する。

```http
Authorization: Bearer <access_token>
```

* 会員登録またはログイン成功時にアクセストークンを発行する
* アクセストークンにはユーザーID、権限、有効期限を含め、改ざんを検知できる形式で署名する
* 有効期限は24時間を初期値とする
* リフレッシュトークンとパスワード再設定は初期実装では設けない
* ログアウトはフロントエンド側でアクセストークンを破棄して行う
* 管理APIではトークンの `role = admin` を確認する
* 本番環境ではHTTPSを必須とする

Bearerトークン方式は、VercelとFly.ioでフロントエンドとバックエンドのドメインが分かれる構成を想定して採用する。

### 任意認証

問題回答APIは認証を任意とする。

* Authorizationヘッダーがない場合は、回答を判定するだけで履歴を保存しない
* 有効なAuthorizationヘッダーがある場合は、回答を判定して履歴を保存する
* Authorizationヘッダーがあるにもかかわらずトークンが不正または期限切れの場合は、匿名扱いにせず `401 Unauthorized` を返す

## 共通仕様

### Content-Type

JSONを送信するAPIでは、以下を指定する。

```http
Content-Type: application/json
Accept: application/json
```

### URLパラメータ

| 表記 | 内容 |
| --- | --- |
| `{question_id}` | 問題ID |
| `{answer_history_id}` | 回答履歴ID |

`{question_id}` はDB上の問題IDを表す。問題演習画面の `/practice/{examNumber}/{questionNumber}` で使用する試験ナンバー・問番号とは区別する。

### コンテンツブロック

問題本文、選択肢、解答解説は、表示順に並んだ `content_blocks` の配列として扱う。HTML文字列は受け付けず、フロントエンドは `type` ごとの表示部品で描画する。

| `type` | 用途 | 主なキー |
| --- | --- | --- |
| `text` | 通常の文章 | `text` |
| `quote` | 枠付きの引用文 | `text`, 任意の `source` |
| `table` | 表 | `headers`, `rows` |
| `code` | 単独のプログラム表記 | 任意の `title`, `code` |
| `code_group` | 複数プログラムの比較 | `items`。各要素に `title`, `code` |

問題本文ではすべての形式を使用できる。選択肢では `text`, `table`、解答解説では `text`, `quote`, `table`, `code` を使用できる。

### ページネーション

回答履歴、お気に入り、管理問題一覧で使用する。

| パラメータ | 必須 | 初期値 | 内容 |
| --- | --- | --- | --- |
| `page` | 任意 | `1` | ページ番号 |
| `per_page` | 任意 | `20` | 1ページの件数。最大100件 |

```json
{
  "data": [],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total_count": 42,
    "total_pages": 3
  }
}
```

### 成功レスポンス

| 処理 | HTTPステータス |
| --- | --- |
| 取得成功 | `200 OK` |
| 登録成功 | `201 Created` |
| 更新成功 | `200 OK` |
| 削除成功・レスポンス本文なし | `204 No Content` |

### エラーレスポンス

```json
{
  "error": {
    "code": "validation_error",
    "message": "入力内容を確認してください",
    "details": {
      "email": ["はすでに使用されています"]
    }
  }
}
```

| HTTPステータス | `code`例 | 使用場面 |
| --- | --- | --- |
| `400 Bad Request` | `bad_request` | JSON形式不正、パラメータ形式不正 |
| `401 Unauthorized` | `unauthorized` | 未ログイン、トークン不正・期限切れ |
| `403 Forbidden` | `forbidden` | 管理者権限不足、他ユーザーのデータへのアクセス |
| `404 Not Found` | `not_found` | 対象が存在しない、非公開問題への一般アクセス |
| `422 Unprocessable Entity` | `validation_error` | バリデーションエラー、選択肢の指定不正 |
| `500 Internal Server Error` | `internal_server_error` | サーバー内部エラー |

## API一覧

### システム

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/health` | 不要 | APIの稼働状態を取得する |

### 認証・アカウント

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| POST | `/api/v1/auth/signup` | 不要 | 会員登録し、アクセストークンを発行する |
| POST | `/api/v1/auth/login` | 不要 | ログインし、アクセストークンを発行する |
| GET | `/api/v1/me` | 必要 | ログインユーザー情報を取得する |
| DELETE | `/api/v1/me` | 必要 | ログインユーザーのアカウントを物理削除する |

### 問題演習

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/questions/next` | 不要 | 公開中の問題を1問取得する |
| GET | `/api/v1/questions/{question_id}` | 不要 | 指定した公開問題を取得する |
| POST | `/api/v1/questions/{question_id}/answer` | 任意 | 回答を判定し、ログイン時のみ履歴を保存する |

### 回答履歴

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/answer_histories` | 必要 | ログインユーザーの回答履歴を取得する |
| GET | `/api/v1/answer_histories/{answer_history_id}` | 必要 | 回答履歴の詳細と解説を取得する |

### お気に入り

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/favorites` | 必要 | お気に入り問題を取得する |
| PUT | `/api/v1/questions/{question_id}/favorite` | 必要 | 問題をお気に入り登録する |
| DELETE | `/api/v1/questions/{question_id}/favorite` | 必要 | 問題のお気に入りを解除する |

### 管理

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/admin/questions` | 管理者 | 全公開状態の問題を一覧取得する |
| GET | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題の編集用データを取得する |
| POST | `/api/v1/admin/questions` | 管理者 | 問題を作成する |
| PATCH | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題を更新する |
| DELETE | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題を削除する |

## 認証・アカウントAPI

### 会員登録

`POST /api/v1/auth/signup`

リクエスト:

```json
{
  "name": "学習ユーザー",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

レスポンス `201 Created`:

```json
{
  "data": {
    "access_token": "token",
    "token_type": "Bearer",
    "expires_in": 86400,
    "user": {
      "id": 1,
      "name": "学習ユーザー",
      "email": "user@example.com",
      "role": "user"
    }
  }
}
```

### ログイン

`POST /api/v1/auth/login`

リクエスト:

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

レスポンスは会員登録と同じ形式とする。認証失敗時は `401 Unauthorized` を返す。

### ログインユーザー取得

`GET /api/v1/me`

レスポンス `200 OK`:

```json
{
  "data": {
    "id": 1,
    "name": "学習ユーザー",
    "email": "user@example.com",
    "role": "user",
    "created_at": "2026-06-25T03:00:00Z"
  }
}
```

### アカウント削除

`DELETE /api/v1/me`

リクエスト:

```json
{
  "current_password": "password123"
}
```

現在のパスワードが一致した場合、ユーザー、回答履歴、お気に入りを物理削除し、`204 No Content` を返す。

## 問題演習API

### 次の問題取得

`GET /api/v1/questions/next`

公開状態が `published` の問題から1問取得する。

任意のクエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `exclude_question_id` | 直前の問題ID。ほかに公開問題がある場合、この問題を除外する |
| `exam_number` | 指定した試験ナンバーの問題に限定する |
| `after_question_number` | 指定した問番号の次を取得する。`exam_number` と組み合わせて使用する |

レスポンス `200 OK`:

```json
{
  "data": {
    "id": 42,
    "exam_number": 1,
    "question_number": 1,
    "content_blocks": [
      {
        "type": "text",
        "text": "教育基本法について正しいものを選びなさい。"
      }
    ],
    "major_category_code": "teacher_education",
    "category_code": "education_law",
    "choices": [
      {
        "id": 101,
        "choice_label": "ア",
        "content_blocks": [
          {
            "type": "text",
            "text": "選択肢の内容"
          }
        ],
        "display_order": 1
      }
    ]
  }
}
```

* 選択肢は必ず4件返す
* `content_blocks` の配列順を画面の表示順とする
* プログラムの `code` は改行と字下げを変更せず返す
* `exam_number` のみ指定した場合は、その試験ナンバーの問1を取得する
* `exam_number` と `after_question_number` を指定した場合は、同じ試験ナンバーの次の問番号を取得する
* 問20より後の問題を要求した場合は `404 Not Found` を返す
* `is_correct`、正答、解答解説、根拠資料は返さない
* ログイン中の場合に限り、レスポンスへ `is_favorite` を追加してよい
* 公開問題が1件もない場合は `404 Not Found` を返す

### 指定問題取得

`GET /api/v1/questions/{question_id}`

回答履歴やお気に入りから、指定した問題を再度表示するときに使用する。レスポンス形式と公開条件は「次の問題取得」と同じとする。

### 回答判定

`POST /api/v1/questions/{question_id}/answer`

リクエスト:

```json
{
  "selected_choice_id": 101
}
```

レスポンス `200 OK`:

```json
{
  "data": {
    "question_id": 42,
    "selected_choice_id": 101,
    "is_correct": false,
    "correct_choice": {
      "id": 103,
      "choice_label": "ウ",
      "content_blocks": [
        {
          "type": "text",
          "text": "正答となる選択肢"
        }
      ]
    },
    "explanation_blocks": [
      {
        "type": "text",
        "text": "この問題の解答解説です。"
      }
    ],
    "source_text": "教育基本法 第1条 | https://laws.e-gov.go.jp/law/418AC0000000120",
    "answer_history_id": 501
  }
}
```

* `selected_choice_id` は対象問題に属する選択肢でなければならない
* 未ログイン時は `answer_history_id` を `null` とし、DBへ保存しない
* ログイン時は回答履歴を作成し、そのIDを返す
* `source_text` は1行ごとに `資料名・章節 | https://...` 形式とし、クライアントはURL部分を外部リンクとして表示する
* 同じ問題へ複数回答した場合も、回答ごとに履歴を作成する
* 非公開問題に対する回答は `404 Not Found` とする

## 回答履歴API

### 回答履歴一覧

`GET /api/v1/answer_histories`

ログインユーザー本人の履歴だけを新しい順に返す。

```json
{
  "data": [
    {
      "id": 501,
      "question": {
        "id": 42,
        "exam_number": 1,
        "question_number": 1,
        "body_excerpt": "教育基本法について正しいものを選びなさい。",
        "major_category_code": "teacher_education",
        "category_code": "education_law",
      },
      "selected_choice": {
        "id": 101,
        "choice_label": "ア",
        "body_excerpt": "選択した内容"
      },
      "is_correct": false,
      "answered_at": "2026-06-25T03:00:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total_count": 1,
    "total_pages": 1
  }
}
```

* `body_excerpt` は、最初の `text` または `quote` ブロックから装飾を除いて生成する
* `body_excerpt` は一覧表示用であり、問題の完全な内容は指定問題取得APIで取得する

### 回答履歴詳細

`GET /api/v1/answer_histories/{answer_history_id}`

一覧の内容に加えて、正答、解答解説、根拠資料を返す。他ユーザーの回答履歴には `404 Not Found` を返す。

## お気に入りAPI

### お気に入り一覧

`GET /api/v1/favorites`

ログインユーザー本人のお気に入りを新しい順に返す。各項目には問題ID、試験ナンバー、問番号、問題文の概要、大分類、小分類、登録日時を含める。

### お気に入り登録

`PUT /api/v1/questions/{question_id}/favorite`

* 対象は公開中の問題に限る
* 同じ問題を再度登録しても重複データを作成しない
* 回答済みかどうかにかかわらず、問題表示中に登録できる
* 新規登録時は `201 Created`、登録済みの場合は `200 OK` を返す

### お気に入り解除

`DELETE /api/v1/questions/{question_id}/favorite`

登録が存在する場合は削除し、存在しない場合も成功として `204 No Content` を返す。

## 管理API

### 管理問題一覧

`GET /api/v1/admin/questions`

| パラメータ | 内容 |
| --- | --- |
| `exam_number` | 試験ナンバーで絞り込む |
| `major_category_code` | 大分類で絞り込む |
| `category_code` | 小分類で絞り込む |
| `publication_status` | 公開状態で絞り込む |
| `keyword` | 問題本文のコンテンツブロック内の文字列を部分一致検索する |
| `page`、`per_page` | ページネーション |

### 管理問題詳細

`GET /api/v1/admin/questions/{question_id}`

試験ナンバー、問番号、問題本文のコンテンツブロック、正答を含む4つの選択肢、解答解説のコンテンツブロック、根拠資料、分類、公開状態を返す。

### 問題作成

`POST /api/v1/admin/questions`

```json
{
  "question": {
    "exam_number": 1,
    "question_number": 1,
    "content_blocks": [
      {
        "type": "text",
        "text": "次のプログラムを比較し、正しいものを選びなさい。"
      },
      {
        "type": "code_group",
        "items": [
          {
            "title": "プログラムA",
            "code": "(01) i = 0\n(02) i < n - 1 の間繰り返す:"
          },
          {
            "title": "プログラムB",
            "code": "(01) i = 1\n(02) i < n の間繰り返す:"
          }
        ]
      }
    ],
    "major_category_code": "information",
    "category_code": "algorithm",
    "explanation_blocks": [
      {
        "type": "text",
        "text": "解答解説"
      }
    ],
    "source_text": "高等学校学習指導要領解説 情報編 | https://www.mext.go.jp/content/1407073_11_1_2.pdf",
    "publication_status": "draft",
    "choices": [
      {
        "choice_label": "ア",
        "content_blocks": [{ "type": "text", "text": "選択肢1" }],
        "is_correct": false,
        "display_order": 1
      },
      {
        "choice_label": "イ",
        "content_blocks": [{ "type": "text", "text": "選択肢2" }],
        "is_correct": true,
        "display_order": 2
      },
      {
        "choice_label": "ウ",
        "content_blocks": [{ "type": "text", "text": "選択肢3" }],
        "is_correct": false,
        "display_order": 3
      },
      {
        "choice_label": "エ",
        "content_blocks": [{ "type": "text", "text": "選択肢4" }],
        "is_correct": false,
        "display_order": 4
      }
    ]
  }
}
```

* 選択肢は4件とする
* 正答は1件だけとする
* 問題本文、選択肢、解答解説の各 `content_blocks` は空配列にせず、「コンテンツブロック」の形式に従う
* `table` は見出しと各行の列数を一致させる
* `code_group.items` は2件以上とし、プログラムの改行と字下げを保持する
* `exam_number` は1以上、`question_number` は1〜20とする
* `exam_number` と `question_number` の組み合わせは重複させない
* 大分類と小分類の組み合わせが `utils` の定義と一致していることを確認する

### 問題更新

`PATCH /api/v1/admin/questions/{question_id}`

リクエスト形式は問題作成と同じとする。選択肢は既存IDを指定して更新し、回答履歴から参照されている選択肢を不用意に削除しない。

### 問題削除

`DELETE /api/v1/admin/questions/{question_id}`

問題、選択肢、回答履歴、お気に入りを同一トランザクションで削除し、`204 No Content` を返す。

## 固定値

以下はDBテーブル化せず、フロントエンドとバックエンドの `utils` で同じ値を管理する。

| 固定値 | 値 |
| --- | --- |
| ユーザー権限 | `user`, `admin` |
| 大分類 | `teacher_education`, `information` |
| 小分類 | `education_history`, `education_law`, `curriculum_guideline`, `student_guidance`, `educational_psychology`, `new_japanese_school_education`, `information_curriculum_guideline`, `algorithm`, `data_science` |
| 公開状態 | `draft`, `published`, `private` |

## CORS

許可するオリジンは環境変数で管理する。

| 環境 | 許可例 |
| --- | --- |
| 開発 | `http://localhost:3000` |
| 本番 | Vercelで公開するフロントエンドURL |

* 許可メソッドは使用するHTTPメソッドに限定する
* 許可ヘッダーに `Authorization` と `Content-Type` を含める
* 本番環境でワイルドカード `*` は使用しない

## セキュリティ・実装上の注意

* パスワードは `bcrypt` などでハッシュ化し、平文保存しない
* アクセストークン、パスワード、Authorizationヘッダーをログへ出力しない
* 公開問題取得時は `question_choices.is_correct`、解答解説、根拠資料を返さない
* 回答判定は必ずサーバー側で行う
* 一般ユーザーは自分の回答履歴とお気に入りだけ取得できる
* 管理APIはすべて管理者権限を確認する
* コンテンツブロックでは許可したキーと文字列だけを受け付け、任意のHTMLやスクリプトを保存・描画しない
* 会員登録、ログイン、回答APIには必要に応じてレート制限を設ける
* アカウント削除と問題削除はトランザクションで実行する

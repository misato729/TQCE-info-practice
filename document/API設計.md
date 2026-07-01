# API設計

## 設計方針

* Rails APIからNuxtフロントエンドへJSON形式でデータを提供する
* APIのベースパスは `/api/v1` とする
* URLはリソース指向とし、HTTPメソッドで取得・登録・更新・削除を表現する
* JSONのキーはRails側に合わせて `snake_case` とする
* 日時はISO 8601形式のUTCで返す
    * 例: `2026-06-25T03:00:00Z`
* 一覧APIはページネーションに対応する
* 分野、難易度、公開状態などの固定値はDBから取得せず、フロントエンドとバックエンドの `utils` で管理する
* 通常演習と模擬試験は、共通の `practice_sessions` APIで扱う
* 公開問題閲覧時と演習回答前は、正答を推測できる情報をレスポンスに含めない

## 認証方式

初期実装では、Bearerトークン方式を採用する。

```http
Authorization: Bearer <access_token>
```

* ログイン成功時にアクセストークンを発行する
* アクセストークンにはユーザーID、権限、有効期限を含め、改ざん検知できる形式で署名する
* 有効期限は24時間を初期値とする
* フロントエンドはログアウト時にトークンを破棄する
* リフレッシュトークンは初期実装では設けず、期限切れ時は再ログインする
* 管理APIではトークンの `role = admin` を確認する
* 本番環境ではHTTPSを必須とする

Bearerトークンを採用する理由は、VercelとFly.ioでドメインが分かれる構成でもCookieのSameSite設定やCSRF対応を増やさずに実装できるためである。

## 共通リクエスト仕様

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
| `{practice_session_id}` | 演習セッションID |
| `{report_id}` | 誤り報告ID |

### ページネーション

一覧APIでは以下のクエリパラメータを使用する。

| パラメータ | 必須 | 初期値 | 内容 |
| --- | --- | --- | --- |
| `page` | 任意 | `1` | ページ番号 |
| `per_page` | 任意 | `20` | 1ページの件数。最大100件 |

一覧レスポンスには以下の `meta` を含める。

```json
{
  "data": [],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total_count": 1200,
    "total_pages": 60
  }
}
```

### 成功レスポンス

| 処理 | HTTPステータス |
| --- | --- |
| 取得成功 | `200 OK` |
| 登録成功 | `201 Created` |
| 非同期処理・受付成功 | `202 Accepted` |
| 更新成功 | `200 OK` |
| 削除成功・レスポンス本文なし | `204 No Content` |

### エラーレスポンス

エラー時は形式を統一する。

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
| `400 Bad Request` | `bad_request` | JSON形式不正、必要な条件の組み合わせ不正 |
| `401 Unauthorized` | `unauthorized` | 未ログイン、トークン不正・期限切れ |
| `403 Forbidden` | `forbidden` | 権限不足、他ユーザーのデータへのアクセス |
| `404 Not Found` | `not_found` | 対象データが存在しない、非公開問題への一般アクセス |
| `409 Conflict` | `conflict` | 演習完了後の回答など、現在状態と競合する操作 |
| `422 Unprocessable Entity` | `validation_error` | バリデーションエラー、出題可能数不足 |
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
| DELETE | `/api/v1/auth/logout` | 必要 | ログアウトを受け付ける |
| GET | `/api/v1/me` | 必要 | ログインユーザー情報を取得する |
| DELETE | `/api/v1/me` | 必要 | ログインユーザーのアカウントを物理削除する |
| POST | `/api/v1/password_resets` | 不要 | パスワード再設定案内を送信する |
| PATCH | `/api/v1/password_resets` | 不要 | 再設定トークンを使ってパスワードを変更する |

### 公開問題・誤り報告

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/questions` | 不要 | 公開中の問題を一覧取得する |
| GET | `/api/v1/questions/{question_id}` | 不要 | 公開中の問題詳細を取得する |
| POST | `/api/v1/questions/{question_id}/reports` | 不要 | 問題の誤りを報告する |

### お気に入り

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/favorites` | 必要 | お気に入り問題を一覧取得する |
| POST | `/api/v1/questions/{question_id}/favorite` | 必要 | 問題をお気に入り登録する |
| DELETE | `/api/v1/questions/{question_id}/favorite` | 必要 | 問題のお気に入りを解除する |

### 演習・履歴

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| POST | `/api/v1/practice_sessions` | 必要 | 通常演習または模擬試験を開始する |
| GET | `/api/v1/practice_sessions/{practice_session_id}` | 必要 | 演習セッションと出題問題を取得する |
| POST | `/api/v1/practice_sessions/{practice_session_id}/answers` | 必要 | 1問分の回答を保存する |
| PATCH | `/api/v1/practice_sessions/{practice_session_id}/complete` | 必要 | 演習を完了し、結果を集計する |
| GET | `/api/v1/practice_sessions/{practice_session_id}/result` | 必要 | 完了した演習結果を取得する |
| GET | `/api/v1/practice_sessions` | 必要 | ログインユーザーの演習履歴を取得する |
| GET | `/api/v1/question_stats` | 必要 | 問題別進捗を取得する |
| GET | `/api/v1/mypage_summary` | 必要 | マイページ用の学習状況概要を取得する |

### 管理

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/admin/dashboard` | 管理者 | 管理ダッシュボード情報を取得する |
| GET | `/api/v1/admin/questions` | 管理者 | 全公開状態の問題を一覧取得する |
| GET | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題の編集用データを取得する |
| POST | `/api/v1/admin/questions` | 管理者 | 問題を作成する |
| PATCH | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題を更新する |
| DELETE | `/api/v1/admin/questions/{question_id}` | 管理者 | 問題を削除する |
| GET | `/api/v1/admin/reports` | 管理者 | 誤り報告を一覧取得する |
| GET | `/api/v1/admin/reports/{report_id}` | 管理者 | 誤り報告の詳細を取得する |
| PATCH | `/api/v1/admin/reports/{report_id}` | 管理者 | 誤り報告の対応状態を更新する |

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

### ログアウト

`DELETE /api/v1/auth/logout`

初期実装ではサーバー側にトークンを保存しないため、APIは `204 No Content` を返し、フロントエンド側でトークンを破棄する。

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

* パスワードを再確認してから削除する
* ユーザーに紐づく演習履歴、お気に入り、問題別進捗なども削除する
* 成功時は `204 No Content` を返す

### パスワード再設定依頼

`POST /api/v1/password_resets`

リクエスト:

```json
{
  "email": "user@example.com"
}
```

メールアドレスの登録有無を外部から推測できないよう、存在しないメールアドレスでも同じ `202 Accepted` を返す。

```json
{
  "data": {
    "message": "登録されているメールアドレスの場合、再設定案内を送信しました"
  }
}
```

### パスワード再設定

`PATCH /api/v1/password_resets`

リクエスト:

```json
{
  "token": "reset-token",
  "password": "newPassword123",
  "password_confirmation": "newPassword123"
}
```

成功時は `204 No Content` を返す。

## 公開問題API

### 問題一覧取得

`GET /api/v1/questions`

クエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `major_category_code` | 大分類コードで絞り込む |
| `category_code` | 小分類コードで絞り込む |
| `difficulty` | 難易度で絞り込む |
| `page` | ページ番号 |
| `per_page` | 1ページの件数 |

* `publication_status = published` の問題のみ返す
* `category_code` を指定した場合は、対応する `major_category_code` との整合性を確認する
* ログイン済みの場合は `is_favorite` を返す
* 問題一覧では正答、解説、選択肢を返さない

レスポンス `200 OK`:

```json
{
  "data": [
    {
      "id": 101,
      "body": "問題文の冒頭...",
      "major_category_code": "teacher_education",
      "category_code": "education_law",
      "difficulty": "star1",
      "is_favorite": true
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total_count": 1200,
    "total_pages": 60
  }
}
```

未ログイン時の `is_favorite` は `false` とする。

### 問題詳細取得

`GET /api/v1/questions/{question_id}`

問題閲覧ページでは正答と解説を閲覧できる要件のため、このAPIは正答を含めて返す。ただし、演習中はこのAPIを使用せず、演習セッションAPIから正答を除いた問題を取得する。

レスポンス `200 OK`:

```json
{
  "data": {
    "id": 101,
    "body": "問題文",
    "explanation": "解答解説",
    "major_category_code": "teacher_education",
    "category_code": "education_law",
    "difficulty": "star1",
    "source_text": "参考資料",
    "is_favorite": true,
    "choices": [
      {
        "id": 1001,
        "choice_label": "ア",
        "body": "選択肢1",
        "display_order": 1,
        "is_correct": false
      },
      {
        "id": 1002,
        "choice_label": "イ",
        "body": "選択肢2",
        "display_order": 2,
        "is_correct": true
      }
    ]
  }
}
```

実際のレスポンスでは選択肢を4件返す。

### 誤り報告

`POST /api/v1/questions/{question_id}/reports`

リクエスト:

```json
{
  "report_body": "選択肢イの説明と正答が一致していないように見えます"
}
```

* 未ログインでも送信可能とする
* ログイン済みの場合のみ、認証情報から `user_id` を保存する
* 初期状態は `unhandled` とする
* 成功時は報告IDと受付完了メッセージを返す

## お気に入りAPI

### お気に入り一覧

`GET /api/v1/favorites`

問題一覧APIと同じ問題概要形式で返す。ページネーションに対応する。

### お気に入り登録

`POST /api/v1/questions/{question_id}/favorite`

リクエスト本文は不要とする。

レスポンス `201 Created`:

```json
{
  "data": {
    "question_id": 101,
    "is_favorite": true
  }
}
```

すでに登録済みの場合もエラーにせず、同じ状態を `200 OK` で返す。

### お気に入り解除

`DELETE /api/v1/questions/{question_id}/favorite`

登録がない場合もエラーにせず、`204 No Content` を返す。

## 演習API

### 演習状態

DBには専用の状態カラムを持たないため、以下のように判定する。

| 状態 | 判定 |
| --- | --- |
| `in_progress` | `finished_at` がNULL |
| `completed` | `finished_at` が入っている |

### 通常演習開始

`POST /api/v1/practice_sessions`

リクエスト:

```json
{
  "practice_type": "practice",
  "condition_type": "category",
  "major_category_code": "teacher_education",
  "category_code": "education_law",
  "extra_condition": "incorrect",
  "question_count": 10
}
```

入力規則:

| 条件 | 必須項目 |
| --- | --- |
| `condition_type = all` | 分野コードは指定しない |
| `condition_type = major_category` | `major_category_code` |
| `condition_type = category` | `major_category_code`, `category_code` |
| `extra_condition = favorite` | お気に入り登録済み問題を対象とする |
| `extra_condition = incorrect` | 不正解回数が1回以上の問題を対象とする |
| `extra_condition = unanswered` | 回答履歴がない問題を対象とする |

* 対象は公開中の問題のみとする
* 条件に合う問題をランダムに選択する
* 条件に合う問題が指定数未満の場合は `422 Unprocessable Entity` を返す
* 作成時の `correct_count` と `correct_rate` は0とする
* 選択した問題ごとに、`practice_answers` を未回答状態で作成する

レスポンス `201 Created`:

```json
{
  "data": {
    "id": 501,
    "practice_type": "practice",
    "status": "in_progress",
    "question_count": 10,
    "started_at": "2026-06-25T03:00:00Z",
    "questions": [
      {
        "id": 101,
        "body": "問題文",
        "major_category_code": "teacher_education",
        "category_code": "education_law",
        "difficulty": "star1",
        "choices": [
          {
            "id": 1001,
            "choice_label": "ア",
            "body": "選択肢1",
            "display_order": 1
          }
        ]
      }
    ]
  }
}
```

演習開始レスポンスには `is_correct`、正答ID、解説を含めない。

### 模擬試験開始

通常演習と同じ `POST /api/v1/practice_sessions` を使用する。

リクエスト:

```json
{
  "practice_type": "mock_exam"
}
```

サーバー側で以下を設定する。

* `condition_type = all`
* `extra_condition = none`
* `question_count = 20`
* `utils` の `MOCK_EXAM_CATEGORY_COUNTS` に従って、小分類ごとの問題数を選択する
* 同じ模擬問題セットを出題する場合は、未使用の `mock_exam_no` から1セットを選択する

問題不足により20問を構成できない場合は `422 Unprocessable Entity` を返す。

### 演習セッション取得

`GET /api/v1/practice_sessions/{practice_session_id}`

* セッション所有者のみ取得できる
* 回答済みかどうかと選択した選択肢IDを返す
* 完了前は未回答問題の正答を返さない
* 通常演習の回答済み問題は、回答APIで返された正誤・解説を再表示できる
* 模擬試験は完了まで正答・解説を返さない

### 回答保存

`POST /api/v1/practice_sessions/{practice_session_id}/answers`

リクエスト:

```json
{
  "question_id": 101,
  "selected_choice_id": 1002
}
```

共通処理:

* 対象問題がその演習セッションに含まれることを確認する
* 選択肢が対象問題に属することを確認する
* 演習開始時に作成した `practice_answers` を回答済み状態へ更新する
* `user_question_stats` の正解回数、不正解回数、連続正解数、最終回答日を更新する
* 同じ問題への2回目の回答は `409 Conflict` とする
* 完了済みセッションへの回答は `409 Conflict` とする

通常演習のレスポンス `200 OK`:

```json
{
  "data": {
    "question_id": 101,
    "selected_choice_id": 1002,
    "is_correct": true,
    "correct_choice_id": 1002,
    "explanation": "解答解説",
    "answered_at": "2026-06-25T03:05:00Z"
  }
}
```

模擬試験では完了前に正答を表示しない。

```json
{
  "data": {
    "question_id": 101,
    "selected_choice_id": 1002,
    "answered": true,
    "answered_at": "2026-06-25T03:05:00Z"
  }
}
```

### 演習完了

`PATCH /api/v1/practice_sessions/{practice_session_id}/complete`

* セッション所有者のみ実行できる
* 原則として全問回答済みの場合のみ完了できる
* 正答数、正答率、終了日時を集計・保存する
* 模擬試験は正答数が12問以上の場合に `is_passed = true` とする
* 通常演習の `is_passed` はNULLとする

レスポンス `200 OK`:

```json
{
  "data": {
    "id": 501,
    "practice_type": "mock_exam",
    "status": "completed",
    "question_count": 20,
    "correct_count": 13,
    "correct_rate": 65.0,
    "is_passed": true,
    "finished_at": "2026-06-25T03:30:00Z"
  }
}
```

### 演習結果取得

`GET /api/v1/practice_sessions/{practice_session_id}/result`

完了したセッションのみ取得できる。

```json
{
  "data": {
    "id": 501,
    "practice_type": "mock_exam",
    "question_count": 20,
    "correct_count": 13,
    "correct_rate": 65.0,
    "is_passed": true,
    "started_at": "2026-06-25T03:00:00Z",
    "finished_at": "2026-06-25T03:30:00Z",
    "answers": [
      {
        "question_id": 101,
        "question_body": "問題文",
        "selected_choice_id": 1002,
        "correct_choice_id": 1002,
        "is_correct": true,
        "explanation": "解答解説"
      }
    ]
  }
}
```

### 演習履歴

`GET /api/v1/practice_sessions`

クエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `practice_type` | `practice`, `mock_exam` で絞り込む |
| `page` | ページ番号 |
| `per_page` | 1ページの件数 |

完了済みセッションを `finished_at` の降順で返す。

### 問題別進捗

`GET /api/v1/question_stats`

クエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `major_category_code` | 大分類で絞り込む |
| `category_code` | 小分類で絞り込む |
| `page` | ページ番号 |
| `per_page` | 1ページの件数 |

レスポンスには以下を含める。

```json
{
  "data": [
    {
      "question_id": 101,
      "question_body": "問題文の冒頭...",
      "major_category_code": "teacher_education",
      "category_code": "education_law",
      "correct_count": 3,
      "incorrect_count": 1,
      "consecutive_correct_count": 2,
      "medal": "silver",
      "last_answered_at": "2026-06-25T03:05:00Z"
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

`medal` はDBに保存せず、`consecutive_correct_count` と `utils` の条件から算出する。

### マイページ概要

`GET /api/v1/mypage_summary`

画面表示時の通信回数を減らすため、マイページに必要な集計値をまとめて返す。

```json
{
  "data": {
    "total_answered_count": 120,
    "total_correct_count": 84,
    "overall_correct_rate": 70.0,
    "favorite_count": 15,
    "recent_sessions": []
  }
}
```

## 管理API

管理APIはすべてBearerトークン認証を必須とし、`role = admin` のユーザーのみ利用できる。

### 管理ダッシュボード

`GET /api/v1/admin/dashboard`

```json
{
  "data": {
    "question_count": 1200,
    "published_question_count": 1180,
    "unhandled_report_count": 3
  }
}
```

### 管理問題一覧

`GET /api/v1/admin/questions`

クエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `keyword` | 問題文の部分一致検索 |
| `major_category_code` | 大分類で絞り込む |
| `category_code` | 小分類で絞り込む |
| `difficulty` | 難易度で絞り込む |
| `publication_status` | 公開状態で絞り込む |
| `page` | ページ番号 |
| `per_page` | 1ページの件数 |

下書き・公開・非公開をすべて取得対象とする。

### 管理問題詳細

`GET /api/v1/admin/questions/{question_id}`

問題本文、解説、分類、難易度、根拠資料、公開状態、模擬問題セット番号、4件の選択肢を返す。各選択肢には `is_correct` を含める。

### 問題作成

`POST /api/v1/admin/questions`

リクエスト:

```json
{
  "question": {
    "body": "問題文",
    "explanation": "解答解説",
    "major_category_code": "teacher_education",
    "category_code": "education_law",
    "difficulty": "star1",
    "source_text": "参考資料",
    "publication_status": "draft",
    "mock_exam_no": 1,
    "mock_exam_question_no": 1,
    "choices": [
      {
        "choice_label": "ア",
        "body": "選択肢1",
        "display_order": 1,
        "is_correct": false
      },
      {
        "choice_label": "イ",
        "body": "選択肢2",
        "display_order": 2,
        "is_correct": true
      },
      {
        "choice_label": "ウ",
        "body": "選択肢3",
        "display_order": 3,
        "is_correct": false
      },
      {
        "choice_label": "エ",
        "body": "選択肢4",
        "display_order": 4,
        "is_correct": false
      }
    ]
  }
}
```

バリデーション:

* 選択肢は4件
* 正答は1件
* `category_code` は指定した `major_category_code` に属する
* 難易度、公開状態、分野コードは `utils` に定義された値
* `mock_exam_no` は1〜60
* `mock_exam_question_no` は1〜20

問題と選択肢はトランザクション内で一括登録する。

### 問題更新

`PATCH /api/v1/admin/questions/{question_id}`

問題作成と同じ形式で、変更対象を送信する。選択肢の更新では各要素に `id` を含める。

問題本文のみ、または公開状態のみの部分更新も許可する。

```json
{
  "question": {
    "publication_status": "published"
  }
}
```

### 問題削除

`DELETE /api/v1/admin/questions/{question_id}`

* 回答履歴が存在しない問題は物理削除する
* 回答履歴が存在する問題は履歴保全のため削除せず、`publication_status = private` への変更を促す
* 回答履歴がある場合は `409 Conflict` を返す

### 誤り報告一覧

`GET /api/v1/admin/reports`

クエリパラメータ:

| パラメータ | 内容 |
| --- | --- |
| `status` | 対応状態で絞り込む |
| `question_id` | 問題IDで絞り込む |
| `page` | ページ番号 |
| `per_page` | 1ページの件数 |

`created_at` の降順で返す。

### 誤り報告詳細

`GET /api/v1/admin/reports/{report_id}`

報告内容、対応状態、管理者メモ、報告対象問題、報告ユーザー情報を返す。未ログイン報告の場合、ユーザー情報はNULLとする。

### 誤り報告更新

`PATCH /api/v1/admin/reports/{report_id}`

リクエスト:

```json
{
  "status": "fixed",
  "admin_memo": "問題文と解説を修正済み"
}
```

* `status` は `unhandled`, `in_progress`, `fixed`, `rejected` のいずれかとする
* `fixed` または `rejected` への変更時は、認証中の管理者を `resolved_by_user_id` に保存し、`resolved_at` を設定する
* `unhandled` または `in_progress` に戻した場合は、`resolved_by_user_id` と `resolved_at` をNULLに戻す

## 固定値の扱い

固定値の取得APIは作成しない。以下のファイルをフロントエンドの表示、バックエンドのバリデーションおよび演習抽出条件に使用する。

* `frontend/app/utils/masterData.ts`
* `backend/app/utils/master_data.rb`

対象:

* ユーザー権限
* 大分類・小分類
* 難易度
* 公開状態
* 誤り報告対応状態
* 演習種別
* 出題条件
* 追加条件
* メダル条件
* 模擬試験の分野別出題数

フロントエンドとバックエンドで値がずれないよう、変更時は両方のファイルを同じプルリクエストで更新する。

## CORS

許可するオリジンは環境変数で管理する。

| 環境 | 設定例 |
| --- | --- |
| 開発 | `http://localhost:3000` |
| 本番 | Vercelで公開したフロントエンドURL |

許可する主なヘッダー:

* `Authorization`
* `Content-Type`
* `Accept`

許可するHTTPメソッド:

* `GET`
* `POST`
* `PATCH`
* `DELETE`
* `OPTIONS`

## セキュリティ・実装上の注意

* パスワードおよびパスワード再設定トークンは平文保存しない
* 認証ユーザーID、管理者IDはリクエスト本文から受け取らず、アクセストークンから決定する
* 一般ユーザーは他ユーザーの演習セッション、履歴、お気に入り、問題別進捗を取得できない
* 管理者用問題API以外では、下書き・非公開問題を返さない
* 演習完了前のレスポンスから正答や `is_correct` が漏れないよう、公開閲覧用・演習用・管理用でレスポンス生成処理を分ける
* 問題作成・更新、回答保存、演習完了時の集計はDBトランザクションを使用する
* 一覧APIではN+1クエリを避けるため、必要な関連データを事前読み込みする
* 本番環境では例外メッセージやスタックトレースをレスポンスに含めない
* ログにパスワード、アクセストークン、再設定トークンを出力しない

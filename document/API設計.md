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
* 未ログインユーザーも模擬試験1〜5には回答できるが、回答履歴は保存しない
* ログインユーザーが回答した場合のみ、回答履歴を1問単位で保存する
* 回答前のレスポンスには、正答や解答解説を含めない
* 模擬試験6以降は、有効な有料会員資格を持つユーザーまたは管理者だけが取得・回答できる
* 有料会員資格は `users.role` と分離し、Stripeの署名検証済みWebhookを起点に更新する

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
* 有料コンテンツの利用可否はトークン内へ固定せず、リクエストごとにDBの有料会員資格を確認する
* 一般画面と管理画面は、フロントエンドに保持した同一のアクセストークンを使用する
* 管理ログインでも一般ログインと同じ `POST /api/v1/auth/login` を使用し、レスポンスの `user.role` が `admin` であることを確認する
* 本番環境ではHTTPSを必須とする
* Nuxtのサーバー側ユーザー確認は、設定済みなら非公開の `NUXT_API_BASE_INTERNAL` を接続先に使う。未設定なら公開APIのURLを使う。ブラウザの接続先とBearer認証・管理者権限の検査は変更しない。

Bearerトークン方式は、VercelとFly.ioでフロントエンドとバックエンドのドメインが分かれる構成を想定して採用する。

### 任意認証

試験一覧、問題取得及び問題回答APIは認証を任意とする。

* Authorizationヘッダーがない場合は、模擬試験1〜5だけを利用でき、回答履歴を保存しない
* 有効なAuthorizationヘッダーがある場合は、DBの有料会員資格と管理者権限に応じて利用範囲を判定し、回答時は履歴を保存する
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
| `fill_in_text` | 過去問形式の穴埋め問題文 | `text` |
| `fill_in_quote` | 空欄ラベルを含む抜粋文 | `text`。空欄は `{{①}}` などで表す |
| `fill_in_choice` | 空欄ごとの語句を並べた選択肢 | `cells` |
| `table` | 表 | `headers`, `rows` |
| `code` | 単独のプログラム表記 | 任意の `title`, `code` |
| `code_group` | 複数プログラムの比較 | `items`。各要素に `title`, `code` |

問題本文では `text`, `quote`, `fill_in_text`, `fill_in_quote`, `table`, `code`, `code_group` を使用できる。選択肢では `text`, `table`, `fill_in_choice`、解答解説では `text`, `quote`, `table`, `code` を使用できる。

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
| `403 Forbidden` | `forbidden`, `paid_membership_required` | 管理者権限不足、他ユーザーのデータへのアクセス、有料会員資格不足 |
| `404 Not Found` | `not_found` | 対象が存在しない、非公開問題への一般アクセス |
| `409 Conflict` | `membership_already_active`, `checkout_session_in_progress` | 有料会員の重複購入、未完了の決済が存在する |
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
| POST | `/api/v1/auth/login` | 不要 | 一般画面または管理画面からログインし、アクセストークンを発行する |
| GET | `/api/v1/me` | 必要 | ログインユーザー情報を取得する |
| DELETE | `/api/v1/me` | 必要 | ログインユーザーのアカウントを物理削除する |

### 問題演習

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/exams` | 任意 | 公開中の試験ナンバーと現在のユーザーの利用可否を取得する |
| GET | `/api/v1/questions/next` | 任意 | 利用可能な公開中の問題を1問取得する |
| GET | `/api/v1/questions/{question_id}` | 任意 | 利用可能な指定問題を取得する |
| POST | `/api/v1/questions/{question_id}/answer` | 任意 | 回答を判定し、ログイン時のみ履歴を保存する |

### 有料会員・決済

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| POST | `/api/v1/payments/checkout_sessions` | 必要 | 500円の買い切り用Stripe Checkout Sessionを作成する |
| POST | `/api/v1/webhooks/stripe` | Stripe署名 | Stripeの決済・返金・異議申立てイベントを処理する |

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
      "role": "user",
      "paid_content_access": false,
      "membership": {
        "status": "free",
        "purchased_at": null,
        "expires_at": null
      }
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
    "paid_content_access": true,
    "membership": {
      "status": "active",
      "purchased_at": "2026-10-07T03:00:00Z",
      "expires_at": null
    },
    "created_at": "2026-06-25T03:00:00Z"
  }
}
```

* `membership.status = free` は有効な `memberships` レコードがない場合にAPIが返す表示用の状態とする
* `paid_content_access` は、有料会員または管理者なら `true` とする

### アカウント削除

`DELETE /api/v1/me`

リクエスト:

```json
{
  "current_password": "password123"
}
```

現在のパスワードが一致した場合、ユーザー、回答履歴、お気に入り及び有料会員資格を物理削除し、`204 No Content` を返す。決済記録は、ユーザーとの関連を `NULL` にして、会計、返金及びStripeとの照合に必要な最小限の情報だけを保持する。削除による自動返金と、再登録時の有料会員資格の復元は行わない。

## 問題演習API

### 利用権限の共通ルール

| 利用者 | 模擬試験1〜5 | 模擬試験6以降 |
| --- | --- | --- |
| 未ログインユーザー | 利用可 | 利用不可 |
| 無料会員 | 利用可 | 利用不可 |
| 有料会員 | 利用可 | 利用可 |
| 管理者 | 利用可 | 利用可 |

* 判定対象は試験一覧、次の問題取得、指定問題取得、回答、回答履歴詳細及びお気に入り登録とする
* 未ログインユーザーが模擬試験6以降を要求した場合は `401 Unauthorized` を返す
* 無料会員が模擬試験6以降を要求した場合は `403 Forbidden` と `paid_membership_required` を返す
* 非公開問題は権限の有無にかかわらず一般向けAPIから取得できず、`404 Not Found` を返す

### 試験一覧

`GET /api/v1/exams`

公開中の問題がある試験ナンバーを、現在のユーザーの利用可否とともに返す。利用不可の試験でも問題本文、選択肢、正答及び解説は返さない。

```json
{
  "data": [
    {
      "exam_number": 1,
      "published_question_count": 20,
      "access": "available"
    },
    {
      "exam_number": 6,
      "published_question_count": 20,
      "access": "paid_membership_required"
    }
  ]
}
```

### 次の問題取得

`GET /api/v1/questions/next`

公開状態が `published` で、現在のユーザーが利用できる問題から1問取得する。

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
    "category_code": "education_system",
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
* `exam_number` を指定しない場合も、現在のユーザーが利用できない試験ナンバーを候補に含めない
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
* 問題取得時と同じ利用権限を回答前にも再検査する

## 有料会員・決済API

### Checkout Session作成

`POST /api/v1/payments/checkout_sessions`

ログイン中の無料会員に対し、Stripe Checkoutのホスト型決済ページへ進むためのSessionを作成する。リクエスト本文から商品、金額、通貨又は数量を受け取らず、サーバーに設定したStripe Price IDを使用する。

リクエスト:

```json
{}
```

レスポンス `201 Created`:

```json
{
  "data": {
    "checkout_session_id": "cs_test_example",
    "checkout_url": "https://checkout.stripe.com/c/pay/example"
  }
}
```

* Stripe Checkout Sessionは `mode = payment`、数量1、初期対応の決済手段はカードとして作成する
* 金額は500円、通貨は `jpy` とし、Stripe上のPrice設定とサーバーの期待値が一致しない場合はSessionを作成しない
* ログインユーザーIDをStripeの `client_reference_id` または `metadata` に設定し、ローカルの決済記録と照合する
* Session作成後、Checkout Session IDを持つ `pending` の決済記録を保存してからURLを返す
* Stripe APIへの作成要求には冪等性キーを使用し、同一ユーザーからの再送でSessionを重複作成しない
* 有料会員または管理者からの要求は `409 Conflict` と `membership_already_active` を返す
* 有効な未完了Sessionが存在する場合は、そのSessionの再利用または `409 Conflict` と `checkout_session_in_progress` のいずれかに統一し、二重決済を防ぐ
* `success_url` は `/premium/complete`、`cancel_url` は `/premium` を基準とし、許可済みフロントエンドURLからサーバー側で組み立てる

### Stripe Webhook

`POST /api/v1/webhooks/stripe`

Bearerトークンは使用しない。未加工のリクエスト本文、`Stripe-Signature` ヘッダー及び環境変数のWebhook署名シークレットをStripe公式ライブラリへ渡し、署名を検証する。署名不正またはJSON不正は `400 Bad Request` とし、状態を更新しない。

初期実装で処理するイベント:

| イベント | 処理 |
| --- | --- |
| `checkout.session.completed` | `payment_status = paid`、商品、金額、通貨、ユーザー及びCheckout Session IDを照合し、決済を `paid`、有料会員資格を `active` にする |
| `checkout.session.expired` | 未完了の決済を `expired` にする |
| `refund.created`, `refund.updated` | Refundの状態を確認し、成立済みの返金額を反映する。全額返金が成立した場合は決済を `refunded`、資格を `revoked` にする |
| `refund.failed` | 返金失敗を記録し、運営者が確認できるようにする |
| `charge.dispute.created` | 決済を `disputed`、資格を `revoked` にして利用を停止する |
| `charge.dispute.closed` | 結果を記録する。資金回復後の資格再開は自動化せず、運営者がStripeの状態を確認して行う |

* Stripe Event IDを一意に保存し、処理済みイベントの再送には状態を変更せず `200 OK` を返す
* Event IDの保存、決済状態の更新及び資格の更新は同一DBトランザクションで確定する
* 処理に失敗した場合はDBをロールバックし、Stripeが再送できるように `5xx` を返す
* 部分返金は購入者向け機能として提供しない。発生した場合は返金額を記録して運営確認とし、全額返金になるまで資格を自動失効させない
* ブラウザの戻り先、URLクエリ、Checkout Sessionの `status = complete` だけでは資格を付与せず、`payment_status = paid` の署名検証済みイベントを必要とする

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
        "category_code": "education_system"
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
* 現在の利用権限で閲覧できない模擬試験6以降の履歴は、`locked = true`、試験ナンバー、問番号及び回答日時だけを返し、問題・選択肢の概要、正答、正誤及び解説を返さない

### 回答履歴詳細

`GET /api/v1/answer_histories/{answer_history_id}`

一覧の内容に加えて、正答、解答解説、根拠資料を返す。他ユーザーの回答履歴には `404 Not Found` を返す。現在の利用権限で閲覧できない模擬試験6以降の履歴には `403 Forbidden` と `paid_membership_required` を返す。

## お気に入りAPI

### お気に入り一覧

`GET /api/v1/favorites`

ログインユーザー本人のお気に入りを新しい順に返す。各項目には問題ID、試験ナンバー、問番号、問題文の概要、大分類、小分類、登録日時を含める。現在の利用権限で閲覧できない模擬試験6以降は `locked = true` とし、問題文の概要、分類及び選択肢を返さない。

### お気に入り登録

`PUT /api/v1/questions/{question_id}/favorite`

* 対象は公開中の問題に限る
* 対象問題が模擬試験6以降の場合は、有効な有料会員資格または管理者権限を必要とする
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
| 小分類 | `education_foundations`, `teaching_profession`, `education_system`, `educational_psychology`, `special_support_education`, `curriculum_organization`, `moral_education`, `integrated_inquiry`, `special_activities`, `education_methods`, `ict_in_education`, `student_guidance_career`, `educational_counseling`, `career_education`, `information_specialized`, `information_education` |
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
    * Railsの共通設定で `password`、`token`、`secret`、`api_key`、`authorization`、`cookie` を含むキーを、大文字・小文字を区別せずフィルタリングする。確認用・現在のパスワード、入れ子の値、ログ用リクエスト環境の認証・Cookieヘッダーも対象とする
    * フィルターを通さない生の本文・ヘッダー・レスポンス・環境変数を独自にログへ出力しない。設定変更前に保存されたログは遡って保護されない
* 公開問題取得時は `question_choices.is_correct`、解答解説、根拠資料を返さない
* 回答判定は必ずサーバー側で行う
* 一般ユーザーは自分の回答履歴とお気に入りだけ取得できる
* 模擬試験6以降の利用権限は、試験一覧、問題取得、回答、回答履歴及びお気に入りの各APIでサーバー側が確認する
* 管理APIはすべて管理者権限を確認する
* 問題の更新はseedと共通の保存処理を使用する。本文・選択肢・正答・解説・出典・分類の変更時は、その問題の古い回答履歴を同一トランザクション内で削除する。公開状態だけの変更では削除しない
* 選択肢はア・イ・ウ・エ各1件・正答1件を保存前後で保証する。重複ID、他の問題のID、IDとラベルの不一致を拒否する
* 公開時は本文・解説・選択肢の実内容、出典のHTTPSリンク形式、空欄ラベルと全選択肢のセル数を検査する。draftでは内容が未完成でも保存できるが、選択肢の構造は維持する。不正な入力は `422` の `validation_error` とする
* seed管理中の試験ナンバー・問番号の変更は `422` で拒否する。管理APIでの削除は同期記録にも残し、seedによる再作成を防ぐ
* 管理画面のルートガードと管理APIの両方で権限を確認し、フロントエンドの画面制御だけに依存しない
* コンテンツブロックでは許可したキーと文字列だけを受け付け、任意のHTMLやスクリプトを保存・描画しない
* 会員登録、ログイン、回答及びCheckout Session作成APIには必要に応じてレート制限を設ける
* アカウント削除と問題削除はトランザクションで実行する
* Stripeのシークレットキー、Webhook署名シークレット及びPrice IDは環境変数で管理し、ログやAPIレスポンスへ出力しない
* Webhookは未加工の本文で署名検証し、Stripe Event ID及びCheckout Session IDの一意制約とDBトランザクションで冪等に処理する

### Stripe関連の環境変数

| 環境変数 | 用途 | 公開範囲 |
| --- | --- | --- |
| `STRIPE_SECRET_KEY` | RailsからStripe APIを呼び出すシークレットキー | バックエンドのみ |
| `STRIPE_WEBHOOK_SECRET` | Stripe Webhookの署名検証 | バックエンドのみ |
| `STRIPE_PRICE_ID` | 500円の買い切り商品に対応するPrice ID | バックエンドのみ |
| `FRONTEND_URL` | Checkoutの成功・中止時の戻り先を組み立てる許可済みURL | バックエンドのみ |

* テスト環境と本番環境のキー、Webhook署名シークレット及びPrice IDを混在させない
* 上記の値はリポジトリへ保存せず、ローカルの `.env` とデプロイ先のSecretで管理する

## Stripe公式資料

* Checkout Session作成: https://docs.stripe.com/api/checkout/sessions/create
* Checkout Sessionの `payment_status`: https://docs.stripe.com/api/checkout/sessions/object
* Webhook署名検証と再送時の処理: https://docs.stripe.com/events/manage-webhook-endpoints
* 返金イベント: https://docs.stripe.com/refunds

# API設計

## 設計方針

* NuxtのNitro/H3 APIからブラウザへJSON形式でデータを提供する。Node.js 24 / TypeScriptで実装し、URLの振り分けは `frontend/server/api/` のファイルベースルーティングを使用する
* 業務APIのベースパスは `/api/v1`、Better Authのベースパスは `/api/auth` とする
* 業務APIのJSONキーは既存契約の `snake_case` を維持する。Better Auth標準APIはライブラリの形式を使用する
* 日時はISO 8601形式のUTCで返す
    * 例: `2026-06-25T03:00:00Z`
* 一覧APIは原則としてページネーションに対応する。復習開始時に全対象の正確な問題ペアが必要な「間違えた問題」の復習対象APIだけはページ分割しない
* 分野・試験構成・料金は `config/exam.json` を正本とし、共有設定とZodスキーマを画面・APIで使用する
* 問題は1問ずつ取得し、演習セッションや演習完了処理は設けない
* 問題は `exam_number` ごとに20問を配置し、各問を `question_number` で並べる
* 未ログインユーザーも模擬試験1〜5には回答できるが、回答履歴は保存しない
* ログインユーザーが回答した場合のみ、回答履歴を1問単位で保存する
* 回答前のレスポンスには、正答や解答解説を含めない
* 模擬試験6以降は、有効なプレミアム会員資格を持つユーザーまたは管理者だけが取得・回答できる
* プレミアム会員資格は `users.role` と分離し、Stripeの署名検証済みWebhookを起点に更新する

## 認証方式

Better Authのメール・パスワード認証とDB保存型のCookieセッションを使用する。旧 `/api/v1/auth/signup`、`/api/v1/auth/login` とBearerトークンは使用しない。

* CookieはHttpOnly・SameSite=Lax・Path=/、Domain指定なし。本番HTTPSではSecureとする。Cookie名は `site.id` を含む独立した接頭辞を使用する
* セッション期限は24時間。Cookieキャッシュ・自動セッション更新は無効とし、毎回Better Authと現在のDBユーザーを確認する
* パスワードハッシュの生成・検証、登録・ログイン・ログアウト、セッション失効はBetter Authへ委ねる
* 管理APIはDBの現在の `role = admin` を確認する。有料資格も各APIでDBを確認し、セッション内へ固定しない
* 一般画面と管理画面は同じCookieセッションを共有する。ログアウトは `/api/auth/sign-out` でサーバー側のセッションも破棄する
* ブラウザの会員情報取得は共通状態と同世代の処理中リクエストを共有する。ログイン・会員登録で完了した本人情報取得を、同じ操作のBetter Auth通知だけで再実行しない。別タブ・別セッションの通知は従来どおり確認する
* Netlifyの `/api/*` はFly.ioの同名APIへ転送し、ブラウザは同一オリジンへアクセスする。秘密鍵とDB接続情報はFly.io側だけに保持する
* 変更系業務APIには許可したOriginとJSONを要求する。認証APIにはBetter AuthのOrigin/CSRF検査も適用する。Stripe Webhookは未加工本文の署名で認証する
* 公開するBetter Auth APIは登録・ログイン・ログアウト・セッション取得の4種類だけ。パスワード再設定・SNSログイン・メール変更等は今回の対象外

公開前のサイト閲覧制限はNetlifyのPrivate設定を維持する。Fly.ioはAPI専用モードで画面と静的アセットを配信せず、API自体の管理者・会員・有料認可は別途必ず実施する。

### 任意認証

試験一覧、問題取得及び問題回答APIは認証を任意とする。

* 有効なCookieセッションがない場合は、模擬試験1〜5だけを利用でき、回答履歴を保存しない
* 有効なCookieセッションがある場合は、DBのプレミアム会員資格と管理者権限に応じて利用範囲を判定し、回答時は履歴を保存する
* 認証Cookieが提示されたものの不正又は期限切れの場合は、任意認証APIも `401 Unauthorized` を返す。ログイン中の回答を匿名回答として扱って履歴を失わないためであり、Better Authで無効なCookieも破棄する。認証Cookieがない場合と無関係のCookieだけの場合は、従来どおり無料範囲を匿名で利用できる

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
| `fill_in_quote` | 試験形式の抜粋文 | `text`。空欄がある場合は `{{①}}` などで表す |
| `fill_in_choice` | 空欄ごとの語句を並べた選択肢 | `cells` |
| `table` | 表 | `headers`, `rows` |
| `code` | 単独のプログラム表記 | 任意の `title`, `code` |
| `code_group` | 複数プログラムの比較 | `items`。各要素に `title`, `code` |

問題本文では `text`, `quote`, `fill_in_text`, `fill_in_quote`, `table`, `code`, `code_group` を使用できる。選択肢では `text`, `table`, `fill_in_choice`、解答解説では `text`, `quote`, `table`, `code` を使用できる。

管理画面でもこの用途別の種別を新規追加できる。`fill_in_choice.cells` は①〜⑥に対応する1〜6個の個別入力で編集し、選択中の個数の文字列配列を従来どおり送信する。列数を減らした際の入力値の一時保持は画面内だけの機能であり、APIに補助属性は追加しない。公開時の空欄・セル整合検査はサーバーで行い、下書きでは未完成の語句も保存できる。

試験問題の抜粋枠は、本文に空欄がない条文選択問題や、別の表に空欄がある問題でも `fill_in_quote` を使用し、通常の試験抜粋と同じ白背景・四辺枠で表示する。`quote` は一般の枠付き引用に使用する。穴埋め問題かどうかはブロック種別だけで判定せず、実際の空欄ラベルと選択肢の `cells` の対応で検査する。

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
| `401 Unauthorized` | `unauthorized` | 未ログイン、セッション不正・期限切れ |
| `403 Forbidden` | `forbidden`, `paid_membership_required` | 管理者権限不足、他ユーザーのデータへのアクセス、プレミアム会員資格不足 |
| `404 Not Found` | `not_found` | 対象が存在しない、非公開問題への一般アクセス |
| `409 Conflict` | `membership_already_active`, `checkout_session_in_progress` | プレミアム会員の重複購入、未完了又は完了確認中の決済が存在する |
| `422 Unprocessable Entity` | `validation_error` | バリデーションエラー、選択肢の指定不正 |
| `429 Too Many Requests` | `rate_limit_exceeded` | 登録・ログイン・回答・Checkoutの一時的な回数上限 |
| `500 Internal Server Error` | `internal_server_error` | サーバー内部エラー |
| `502 Bad Gateway` | `payment_provider_error` | Stripe APIへの接続失敗 |
| `503 Service Unavailable` | `payment_unavailable`, `webhook_unavailable`, `rate_limiter_unavailable` | 決済・Webhookの必須設定不足、又は回数制限用DBの障害 |

### 操作回数の制限

認証の入口はBetter Authの標準レート制限、保存先と業務APIはrate-limiter-flexibleのPostgreSQL共有ストアを使用し、成功・失敗を問わず次の操作を数える。追加APIやRedisは使用しない。2026年10月21日、所有者は個人学習を中心とし、学校等の共有IPからの一斉利用は想定しないと確認した。この想定で以下の初期値を維持し、実利用で支障が見られた場合に見直す。共有IPの利用禁止や、全利用条件で制限に達しないことの保証ではない。

| 対象 | 単位 | 固定時間窓の上限 |
| --- | --- | --- |
| `POST /api/auth/sign-up/email` | IP | 15分10回 |
| `POST /api/auth/sign-in/email` | IP | 5分30回 |
| `POST /api/v1/questions/:id/answer` | IP | 1分120回 |
| `POST /api/v1/payments/checkout_sessions` | IP、ログインユーザーそれぞれ | 5分20回、5分10回 |

- 上限を超えた操作は処理前に `429` と既存のエラー形式を返す。次の窓までの秒数を `Retry-After`、キャッシュ禁止を `Cache-Control: no-store` で示す。境界の前後では短時間に2窓分の操作が可能な方式であり、厳密な直近N分の上限ではない。
- Checkoutは認証後、IP・ユーザーの順で確認する。Webhook、公開GET、管理API等へこの制限を流用しない。Stripeの署名検証・再送・冪等性は従来どおり維持する。
- カウンター保存が失敗した場合は制限を迂回せず `503 rate_limiter_unavailable`、`Retry-After: 60` を返す。
- Fly.ioではFly Proxyが付ける `Fly-Client-IP`、それ以外は直接接続の `REMOTE_ADDR` を正規化して使う。任意の `X-Forwarded-For` は信用しない。別のプロキシを追加するときは信頼境界を再点検する。
- IP・ユーザーIDの平文はカウンターへ保存せず、秘密鍵付きハッシュ・回数・失効時刻だけを保存する。多量通信へのネットワーク防御の代替にはならない。
- 本番の適用状況とローカル追加試験の範囲は `document/運用手順.md` の確認記録を参照する。利用想定の決定と、実環境での性能確認は区別する。

## API一覧

### システム

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/health` | 不要 | APIの稼働状態を取得する |

### 認証・アカウント

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| POST | `/api/auth/sign-up/email` | 不要 | Better Authで会員登録・セッション発行 |
| POST | `/api/auth/sign-in/email` | 不要 | 一般・管理画面共通のログイン |
| POST | `/api/auth/sign-out` | Cookie | サーバー側セッションの破棄 |
| GET | `/api/auth/get-session` | 任意 | Better Authのセッション取得 |
| GET | `/api/v1/me` | 必要 | ログインユーザー情報を取得する |
| DELETE | `/api/v1/me` | 必要 | ログインユーザーのアカウントを物理削除する |

### 問題演習

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/exams` | 任意 | 公開中の試験ナンバーと現在のユーザーの利用可否を取得する |
| GET | `/api/v1/questions/next` | 任意 | 利用可能な公開中の問題を1問取得する |
| GET | `/api/v1/questions/{question_id}` | 任意 | 利用可能な指定問題を取得する |
| POST | `/api/v1/questions/{question_id}/answer` | 任意 | 回答を判定し、ログイン時のみ履歴を保存する |

### プレミアム会員・決済

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/payments/config` | 不要 | 販売可否、金額、通貨及び無料範囲を取得する |
| POST | `/api/v1/payments/checkout_sessions` | 必要 | 500円の買い切り用Stripe Checkout Sessionを作成する |
| POST | `/api/v1/webhooks/stripe` | Stripe署名 | Stripeの決済・返金・異議申立てイベントを処理する |

### 回答履歴

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/answer_histories` | 必要 | ログインユーザーの回答履歴を取得する |
| GET | `/api/v1/answer_histories/{answer_history_id}` | 必要 | 回答履歴の詳細と解説を取得する |

### 間違えた問題の復習

| メソッド | パス | 認証 | 概要 |
| --- | --- | --- | --- |
| GET | `/api/v1/review_questions/incorrect` | 必要 | 最新回答が不正解で、現在利用できる公開問題の位置を取得する |

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

### 会員登録・ログイン・ログアウト

Better Authクライアントを使用する。会員登録は `POST /api/auth/sign-up/email` へ `name`、`email`、`password`、ログインは `POST /api/auth/sign-in/email` へ `email`、`password` をJSONで渡す。パスワード確認欄は画面の共通Zodスキーマで一致を検証し、APIへは送らない。

レスポンスとエラーはBetter Auth標準形式（エラーは `code` / `message`）とする。業務APIの `{ data: ... }` / `{ error: ... }` 形式で包まない。成功後は `/api/v1/me` でアプリ用の権限・有料資格・お気に入り情報を取得する。クライアントがCookie値を読み取り、Bearerヘッダーへ変換する処理は設けない。

`POST /api/auth/sign-out` はセッションを破棄する。`GET /api/auth/get-session` は未ログインの場合 `null`、ログイン中はBetter Authのセッション・ユーザーを返す。認証機能を許可リストで限定しており、他のBetter Authパスは404とする。

認証エラー・入力エラーは共通フォーム部品へ割り当てて表示する。429は `Retry-After` と固定メッセージを返す。ライブラリやDBの内部例外は利用者へ返さない。

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
    "favorite_questions": [
      { "id": 102, "exam_number": 6, "question_number": 2 }
    ],
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
* `paid_content_access` は、プレミアム会員、管理者又は有効な検証用資格がある場合に `true` とする。検証用資格は決済による購入資格とは独立させる
* `verification_access` は検証用資格が有効な場合だけ `{ "expires_at": "ISO 8601日時" }`、それ以外は `null` とする。付与理由・付与者は一般APIへ返さない。`/api/v1/me` のアプリ用ユーザー形式へ追加する
* 検証用資格だけを持つ一般会員の `membership.status` は `free`、`membership.purchased_at` は `null` のままとし、購入済みと偽らない。管理画面は引き続き `role = admin` のみ許可する
* 検証用資格の期限切れ・取消は各APIリクエストで判定し、同じセッションでも以後は有料問題・お気に入りを拒否する。付与・取消のHTTPエンドポイントは追加しない
* `favorite_questions` は本人が登録した公開中の問題の位置一覧とする。各項目は `id`、`exam_number`、`question_number` のみで、本文・解説・選択肢を含めない。試験ナンバー・問番号順に全件を返し、一覧ページのページ分割とは独立させる
* アプリ用ユーザー情報は `/api/v1/me` で取得する。無料会員には `favorite_questions: []` を返し、お気に入りテーブルを照会しない
* サイドバーは同梱した一覧を共有状態として参照する。色付け専用のAPI、開閉・画面移動時の再取得、登録解除後の確認用GETは追加しない。通常の再読み込み・再ログイン時に同期する

### アカウント削除

`DELETE /api/v1/me`

リクエスト:

```json
{
  "current_password": "password123"
}
```

現在のパスワードが一致した場合、未完了のStripe Checkout Sessionを失効させた上で、ユーザー、回答履歴、お気に入り及びプレミアム会員資格を物理削除し、`204 No Content` を返す。Sessionが完了済みでWebhookの確認中である場合は、`409 Conflict` と `checkout_session_in_progress` を返して削除しない。Stripeへ接続できず未完了Sessionの安全な失効を確認できない場合も削除しない。

決済記録は、ユーザーとの関連を `NULL` にして、会計、返金及びStripeとの照合に必要な最小限の情報だけを保持する。削除による自動返金と、再登録時のプレミアム会員資格の復元は行わない。

## 問題演習API

### 利用権限の共通ルール

| 利用者 | 模擬試験1〜5 | 模擬試験6以降 |
| --- | --- | --- |
| 未ログインユーザー | 利用可 | 利用不可 |
| 無料会員 | 利用可 | 利用不可 |
| プレミアム会員 | 利用可 | 利用可 |
| 管理者 | 利用可 | 利用可 |
| 有効な検証用資格を持つ一般ユーザー | 利用可 | 利用可 |

* 上表の判定対象は試験一覧、次の問題取得、指定問題取得、回答、回答履歴詳細及び間違えた問題の復習対象取得とする
* 本資料の有料機能のアクセス判定には、有効な検証用資格も含める。ただし、購入・支払済みという意味ではなく、付与理由を持つ最長7日の例外である。管理機能の対象は増やさない
* お気に入りの一覧取得・登録・解除は、上表の無料利用範囲とは別に、すべての模試番号でプレミアム会員又は管理者に限定する
* 未ログインユーザーが模擬試験6以降を要求した場合は `401 Unauthorized` を返す
* 無料会員が模擬試験6以降を要求した場合は `403 Forbidden` と `paid_membership_required` を返す
* 非公開問題は権限の有無にかかわらず一般向けAPIから取得できず、`404 Not Found` を返す

### 試験一覧

`GET /api/v1/exams`

公開中の問題がある試験ナンバーを、現在のユーザーの利用可否とともに返す。利用不可の試験でも問題本文、選択肢、正答及び解説は返さない。

一般画面の試験サイドバーは、`config/exam.json` から固定カタログを生成する。未ログイン・無料会員には `payments.free_exam_count` の5セット、プレミアム会員には `exam.set_count` の50セットを表示し、各セットは `exam.questions_per_exam` の20問とする。会員情報の初期未確定時は5セットを表示する。

ログイン時の会員ステータスは、共通の `GET /api/v1/me` の結果を共有し、`paid_content_access = false` なら5セット、`true` なら50セットへ切り替える。管理者・有効な検証用資格も既存の `paid_content_access` 判定に従う。未ログインの一覧表示や開閉のためにAPIを呼び出さず、サイドバー独自の会員ステータス再取得も追加しない。試験一覧API・問題一覧APIでカタログを取得しない。

この試験一覧APIは公開状態を動的に確認する用途のために維持するが、共通レイアウトからは呼び出さない。共通のCookie認証確認はサイドバーから独立して行い、実際の問題取得・回答時の認可は各APIで必ず再判定する。

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
* ログイン中の場合に限り、レスポンスへ `is_favorite` を追加してよい。プレミアム会員と管理者のみDBを照会し、無料会員は照会せず `false` とする
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

## プレミアム会員・決済API

### 販売設定取得

`GET /api/v1/payments/config`

公開して差し支えない販売状態と、特定商取引法に基づく表記へ掲載する販売者情報だけを返す。Stripeのキー、Webhook署名シークレット及びPrice IDは返さない。販売者情報はこのAPIを正本として公開画面へ表示し、バックエンドの販売開始判定と表示内容の不一致を防ぐ。

```json
{
  "data": {
    "enabled": false,
    "amount": 500,
    "currency": "jpy",
    "purchase_type": "one_time",
    "free_exam_max": 5,
    "seller": {
      "name": "販売事業者名",
      "representative": "運営責任者名",
      "address": "所在地",
      "phone": "電話番号",
      "email": "問い合わせ先",
      "contact_disclosure_mode": "public",
      "contact_disclosure_ready": false
    }
  }
}
```

`enabled` は販売開始フラグが有効で、Stripe、戻り先URL及び選択した開示方式に必要な販売事業者情報がすべて設定され、キーの実行モード・戻り先URLの形式が妥当な場合だけ `true` とする。本番はHTTPSオリジン・本番モードを必須とし、認証情報・パス・クエリ・フラグメントを戻り先へ含めない。これは実Stripeでの購入試験や販売者情報の最終承認が済んだことを意味しない。

* `contact_disclosure_mode` は `public`（既定）、`on_request`（請求時開示）、設定不正時の `unconfigured` のいずれかとする。不正な環境変数の実値は返さず、販売も無効にする
* `public` は所在地・電話番号を従来どおり必須とする。`on_request` はそれらの公開設定を必須にせず、古い環境変数に値があっても `address`・`phone` は必ず空文字列を返す。氏名・責任者・問い合わせ先は引き続き必須とする
* `contact_disclosure_ready` は `on_request` かつ、対応体制の確認設定が厳密な文字列 `true` の場合だけ `true`。未確認では販売を無効にする。確認済みでも `PAID_MEMBERSHIP_ENABLED=false` なら販売は無効のまま
* 開示体制の確認は、購入前の請求にも十分な時間的余裕をもって実情報を電子メール提供できる運用を意味する。フラグや文言だけで法令適合を保証するものではない。公開・販売の最終承認とは分ける

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
* [Stripe SDK 20の定義](https://github.com/stripe/stripe-ruby/blob/v20.0.0/lib/stripe/params/checkout/session_create_params.rb)に合わせ、ホスト型の `ui_mode = hosted_page` と `allowed_payment_method_types = ["card"]` を指定する。請求先住所は自動判定、電話番号収集・自動税計算・プロモーションコードは無効とし、既存Price・購入者照合情報・同意・冪等性キーを維持する。買い切りのため、subscription専用の `payment_method_collection` は送信しない
* Checkoutは日本語表示とし、Stripe Dashboardへ登録した利用規約への同意を必須にする。支払確定ボタン付近にも、500円の買い切り、自動更新なし及び提供開始後の利用者都合による返金条件を表示する
* 金額は500円、通貨は `jpy` とし、Stripe上のPriceの有効状態・一回払い・金額・通貨・`livemode` とサーバーの期待値が一致しない場合はSessionを作成しない
* ログインユーザーIDをStripeの `client_reference_id` または `metadata` に設定し、ローカルの決済記録と照合する
* Session作成後、Checkout Session IDを持つ `pending` の決済記録を保存してからURLを返す
* Stripe APIへの作成要求には要求ごとの冪等性キーを使用する。ユーザー単位のDBロックと未完了決済の再利用を併用し、同一ユーザーの再送で利用可能なSessionを重複作成しない
* プレミアム会員または管理者からの要求は `409 Conflict` と `membership_already_active` を返す
* 有効な未完了Sessionが存在する場合は、そのSessionの再利用または `409 Conflict` と `checkout_session_in_progress` のいずれかに統一し、二重決済を防ぐ
* `success_url` は `/premium/complete`、`cancel_url` は `/premium` を基準とし、許可済みフロントエンドURLからサーバー側で組み立てる

### Stripe Webhook

`POST /api/v1/webhooks/stripe`

Bearerトークンは使用しない。未加工のリクエスト本文、`Stripe-Signature` ヘッダー及び環境変数のWebhook署名シークレットをStripe公式ライブラリへ渡し、署名を検証する。署名不正またはJSON不正は `400 Bad Request` とし、状態を更新しない。

初期実装で処理するイベント:

| イベント | 処理 |
| --- | --- |
| `checkout.session.completed` | `payment_status = paid`、商品、金額、通貨、ユーザー及びCheckout Session IDを照合し、決済を `paid`、プレミアム会員資格を `active` にする |
| `checkout.session.expired` | 未完了の決済を `expired` にする |
| `refund.created`, `refund.updated` | Refundの状態を確認し、成立済みの返金額を反映する。全額返金が成立した場合は決済を `refunded`、資格を `revoked` にする |
| `refund.failed` | 失敗理由と通知日時を記録し、Stripeの現在のChargeを照合して成立済み返金額と決済状態を更新する。同じ購入の返金だけを理由に失効した資格は、全額返金・異議申立てが残っていない場合に限り元へ戻す。別購入や異議申立てによる失効資格は戻さない |
| `charge.dispute.created` | 決済を `disputed`、資格を `revoked` にして利用を停止する |
| `charge.dispute.closed` | 対応する決済へStripe上の終了結果と通知日時を記録する。資金回復後の資格再開は自動化せず、運営者がStripeの状態を確認して行う |

* Stripe Event IDを一意に保存し、処理済みイベントの再送には状態を変更せず `200 OK` を返す
* Event IDの保存、決済状態の更新及び資格の更新は同一DBトランザクションで確定する
* 処理に失敗した場合はDBをロールバックし、Stripeが再送できるように `5xx` を返す
* 返金又は異議申立てが対応する `checkout.session.completed` より先に届いた場合は、PaymentIntentのメタデータで本サービスの決済であることを確認し、イベントを処理済みにせず `5xx` を返して再送を待つ
* 異議申立てイベントのPaymentIntent IDが空の場合は、ChargeをStripeから取得してPaymentIntent IDを確認し、対応する決済を照合する
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

## 間違えた問題の復習API

### 復習対象取得

`GET /api/v1/review_questions/incorrect`

Better Authで認証したユーザー本人について、問題ごとの最新回答が不正解であり、現在も利用できる公開問題の位置を1問1件で返す。最新回答は `created_at DESC, id DESC` の順で一意に決定する。

* 未回答の問題は対象外とする
* 不正解の後に正解した問題は対象から外し、正解の後に不正解だった問題は対象へ戻す
* 同じ問題へ複数回不正解でも1問として返す
* `publication_status = published` で、現在のユーザーが利用できる問題だけを返す
* 無料会員には模擬試験1〜5だけを返し、模擬試験6以降が復習対象であること及びその件数を返さない
* プレミアム会員、管理者及び有効な検証用資格を持つユーザーは、利用可能な全公開問題を対象にできる
* ページ分割は行わず、`page` と `per_page` は受け付けない

レスポンス:

```json
{
  "data": [
    {
      "question_id": 42,
      "exam_number": 1,
      "question_number": 3
    },
    {
      "question_id": 88,
      "exam_number": 2,
      "question_number": 7
    }
  ],
  "meta": {
    "total_count": 2
  }
}
```

レスポンスへ選択肢、正答、選択した回答、正誤、解答解説及び根拠資料を含めない。`question_id` は問題取得APIで使用する内部識別子であり、問題演習画面のURLには `exam_number` と `question_number` を使用する。返却順は出題順を表さず、フロントエンドがURLの32ビット非負整数の `seed` と各問題の試験ナンバー・問番号から安定したランダム順を生成する。

対象がない場合も `200 OK` とし、`data: []`、`meta.total_count: 0` を返す。未ログイン又はセッション切れの場合は `401 Unauthorized` とする。

`HEAD /api/v1/review_questions/incorrect` も用意し、GETと同じ認証・利用権限の検査及びHTTPステータスを使用して、レスポンス本文は返さない。

## お気に入りAPI

すべての操作にログイン及び有効なプレミアム会員資格又は管理者権限を必要とする。未ログインは `401`、無料会員・資格失効ユーザーは `403` の `paid_membership_required` とする。無料会員の既存データは削除せず保持する。

### お気に入り一覧

`GET /api/v1/favorites`

利用資格を持つユーザー本人のお気に入りを新しい順に返す。各項目には問題ID、試験ナンバー、問番号、問題文の概要、大分類、小分類、登録日時を含める。互換性のため `locked = false` を返す。

`page` と `per_page` を受け付け、共通の `meta` を返す。既定は20件、最大100件とし、不正な値は `400 Bad Request` とする。非公開問題と他ユーザーの項目は一覧・総件数に含めない。同じ登録日時ではIDの降順で並べる。

### お気に入り登録

`PUT /api/v1/questions/{question_id}/favorite`

* 対象は公開中の問題に限る
* 模擬試験1〜5の問題も含め、有効なプレミアム会員資格または管理者権限を必要とする
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

## CORS・Origin検査

ブラウザの本番通信はNetlifyの同一オリジン `/api/*` を使用する。Fly.io側は明示したオリジンだけを許可する。

| 環境 | 許可例 |
| --- | --- |
| 開発 | `http://localhost:3000`、`http://127.0.0.1:3000` |
| 本番 | `https://johokyonin-lab.netlify.app` |

* `CORS_ORIGINS` は完全一致。ワイルドカード、パス、認証情報、末尾の `/` を含む値は拒否し、本番ではHTTPSを必須とする
* `/api/v1/*` と `/api/auth/*` で許可Originへ `Access-Control-Allow-Credentials: true` を返す。許可メソッドは `GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD`、ヘッダーは `Authorization, Content-Type` とする
* 許可Origin以外のプリフライトは403。変更系リクエストはOriginの欠落・許可外・`Sec-Fetch-Site: cross-site` を拒否する。本文があればJSON形式を必須とする
* Stripe WebhookはOrigin検査の例外とし、未加工本文とStripe署名で認証する。CORSだけをアクセス制限やCSRF対策とみなさない
* APIは `Cache-Control: no-store`、`X-Content-Type-Options: nosniff` を付ける。認証Cookieの値やDB接続情報をログへ残さない

## セキュリティ・実装上の注意

* パスワードハッシュの実装はBetter Authへ委ね、平文・セッションCookie・秘密値を保存ログやAPIへ出力しない
* ログは固定した障害区分・HTTP状態などに制限し、生の本文・ヘッダー・レスポンス・環境変数・利用者情報・DB例外を出力しない。旧Railsのフィルター設定を新Nodeコードの保証とみなさない
* 公開問題取得時は `question_choices.is_correct`、解答解説、根拠資料を返さない
* 回答判定は必ずサーバー側で行う
* 一般ユーザーは自分の回答履歴、間違えた問題の復習対象及びお気に入りだけ取得できる
* 模擬試験6以降の利用権限は、試験一覧、問題取得、回答、回答履歴、間違えた問題の復習対象及びお気に入りの各APIでサーバー側が確認する
* 管理APIはすべて管理者権限を確認する
* 問題の更新は `frontend/server/services/learning-writer.ts` の保存処理を使用する。本文・選択肢・正答・解説・出典・分類・問題番号の変更時は、その問題の古い回答履歴を同一トランザクション内で削除する。公開状態だけの変更では削除しない。通常の改稿で問題ID・選択肢ID・お気に入りを保持する
* 選択肢はア・イ・ウ・エ各1件・正答1件を保存前後で保証する。重複ID、他の問題のID、IDとラベルの不一致を拒否する
* 公開時は本文・解説・選択肢の実内容、出典のHTTPSリンク形式、空欄ラベルと全選択肢のセル数を検査する。draftでは内容が未完成でも保存できるが、選択肢の構造は維持する。不正な入力は `422` の `validation_error` とする
* 管理APIで `published` として作成・更新する際は、保存対象を含めて同じ試験ナンバーに問1〜20が各1件登録されていることも検査する。不足する場合は `422` の `validation_error` と不足問番号を返し、変更や履歴削除を行わない。この検査は登録件数の確認であり、20問を同時公開する操作ではない。個別の非公開化・削除は引き続き可能とする
* フロントエンドは既存のAPI通信を共通クライアントで観測し、フッターの接続状態を更新する。HTTP 4xxは通信自体の成功として扱い、ネットワークエラー及びHTTP 5xxは接続失敗として表示する。表示のためだけのhealth・試験一覧呼び出しやポーリングは行わない
* 試験ナンバー・問番号は通常の範囲・重複・公開時検査を満たせば変更できる。seed固有の変更制限や削除記録は使用しない。削除した問題はデプロイで再作成しない
* 管理画面のルートガードと管理APIの両方で権限を確認し、フロントエンドの画面制御だけに依存しない
* コンテンツブロックでは許可したキーと文字列だけを受け付け、任意のHTMLやスクリプトを保存・描画しない
* 会員登録、ログイン、回答及びCheckout Session作成APIには上記の共有レート制限を設ける
* APIの障害通知は初期状態で無効。個別承認後に有効化する場合も、Sentry公式SDKの独立クライアントで、固定の障害名・時刻・ランダムID・検証／本番の環境名・重大度・固定カテゴリタグだけを送信する。リクエスト、例外の本文、利用者情報、認証情報、DB・Stripeの識別子は送らない。設定と制限は `document/運用手順.md` を参照する
    * 通知対象から除く503は、Checkoutの販売停止又はWebhook未設定として明示した予定どおりの応答だけとする。レート制限の保存先障害など、同じコントローラーの想定外の503は一般API障害として扱う。販売開始を要求した状態での決済設定不足も通知対象とする。分類用の内部情報はAPIレスポンスにも外部通知にも含めない。本番反映結果はテンプレート移行記録で別途確認する
* アカウント削除と問題削除はトランザクションで実行する
* Stripeのシークレットキー、Webhook署名シークレット及びPrice IDは環境変数で管理し、ログやAPIレスポンスへ出力しない
* Webhookは未加工の本文で署名検証し、Stripe Event ID及びCheckout Session IDの一意制約とDBトランザクションで冪等に処理する

### DB正本の問題編集運用（2026年10月21日承認）

* 実行用seedと自動同期を廃止し、本番DBを正本として管理APIで編集する。`frontend/server/services/learning-writer.ts` とPrismaのトランザクションで保存する。旧同期表は旧DB側の履歴としてのみ保持し、新版アプリは使用しない
* 管理者認可、4択・正答1件、公開時検査、同一トランザクションでの回答履歴削除・ロールバックを維持する。既存エンドポイント・レスポンス及び一般APIへの正答非公開の契約は変更しない
* 問題アーカイブの書き出し・空DBへの取込みは運営者が明示的に実行するCLIのみとし、公開API・管理APIへ転送機能を追加しない。ユーザー情報を含む完全バックアップと区別する。手順は `document/運用手順.md` を参照する
* 旧問題カタログ、原典fixture、承認記録及び固定ハッシュはテスト専用に保持する。ローカル実装・検証の完了を、本番の最終内容照合又はデプロイ済みと同一視しない

### Stripe関連の環境変数

| 環境変数 | 用途 | 公開範囲 |
| --- | --- | --- |
| `STRIPE_SECRET_KEY` | Node.jsのStripe公式SDKから使用するシークレットキー | バックエンドのみ |
| `STRIPE_WEBHOOK_SECRET` | Stripe Webhookの署名検証 | バックエンドのみ |
| `STRIPE_PRICE_ID` | 500円の買い切り商品に対応するPrice ID | バックエンドのみ |
| `FRONTEND_URL` | Checkoutの成功・中止時の戻り先を組み立てる許可済みURL | バックエンドのみ |
| `PAID_MEMBERSHIP_ENABLED` | 販売開始フラグ。初期値は `false` | バックエンドのみ |
| `STRIPE_LIVEMODE` | Stripeイベントと実行環境のテスト／本番モード照合 | バックエンドのみ |
| `NUXT_PUBLIC_SELLER_NAME` | 特定商取引法に基づく表記の販売事業者名 | 公開 |
| `NUXT_PUBLIC_SELLER_REPRESENTATIVE` | 運営責任者 | 公開 |
| `NUXT_PUBLIC_SELLER_ADDRESS` | 直接公開方式の所在地。請求時開示方式では設定不要・APIへ返さない | `public` 方式のみ公開 |
| `NUXT_PUBLIC_SELLER_PHONE` | 直接公開方式の電話番号。請求時開示方式では設定不要・APIへ返さない | `public` 方式のみ公開 |
| `NUXT_PUBLIC_SELLER_EMAIL` | 問い合わせ先 | 公開 |
| `SELLER_CONTACT_DISCLOSURE_MODE` | `public`（既定）又は `on_request`。不正値では販売無効 | 方式名だけ公開 |
| `SELLER_CONTACT_DISCLOSURE_READY` | 購入前の開示請求へ対応できる体制の確認。厳密な `true` 以外は未確認 | 確認状態だけ公開 |

* テスト環境と本番環境のキー、Webhook署名シークレット及びPrice IDを混在させない
* 上記の値はリポジトリへ保存せず、ローカルの `.env` とデプロイ先のSecretで管理する
* `PAID_MEMBERSHIP_ENABLED` は、テスト決済、Webhook、利用規約、プライバシーポリシー及び特定商取引法に基づく表記を確認した後にだけ `true` へ変更する

## Stripe公式資料

* Checkout Session作成: https://docs.stripe.com/api/checkout/sessions/create
* Checkout Sessionの `payment_status`: https://docs.stripe.com/api/checkout/sessions/object
* Webhook署名検証と再送時の処理: https://docs.stripe.com/events/manage-webhook-endpoints
* 返金イベント: https://docs.stripe.com/refunds

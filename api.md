## API仕様書

### 実装されるAPI
- [Micropost閲覧API](#Micropost閲覧API)
- [フォローAPI](#フォローAPI)
- [ログインAPI](#ログインAPI)

### Micropost閲覧API
#### 概要
- クライアント側からリクエストがあったuser_idのmicropostsを返す

#### URI
- /api/v1/users/"user_id"/microposts

#### HTTPメソッド
- GET

#### 入力（リクエスト）
- user_id
  - micropostsを表示するユーザーのID

#### 出力（レスポンス）
- 出力データ詳細
  - 200
    - 正常にレスポンスできた時
  - 404
    - 存在しないuser_idを指定した時

- micropostsが正常に返された時
  - user_name (String)：ユーザー名
  - icon_url (String)：アイコンのgravatarURL
  - microposts
    - id (Integer)：マイクロポストのid
    - content (String)：文章
    - user_id (Integer)：ユーザーID
    - created_at (Time:ISO 8601形式の日時文字列)：生成時間
    - updated_at (Time:ISO 8601形式の日時文字列)：更新時間
    - picture
      - url (String)：添付画像URL
      
- エラー時
  - status (Integer)：ステータスコード
  - error (String)：エラーメッセージ
    - 存在しないuser_idを指定したとき
      - Couldn't find User with 'id'=〜

#### JSONの例
- 正常時
```
{
  "user_name": "Example User",
  "icon_url": "https://secure.gravatar.com/avatar/bebfcf57d6d8277d806a9ef3385c078d?s=80",
  "microposts": [
    {
      "id": 295,
      "content": "Cumque eum quam sed neque dignissimos ut quaerat harum.",
      "user_id": 1,
      "created_at": "2020-05-11T09:13:55.107Z",
      "updated_at": "2020-05-11T09:13:55.107Z",
      "picture": {
        "url": null
      }
    },
    {
      "id": 289,
      "content": "Eius minus praesentium sunt dolorum.",
      "user_id": 1,
      "created_at": "2020-05-11T09:13:55.050Z",
      "updated_at": "2020-05-11T09:13:55.050Z",
      "picture": {
        "url": null
      }
    }
  ]
}
```
- エラー時
```
{
  "status": 404,
  "error": "Couldn't find User with 'id'=10000"
}
```

### フォローAPI
#### 概要
- クライアント側でフォローボタンが押された際にフォローする

#### URI
- /api/v1/relationships

#### HTTPメソッド
- POST

#### 入力（リクエスト）
- user_id
  - フォローする側のユーザーID
  - 必要性：必須
- followed_id
  - フォローされる側のユーザーID
  - 必要性：必須
- token
  - ログインページから持ってきて保存してあった認証トークン
  - 必要性：必須


#### 出力（レスポンス）
- 出力データ詳細
  - ステータスコード
    - 200：正常にレスポンスできたとき
    - 401：認証失敗した時
    - 404：リクエストしたリソースが存在しない時
  - データ
    - is_logged
      - ログインしているかどうか
    - is_followed
      - フォローできたかどうか

- 正常時（ステータス：200）
  - フォロー成功時
    - is_followed：true
    - is_logged：true
  - 既にフォローしている時
    - is_followed：false
    - is_logged：true

- エラー時
  - tokenが一致せずログインに失敗した時
    - ステータス：401
    - is_followed：false
    - is_logged：false
  - user_idが存在しない時
    - ステータス：404
    - is_logged：false
    - is_followed：false
  - followed_idが存在しない
    - ステータス：404
    - is_logged = true
    - is_followed = false

### ログインAPI
#### 概要
- ユーザーがログインしているかを確認するAPI

#### URI
- /api/v1/users

#### HTTPメソッド
- POST

#### 入力（リクエスト）
- user_id
  - ログインしているユーザーID
  - 必要性：必須
- token
  - 認証トークン
  - 必要性：必須

#### 出力（レスポンス）
- 出力データ詳細
  - ステータスコード
    - 200：正常にレスポンスできたとき
    - 401：認証失敗した時
    - 404：リクエストしたリソースが存在しない時
  - is_logged
    - ログインしているかどうか

- 正常時
  - ログイン成功時
    - ステータス：200
    - is_logged：true

- エラー時
  - user_idが存在しない
      - ステータスコード：404
      - is_logged：false
  - user_idが存在するがtokenが不一致の時
    - ステータスコード：401
    - is_logged：false

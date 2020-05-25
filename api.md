## API仕様書

### 実装されるAPI
- Micropost閲覧API
- フォローAPI

### Micropost閲覧APIについて
#### 概要
クライアント側からリクエストがあったuser_idのmicropostsを返す。

#### URI
/api/v1/users/"user_id"/microposts

#### HTTPメソッド
GET

#### 入力（リクエスト）
per

#### 出力
- 200
  - 正常にレスポンスできた時
- 404
  - 存在しないuser_idを指定した時

#### データ
- 正常時
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

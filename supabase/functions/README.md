# Supabase Edge Functions

## 概要
このディレクトリには、株主優待マップアプリのバックエンドAPIとして機能するSupabase Edge Functionsが含まれています。

## 利用可能なエンドポイント

### 1. create-benefit
単一の優待券（株主優待）を登録するためのエンドポイント

#### エンドポイント
```
POST /functions/v1/create-benefit
```

#### リクエストヘッダー
```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
Content-Type: application/json
```

#### リクエストボディ
```json
{
  "company_id": 1,
  "benefit_type": "買い物券",
  "benefit_value": 5000,
  "validity_start_date": "2025-01-01",
  "validity_end_date": "2025-12-31",
  "is_active": true
}
```

#### 必須フィールド
- `company_id` (number): 企業のID（companiesテーブルのid）
- `benefit_type` (string): 優待種別（例: 買い物券、割引券、宿泊券など）

#### オプションフィールド
- `benefit_value` (number): 優待券面額（円）
- `validity_start_date` (string): 有効期間開始日（YYYY-MM-DD形式）
- `validity_end_date` (string): 有効期間終了日（YYYY-MM-DD形式）
- `is_active` (boolean): 有効/無効フラグ（デフォルト: true）

#### レスポンス例
**成功時 (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "company_id": 1,
    "benefit_type": "買い物券",
    "benefit_value": 5000,
    "validity_start_date": "2025-01-01",
    "validity_end_date": "2025-12-31",
    "is_active": true,
    "created_at": "2025-10-16T23:43:57.000Z",
    "updated_at": "2025-10-16T23:43:57.000Z"
  },
  "message": "優待券を登録しました"
}
```

**エラー時 (400 Bad Request):**
```json
{
  "error": "Missing required fields: company_id and benefit_type are required"
}
```

### 2. create-benefits-batch
複数の優待券を一括登録するためのエンドポイント

#### エンドポイント
```
POST /functions/v1/create-benefits-batch
```

#### リクエストヘッダー
```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
Content-Type: application/json
```

#### リクエストボディ
```json
{
  "benefits": [
    {
      "company_id": 1,
      "benefit_type": "買い物券",
      "benefit_value": 5000,
      "validity_start_date": "2025-01-01",
      "validity_end_date": "2025-12-31",
      "is_active": true
    },
    {
      "company_id": 2,
      "benefit_type": "割引券",
      "benefit_value": 3000,
      "validity_start_date": "2025-01-01",
      "validity_end_date": "2025-12-31",
      "is_active": true
    }
  ]
}
```

#### レスポンス例
**成功時 (201 Created):**
```json
{
  "success": true,
  "data": [...],
  "count": 2,
  "message": "2件の優待券を登録しました"
}
```

## デプロイ方法

### ローカル環境でのテスト
```bash
# Supabase CLIをインストール（未インストールの場合）
brew install supabase/tap/supabase

# Supabaseプロジェクトにリンク
supabase link --project-ref YOUR_PROJECT_REF

# ローカル環境で関数を起動
supabase functions serve create-benefit --env-file .env

# 別のターミナルでテスト
curl -X POST http://localhost:54321/functions/v1/create-benefit \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "company_id": 1,
    "benefit_type": "買い物券",
    "benefit_value": 5000
  }'
```

### 本番環境へのデプロイ
```bash
# 単一の関数をデプロイ
supabase functions deploy create-benefit

# すべての関数をデプロイ
supabase functions deploy

# バッチ登録関数をデプロイ
supabase functions deploy create-benefits-batch
```

## 使用例

### curlでの使用例

#### 単一登録
```bash
curl -X POST https://YOUR_PROJECT_REF.supabase.co/functions/v1/create-benefit \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "company_id": 1,
    "benefit_type": "買い物券",
    "benefit_value": 5000,
    "validity_start_date": "2025-01-01",
    "validity_end_date": "2025-12-31"
  }'
```

#### 一括登録
```bash
curl -X POST https://YOUR_PROJECT_REF.supabase.co/functions/v1/create-benefits-batch \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "benefits": [
      {
        "company_id": 1,
        "benefit_type": "買い物券",
        "benefit_value": 5000
      },
      {
        "company_id": 2,
        "benefit_type": "割引券",
        "benefit_value": 3000
      }
    ]
  }'
```

### JavaScriptでの使用例
```javascript
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 単一登録
const { data, error } = await supabase.functions.invoke('create-benefit', {
  body: {
    company_id: 1,
    benefit_type: '買い物券',
    benefit_value: 5000,
    validity_start_date: '2025-01-01',
    validity_end_date: '2025-12-31'
  }
});

// 一括登録
const { data: batchData, error: batchError } = await supabase.functions.invoke('create-benefits-batch', {
  body: {
    benefits: [
      { company_id: 1, benefit_type: '買い物券', benefit_value: 5000 },
      { company_id: 2, benefit_type: '割引券', benefit_value: 3000 }
    ]
  }
});
```

### Dartでの使用例
```dart
final supabase = Supabase.instance.client;

// 単一登録
final response = await supabase.functions.invoke(
  'create-benefit',
  body: {
    'company_id': 1,
    'benefit_type': '買い物券',
    'benefit_value': 5000,
    'validity_start_date': '2025-01-01',
    'validity_end_date': '2025-12-31',
  },
);

// 一括登録
final batchResponse = await supabase.functions.invoke(
  'create-benefits-batch',
  body: {
    'benefits': [
      {
        'company_id': 1,
        'benefit_type': '買い物券',
        'benefit_value': 5000,
      },
      {
        'company_id': 2,
        'benefit_type': '割引券',
        'benefit_value': 3000,
      },
    ],
  },
);
```

## エラーハンドリング

### 一般的なエラーコード
- `400 Bad Request`: リクエストパラメータが不正
- `401 Unauthorized`: 認証エラー
- `405 Method Not Allowed`: POSTメソッド以外でのリクエスト
- `500 Internal Server Error`: サーバー側のエラー

### トラブルシューティング

#### エラー: "Missing required fields"
必須フィールド（company_id, benefit_type）が含まれていることを確認してください。

#### エラー: "Database error"
- company_idが存在するcompaniesテーブルのUUIDであることを確認
- データベースの接続を確認
- テーブルのRow Level Security (RLS)ポリシーを確認

#### エラー: "Unauthorized"
- Authorization ヘッダーにSupabase ANON KEYが正しく設定されていることを確認
- `.env`ファイルの設定を確認

## セキュリティ

これらのエンドポイントはRow Level Security (RLS)ポリシーによって保護されています：
- 読み取り: すべてのユーザーが可能
- 挿入/更新: 認証済みユーザーのみ

認証が必要な場合は、以下のようにユーザートークンを使用してください：
```javascript
const { data: { session } } = await supabase.auth.getSession();

const response = await supabase.functions.invoke('create-benefit', {
  headers: {
    Authorization: `Bearer ${session.access_token}`
  },
  body: { ... }
});
```

## 参考資料
- [Supabase Edge Functions Documentation](https://supabase.com/docs/guides/functions)
- [Deno Deploy Documentation](https://deno.com/deploy/docs)

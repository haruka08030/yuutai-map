# Supabase セットアップガイド

## 概要
株主優待マップアプリのSupabase連携とデータベースセットアップの手順です。

## 前提条件
- Flutter SDK がインストールされていること
- Dart SDK がインストールされていること
- Supabaseアカウントを作成済みであること

## セットアップ手順

### 1. Supabaseプロジェクトの作成
1. [Supabase](https://supabase.com) にログイン
2. 新しいプロジェクトを作成
3. プロジェクトのURLとANON KEYを取得

### 2. 環境変数の設定
`.env` ファイルに以下の情報を設定してください：

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### 3. データベースマイグレーション
Supabaseのダッシュボードで以下のSQLファイルを実行してください：

1. `supabase/migrations/001_create_stores_table.sql`
2. `supabase/migrations/002_create_shareholder_benefits_tables.sql`

### 4. 依存関係のインストール
```bash
flutter pub get
```

### 5. データベースのシード（初期データ投入）

#### 方法1: 自動セットアップスクリプト
```bash
./scripts/setup_database.sh
```

#### 方法2: 手動実行
```bash

# Supabaseにデータを投入
dart scripts/seed_stores.dart
```

#### 方法3: Makefileを使用
```bash

# データをシード
make seed-stores

# 全体のセットアップ（依存関係インストール + シード）
make install && make seed-stores
```

## 利用可能なコマンド

### Makefileコマンド
- `make seed-stores` - Supabaseにstoreデータを投入
- `make install` - Flutter依存関係をインストール
- `make run` - アプリを実行
- `make build` - リリースビルドを作成
- `make clean` - ビルドファイルをクリーン
- `make help` - ヘルプを表示

### 個別スクリプト
- `dart scripts/seed_stores.dart` - データベースシード
- `./scripts/setup_database.sh` - 全自動セットアップ

## ファイル構成

```
yuutai-map/
├── .env                              # 環境変数設定
├── balnibani-hotel+cafe.csv         # 元データ（CSV）
├── stores_data.json                 # 変換後データ（JSON）
├── Makefile                         # ビルドコマンド
├── supabase/
│   ├── migrations/
│   │   ├── 001_create_stores_table.sql
│   │   └── 002_create_shareholder_benefits_tables.sql
│   └── seed.sql                     # SQLシードファイル（参考）
└── scripts/
    ├── seed_stores.dart            # データベースシードスクリプト
    └── setup_database.sh           # 自動セットアップスクリプト
```

## データベーススキーマ

### stores テーブル
- `id` - 主キー
- `name` - 店舗名
- `store_brand` - 店舗ブランド
- `address` - 住所
- `latitude` - 緯度
- `longitude` - 経度
- `phone` - 電話番号
- `business_hours` - 営業時間
- `store_tag` - 店舗タグ（宿泊、飲食など）
- `is_active` - 営業中フラグ
- `created_at` - 作成日時
- `updated_at` - 更新日時

### companies テーブル
- `id` - 主キー
- `company_code` - 証券コード
- `company_name` - 企業名
- `created_at` - 作成日時
- `updated_at` - 更新日時

### shareholder_benefits テーブル
- `id` - 主キー
- `company_id` - 企業ID（外部キー）
- `benefit_type` - 優待種別
- `benefit_value` - 優待券面額
- `validity_start_date` - 有効期間開始
- `validity_end_date` - 有効期間終了
- `is_active` - 有効フラグ
- `created_at` - 作成日時
- `updated_at` - 更新日時

### benefit_store_mappings テーブル
- `id` - 主キー
- `benefit_id` - 優待ID（外部キー）
- `store_id` - 店舗ID（外部キー）
- `usage_conditions` - 利用条件
- `discount_rate` - 割引率
- `created_at` - 作成日時

## トラブルシューティング

### エラー: .env file not found
`.env` ファイルが存在しない場合は、プロジェクトルートに作成してSupabaseの設定を記入してください。

### エラー: stores_data.json not found
`dart scripts/csv_to_json.dart` を実行してCSVファイルをJSONに変換してください。

### エラー: Supabase connection failed
- `.env` ファイルのURLとキーが正しいか確認
- Supabaseプロジェクトが起動しているか確認
- ネットワーク接続を確認

### データが重複する場合
`scripts/seed_stores.dart` では既存データを削除してから新しいデータを投入します。重複を避けたい場合は、スクリプトを修正してください。

## 次のステップ

1. アプリでSupabaseに接続するためのサービスクラスを実装
2. 株主優待と店舗の関連データを追加
3. 企業データの投入
4. 地図表示機能の実装

## 参考資料

- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
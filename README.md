# 優待まっぷ (Yuutai Map)

株主優待情報を登録し、地図上で優待店舗を確認できる Flutter アプリです。

[![CI](https://github.com/haruka08030/yuutai-map/actions/workflows/ci.yml/badge.svg)](https://github.com/haruka08030/yuutai-map/actions/workflows/ci.yml)

## 主な機能

- **優待管理**: 株主優待の登録・編集・削除（TODO風の一覧管理）
- **地図表示**: Google マップで優待店舗をピン表示
- **現在地取得**: 近隣で利用可能な優待を可視化
- **期限通知**: 優待期限の1日/3日/7日/30日前/ユーザーのカスタムに通知
- **検索・フィルタ**: 銘柄名、優待内容、メモで検索可能
- **オフライン対応**: ローカルキャッシュで最後のデータを表示
- **認証**: Supabase Auth（Email、Google、Apple）でマルチデバイス同期

## 技術スタック

- **Framework**: Flutter (Stable 3.22.0+)
- **State Management**: Riverpod
- **Database**:
  - Remote: Supabase (PostgreSQL)
  - Local: Drift (SQLite)
- **地図**: Google Maps Platform
- **通知**: flutter_local_notifications
- **認証**: Supabase Auth

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/haruka08030/yuutai-map.git
cd yuutai-map
```

### 2. 環境変数の設定

```bash
# .envファイルを作成
cp .env.example .env

# Android用のlocal.propertiesを作成
cp android/local.properties.example android/local.properties
```

`.env` と `android/local.properties` を編集して、以下のAPIキーを設定してください：

- **Google Maps API Key**: [Google Cloud Console](https://console.cloud.google.com/) で Maps SDK を有効化して取得
- **Supabase URL/Keys**: [Supabase Dashboard](https://app.supabase.com/) でプロジェクト作成後に取得

### 3. 依存関係のインストール

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Supabase データベースセットアップ

Supabase ダッシュボードの SQL Editor で以下を実行してください：

```sql
-- Users Yuutai テーブル
CREATE TABLE users_yuutais (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  benefit_text TEXT,
  notes TEXT,
  expire_on TIMESTAMP WITH TIME ZONE,
  is_used BOOLEAN DEFAULT FALSE,
  brand_id TEXT,
  company_id TEXT,
  notify_before_days INTEGER,
  notify_at_hour INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Stores テーブル（優待店舗）
CREATE TABLE stores (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address TEXT,
  brand_id TEXT,
  company_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security (RLS) を有効化
ALTER TABLE users_yuutais ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- ポリシー設定（自分のデータのみアクセス可能）
CREATE POLICY "Users can view their own yuutais"
  ON users_yuutais FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own yuutais"
  ON users_yuutais FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own yuutais"
  ON users_yuutais FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own yuutais"
  ON users_yuutais FOR DELETE
  USING (auth.uid() = user_id);

-- Stores は全員が閲覧可能
CREATE POLICY "Anyone can view stores"
  ON stores FOR SELECT
  USING (true);
```

### 5. アプリの起動

**Android の場合**:
```bash
flutter run
```

**iOS の場合**:
```bash
flutter run --dart-define=Maps_API_KEY=your_api_key_here
```

## テスト

```bash
# すべてのテストを実行
flutter test

# カバレッジ付き
flutter test --coverage
```

## アーキテクチャ

```
lib/
├── core/               # コア機能（通知、ユーティリティなど）
│   ├── notifications/
│   └── utils/
├── data/              # データ層（Repository実装、DB）
│   ├── local/        # ローカルDB (Drift)
│   ├── repositories/
│   └── supabase/
├── domain/            # ドメイン層（エンティティ、Repository インターフェース）
│   ├── entities/
│   └── repositories/
├── features/          # 機能ごとのモジュール
│   ├── auth/         # 認証
│   ├── benefits/     # 優待管理
│   ├── map/          # 地図表示
│   └── settings/     # 設定
├── app/              # アプリ全体の設定
│   ├── routing/
│   └── theme/
└── main.dart
```

**設計パターン**:
- Repository Pattern: データアクセスの抽象化
- Facade Pattern: ローカル/リモートデータソースの切り替え
- Observer Pattern: Riverpod による状態管理

## CI/CD

GitHub Actions で自動テスト・ビルドを実行しています。ワークフローファイル: [.github/workflows/ci.yml](.github/workflows/ci.yml)

**GitHub Secrets の設定が必要**:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `GOOGLE_MAPS_API_KEY`

## トラブルシューティング

### ビルドエラー

```bash
# クリーンビルド
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Google Maps が表示されない

- `.env` と `android/local.properties` にAPIキーが正しく設定されているか確認
- Google Cloud Console で Maps SDK for Android/iOS が有効化されているか確認
- iOS の場合、`--dart-define=Maps_API_KEY=...` を指定して起動

### Supabase 接続エラー

- `.env` の `SUPABASE_URL` と `SUPABASE_ANON_KEY` が正しいか確認
- Supabase ダッシュボードでテーブルとRLSポリシーが作成されているか確認

## ライセンス

MIT License

## コントリビューション

プルリクエストを歓迎します！

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 作成者

- GitHub: [@haruka08030](https://github.com/haruka08030)

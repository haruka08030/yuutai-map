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

## 環境変数

このプロジェクトでは、APIキーや機密情報を安全に管理するために環境変数を使用しています。

### セットアップ方法

#### 1. .env ファイルの作成

プロジェクトルートに `.env` ファイルを作成します：

```bash
cp .env.example .env
```

`.env` ファイルを編集して、以下の環境変数を設定してください：

```env
MAPS_API_KEY=your_google_maps_api_key_here
SUPABASE_URL=your_supabase_project_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key_here
```

#### 2. Android 用の local.properties の作成

Android プロジェクトのルートに `android/local.properties` ファイルを作成します：

```bash
cp android/local.properties.example android/local.properties
```

`android/local.properties` ファイルを編集して、以下を設定してください：

```properties
sdk.dir=/path/to/your/Android/sdk
flutter.sdk=/path/to/your/flutter
MAPS_API_KEY=your_google_maps_api_key_here
```

**注意**: これらのファイルは `.gitignore` に含まれており、Git にコミットされません。

### 環境変数の取得方法

#### Supabase
1. [Supabase](https://supabase.com/) でプロジェクトを作成
2. Settings → API から `URL` と `anon public` キーを取得
3. SQL Editor で以下のテーブルを作成：

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

#### Google Maps API
1. [Google Cloud Console](https://console.cloud.google.com/) でプロジェクトを作成
2. APIs & Services → Enable APIs and Services
3. 以下の API を有効化：
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API (オプション)
4. Credentials → Create Credentials → API Key
5. API キーの制限を設定（アプリケーション制限を推奨）
6. 取得したAPIキーを上記の `.env` および `android/local.properties` に設定

**Android の場合**:
- `android/local.properties` に `MAPS_API_KEY` を追加（上記参照）
- `android/app/build.gradle.kts` が自動的に `local.properties` から読み込みます

**iOS の場合**:
- iOS では `$(Maps_API_KEY)` プレースホルダーが使用されます
- 実行時に以下のコマンドでAPIキーを渡します：
  ```bash
  flutter run --dart-define=Maps_API_KEY=your_api_key_here
  ```

## セットアップ手順

### 1. リポジトリのクローン

```bash
git clone https://github.com/haruka08030/yuutai-map.git
cd yuutai-map
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. コード生成

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. 環境変数の設定

上記の「環境変数」セクションに従って、`.env` および `android/local.properties` ファイルを作成してください。

### 5. アプリの起動

**Android の場合**:
```bash
flutter run
```

**iOS の場合**:
```bash
flutter run --dart-define=Maps_API_KEY=your_google_maps_api_key_here
```

**または、全ての環境変数を明示的に指定**:
```bash
flutter run \
  --dart-define=SUPABASE_URL=your_url \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=Maps_API_KEY=your_maps_key
```

## テスト

### 単体テスト・ウィジェットテストの実行

```bash
# すべてのテストを実行
flutter test

# カバレッジ付きでテストを実行
flutter test --coverage

# 特定のテストファイルを実行
flutter test test/domain/entities/users_yuutai_test.dart
```

### カバレッジレポートの生成

```bash
# HTML形式でカバレッジレポートを生成
genhtml coverage/lcov.info -o coverage/html

# ブラウザで開く (macOS)
open coverage/html/index.html

# ブラウザで開く (Linux)
xdg-open coverage/html/index.html
```

### 統合テストの実行

```bash
# 統合テストを実行
flutter test integration_test

# または特定のデバイスで実行
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
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

### レイヤー構成

- **Presentation Layer**: UI（Widgets）と ViewModel（Riverpod Providers）
- **Domain Layer**: ビジネスロジックとエンティティ
- **Data Layer**: データソース（Supabase、Drift）と Repository 実装

### 設計パターン

- **Repository Pattern**: データアクセスの抽象化
- **Facade Pattern**: ローカル/リモートデータソースの切り替え
- **Observer Pattern**: Riverpod による状態管理

## CI/CD

GitHub Actions を使用した自動テスト・ビルド：

- **テスト**: プルリクエストごとに自動実行
- **ビルド**: main/development ブランチへのマージ時に APK/IPA を生成
- **カバレッジ**: Codecov へ自動アップロード

ワークフローファイル: `.github/workflows/ci.yml`

## トラブルシューティング

### ビルドエラー

```bash
# クリーンビルド
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Google Maps が表示されない

- API キーが正しく設定されているか確認
- Google Cloud Console で Maps SDK が有効化されているか確認
- API キーの制限設定を確認

### Supabase 接続エラー

- `.env` ファイルの `SUPABASE_URL` と `SUPABASE_ANON_KEY` が正しいか確認
- Supabase プロジェクトが起動しているか確認
- RLS (Row Level Security) ポリシーが正しく設定されているか確認

### 通知が届かない

- iOS: Settings → Notifications でアプリの通知許可を確認
- Android: アプリの通知権限を確認
- バックグラウンド制限が有効になっていないか確認

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

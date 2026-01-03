# 優待マップ (Yuutai Map)
株主優待情報を登録し、地図上で優待店舗を確認できる Flutter アプリです。

### 目的
株主優待の管理をシンプルにし、機会損失（使い忘れ、期限切れ）を防止する。
地図上で「今使える場所」を可視化し、ユーザーの意思決定コストを低減する。

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

Supabase ダッシュボードの SQL Editor で `supabase/migrations/` 内のファイルを順番に実行してください：

1. `001_create_companies.sql` - 企業マスタテーブル
2. `002_create_stores.sql` - 店舗テーブル
3. `003_create_users_yuutai.sql` - 優待管理テーブル
4. `004_add_folders.sql` - フォルダ機能

または、Supabase CLI を使用している場合：
```bash
supabase db push
```

詳細は `supabase/migrations/README.md` を参照してください。

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
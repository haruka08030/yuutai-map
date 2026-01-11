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
- **State Management**: Hooks Riverpod, Riverpod Generator
- **Navigation**: GoRouter
- **Database**:
  - Remote: Supabase (PostgreSQL)
  - Local: Drift (SQLite) - (Phase 2)
- **地図**: Google Maps Platform
- **通知**: flutter_local_notifications, FCM
- **認証**: Supabase Auth

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/haruka08030/yuutai-map.git
cd yuutai-map
```

### 2. 環境変数の設定

`local.properties.example` を参考に `android/local.properties` を作成し、各種APIキーを設定してください。

- **Google Maps API Key**:
  [Google Cloud Console](https://console.cloud.google.com/) で Maps SDK を有効化して取得
- **Supabase URL/Keys**: [Supabase Dashboard](https://app.supabase.com/) でプロジェクト作成後に取得

### 3. 依存関係のインストールとコード生成

```bash
# Flutterパッケージをインストール
flutter pub get

# iOSの場合、CocoaPodsをインストール
make pod_install

# build_runnerでコードを生成
make build_runner
```

### 4. Supabase データベースセットアップ

Supabase ダッシュボードの SQL Editor で `supabase/migrations/` 内のファイルを順番に実行してください。
詳細は `supabase/migrations/README.md` を参照してください。

もしくは、Supabase CLI を使用している場合：

```bash
supabase db push
```

### 5. アプリの起動

```bash
# Android/iOSでアプリを起動
flutter run
```

## 詳細仕様

機能仕様、DBスキーマ、コーディング規約などの詳細なドキュメントは `GEMINI.md` を参照してください。

## アーキテクチャ

`Feature-First` アプローチを採用しています。
各機能（feature）は `data`, `domain`, `presentation` のレイヤーに関するコードを内包します。

```
lib/
├── app/              # アプリ全体の設定（ルーティング、テーマ）
│   ├── routing/
│   └── theme/
├── core/             # 複数機能で共有されるコア機能
│   ├── exceptions/
│   ├── notifications/
│   ├── supabase/
│   └── utils/
├── features/         # 機能ごとのモジュール
│   ├── auth/         # 認証
│   │   ├── data/
│   │   ├── presentation/
│   │   └── provider/
│   ├── benefits/     # 優待管理
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── map/          # 地図表示
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## テスト

```bash
# すべてのテストを実行
flutter test

# カバレッジ付き
flutter test --coverage
```

## トラブルシューティング

### "Generated.xcconfig must exist" or "Pod install failed"

iOSビルド時に上記のエラーが発生した場合、`ios/` ディレクトリの `Podfile.lock` や `Pods/` が古くなっている可能性があります。
クリーンインストールを試してください。

```bash
make pod_clean
```

### "Conflicting outputs" ビルドエラー

`build_runner` の実行時にエラーが発生する場合、生成ファイルが競合している可能性があります。
一度クリーンしてから再実行してください。

```bash
make build_runner
```

### Google Maps が表示されない

- `android/local.properties` にAPIキーが正しく設定されているか確認
- Google Cloud Console で Maps SDK for Android/iOS が有効化されているか確認
- iOS の場合、ビルド時に `GoogleMap-Info.plist` が正しく読み込まれているか確認

### Supabase 接続エラー

- Supabase URL と Anon Key が環境変数経由で正しく設定されているか確認
- Supabase ダッシュボードでテーブルとRLSポリシーが作成されているか確認

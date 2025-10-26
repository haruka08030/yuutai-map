# アプリの実行方法

## 環境変数の設定

### 1. .envファイルの作成

```bash
cp .env.example .env
```

`.env` ファイルに実際のAPIキーを設定してください。

### 2. Android用 local.propertiesの作成

`android/local.properties` ファイルを作成し、以下の内容を記載：

```properties
sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
flutter.sdk=/Applications/flutter
MAPS_API_KEY=your_google_maps_api_key_here
```

**注意**: このファイルは `.gitignore` に含まれており、Gitにコミットされません。

### 3. iOS用の設定

iOSでは`Info.plist`に環境変数が設定されています。
ビルド時に `--dart-define=MAPS_API_KEY=your_key` で指定してください。

## 実行コマンド

### 開発環境で実行

#### Android
```bash
# local.propertiesから自動的にAPIキーを読み込みます
flutter run
```

#### iOS
```bash
# --dart-defineでAPIキーを指定
flutter run --dart-define=MAPS_API_KEY=$(grep MAPS_API_KEY .env | cut -d '=' -f2 | tr -d '"')
```

### リリースビルド

#### Android
```bash
flutter build apk --release
# local.propertiesから自動的にAPIキーを読み込みます
```

#### iOS
```bash
flutter build ios --release \
  --dart-define=MAPS_API_KEY=$(grep MAPS_API_KEY .env | cut -d '=' -f2 | tr -d '"')
```

## トラブルシューティング

### Google Mapが表示されない場合

1. **local.propertiesの確認**（Android）
   ```bash
   cat android/local.properties
   ```
   MAPS_API_KEYが正しく設定されているか確認

2. **クリーンビルド**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **APIキーの権限確認**
   - Google Cloud ConsoleでMaps SDK for Android/iOSが有効化されているか
   - APIキーの制限設定を確認

4. **位置情報の権限**
   - アプリ初回起動時に位置情報の許可が求められます
   - 拒否した場合は、デバイスの設定から許可してください

### 環境変数が読み込まれない場合

- Android: `android/local.properties`が存在し、正しいフォーマットであることを確認
- iOS: `--dart-define=MAPS_API_KEY=...`を指定してビルド

## セキュリティ注意事項

- **絶対にコミットしないファイル**:
  - `.env`
  - `android/local.properties`

- これらのファイルには機密情報（APIキー）が含まれるため、`.gitignore`に追加されています
- チームメンバーには `.env.example` を共有し、各自でAPIキーを設定してもらってください

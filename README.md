# Shareholder Benefit Map (yuutai-map)

株主優待情報を登録し、地図上で優待店舗を確認できる Flutter アプリです。

## 主な機能
- 株主優待の登録・編集
- Google マップを用いた優待スポットの表示
- 現在地の取得による近隣検索

## セットアップ
1. Flutter 3.8.1 以降をインストールします。
2. このリポジトリをクローンし、ディレクトリに移動します。
3. `.env` に Firebase や Google Maps の API キーを設定します。
4. 依存関係を取得します。
   ```bash
   flutter pub get
   ```
5. アプリを起動します。
   ```bash
   flutter run

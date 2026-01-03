# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing on code quality, consistency, and maintainability.

---

## Next Up

### 1. テーマシステムの整理
-   **Task:** テーマシステムを整理する
-   **Reason:** コンポーネントの見た目を一貫させる
-   **Sub-tasks:**
    -   セカンダリ・ターシャリカラーを定義する

### 2. MapPageのリファクタリング
-   **Task:** MapPageのロジックをProviderに分離する
-   **Reason:** UIコンポーネントからビジネスロジック（位置情報取得、データフェッチ、マーカー作成）を切り離し、コードの可読性、保守性、テスト容易性を向上させるため
-   **Sub-tasks:**
    -   MapStateNotifier (または MapController) プロバイダーを作成する
    -   MapPage 内にある _fetchStores, _determinePosition 等のロジックをプロバイダーへ移動する
    -   UI側を ref.watch で状態を購読する形に修正する

### 4. 通知サービスのDI（依存性注入）化
-   **Task:** NotificationService のシングルトン利用を廃止しProvider経由にする
-   **Reason:** グローバルなシングルトンへの依存をなくし、ユニットテストやモックへの差し替えを容易にするため
-   **Sub-tasks:**
    -   NotificationService 内の static instance を削除または非推奨にする
    -   usersYuutaiRepository や main.dart などで直接インスタンスを参照している箇所を、Riverpodの Provider 経由に変更する

### 5. マップ描画のパフォーマンス改善
-   **Task:** マップマーカーのクラスタリングを導入する
-   **Reason:** 店舗数が増加した際にマップの描画負荷が高まり、動作が重くなるのを防ぐため
-   **Sub-tasks:**
    -   Maps_cluster_manager などのパッケージ導入を検討する
    -   または、表示領域（Viewport）内のデータのみをフェッチするロジックを実装する

### 6. OCR機能の導入
-   **Task:** カメラで優待券を読み取り、企業名と期限を自動入力する
-   **Reason:** ユーザーの入力負荷を大幅に下げ、アプリへの登録率を向上させるため
-   **Sub-tasks:**
    -   `google_mlkit_text_recognition` および `image_picker` パッケージを導入する
    -   `UsersYuutaiEditPage` にカメラ起動ボタンを追加する
    -   画像からテキストを抽出し、正規表現で日付と企業名を推測するロジックを実装する

### 7. 論理削除とUndo機能の実装
-   **Task:** データの削除を論理削除に変更し、削除取り消しを可能にする
-   **Reason:** 誤操作によるデータ消失を防ぎ、ユーザーに安心感を与えるため
-   **Sub-tasks:**
    -   `users_yuutai` テーブルに `deleted_at` (timestamp, nullable) カラムを追加する
    -   Repositoryの `softDelete` メソッドを `delete()` ではなく `update({ 'deleted_at': DateTime.now() })` に修正する
    -   データ一覧取得時のクエリに `.is_('deleted_at', null)` フィルタを追加する
    -   削除完了時の `SnackBar` に `SnackBarAction(label: '元に戻す', ...)` を追加し、復元ロジックを実装する

---

## ✅ Completed


---

## 🔍 Self-Discovery Protocol (When Queue is Empty)
*If no tasks are listed above, perform these audits in order and generate new tasks based on findings.*

### 1. Code Quality Audit
-   **Linter Check:** Run `flutter analyze`. If errors/warnings exist, create a task to fix them.
-   **Hardcoded Strings:** Search for user-facing strings not in a localization file/const class. Create a task to extract them.
-   **Long Methods:** Identify build methods over 50 lines. Create a task to "Extract Widget".
-   **Magic Numbers:** Identify raw numbers in code (e.g., styling constants). Create a task to move them to `AppTheme` or constants.

### 2. Architecture & Consistency
-   **Logic Separation:** Ensure no business logic exists directly in UI Widgets (Move to Controllers/Providers).
-   **Supabase Sync:** Check `GEMINI.md` schema definition against the actual Supabase table definitions in code. If different, create a task to update documentation.

### 3. Cleanup
-   **TODO Comments:** Search for `// TODO` in the codebase. Convert the oldest/most critical one into a task.
-   **Unused Imports:** Run cleanup command or manually check for unused files.
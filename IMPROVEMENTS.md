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

### 3. データ削除の一貫性確保
-   **Task:** リポジトリの削除メソッドの命名を統一する
-   **Reason:** softDelete という名前でありながら物理削除（完全削除）を行っている現状の矛盾を解消し、意図しないデータ消失や混乱を防ぐため
-   **Sub-tasks:**
    -   物理削除で統一する場合は、メソッド名を delete に変更する

### 4. テーマシステムの改善（ハードコード色の排除）
-   **Task:** ハードコードされた色定義を AppTheme に集約する
-   **Reason:** ダークモード対応の準備を整えるとともに、アプリ全体でデザインの一貫性を保ちやすくするため
-   **Sub-tasks:**
    -   AppTheme にカスタムカラー定義（ThemeExtensionなど）を追加する
    -   CompanySearchBar や UsersYuutaiListTile 内の直書きされた色コードを Theme.of(context) 経由の参照に置き換える

### 5. 通知サービスのDI（依存性注入）化
-   **Task:** NotificationService のシングルトン利用を廃止しProvider経由にする
-   **Reason:** グローバルなシングルトンへの依存をなくし、ユニットテストやモックへの差し替えを容易にするため
-   **Sub-tasks:**
    -   NotificationService 内の static instance を削除または非推奨にする
    -   usersYuutaiRepository や main.dart などで直接インスタンスを参照している箇所を、Riverpodの Provider 経由に変更する

### 6. UI/UXの改善
-   **Task:** 検索バーとリスト表示のUXを改善する
-   **Reason:** ユーザーの操作性を向上させ、アプリの挙動をよりスムーズに見せるため
-   **Sub-tasks:**
    -   検索バー (CompanySearchBar) にテキスト消去用のクリアボタン（×）を追加する
    -   優待リスト (UsersYuutaiPage) 更新時に一瞬ローディングが表示される「ちらつき」を、skipLoadingOnReload 等を活用して防止する

### 7. マップ描画のパフォーマンス改善
-   **Task:** マップマーカーのクラスタリングを導入する
-   **Reason:** 店舗数が増加した際にマップの描画負荷が高まり、動作が重くなるのを防ぐため
-   **Sub-tasks:**
    -   Maps_cluster_manager などのパッケージ導入を検討する
    -   または、表示領域（Viewport）内のデータのみをフェッチするロジックを実装する

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
# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing
on code quality, consistency, and maintainability.

---

## Next Up

### 1. テーマシステムの整理

- **Task:** テーマシステムを整理する
- **Reason:** コンポーネントの見た目を一貫させる
- **Sub-tasks:**
  - セカンダリ・ターシャリカラーを定義する

### 8. Drawerの中のUIを整える

### 9.フィルターのドロップダウンをモダンに

### 10.フィルターボタンを下に

【優先度: 高】 リリースに向けた必須タスク

1. AndroidアプリIDの設定: アプリをGoogle Playストアで公開するために必須の
   applicationId が仮のままです。これを正式なものに設定する必要があります。
   - 関連ファイル: android/app/build.gradle.kts

2. テストフレームワークの導入:
   プロジェクトに自動テスト（test/ディレクトリ）が存在しません。品質を保証し、将来の変更を安全に行うために
   、テストの導入を強く推奨します。

【優先度: 中】 機能の不備とプレースホルダー

3. Android ストレージ・ランタイム権限:
   - ストレージ権限は Android 10+ 対応済み（scoped storage; API 33+ は
     READ_MEDIA_IMAGES、API 29–32 は READ_EXTERNAL_STORAGE
     maxSdkVersion=32）。WRITE_EXTERNAL_STORAGE は未使用。
   - 危険な権限（位置・カメラ・ストレージ）は Android 6.0+
     でランタイムにリクエストすること。位置は map_controller
     でリクエスト済み。カメラ・ストレージを使う機能（例: ML Kit
     OCR）を追加する場合は、その利用直前に permission_handler
     またはプラグインの組み込みリクエストで権限を取得し、拒否時は機能を無効化すること。
   - 関連ファイル: android/app/src/main/AndroidManifest.xml,
     lib/features/map/presentation/controllers/map_controller.dart

4. プライバシーポリシーURLの更新:
   設定画面にあるプライバシーポリシーのリンク先がダミー（#）になっています。
   - 関連ファイル: lib/features/settings/presentation/settings_page.dart

【優先度: 低】 コード品質とメンテナンス

6. Linterルールの見直し:
   コード品質ルールの一つ（library_private_types_in_public_api）が無効化されています。コードの保守性を向上
   させるために、このルールを有効化し、関連する警告を修正することを推奨します。
   - 関連ファイル: analysis_options.yaml

---

## 🔍 Self-Discovery Protocol (When Queue is Empty)

_If no tasks are listed above, perform these audits in order and generate new
tasks based on findings._

### 1. Code Quality Audit

- **Linter Check:** Run `flutter analyze`. If errors/warnings exist, create a
  task to fix them.
- **Hardcoded Strings:** Search for user-facing strings not in a localization
  file/const class. Create a task to extract them.
- **Long Methods:** Identify build methods over 50 lines. Create a task to
  "Extract Widget".
- **Magic Numbers:** Identify raw numbers in code (e.g., styling constants).
  Create a task to move them to `AppTheme` or constants.

### 2. Architecture & Consistency

- **Logic Separation:** Ensure no business logic exists directly in UI Widgets
  (Move to Controllers/Providers).
- **Supabase Sync:** Check `GEMINI.md` schema definition against the actual
  Supabase table definitions in code. If different, create a task to update
  documentation.

### 3. Cleanup

- **TODO Comments:** Search for `// TODO` in the codebase. Convert into a task.
- **Unused Imports:** Run cleanup command or manually check for unused files.

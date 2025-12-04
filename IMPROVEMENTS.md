# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing on code quality, consistency, and maintainability.

---

## Next Up

### 1. ローディング状態の統一
-   **Task:** ローディング状態を統一する
-   **Reason:** コンポーネントの見た目を一貫させる
-   **Sub-tasks:**
    -   一貫性のないローディングUIを統一する
    -   スケルトンローディングを追加する
    -   ボタンのローディング状態を追加する

### 2. テーマシステムの整理
-   **Task:** テーマシステムを整理する
-   **Reason:** コンポーネントの見た目を一貫させる
-   **Sub-tasks:**
    -   ハードコードされた色をまとめる
    -   セカンダリ・ターシャリカラーを定義する
    -   ダークモードを対応する

### 3. フォームUX改善
-   **Task:** フォームUXを改善する
-   **Reason:** ユーザーエクスペリエンスを向上させる
-   **Sub-tasks:**
    -   パスワード表示切替を追加する
    -   リアルタイムバリデーションを実装する
    -   必須フィールドのマーキングを追加する

---

## ✅ Completed

### 1. フォームバリデーション改善
-   **Task:** フォームバリデーションを改善する
-   **Reason:** ユーザーエクスペリエンスを向上させる
-   **Sub-tasks:**
    -   リアルタイムバリデーションを実装する
    -   パスワード強度インジケーターを追加する
    -   メールのバリデーションを厳格にする

### 2. レスポンシブデザイン
-   **Task:** レスポンシブデザインを改善する
-   **Reason:** ユーザーエクスペリエンスを向上させる
-   **Sub-tasks:**
    -   タブレット・ランドスケープ対応を追加する
    -   固定高さの使用を避ける
    -   大画面での最大幅制約を追加する

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
# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing on code quality, consistency, and maintainability.

---

## Next Up

### 1. テーマシステムの整理
-   **Task:** テーマシステムを整理する
-   **Reason:** コンポーネントの見た目を一貫させる
-   **Sub-tasks:**
    -   セカンダリ・ターシャリカラーを定義する

### 8. Drawerの中のUIを整える

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
-   **TODO Comments:** Search for `// TODO` in the codebase. Convert into a task.
-   **Unused Imports:** Run cleanup command or manually check for unused files.
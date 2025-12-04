# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing on code quality, consistency, and maintainability.

## 1. Documentation and Schema Alignment

-   **Task:** Update `GEMINI.md` to reflect the current database schema.
-   **Reason:** The `notes` column was recently added to the `public.users_yuutai` table, but the documentation has not been updated. Keeping documentation in sync with the implementation is crucial.

## 2. Refactor Status Management

-   **Task:** Refactor the `status` field in `users_yuutai` from a `String` to a Dart `enum`.
-   **Reason:** Using a `String` for status ('active', 'used', 'expired') is error-prone. An `enum` provides type safety, improves readability, and prevents invalid status values.
-   **Sub-tasks:**
    -   Create a `BenefitStatus` enum in Dart.
    -   Update the `UsersYuutai` entity to use this enum.
    -   Update the repository and UI code to handle the new enum type.

## 3. Code Cleanup (Future Consideration)

-   **Task:** Search for and remove any remaining code related to local data storage.
-   **Reason:** The project mandate is to use Supabase exclusively. I recently removed a local test file, but other remnants of a previous local database implementation might still exist.

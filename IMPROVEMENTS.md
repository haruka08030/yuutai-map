# Project Improvement Plan

This plan outlines key areas for improving the Yuutai Map application, focusing on code quality, consistency, and maintainability.

## Next Up

### 1. Implement Anonymous Login
-   **Task:** Implement Anonymous Login for guest users as specified in `GEMINI.md`.
-   **Reason:** Provides a low-friction entry point for new users to try the app without full registration, improving user acquisition.
-   **Sub-tasks:**
    -   Investigate the current authentication flow in `auth_gate.dart`, `login_page.dart`, and `auth_repository.dart`.
    -   Add a method to `AuthRepository` to perform `supabase.auth.signInAnonymously()`.
    -   Add a "Continue as Guest" button to the login/signup screen.
    -   Consider how to handle linking anonymous accounts to permanent accounts later.

### 2. Implement Map Filtering by Store Category
-   **Task:** Implement Map Filtering by Store Category based on the `category_tag` in the `stores` table.
-   **Reason:** Enhance map usability by allowing users to filter stores by categories (e.g., "Restaurant", "Retail"), making it easier to find relevant locations.
-   **Sub-tasks:**
    -   Identify available `category_tag` values from the `stores` table.
    -   Add filter UI (e.g., `FilterChip` widgets) to `lib/features/map/presentation/map_page.dart`.
    -   Update `StoreRepository.getStores` to accept an optional `List<String>` of categories for filtering.
    -   Integrate filtering logic in `map_page.dart`'s `_fetchStores`.

### 3. Implement Configurable Alerts
-   **Task:** Implement Configurable Alerts for benefits.
-   **Reason:** Enhance user experience by allowing users to customize when they receive reminders for expiring benefits, rather than relying on a hardcoded "7 days before" alert.
-   **Sub-tasks:**
    1.  **Schema Update:** Add a new nullable integer column `notify_days_before` to the `public.users_yuutai` table in Supabase.
    2.  **Entity Update:** Add `int? notifyDaysBefore` to the `UsersYuutai` Freezed entity in `lib/domain/entities/users_yuutai.dart`.
    3.  **Regenerate Freezed Files:** Run `build_runner`.
    4.  **UI Update:** In `lib/features/benefits/presentation/users_yuutai_edit_page.dart`, replace the hardcoded "7日前" with a UI control (e.g., a dropdown or input field) to set `notify_days_before`.
    5.  **Notification Service Update:** Modify `lib/core/notifications/notification_service.dart` to use `notifyDaysBefore` when scheduling reminders.
    6.  **Default Value (Optional):** Consider a sensible default for new benefits if `notify_days_before` is not set by the user.

### 4. Implement Social Login (Google/Apple)
-   **Task:** Implement Social Login (Google/Apple) as specified in `GEMINI.md`.
-   **Reason:** To simplify the registration and login process for users, improving the overall user experience and onboarding flow.
-   **Sub-tasks:**
    -   Investigate Supabase documentation for Google & Apple sign-in with Flutter.
    -   Add "Sign in with Google" and "Sign in with Apple" buttons to the Login and Signup pages.
    -   Implement the social login logic in the `AuthRepository`.
    -   Ensure the app correctly handles OAuth callbacks.

---

## ✅ Completed

### 1. Documentation and Schema Alignment
-   **Task:** Update `GEMINI.md` to reflect the current database schema.
-   **Reason:** The `notes` column was recently added to the `public.users_yuutai` table, but the documentation has not been updated. Keeping documentation in sync with the implementation is crucial.

### 2. Refactor Status Management
-   **Task:** Refactor the `status` field in `users_yuutai` from a `String` to a Dart `enum`.
-   **Reason:** Using a `String` for status ('active', 'used', 'expired') is error-prone. An `enum` provides type safety, improves readability, and prevents invalid status values.
-   **Sub-tasks:**
    -   Create a `BenefitStatus` enum in Dart.
    -   Update the `UsersYuutai` entity to use this enum.
    -   Update the repository and UI code to handle the new enum type.

### 3. Code Cleanup
-   **Task:** Search for and remove any remaining code related to local data storage.
-   **Reason:** The project mandate is to use Supabase exclusively. I recently removed a local test file, but other remnants of a previous local database implementation might still exist.
-   **Outcome:** No code related to local data storage (Drift, SQLite) was found. The codebase is clean.

### 4. Implement Global Store View on Map
-   **Task:** Allow users to see all available stores on the map, not just those related to their benefits.
-   **Reason:** The current implementation only fetches stores for companies the user has benefits for. Displaying all stores enhances discovery and helps users decide which company benefits they might want to acquire.
-   **Sub-tasks:**
    -   Refactor `StoreRepository` to allow fetching all stores.
    -   Move the `Store` model to `domain/entities` and convert it to a Freezed class.
    -   Add a UI control on the map page to toggle between "My Stores" and "All Stores".

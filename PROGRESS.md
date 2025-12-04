# Progress Log

## 2025-12-03

- **Enhanced Guest User Experience:**
  - Implemented role-based access control for guest users.
  - Guests can now view store locations on the map by default.
  - Disabled the ability for guest users to add new shareholder benefits, hiding the UI elements.
  - Refined the map filter visibility to provide a cleaner interface for guests.
- **Providers and State Management:**
  - Added `isGuestProvider` to globally manage the guest user state.
- **Backend Configuration:**
  - Advised on enabling anonymous authentication in the Supabase backend to allow guest sign-in.

---

## 2025-12-03 (Refactor)

- **Simplified Guest Access Model:**
  - Refactored the authentication flow to remove the need for explicit "anonymous login".
  - A "guest" is now any user who is not logged in. The app starts directly in guest mode.
  - Removed `signInAnonymously` method and associated UI, simplifying the codebase.
  - Updated `isGuestProvider` to reflect the new definition (`user == null`).
  - Streamlined `AuthGate` to always show the main application screen, with UI adapting based on login state.
- **Backend Configuration:**
  - As anonymous logins are no longer used, it is recommended to **disable** this feature in the Supabase project settings for improved security.

---

## 2025-12-03 (UI/UX Adjustment)

- **Re-introduced Initial Choice Screen:**
  - Modified the app's startup flow to present an initial choice screen (`InitialAuthChoicePage`).
  - Users can now explicitly choose to log in, sign up, or proceed in guest mode upon app launch.
  - `AuthGate` now directs unauthenticated users to this choice screen, and authenticated users directly to the main app.

---

## 2025-12-03 (Features & Fixes)

- **Enhanced Notification Feature:**
  - Upgraded notification system to allow multiple, configurable reminders for a single benefit.
  - Database schema for `users_yuutai` was updated (`notify_days_before` is now an integer array).
  - Refactored the benefit edit page with a new UI, moving notification choices into a modal bottom sheet for a cleaner user experience.
  - Updated notification service to handle scheduling and cancellation of multiple reminders.
- **Improved List View UX:**
  - Fixed a bug causing a time lag for new/updated items to appear in the benefit list.
  - Refactored benefit list page to use Riverpod's `StreamProvider` for more robust and immediate state updates.
- **UI Polish:**
  - Added a border to the memo field and adjusted its label behavior for better visual clarity.

---

## 2025-12-03 (Form Validation & UI)

- **Improved Form Validation (IMPROVEMENTS.md #1):**
  - Implemented real-time validation (`AutovalidateMode.onUserInteraction`) for Signup, Login, and Benefit Edit forms.
  - Added a password strength indicator to the Signup form for better user feedback.
  - Made email validation stricter by adjusting the regex.
- **Map UI Refinement:**
  - Refactored map filter UI to use a modal bottom sheet, cleaning up the main map view.
  - Replaced the default Google Maps current location button with a custom `FloatingActionButton` to avoid overlap with modals and provide layout control.
- **Error Fixes:**
  - Resolved `Future already completed` crash on map by adding `!_controller.isCompleted` check.
  - Fixed build error by removing incompatible `uiLocalNotificationDateInterpretation` parameter.

---

## 2025-12-03 (Responsive Design)

- **Improved Responsive Design (IMPROVEMENTS.md #4):**
  - Implemented responsive navigation for `MainPage`, switching between `BottomNavigationBar` and `NavigationRail` based on screen width for better tablet/landscape support.
  - Ensured no problematic fixed heights were used on core navigation pages (`MainPage`, `UsersYuutaiPage`, `MapPage`, `SettingsPage`).
  - Added max-width constraints (600px) to form-heavy pages (`LoginPage`, `SignUpPage`, `UsersYuutaiEditPage`) and setting sub-widgets (`AuthOptionsPage`, `AccountInfoPage`) to prevent content from stretching too wide on large screens.

---

## 2025-12-03 (Loading States & UI)

- **Unified Loading States (IMPROVEMENTS.md #1):**
  - Created `AppLoadingIndicator` widget for consistent full-screen/page-level loading states.
  - Replaced inline `CircularProgressIndicator` usages with `AppLoadingIndicator` in `UsersYuutaiPage`, `CompanySearchPage`, `MapPage`, `AuthGate`, and `SettingsPage`.
  - Implemented skeleton loading for `UsersYuutaiPage` to enhance user experience during data fetching.
  - Created `LoadingElevatedButton` widget for consistent button loading states.
  - Replaced `ElevatedButton` usages with `LoadingElevatedButton` in `LoginPage` and `SignUpPage`.

---

## 2025-12-03 (Settings Enhancement)

- **Enhanced Settings Screen:**
  - Implemented Dark Mode toggle in `SettingsPage` to allow users to switch between light and dark themes.
  - Set up `ThemeProvider` with `shared_preferences` for persisting theme preference across app launches and sessions.
  - Defined a basic dark theme in `app_theme.dart`.
  - Integrated `ThemeProvider` into `MaterialApp` to dynamically apply the selected theme.


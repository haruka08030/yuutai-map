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

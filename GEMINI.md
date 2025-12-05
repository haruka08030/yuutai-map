# Project: Yuutai Map

## 1. Purpose
To develop a Flutter-based mobile application that helps users manage shareholder benefits ("yuutai") and visualize eligible store locations on a map, reducing decision-making costs and preventing opportunity losses.

## 2. Core Features

### 2.1. Benefit Management
- **CRUD Operations:** Registered users can add, view, edit, and delete their yuutai holdings.
- **List View:** Display owned benefits in a list or card format.
- **Manual Balance Tracking:** The `benefit_detail` and `notes` fields serve as free-text memos for users to manually track remaining values or quantities (e.g., "4 tickets left").
- **Status Control:** Users manually transition benefits between `active`, `used`, and `expired` states.

### 2.2. Map Visualization
- **Store Pinning:** Display all eligible stores from the `stores` table on a map.
- **Filtering:**
    - **By Ownership:** For registered users, toggle between viewing all stores vs. only stores associated with their currently held benefits. This filter is hidden for guest users.
    - **By Category:** Filter stores by their `category_tag` (e.g., "Restaurant", "Retail").

### 2.3. Authentication
- **Standard Login:** Email and password authentication.
- **Social Login:** Sign-in with Google and Apple for simplified access.
- **Guest Mode:** Users can use the app without an account. In guest mode, users have read-only access to browse map data. Account registration is required to manage personal benefits.

### 2.4. Notifications
- **Expiration Reminders:** Schedule local notifications to remind users about expiring benefits.
- **Configurable Timing:** Users can select multiple reminder timings (e.g., 30 days before, 7 days before, on the day) and set a custom day for notifications.

## 3. Architecture & Guiding Principles

- **Tech Stack:**
  - **Framework:** Flutter
  - **State Management:** Riverpod
  - **Backend:** Supabase (Auth, PostgreSQL, Edge Functions)
  - **Mapping:** Google Maps Platform
  - **Modeling:** Freezed

- **Architecture:**
  - Adhere strictly to **Clean Architecture** principles (Data, Domain, Presentation layers).
  - Use the **Repository Pattern** to abstract data sources.

- **Development Rules & Limitations:**
  - **Supabase-Only Persistence:** All user-specific application data **must** be stored in Supabase. Do **not** use local databases like SQLite or Drift for user data.
  - **Manual Calculations:** Business logic for benefit value/quantity deduction will **not** be implemented automatically. This is managed by the user manually editing text fields.
  - **Manual Status Flow:** A benefit's status (`active` -> `used`) must be changed explicitly by user action (e.g., tapping a "Mark as Used" button).
  - タスクを開始と言ったら’IMPROVEMENTS.md’を参照して自走して
  - ’IMPROVEMENTS.md’の内容を定期的に確認して、タスクを追加する
  - ナビゲーションアイテムのラベルは不要
  

## 4. Database Schema (Supabase)

### public.companies (Master Data)
- `id` (int8, PK): Auto-increment.
- `name` (text): Company name.
- `stock_code` (text): Stock ticker symbol.
- `official_url` (text): URL to official site.
- `logo_url` (text): URL to company logo.

### public.stores (Map Data)
- `id` (int8, PK): Auto-increment.
- `company_id` (int8, FK): Links to `companies`.
- `store_brand` (text): Store brand name.
- `name` (text): Store name.
- `address` (text): Store address.
- `lat` / `lng` (float8): Coordinates.
- `geog` (geography): PostGIS location data.
- `category_tag` (text): Filtering tag.

### public.users_yuutai (User Holdings)
- `id` (int8, PK): Auto-increment.
- `user_id` (uuid, FK): Links to `auth.users`.
- `company_id` (int8, FK, Nullable): Links to `companies`.
- `company_name` (text): Display name (manual input or from master).
- `benefit_detail` (text): **Free-text memo** for managing remaining balance/value.
- `notes` (text, nullable): General-purpose user notes.
- `expiry_date` (date, nullable): Expiration date.
- `status` (text): `active`, `used`, `expired`. Corresponds to the `BenefitStatus` enum in Dart.
- `alert_enabled` (bool): Notification toggle.
- `notify_days_before` (int[], nullable): An array of integers representing the days before expiry to send a notification.

## 5. Project Structure
```text
flutter_stock/
├── lib/
│   ├── app/                  # App-wide configurations (routing, theme)
│   ├── core/                 # Core utilities (notifications, validators)
│   ├── data/                 # Data layer (Repositories, Supabase client)
│   ├── domain/               # Domain layer (Entities, Repository interfaces)
│   ├── features/             # Feature modules (by feature)
│   └── main.dart             # Entry point
├── supabase/                 # Supabase migrations and edge functions
├── test/                     # Unit and widget tests
├── IMPROVEMENTS.md           # Task backlog and improvement plan
└── GEMINI.md                 # This file
```

# Project: Yuutai Map Specification

## Commands

- **Build iOS**: `flutter run`
- **Clean Build**:
  `flutter clean && flutter pub get && cd ios && pod install && cd ..`
- **Fix Pods**:
  `rm -rf ios/Pods ios/Podfile.lock && cd ios && pod install && cd ..`
- **Analyze**: `flutter analyze`

## Architecture

- **Framework**: Flutter (Stable)
- **State Management**: Riverpod (Hooks Riverpod + Riverpod Generator)
- **Target**: iOS/Android
- **Navigation**: GoRouter
- **Backend**: Supabase (Auth, DB, Storage)
- **Map**: Google Maps Flutter + Cluster Manager
- **Local DB**: None (Drift is planned for Phase 2)

## Coding Style

- **Linter**: Follow `analysis_options.yaml` (flutter_lints).
- **Hooks**: Use `flutter_hooks` for UI logic (TextEditingController,
  AnimationController).
- **Constructors**: Use `const` whenever possible.
- **Async**: Use `FutureBuilder` or Riverpod `AsyncValue` for async operations.
- **Logging**: Use a proper logger or `debugPrint`.
- **Imports**: Prefer absolute imports `package:flutter_stock/...`.
- **Color Opacity**: Use `.withValues(alpha: value)` instead of
  `.withOpacity(value)`.
- **If "Generated.xcconfig must exist" occurs**: ALWAYS run `flutter pub get`
  before `pod install`.
- **"Pod install failed"**: Run `make pod_clean`.
- **"Conflicting outputs"**: Run `make build_runner`.
- **Supabase Types**: If DB schema changes, update local models or run type
- Follow Effective Dart guidelines.

## 1. Vision & Core Value

A premium Flutter application for managing shareholder benefits ("yuutai") and
visualizing eligible store locations.

- **Core Value:** Reduces opportunity loss (using coupons before expiry) and
  decision fatigue (finding where to use them).
- **Target Audience:** Japan-based investors holding multiple shareholder
  benefits.
- **Design Philosophy:** "Premium Utility". High-quality UI/UX that feels like a
  polished consumer product, not just a database viewer.

## 2. Feature Specification

### 2.1. Benefit Management ("ToDo Style")

- **Concept:** Simplistic "ToDo" list approach.
- **Inputs:**
  - `benefit_detail` (Text): Free-text field (e.g., "500 yen x 10 tickets"). No
    structured integer parsing.
  - `notes` (Text): User memos.
- **State Logic:**
  - **Active:** Appears in the main list.
  - **Used (Binary):** A checkbox/button action moves the item to a
    "History/Completed" tab.
  - **Reverting:** Unchecking "Used" item in History returns it to the Active
    list.
- **Data Integrity:** The system does _not_ track partial usage (e.g., "3
  tickets used, 7 remaining"). Users manually update the text field if they wish
  to track partial balances.

### 2.2. Map & Geolocation

- **Clustering:**
  - **Implementation:** Client-side clustering (Google Maps Flutter plugin).
  - **Logic:** Aggregates pins dynamically based on zoom level.
- **Filtering:**
  - **"My Yuutai Only" Mode:** Strictly hides all pins for stores where the user
    does not have an _Active_ benefit.
  - **Cluster & Filter Interaction:** The cluster count must dynamically update
    to reflect the filtered state (e.g., a cluster of 50 becomes a cluster of 2
    if only 2 are owned).
- **Search:**
  - **Scope:** **Local Inventory Only**. Searches strictly against the `stores`
    table in Supabase.
  - **Result:** Does _not_ query Google Places API for missing stores. If a
    store is not in the DB, it does not exist in the app ecosystem.
- **Guest Mode:**
  - **Goal:** Volume/Discovery demonstration.
  - **Interaction:** Browsing allowed. Clicking a specific store pin (e.g.,
    "Skylark") opens a Call-to-Action (CTA): _"Register to manage your coupons
    for Skylark and never miss an expiry date."_

### 2.3. Notifications (Server-Side Authority)

- **Architecture:** Supabase Edge Functions + Firebase Cloud Messaging (FCM).
- **Trigger:** Scheduled Cron Job (Daily).
- **Timezone:** **Strictly JST (Japan Standard Time)**. All expiration logic
  assumes Japanese business days.
- **Rules:**
  - User configurable days (e.g., 30 days, 7 days, 1 day before).
  - Sent to _all_ logged-in devices.

### 2.4. Data Administration (Master Data)

- **Strategy:** Manual Curation.
- **Pipeline:**
  1. User reports missing store via external form (Google Form).
  2. Developer verifies data.
  3. Developer inserts data via SQL scripts to `stores`/`companies` tables.
- **Constraint:** No in-app "Add Store" UI for V1.

## 3. Technical Architecture

### 3.1. Tech Stack

- **Frontend:** Flutter (Sorts: Riverpod, Freezed, GoRouter).
- **Backend:** Supabase (PostgreSQL, Auth, Edge Functions, Storage).
- **Maps:** Google Maps Platform (Flutter SDK).
- **Notifications:** FCM (Firebase Cloud Messaging).

### 3.2. Tables

### `public.companies` (企業マスタ)

| column_name  | data_type                | is_nullable |
| ------------ | ------------------------ | ----------- |
| id           | bigint                   | NO          |
| created_at   | timestamp with time zone | YES         |
| name         | text                     | NO          |
| stock_code   | text                     | YES         |
| official_url | text                     | YES         |
| logo_url     | text                     | YES         |

### `public.stores` (店舗マスタ)

| column_name  | data_type                | is_nullable |
| ------------ | ------------------------ | ----------- |
| id           | bigint                   | NO          |
| company_id   | bigint                   | YES         |
| lat          | double precision         | YES         |
| lng          | double precision         | YES         |
| geog         | USER-DEFINED             | YES         |
| created_at   | timestamp with time zone | YES         |
| name         | text                     | NO          |
| address      | text                     | YES         |
| category_tag | text                     | YES         |
| store_brand  | text                     | YES         |

### `public.folders` (フォルダ)

| column_name | data_type                | is_nullable |
| ----------- | ------------------------ | ----------- |
| id          | uuid                     | NO          |
| user_id     | uuid                     | NO          |
| sort_order  | integer                  | NO          |
| created_at  | timestamp with time zone | YES         |
| name        | text                     | NO          |

### `public.users_yuutai` (ユーザー優待)

| column_name        | data_type                | is_nullable |
| ------------------ | ------------------------ | ----------- |
| id                 | bigint                   | NO          |
| user_id            | uuid                     | NO          |
| company_id         | bigint                   | YES         |
| alert_enabled      | boolean                  | YES         |
| created_at         | timestamp with time zone | YES         |
| notify_days_before | ARRAY                    | YES         |
| folder_id          | uuid                     | YES         |
| expiry_date        | date                     | YES         |
| company_name       | text                     | YES         |
| benefit_detail     | text                     | YES         |
| notes              | text                     | YES         |
| status             | text                     | YES         |

### 3.3. Development Guidelines

- **Data Caching:** Use Riverpod (in-memory) for caching data. Persistent
  offline storage (Drift) is not implemented in V1.
- **Strict Typing:** All data models generated via `freezed`.
- **Linting:** strict analysis options enabled.

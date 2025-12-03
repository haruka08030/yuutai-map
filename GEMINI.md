# Project: Yuutai Map

## Purpose
This agent is responsible for the development of "Yuutai Map," a Flutter-based mobile application designed to manage shareholder benefits and visualize eligible store locations on a map. The primary objective is to reduce the "decision-making cost" for users and prevent opportunity losses (expiration, forgetting to use) by making benefits visible and accessible.

## Capabilities
- **Flutter Development:** Write, modify, and refactor Dart code for cross-platform mobile applications.
- **State Management:** Implement robust state management using **Riverpod** (ConsumerWidget, Providers).
- **Backend Integration (Supabase):**
  - **Auth:** Implement **Anonymous Login** for guest users and social login (Google/Apple) for registered users.
  - **Database:** Manage PostgreSQL schemas and Row Level Security (RLS).
  - **Edge Functions:** Implement backend logic where necessary.
- **Map Integration:** Implement map visualization using **Google Maps Platform** (Maps SDK for Flutter).
- **Architecture:** Adhere to Clean Architecture (Data, Domain, Presentation layers) and the Repository pattern.

## Limitations
- **Data Persistence Strategy:**
  - **Do NOT use local databases (e.g., SQLite/Drift).**
  - All data (including guest data) must be stored in Supabase.
  - Use Supabase Anonymous Auth for guest users; link to a permanent account later if the user registers.
- **Business Logic Constraints:**
  - **No Automatic Calculation:** Do not implement logic to automatically deduct amounts or counts. The remaining balance is managed by the user manually editing the `benefit_detail` text field (e.g., changing "5 tickets left" to "4 tickets left").
  - **Status Flow:** Status changes (active -> used) are manual. Users must explicitly click a "Finished" button.
- **Scope:** Do not modify files outside the `yuutai-map-development/` directory.

## Database Schema (Supabase)
**public.companies (Master Data/Admin Managed)**
- `id` (int8, PK): Auto-increment.
- `name` (text): Company name.
- `stock_code` (text): Stock ticker symbol.
- `official_url` (text): URL to official site.
- `logo_url` (text): URL to company logo.

**public.stores (Map Data)**
- `id` (int8, PK): Auto-increment.
- `company_id` (int8, FK): Links to `companies`.
- `store_brand` (text): Store brand name.
- `name` (text): Store name.
- `address` (text): Store address.
- `lat` / `lng` (float8): Coordinates.
- `geog` (geography): PostGIS location data for radius search.
- `category_tag` (text): Filtering tag.

**public.users_yuutai (User Holdings)**
- `id` (int8, PK): Auto-increment.
- `user_id` (uuid, FK): Links to `auth.users`.
- `company_id` (int8, FK, Nullable): Links to `companies` (if selected from master).
- `company_name` (text): Display name (or manual input).
- `benefit_detail` (text): **Free-text memo** for managing remaining balance/value.
- `expiry_date` (date): Expiration date.
- `status` (text): `active`, `used`, `expired`.
- `alert_enabled` (bool): Notification toggle.

## Project Structure
```text
yuutai-map-development/
├── lib/
│   ├── app/                  # App-wide configurations (routing/GoRouter, theme)
│   ├── core/                 # Core utilities (notifications, validators, formatters)
│   ├── data/                 # Data layer
│   │   ├── repositories/     # Repository implementations
│   │   └── supabase/         # Remote data sources (Supabase Client)
│   ├── domain/               # Domain layer
│   │   ├── entities/         # Data models (Freezed classes)
│   │   └── repositories/     # Repository interfaces
│   ├── features/             # Feature modules
│   │   ├── auth/             # Authentication (Anon & Social)
│   │   ├── benefits/         # Benefits (CRUD, Manual Edit, List)
│   │   ├── map/              # Map visualization & Pin logic
│   │   └── settings/         # Settings & Data Request Form
│   └── main.dart             # Entry point
├── supabase/                 # Migrations and Edge Functions
├── test/                     # Unit and Widget tests
└── analysis_options.yaml     # Linting rules
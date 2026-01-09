# Project: Yuutai Map Specification

## 1. Vision & Core Value
A premium Flutter application for managing shareholder benefits ("yuutai") and visualizing eligible store locations.
- **Core Value:** Reduces opportunity loss (using coupons before expiry) and decision fatigue (finding where to use them).
- **Target Audience:** Japan-based investors holding multiple shareholder benefits.
- **Design Philosophy:** "Premium Utility". High-quality UI/UX that feels like a polished consumer product, not just a database viewer.

## 2. Feature Specification

### 2.1. Benefit Management ("ToDo Style")
- **Concept:** Simplistic "ToDo" list approach.
- **Inputs:**
    - `benefit_detail` (Text): Free-text field (e.g., "500 yen x 10 tickets"). No structured integer parsing.
    - `notes` (Text): User memos.
- **State Logic:**
    - **Active:** Appears in the main list.
    - **Used (Binary):** A checkbox/button action moves the item to a "History/Completed" tab.
    - **Reverting:** Unchecking "Used" item in History returns it to the Active list.
- **Data Integrity:** The system does *not* track partial usage (e.g., "3 tickets used, 7 remaining"). Users manually update the text field if they wish to track partial balances.

### 2.2. Map & Geolocation
- **Clustering:**
    - **Implementation:** Client-side clustering (Google Maps Flutter plugin).
    - **Logic:** Aggregates pins dynamically based on zoom level.
- **Filtering:**
    - **"My Yuutai Only" Mode:** Strictly hides all pins for stores where the user does not have an *Active* benefit.
    - **Cluster & Filter Interaction:** The cluster count must dynamically update to reflect the filtered state (e.g., a cluster of 50 becomes a cluster of 2 if only 2 are owned).
- **Search:**
    - **Scope:** **Local Inventory Only**. Searches strictly against the `stores` table in Supabase.
    - **Result:** Does *not* query Google Places API for missing stores. If a store is not in the DB, it does not exist in the app ecosystem.
- **Guest Mode:**
    - **Goal:** Volume/Discovery demonstration.
    - **Interaction:** Browsing allowed. Clicking a specific store pin (e.g., "Skylark") opens a Call-to-Action (CTA): *"Register to manage your coupons for Skylark and never miss an expiry date."*

### 2.3. Notifications (Server-Side Authority)
- **Architecture:** Supabase Edge Functions + Firebase Cloud Messaging (FCM).
- **Trigger:** Scheduled Cron Job (Daily).
- **Timezone:** **Strictly JST (Japan Standard Time)**. All expiration logic assumes Japanese business days.
- **Offline handling:**
    - System accepts that offline users might receive "False Positive" reminders if they used a coupon offline but haven't synced.
    - "Used" status updates done offline will stop future notifications once connectivity is restored and sync occurs.
- **Rules:**
    - User configurable days (e.g., 30 days, 7 days, 1 day before).
    - Sent to *all* logged-in devices.

### 2.4. Data Administration (Master Data)
- **Strategy:** Manual Curation.
- **Pipeline:**
    1.  User reports missing store via external form (Google Form).
    2.  Developer verifies data.
    3.  Developer inserts data via SQL scripts to `stores`/`companies` tables.
- **Constraint:** No in-app "Add Store" UI for V1.

## 3. Technical Architecture

### 3.1. Tech Stack
- **Frontend:** Flutter (Sorts: Riverpod, Freezed, GoRouter).
- **Backend:** Supabase (PostgreSQL, Auth, Edge Functions, Storage).
- **Maps:** Google Maps Platform (Flutter SDK).
- **Notifications:** FCM (Firebase Cloud Messaging).

### 3.2. Database Schema Refinements
*(Specific field requirements based on decisions)*
- **`users_yuutai` Table:**
    - `status` (Text): `active`, `used`, `expired` - The source of truth for filtering.
    - `benefit_detail` (Text): The user's manual ledger.
    - `folder_id` (UUID, nullable): References `folders.id` for organization.
- **`folders` Table:**
    - `id` (UUID, PK): Unique folder identifier.
    - `user_id` (UUID, FK): References `auth.users`.
    - `name` (Text): User-defined folder name.
    - `sort_order` (Integer): Manual ordering of folders.
- **`stores` Table:**
    - No real-time proxying. Static lat/lng coordinates required.

### 3.3. Development Guidelines
- **Offline First (Read:** Cached data via Riverpod/Drift (if needed) or simple in-memory caching. Sync on connect.
- **Strict Typing:** All data models generated via `freezed`.
- **Linting:** strict analysis options enabled.

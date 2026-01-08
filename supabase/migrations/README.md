# Supabase Migrations

This directory contains SQL migration files for the Yuutai Map database schema.

## Migration History

| # | File | Description | Status |
|---|------|-------------|--------|
| 001 | `001_create_companies.sql` | Create companies master table | ✅ Applied |
| 002 | `002_create_stores.sql` | Create stores table with geolocation | ✅ Applied |
| 003 | `003_create_users_yuutai.sql` | Create users_yuutai table for benefit tracking | ✅ Applied |
| 004 | `004_add_folders.sql` | Add folders feature for organizing benefits | ✅ Applied |

## How to Apply Migrations

### Via Supabase Dashboard (Recommended for existing projects)
1. Open your Supabase project dashboard
2. Navigate to SQL Editor
3. Copy and paste the migration file content
4. Execute the SQL
5. Update this README to mark as "✅ Applied"

### Via Supabase CLI (For new environments)
```bash
supabase db push
```

## Latest Schema Changes (Migration 004)

**Added Tables:**
- `folders` - User-created folders for organizing shareholder benefits

**Modified Tables:**
- `users_yuutai` - Added `folder_id` column (nullable, references `folders.id`)

**Features:**
- Users can create, rename, and delete folders
- Coupons can be assigned to folders
- Deleting a folder sets associated coupons to "uncategorized" (folder_id = NULL)
- Row Level Security (RLS) ensures users only access their own folders

## Notes
- All migrations are idempotent (safe to run multiple times)
- RLS is enabled on all user-facing tables
- Indexes are created for optimal query performance

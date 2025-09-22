#!/bin/bash

# Setup database script for yuutai-map

set -e

echo "🚀 Starting database setup for yuutai-map..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "Please create .env file with SUPABASE_URL and SUPABASE_ANON_KEY"
    exit 1
fi

# Check if stores_data.json exists, if not create it
if [ ! -f "stores_data.json" ]; then
    echo "📄 Converting CSV to JSON..."
    dart scripts/csv_to_json.dart
fi

# Install dependencies if needed
echo "📦 Installing dependencies..."
flutter pub get

# Seed the database
echo "🌱 Seeding stores data to Supabase..."
dart scripts/seed_stores.dart

echo "✅ Database setup complete!"
echo ""
echo "Next steps:"
echo "1. Update your .env file with actual Supabase credentials"
echo "2. Run 'flutter run' to start the app"
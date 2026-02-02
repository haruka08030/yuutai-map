# Makefile for yuutai-map project

# Seed stores data to Supabase
seed-stores:
	@echo "📦 Seeding stores data to Supabase..."
	@dart scripts/seed_stores.dart

# Deploy Supabase Edge Functions
deploy-functions:
	@echo "🚀 Deploying Supabase Edge Functions..."
	@./scripts/deploy_functions.sh

# Install dependencies
install:
	@echo "Installing Flutter dependencies..."
	flutter pub get

# Run the app
run:
	@echo "Running the Flutter app..."
	flutter run

# Build for release
build:
	@echo "Building Flutter app for release..."
	flutter build apk --release

# Clean build files
clean:
	flutter clean

# Help
help:
	@echo "Available commands:"
	@echo "  make install          - Flutter dependencies"
	@echo "  make run             - Run the Flutter app"
	@echo "  make build           - Build for release"
	@echo "  make clean           - Clean build files"
	@echo "  make seed-stores     - Seed stores data to Supabase"
	@echo "  make deploy-functions - Deploy Supabase Edge Functions"

.PHONY: seed-stores deploy-functions install run build clean help
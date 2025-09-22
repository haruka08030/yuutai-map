# Makefile for yuutai-map project

# Seed stores data to Supabase
seed-stores:
	@echo "Seeding stores data to Supabase..."
	dart scripts/seed_stores.dart

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
	@echo "Cleaning build files..."
	flutter clean

# Help
help:
	@echo "Available commands:"
	@echo "  seed-stores  - Seed stores data to Supabase"
	@echo "  install      - Install Flutter dependencies"
	@echo "  run          - Run the Flutter app"
	@echo "  build        - Build for release"
	@echo "  clean        - Clean build files"
	@echo "  help         - Show this help message"

.PHONY: seed-stores install run build clean help
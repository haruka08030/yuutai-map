# Makefile for yuutai-map project

# ==============================================================================
# Flutter App Commands
# ==============================================================================

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

# ==============================================================================
# Code Generation (build_runner)
# ==============================================================================

# Run build_runner once
build_runner:
	@echo "Running build_runner..."
	dart run build_runner build --delete-conflicting-outputs

# Watch for file changes and run build_runner
watch_runner:
	@echo "Watching for file changes with build_runner..."
	dart run build_runner watch --delete-conflicting-outputs

# ==============================================================================
# iOS Specific Commands
# ==============================================================================

# Install CocoaPods dependencies
pod_install:
	@echo "Installing pods in ios/..."
	(cd ios && pod install)

# Clean CocoaPods cache and installations
pod_clean:
	@echo "Cleaning Pods..."
	rm -rf ios/Podfile.lock ios/Pods ios/Runner.xcworkspace

# ==============================================================================
# Database Commands
# ==============================================================================

# Seed stores data to Supabase
seed-stores:
	@echo "Seeding stores data to Supabase..."
	dart scripts/seed_stores.dart

# ==============================================================================
# Help
# ==============================================================================

# Help
help:
	@echo "Available commands:"
	@echo ""
	@echo "Flutter:"
	@echo "  install      - Install Flutter dependencies"
	@echo "  run          - Run the Flutter app"
	@echo "  build        - Build for release"
	@echo "  clean        - Clean build files"
	@echo ""
	@echo "Code Generation:"
	@echo "  build_runner - Run build_runner once"
	@echo "  watch_runner - Run build_runner continuously"
	@echo ""
	@echo "iOS:"
	@echo "  pod_install  - Install CocoaPods dependencies"
	@echo "  pod_clean    - Clean CocoaPods cache"
	@echo ""
	@echo "Database:"
	@echo "  seed-stores  - Seed stores data to Supabase"
	@echo ""
	@echo "Other:"
	@echo "  help         - Show this help message"


.PHONY: install run build clean build_runner watch_runner pod_install pod_clean seed-stores help
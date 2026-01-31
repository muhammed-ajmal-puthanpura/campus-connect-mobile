#!/bin/bash

# Campus Connect Mobile App - Quick Setup Script
# This script helps you set up and run the Flutter mobile app

set -e  # Exit on error

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Campus Connect Mobile App - Quick Setup & Run          ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Flutter is installed
print_info "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "  Visit: https://flutter.dev/docs/get-started/install"
    echo ""
    exit 1
fi

print_success "Flutter found: $(flutter --version | head -n 1)"
echo ""

# Navigate to mobile_app directory
print_info "Navigating to mobile_app directory..."
cd "$(dirname "$0")/mobile_app" || {
    print_error "mobile_app directory not found!"
    exit 1
}
print_success "In mobile_app directory"
echo ""

# Check Flutter doctor
print_info "Running Flutter doctor..."
flutter doctor
echo ""

# Install dependencies
print_info "Installing dependencies (flutter pub get)..."
flutter pub get
print_success "Dependencies installed"
echo ""

# Check for available devices
print_info "Checking for available devices..."
flutter devices
echo ""

# Check if web is enabled
print_info "Enabling web support..."
flutter config --enable-web > /dev/null 2>&1 || true
print_success "Web support enabled"
echo ""

# Ask user how they want to run the app
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                    How to Run the App                    ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Choose how you want to run the app:"
echo ""
echo "  1) Chrome Browser (Easiest - Recommended for first run)"
echo "  2) Android Emulator"
echo "  3) iOS Simulator (macOS only)"
echo "  4) First available device"
echo "  5) List all devices and let me choose"
echo "  6) Exit"
echo ""
read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        print_info "Running app in Chrome browser..."
        print_warning "Make sure your backend is running at http://localhost:5000"
        echo ""
        print_info "The app will open in Chrome. You can login with:"
        echo "   Email: student@example.com"
        echo "   Password: password123"
        echo ""
        sleep 2
        flutter run -d chrome
        ;;
    2)
        print_info "Running app on Android emulator..."
        print_warning "Make sure an Android emulator is running"
        echo ""
        flutter run -d android
        ;;
    3)
        print_info "Running app on iOS simulator..."
        print_warning "This only works on macOS"
        echo ""
        flutter run -d ios
        ;;
    4)
        print_info "Running app on first available device..."
        flutter run
        ;;
    5)
        print_info "Available devices:"
        flutter devices
        echo ""
        read -p "Enter device ID: " device_id
        print_info "Running app on device: $device_id"
        flutter run -d "$device_id"
        ;;
    6)
        print_info "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

print_success "Setup complete!"
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                    App is Running!                        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Hot reload tips:"
echo "  - Press 'r' to hot reload"
echo "  - Press 'R' to hot restart"
echo "  - Press 'q' to quit"
echo ""
echo "Demo accounts:"
echo "  Student:   student@example.com / password123"
echo "  Organizer: organizer@example.com / password123"
echo "  HOD:       hod@example.com / password123"
echo "  Principal: principal@example.com / password123"
echo "  Admin:     admin@example.com / password123"
echo ""

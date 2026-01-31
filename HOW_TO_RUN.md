# 🚀 HOW TO RUN THE APP - Complete Step-by-Step Guide

This guide will help you run and preview the Campus Connect Flutter mobile app on your computer.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Setup Instructions](#detailed-setup-instructions)
4. [Running the App](#running-the-app)
5. [Preview Options](#preview-options)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before running the app, you need:

### 1. Flutter SDK

**Download and Install Flutter:**
- Visit: https://flutter.dev/docs/get-started/install
- Choose your operating system (Windows, macOS, Linux)
- Follow the installation instructions

**Verify Installation:**
```bash
flutter --version
flutter doctor
```

The `flutter doctor` command will check your setup and tell you what's missing.

### 2. Development Environment

Choose ONE of the following based on your target platform:

**For Android Development:**
- Android Studio (https://developer.android.com/studio)
- Android SDK
- Android Emulator or Physical Android Device

**For iOS Development (macOS only):**
- Xcode (from Mac App Store)
- iOS Simulator or Physical iOS Device
- CocoaPods (`sudo gem install cocoapods`)

**For Web Preview (easiest):**
- Google Chrome browser
- No additional setup needed!

### 3. Backend Server

Make sure your Flask backend is running:
```bash
# In the repository root
python app.py
```

The backend should be accessible at `http://localhost:5000`

---

## Quick Start

### 🎯 Fastest Way to Preview (Using Chrome)

```bash
# 1. Navigate to the mobile app directory
cd mobile_app

# 2. Install dependencies
flutter pub get

# 3. Enable web support (if not already enabled)
flutter config --enable-web

# 4. Run in Chrome browser
flutter run -d chrome
```

This will open the app in your Chrome browser! ✨

---

## Detailed Setup Instructions

### Step 1: Install Flutter

#### Windows:
```bash
# Download Flutter SDK from flutter.dev
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin
```

#### macOS/Linux:
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Add to your shell profile (~/.bashrc, ~/.zshrc)
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.bashrc
```

#### Verify:
```bash
flutter --version
flutter doctor
```

### Step 2: Setup Development Tools

#### For Android:
```bash
# Install Android Studio
# During setup, install:
# - Android SDK
# - Android SDK Platform
# - Android Virtual Device (AVD)

# Accept licenses
flutter doctor --android-licenses
```

#### For iOS (macOS only):
```bash
# Install Xcode from Mac App Store
# Install CocoaPods
sudo gem install cocoapods

# Setup Xcode command line tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### Step 3: Navigate to the App

```bash
cd /path/to/campus-connect-mobile/mobile_app
```

### Step 4: Install Dependencies

```bash
flutter pub get
```

This downloads all required packages listed in `pubspec.yaml`.

### Step 5: Configure the Backend URL

Edit the file `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Update this line with your backend URL:
  static const String baseUrl = 'http://localhost:5000';  // ← Change this
  
  // For different scenarios:
  // Android Emulator: 'http://10.0.2.2:5000'
  // iOS Simulator: 'http://localhost:5000'
  // Physical Device: 'http://YOUR_COMPUTER_IP:5000' (e.g., 'http://192.168.1.100:5000')
  // Production: 'https://your-domain.com'
}
```

**Finding Your Computer's IP Address:**
- **Windows**: `ipconfig` (look for IPv4 Address)
- **macOS/Linux**: `ifconfig` or `ip addr` (look for inet)

---

## Running the App

### Option 1: Run in Chrome Browser (Easiest!)

```bash
# Enable web support
flutter config --enable-web

# Run the app
flutter run -d chrome
```

The app will open in your Chrome browser at `http://localhost:xxxxx`

**Pros:**
- ✅ Fastest to set up
- ✅ No emulator needed
- ✅ Works on all operating systems
- ✅ Good for testing UI and functionality

**Cons:**
- ❌ Camera/QR scanning may not work perfectly
- ❌ Some mobile-specific features limited

### Option 2: Run on Android Emulator

```bash
# Create an Android Virtual Device (first time only)
flutter emulators --create

# Or use Android Studio: Tools > AVD Manager > Create Virtual Device

# List available devices
flutter devices

# Run the app
flutter run
```

**Pros:**
- ✅ Full Android experience
- ✅ Test device-specific features
- ✅ Camera simulation available

**Cons:**
- ❌ Slower startup
- ❌ Requires more RAM/CPU

### Option 3: Run on iOS Simulator (macOS only)

```bash
# Open iOS Simulator
open -a Simulator

# List available devices
flutter devices

# Run the app
flutter run
```

**Pros:**
- ✅ Full iOS experience
- ✅ Fast on Apple Silicon Macs

**Cons:**
- ❌ macOS only
- ❌ Camera simulation limited

### Option 4: Run on Physical Device

#### Android Device:
```bash
# 1. Enable Developer Options on your phone:
#    Settings > About Phone > Tap "Build Number" 7 times

# 2. Enable USB Debugging:
#    Settings > Developer Options > USB Debugging

# 3. Connect via USB

# 4. Verify device is connected
flutter devices

# 5. Run the app
flutter run
```

#### iOS Device (macOS only):
```bash
# 1. Connect iPhone/iPad via USB
# 2. Trust the computer on your device
# 3. Open project in Xcode: open ios/Runner.xcworkspace
# 4. Sign the app with your Apple ID
# 5. Run from Xcode or:
flutter run
```

**Pros:**
- ✅ Real device experience
- ✅ Full camera/QR scanning
- ✅ Test on actual hardware

**Cons:**
- ❌ Requires physical device
- ❌ iOS requires Apple Developer account for some features

---

## Preview Options

### Development Mode Features

When you run with `flutter run`, you get:

- **Hot Reload**: Press `r` to instantly reload changes
- **Hot Restart**: Press `R` to restart the app
- **Debug Console**: See logs and errors
- **Inspector**: Press `i` to toggle widget inspector

### Build Preview (APK/IPA)

#### Android APK:
```bash
# Build APK for testing
flutter build apk --debug

# APK location:
# build/app/outputs/flutter-apk/app-debug.apk

# Install on device:
flutter install
```

#### iOS (macOS only):
```bash
# Build for iOS
flutter build ios --debug

# Open in Xcode to install:
open ios/Runner.xcworkspace
```

### Web Preview URL

After running `flutter run -d chrome`, access at:
```
http://localhost:[PORT]/
```

You can also share this with others on your network if they can access your computer's IP.

---

## Troubleshooting

### Problem: Flutter command not found

**Solution:**
```bash
# Make sure Flutter is in your PATH
export PATH="$PATH:/path/to/flutter/bin"

# Or reinstall Flutter
```

### Problem: "No devices found"

**Solutions:**

1. **For Web:**
```bash
flutter config --enable-web
flutter devices
```

2. **For Android:**
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Or start from Android Studio
```

3. **For iOS:**
```bash
# Open Simulator
open -a Simulator
```

### Problem: "Unable to connect to backend"

**Solutions:**

1. **Check backend is running:**
```bash
curl http://localhost:5000
```

2. **Update API URL in app:**
   - Edit `lib/config/api_config.dart`
   - For Android Emulator: use `http://10.0.2.2:5000`
   - For iOS Simulator: use `http://localhost:5000`
   - For Physical Device: use `http://YOUR_COMPUTER_IP:5000`

3. **Check firewall:**
   - Allow port 5000 in your firewall
   - Disable firewall temporarily for testing

### Problem: "Gradle build failed" (Android)

**Solutions:**
```bash
# Clean build
cd android
./gradlew clean

# Or from project root
flutter clean
flutter pub get
flutter run
```

### Problem: "Pod install failed" (iOS)

**Solutions:**
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

### Problem: "Hot reload not working"

**Solution:**
```bash
# Press 'R' (capital R) for hot restart instead of 'r'
# Or restart the app completely
```

### Problem: Camera/QR scanning not working

**Check:**
1. Permissions granted in Android/iOS settings
2. `AndroidManifest.xml` has camera permission
3. `Info.plist` has camera permission
4. Use real device instead of emulator

---

## Quick Reference Commands

```bash
# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on first available device
flutter run

# Run on specific device
flutter run -d <device-id>

# List all devices
flutter devices

# Clean build
flutter clean

# Check Flutter setup
flutter doctor

# Hot reload (press in terminal)
r

# Hot restart (press in terminal)
R

# Quit app (press in terminal)
q
```

---

## Demo Accounts

Test the app with these accounts:

| Role | Email | Password |
|------|-------|----------|
| Student | student@example.com | password123 |
| Organizer | organizer@example.com | password123 |
| HOD | hod@example.com | password123 |
| Principal | principal@example.com | password123 |
| Admin | admin@example.com | password123 |

---

## Visual Preview

### Expected Flow:

```
1. Splash Screen
   ↓
2. Login Screen (Enter credentials)
   ↓
3. Dashboard (Based on role)
   ↓
4. Various features based on user role
```

### Screenshots will show:

- 📱 Login screen with demo account info
- 🎓 Student dashboard with events
- 📅 Event list and details
- 📱 QR ticket display
- 👨‍💼 Organizer/HOD/Principal/Admin dashboards

---

## Next Steps

After successfully running the app:

1. **Test Login**: Use demo accounts above
2. **Explore Features**: Based on your user role
3. **Test Backend Integration**: Make sure API calls work
4. **Test QR Code**: If using physical device with camera
5. **Review Documentation**: Check `DEVELOPER_GUIDE.md` for more details

---

## Getting Help

If you encounter issues:

1. Run `flutter doctor` and fix any issues shown
2. Check the `DEVELOPER_GUIDE.md` for detailed troubleshooting
3. Review Flutter documentation: https://flutter.dev/docs
4. Check backend is running and accessible

---

## Summary

**Easiest way to preview:**
```bash
cd mobile_app
flutter pub get
flutter config --enable-web
flutter run -d chrome
```

**For full mobile experience:**
```bash
cd mobile_app
flutter pub get
flutter run  # Will use first available device
```

That's it! Your app should now be running! 🎉

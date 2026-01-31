# Campus Connect Mobile App - Developer Guide

## Table of Contents
1. [Setup and Installation](#setup-and-installation)
2. [Project Structure](#project-structure)
3. [Configuration](#configuration)
4. [API Integration](#api-integration)
5. [Running the App](#running-the-app)
6. [Building for Production](#building-for-production)
7. [Testing](#testing)
8. [Troubleshooting](#troubleshooting)

## Setup and Installation

### Prerequisites
- Flutter SDK 3.0.0 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK 3.0.0 or higher (comes with Flutter)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)
- A running instance of the Campus Connect backend

### Installation Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd campus-connect-mobile/mobile_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Verify Flutter installation**
```bash
flutter doctor
```
Address any issues reported by `flutter doctor`.

4. **Configure API endpoint**
Edit `lib/config/api_config.dart` and update the `baseUrl`:
```dart
static const String baseUrl = 'http://your-backend-url:5000';
```

For development with backend running locally:
- **Android Emulator**: Use `http://10.0.2.2:5000`
- **iOS Simulator**: Use `http://localhost:5000` or `http://127.0.0.1:5000`
- **Physical Device**: Use your computer's IP address, e.g., `http://192.168.1.100:5000`

## Project Structure

```
mobile_app/
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Dart source code
│   ├── config/          # Configuration (API, Theme)
│   ├── models/          # Data models
│   ├── providers/       # State management (Provider)
│   ├── screens/         # UI screens
│   │   ├── auth/       # Authentication screens
│   │   ├── student/    # Student features
│   │   ├── organizer/  # Organizer features
│   │   ├── hod/        # HOD features
│   │   ├── principal/  # Principal features
│   │   └── admin/      # Admin features
│   ├── services/        # API services
│   ├── utils/           # Utility functions
│   ├── widgets/         # Reusable widgets
│   └── main.dart       # App entry point
├── assets/              # Images, fonts, etc.
├── test/                # Unit and widget tests
├── pubspec.yaml         # Dependencies
└── README.md           # Documentation
```

## Configuration

### API Configuration

Edit `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Update this to your backend URL
  static const String baseUrl = 'http://your-backend-url:5000';
  
  // Adjust timeouts if needed
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### Theme Customization

Edit `lib/config/theme.dart` to customize colors and styles:

```dart
class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color accentColor = Color(0xFFF59E0B);
  // ... more customizations
}
```

## API Integration

The app communicates with the Flask backend through REST APIs.

### Authentication Flow

1. User enters credentials in login screen
2. App sends POST request to `/auth/login`
3. Backend returns JWT token and user data
4. Token is stored securely using `flutter_secure_storage`
5. Token is included in all subsequent API requests

### Example API Call

```dart
// In a service file
final response = await _apiService.get(
  ApiConfig.studentEvents,
  includeAuth: true,  // Include JWT token
);

if (response.success) {
  // Handle successful response
  final events = response.data;
} else {
  // Handle error
  print(response.message);
}
```

### Available Services

- **AuthService**: Login, register, logout, change password
- **StudentService**: Browse events, register, view certificates
- **OrganizerService**: Create events, scan QR codes
- **HodService**: Approve/reject events
- **PrincipalService**: Final event approval
- **AdminService**: System analytics and reports

## Running the App

### Development Mode

**Run on connected device or emulator:**
```bash
flutter run
```

**Run on specific device:**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

**Hot Reload:**
Press `r` in the terminal to hot reload changes.

**Hot Restart:**
Press `R` to hot restart the app.

### Debug Mode Features
- Detailed error messages
- Debug console output
- Hot reload/restart

## Building for Production

### Android

**Build APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Build App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

**Build for iOS:**
```bash
flutter build ios --release
```

Then open the project in Xcode:
```bash
open ios/Runner.xcworkspace
```

Create an archive in Xcode for App Store submission.

## Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Widget Testing
```bash
flutter test test/widget_test.dart
```

## Troubleshooting

### Common Issues

#### 1. API Connection Failed
**Problem:** "No internet connection" or "Unable to connect to server"

**Solutions:**
- Verify backend is running
- Check `baseUrl` in `api_config.dart`
- For emulator, use correct IP address:
  - Android: `10.0.2.2`
  - iOS: `localhost` or `127.0.0.1`
- For physical device, use computer's IP address
- Ensure firewall allows connections

#### 2. JWT Token Issues
**Problem:** "Unauthorized" or "Invalid token"

**Solutions:**
- Clear app data and login again
- Check token expiration in backend
- Verify token is being sent in headers

#### 3. Build Errors
**Problem:** Gradle or build errors

**Solutions:**
```bash
# Clean build
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade

# Check Flutter health
flutter doctor
```

#### 4. QR Scanner Not Working
**Problem:** Camera permission denied or scanner crashes

**Solutions:**
- Grant camera permissions in device settings
- Check `AndroidManifest.xml` and `Info.plist` for permissions
- Restart the app after granting permissions

#### 5. Certificate Download Issues
**Problem:** PDF not downloading or opening

**Solutions:**
- Grant storage permissions (Android)
- Check backend certificate generation
- Verify PDF URL is accessible

### Getting Help

If you encounter issues:

1. Check the error message in the console
2. Review the API response in debug mode
3. Verify backend is functioning correctly
4. Check this documentation
5. Review Flutter documentation: https://flutter.dev/docs

## Backend Requirements

The mobile app requires the following backend endpoints:

### Authentication
- POST `/auth/login` - User login
- POST `/auth/register` - User registration
- GET `/auth/logout` - User logout
- POST `/auth/change-password` - Change password

### Student Endpoints
- GET `/student/dashboard` - Dashboard data
- GET `/student/events` - List events
- POST `/student/register/:event_id` - Register for event
- GET `/student/my-registrations` - Get registrations
- GET `/student/my-certificates` - Get certificates
- GET `/student/download-certificate/:id` - Download certificate
- POST `/student/submit-feedback/:event_id` - Submit feedback

### Organizer Endpoints
- GET `/organizer/dashboard` - Dashboard data
- POST `/organizer/create-event` - Create event
- GET `/organizer/event/:event_id` - Get event details
- POST `/organizer/validate-qr` - Validate QR code

### HOD Endpoints
- GET `/hod/dashboard` - Dashboard data
- POST `/hod/approve-event/:approval_id` - Approve/reject event

### Principal Endpoints
- GET `/principal/dashboard` - Dashboard data
- POST `/principal/approve-event/:approval_id` - Final approval

### Admin Endpoints
- GET `/admin/dashboard` - Dashboard data
- GET `/admin/events` - All events
- GET `/admin/reports` - System reports
- GET `/admin/feedback` - All feedback
- GET `/admin/users` - All users

## Demo Accounts

For testing, use these demo accounts:

| Role | Email | Password |
|------|-------|----------|
| Student | student@example.com | password123 |
| Organizer | organizer@example.com | password123 |
| HOD | hod@example.com | password123 |
| Principal | principal@example.com | password123 |
| Admin | admin@example.com | password123 |

## Security Notes

- Never commit API keys or secrets to version control
- Use environment variables for sensitive data
- Enable ProGuard/R8 for release builds
- Implement certificate pinning for production
- Regularly update dependencies for security patches
- Store tokens securely using `flutter_secure_storage`

## Performance Tips

1. Use `const` constructors where possible
2. Implement lazy loading for large lists
3. Cache API responses when appropriate
4. Optimize images and assets
5. Use `ListView.builder` for long lists
6. Implement pull-to-refresh for data updates

## Contributing

When contributing to the mobile app:

1. Follow Flutter style guide
2. Write meaningful commit messages
3. Add comments for complex logic
4. Update documentation
5. Test on both Android and iOS
6. Ensure no breaking changes to API integration

## Version Information

- **App Version:** 1.0.0
- **Flutter Version:** 3.0.0+
- **Minimum Android SDK:** 21 (Android 5.0)
- **Minimum iOS Version:** 11.0

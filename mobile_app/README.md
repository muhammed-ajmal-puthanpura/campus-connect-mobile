# Campus Connect Mobile App

A Flutter mobile application for the Campus Event Management System.

## 🚀 Quick Start - How to Run

**Fastest way to preview the app (2 minutes):**

```bash
cd mobile_app
flutter pub get
flutter config --enable-web
flutter run -d chrome
```

Login with: `student@example.com` / `password123`

**📖 Need help?** See [HOW_TO_RUN.md](../HOW_TO_RUN.md) for complete step-by-step instructions!

**🎬 Quick Start Scripts:**
- Linux/Mac: `./run_app.sh`
- Windows: `run_app.bat`

---

## Features

### Role-Based Dashboards
- **Student**: View events, register, generate QR tickets, download certificates
- **Organizer**: Create events, scan QR codes, manage registrations
- **HOD**: Approve department events
- **Principal**: Final event approval
- **Admin**: Analytics, reports, and system management

### Core Functionality
- JWT-based authentication
- QR code generation and scanning
- PDF certificate viewing/downloading
- Event registration and management
- Feedback and rating system
- Real-time attendance tracking

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- A running instance of the Campus Connect backend

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Configure API endpoint:
Edit `lib/config/api_config.dart` and set your backend URL:
```dart
static const String baseUrl = 'http://your-backend-url:5000';
```

3. Run the app:
```bash
# Development
flutter run

# Release build
flutter build apk  # Android
flutter build ios  # iOS
```

## Project Structure

```
lib/
├── config/          # Configuration files
├── models/          # Data models
├── providers/       # State management (Provider)
├── screens/         # UI screens
│   ├── auth/       # Login, register, etc.
│   ├── student/    # Student features
│   ├── organizer/  # Organizer features
│   ├── hod/        # HOD features
│   ├── principal/  # Principal features
│   └── admin/      # Admin features
├── services/        # API services
├── utils/           # Utility functions
├── widgets/         # Reusable widgets
└── main.dart       # App entry point
```

## API Integration

The app consumes REST APIs from the Flask backend:
- Authentication: `/auth/login`, `/auth/register`
- Student: `/student/*`
- Organizer: `/organizer/*`
- HOD: `/hod/*`
- Principal: `/principal/*`
- Admin: `/admin/*`

## Technologies Used

- **Framework**: Flutter
- **State Management**: Provider
- **Networking**: HTTP/Dio
- **Local Storage**: Shared Preferences & Secure Storage
- **QR Code**: mobile_scanner, qr_flutter
- **PDF**: pdf, printing packages

## Testing

Run tests:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## License

This project is part of the Campus Event Management System.

# 🎯 Answer: How to Run the App or See the Preview

## Quick Answer

You have **3 easy ways** to run and preview the Campus Connect mobile app:

### 🚀 Method 1: Automated Script (Easiest!)

**Just run this:**

**On Linux/Mac:**
```bash
./run_app.sh
```

**On Windows:**
```bash
run_app.bat
```

The script will guide you through everything! ✨

---

### ⚡ Method 2: Quick Manual (2 Minutes)

**For the fastest preview:**

```bash
cd mobile_app
flutter pub get
flutter config --enable-web
flutter run -d chrome
```

The app will open in your Chrome browser!

**Login with:**
- Email: `student@example.com`
- Password: `password123`

---

### 📖 Method 3: Detailed Guide

For complete step-by-step instructions, see:

- **[HOW_TO_RUN.md](HOW_TO_RUN.md)** - Complete guide (10,000+ words)
- **[mobile_app/QUICK_START.txt](mobile_app/QUICK_START.txt)** - Quick reference card
- **[mobile_app/APP_PREVIEW.md](mobile_app/APP_PREVIEW.md)** - Visual app preview

---

## What You Need

### Prerequisites:
1. **Flutter SDK** installed ([Get Flutter](https://flutter.dev/docs/get-started/install))
2. **Backend running** at `http://localhost:5000`
3. **Chrome browser** (for web preview)

### Quick Check:
```bash
flutter --version
flutter doctor
```

---

## Preview Options

| Option | Setup Time | Pros | Cons |
|--------|-----------|------|------|
| **Chrome Browser** | 2 min | ✅ Fastest, No emulator | ❌ Limited camera |
| **Android Emulator** | 10 min | ✅ Full experience | ❌ Needs more RAM |
| **iOS Simulator** | 5 min | ✅ Native iOS | ❌ macOS only |
| **Physical Device** | 5 min | ✅ All features work | ❌ Needs USB |

**Recommendation:** Start with Chrome browser for quickest preview!

---

## Demo Accounts

Test with these accounts (all use password: `password123`):

| Role | Email | Features |
|------|-------|----------|
| 👨‍🎓 Student | student@example.com | Browse events, register, QR tickets |
| 🎯 Organizer | organizer@example.com | Create events, scan QR codes |
| ✅ HOD | hod@example.com | Approve department events |
| 🏛️ Principal | principal@example.com | Final approvals |
| 👨‍💼 Admin | admin@example.com | Analytics, reports |

---

## Troubleshooting

### "Flutter not found"
**Solution:** Install Flutter from https://flutter.dev

### "No devices found"  
**Solution:** Run `flutter config --enable-web` for Chrome preview

### "Cannot connect to backend"
**Solution:** 
1. Check backend is running: `python app.py`
2. Update API URL in `mobile_app/lib/config/api_config.dart`

### More help?
See the troubleshooting section in [HOW_TO_RUN.md](HOW_TO_RUN.md)

---

## Complete Documentation

All guides are in the repository:

```
📁 Repository
├── 📄 HOW_TO_RUN.md                Complete setup guide
├── 🚀 run_app.sh                   Quick start (Linux/Mac)
├── 🚀 run_app.bat                  Quick start (Windows)
└── 📁 mobile_app/
    ├── 📄 README.md                Quick overview
    ├── 📄 QUICK_START.txt          Visual reference
    ├── 📄 APP_PREVIEW.md           Screen mockups
    ├── 📄 DEVELOPER_GUIDE.md       Detailed guide
    └── 📄 QUICKSTART.md            User guide
```

---

## Summary

**To run the app:**

1. Make sure Flutter is installed
2. Navigate to `mobile_app` directory
3. Run `flutter pub get`
4. Run `flutter run -d chrome`
5. Login with demo account

**Or just run:**
- Linux/Mac: `./run_app.sh`
- Windows: `run_app.bat`

That's it! Your app will be running in 2 minutes! 🎉

---

**Need more help?** Check [HOW_TO_RUN.md](HOW_TO_RUN.md) for the complete guide.

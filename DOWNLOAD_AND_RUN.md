# 🚀 How to Download and Run the Code Locally

## ❓ Why Can't I See the Code in My Repo?

**The mobile app code is on a feature branch, not the main branch!**

The Flutter mobile app was developed on a branch called:
```
copilot/implement-campus-event-management-app
```

You need to **checkout this branch** to see and use the mobile app code.

---

## 📥 Step-by-Step: Download and Run Locally

### Option 1: Clone and Checkout (Fresh Start)

If you haven't cloned the repository yet:

```bash
# 1. Clone the repository
git clone https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile.git

# 2. Navigate to the directory
cd campus-connect-mobile

# 3. Checkout the mobile app branch
git checkout copilot/implement-campus-event-management-app

# 4. Verify you're on the correct branch
git branch
```

You should now see all the mobile app files including the `mobile_app/` directory!

---

### Option 2: Switch Branch (If Already Cloned)

If you already have the repository cloned:

```bash
# 1. Navigate to your repository
cd path/to/campus-connect-mobile

# 2. Fetch the latest changes
git fetch origin

# 3. Checkout the mobile app branch
git checkout copilot/implement-campus-event-management-app

# 4. Pull the latest code
git pull origin copilot/implement-campus-event-management-app

# 5. Verify you're on the correct branch
git branch
```

---

### Option 3: Download as ZIP

Don't want to use Git? Download directly:

1. Go to: https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile
2. Click on the **branch dropdown** (usually says "main")
3. Select `copilot/implement-campus-event-management-app`
4. Click the green **"Code"** button
5. Click **"Download ZIP"**
6. Extract the ZIP file to your desired location

---

## 🏃 Running the Code Locally

Once you have the code, follow these steps:

### Prerequisites

Make sure you have:
- **Flutter SDK 3.0+** ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Git** (for cloning)
- **Python 3.x** (for backend)
- **Chrome browser** (for web preview)

### Quick Start

#### 1. Run the Backend Server

```bash
# In the repository root
python app.py
```

The backend will start on `http://localhost:5000`

#### 2. Run the Mobile App

**Easiest way (Chrome browser):**

```bash
# Navigate to mobile app
cd mobile_app

# Install dependencies
flutter pub get

# Enable web support
flutter config --enable-web

# Run in Chrome
flutter run -d chrome
```

**Or use the automated script:**

```bash
# Linux/Mac
./run_app.sh

# Windows
run_app.bat
```

---

## 📂 What You'll See After Checkout

After checking out the branch, your directory structure will look like:

```
campus-connect-mobile/
├── mobile_app/              ← Flutter mobile app
│   ├── lib/                ← App source code
│   ├── android/            ← Android config
│   ├── ios/                ← iOS config
│   └── pubspec.yaml        ← Dependencies
├── app.py                  ← Flask backend
├── models/                 ← Backend models
├── routes/                 ← Backend routes
├── HOW_TO_RUN.md          ← Running instructions
├── run_app.sh             ← Quick start script (Linux/Mac)
├── run_app.bat            ← Quick start script (Windows)
└── README.md              ← Project overview
```

---

## 🔍 Verify You Have the Right Code

After checkout, verify with these commands:

```bash
# Check current branch
git branch

# Should show: * copilot/implement-campus-event-management-app

# List files
ls -la

# You should see: mobile_app/ directory, run_app.sh, HOW_TO_RUN.md, etc.
```

---

## 🎯 Complete Local Setup Guide

### Step 1: Get the Code

```bash
git clone https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile.git
cd campus-connect-mobile
git checkout copilot/implement-campus-event-management-app
```

### Step 2: Setup Backend

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run backend server
python app.py
```

Keep this terminal open. Backend runs on `http://localhost:5000`

### Step 3: Setup Mobile App

Open a **new terminal** and:

```bash
# Navigate to mobile app
cd mobile_app

# Install Flutter dependencies
flutter pub get

# Configure API (optional - edit lib/config/api_config.dart if needed)

# Run the app
flutter run -d chrome
```

### Step 4: Login and Test

Once the app opens:
- **Email:** `student@example.com`
- **Password:** `password123`

Test with other demo accounts:
- `organizer@example.com` / `password123`
- `hod@example.com` / `password123`
- `principal@example.com` / `password123`
- `admin@example.com` / `password123`

---

## 🛠️ Troubleshooting

### "Branch not found"

```bash
# Fetch all branches
git fetch --all

# List all branches
git branch -a

# Checkout the branch
git checkout copilot/implement-campus-event-management-app
```

### "Flutter not found"

Install Flutter:
1. Visit https://flutter.dev/docs/get-started/install
2. Follow installation for your OS
3. Run `flutter doctor` to verify

### "Cannot connect to backend"

1. Make sure backend is running: `python app.py`
2. Check it's accessible: `curl http://localhost:5000`
3. Update API URL in `mobile_app/lib/config/api_config.dart` if needed

### "No devices found"

For quick preview:
```bash
flutter config --enable-web
flutter run -d chrome
```

---

## 📖 Additional Documentation

Once you have the code, check these files:

| File | Description |
|------|-------------|
| **ANSWER.md** | Quick start guide |
| **HOW_TO_RUN.md** | Complete running instructions |
| **mobile_app/README.md** | Mobile app overview |
| **mobile_app/DEVELOPER_GUIDE.md** | Detailed developer guide |
| **mobile_app/QUICK_START.txt** | Visual quick reference |
| **mobile_app/APP_PREVIEW.md** | Screen mockups and flows |

---

## 🎥 Video Tutorial (If Needed)

### Quick Commands Cheat Sheet

```bash
# Clone and checkout in one go
git clone -b copilot/implement-campus-event-management-app \
  https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile.git

# Or if already cloned
cd campus-connect-mobile
git fetch origin
git checkout copilot/implement-campus-event-management-app
git pull

# Run backend
python app.py

# Run mobile app (in new terminal)
cd mobile_app
flutter pub get
flutter run -d chrome
```

---

## ✅ Success Checklist

After following this guide, you should have:

- [ ] Repository cloned locally
- [ ] On the correct branch (`copilot/implement-campus-event-management-app`)
- [ ] Can see `mobile_app/` directory
- [ ] Backend running on port 5000
- [ ] Mobile app running in Chrome
- [ ] Can login with demo accounts
- [ ] Can browse and test features

---

## 🆘 Still Having Issues?

If you're still having trouble:

1. **Check you're on the right branch:**
   ```bash
   git branch
   # Should show: * copilot/implement-campus-event-management-app
   ```

2. **Verify Flutter installation:**
   ```bash
   flutter doctor
   ```

3. **Check backend is running:**
   ```bash
   curl http://localhost:5000
   ```

4. **Review detailed guides:**
   - Read `HOW_TO_RUN.md` in the repository
   - Check `mobile_app/DEVELOPER_GUIDE.md`

---

## 🎉 Summary

**Why you can't see the code:**
- Code is on a feature branch, not main branch
- Branch name: `copilot/implement-campus-event-management-app`

**How to download:**
```bash
git clone https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile.git
cd campus-connect-mobile
git checkout copilot/implement-campus-event-management-app
```

**How to run locally:**
```bash
# Terminal 1: Backend
python app.py

# Terminal 2: Mobile App
cd mobile_app
flutter pub get
flutter run -d chrome
```

**Login:**
- Email: `student@example.com`
- Password: `password123`

That's it! You should now have the code running locally! 🚀

# 🎯 Quick Answer: Why Can't I See the Code?

## The Problem

**The mobile app code is on a different branch!**

You're probably looking at the `main` branch, but the Flutter mobile app code is on:
```
copilot/implement-campus-event-management-app
```

## The Solution (3 Steps)

### Step 1: Clone the Repository
```bash
git clone https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile.git
cd campus-connect-mobile
```

### Step 2: Checkout the Feature Branch
```bash
git checkout copilot/implement-campus-event-management-app
```

### Step 3: Verify You See the Mobile App
```bash
ls -la
# You should now see: mobile_app/ directory, run_app.sh, HOW_TO_RUN.md, etc.
```

## Run the Code Locally

Once you've checked out the branch:

### Backend (Terminal 1)
```bash
python app.py
```

### Mobile App (Terminal 2)
```bash
cd mobile_app
flutter pub get
flutter run -d chrome
```

### Login
- Email: `student@example.com`
- Password: `password123`

## Already Have the Repo Cloned?

Just switch to the branch:
```bash
cd campus-connect-mobile
git fetch origin
git checkout copilot/implement-campus-event-management-app
git pull
```

## Don't Want to Use Git?

Download ZIP directly:
1. Go to https://github.com/muhammed-ajmal-puthanpura/campus-connect-mobile
2. Click the **branch dropdown** (says "main")
3. Select `copilot/implement-campus-event-management-app`
4. Click green **"Code"** → **"Download ZIP"**

## Need More Help?

See these detailed guides:
- **DOWNLOAD_AND_RUN.md** - Complete download & setup guide
- **WHY_CANT_SEE_CODE.txt** - Visual explanation
- **HOW_TO_RUN.md** - Running instructions

---

**TL;DR:** The code is on a feature branch. Run `git checkout copilot/implement-campus-event-management-app` to see it!

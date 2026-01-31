# 📱 Campus Connect Mobile App - LIVE PREVIEW & DEMO

## 🎬 App Preview & Walkthrough

This document provides a comprehensive visual preview of the Campus Connect Mobile App and Backend system.

---

## 🖥️ System Overview

The Campus Connect system consists of:

1. **Flask Backend** - Web-based admin/management interface
2. **Flutter Mobile App** - Native mobile application for iOS/Android/Web
3. **REST API** - Connects mobile app to backend

---

## 📸 Backend Web Interface Preview

### Login Screen
```
┌────────────────────────────────────────────────────────┐
│                  Campus Connect                        │
│              Event Management System                   │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  👤 Email/Username                           │    │
│  │  ______________________________________      │    │
│  │                                              │    │
│  │  🔒 Password                                 │    │
│  │  ______________________________________      │    │
│  │                                              │    │
│  │  ☐ Remember Me                              │    │
│  │                                              │    │
│  │  ┌────────────────┐                         │    │
│  │  │     Login      │                         │    │
│  │  └────────────────┘                         │    │
│  │                                              │    │
│  │  Forgot Password?  |  Register              │    │
│  └──────────────────────────────────────────────┘    │
│                                                        │
│  Demo Accounts:                                        │
│  • admin@example.com / password123 (Admin)            │
│  • student@example.com / password123 (Student)        │
│  • hod@example.com / password123 (HOD)               │
└────────────────────────────────────────────────────────┘
```

### Student Dashboard (Web)
```
┌────────────────────────────────────────────────────────┐
│  Campus Connect  |  Student Dashboard    👤 John  ↓    │
├────────────────────────────────────────────────────────┤
│                                                        │
│  📅 Upcoming Events                                    │
│  ┌────────────────────────────────────────────┐      │
│  │ Tech Workshop 2026                         │      │
│  │ 📍 Main Hall  |  🕐 Feb 15, 10:00 AM       │      │
│  │ [Register] [View Details]                  │      │
│  └────────────────────────────────────────────┘      │
│                                                        │
│  ┌────────────────────────────────────────────┐      │
│  │ AI Seminar                                 │      │
│  │ 💻 Online  |  🕐 Feb 20, 2:00 PM           │      │
│  │ [Register] [View Details]                  │      │
│  └────────────────────────────────────────────┘      │
│                                                        │
│  Quick Links:                                          │
│  [My Registrations] [My Certificates] [Profile]       │
└────────────────────────────────────────────────────────┘
```

### Admin Dashboard (Web)
```
┌────────────────────────────────────────────────────────┐
│  Campus Connect  |  Admin Dashboard     👤 Admin  ↓    │
├────────────────────────────────────────────────────────┤
│                                                        │
│  📊 System Statistics                                  │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │Events  │  │Students│  │Pending │  │Active  │     │
│  │  125   │  │  450   │  │   8    │  │   15   │     │
│  └────────┘  └────────┘  └────────┘  └────────┘     │
│                                                        │
│  Recent Activities:                                    │
│  • New event created: "Tech Workshop"                 │
│  • Event approved: "AI Seminar"                       │
│  • 25 new registrations today                         │
│                                                        │
│  Quick Actions:                                        │
│  [Manage Events] [View Reports] [User Management]     │
└────────────────────────────────────────────────────────┘
```

---

## 📱 Mobile App Preview

### Splash Screen
```
┌─────────────────────────┐
│                         │
│                         │
│         🎓              │
│    Campus Connect       │
│                         │
│    Event Management     │
│                         │
│      Loading...         │
│        ⚪⚪⚪           │
│                         │
└─────────────────────────┘
```

### Login Screen (Mobile)
```
┌─────────────────────────┐
│    Campus Connect   ⚙️  │
├─────────────────────────┤
│                         │
│         🎓              │
│    Campus Connect       │
│                         │
│  ┌───────────────────┐  │
│  │ 📧 Email          │  │
│  │ _________________│  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │ 🔒 Password       │  │
│  │ _________________│  │
│  └───────────────────┘  │
│                         │
│  ☑ Remember Me         │
│                         │
│  ┌───────────────────┐  │
│  │      Login        │  │
│  └───────────────────┘  │
│                         │
│  Forgot Password?       │
│                         │
│  ─── Demo Accounts ───  │
│  📧 student@example.com │
│  🔑 password123         │
└─────────────────────────┘
```

### Student Dashboard (Mobile)
```
┌─────────────────────────┐
│  🎓 Dashboard      ⚙️ 🚪│
├─────────────────────────┤
│                         │
│  👋 Welcome, John       │
│                         │
│  Quick Actions          │
│  ┌────────┐ ┌────────┐ │
│  │ 📅     │ │ 🎫     │ │
│  │Browse  │ │  My    │ │
│  │Events  │ │Tickets │ │
│  └────────┘ └────────┘ │
│  ┌────────┐ ┌────────┐ │
│  │ 📜     │ │ 👤     │ │
│  │Certif. │ │Profile │ │
│  └────────┘ └────────┘ │
│                         │
│  📅 Upcoming Events     │
│  ┌───────────────────┐ │
│  │Tech Workshop 2026 │ │
│  │📍 Main Hall       │ │
│  │🕐 Feb 15, 10:00 AM│ │
│  │[Register Now]     │ │
│  └───────────────────┘ │
│  ┌───────────────────┐ │
│  │AI Seminar         │ │
│  │💻 Online          │ │
│  │🕐 Feb 20, 2:00 PM │ │
│  │[Register Now]     │ │
│  └───────────────────┘ │
└─────────────────────────┘
```

### Event Details Screen
```
┌─────────────────────────┐
│  ← Event Details    ⋮   │
├─────────────────────────┤
│                         │
│  Tech Workshop 2026     │
│                         │
│  📖 Description:        │
│  Learn latest web tech  │
│  and frameworks. Hands- │
│  on workshop with       │
│  industry experts.      │
│                         │
│  📍 Venue: Main Hall    │
│  📅 Date: Feb 15, 2026  │
│  🕐 Time: 10:00 AM      │
│  👥 Organizer: Tech Club│
│  📊 Capacity: 50/100    │
│                         │
│  ┌───────────────────┐ │
│  │  ✅ Register Now  │ │
│  └───────────────────┘ │
│                         │
│  ℹ️ About Organizer    │
│  Tech Club - Leading   │
│  technology community   │
└─────────────────────────┘
```

### QR Ticket Screen
```
┌─────────────────────────┐
│  ← Your Ticket      ⋮   │
├─────────────────────────┤
│                         │
│  Tech Workshop 2026     │
│  📅 Feb 15, 10:00 AM    │
│                         │
│  ┌───────────────────┐ │
│  │ ▄▄▄▄▄ ▄ ▄ ▄▄▄▄▄  │ │
│  │ █   █ ▄▄▄ █   █  │ │
│  │ █ ▀ █ ███ █ ▀ █  │ │
│  │ █▀▀▀█ ▄ ▄ █▀▀▀█  │ │
│  │ ▀▀▀▀▀ ▀▀▀ ▀▀▀▀▀  │ │
│  │   QR CODE HERE    │ │
│  │                   │ │
│  │ REG123456789      │ │
│  └───────────────────┘ │
│                         │
│  Show this at venue     │
│  for attendance marking │
│                         │
│  ℹ️ Ticket Info         │
│  Status: Confirmed      │
│  Registered: Jan 30     │
│                         │
│  [Share] [Download]     │
└─────────────────────────┘
```

### Organizer Dashboard
```
┌─────────────────────────┐
│  🎯 Organizer      ⚙️ 🚪│
├─────────────────────────┤
│                         │
│  👋 Welcome, Sarah      │
│                         │
│  Quick Actions          │
│  ┌────────┐ ┌────────┐ │
│  │ ➕     │ │ 📷     │ │
│  │Create  │ │ Scan   │ │
│  │Event   │ │QR Code │ │
│  └────────┘ └────────┘ │
│                         │
│  📊 Statistics          │
│  • Pending: 2 events    │
│  • Approved: 5 events   │
│  • Total Reg: 145       │
│                         │
│  📅 My Events           │
│  ┌───────────────────┐ │
│  │Tech Workshop 2026 │ │
│  │✅ Approved        │ │
│  │📊 Reg: 45/50      │ │
│  │[View] [Edit]      │ │
│  └───────────────────┘ │
│  ┌───────────────────┐ │
│  │AI Seminar         │ │
│  │⏳ Pending HOD     │ │
│  │[View Details]     │ │
│  └───────────────────┘ │
└─────────────────────────┘
```

### QR Scanner (Organizer)
```
┌─────────────────────────┐
│  ← Scan QR Code     ⚡   │
├─────────────────────────┤
│                         │
│  ┌───────────────────┐ │
│  │                   │ │
│  │   ┌─────────┐     │ │
│  │   │         │     │ │
│  │   │  CAMERA │     │ │
│  │   │  VIEW   │     │ │
│  │   │         │     │ │
│  │   └─────────┘     │ │
│  │                   │ │
│  │ Position QR code  │ │
│  │ within frame      │ │
│  └───────────────────┘ │
│                         │
│  ℹ️ Instructions        │
│  • Center the QR code  │
│  • Hold steady         │
│  • Wait for beep       │
│                         │
│  💡 Scanning for:      │
│  Tech Workshop 2026     │
│                         │
│  📊 Today's Scans: 23  │
└─────────────────────────┘
```

### HOD Dashboard
```
┌─────────────────────────┐
│  ✅ HOD Dashboard  ⚙️ 🚪│
├─────────────────────────┤
│                         │
│  Pending Approvals (3)  │
│                         │
│  ┌───────────────────┐ │
│  │Tech Workshop 2026 │ │
│  │📍 Main Hall       │ │
│  │👤 Tech Club       │ │
│  │                   │ │
│  │ ┌──────┐ ┌──────┐│ │
│  │ │Approve│ │Reject││ │
│  │ └──────┘ └──────┘│ │
│  └───────────────────┘ │
│                         │
│  ┌───────────────────┐ │
│  │AI Seminar         │ │
│  │💻 Online          │ │
│  │👤 AI Society      │ │
│  │                   │ │
│  │ ┌──────┐ ┌──────┐│ │
│  │ │Approve│ │Reject││ │
│  │ └──────┘ └──────┘│ │
│  └───────────────────┘ │
│                         │
│  Recent Activity:       │
│  • 5 events approved    │
│  • 1 event rejected     │
└─────────────────────────┘
```

### Admin Analytics
```
┌─────────────────────────┐
│  👨‍💼 Admin        ⚙️ 🚪│
├─────────────────────────┤
│                         │
│  📊 System Overview     │
│                         │
│  ┌─────┐ ┌─────┐       │
│  │Total│ │Users│       │
│  │ 125 │ │ 450 │       │
│  │Events│ │     │       │
│  └─────┘ └─────┘       │
│  ┌─────┐ ┌─────┐       │
│  │Pend.│ │Active│      │
│  │  8  │ │  15  │      │
│  └─────┘ └─────┘       │
│                         │
│  📈 This Month          │
│  • Events: +15          │
│  • Users: +45           │
│  • Registrations: +234  │
│                         │
│  Quick Actions:         │
│  • 📅 View All Events   │
│  • 📊 Generate Report   │
│  • 💬 View Feedback     │
│  • 👥 Manage Users      │
└─────────────────────────┘
```

---

## 🎯 Key Features Demonstrated

### 1. Authentication System
- JWT-based secure login
- Role-based access control
- Auto-login with stored tokens
- Multiple user roles (Student, Organizer, HOD, Principal, Admin)

### 2. Student Features
- Browse approved events
- Filter by mode (online/offline)
- One-click registration
- QR ticket generation
- Certificate viewing
- Feedback submission

### 3. Organizer Features
- Create events with venue selection
- Online/offline event modes
- Track approval status
- QR code scanning
- Attendance marking
- Registration management

### 4. Approval Workflow
- HOD approval for department events
- Principal final approval
- Remarks and feedback system
- Status tracking

### 5. Admin Capabilities
- System-wide analytics
- Event management
- User management
- Report generation
- Feedback review

---

## 🔐 Demo Accounts

Test the system with these credentials:

| Role | Email | Password | Features |
|------|-------|----------|----------|
| Student | student@example.com | password123 | Browse, Register, QR Tickets |
| Organizer | organizer@example.com | password123 | Create Events, Scan QR |
| HOD | hod@example.com | password123 | Approve Department Events |
| Principal | principal@example.com | password123 | Final Approval |
| Admin | admin@example.com | password123 | Full System Access |

---

## 🚀 How to Access the Running App

### Backend (Web Interface)
```bash
# Start backend server
python app.py

# Access at:
http://localhost:5000
```

### Mobile App (Flutter)
```bash
# Navigate to mobile app
cd mobile_app

# Install dependencies
flutter pub get

# Run on Chrome (fastest)
flutter run -d chrome

# Or use quick start script
../run_app.sh  # Linux/Mac
../run_app.bat # Windows
```

---

## 📊 System Architecture

```
┌─────────────────────────────────────────────┐
│           Users / Devices                   │
│  (Web Browsers, iOS, Android, Desktop)      │
└──────────────┬──────────────────────────────┘
               │
┌──────────────┴──────────────┐
│     Flutter Mobile App      │
│   (Material Design UI)      │
└──────────────┬──────────────┘
               │ REST API
               │ (JSON)
┌──────────────┴──────────────┐
│     Flask Backend Server    │
│   (Python 3.x + SQLAlchemy) │
└──────────────┬──────────────┘
               │
┌──────────────┴──────────────┐
│      MySQL Database         │
│   (Events, Users, Tickets)  │
└─────────────────────────────┘
```

---

## 🎨 Technology Stack

**Mobile App:**
- Flutter 3.0+
- Dart 3.0+
- Provider (State Management)
- HTTP (API Calls)
- QR Flutter (QR Generation)
- Mobile Scanner (QR Scanning)

**Backend:**
- Python Flask 3.0
- SQLAlchemy ORM
- MySQL Database
- JWT Authentication
- QR Code Generation
- PDF Certificate Generation

---

## 📱 Platform Support

✅ **Web** - Runs in Chrome, Safari, Firefox
✅ **Android** - Android 5.0+ (API 21+)
✅ **iOS** - iOS 11.0+
✅ **Desktop** - Windows, macOS, Linux (via Flutter)

---

## 🎥 Video Walkthrough (Text Description)

### Student Journey:
1. Open app → See splash screen
2. Login with student credentials
3. Browse upcoming events
4. Click event → View details
5. Register → Receive QR ticket
6. Save ticket to phone
7. Attend event → Show QR code
8. After event → Download certificate
9. Submit feedback with rating

### Organizer Journey:
1. Login as organizer
2. Create new event
3. Fill event details (venue, date, time)
4. Submit for approval
5. Track approval status
6. Event approved → View registrations
7. Event day → Scan student QR codes
8. Mark attendance in real-time
9. View attendance reports

### Admin Journey:
1. Login as admin
2. View system dashboard
3. See statistics (events, users, registrations)
4. Filter events by department/organizer
5. View participation analytics
6. Review feedback and ratings
7. Generate progress reports
8. Manage users and permissions

---

## 💡 Interactive Elements

**Clickable Elements:**
- All buttons respond with visual feedback
- Cards expand on tap
- Pull-to-refresh on lists
- Swipe gestures for navigation
- Long-press for contextual menus

**Real-time Updates:**
- Live event countdown
- Registration count updates
- Approval status changes
- Notification badges

**Animations:**
- Smooth page transitions
- Card elevation on hover
- Loading spinners
- Success/error animations

---

## 📈 Sample Data Preview

### Events
- Tech Workshop 2026 (Main Hall, Feb 15)
- AI Seminar (Online, Feb 20)
- Career Fair (Campus Ground, Mar 1)
- Hackathon 2026 (Lab Building, Mar 10)

### Statistics
- Total Events: 125
- Active Users: 450
- Pending Approvals: 8
- Total Registrations: 1,234
- Certificates Issued: 856

---

## 🎉 What Makes This Special

✨ **Complete Solution**
- Full backend + mobile app
- Production-ready code
- Comprehensive documentation

✨ **Modern Tech Stack**
- Flutter for beautiful UI
- Flask for robust backend
- Clean architecture

✨ **Real-World Features**
- QR code system
- Certificate generation
- Analytics dashboard
- Multi-role support

✨ **Developer Friendly**
- Well-commented code
- Clean structure
- Easy to extend
- Detailed guides

---

## 📚 More Information

For detailed setup and usage instructions, see:
- **HOW_TO_RUN.md** - Complete running guide
- **DEVELOPER_GUIDE.md** - Developer documentation
- **QUICKSTART.md** - End-user guide
- **API_DOCUMENTATION.md** - API reference

---

## ✅ Summary

This preview demonstrates:
- ✅ Complete Flutter mobile app with Material Design
- ✅ Flask backend with web interface
- ✅ Role-based dashboards for all user types
- ✅ QR code generation and scanning
- ✅ Event management workflow
- ✅ Approval system (HOD → Principal)
- ✅ Analytics and reporting
- ✅ Certificate generation
- ✅ Feedback system

**The app is fully functional and ready to run!** 🚀

Use the demo accounts above to test all features.

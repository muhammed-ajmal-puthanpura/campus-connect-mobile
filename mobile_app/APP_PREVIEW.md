# 📱 Campus Connect Mobile App - Visual Guide

## 🎬 App Preview & Flow

### Login Screen
```
┌─────────────────────────────────────┐
│                                     │
│         🎓 Campus Connect           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  📧 Email                   │   │
│  │  student@example.com        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🔒 Password                │   │
│  │  ••••••••••••               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ☑ Remember Me                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         Login               │   │
│  └─────────────────────────────┘   │
│                                     │
│  Demo Accounts Available:           │
│  • student@example.com              │
│  • organizer@example.com            │
│  • hod@example.com                  │
│  • principal@example.com            │
│  • admin@example.com                │
│  Password: password123              │
└─────────────────────────────────────┘
```

### Student Dashboard
```
┌─────────────────────────────────────┐
│  🎓 Student Dashboard          ⚙️ 🚪 │
├─────────────────────────────────────┤
│                                     │
│  👤 Welcome, John Student           │
│                                     │
│  Quick Actions:                     │
│  ┌──────────┐ ┌──────────┐         │
│  │ 📅 Browse│ │ 🎫 My    │         │
│  │  Events  │ │  Tickets │         │
│  └──────────┘ └──────────┘         │
│  ┌──────────┐ ┌──────────┐         │
│  │ 📜 Cert. │ │ 👤 Profile│        │
│  └──────────┘ └──────────┘         │
│                                     │
│  📅 Upcoming Events:                │
│  ┌─────────────────────────────┐   │
│  │ Tech Workshop 2026          │   │
│  │ 📍 Main Hall | 🕐 10:00 AM  │   │
│  │ [Register Now]              │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ AI Seminar                  │   │
│  │ 💻 Online | 🕐 2:00 PM      │   │
│  │ [Register Now]              │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Event Registration & QR Ticket
```
┌─────────────────────────────────────┐
│  📅 Tech Workshop 2026         ← 🚪 │
├─────────────────────────────────────┤
│                                     │
│  📖 Description:                    │
│  Learn latest web technologies      │
│  and frameworks...                  │
│                                     │
│  📍 Venue: Main Hall                │
│  📅 Date: Feb 15, 2026              │
│  🕐 Time: 10:00 AM - 4:00 PM        │
│  👥 Organizer: Tech Club            │
│                                     │
│  ┌─────────────────────────────┐   │
│  │    ✅ Register Now          │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘

After Registration:

┌─────────────────────────────────────┐
│  🎫 Your QR Ticket             ← 🚪 │
├─────────────────────────────────────┤
│                                     │
│  Tech Workshop 2026                 │
│  📅 Feb 15, 2026 | 🕐 10:00 AM      │
│                                     │
│  ┌─────────────────────────────┐   │
│  │     ▄▄▄▄▄▄▄  ▄▄▄  ▄▄▄▄▄▄▄  │   │
│  │     █     █  ███  █     █  │   │
│  │     █ ▀▀▀ █  ▄ ▄  █ ▀▀▀ █  │   │
│  │     █▀▀▀▀▀█  ▄█▄  █▀▀▀▀▀█  │   │
│  │     ▀ ▀ ▀ ▀  ▀ ▀  ▀ ▀ ▀ ▀  │   │
│  │        QR CODE HERE         │   │
│  └─────────────────────────────┘   │
│                                     │
│  Show this at the event for         │
│  attendance marking                 │
└─────────────────────────────────────┘
```

### Organizer Dashboard
```
┌─────────────────────────────────────┐
│  🎯 Organizer Dashboard        ⚙️ 🚪 │
├─────────────────────────────────────┤
│                                     │
│  👋 Welcome, Sarah Organizer        │
│                                     │
│  Quick Actions:                     │
│  ┌──────────┐ ┌──────────┐         │
│  │ ➕ Create│ │ 📷 Scan  │         │
│  │  Event   │ │  QR Code │         │
│  └──────────┘ └──────────┘         │
│                                     │
│  📊 Statistics:                     │
│  • Pending: 2 events                │
│  • Approved: 5 events               │
│  • Rejected: 1 event                │
│                                     │
│  📅 My Events:                      │
│  ┌─────────────────────────────┐   │
│  │ Tech Workshop 2026          │   │
│  │ Status: ✅ Approved         │   │
│  │ Registrations: 45/50        │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### HOD/Principal Approval Screen
```
┌─────────────────────────────────────┐
│  ✅ HOD Dashboard              ⚙️ 🚪 │
├─────────────────────────────────────┤
│                                     │
│  Pending Approvals (3):             │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Tech Workshop 2026          │   │
│  │ 📍 Main Hall | CS Dept      │   │
│  │ Organizer: Tech Club        │   │
│  │                             │   │
│  │ [Approve] [Reject]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ AI Seminar                  │   │
│  │ 💻 Online | CS Dept         │   │
│  │ Organizer: AI Society       │   │
│  │                             │   │
│  │ [Approve] [Reject]          │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Admin Dashboard
```
┌─────────────────────────────────────┐
│  👨‍💼 Admin Dashboard          ⚙️ 🚪 │
├─────────────────────────────────────┤
│                                     │
│  📊 System Overview:                │
│                                     │
│  ┌─────────┐ ┌─────────┐           │
│  │ Events  │ │Students │           │
│  │   125   │ │   450   │           │
│  └─────────┘ └─────────┘           │
│  ┌─────────┐ ┌─────────┐           │
│  │Organizers│ │Pending │           │
│  │   25    │ │   8     │           │
│  └─────────┘ └─────────┘           │
│                                     │
│  Quick Actions:                     │
│  • 📅 View All Events               │
│  • 📊 View Reports                  │
│  • 💬 View Feedback                 │
│  • 👥 Manage Users                  │
└─────────────────────────────────────┘
```

## 🎯 User Flow by Role

### Student Flow
```
Login → Dashboard → Browse Events → Register → Get QR Ticket
                                              ↓
      Certificate ← Attendance ← Show QR at Event
                       ↓
                  Submit Feedback
```

### Organizer Flow
```
Login → Dashboard → Create Event → Submit for Approval
                                          ↓
                                    Track Status
                                          ↓
                         Scan Student QR Codes ← Event Day
                                          ↓
                                  Mark Attendance
```

### HOD/Principal Flow
```
Login → Dashboard → View Pending Requests → Approve/Reject
                                                  ↓
                                           Add Remarks
```

### Admin Flow
```
Login → Dashboard → View Analytics → Generate Reports
                  ↓               ↓
           Review Feedback    Manage Users
```

## 🎨 Color Scheme

```
Primary:   🔵 #2563EB (Blue)
Accent:    🟠 #F59E0B (Orange)
Success:   🟢 #10B981 (Green)
Error:     🔴 #EF4444 (Red)
Warning:   🟡 #F59E0B (Orange)
```

## 📱 Responsive Design

The app works on:
- 📱 Small phones (< 6 inches)
- 📱 Large phones (6+ inches)
- 📱 Tablets (7-10 inches)
- 💻 Web browsers (Chrome, Safari, Firefox)

## 🔄 State Flow

```
App Start
   ↓
Check Token → Valid? → Dashboard (Role-based)
               ↓
              No
               ↓
         Login Screen
               ↓
         Enter Credentials
               ↓
         Authenticate → Success → Store Token → Dashboard
               ↓
              Fail
               ↓
         Show Error
```

## 📡 API Integration

```
Mobile App → HTTP Request → Flask Backend
                               ↓
                          Process Request
                               ↓
                         Database Query
                               ↓
                          Format Response
                               ↓
Mobile App ← JSON Response ← Flask Backend
     ↓
Update UI
```

## 🔒 Security Features

- 🔐 JWT Token Authentication
- 💾 Secure Token Storage (flutter_secure_storage)
- 🔑 Password Hashing (handled by backend)
- ✅ Permission-based Access Control
- 🚫 Automatic Logout on Token Expiry

## 🎯 Key Features Highlighted

### QR Code System
```
Student Registers → QR Generated → Stored Securely
                                       ↓
                               Student Shows QR
                                       ↓
                            Organizer Scans QR
                                       ↓
                              Validates & Marks
                                       ↓
                          Attendance Recorded
                                       ↓
                        Certificate Auto-Generated
```

### Approval Workflow
```
Organizer Creates Event
         ↓
    HOD Reviews (Department Venue)
         ↓
   Principal Reviews (Final)
         ↓
      Approved
         ↓
  Visible to Students
```

## 💡 Tips for Best Experience

1. **Use Chrome for quick preview** - Fastest way to test
2. **Test on real device** - For full QR/camera features
3. **Keep backend running** - App needs API connection
4. **Use demo accounts** - Pre-configured for testing
5. **Check console logs** - For debugging API issues

## 🎓 Learning Resources

- Flutter Docs: https://flutter.dev/docs
- Material Design: https://material.io
- Provider Package: https://pub.dev/packages/provider
- QR Code: https://pub.dev/packages/qr_flutter

---

**Ready to run?** Check [HOW_TO_RUN.md](../HOW_TO_RUN.md) for detailed instructions!

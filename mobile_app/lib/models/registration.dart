/// Registration Model
/// Represents a student's registration for an event
class Registration {
  final int registrationId;
  final int eventId;
  final String? eventTitle;
  final DateTime? eventDate;
  final String? eventStartTime;
  final String? eventEndTime;
  final String? venueName;
  final int studentId;
  final String? studentName;
  final String qrCode;
  final String? qrCodeImage; // Base64 image
  final DateTime registeredAt;
  final bool hasAttended;
  final DateTime? attendanceTime;

  Registration({
    required this.registrationId,
    required this.eventId,
    this.eventTitle,
    this.eventDate,
    this.eventStartTime,
    this.eventEndTime,
    this.venueName,
    required this.studentId,
    this.studentName,
    required this.qrCode,
    this.qrCodeImage,
    required this.registeredAt,
    this.hasAttended = false,
    this.attendanceTime,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      registrationId: json['registration_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      eventTitle: json['event_title'] ?? json['title'],
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : (json['date'] != null ? DateTime.parse(json['date']) : null),
      eventStartTime: json['event_start_time'] ?? json['start_time'],
      eventEndTime: json['event_end_time'] ?? json['end_time'],
      venueName: json['venue_name'],
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'],
      qrCode: json['qr_code'] ?? '',
      qrCodeImage: json['qr_code_image'],
      registeredAt: json['registered_at'] != null
          ? DateTime.parse(json['registered_at'])
          : DateTime.now(),
      hasAttended: json['has_attended'] ?? json['attended'] ?? false,
      attendanceTime: json['attendance_time'] != null
          ? DateTime.parse(json['attendance_time'])
          : (json['scan_time'] != null ? DateTime.parse(json['scan_time']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_id': registrationId,
      'event_id': eventId,
      'event_title': eventTitle,
      'event_date': eventDate?.toIso8601String().split('T')[0],
      'event_start_time': eventStartTime,
      'event_end_time': eventEndTime,
      'venue_name': venueName,
      'student_id': studentId,
      'student_name': studentName,
      'qr_code': qrCode,
      'qr_code_image': qrCodeImage,
      'registered_at': registeredAt.toIso8601String(),
      'has_attended': hasAttended,
      'attendance_time': attendanceTime?.toIso8601String(),
    };
  }
}

/// Attendance Model
class Attendance {
  final int attendanceId;
  final int registrationId;
  final DateTime scanTime;
  final int scannedBy;
  final String? scannerName;
  final String status;

  Attendance({
    required this.attendanceId,
    required this.registrationId,
    required this.scanTime,
    required this.scannedBy,
    this.scannerName,
    this.status = 'present',
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendanceId: json['attendance_id'] ?? 0,
      registrationId: json['registration_id'] ?? 0,
      scanTime: DateTime.parse(json['scan_time'] ?? DateTime.now().toString()),
      scannedBy: json['scanned_by'] ?? 0,
      scannerName: json['scanner_name'],
      status: json['status'] ?? 'present',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'registration_id': registrationId,
      'scan_time': scanTime.toIso8601String(),
      'scanned_by': scannedBy,
      'scanner_name': scannerName,
      'status': status,
    };
  }
}

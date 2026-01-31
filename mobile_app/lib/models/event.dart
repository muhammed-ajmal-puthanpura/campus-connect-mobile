/// Event Model
/// Represents an event in the system
class Event {
  final int eventId;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int? venueId;
  final String? venueName;
  final int? venueCapacity;
  final int deptId;
  final String? deptName;
  final String mode; // 'online' or 'offline'
  final String? meetingUrl;
  final String? posterUrl;
  final int organizerId;
  final String? organizerName;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime? createdAt;
  final int? registrationCount;
  final int? attendanceCount;

  Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.venueId,
    this.venueName,
    this.venueCapacity,
    required this.deptId,
    this.deptName,
    this.mode = 'offline',
    this.meetingUrl,
    this.posterUrl,
    required this.organizerId,
    this.organizerName,
    required this.status,
    this.createdAt,
    this.registrationCount,
    this.attendanceCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? json['event_date'] ?? DateTime.now().toString()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      venueId: json['venue_id'],
      venueName: json['venue_name'],
      venueCapacity: json['venue_capacity'],
      deptId: json['dept_id'] ?? 0,
      deptName: json['dept_name'],
      mode: json['mode'] ?? 'offline',
      meetingUrl: json['meeting_url'],
      posterUrl: json['poster_url'],
      organizerId: json['organizer_id'] ?? 0,
      organizerName: json['organizer_name'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      registrationCount: json['registration_count'] ?? json['registrations_count'],
      attendanceCount: json['attendance_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'venue_id': venueId,
      'venue_name': venueName,
      'venue_capacity': venueCapacity,
      'dept_id': deptId,
      'dept_name': deptName,
      'mode': mode,
      'meeting_url': meetingUrl,
      'poster_url': posterUrl,
      'organizer_id': organizerId,
      'organizer_name': organizerName,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'registration_count': registrationCount,
      'attendance_count': attendanceCount,
    };
  }

  bool get isPast {
    return date.isBefore(DateTime.now());
  }

  bool get isUpcoming {
    return date.isAfter(DateTime.now()) || date.isAtSameMomentAs(DateTime.now());
  }
}

/// Venue Model
class Venue {
  final int venueId;
  final String venueName;
  final int? deptId;
  final String? deptName;
  final int capacity;

  Venue({
    required this.venueId,
    required this.venueName,
    this.deptId,
    this.deptName,
    required this.capacity,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueId: json['venue_id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      deptId: json['dept_id'],
      deptName: json['dept_name'],
      capacity: json['capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venue_id': venueId,
      'venue_name': venueName,
      'dept_id': deptId,
      'dept_name': deptName,
      'capacity': capacity,
    };
  }
}

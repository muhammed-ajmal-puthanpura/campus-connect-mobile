/// Certificate Model
/// Represents a certificate issued to a student for attending an event
class Certificate {
  final int certificateId;
  final int studentId;
  final String? studentName;
  final int eventId;
  final String? eventTitle;
  final String certificateUrl;
  final DateTime issuedAt;

  Certificate({
    required this.certificateId,
    required this.studentId,
    this.studentName,
    required this.eventId,
    this.eventTitle,
    required this.certificateUrl,
    required this.issuedAt,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      certificateId: json['certificate_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'],
      eventId: json['event_id'] ?? 0,
      eventTitle: json['event_title'] ?? json['title'],
      certificateUrl: json['certificate_url'] ?? '',
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificate_id': certificateId,
      'student_id': studentId,
      'student_name': studentName,
      'event_id': eventId,
      'event_title': eventTitle,
      'certificate_url': certificateUrl,
      'issued_at': issuedAt.toIso8601String(),
    };
  }
}

/// Feedback Model
/// Represents student feedback for an event
class Feedback {
  final int feedbackId;
  final int eventId;
  final String? eventTitle;
  final int studentId;
  final String? studentName;
  final int rating; // 1-5
  final String? comments;
  final DateTime submittedAt;

  Feedback({
    required this.feedbackId,
    required this.eventId,
    this.eventTitle,
    required this.studentId,
    this.studentName,
    required this.rating,
    this.comments,
    required this.submittedAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      feedbackId: json['feedback_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      eventTitle: json['event_title'] ?? json['title'],
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'],
      rating: json['rating'] ?? 0,
      comments: json['comments'],
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'event_id': eventId,
      'event_title': eventTitle,
      'student_id': studentId,
      'student_name': studentName,
      'rating': rating,
      'comments': comments,
      'submitted_at': submittedAt.toIso8601String(),
    };
  }
}

/// Approval Model
/// Represents an approval step in the event approval workflow
class Approval {
  final int approvalId;
  final int eventId;
  final String? eventTitle;
  final int approverId;
  final String? approverName;
  final String approverRole; // 'HOD', 'Principal'
  final String status; // 'pending', 'approved', 'rejected'
  final String? remarks;
  final DateTime? approvedAt;

  Approval({
    required this.approvalId,
    required this.eventId,
    this.eventTitle,
    required this.approverId,
    this.approverName,
    required this.approverRole,
    required this.status,
    this.remarks,
    this.approvedAt,
  });

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      approvalId: json['approval_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      eventTitle: json['event_title'] ?? json['title'],
      approverId: json['approver_id'] ?? 0,
      approverName: json['approver_name'],
      approverRole: json['approver_role'] ?? '',
      status: json['status'] ?? 'pending',
      remarks: json['remarks'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approval_id': approvalId,
      'event_id': eventId,
      'event_title': eventTitle,
      'approver_id': approverId,
      'approver_name': approverName,
      'approver_role': approverRole,
      'status': status,
      'remarks': remarks,
      'approved_at': approvedAt?.toIso8601String(),
    };
  }
}

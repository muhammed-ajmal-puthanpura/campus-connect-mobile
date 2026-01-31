/// API Configuration
/// Defines base URLs and endpoints for the backend API
class ApiConfig {
  // Base URL for the Flask backend
  // Update this to match your backend server address
  static const String baseUrl = 'http://localhost:5000';
  
  // API Endpoints
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  
  // Student
  static const String studentDashboard = '/student/dashboard';
  static const String studentEvents = '/student/events';
  static const String studentRegister = '/student/register'; // + /:event_id
  static const String studentMyRegistrations = '/student/my-registrations';
  static const String studentMyCertificates = '/student/my-certificates';
  static const String studentDownloadCertificate = '/student/download-certificate'; // + /:id
  static const String studentSubmitFeedback = '/student/submit-feedback'; // + /:event_id
  
  // Organizer
  static const String organizerDashboard = '/organizer/dashboard';
  static const String organizerCreateEvent = '/organizer/create-event';
  static const String organizerEvent = '/organizer/event'; // + /:event_id
  static const String organizerScanQr = '/organizer/scan-qr'; // + /:event_id
  static const String organizerValidateQr = '/organizer/validate-qr';
  
  // HOD
  static const String hodDashboard = '/hod/dashboard';
  static const String hodApproveEvent = '/hod/approve-event'; // + /:approval_id
  
  // Principal
  static const String principalDashboard = '/principal/dashboard';
  static const String principalApproveEvent = '/principal/approve-event'; // + /:approval_id
  
  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminEvents = '/admin/events';
  static const String adminEvent = '/admin/event'; // + /:event_id
  static const String adminReports = '/admin/reports';
  static const String adminFeedback = '/admin/feedback';
  static const String adminUsers = '/admin/users';
  
  // Common
  static const String profile = '/profile';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

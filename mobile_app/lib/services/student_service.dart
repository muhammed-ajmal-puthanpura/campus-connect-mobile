/// Student Service
/// Handles all student-related API calls
import '../config/api_config.dart';
import '../models/event.dart';
import '../models/registration.dart';
import '../models/certificate.dart';
import 'api_service.dart';

class StudentService {
  static final StudentService _instance = StudentService._internal();
  factory StudentService() => _instance;
  StudentService._internal();

  final ApiService _apiService = ApiService();

  /// Get student dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get(ApiConfig.studentDashboard);
  }

  /// Get list of approved upcoming events
  Future<ApiResponse<List<Event>>> getEvents({
    String? organizer,
    String? mode,
  }) async {
    final queryParams = <String, String>{};
    if (organizer != null) queryParams['organizer'] = organizer;
    if (mode != null) queryParams['mode'] = mode;

    final response = await _apiService.get(
      ApiConfig.studentEvents,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.success && response.data != null) {
      final data = response.data;
      List<Event> events = [];
      
      if (data is List) {
        events = data.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('events')) {
        final eventsList = data['events'] as List;
        events = eventsList.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
      }

      return ApiResponse<List<Event>>(
        success: true,
        data: events,
        message: response.message,
      );
    }

    return ApiResponse<List<Event>>(
      success: false,
      message: response.message ?? 'Failed to load events',
    );
  }

  /// Register for an event
  Future<ApiResponse<Registration>> registerForEvent(int eventId) async {
    final response = await _apiService.post(
      '${ApiConfig.studentRegister}/$eventId',
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final registration = Registration.fromJson(data);
      
      return ApiResponse<Registration>(
        success: true,
        data: registration,
        message: response.message ?? 'Registration successful',
      );
    }

    return ApiResponse<Registration>(
      success: false,
      message: response.message ?? 'Registration failed',
    );
  }

  /// Get student's registrations
  Future<ApiResponse<List<Registration>>> getMyRegistrations() async {
    final response = await _apiService.get(ApiConfig.studentMyRegistrations);

    if (response.success && response.data != null) {
      final data = response.data;
      List<Registration> registrations = [];
      
      if (data is List) {
        registrations = data.map((e) => Registration.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('registrations')) {
        final regList = data['registrations'] as List;
        registrations = regList.map((e) => Registration.fromJson(e as Map<String, dynamic>)).toList();
      }

      return ApiResponse<List<Registration>>(
        success: true,
        data: registrations,
        message: response.message,
      );
    }

    return ApiResponse<List<Registration>>(
      success: false,
      message: response.message ?? 'Failed to load registrations',
    );
  }

  /// Get student's certificates
  Future<ApiResponse<List<Certificate>>> getMyCertificates() async {
    final response = await _apiService.get(ApiConfig.studentMyCertificates);

    if (response.success && response.data != null) {
      final data = response.data;
      List<Certificate> certificates = [];
      
      if (data is List) {
        certificates = data.map((e) => Certificate.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('certificates')) {
        final certList = data['certificates'] as List;
        certificates = certList.map((e) => Certificate.fromJson(e as Map<String, dynamic>)).toList();
      }

      return ApiResponse<List<Certificate>>(
        success: true,
        data: certificates,
        message: response.message,
      );
    }

    return ApiResponse<List<Certificate>>(
      success: false,
      message: response.message ?? 'Failed to load certificates',
    );
  }

  /// Download certificate
  Future<ApiResponse<List<int>>> downloadCertificate(int certificateId) async {
    return await _apiService.downloadFile(
      '${ApiConfig.studentDownloadCertificate}/$certificateId',
    );
  }

  /// Submit feedback for an event
  Future<ApiResponse<void>> submitFeedback({
    required int eventId,
    required int rating,
    String? comments,
  }) async {
    if (rating < 1 || rating > 5) {
      return ApiResponse<void>(
        success: false,
        message: 'Rating must be between 1 and 5',
      );
    }

    final response = await _apiService.post(
      '${ApiConfig.studentSubmitFeedback}/$eventId',
      body: {
        'rating': rating,
        if (comments != null && comments.isNotEmpty) 'comments': comments,
      },
    );

    return ApiResponse<void>(
      success: response.success,
      message: response.message ?? 
              (response.success ? 'Feedback submitted successfully' : 'Failed to submit feedback'),
    );
  }
}

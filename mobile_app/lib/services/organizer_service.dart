/// Organizer Service
/// Handles all organizer-related API calls
import '../config/api_config.dart';
import '../models/event.dart';
import '../models/registration.dart';
import '../models/user.dart';
import '../models/certificate.dart';
import 'api_service.dart';

class OrganizerService {
  static final OrganizerService _instance = OrganizerService._internal();
  factory OrganizerService() => _instance;
  OrganizerService._internal();

  final ApiService _apiService = ApiService();

  /// Get organizer dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get(ApiConfig.organizerDashboard);
  }

  /// Create a new event
  Future<ApiResponse<Event>> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int deptId,
    required String mode, // 'online' or 'offline'
    int? venueId,
    String? meetingUrl,
    String? posterUrl,
  }) async {
    // Validate inputs
    if (mode == 'online' && (meetingUrl == null || meetingUrl.isEmpty)) {
      return ApiResponse<Event>(
        success: false,
        message: 'Meeting URL is required for online events',
      );
    }

    if (mode == 'offline' && (venueId == null || venueId <= 0)) {
      return ApiResponse<Event>(
        success: false,
        message: 'Venue is required for offline events',
      );
    }

    final body = {
      'title': title,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'dept_id': deptId,
      'mode': mode,
      if (venueId != null && venueId > 0) 'venue_id': venueId,
      if (meetingUrl != null && meetingUrl.isNotEmpty) 'meeting_url': meetingUrl,
      if (posterUrl != null && posterUrl.isNotEmpty) 'poster_url': posterUrl,
    };

    final response = await _apiService.post(
      ApiConfig.organizerCreateEvent,
      body: body,
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final event = Event.fromJson(data);
      
      return ApiResponse<Event>(
        success: true,
        data: event,
        message: response.message ?? 'Event created successfully',
      );
    }

    return ApiResponse<Event>(
      success: false,
      message: response.message ?? 'Failed to create event',
    );
  }

  /// Get event details
  Future<ApiResponse<Map<String, dynamic>>> getEvent(int eventId) async {
    return await _apiService.get('${ApiConfig.organizerEvent}/$eventId');
  }

  /// Get registered students for an event
  Future<ApiResponse<List<Registration>>> getEventRegistrations(int eventId) async {
    final response = await _apiService.get('${ApiConfig.organizerEvent}/$eventId');

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      List<Registration> registrations = [];
      
      if (data.containsKey('registrations')) {
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

  /// Validate QR code and mark attendance
  Future<ApiResponse<Map<String, dynamic>>> validateQRCode({
    required String qrCode,
    required int eventId,
  }) async {
    final response = await _apiService.post(
      ApiConfig.organizerValidateQr,
      body: {
        'qr_code': qrCode,
        'event_id': eventId,
      },
    );

    if (response.success && response.data != null) {
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: response.data as Map<String, dynamic>,
        message: response.message ?? 'Attendance marked successfully',
      );
    }

    return ApiResponse<Map<String, dynamic>>(
      success: false,
      message: response.message ?? 'Failed to validate QR code',
    );
  }

  /// Get venues list
  Future<ApiResponse<List<Venue>>> getVenues() async {
    // Note: This might need to be added to the backend
    // For now, return a placeholder
    return ApiResponse<List<Venue>>(
      success: true,
      data: [],
    );
  }
}

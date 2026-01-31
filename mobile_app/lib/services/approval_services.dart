/// HOD Service
/// Handles all HOD-related API calls
import '../config/api_config.dart';
import '../models/certificate.dart';
import 'api_service.dart';

class HodService {
  static final HodService _instance = HodService._internal();
  factory HodService() => _instance;
  HodService._internal();

  final ApiService _apiService = ApiService();

  /// Get HOD dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get(ApiConfig.hodDashboard);
  }

  /// Approve or reject an event
  Future<ApiResponse<void>> approveEvent({
    required int approvalId,
    required String action, // 'approve' or 'reject'
    String? remarks,
  }) async {
    if (action != 'approve' && action != 'reject') {
      return ApiResponse<void>(
        success: false,
        message: 'Invalid action. Must be "approve" or "reject"',
      );
    }

    final response = await _apiService.post(
      '${ApiConfig.hodApproveEvent}/$approvalId',
      body: {
        'action': action,
        if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
      },
    );

    return ApiResponse<void>(
      success: response.success,
      message: response.message ?? 
              (response.success 
                ? 'Event ${action == "approve" ? "approved" : "rejected"} successfully' 
                : 'Failed to $action event'),
    );
  }
}

/// Principal Service
/// Handles all Principal-related API calls
class PrincipalService {
  static final PrincipalService _instance = PrincipalService._internal();
  factory PrincipalService() => _instance;
  PrincipalService._internal();

  final ApiService _apiService = ApiService();

  /// Get Principal dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get(ApiConfig.principalDashboard);
  }

  /// Approve or reject an event (final approval)
  Future<ApiResponse<void>> approveEvent({
    required int approvalId,
    required String action, // 'approve' or 'reject'
    String? remarks,
  }) async {
    if (action != 'approve' && action != 'reject') {
      return ApiResponse<void>(
        success: false,
        message: 'Invalid action. Must be "approve" or "reject"',
      );
    }

    final response = await _apiService.post(
      '${ApiConfig.principalApproveEvent}/$approvalId',
      body: {
        'action': action,
        if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
      },
    );

    return ApiResponse<void>(
      success: response.success,
      message: response.message ?? 
              (response.success 
                ? 'Event ${action == "approve" ? "approved" : "rejected"} successfully' 
                : 'Failed to $action event'),
    );
  }
}

/// Admin Service
/// Handles all Admin-related API calls
class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final ApiService _apiService = ApiService();

  /// Get Admin dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    return await _apiService.get(ApiConfig.adminDashboard);
  }

  /// Get all events with filters
  Future<ApiResponse<Map<String, dynamic>>> getEvents({
    String? department,
    String? organizer,
    String? status,
    String? date,
  }) async {
    final queryParams = <String, String>{};
    if (department != null) queryParams['department'] = department;
    if (organizer != null) queryParams['organizer'] = organizer;
    if (status != null) queryParams['status'] = status;
    if (date != null) queryParams['date'] = date;

    return await _apiService.get(
      ApiConfig.adminEvents,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get event details
  Future<ApiResponse<Map<String, dynamic>>> getEvent(int eventId) async {
    return await _apiService.get('${ApiConfig.adminEvent}/$eventId');
  }

  /// Get reports
  Future<ApiResponse<Map<String, dynamic>>> getReports() async {
    return await _apiService.get(ApiConfig.adminReports);
  }

  /// Get feedback
  Future<ApiResponse<List<Feedback>>> getFeedback() async {
    final response = await _apiService.get(ApiConfig.adminFeedback);

    if (response.success && response.data != null) {
      final data = response.data;
      List<Feedback> feedbackList = [];
      
      if (data is List) {
        feedbackList = data.map((e) => Feedback.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('feedback')) {
        final fbList = data['feedback'] as List;
        feedbackList = fbList.map((e) => Feedback.fromJson(e as Map<String, dynamic>)).toList();
      }

      return ApiResponse<List<Feedback>>(
        success: true,
        data: feedbackList,
        message: response.message,
      );
    }

    return ApiResponse<List<Feedback>>(
      success: false,
      message: response.message ?? 'Failed to load feedback',
    );
  }

  /// Get users
  Future<ApiResponse<Map<String, dynamic>>> getUsers() async {
    return await _apiService.get(ApiConfig.adminUsers);
  }
}

/// API Service
/// Base service for making HTTP requests to the backend
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final StorageService _storageService = StorageService();

  /// Get headers with authentication token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Build full URL
  String _buildUrl(String endpoint) {
    return '${ApiConfig.baseUrl}$endpoint';
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(http.Response response, {T Function(dynamic)? parser}) {
    try {
      final statusCode = response.statusCode;
      
      // Check for successful response
      if (statusCode >= 200 && statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse<T>(
            success: true,
            statusCode: statusCode,
          );
        }

        final jsonData = jsonDecode(response.body);
        
        // Handle different response formats
        if (jsonData is Map<String, dynamic>) {
          // If response has a 'success' field, use it
          final success = jsonData['success'] as bool? ?? true;
          final message = jsonData['message'] as String?;
          
          if (!success) {
            return ApiResponse<T>(
              success: false,
              message: message ?? 'Request failed',
              statusCode: statusCode,
            );
          }

          // Parse data if parser is provided
          if (parser != null) {
            final data = parser(jsonData['data'] ?? jsonData);
            return ApiResponse<T>(
              success: true,
              data: data,
              message: message,
              statusCode: statusCode,
            );
          }

          return ApiResponse<T>(
            success: true,
            data: jsonData['data'] as T? ?? jsonData as T?,
            message: message,
            statusCode: statusCode,
          );
        }

        // If response is a list
        if (parser != null) {
          final data = parser(jsonData);
          return ApiResponse<T>(
            success: true,
            data: data,
            statusCode: statusCode,
          );
        }

        return ApiResponse<T>(
          success: true,
          data: jsonData as T?,
          statusCode: statusCode,
        );
      }

      // Handle error responses
      String message = 'Request failed with status: $statusCode';
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic>) {
          message = jsonData['message'] as String? ?? 
                   jsonData['error'] as String? ?? 
                   message;
        }
      } catch (e) {
        // Ignore JSON parsing error
      }

      return ApiResponse<T>(
        success: false,
        message: message,
        statusCode: statusCode,
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error parsing response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true,
    T Function(dynamic)? parser,
  }) async {
    try {
      var url = _buildUrl(endpoint);
      if (queryParams != null && queryParams.isNotEmpty) {
        final query = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        url = '$url?$query';
      }

      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(ApiConfig.connectTimeout);

      return _handleResponse<T>(response, parser: parser);
    } on SocketException {
      return ApiResponse<T>(
        success: false,
        message: 'No internet connection',
      );
    } on HttpException {
      return ApiResponse<T>(
        success: false,
        message: 'Unable to connect to server',
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
    T Function(dynamic)? parser,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, parser: parser);
    } on SocketException {
      return ApiResponse<T>(
        success: false,
        message: 'No internet connection',
      );
    } on HttpException {
      return ApiResponse<T>(
        success: false,
        message: 'Unable to connect to server',
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
    T Function(dynamic)? parser,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, parser: parser);
    } on SocketException {
      return ApiResponse<T>(
        success: false,
        message: 'No internet connection',
      );
    } on HttpException {
      return ApiResponse<T>(
        success: false,
        message: 'Unable to connect to server',
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool includeAuth = true,
    T Function(dynamic)? parser,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(ApiConfig.connectTimeout);

      return _handleResponse<T>(response, parser: parser);
    } on SocketException {
      return ApiResponse<T>(
        success: false,
        message: 'No internet connection',
      );
    } on HttpException {
      return ApiResponse<T>(
        success: false,
        message: 'Unable to connect to server',
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  /// Download file
  Future<ApiResponse<List<int>>> downloadFile(String endpoint) async {
    try {
      final url = _buildUrl(endpoint);
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        return ApiResponse<List<int>>(
          success: true,
          data: response.bodyBytes,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<int>>(
        success: false,
        message: 'Failed to download file',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<List<int>>(
        success: false,
        message: 'Error downloading file: $e',
      );
    }
  }
}

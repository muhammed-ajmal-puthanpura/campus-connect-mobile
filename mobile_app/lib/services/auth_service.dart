/// Authentication Service
/// Handles user authentication, login, logout, and registration
import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  /// Login user
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      if (response.success && response.data != null) {
        // Extract token and user data
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;

        if (token != null && userData != null) {
          // Save token and user data
          await _storageService.saveToken(token);
          await _storageService.saveUser(userData);
          await _storageService.setRememberMe(rememberMe);

          final user = User.fromJson(userData);
          return ApiResponse<User>(
            success: true,
            data: user,
            message: 'Login successful',
          );
        }
      }

      return ApiResponse<User>(
        success: false,
        message: response.message ?? 'Login failed',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Error during login: $e',
      );
    }
  }

  /// Register new user
  Future<ApiResponse<void>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required int roleId,
    int? deptId,
  }) async {
    try {
      if (password != confirmPassword) {
        return ApiResponse<void>(
          success: false,
          message: 'Passwords do not match',
        );
      }

      if (password.length < 8) {
        return ApiResponse<void>(
          success: false,
          message: 'Password must be at least 8 characters',
        );
      }

      final response = await _apiService.post(
        ApiConfig.register,
        body: {
          'full_name': fullName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'role_id': roleId,
          if (deptId != null) 'dept_id': deptId,
        },
        includeAuth: false,
      );

      return ApiResponse<void>(
        success: response.success,
        message: response.message ?? 
                (response.success ? 'Registration successful' : 'Registration failed'),
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Error during registration: $e',
      );
    }
  }

  /// Change password
  Future<ApiResponse<void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (newPassword != confirmPassword) {
        return ApiResponse<void>(
          success: false,
          message: 'New passwords do not match',
        );
      }

      if (newPassword.length < 8) {
        return ApiResponse<void>(
          success: false,
          message: 'Password must be at least 8 characters',
        );
      }

      final response = await _apiService.post(
        ApiConfig.changePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      return ApiResponse<void>(
        success: response.success,
        message: response.message ?? 
                (response.success ? 'Password changed successfully' : 'Failed to change password'),
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Error changing password: $e',
      );
    }
  }

  /// Logout user
  Future<ApiResponse<void>> logout() async {
    try {
      // Call logout endpoint
      await _apiService.get(ApiConfig.logout);

      // Clear local storage
      await _storageService.clearAll();

      return ApiResponse<void>(
        success: true,
        message: 'Logged out successfully',
      );
    } catch (e) {
      // Even if API call fails, clear local storage
      await _storageService.clearAll();
      
      return ApiResponse<void>(
        success: true,
        message: 'Logged out',
      );
    }
  }

  /// Get current user data
  User? getCurrentUser() {
    final userData = _storageService.getUser();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  /// Get roles list
  Future<ApiResponse<List<Role>>> getRoles() async {
    // Note: This assumes there's an endpoint to get roles
    // If not available, we can return a static list
    return ApiResponse<List<Role>>(
      success: true,
      data: [
        Role(roleId: 1, roleName: 'Student'),
        Role(roleId: 2, roleName: 'Event Organizer'),
        Role(roleId: 3, roleName: 'HOD'),
        Role(roleId: 4, roleName: 'Principal'),
        Role(roleId: 5, roleName: 'Admin'),
      ],
    );
  }

  /// Get departments list
  Future<ApiResponse<List<Department>>> getDepartments() async {
    // Note: This assumes there's an endpoint to get departments
    // If not available, we can return a static list based on your backend
    return ApiResponse<List<Department>>(
      success: true,
      data: [
        Department(deptId: 1, deptName: 'Computer Science'),
        Department(deptId: 2, deptName: 'Electronics'),
        Department(deptId: 3, deptName: 'Mechanical'),
        Department(deptId: 4, deptName: 'Civil'),
        Department(deptId: 5, deptName: 'Electrical'),
      ],
    );
  }
}

/// Storage Service
/// Handles local storage for tokens and user data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  // Keys
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyRememberMe = 'remember_me';

  /// Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save authentication token securely
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyToken);
  }

  /// Save user data
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _prefs?.setString(_keyUser, jsonEncode(userData));
  }

  /// Get user data
  Map<String, dynamic>? getUser() {
    final userStr = _prefs?.getString(_keyUser);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  /// Delete user data
  Future<void> deleteUser() async {
    await _prefs?.remove(_keyUser);
  }

  /// Save remember me preference
  Future<void> setRememberMe(bool value) async {
    await _prefs?.setBool(_keyRememberMe, value);
  }

  /// Get remember me preference
  bool getRememberMe() {
    return _prefs?.getBool(_keyRememberMe) ?? false;
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
    await _prefs?.clear();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_app/models/api_response.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';

class AuthService {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthService(this._dioClient);

  // Register a new user
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? userData = responseData['user'];
        final String? token = responseData['token'];
        final String? tokenType = responseData['token_type'];

        if (token != null) {
          final fullToken = '$tokenType $token';
          await _saveToken(fullToken);
        }

        return ApiResponse.success({
          'user': userData,
          'token': token,
          'token_type': tokenType,
        }, message: message ?? 'Registration successful');
      }

      return ApiResponse.error('Registration failed');
    } on DioException catch (e) {
      debugPrint('Registration error: ${e.message}');

      Map<String, List<String>> errors = {};
      String message = 'Registration failed';

      if (e.response != null) {
        debugPrint('Error response: ${e.response!.data}');

        if (e.response!.data is Map) {
          if (e.response!.data['errors'] != null &&
              e.response!.data['errors'] is Map) {
            final errorData = e.response!.data['errors'] as Map;
            errorData.forEach((key, value) {
              if (value is List) {
                errors[key] = List<String>.from(
                  value.map((item) => item.toString()),
                );
              } else if (value is String) {
                errors[key] = [value];
              }
            });
          }
          if (e.response!.data['message'] != null) {
            message = e.response!.data['message'].toString();
          }
        }
      }

      return ApiResponse.error(message, errors: errors);
    } catch (e) {
      debugPrint('Unexpected error during registration: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Login user
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        final String? message = responseData['message'];
        final Map<String, dynamic>? userData = responseData['user'];
        final String? token = responseData['token'];
        final String? tokenType = responseData['token_type'];
        if (token != null && tokenType != null) {
          final fullToken = '$tokenType $token';
          await _saveToken(fullToken);
        }

        return ApiResponse.success({
          'user': userData,
          'token': token,
          'token_type': tokenType,
        }, message: message ?? 'Login successful');
      }

      return ApiResponse.error('Login failed');
    } on DioException catch (e) {
      debugPrint('Login error: ${e.message}');

      String message = 'Login failed';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }

      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error during login: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Logout user
  Future<ApiResponse<bool>> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        _dioClient.addAuthToken(token);

        try {
          await _dioClient.dio.post('/api/logout');
        } catch (e) {
          debugPrint('Logout API error: $e');
        }
      }
      await _clearToken();
      return ApiResponse.success(true, message: 'Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
      await _clearToken();
      return ApiResponse.success(true, message: 'Logout completed');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Get the current authentication token
  Future<String?> getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }

  // Save the authentication token
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
    // Also set the token in the dio client for future requests
    _dioClient.addAuthToken(token);
  }

  // Clear the authentication token
  Future<void> _clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
    _dioClient.removeAuthToken();
  }

  // Get current user profile
  Future<ApiResponse<Map<String, dynamic>>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.get('/api/user');

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      }

      return ApiResponse.error('Failed to get user data');
    } on DioException catch (e) {
      debugPrint('Get user error: ${e.message}');
      return ApiResponse.error('Failed to fetch user data');
    } catch (e) {
      debugPrint('Unexpected error fetching user: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<bool>> forgotPassword({required String email}) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        return ApiResponse.success(
          true,
          message: message ?? 'Password reset link sent',
        );
      }

      return ApiResponse.error('Failed to send reset link');
    } on DioException catch (e) {
      debugPrint('Forgot password error: ${e.message}');
      String message = 'Failed to send reset link';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error during forgot password: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }
}

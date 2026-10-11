import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final ApiClient _apiClient = ApiClient();
  UserModel? currentUser;

  AuthService._internal();

  bool get isAuthenticated => _apiClient.token != null;

  /// Authenticate user with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      _apiClient.setToken(authResponse.accessToken);

      // Fetch user profile after successful login
      final profile = await getProfile();
      currentUser = profile;
      return profile;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Register a new user
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    String? avatar,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/users',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': avatar ?? 'https://picsum.photos/800',
        },
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Fetch authenticated user profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile');
      final user = UserModel.fromJson(response.data);
      currentUser = user;
      return user;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Logout and clear saved session
  void logout() {
    _apiClient.clearToken();
    currentUser = null;
  }

  String _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      if (statusCode == 401) {
        return 'Invalid email or password. Please check your credentials.';
      }

      if (data is Map<String, dynamic> && data.containsKey('message')) {
        final message = data['message'];
        if (message is List) {
          return message.join('\n');
        } else if (message is String) {
          return message;
        }
      }

      return 'Request failed with status code $statusCode';
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to the server. Please check your internet connection.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return error.message ?? 'A network error occurred. Please try again.';
      }
    }
  }
}

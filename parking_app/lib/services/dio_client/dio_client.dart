import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();
  final String _baseUrl;

  // Constructor that takes a base URL
  DioClient(this._baseUrl) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptors for logging, error handling, etc.
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print(object),
      ),
    );
  }

  // Getter for the Dio instance
  Dio get dio => _dio;

  // You can add interceptors or other configuration methods here
  void addAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

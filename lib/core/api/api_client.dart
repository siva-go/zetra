import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/logger_interceptor.dart';
import '../network/interceptors/token_interceptor.dart';

/// ZETRA Core — API Client
///
/// A singleton [Dio] instance pre-configured with base URL, timeouts,
/// headers, and all required interceptors.
///
/// Usage (after DI is wired):
/// ```dart
/// final client = getIt<ApiClient>();
/// final response = await client.dio.get('/stations');
/// ```
class ApiClient {
  ApiClient({
    required AuthInterceptor authInterceptor,
    required TokenInterceptor tokenInterceptor,
    required LoggerInterceptor loggerInterceptor,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      tokenInterceptor,
      loggerInterceptor,
    ]);
  }

  late final Dio dio;
}

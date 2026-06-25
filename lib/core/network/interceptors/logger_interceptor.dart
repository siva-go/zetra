import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs all HTTP requests and responses to the debug console.
/// Only active in debug/profile mode — stripped in release builds.
class LoggerInterceptor extends Interceptor {
  const LoggerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── REQUEST ─────────────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      if (options.data != null) debugPrint('│ Body: ${options.data}');
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── RESPONSE ────────────────────────────────');
      debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── ERROR ───────────────────────────────────');
      debugPrint('│ ${err.type} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      if (err.response != null) debugPrint('│ Response: ${err.response?.data}');
      debugPrint('└────────────────────────────────────────────');
    }
    handler.next(err);
  }
}

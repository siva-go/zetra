import 'package:dio/dio.dart';
import 'package:zetra/core/errors/app_exception.dart';
import 'package:zetra/core/storage/secure_storage.dart';

/// Handles 401 responses by attempting a token refresh.
///
/// If the refresh succeeds, the original request is retried with the new token.
/// If the refresh fails, [SessionExpiredException] is thrown and the user
/// should be redirected to the login screen.
class TokenInterceptor extends Interceptor {
  TokenInterceptor({required SecureStorage secureStorage})
      : _storage = secureStorage;

  final SecureStorage _storage;
  late final Dio dio;

  // Track in-flight refresh to avoid concurrent refresh calls
  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final bool refreshed = await _refreshToken();
        if (refreshed) {
          // Retry original request with fresh token
          final String? token = await _storage.getAccessToken();
          final RequestOptions opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';
          final Response<dynamic> response = await dio.fetch(opts);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        // Fall through to session expired
      } finally {
        _isRefreshing = false;
      }

      await _storage.clearTokens();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const SessionExpiredException(),
          type: DioExceptionType.badResponse,
          response: err.response,
        ),
      );
      return;
    }
    handler.next(err);
  }

  /// Calls the refresh endpoint and persists new tokens.
  /// Returns `true` on success, `false` otherwise.
  Future<bool> _refreshToken() async {
    final String? refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final Response<dynamic> response = await dio.post(
        '/auth/refresh',
        data: <String, String>{'refresh_token': refreshToken},
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      await _storage.saveAccessToken(data['access_token'] as String);
      if (data.containsKey('refresh_token')) {
        await _storage.saveRefreshToken(data['refresh_token'] as String);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}

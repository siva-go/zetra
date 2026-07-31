import 'package:dio/dio.dart';
import 'package:zetra/core/storage/secure_storage.dart';

/// Attaches the Bearer token from [SecureStorage] to every outbound request.
class AuthInterceptor extends Interceptor {

  const AuthInterceptor({required SecureStorage secureStorage}) : _storage = secureStorage;

  final SecureStorage _storage;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    final String? token = await _storage.getAccessToken();

    if (token != null && token.isNotEmpty) {

      options.headers['Authorization'] = 'Bearer $token';

    }

    handler.next(options);

  }

}
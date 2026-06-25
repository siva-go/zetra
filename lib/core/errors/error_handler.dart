import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'failure.dart';

/// ZETRA Core — Error Handler
///
/// Centralised mapping from raw exceptions ([DioException], [AppException],
/// [SocketException], etc.) to domain [Failure] objects.
///
/// Usage:
/// ```dart
/// try {
///   final result = await apiClient.get('/endpoint');
///   return Result.success(result.data);
/// } catch (e) {
///   return Result.failure(ErrorHandler.handle(e));
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  /// Maps any caught object to the appropriate [Failure] subtype.
  static Failure handle(Object error) {
    if (error is DioException) return _handleDio(error);
    if (error is AppException) return _handleAppException(error);
    if (error is SocketException) return const NetworkFailure();
    return const UnknownFailure();
  }

  static Failure _handleDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.badResponse:
        return _handleHttpStatus(e.response?.statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled.');
      default:
        return const UnknownFailure();
    }
  }

  static Failure _handleHttpStatus(int? code) {
    return switch (code) {
      400 => const ServerFailure(message: 'Bad request. Please check your input.', code: 400),
      401 => const UnauthorizedFailure(),
      403 => const ForbiddenFailure(),
      404 => const NotFoundFailure(),
      408 => const TimeoutFailure(),
      422 => const ServerFailure(message: 'Unprocessable data. Please try again.', code: 422),
      500 => const ServerFailure(message: 'Server error. Please try again later.', code: 500),
      503 => const ServerFailure(message: 'Service unavailable. Please try again later.', code: 503),
      _ => ServerFailure(message: 'Unexpected error (HTTP $code).', code: code),
    };
  }

  static Failure _handleAppException(AppException e) {
    return switch (e) {
      NetworkException() => NetworkFailure(message: e.message),
      TimeoutException() => TimeoutFailure(message: e.message),
      ServerException() => ServerFailure(message: e.message, code: e.code),
      UnauthorizedException() => UnauthorizedFailure(message: e.message),
      ForbiddenException() => ForbiddenFailure(message: e.message),
      NotFoundException() => NotFoundFailure(message: e.message),
      OtpException() => OtpFailure(message: e.message),
      SessionExpiredException() => SessionExpiredFailure(message: e.message),
      CacheException() => CacheFailure(message: e.message),
      InvalidQrException() => InvalidQrFailure(message: e.message),
      ChargingSessionException() => ChargingSessionFailure(message: e.message),
    };
  }
}

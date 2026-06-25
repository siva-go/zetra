/// ZETRA Core — Exception Definitions
///
/// All exceptions thrown across the app are expressed as sealed subclasses
/// of [AppException]. This keeps error handling consistent and exhaustive.
sealed class AppException implements Exception {
  const AppException({required this.message, this.code});

  final String message;
  final int? code;

  @override
  String toString() => '$runtimeType(code: $code, message: $message)';
}

// ── Network ─────────────────────────────────────────────────────────────────

/// Thrown when the device has no internet connectivity.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Thrown when a request times out.
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The request timed out. Please try again.',
  });
}

// ── Server ───────────────────────────────────────────────────────────────────

/// Thrown on non-2xx HTTP responses from the API.
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Thrown on 401 Unauthorized responses.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Your session has expired. Please log in again.',
    super.code = 401,
  });
}

/// Thrown on 403 Forbidden responses.
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.code = 403,
  });
}

/// Thrown on 404 Not Found responses.
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.code = 404,
  });
}

// ── Auth ─────────────────────────────────────────────────────────────────────

/// Thrown when OTP verification fails.
class OtpException extends AppException {
  const OtpException({
    super.message = 'Invalid OTP. Please try again.',
  });
}

/// Thrown when the refresh token is expired or invalid.
class SessionExpiredException extends AppException {
  const SessionExpiredException({
    super.message = 'Session expired. Please log in again.',
  });
}

// ── Cache / Local DB ─────────────────────────────────────────────────────────

/// Thrown when a local database read/write operation fails.
class CacheException extends AppException {
  const CacheException({
    super.message = 'A local storage error occurred. Please restart the app.',
  });
}

// ── Charging ─────────────────────────────────────────────────────────────────

/// Thrown when a QR code cannot be parsed as a valid charger link.
class InvalidQrException extends AppException {
  const InvalidQrException({
    super.message = 'This QR code is not a valid Zetra charger.',
  });
}

/// Thrown when a charging session fails to start or is interrupted.
class ChargingSessionException extends AppException {
  const ChargingSessionException({required super.message});
}

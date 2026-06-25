/// ZETRA Core — Failure Definitions
///
/// [Failure] is the domain-layer counterpart to [AppException].
/// Use Cases and Repositories return `Result<T, Failure>` instead of
/// throwing exceptions, keeping domain logic pure and testable.
sealed class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final int? code;
}

// ── Network ──────────────────────────────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The request timed out. Please try again.',
  });
}

// ── Server ───────────────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.code = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'You do not have permission to perform this action.',
    super.code = 403,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.code = 404,
  });
}

// ── Auth ─────────────────────────────────────────────────────────────────────

class OtpFailure extends Failure {
  const OtpFailure({
    super.message = 'Invalid OTP. Please try again.',
  });
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Session expired. Please log in again.',
  });
}

// ── Cache / Local DB ─────────────────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'A local storage error occurred. Please restart the app.',
  });
}

// ── Charging ─────────────────────────────────────────────────────────────────

class InvalidQrFailure extends Failure {
  const InvalidQrFailure({
    super.message = 'This QR code is not a valid Zetra charger.',
  });
}

class ChargingSessionFailure extends Failure {
  const ChargingSessionFailure({required super.message});
}

// ── Unknown ──────────────────────────────────────────────────────────────────

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
  });
}

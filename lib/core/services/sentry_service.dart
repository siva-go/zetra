import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zetra/core/constants/app_constants.dart';

class SentryService {

  static Future<void> init(AppRunner runner) async {

    await SentryFlutter.init(
      (SentryFlutterOptions options) {
        options.dsn = AppConstants.sentryDsn;
        options.tracesSampleRate = kDebugMode ? 0.0 : 0.2;
        options.profilesSampleRate = kDebugMode ? 0.0 : 0.1;
        options.environment = kDebugMode ? 'development' : 'production';
        options.debug = kDebugMode;
      },
      appRunner: runner
    );

  }

  static Future<void> logChargingStarted({required String stationId}) => Sentry.captureMessage(
      'charging_session_started',
      withScope: (Scope scope) => scope.setContexts('charging', <String, String>{'station_id': stationId})
  );

  static Future<void> logChargingStop({required String stationId, required bool isError, String? reason}) => Sentry.captureMessage(
    isError ? 'charging_session_error' : 'charging_session_stopped',
    withScope: (Scope scope) {

      scope.setContexts('charging', <String, String>{
        'station_id': stationId,
        if (reason != null) 'reason': reason,
      });

    }
  );

  static Future<void> logQrValidationFailed({required String rawCode}) => Sentry.captureMessage(
    'qr_validation_failed',
    withScope: (Scope scope) => scope.setContexts('qr', <String, String>{'raw_code': rawCode})
  );

  static Future<void> logPaymentFailed({required String gateway, required String errorCode}) => Sentry.captureMessage(
    'payment_failed',
    withScope: (Scope scope) {

      scope.setContexts('payment', <String, String>{
        'gateway': gateway,
        'error_code': errorCode,
      });

    }
  );

  /// Generic exception capture with optional breadcrumbs.
  static Future<void> captureException(Object error, {StackTrace? stackTrace, String? hint}) => Sentry.captureException(
    error,
    stackTrace: stackTrace,
    hint: hint != null ? Hint.withMap(<String, dynamic>{'message': hint}) : null,
  );

}

typedef AppRunner = Future<void> Function();
/// ZETRA Core — App Constants
///
/// Centralised store for environment values, timeouts, and URL paths.
/// No hardcoded URL/key should appear in any other file.
abstract final class AppConstants {
  // ── API ────────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://zetra-production.up.railway.app/api/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 20);

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String tokenKey = 'zetra_access_token';
  static const String refreshTokenKey = 'zetra_refresh_token';
  static const String userKey = 'zetra_user';

  // ── Charging ───────────────────────────────────────────────────────────────
  /// QR code URL prefix that identifies a valid Zetra charger.
  static const String qrChargerPrefix = 'zetra://charger/';

  /// Simulated tick interval for charging session updates.
  static const Duration chargingTickInterval = Duration(seconds: 1);

  /// SOC increment per tick during simulation.
  static const double socIncrementPerTick = 0.005; // 0.5% per second

  /// Maximum battery temperature before warning (°C).
  static const double batteryTempWarning = 40.0;

  /// Maximum battery temperature before emergency stop (°C).
  static const double batteryTempCritical = 45.0;

  // ── Maps ───────────────────────────────────────────────────────────────────
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // ── Monitoring ─────────────────────────────────────────────────────────────
  static const String sentryDsn = 'YOUR_SENTRY_DSN';

  // ── Pagination ─────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
}

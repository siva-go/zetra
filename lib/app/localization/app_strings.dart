/// ZETRA Core — App Strings
///
/// All UI strings are defined here as constants.
/// Hardcoded string literals in widgets are strictly prohibited.
///
/// When localisation (ARB/intl) is added, replace these constants with
/// generated `AppLocalizations.of(context).xxx` calls.
abstract final class AppStrings {
  // ── General ───────────────────────────────────────────────────────────────
  static const String appName = 'ZETRA EV Charging';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String finish = 'Finish';
  static const String comingSoon = 'Feature coming soon';

  // ── Charge Link Screen ─────────────────────────────────────────────────────
  static const String chargeLinkTitle = 'Power Link\nEstablished! ⚡';
  static const String chargeLinkSubtitle = 'Vehicle connected successfully.';
  static const String letsCharge = "Let's Charge";

  // ── Charging Screen ────────────────────────────────────────────────────────
  static const String chargingSessionLabel = 'CHARGING SESSION';
  static const String statusActiveCharging = 'Active Charging';
  static const String statusChargingCompleted = 'Charging Completed';
  static const String statusSessionPaused = 'Session Paused';

  static const String gaugeSpeedLabel = 'SPEED';
  static const String gaugeSpeedUnit = 'kW';
  static const String gaugeEnergyLabel = 'ENERGY';
  static const String gaugeEnergyUnit = 'kWh';
  static const String gaugeRemainingLabel = 'REMAINING';
  static const String gaugeRemainingUnit = 'min';

  static const String chargerType = 'DC Fast Charge';
  static const String powerValue = '150 kW';
  static const String connectorType = 'CCS Type 2';

  static const String slideToStop = 'Slide to Stop Charging';
  static const String slideToFinish = 'Slide to Finish';

  static const String tabFeedback = 'Tab %d tapped (Feature coming soon)';

  // ── Station Info Dialog ────────────────────────────────────────────────────
  static const String stationInfoTitle = 'Station Info';
  static const String stationInfoContent =
      'Charger: Super DC-94\nLocation: Sector 4 EV Hub\nNetwork: Zetra Power\nStatus: Online';

  // ── Session Summary Dialog ─────────────────────────────────────────────────
  static const String sessionSummaryTitle = 'Session Summary';
  static const String sessionSummaryStoppedIntro =
      'Charging session stopped successfully.\n\n';
  static const String sessionSummaryFinalCharge = '• Final Charge: %s%%\n';
  static const String sessionSummaryEnergy = '• Energy Delivered: %s kWh\n';
  static const String sessionSummaryElapsed =
      '• Elapsed Time: %dm %ds\n';
  static const String sessionSummaryTemp = '• Average Temp: %s°C';

  // ── Error Messages ─────────────────────────────────────────────────────────
  static const String genericError =
      'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String sessionExpiredError =
      'Your session has expired. Please log in again.';
  static const String qrInvalidError =
      'This QR code is not a valid Zetra charger.';
}

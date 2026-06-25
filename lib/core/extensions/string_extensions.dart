/// ZETRA Core — String Extensions
extension ZetraStringExtension on String {
  /// Returns `true` if the string is a valid E.164 phone number.
  bool get isValidPhone =>
      RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(trim());

  /// Returns `true` if the string is a valid email address.
  bool get isValidEmail =>
      RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(trim());

  /// Capitalises the first letter of the string.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Returns `true` if this string starts with the Zetra QR prefix.
  bool get isValidZetraQr =>
      startsWith('zetra://charger/');

  /// Extracts the charger ID from a Zetra QR code string.
  /// Returns `null` if the string is not a valid QR code.
  String? get zetraChargerId {
    const prefix = 'zetra://charger/';
    if (!startsWith(prefix)) return null;
    final id = substring(prefix.length);
    return id.isNotEmpty ? id : null;
  }

  /// Truncates and appends '…' if longer than [maxLength].
  String truncate(int maxLength) =>
      length > maxLength ? '${substring(0, maxLength)}…' : this;
}

/// Nullable variant of [ZetraStringExtension].
extension ZetraNullableStringExtension on String? {
  /// Returns `true` if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns the value or a fallback string.
  String orDefault([String fallback = '—']) => this ?? fallback;
}

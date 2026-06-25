/// ZETRA Core — Numeric Extensions
extension ZetraNumExtension on num {
  /// Formats a kWh value to 2 decimal places with unit: "34.52 kWh".
  String toKWh() => '${toStringAsFixed(2)} kWh';

  /// Formats a kW value to 1 decimal place with unit: "82.5 kW".
  String toKW() => '${toStringAsFixed(1)} kW';

  /// Formats a temperature with unit: "32.1°C".
  String toTemp() => '${toStringAsFixed(1)}°C';

  /// Converts a 0.0–1.0 fraction to a 0–100 integer percent: 84.
  int toPercent() => (this * 100).round().clamp(0, 100);

  /// Converts a 0.0–1.0 fraction to a "84%" string.
  String toPercentString() => '${toPercent()}%';
}

extension ZetraDoubleExtension on double {
  /// Clamps a speed (kW) to a sensible range [0, 350].
  double clampSpeed() => clamp(0.0, 350.0).toDouble();

  /// Clamps a SOC value to [0.0, 1.0].
  double clampSoc() => clamp(0.0, 1.0).toDouble();
}

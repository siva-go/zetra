import 'package:flutter/material.dart';

class AppLightColors {

  AppLightColors._();

  /// Backgrounds
  static const Color scaffold = Color(0xFFF2F4F8);   // Very light blue-grey page bg
  static const Color card = Color(0xFFFFFFFF);   // Pure white card
  static const Color surface = Color(0xFFEEF1F6);   // Slightly deeper surface
  static const Color elevated = Color(0xFFE6EAF2);   // Elevated element bg
  /// Text
  static const Color textPrimary = Color(0xFF0D1120); // Near-black
  static const Color textSecondary = Color(0xFF5A6378); // Mid grey
  static const Color textTertiary = Color(0xFF9DA5B8); // Light grey hint
  /// Borders & Dividers
  static const Color border = Color(0xFFDDE1EA);
  static const Color divider = Color(0xFFE8EBF2);
  /// Brand / Accent (inherit from dark palette, same hues)
  static const Color primary = Color(0xFF00B348); // Slightly deeper green for light bg
  static const Color primaryLight = Color(0xFFDFF6E9); // Washed green tint for icon bg
  static const Color chargingGreen = Color(0xFF00B348);
  static const Color chargingGreenBg = Color(0xFFDFF6E9);
  static const Color chargingRed = Color(0xFFE8213A);
  static const Color chargingRedBg = Color(0xFFFFECEE);
  static const Color chargingOrange = Color(0xFFE07900);
  static const Color chargingOrangeBg = Color(0xFFFFF3E0);
  static const Color accent = Color(0xFF5B21B6); // Purple accent (plug-in active step)
  static const Color accentBg = Color(0xFFEDE9FF); // Washed purple tint
  /// Status
  static const Color success = Color(0xFF00B348);
  static const Color error   = Color(0xFFE8213A);
  static const Color warning = Color(0xFFE07900);
  /// Bottom Nav
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navActive     = Color(0xFF0D1120);
  static const Color navInactive   = Color(0xFFACB4C8);
  /// Button
  static const Color buttonGradientStart = Color(0xFF6D28D9);
  static const Color buttonGradientEnd   = Color(0xFF3B82F6);

}
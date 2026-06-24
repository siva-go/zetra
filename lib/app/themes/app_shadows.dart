import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ZETRA Design System - Shadows and Glows Tokens
/// Centralizes premium shadows and neon glow effects.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.35),
          blurRadius: 15,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> get greenGlow => [
        BoxShadow(
          color: AppColors.chargingGreenGlow.withValues(alpha: 0.4),
          blurRadius: 20,
          spreadRadius: 3,
        ),
      ];

  static List<BoxShadow> get orangeGlow => [
        BoxShadow(
          color: AppColors.chargingOrangeGlow.withValues(alpha: 0.4),
          blurRadius: 20,
          spreadRadius: 3,
        ),
      ];

  static List<BoxShadow> get redGlow => [
        BoxShadow(
          color: AppColors.chargingRedGlow.withValues(alpha: 0.4),
          blurRadius: 20,
          spreadRadius: 3,
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: const Color(0xFF7B2FF7).withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}

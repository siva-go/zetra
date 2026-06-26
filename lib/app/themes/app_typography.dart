import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zetra/app/themes/app_colors.dart';

class AppTypography {

  AppTypography._();

  // Headings
  static TextStyle h1 = GoogleFonts.urbanist(
    fontSize: 96,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.1
  );

  static TextStyle h2 = GoogleFonts.urbanist(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2
  );

  static TextStyle h3 = GoogleFonts.urbanist(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3
  );

  // Subtitles
  static TextStyle subtitle1 = GoogleFonts.urbanist(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4
  );

  static TextStyle subtitle2 = GoogleFonts.urbanist(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5
  );

  static TextStyle bodyMedium = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5
  );

  static TextStyle bodySmall = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5
  );

  // Caption
  static TextStyle caption = GoogleFonts.urbanist(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4
  );

  // Label
  static TextStyle labelLarge = GoogleFonts.urbanist(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4
  );

  static TextStyle labelSmall = GoogleFonts.urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
    height: 1.4
  );

  // SOC / Big Numbers
  static TextStyle socPercentage = GoogleFonts.urbanist(
    fontSize: 128,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -2,
    height: 1
  );

  static TextStyle statValue = GoogleFonts.urbanist(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2
  );

  static TextStyle statLabel = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.3
  );

  static TextStyle statUnit = GoogleFonts.urbanist(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.2
  );

}
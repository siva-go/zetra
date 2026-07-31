import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_shadows.dart';
import 'package:zetra/app/themes/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final List<Color> gradientColors;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.gradientColors = const <Color>[Color(0xFF7B2FF7), Color(0xFF4A90E2)],
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: gradientColors,
              )
            : null,
        color: isEnabled ? null : Colors.white.withValues(alpha: 0.1),
        borderRadius: AppRadius.roundBorder,
        boxShadow: isEnabled ? AppShadows.buttonShadow : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundBorder,
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: AppTypography.labelLarge.copyWith(
                  color: isEnabled ? Colors.white : Colors.white.withValues(alpha: 0.35),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
      ),
    );
  }
}

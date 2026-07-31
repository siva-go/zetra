import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';

class SecondaryButton extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final Color borderColor;
  final Color textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height = 56,
    this.borderColor = AppColors.border,
    this.textColor = AppColors.whiteColor
  });

  @override
  Widget build(BuildContext context) {

    final bool isEnabled = onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isEnabled ? borderColor : borderColor.withValues(
                alpha: 0.3
            ),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundBorder
          ),
          padding: EdgeInsets.zero
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTypography.labelLarge.copyWith(
            color: isEnabled ? textColor : textColor.withValues(
                alpha: 0.35
            ),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4
          )
        )
      )
    );

  }

}
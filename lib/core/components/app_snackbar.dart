import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.surfaceDark,
    Color textColor = Colors.white,
    IconData? icon,
    Color? iconColor,
    Duration duration = const Duration(
        seconds: 3
    )
  }) {

    final SnackBar snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      content: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm - 2
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: AppColors.whiteColor.withValues(
                alpha: 0.1
            )
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(
                  alpha: 0.3
              ),
              blurRadius: 10,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Row(
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                color: iconColor ?? textColor,
                size: 20
              ),
              const SizedBox(
                  width: AppSpacing.xs
              )
            ],
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500
                )
              )
            )
          ]
        )
      )
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

  }

  static void showSuccess(BuildContext context, String message) {

    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF003816),
      textColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.success
    );

  }

  static void showError(BuildContext context, String message) {

    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF38000C),
      textColor: AppColors.error,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error
    );

  }

  static void showWarning(BuildContext context, String message) {

    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF381F00),
      textColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.warning
    );

  }

}
import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/components/primary_button.dart';
import 'package:zetra/core/components/secondary_button.dart';

class AppDialog extends StatelessWidget {

  final String title;
  final String content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;
  final Color iconColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.icon,
    this.iconColor = AppColors.primary
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
    Color iconColor = AppColors.primary,
  }) {

    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.blackColor.withValues(
          alpha: 0.7
      ),
      builder: (BuildContext context) {
        return AppDialog(
          title: title,
          content: content,
          primaryButtonText: primaryButtonText,
          onPrimaryPressed: onPrimaryPressed,
          secondaryButtonText: secondaryButtonText,
          onSecondaryPressed: onSecondaryPressed,
          icon: icon,
          iconColor: iconColor
        );

      }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.xxlBorder,
          border: Border.all(
            color: AppColors.border.withValues(
                alpha: 0.4
            )
          )
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(
                      alpha: 0.1
                  )
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32
                )
              ),
              const SizedBox(
                  height: AppSpacing.sm
              )
            ],
            Text(
              title,
              style: AppTypography.subtitle1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center
            ),
            const SizedBox(
                height: AppSpacing.xs
            ),
            Text(
              content,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary
              ),
              textAlign: TextAlign.center
            ),
            const SizedBox(
                height: AppSpacing.md
            ),
            Row(
              children: <Widget>[
                if (secondaryButtonText != null) ...<Widget>[
                  Expanded(
                    child: SecondaryButton(
                      text: secondaryButtonText!,
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(false)
                    )
                  ),
                  const SizedBox(
                      width: AppSpacing.xs
                  )
                ],
                Expanded(
                  child: PrimaryButton(
                    text: primaryButtonText,
                    onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(true),
                    gradientColors: iconColor == AppColors.error ? const <Color>[Color(0xFFFF073A), Color(0xFFFF7694)]
                        : const <Color>[Color(0xFF7B2FF7), Color(0xFF4A90E2)]
                  )
                )
              ]
            )
          ]
        )
      )
    );

  }

}
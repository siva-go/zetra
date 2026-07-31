import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/components/primary_button.dart';

class AppEmptyState extends StatelessWidget {

  final String title;
  final String description;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: AppColors.textSecondary.withValues(
                  alpha: 0.4
              ),
              size: 72
            ),
            const SizedBox(
                height: AppSpacing.sm
            ),
            Text(
              title,
              style: AppTypography.subtitle1.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center
            ),
            const SizedBox(
                height: AppSpacing.xs
            ),
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary
              ),
              textAlign: TextAlign.center
            ),
            if (buttonText != null && onButtonPressed != null) ...<Widget>[
              const SizedBox(
                  height: AppSpacing.md
              ),
              PrimaryButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                width: 200,
                height: 48
              )
            ]
          ]
        )
      )
    );

  }

}
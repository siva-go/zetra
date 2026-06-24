import 'package:flutter/material.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_spacing.dart';
import '../../app/themes/app_typography.dart';
import 'primary_button.dart';

class AppErrorState extends StatelessWidget {
  final String errorMessage;
  final String? title;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.errorMessage,
    this.title = 'An Error Occurred',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF38000C),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title!,
              style: AppTypography.subtitle1.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                text: 'Retry',
                onPressed: onRetry!,
                width: 150,
                height: 48,
                gradientColors: const [Color(0xFFFF073A), Color(0xFFFF7694)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

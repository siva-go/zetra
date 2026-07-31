import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final Color color;

  const AppLoader({
    super.key,
    this.message,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 3.5,
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

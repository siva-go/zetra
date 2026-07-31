import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_shadows.dart';
import 'package:zetra/app/themes/app_spacing.dart';

class AppCard extends StatelessWidget {

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.sm),
    this.margin,
    this.backgroundColor = AppColors.cardDark,
    this.borderColor = AppColors.border,
    this.borderWidth = 1.0,
    this.width,
    this.height,
    this.shadow
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: borderColor.withValues(
              alpha: 0.3
          ),
          width: borderWidth,
        ),
        boxShadow: shadow ?? AppShadows.cardShadow,
      ),
      child: child
    );

  }

}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zetra/app/themes/app_colors.dart';

class StationMarker extends StatelessWidget {

  final bool isHighlighted;

  const StationMarker({
    super.key,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: isHighlighted ? 36 : 26,
      height: isHighlighted ? 36 : 26,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: isHighlighted ? 36 : 26,
            height: isHighlighted ? 36 : 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(
                alpha: isDark ? 0.18 : 0.12
              )
            )
          ),
          Container(
            width: isHighlighted ? 20 : 14,
            height: isHighlighted ? 20 : 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.7 : 0.5
                  ),
                  blurRadius: isHighlighted ? 12 : 8,
                  spreadRadius: isHighlighted ? 2 : 1
                )
              ]
            ),
            child: Center(
              child: Icon(
                Icons.electric_bolt_rounded,
                color: AppColors.blackColor,
                size: isHighlighted ? 11 : 8
              )
            )
          )
        ]
      )
    ).animate(
      onPlay: (AnimationController controller) => controller.repeat(
          reverse: true
      )
    ).scale(
      begin: const Offset(0.92, 0.92),
      end: const Offset(1, 1),
      duration: 1800.ms,
      curve: Curves.easeInOut
    );

  }

}
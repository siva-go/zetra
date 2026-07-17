import 'package:flutter/material.dart';
import 'package:zetra/app/themes/light/app_light_colors.dart';

class AppLightShadows {

  AppLightShadows._();

  static List<BoxShadow> get card => <BoxShadow>[
    BoxShadow(
      color: const Color(0xFF000000).withValues(
          alpha: 0.06
      ),
      blurRadius: 12,
      offset: const Offset(0, 3)
    ),
    BoxShadow(
      color: const Color(0xFF000000).withValues(
          alpha: 0.03
      ),
        blurRadius: 4,
        offset: const Offset(0, 1)
    )
  ];

  static List<BoxShadow> get greenGlow => <BoxShadow>[
    BoxShadow(
      color: AppLightColors.chargingGreen.withValues(
          alpha: 0.20
      ),
        blurRadius: 10,
        spreadRadius: 1
    )
  ];

  static List<BoxShadow> get redGlow => <BoxShadow>[
    BoxShadow(
      color: AppLightColors.chargingRed.withValues(
          alpha: 0.18
      ),
      blurRadius: 10,
      spreadRadius: 1
    )
  ];

  static List<BoxShadow> get orangeGlow => <BoxShadow>[
    BoxShadow(
      color: AppLightColors.chargingOrange.withValues(
          alpha: 0.18
      ),
      blurRadius: 10,
      spreadRadius: 1
    )
  ];

  static List<BoxShadow> get button => <BoxShadow>[
    BoxShadow(
      color: AppLightColors.buttonGradientStart.withValues(
          alpha: 0.30
      ),
      blurRadius: 16,
      offset: const Offset(0, 6)
    )
  ];

  static List<BoxShadow> get imageFrame => <BoxShadow>[
    BoxShadow(
      color: const Color(0xFF0099CC).withValues(
          alpha: 0.18
      ), // Cyan tint
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 2)
    ),
    BoxShadow(
      color: AppLightColors.accent.withValues(
          alpha: 0.10
      ),
      blurRadius: 20,
      spreadRadius: 1
    )
  ];

}
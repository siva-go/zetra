import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/home/bloc/home_state.dart';

class NearestStationCard extends StatelessWidget {

  final NearestStationData station;
  final VoidCallback onDismiss;
  final VoidCallback onScanQr;
  final bool isDark;

  const NearestStationCard({super.key, required this.station, required this.onDismiss, required this.onScanQr, required this.isDark});

  @override
  Widget build(BuildContext context) {

    final Color cardBg = isDark ? const Color(0xFF141927).withValues(
        alpha: 0.96
    ) : AppColors.whiteColor.withValues(
        alpha: 0.96
    );
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return ClipRRect(
      borderRadius: AppRadius.lgBorder,
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 16,
            sigmaY: 16
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: AppRadius.lgBorder,
            border: Border.all(
              color: isDark ? AppColors.whiteColor.withValues(
                  alpha: 0.08
              ) : AppColors.blackColor.withValues(
                  alpha: 0.07
              )
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.blackColor.withValues(
                  alpha: isDark ? 0.4 : 0.12
                ),
                blurRadius: 24,
                offset: const Offset(0, -4)
              )
            ]
          ),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Nearest Station',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10.sp,
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2
                    )
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 13,
                        color: AppColors.textSecondary
                      )
                    )
                  )
                ]
              ),
              SizedBox(
                  height: 8.h
              ),
              // Station info row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.smBorder,
                      color: AppColors.primary.withValues(
                          alpha: 0.12
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(
                            alpha: 0.3
                        )
                      )
                    ),
                    child: const Icon(
                      Icons.ev_station_rounded,
                      color: AppColors.primary,
                      size: 20
                    )
                  ),
                  SizedBox(
                      width: 10.w
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          station.name,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 13.sp,
                            color: textPrimary,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        SizedBox(
                            height: 2.h
                        ),
                        Text(
                          station.type,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10.sp,
                            color: textSecondary,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                          alpha: 0.12
                      ),
                      borderRadius: AppRadius.roundBorder,
                      border: Border.all(
                        color: AppColors.primary.withValues(
                            alpha: 0.3
                        )
                      )
                    ),
                    child: Text(
                      '${station.availableCount} Available',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 9.5.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3
                      )
                    )
                  )
                ]
              ),
              SizedBox(
                  height: 8.h
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on_rounded,
                    size: 13,
                    color: AppColors.primary
                  ),
                  SizedBox(
                      width: 4.w
                  ),
                  Text(
                    '${station.distanceKm} km away',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.sp,
                      color: textSecondary,
                      fontWeight: FontWeight.w500
                    )
                  )
                ]
              ),
              SizedBox(
                  height: 12.h
              ),
              Container(
                height: 1,
                color: borderColor
              ),
              SizedBox(
                  height: 12.h
              ),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[AppColors.primary, Color(0xFF00A846)]
                    ),
                    borderRadius: AppRadius.roundBorder,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: isDark ? 0.45 : 0.3
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 6)
                      )
                    ]
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundBorder
                      )
                    ),
                    onPressed: () {

                      HapticFeedback.lightImpact();
                      onScanQr();

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.blackColor,
                          size: 18
                        ),
                        SizedBox(
                            width: 8.w
                        ),
                        Text(
                          'Scan QR to Charge',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3
                          )
                        )
                      ]
                    )
                  )
                )
              )
            ]
          )
        )
      )
    )
    .animate()
    .fade(
        delay: 200.ms,
        duration: 400.ms
    )
    .slideY(
        begin: 0.15,
        end: 0,
        curve: Curves.easeOutCubic
    );

  }

}
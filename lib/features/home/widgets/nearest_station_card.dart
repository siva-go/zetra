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

    final Color cardBg = isDark ? const Color(0xFF0D1120).withValues(
        alpha: 0.97
    ) : AppColors.whiteColor.withValues(
        alpha: 0.97
    );
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: isDark ? AppColors.border.withValues(
              alpha: 0.5
          ) : AppColors.borderLight
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(
              alpha: isDark ? 0.5 : 0.14
            ),
            blurRadius: 32,
            offset: const Offset(0, -6)
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 12.w, 0),
            child: Row(
              children: <Widget>[
                Text(
                  'Nearest Station',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 9.5.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4
                  )
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      border: Border.all(
                        color: isDark ? AppColors.border.withValues(
                            alpha: 0.5
                        ) : AppColors.borderLight
                      )
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 13,
                      color: textSecondary
                    )
                  )
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 3.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.smBorder,
                    color: AppColors.primary.withValues(
                        alpha: 0.1
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(
                          alpha: 0.25
                      )
                    )
                  ),
                  child: const Icon(
                    Icons.ev_station_rounded,
                    color: AppColors.primary,
                    size: 22
                  )
                ),
                SizedBox(
                    width: 12.w
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
                          fontWeight: FontWeight.w700,
                          height: 1.2
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
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
                      ),
                      SizedBox(
                          height: 5.h
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: AppColors.primary
                          ),
                          SizedBox(
                              width: 3.w
                          ),
                          Text(
                            '${station.distanceKm} km away',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.sp,
                              color: textSecondary,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          const Spacer(),
                          Text(
                              '${station.availableCount} Available',
                              style: AppTypography.labelSmall.copyWith(
                                  fontSize: 10.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2
                              )
                          )
                        ]
                      )
                    ]
                  )
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
            child: SizedBox(
              width: double.infinity,
              height: 40.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[ Color(0xFF00882E), Color(0xFF006B22)]
                  ),
                  borderRadius: AppRadius.roundBorder,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.4 : 0.3
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 5)
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
                        color: AppColors.whiteColor,
                        size: 18
                      ),
                      SizedBox(
                          width: 8.w
                      ),
                      Text(
                        'Scan QR to Charge',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 13.sp,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        ]
      )
    )
    .animate()
    .fade(
        delay: 150.ms,
        duration: 350.ms
    )
    .slideY(
        begin: 0.12,
        end: 0,
        curve: Curves.easeOutCubic
    );

  }

}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/station/models/station_info.dart';

class StationCard extends StatelessWidget {

  final StationInfo station;
  final VoidCallback? onTap;

  const StationCard({super.key, required this.station, this.onTap});

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.xlBorder,
          border: Border.all(
              color: borderColor
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 13.h,
            horizontal: 10.w
          ),
          child: Row(
            children: <Widget>[
              Image.asset(
                  'assets/images/ic_station_mark.png',
                  height: 45.h
              ),
              SizedBox(
                  width: 6.w
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        station.name,
                        style: AppTypography.bodyLarge.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: textPrimary
                        )
                    ),
                    SizedBox(
                        height: 2.h
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            station.type,
                            style: AppTypography.bodySmall.copyWith(
                                fontSize: 11.sp,
                                color: textSecondary,
                                fontWeight: FontWeight.w500
                            )
                        ),
                        Text(
                            '${station.availableCount.toStringAsFixed(0)} Available',
                            style: AppTypography.bodySmall.copyWith(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                    ),
                    SizedBox(
                        height: 6.h
                    ),
                    Text(
                        '${station.distanceKm} Km',
                        style: AppTypography.bodySmall.copyWith(
                            fontSize: 12.sp,
                            color: textSecondary,
                            fontWeight: FontWeight.w700
                        )
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );

  }

}
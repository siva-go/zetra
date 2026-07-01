import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
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
              color: AppColors.blackColor.withValues(
                  alpha: isDark ? 0.3 : 0.08
              ),
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
                  width: 8.w
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                              Text(
                                  '${station.type} • ${station.address}',
                                  style: AppTypography.bodySmall.copyWith(
                                      fontSize: 11.sp,
                                      color: textSecondary,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis
                              )
                            ]
                          )
                        ),
                        SizedBox(
                            width: 8.w
                        ),
                        InkWell(
                          borderRadius: AppRadius.roundBorder,
                          onTap: () async {

                            final String query = Uri.encodeComponent('${station.name}, ${station.address}');
                            final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                            final Uri appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$query');

                            if (await canLaunchUrl(googleMapsUrl)) {

                              await launchUrl(googleMapsUrl,
                                  mode: LaunchMode.externalApplication
                              );

                            } else if (await canLaunchUrl(appleMapsUrl)) {

                              await launchUrl(appleMapsUrl,
                                  mode: LaunchMode.externalApplication
                              );

                            }

                          },
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                      alpha: 0.6
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1
                                )
                              ]
                            ),
                            child: Icon(
                              Icons.navigation_rounded,
                              color: AppColors.whiteColor,
                              size: 16.sp
                            )
                          )
                        )
                      ]
                    ),
                    SizedBox(
                        height: 4.h
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${station.distanceKm} Km',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12.sp,
                              color: textSecondary,
                              fontWeight: FontWeight.w700
                            )
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
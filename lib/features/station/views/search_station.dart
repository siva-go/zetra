import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_event.dart';
import 'package:zetra/features/station/bloc/search_station_state.dart';
import 'package:zetra/features/station/models/station_info.dart';
import 'package:zetra/features/station/widgets/station_card.dart';

class SearchStationScreen extends StatefulWidget {

  const SearchStationScreen({super.key});

  @override
  State<SearchStationScreen> createState() => _SearchStationScreenState();
}

class _SearchStationScreenState extends State<SearchStationScreen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {

    _searchController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      body: SafeArea(
        child: BlocBuilder<SearchStationBloc, SearchStationState>(
          builder: (BuildContext context, SearchStationState state) {

            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 16,
                          sigmaY: 16
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark.withOpacity(0.88) : AppColors.whiteColor.withOpacity(0.96),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isDark ? AppColors.border : AppColors.borderLight
                          )
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                                width: 14.w
                            ),
                            const Icon(
                                Icons.search_rounded,
                                size: 22,
                                color: AppColors.primary
                            ),
                            SizedBox(
                                width: 10.w
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (String value) {

                                  context.read<SearchStationBloc>().add(SearchStationQueryChanged(value));

                                },
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search location or station',
                                  hintStyle: AppTypography.bodyMedium.copyWith(
                                    fontSize: 14.sp,
                                    color: isDark ? AppColors.textHint : AppColors.textHintLight
                                  )
                                )
                              )
                            ),
                            Container(
                                width: 1,
                                height: 28.h,
                                color: isDark ? AppColors.border :
                                AppColors.borderLight
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
                              )
                            )
                          ]
                        )
                      )
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Stations Near You',
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
                        )
                      ),
                      const Spacer(),
                      Text(
                        '${state.filteredStations.length} results',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
                        )
                      )
                    ]
                  )
                ),
                SizedBox(
                    height: 12.h
                ),
                Expanded(
                  child: state.filteredStations.isEmpty ? Center(
                    child: Text(
                      'No stations found.Try a different location or keyword.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
                      )
                    )
                  ) :
                  ListView.separated(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w
                    ),
                    itemCount: state.filteredStations.length,
                    separatorBuilder: (_, __) => SizedBox(
                        height: 16.h
                    ),
                    itemBuilder: (BuildContext context, int index) {

                      final StationInfo station = state.filteredStations[index];

                      return StationCard(
                        station: station,
                        onTap: () {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Tap action coming soon for ${station.city}'
                              )
                            )
                          );

                        }
                      );

                    }
                  )
                ),
                SizedBox(
                    height: 16.h
                )
              ]
            ).animate().fade(
                duration: 400.ms
            ).slideY(
                begin: 0.02
            );

          }
        )
      )
    );

  }

}
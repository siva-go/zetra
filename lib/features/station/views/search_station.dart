import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_event.dart';
import 'package:zetra/features/station/bloc/search_station_state.dart';
import 'package:zetra/features/station/models/station_info.dart';
import 'package:zetra/features/station/widgets/station_card.dart';

class SearchStation extends StatefulWidget {
  const SearchStation({super.key});

  @override
  State<SearchStation> createState() => _SearchStationState();
}

class _SearchStationState extends State<SearchStation> {

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
                // ── Search Bar ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark.withOpacity(0.88)
                              : AppColors.whiteColor.withOpacity(0.96),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isDark ? AppColors.border : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 14.w),
                            const Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (String value) {
                                  context.read<SearchStationBloc>().add(
                                    SearchStationQueryChanged(value),
                                  );
                                },
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.textPrimaryLight,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context).searchLocationOrStation,
                                  hintStyle: AppTypography.bodyMedium.copyWith(
                                    fontSize: 14.sp,
                                    color: isDark
                                        ? AppColors.textHint
                                        : AppColors.textHintLight,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 28.h,
                              color: isDark ? AppColors.border : AppColors.borderLight,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Header row ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).stationsNearYou,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Spacer(),
                      if (state.status == SearchStationStatus.loaded)
                        Text(
                          AppLocalizations.of(context).resultsCount(state.filteredStations.length.toString()),
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // ── Body ──────────────────────────────────────────────
                Expanded(child: _buildBody(state, isDark, context)),

                SizedBox(height: 16.h),
              ],
            ).animate().fade(duration: 400.ms).slideY(begin: 0.02);
          },
        ),
      ),
    );
  }

  Widget _buildBody(SearchStationState state, bool isDark, BuildContext context) {
    switch (state.status) {
      case SearchStationStatus.loading:
      case SearchStationStatus.initial:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context).findingStationsNearYou,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );

      case SearchStationStatus.error:
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.errorMessage ?? AppLocalizations.of(context).failedToLoadStations,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.whiteColor,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  onPressed: () {
                    context.read<SearchStationBloc>().add(FetchStations());
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    AppLocalizations.of(context).retry,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case SearchStationStatus.loaded:
        if (state.filteredStations.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context).noStationsFound,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: state.filteredStations.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (BuildContext context, int index) {
            final StationInfo station = state.filteredStations[index];
            return StationCard(
              station: station,
              onTap: () {
                context.push('/station-details', extra: station);
              },
            );
          },
        );
    }
  }
}
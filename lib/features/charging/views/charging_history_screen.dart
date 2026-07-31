import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/charging/bloc/charging_history_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_history_event.dart';
import 'package:zetra/features/charging/bloc/charging_history_state.dart';
import 'package:zetra/features/charging/models/session_entry.dart';

/// Dark-themed Charging History screen.
/// Shows past sessions grouped by date, with a period filter dropdown.
class ChargingHistoryScreen extends StatelessWidget {

  const ChargingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: BlocBuilder<ChargingHistoryBloc, ChargingHistoryState>(
          builder: (BuildContext context, ChargingHistoryState state) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs
                  ),
                  child: Row(
                    children: <Widget>[
                      _IconBtn(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => context.go('/home')
                      ),
                      const SizedBox(
                          width: AppSpacing.xs
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).chargingHistory,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: AppColors.whiteColor
                          )
                        )
                      ),
                      const SizedBox(
                          width: AppSpacing.xs
                      ),
                      // Menu icon — placeholder for future actions
                      _IconBtn(
                        icon: Icons.more_vert_rounded,
                        onTap: () {
                          // TODO: show context menu
                        }
                      )
                    ]
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs
                  ),
                  child: _FilterDropdown(
                    value: state.selectedFilter,
                    options: state.filterOptions,
                    onChanged: (String v) => context.read<ChargingHistoryBloc>().add(FilterHistory(v))
                  )
                ),
                const SizedBox(
                    height: AppSpacing.xs
                ),
                Expanded(
                  child: state.status == ChargingHistoryStatus.loading ? const Center(
                      child: CircularProgressIndicator()
                  ) :
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.md),
                    itemCount: state.historyGroups.length,
                    itemBuilder: (BuildContext context, int groupIndex) {

                      final SessionGroup group = state.historyGroups[groupIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppSpacing.sm,
                              bottom: AppSpacing.xs
                            ),
                            child: Text(
                              group.date,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3
                              )
                            )
                          ), ...group.sessions.map(
                                (SessionEntry session) => _SessionCard(
                                    session: session
                                )
                          )
                        ]
                      );

                    }
                  )
                ),
                const ZetraBottomNavBar(
                    
                )
              ]
            );

          }
        )
      )
    );

  }

}

/// Circular icon button used in the app bar.
class _IconBtn extends StatelessWidget {

  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.border.withValues(
                alpha: 0.5
            )
          )
        ),
        child: Icon(
            icon,
            color: AppColors.whiteColor,
            size: 20
        )
      )
    );

  }

}

/// Dropdown button for the session filter (e.g. "This Month").
class _FilterDropdown extends StatelessWidget {

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.smBorder,
        border: Border.all(
          color: AppColors.border.withValues(
              alpha: 0.6
          )
        )
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          dropdownColor: AppColors.cardDark,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 20
          ),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: options.map((String opt) => DropdownMenuItem<String>(
              value: opt,
              child: Text(opt)
          )
          ).toList(),
          onChanged: (String? v) {

            if (v != null) {

              onChanged(v);

            }

          }
        )
      )
    );

  }

}

class _SessionCard extends StatelessWidget {
  final SessionEntry session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(
          bottom: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(
          color: AppColors.border.withValues(
              alpha: 0.5
          )
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(
                alpha: 0.25
            ),
            blurRadius: 8,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.mdBorder,
        child: InkWell(
          borderRadius: AppRadius.mdBorder,
          onTap: () {},
          splashColor: session.iconColor.withValues(
              alpha: 0.08
          ),
          highlightColor: session.iconColor.withValues(
              alpha: 0.04
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm
            ),
            child: Row(
              children: <Widget>[
                // Station icon badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: session.iconColor.withValues(
                        alpha: 0.12
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: session.iconColor.withValues(
                          alpha: 0.3
                      ),
                      width: 1.5
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: session.iconColor.withValues(
                            alpha: 0.25
                        ),
                        blurRadius: 10,
                        spreadRadius: 1
                      )
                    ]
                  ),
                  child: Icon(
                    session.icon,
                    color: session.iconColor,
                    size: 22
                  )
                ),
                const SizedBox(
                    width: AppSpacing.sm
                ),
                // Station name + amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        session.stationName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(
                          height: 4
                      ),
                      Text(
                        session.amountRupees,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                ),
                // Energy + duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      session.energyKwh,
                      style: AppTypography.bodyMedium.copyWith(
                        color: session.iconColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13
                      )
                    ),
                    const SizedBox(
                        height: 4
                    ),
                    Text(
                      session.duration,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        fontFamily: 'monospace'
                      )
                    )
                  ]
                )
              ]
            )
          )
        )
      )
    );

  }

}
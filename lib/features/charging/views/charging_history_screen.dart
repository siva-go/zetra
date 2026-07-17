import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/core/l10n/app_localizations.dart';

import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

// ── Data model ────────────────────────────────────────────────────────────────

/// Represents one past charging session entry in the history list.
class _SessionEntry {
  final String stationName;
  final String energyKwh;
  final String amountRupees;
  final String duration; // HH:MM:SS
  final Color iconColor;
  final IconData icon;

  const _SessionEntry({
    required this.stationName,
    required this.energyKwh,
    required this.amountRupees,
    required this.duration,
    required this.iconColor,
    required this.icon,
  });
}

/// A date-keyed group of session entries.
class _SessionGroup {
  final String date; // e.g. "May 26, 2024"
  final List<_SessionEntry> sessions;

  const _SessionGroup({required this.date, required this.sessions});
}

// ── Mock data ─────────────────────────────────────────────────────────────────

const _mockHistory = [
  _SessionGroup(
    date: 'May 26, 2024',
    sessions: [
      _SessionEntry(
        stationName: 'ZETRA GreenCharge Hub',
        energyKwh: '8.4 kWh',
        amountRupees: '₹ 120.00',
        duration: '00:42:15',
        iconColor: Color(0xFF2EFE58),
        icon: Icons.ev_station_rounded,
      ),
    ],
  ),
  _SessionGroup(
    date: 'May 24, 2024',
    sessions: [
      _SessionEntry(
        stationName: 'ZETRA EcoPower Station',
        energyKwh: '10.2 kWh',
        amountRupees: '₹ 142.00',
        duration: '00:55:10',
        iconColor: Color(0xFF2EFE58),
        icon: Icons.ev_station_rounded,
      ),
    ],
  ),
  _SessionGroup(
    date: 'May 22, 2024',
    sessions: [
      _SessionEntry(
        stationName: 'ZETRA Pulse Station – Ooty',
        energyKwh: '12.6 kWh',
        amountRupees: '₹ 168.00',
        duration: '01:02:33',
        iconColor: Color(0xFF00E5FF),
        icon: Icons.bolt_rounded,
      ),
    ],
  ),
  _SessionGroup(
    date: 'May 18, 2024',
    sessions: [
      _SessionEntry(
        stationName: 'ZETRA GreenCharge Hub',
        energyKwh: '9.1 kWh',
        amountRupees: '₹ 128.00',
        duration: '00:47:22',
        iconColor: Color(0xFF2EFE58),
        icon: Icons.ev_station_rounded,
      ),
    ],
  ),
];

const _filterOptions = ['This Month', 'Last Month', 'Last 3 Months', 'All Time'];

// ── Screen ────────────────────────────────────────────────────────────────────

/// Dark-themed Charging History screen.
/// Shows past sessions grouped by date, with a period filter dropdown.
class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({super.key});

  @override
  State<ChargingHistoryScreen> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen> {
  String _selectedFilter = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  // Back to Home arrow
                  _IconBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => context.go('/home'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).chargingHistory,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // Menu icon — placeholder for future actions
                  _IconBtn(
                    icon: Icons.more_vert_rounded,
                    onTap: () {
                      // TODO: show context menu
                    },
                  ),
                ],
              ),
            ),

            // ── Filter Dropdown ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: _FilterDropdown(
                value: _selectedFilter,
                options: _filterOptions,
                onChanged: (v) => setState(() => _selectedFilter = v),
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // ── Session List ──────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  0,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                itemCount: _mockHistory.length,
                itemBuilder: (context, groupIndex) {
                  final group = _mockHistory[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.sm,
                          bottom: AppSpacing.xs,
                        ),
                        child: Text(
                          group.date,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      // Session cards for this date
                      ...group.sessions.map(
                        (session) => _SessionCard(session: session),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Bottom Nav ────────────────────────────────────────────────────
            const ZetraBottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

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
            color: AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Dropdown button for the session filter (e.g. "This Month").
class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.smBorder,
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
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
            size: 20,
          ),
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(opt),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

/// Card showing a single past charging session.
class _SessionCard extends StatelessWidget {
  final _SessionEntry session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.mdBorder,
        child: InkWell(
          borderRadius: AppRadius.mdBorder,
          onTap: () {
            // Future: navigate to session detail
          },
          splashColor: session.iconColor.withValues(alpha: 0.08),
          highlightColor: session.iconColor.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                // Station icon badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: session.iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: session.iconColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: session.iconColor.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    session.icon,
                    color: session.iconColor,
                    size: 22,
                  ),
                ),

                const SizedBox(width: AppSpacing.sm),

                // Station name + amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.stationName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.amountRupees,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Energy + duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      session.energyKwh,
                      style: AppTypography.bodyMedium.copyWith(
                        color: session.iconColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.duration,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/station/bloc/station_detail_bloc.dart';
import 'package:zetra/features/station/bloc/station_detail_state.dart';
import 'package:zetra/features/station/models/station_detail.dart';
import 'package:zetra/features/station/models/station_info.dart';

class StationDetails extends StatefulWidget {
  final StationInfo station;

  const StationDetails({super.key, required this.station});

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {

  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    final StationInfo s = widget.station;
    print('[ZETRA DEBUG][StationDetails] Screen opened with station:');
    print('  id="${s.id}"');
    print('  name="${s.name}"');
    print('  city="${s.city}"');
    print('  type="${s.type}"');
    print('  address="${s.address}"');
    print('  distanceKm=${s.distanceKm}');
    print('  availableCount=${s.availableCount}');
    print('  connectorCount=${s.connectorCount}');
    print('  pricePerKwh=${s.pricePerKwh}');
    print('  latitude=${s.latitude}');
    print('  longitude=${s.longitude}');
    print('  status="${s.status}"');
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color cardColor = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Top bar ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: <Widget>[
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios,
                    isDark: isDark,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: textPrimary,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  _CircleIconButton(
                    icon: _isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    isDark: isDark,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: _isFavourite ? AppColors.error : textPrimary,
                    onTap: () => setState(() => _isFavourite = !_isFavourite),
                  ),
                ],
              ),
            ),

            // ── Body — reacts to BLoC state ──────────────────────────
            Expanded(
              child: BlocBuilder<StationDetailBloc, StationDetailState>(
                builder: (BuildContext context, StationDetailState detailState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        // ── Station header ───────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.station.name,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${widget.station.type} • ${widget.station.address}',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 13.sp,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.star_rounded, color: AppColors.bolt, size: 16.sp),
                                  SizedBox(width: 3.w),
                                  Text(
                                    '4.8 (250)',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 12.sp,
                                      color: textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppLocalizations.of(context).kmAway(widget.station.distanceKm.toStringAsFixed(1)),
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 13.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/ic_charging_station.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Connector summary row ─────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).availableConnectors,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${_resolvedAvailable(detailState)}',
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / ${_resolvedTotal(detailState)}',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Chargers section ──────────────────────────
                        _buildChargersSection(
                          detailState,
                          isDark,
                          cardColor,
                          textPrimary,
                          textSecondary,
                          borderColor,
                          surfaceColor,
                        ),

                        SizedBox(height: 20.h),

                        // ── Info rows (pricing / timing) ─────────────
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: AppRadius.lgBorder,
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            children: <Widget>[
                              _DetailRow(
                                icon: Icons.currency_rupee_rounded,
                                label: AppLocalizations.of(context).pricing,
                                value: widget.station.pricePerKwh > 0
                                    ? AppLocalizations.of(context).pricePerKwh(
                                        widget.station.pricePerKwh.toStringAsFixed(0))
                                    : '—',
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                borderColor: borderColor,
                                showDivider: true,
                              ),
                              _DetailRow(
                                icon: Icons.access_time_rounded,
                                label: AppLocalizations.of(context).stationTimings,
                                value: AppLocalizations.of(context).alwaysOpen,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                borderColor: borderColor,
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ── Start Charging CTA ────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.roundBorder,
                                gradient: const LinearGradient(
                                  colors: <Color>[Color(0xFF00C853), Color(0xFF009624)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: isDark ? 0.65 : 0.45),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.bolt_rounded, size: 22.sp, color: AppColors.whiteColor),
                                label: Text(
                                  AppLocalizations.of(context).startCharging,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: AppColors.whiteColor,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.roundBorder,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────────

  int _resolvedAvailable(StationDetailState s) {
    if (s.status == StationDetailStatus.loaded && s.detail != null) {
      return s.detail!.availableConnectors;
    }
    return widget.station.availableCount;
  }

  int _resolvedTotal(StationDetailState s) {
    if (s.status == StationDetailStatus.loaded && s.detail != null) {
      return s.detail!.totalConnectors;
    }
    return widget.station.connectorCount;
  }

  Widget _buildChargersSection(
    StationDetailState detailState,
    bool isDark,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
  ) {
    if (detailState.status == StationDetailStatus.loading ||
        detailState.status == StationDetailStatus.initial) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Loading charger details…',
              style: AppTypography.bodySmall.copyWith(color: textSecondary),
            ),
          ],
        ),
      );
    }

    if (detailState.status == StationDetailStatus.error) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Text(
          detailState.errorMessage ?? 'Failed to load charger details.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
        ),
      );
    }

    final StationDetail? detail = detailState.detail;
    if (detail == null || detail.chargers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Text(
          'No chargers available at this station.',
          style: AppTypography.bodySmall.copyWith(color: textSecondary),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
            child: Text(
              'Chargers (${detail.chargers.length})',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          ...detail.chargers.map(
            (Charger charger) => _ChargerCard(
              charger: charger,
              isDark: isDark,
              cardColor: cardColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              borderColor: borderColor,
              surfaceColor: surfaceColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Charger card widget ───────────────────────────────────────────────────────

class _ChargerCard extends StatelessWidget {
  final Charger charger;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final Color surfaceColor;

  const _ChargerCard({
    required this.charger,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool online = charger.isOnline;
    final Color statusColor = online ? AppColors.primary : AppColors.error;
    final String statusLabel = online ? 'Online' : 'Offline';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ── Charger header ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
            child: Row(
              children: <Widget>[
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: AppRadius.smBorder,
                  ),
                  child: Icon(Icons.ev_station_rounded, color: AppColors.primary, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        charger.name?.isNotEmpty == true
                            ? charger.name!
                            : charger.chargePointId,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        charger.chargePointId,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.sp,
                          color: textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // ── Status badge ──────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        statusLabel,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // ── Connectors list ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
            child: Column(
              children: charger.connectors.asMap().entries.map(
                (MapEntry<int, ChargerConnector> entry) {
                  final ChargerConnector connector = entry.value;
                  final bool avail = connector.isAvailable;
                  final Color connColor = avail ? AppColors.primary : textSecondary;

                  return Padding(
                    padding: EdgeInsets.only(bottom: entry.key < charger.connectors.length - 1 ? 8.h : 0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.electrical_services_rounded,
                          size: 16.sp,
                          color: connColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'C${connector.connectorId}  •  ${connector.type}',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12.sp,
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (connector.maxPowerKw != null) ...<Widget>[
                          SizedBox(width: 6.w),
                          Text(
                            '${connector.maxPowerKw!.toStringAsFixed(0)} kW',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.sp,
                              color: textSecondary,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: connColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            connector.status,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: connColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {

  final IconData icon;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.roundBorder,
      onTap: onTap,
      child: SizedBox(
        width: 40.w,
        height: 40.w,
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {

  final IconData icon;
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final bool showDivider;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: <Widget>[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smBorder,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.sp,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: borderColor, indent: 16.w, endIndent: 16.w),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
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
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color cardColor = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    const List<_ConnectorType> connectors = <_ConnectorType>[
      _ConnectorType(
          label: 'CCS2',
          count: 5
      ),
      _ConnectorType(
          label: 'CHAdeMO',
          count: 2
      ),
      _ConnectorType(
          label: 'Type 2',
          count: 1
      )
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h
              ),
              child: Row(
                children: <Widget>[
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios,
                    isDark: isDark,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: textPrimary,
                    onTap: () => Navigator.of(context).maybePop()
                  ),
                  const Spacer(),
                  _CircleIconButton(
                    icon: _isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    isDark: isDark,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: _isFavourite ? AppColors.error : textPrimary,
                    onTap: () => setState(() => _isFavourite = !_isFavourite)
                  )
                ]
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: 32.h
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.station.name,
                            style: AppTypography.bodyLarge.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              height: 1.2
                            )
                          ),
                          SizedBox(
                              height: 2.h
                          ),
                          Text(
                              '${widget.station.type} • ${widget.station.address}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13.sp,
                              color: textSecondary,
                              fontWeight: FontWeight.w400
                            )
                          ),
                          SizedBox(
                              height: 5.h
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                      Icons.star_rounded,
                                      color: AppColors.bolt,
                                      size: 16.sp
                                  ),
                                  SizedBox(
                                      width: 3.w
                                  ),
                                  Text(
                                    '4.8 (250)',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 12.sp,
                                      color: textPrimary,
                                      fontWeight: FontWeight.w700
                                    )
                                  )
                                ]
                              )
                            ]
                          ),
                          SizedBox(
                              height: 4.h
                          ),
                          Text(
                            AppLocalizations.of(context).kmAway(widget.station.distanceKm.toStringAsFixed(1)),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w400
                            )
                          )
                        ]
                      )
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/ic_charging_station.png',
                        fit: BoxFit.cover
                      )
                    ),
                    SizedBox(
                        height: 16.h
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).availableConnectors,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary
                                )
                              ),
                              const Spacer(),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${widget.station.availableCount}',
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary
                                      )
                                    ),
                                    TextSpan(
                                      text: ' / ${widget.station.connectorCount}',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textSecondary
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          ),
                          SizedBox(
                              height: 12.h
                          ),
                          Row(
                            children: List<Widget>.generate(
                              connectors.length,
                              (int i) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: i < connectors.length - 1 ? 10.w : 0
                                  ),
                                  child: _ConnectorChip(
                                    type: connectors[i],
                                    cardColor: cardColor,
                                    borderColor: borderColor,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    surfaceColor: surfaceColor
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    ),
                    SizedBox(
                        height: 16.h
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 8.w
                      ),
                      decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.lgBorder,
                          border: Border.all(
                              color: borderColor
                          )
                      ),
                      child: Column(
                        children: <Widget>[
                          _DetailRow(
                              icon: Icons.currency_rupee_rounded,
                              label: AppLocalizations.of(context).pricing,
                              value: AppLocalizations.of(context).pricePerKwh(widget.station.pricePerKwh.toStringAsFixed(0)),
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              borderColor: borderColor,
                              showDivider: true
                          ),
                          _DetailRow(
                              icon: Icons.access_time_rounded,
                              label: AppLocalizations.of(context).stationTimings,
                              value: AppLocalizations.of(context).alwaysOpen,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              borderColor: borderColor,
                              showDivider: false
                          )
                        ]
                      )
                    ),
                    SizedBox(
                        height: 24.h
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.roundBorder,
                            gradient: const LinearGradient(
                              colors: <Color>[Color(0xFF00C853), Color(0xFF009624)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                    alpha: isDark ? 0.65 : 0.45
                                ),
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: const Offset(0, 5)
                              )
                            ]
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                                Icons.bolt_rounded,
                                size: 22.sp,
                                color: AppColors.whiteColor
                            ),
                            label: Text(
                              AppLocalizations.of(context).startCharging,
                              style: AppTypography.bodyLarge.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor
                              )
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.whiteColor,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.roundBorder
                              )
                            )
                          )
                        )
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );

  }

}

class _CircleIconButton extends StatelessWidget {

  final IconData icon;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.isDark, required this.cardColor, required this.borderColor, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: AppRadius.roundBorder,
      onTap: onTap,
      child: SizedBox(
        width: 40.w,
        height: 40.w,
        child: Icon(
            icon,
            color: iconColor,
            size: 20.sp
        )
      )
    );

  }

}

class _ConnectorType {

  final String label;
  final int count;
  const _ConnectorType({required this.label, required this.count});
}

class _ConnectorChip extends StatelessWidget {

  final _ConnectorType type;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color surfaceColor;

  const _ConnectorChip({required this.type, required this.cardColor, required this.borderColor, required this.textPrimary, required this.textSecondary, required this.surfaceColor});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 12.h
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                  alpha: 0.12
              ),
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(
                      alpha: 0.35
                  ),
                  blurRadius: 10,
                  spreadRadius: 1
                )
              ]
            ),
            child: Icon(
              Icons.electrical_services_rounded,
              color: AppColors.primary,
              size: 20.sp
            )
          ),
          SizedBox(
              height: 6.h
          ),
          Text(
            type.label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11.sp,
              color: textSecondary,
              fontWeight: FontWeight.w500
            )
          ),
          SizedBox(
              height: 2.h
          ),
          Text(
            '${type.count}',
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary
            )
          )
        ]
      )
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

  const _DetailRow({required this.icon, required this.label, required this.value, required this.textPrimary, required this.textSecondary, required this.borderColor, required this.showDivider});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                      alpha: 0.12
                  ),
                  borderRadius: AppRadius.smBorder
                ),
                child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 18.sp
                )
              ),
              SizedBox(
                  width: 12.w
              ),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.sp,
                  color: textSecondary,
                  fontWeight: FontWeight.w500
                )
              ),
              const Spacer(),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary
                )
              )
            ]
          )
        ),
        if (showDivider)
          Divider(
              height: 1,
              color: borderColor,
              indent: 16.w,
              endIndent: 16.w
          )
      ]
    );

  }

}
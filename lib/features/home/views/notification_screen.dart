import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';

enum _NotifType { pluggedIn, chargingStarted, lowBalance, chargingCompleted, newOffer }

class _NotifItem {
  final _NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const _NotifItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isUnread = false
  });

}

class NotificationScreen extends StatelessWidget {

  const NotificationScreen({super.key});

  static const List<_NotifItem> _notifications = <_NotifItem>[
    _NotifItem(
      type: _NotifType.pluggedIn,
      title: 'Plugged In',
      body: 'Vehicle connected successfully.',
      time: '10:45 AM',
      isUnread: true
    ),
    _NotifItem(
      type: _NotifType.chargingStarted,
      title: 'Charging Started',
      body: 'Your charging session has started.',
      time: '10:46 AM',
      isUnread: true
    ),
    _NotifItem(
      type: _NotifType.lowBalance,
      title: 'Low Balance',
      body: 'Your wallet balance is low.',
      time: 'Yesterday'
    ),
    _NotifItem(
      type: _NotifType.chargingCompleted,
      title: 'Charging Completed',
      body: 'Session completed at ZETRA Hub.',
      time: 'Yesterday'
    ),
    _NotifItem(
      type: _NotifType.newOffer,
      title: 'New Offer',
      body: 'Get 10% cashback on your next 3 sessions!',
      time: '2d ago'
    )
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm
              ),
              child: Row(
                children: <Widget>[
                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border.withValues(
                              alpha: 0.5
                          )
                        )
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.whiteColor,
                        size: 16
                      )
                    )
                  ),
                  const SizedBox(
                      width: AppSpacing.sm
                  ),
                  Text(
                    AppLocalizations.of(context).notifications,
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.whiteColor
                    )
                  ),
                  const Spacer(),
                  // Bell icon with glow
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border.withValues(
                            alpha: 0.4
                        )
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.chargingGreenGlow.withValues(
                              alpha: 0.2
                          ),
                          blurRadius: 12,
                          spreadRadius: 1
                        )
                      ]
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.chargingGreenGlow,
                      size: 20
                    )
                  )
                ]
              )
            ),
            // ── Notification List ─────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs
                ),
                itemCount: _notifications.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                    height: AppSpacing.sm
                ),
                itemBuilder: (BuildContext context, int index) {

                  return _NotifCard(
                      item: _notifications[index]
                  );

                }
              )
            ),
            // ── Bottom Nav ────────────────────────────────────────────────
            const ZetraBottomNavBar(
                currentIndex: 3
            )
          ]
        )
      )
    );

  }

}

class _NotifContent {

  final String title;
  final String body;
  const _NotifContent({required this.title, required this.body});

}

_NotifContent _localizeNotification(BuildContext context, _NotifType type) {

  switch (type) {

  case _NotifType.pluggedIn:
      return _NotifContent(
        title: AppLocalizations.of(context).pluggedIn,
        body: AppLocalizations.of(context).vehicleConnectedSuccess
      );
    case _NotifType.chargingStarted:
      return _NotifContent(
        title: AppLocalizations.of(context).chargingStarted,
        body: AppLocalizations.of(context).sessionHasStarted
      );
    case _NotifType.lowBalance:
      return _NotifContent(
        title: AppLocalizations.of(context).lowBalance,
        body: AppLocalizations.of(context).walletBalanceIsLow
      );
    case _NotifType.chargingCompleted:
      return _NotifContent(
        title: AppLocalizations.of(context).chargingCompleted,
        body: AppLocalizations.of(context).sessionCompletedAt
      );
    case _NotifType.newOffer:
      return _NotifContent(
        title: AppLocalizations.of(context).newOffer,
        body: AppLocalizations.of(context).offerCashbackBody
      );

  }

}

// ── Notification Card ─────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {

  final _NotifItem item;

  const _NotifCard({required this.item});

  static _IconStyle _resolveStyle(_NotifType type) {

    switch (type) {

      case _NotifType.pluggedIn:
        return const _IconStyle(
          icon: Icons.ev_station_rounded,
          iconColor: AppColors.chargingGreenGlow,
          glowColor: AppColors.chargingGreenGlow,
          bgColor: Color(0xFF0A2A1A),
          borderColor: AppColors.chargingGreenGlow
        );
      case _NotifType.chargingStarted:
        return const _IconStyle(
          icon: Icons.electric_bolt_rounded,
          iconColor: AppColors.chargingGreenGlow,
          glowColor: AppColors.chargingGreenGlow,
          bgColor: Color(0xFF0A2A1A),
          borderColor: AppColors.chargingGreenGlow
        );
      case _NotifType.lowBalance:
        return const _IconStyle(
          icon: Icons.warning_rounded,
          iconColor: AppColors.chargingRedGlow,
          glowColor: AppColors.chargingRedGlow,
          bgColor: Color(0xFF2A0A0A),
          borderColor: AppColors.chargingRedGlow
        );
      case _NotifType.chargingCompleted:
        return const _IconStyle(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.chargingGreenGlow,
          glowColor: AppColors.chargingGreenGlow,
          bgColor: Color(0xFF0A2A1A),
          borderColor: AppColors.chargingGreenGlow
        );
      case _NotifType.newOffer:
        return const _IconStyle(
          icon: Icons.card_giftcard_rounded,
          iconColor: AppColors.chargingOrangeGlow,
          glowColor: AppColors.chargingOrangeGlow,
          bgColor: Color(0xFF2A1A0A),
          borderColor: AppColors.chargingOrangeGlow
        );

    }

  }

  @override
  Widget build(BuildContext context) {

    final _IconStyle style = _resolveStyle(item.type);
    final bool isLowBalance = item.type == _NotifType.lowBalance;
    final _NotifContent localized = _localizeNotification(context, item.type);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: isLowBalance ? AppColors.chargingRedGlow.withValues(
              alpha: 0.3
          ) : AppColors.border.withValues(
              alpha: 0.4
          )
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: style.glowColor.withValues(
                alpha: 0.06
            ),
            blurRadius: 12,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Neon icon badge
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: style.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: style.borderColor.withValues(
                    alpha: 0.55
                ),
                width: 1.5
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: style.glowColor.withValues(
                      alpha: 0.3
                  ),
                  blurRadius: 10,
                  spreadRadius: 1
                )
              ]
            ),
            child: Icon(
                style.icon,
                color: style.iconColor,
                size: 22
            )
          ),
          const SizedBox(
              width: AppSpacing.sm
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        localized.title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isLowBalance ? AppColors.chargingRedGlow : AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14
                        )
                      )
                    ),
                    Text(
                      item.time,
                      style: AppTypography.bodySmall.copyWith(
                        color: isLowBalance ? AppColors.chargingRedGlow : AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: isLowBalance ? FontWeight.w600 : FontWeight.w400
                      )
                    )
                  ]
                ),
                const SizedBox(
                    height: 4
                ),
                Text(
                  localized.body,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4
                  )
                )
              ]
            )
          )
        ]
      )
    );

  }

}

// ── Icon style helper ─────────────────────────────────────────────────────────
class _IconStyle {

  final IconData icon;
  final Color iconColor;
  final Color glowColor;
  final Color bgColor;
  final Color borderColor;

  const _IconStyle({
    required this.icon,
    required this.iconColor,
    required this.glowColor,
    required this.bgColor,
    required this.borderColor
  });

}
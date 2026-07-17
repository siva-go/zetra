import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/core/l10n/app_localizations.dart';

import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../app/themes/light/app_light_colors.dart';
import '../../../../app/themes/light/app_light_shadows.dart';
import '../../../../core/widgets/light_bottom_nav_bar.dart';

// ── Notification data model ───────────────────────────────────────────────────
enum _NotifType { pluggedIn, chargingStarted, lowBalance, chargingCompleted, newOffer }

class _NotifItem {
  final _NotifType type;
  final String title;
  final String body;
  final String time;

  const _NotifItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
  });
}

/// Light-themed Notification screen matching the provided mockup.
/// Uses [AppLightColors] and [AppLightShadows] from the light theme folder.
class NotificationScreenLight extends StatelessWidget {
  const NotificationScreenLight({super.key});

  static const List<_NotifItem> _notifications = [
    _NotifItem(
      type: _NotifType.pluggedIn,
      title: 'Plugged In',
      body: 'Vehicle connected successfully.',
      time: '10:45 AM',
    ),
    _NotifItem(
      type: _NotifType.chargingStarted,
      title: 'Charging Started',
      body: 'Your charging session has started.',
      time: '10:46 AM',
    ),
    _NotifItem(
      type: _NotifType.lowBalance,
      title: 'Low Balance',
      body: 'Your wallet balance is low.',
      time: 'Yesterday',
    ),
    _NotifItem(
      type: _NotifType.chargingCompleted,
      title: 'Charging Completed',
      body: 'Session completed at GreenCharge Hub.',
      time: 'Yesterday',
    ),
    _NotifItem(
      type: _NotifType.newOffer,
      title: 'New Offer',
      body: 'Get 10% cashback on your next 3 sessions!',
      time: '2d ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppLightColors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppLightColors.border),
                        boxShadow: AppLightShadows.card,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppLightColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppLocalizations.of(context).notifications,
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppLightColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Bell icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppLightColors.card,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppLightColors.border),
                      boxShadow: AppLightShadows.card,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppLightColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ── Notification List ─────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                itemCount: _notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return _LightNotifCard(item: _notifications[index]);
                },
              ),
            ),

            // ── Bottom Nav ────────────────────────────────────────────────
            ZetraLightBottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) context.go('/home');
              },
            ),
          ],
        ),
      ),
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
        body: AppLocalizations.of(context).vehicleConnectedSuccess,
      );
    case _NotifType.chargingStarted:
      return _NotifContent(
        title: AppLocalizations.of(context).chargingStarted,
        body: AppLocalizations.of(context).sessionHasStarted,
      );
    case _NotifType.lowBalance:
      return _NotifContent(
        title: AppLocalizations.of(context).lowBalance,
        body: AppLocalizations.of(context).walletBalanceIsLow,
      );
    case _NotifType.chargingCompleted:
      return _NotifContent(
        title: AppLocalizations.of(context).chargingCompleted,
        body: AppLocalizations.of(context).sessionCompletedAt,
      );
    case _NotifType.newOffer:
      return _NotifContent(
        title: AppLocalizations.of(context).newOffer,
        body: AppLocalizations.of(context).offerCashbackBody,
      );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────
class _LightNotifCard extends StatelessWidget {
  final _NotifItem item;
  const _LightNotifCard({required this.item});

  static _IconStyle _resolveStyle(_NotifType type) {
    switch (type) {
      case _NotifType.pluggedIn:
        return const _IconStyle(
          icon: Icons.ev_station_rounded,
          iconColor: AppLightColors.chargingGreen,
          bgColor: AppLightColors.chargingGreenBg,
          borderColor: AppLightColors.chargingGreen,
          isGreen: true,
        );
      case _NotifType.chargingStarted:
        return const _IconStyle(
          icon: Icons.electric_bolt_rounded,
          iconColor: AppLightColors.chargingGreen,
          bgColor: AppLightColors.chargingGreenBg,
          borderColor: AppLightColors.chargingGreen,
          isGreen: true,
        );
      case _NotifType.lowBalance:
        return const _IconStyle(
          icon: Icons.warning_rounded,
          iconColor: AppLightColors.chargingRed,
          bgColor: AppLightColors.chargingRedBg,
          borderColor: AppLightColors.chargingRed,
          isGreen: false,
        );
      case _NotifType.chargingCompleted:
        return const _IconStyle(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppLightColors.chargingGreen,
          bgColor: AppLightColors.chargingGreenBg,
          borderColor: AppLightColors.chargingGreen,
          isGreen: true,
        );
      case _NotifType.newOffer:
        return const _IconStyle(
          icon: Icons.card_giftcard_rounded,
          iconColor: AppLightColors.chargingOrange,
          bgColor: AppLightColors.chargingOrangeBg,
          borderColor: AppLightColors.chargingOrange,
          isGreen: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(item.type);
    final isLowBalance = item.type == _NotifType.lowBalance;
    final localized = _localizeNotification(context, item.type);

    // Low-balance card gets a very subtle pinkish tint
    final cardBg = isLowBalance
        ? const Color(0xFFFFF5F5)
        : AppLightColors.card;
    final cardBorder = isLowBalance
        ? AppLightColors.chargingRed.withValues(alpha: 0.25)
        : AppLightColors.border;

    final glowShadow = isLowBalance
        ? AppLightShadows.redGlow
        : style.isGreen
            ? AppLightShadows.greenGlow
            : AppLightShadows.orangeGlow;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: [
          ...AppLightShadows.card,
          ...glowShadow,
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: style.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: style.borderColor.withValues(alpha: 0.45),
                width: 1.5,
              ),
            ),
            child: Icon(style.icon, color: style.iconColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        localized.title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isLowBalance
                              ? AppLightColors.chargingRed
                              : AppLightColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: AppTypography.bodySmall.copyWith(
                        color: isLowBalance
                            ? AppLightColors.chargingRed
                            : AppLightColors.textTertiary,
                        fontSize: 11,
                        fontWeight:
                            isLowBalance ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  localized.body,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppLightColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Icon style helper ─────────────────────────────────────────────────────────
class _IconStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final bool isGreen;

  const _IconStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.isGreen,
  });
}

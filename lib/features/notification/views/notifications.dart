import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/app/themes/light/app_light_colors.dart';
import 'package:zetra/app/themes/light/app_light_shadows.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/notification/bloc/notification_bloc.dart';
import 'package:zetra/features/notification/bloc/notification_event.dart';
import 'package:zetra/features/notification/bloc/notification_state.dart';
import 'package:zetra/features/notification/models/notification_model.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NotificationBloc>().add(const NotificationInitialized());

  }

  @override
  void dispose() {

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();

  }

  void _onScroll() {

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {

      context.read<NotificationBloc>().add(const NotificationLoadMoreRequested());

    }

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? AppColors.scaffoldDark : AppLightColors.scaffold,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark
      )
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppLightColors.scaffold,
      body: SafeArea(
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (BuildContext context, NotificationState state) {

            if (state.status == NotificationStatus.error && state.errorMessage != null && state.notifications.isNotEmpty) {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: isDark ? AppColors.chargingRedGlow : AppLightColors.chargingRed
                )
              );

            }

          },
          builder: (BuildContext context, NotificationState state) {

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm
                  ),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : AppLightColors.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.border.withValues(
                                  alpha: 0.5
                              ) : AppLightColors.border
                            ),
                            boxShadow: isDark ? null : AppLightShadows.card
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isDark ? AppColors.whiteColor : AppLightColors.textPrimary,
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
                          color: isDark ? AppColors.whiteColor : AppLightColors.textPrimary
                        )
                      ),
                      const Spacer(),
                      // Mark all read button or Bell icon
                      if (state.unreadCount > 0)
                        GestureDetector(
                          onTap: () {

                            context.read<NotificationBloc>().add(
                              const NotificationMarkAllReadRequested()
                            );

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 6
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : AppLightColors.card,
                              borderRadius: AppRadius.mdBorder,
                              border: Border.all(
                                color: (isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen).withValues(
                                    alpha: 0.4
                                )
                              ),
                              boxShadow: isDark ? null : AppLightShadows.card
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.done_all_rounded,
                                  color: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen,
                                  size: 14
                                ),
                                const SizedBox(
                                    width: 4
                                ),
                                Text(
                                  'Mark all read',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ]
                            )
                          )
                        )
                      else
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : AppLightColors.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.border.withValues(
                                  alpha: 0.4
                              ) : AppLightColors.border,
                            ),
                            boxShadow: isDark ? <BoxShadow>[
                              BoxShadow(
                                color: AppColors.chargingGreenGlow.withValues(
                                    alpha: 0.2
                                ),
                                blurRadius: 12,
                                spreadRadius: 1
                              )
                            ] : AppLightShadows.card,
                          ),
                          child: Icon(
                            isDark ? Icons.notifications_active_outlined : Icons.notifications_outlined,
                            color: isDark ? AppColors.chargingGreenGlow : AppLightColors.textPrimary,
                            size: 20
                          )
                        )
                    ]
                  )
                ),
                _CategoryFilterBar(
                  selectedCategory: state.selectedCategory,
                  isDark: isDark
                ),
                const SizedBox(
                    height: AppSpacing.xs
                ),
                Expanded(
                  child: _buildBody(context, state, isDark)
                ),
                const ZetraBottomNavBar(
                    currentIndex: 3
                )
              ]
            );

          }
        )
      )
    );

  }

  Widget _buildBody(BuildContext context, NotificationState state, bool isDark) {

    if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {

      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen
        )
      );

    }

    if (state.status == NotificationStatus.error && state.notifications.isEmpty) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              color: isDark ? AppColors.chargingRedGlow : AppLightColors.chargingRed,
              size: 40
            ),
            const SizedBox(
                height: AppSpacing.sm
            ),
            Text(
              state.errorMessage ?? 'Failed to load notifications',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondary : AppLightColors.textSecondary
              )
            ),
            const SizedBox(
                height: AppSpacing.md
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen,
                foregroundColor: isDark ? AppColors.blackColor : AppLightColors.card
              ),
              onPressed: () {

                context.read<NotificationBloc>().add(
                  const NotificationLoadRequested()
                );

              },
              child: const Text('Retry')
            )
          ]
        )
      );

    }

    if (state.notifications.isEmpty) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off_outlined,
              color: (isDark ? AppColors.textTertiary : AppLightColors.textTertiary).withValues(
                  alpha: 0.5
              ),
              size: 48
            ),
            const SizedBox(
                height: AppSpacing.sm
            ),
            Text(
              'No notifications found',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondary : AppLightColors.textSecondary
              )
            )
          ]
        )
      );

    }

    return RefreshIndicator(
      color: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen,
      backgroundColor: isDark ? AppColors.cardDark : AppLightColors.card,
      onRefresh: () async {

        context.read<NotificationBloc>().add(
          const NotificationLoadRequested()
        );

      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs
        ),
        itemCount: state.notifications.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: AppSpacing.sm
        ),
        itemBuilder: (BuildContext context, int index) {

          if (index >= state.notifications.length) {

            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen
                )
              )
            );

          }

          final NotificationModel item = state.notifications[index];

          return _NotifCard(
              item: item,
              isDark: isDark
          );

        }
      )
    );

  }

}

class _CategoryFilterBar extends StatelessWidget {

  final String? selectedCategory;
  final bool isDark;

  const _CategoryFilterBar({required this.selectedCategory, required this.isDark});

  static const List<Map<String, String?>> _categories = <Map<String, String?>>[
    <String, String?>{'label': 'All', 'value': null},
    <String, String?>{'label': 'Charging', 'value': 'CHARGING'},
    <String, String?>{'label': 'Offers', 'value': 'OFFER'},
    <String, String?>{'label': 'Wallet', 'value': 'WALLET'},
    <String, String?>{'label': 'Payment', 'value': 'PAYMENT'},
    <String, String?>{'label': 'System', 'value': 'SYSTEM'}
  ];

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md
        ),
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: AppSpacing.xs
        ),
        itemBuilder: (BuildContext context, int index) {

          final Map<String, String?> category = _categories[index];
          final bool isSelected = selectedCategory == category['value'];
          final Color activeBg = isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen;
          final Color inactiveBg = isDark ? AppColors.cardDark : AppLightColors.card;
          final Color activeBorder = isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen;
          final Color inactiveBorder = isDark ? AppColors.border.withValues(
              alpha: 0.4
          ) : AppLightColors.border;
          final Color activeTextColor = isDark ? AppColors.blackColor : AppLightColors.card;
          final Color inactiveTextColor = isDark ? AppColors.whiteColor : AppLightColors.textSecondary;

          return GestureDetector(
            onTap: () {

              context.read<NotificationBloc>().add(
                NotificationCategorySelected(category['value'])
              );

            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8
              ),
              decoration: BoxDecoration(
                color: isSelected ? activeBg : inactiveBg,
                borderRadius: AppRadius.roundBorder,
                border: Border.all(
                  color: isSelected ? activeBorder : inactiveBorder
                ),
                boxShadow: isDark ? null : (isSelected ? AppLightShadows.greenGlow : AppLightShadows.card)
              ),
              child: Text(
                category['label']!,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? activeTextColor : inactiveTextColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12
                )
              )
            )
          );

        }
      )
    );

  }

}

class _NotifCard extends StatelessWidget {

  final NotificationModel item;
  final bool isDark;

  const _NotifCard({required this.item, required this.isDark});

  static _IconStyle _resolveStyle(String category, bool isDark, {bool isLowBalance = false}) {

    if (isDark) {

      if (isLowBalance) {

        return const _IconStyle(
          icon: Icons.warning_rounded,
          iconColor: AppColors.chargingRedGlow,
          glowColor: AppColors.chargingRedGlow,
          bgColor: Color(0xFF2A0A0A),
          borderColor: AppColors.chargingRedGlow
        );

      }

      switch (category.toUpperCase()) {

        case 'CHARGING':
          return const _IconStyle(
            icon: Icons.electric_bolt_rounded,
            iconColor: AppColors.chargingGreenGlow,
            glowColor: AppColors.chargingGreenGlow,
            bgColor: Color(0xFF0A2A1A),
            borderColor: AppColors.chargingGreenGlow
          );
        case 'OFFER':
          return const _IconStyle(
            icon: Icons.card_giftcard_rounded,
            iconColor: AppColors.chargingOrangeGlow,
            glowColor: AppColors.chargingOrangeGlow,
            bgColor: Color(0xFF2A1A0A),
            borderColor: AppColors.chargingOrangeGlow
          );
        case 'WALLET':
        case 'PAYMENT':
          return const _IconStyle(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.info,
            glowColor: AppColors.info,
            bgColor: Color(0xFF0A2A2A),
            borderColor: AppColors.info
          );
        case 'SYSTEM':
        default:
          return const _IconStyle(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.whiteColor,
            glowColor: AppColors.whiteColor,
            bgColor: Color(0xFF1E2530),
            borderColor: AppColors.textTertiary
          );
      }

    } else {

      if (isLowBalance) {

        return _IconStyle(
          icon: Icons.warning_rounded,
          iconColor: AppLightColors.chargingRed,
          glowColor: AppLightColors.chargingRed,
          bgColor: AppLightColors.chargingRedBg,
          borderColor: AppLightColors.chargingRed,
          lightGlowShadow: AppLightShadows.redGlow
        );

      }

      switch (category.toUpperCase()) {

        case 'CHARGING':
          return _IconStyle(
            icon: Icons.electric_bolt_rounded,
            iconColor: AppLightColors.chargingGreen,
            glowColor: AppLightColors.chargingGreen,
            bgColor: AppLightColors.chargingGreenBg,
            borderColor: AppLightColors.chargingGreen,
            lightGlowShadow: AppLightShadows.greenGlow
          );
        case 'OFFER':
          return _IconStyle(
            icon: Icons.card_giftcard_rounded,
            iconColor: AppLightColors.chargingOrange,
            glowColor: AppLightColors.chargingOrange,
            bgColor: AppLightColors.chargingOrangeBg,
            borderColor: AppLightColors.chargingOrange,
            lightGlowShadow: AppLightShadows.orangeGlow
          );
        case 'WALLET':
          return const _IconStyle(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Color(0xFF0284C7),
            glowColor: Color(0xFF0284C7),
            bgColor: Color(0xFFE0F2FE),
            borderColor: Color(0xFF0284C7)
          );
        case 'PAYMENT':
          return const _IconStyle(
            icon: Icons.receipt_long_rounded,
            iconColor: Color(0xFF0284C7),
            glowColor: Color(0xFF0284C7),
            bgColor: Color(0xFFE0F2FE),
            borderColor: Color(0xFF0284C7)
          );
        case 'SYSTEM':
        default:
          return const _IconStyle(
            icon: Icons.info_outline_rounded,
            iconColor: AppLightColors.textSecondary,
            glowColor: AppLightColors.textSecondary,
            bgColor: Color(0xFFF1F5F9),
            borderColor: AppLightColors.border
          );

      }

    }

  }

  String _formatTime(DateTime time) {

    final Duration diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) {

      return 'Just now';

    }

    if (diff.inMinutes < 60) {

      return '${diff.inMinutes}m ago';

    }

    if (diff.inHours < 24) {

      return '${diff.inHours}h ago';

    }

    if (diff.inDays < 7) {

      return '${diff.inDays}d ago';

    }

    return '${time.day}/${time.month}/${time.year}';

  }

  @override
  Widget build(BuildContext context) {

    final bool isLowBalance = item.title.toLowerCase().contains('low balance') || item.body.toLowerCase().contains('balance is low');
    final _IconStyle style = _resolveStyle(item.category, isDark, isLowBalance: isLowBalance);
    final bool isUnread = !item.isRead;
    final Color cardBg;
    final Color cardBorder;
    final List<BoxShadow> boxShadows;

    if (isDark) {

      cardBg = isUnread ? AppColors.cardDark.withValues(
          alpha: 0.95
      ) : AppColors.cardDark;
      cardBorder = isUnread ? AppColors.chargingGreenGlow.withValues(
          alpha: 0.4
      ) : AppColors.border.withValues(
          alpha: 0.4
      );
      boxShadows = <BoxShadow>[
        BoxShadow(
          color: style.glowColor.withValues(
              alpha: isUnread ? 0.12 : 0.04
          ),
          blurRadius: 12,
          offset: const Offset(0, 2)
        )
      ];

    } else {

      cardBg = isLowBalance ? const Color(0xFFFFF5F5) : AppLightColors.card;
      cardBorder = isLowBalance ? AppLightColors.chargingRed.withValues(
          alpha: 0.25
      ) : isUnread ? AppLightColors.chargingGreen.withValues(
          alpha: 0.4
      ) : AppLightColors.border;
      final List<BoxShadow> glowShadow = isLowBalance ? AppLightShadows.redGlow : style.lightGlowShadow;
      boxShadows = <BoxShadow>[
        ...AppLightShadows.card,
        ...glowShadow
      ];

    }

    final BoxDecoration badgeDecoration;

    if (isDark) {

      badgeDecoration = BoxDecoration(
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
      );

    } else {

      badgeDecoration = BoxDecoration(
        color: style.bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: style.borderColor.withValues(
              alpha: 0.45
          ),
          width: 1.5
        )
      );

    }

    final Color titleColor = isDark ? AppColors.whiteColor : (isLowBalance ? AppLightColors.chargingRed : AppLightColors.textPrimary);
    final FontWeight titleWeight = isDark ? (isUnread ? FontWeight.w800 : FontWeight.w600) : (isUnread ? FontWeight.w800 : FontWeight.w700);
    final Color timeColor = isDark ? (isUnread ? AppColors.chargingGreenGlow : AppColors.textTertiary) : (isLowBalance
        ? AppLightColors.chargingRed : (isUnread ? AppLightColors.chargingGreen : AppLightColors.textTertiary));
    final Color bodyColor = isDark ? AppColors.textSecondary : AppLightColors.textSecondary;
    final Color unreadDotColor = isDark ? AppColors.chargingGreenGlow : AppLightColors.chargingGreen;

    return GestureDetector(
      onTap: () {

        if (isUnread) {

          context.read<NotificationBloc>().add(NotificationMarkReadRequested(item.id));

        }

      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: cardBorder,
            width: isUnread ? 1.5 : 1.0
          ),
          boxShadow: boxShadows
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: badgeDecoration,
              child: Icon(
                style.icon,
                color: style.iconColor,
                size: 22
              )
            ),
            const SizedBox(
                width: AppSpacing.sm
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: titleColor,
                            fontWeight: titleWeight,
                            fontSize: 14
                          )
                        )
                      ),
                      if (isUnread) ...<Widget>[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: unreadDotColor,
                            shape: BoxShape.circle
                          )
                        ),
                        const SizedBox(
                            width: 6
                        )
                      ],
                      Text(
                        _formatTime(item.createdAt),
                        style: AppTypography.bodySmall.copyWith(
                          color: timeColor,
                          fontSize: 11,
                          fontWeight: isUnread || isLowBalance ? FontWeight.w600 : FontWeight.w400
                        )
                      )
                    ]
                  ),
                  const SizedBox(
                      height: 4
                  ),
                  Text(
                    item.body,
                    style: AppTypography.bodySmall.copyWith(
                      color: bodyColor,
                      fontSize: 12,
                      height: 1.4
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );

  }

}

class _IconStyle {

  final IconData icon;
  final Color iconColor;
  final Color glowColor;
  final Color bgColor;
  final Color borderColor;
  final List<BoxShadow> lightGlowShadow;

  const _IconStyle({required this.icon, required this.iconColor, required this.glowColor, required this.bgColor, required this.borderColor, this.lightGlowShadow = const <BoxShadow>[]});

}
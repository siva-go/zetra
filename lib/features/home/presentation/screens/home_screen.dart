import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';

/// Main home screen of the ZETRA app.
/// Provides navigation cards to the three charging flow screens and
/// a top-right notification bell icon that opens the notification screen.
class ZetraHomeScreen extends StatelessWidget {
  const ZetraHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Top App Bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: <Widget>[
                  // ZETRA Logo / Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShaderMask(
                        shaderCallback: (Rect bounds) => const LinearGradient(
                          colors: <Color>[Color(0xFF69F0AE), Color(0xFF2EFE58)],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'ZETRA',
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).evChargingPlatform,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.chargingGreenGlow.withValues(alpha: 0.15),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          // Unread badge dot
                          Positioned(
                            top: 9,
                            right: 9,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.chargingGreenGlow,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppColors.chargingGreenGlow.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // ── Greeting ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).welcomeBackGreeting,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    AppLocalizations.of(context).startChargingSession,
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Quick Stats Row ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  _StatChip(
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.chargingGreenGlow,
                    label: AppLocalizations.of(context).sessionsCount('3'),
                    sublabel: AppLocalizations.of(context).thisWeek,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    icon: Icons.battery_charging_full_rounded,
                    iconColor: const Color(0xFF00E5FF),
                    label: '124 kWh',
                    sublabel: AppLocalizations.of(context).totalEnergy,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatChip(
                    icon: Icons.eco_rounded,
                    iconColor: AppColors.chargingGreenGlow,
                    label: '62 kg',
                    sublabel: AppLocalizations.of(context).co2Saved,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                AppLocalizations.of(context).chargingFlow,
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 2,
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Navigation Cards ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Plug-In Card (dark)
                    _NavCard(
                      step: '01',
                      title: AppLocalizations.of(context).plugIn,
                      subtitle: AppLocalizations.of(context).connectEvToCharger,
                      icon: Icons.power_rounded,
                      gradientColors: const <Color>[Color(0xFF1A1F33), Color(0xFF0D1020)],
                      accentColor: const Color(0xFF00E5FF),
                      glowColor: const Color(0xFF00E5FF),
                      onTap: () => context.go('/plug-in'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Power Link Card (dark)
                    _NavCard(
                      step: '02',
                      title: AppLocalizations.of(context).powerLink,
                      subtitle: AppLocalizations.of(context).vehicleConnectedReady,
                      icon: Icons.link_rounded,
                      gradientColors: const <Color>[Color(0xFF1A1F33), Color(0xFF0D1020)],
                      accentColor: AppColors.chargingGreenGlow,
                      glowColor: AppColors.chargingGreenGlow,
                      onTap: () => context.go('/charge-link'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Charging Session Card (dark)
                    _NavCard(
                      step: '03',
                      title: AppLocalizations.of(context).chargingSession,
                      subtitle: AppLocalizations.of(context).monitorLiveStats,
                      icon: Icons.electric_bolt_rounded,
                      gradientColors: const <Color>[Color(0xFF1A1F33), Color(0xFF0D1020)],
                      accentColor: const Color(0xFF7B2FF7),
                      glowColor: const Color(0xFF7B2FF7),
                      onTap: () => context.go('/charging'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Charging History Card
                    _NavCard(
                      step: '04',
                      title: AppLocalizations.of(context).chargingHistory,
                      subtitle: AppLocalizations.of(context).viewPastSessions,
                      icon: Icons.history_rounded,
                      gradientColors: const <Color>[Color(0xFF1C1B2E), Color(0xFF0F0E1C)],
                      accentColor: const Color(0xFFFFD600),
                      glowColor: const Color(0xFFFFD600),
                      onTap: () => context.go('/charging-history'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Invoice Card
                    _NavCard(
                      step: '05',
                      title: AppLocalizations.of(context).invoice,
                      subtitle: AppLocalizations.of(context).downloadViewInvoice,
                      icon: Icons.receipt_long_rounded,
                      gradientColors: const <Color>[Color(0xFF1E1A10), Color(0xFF110F06)],
                      accentColor: const Color(0xFFFF6D00),
                      glowColor: const Color(0xFFFF6D00),
                      onTap: () => context.go('/invoice'),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Light Theme Section Label ─────────────────────────
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B21B6).withValues(alpha: 0.15),
                            borderRadius: AppRadius.smBorder,
                            border: Border.all(
                              color: const Color(0xFF5B21B6).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(Icons.light_mode_rounded,
                                  size: 12, color: Color(0xFF8B5CF6)),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context).lightTheme,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFF8B5CF6),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Plug-In Light Card
                    _NavCard(
                      step: '01',
                      title: AppLocalizations.of(context).plugInLight,
                      subtitle: AppLocalizations.of(context).lightThemeConnectEv,
                      icon: Icons.power_rounded,
                      gradientColors: const <Color>[Color(0xFF1E2440), Color(0xFF151A2E)],
                      accentColor: const Color(0xFF8B5CF6),
                      glowColor: const Color(0xFF8B5CF6),
                      onTap: () => context.go('/plug-in-light'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Notification Light Card
                    _NavCard(
                      step: '02',
                      title: AppLocalizations.of(context).notificationsLight,
                      subtitle: AppLocalizations.of(context).lightThemeSessionAlerts,
                      icon: Icons.notifications_outlined,
                      gradientColors: const <Color>[Color(0xFF1E2440), Color(0xFF151A2E)],
                      accentColor: const Color(0xFF8B5CF6),
                      glowColor: const Color(0xFF8B5CF6),
                      onTap: () => context.go('/notifications-light'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Bottom Nav ────────────────────────────────────────────────
            const ZetraBottomNavBar(),
          ],
        ),
      ),
    );
  }
}

// ── Quick stat chip ───────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              sublabel,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Navigation card ───────────────────────────────────────────────────────────
class _NavCard extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color glowColor;
  final VoidCallback onTap;

  const _NavCard({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    required this.glowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: accentColor.withValues(alpha: 0.35),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: glowColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // Neon icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: accentColor, size: 26),
            ),
            const SizedBox(width: AppSpacing.md),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'STEP $step',
                        style: AppTypography.labelSmall.copyWith(
                          color: accentColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow indicator
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: accentColor,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

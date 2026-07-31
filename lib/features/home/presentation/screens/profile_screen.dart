import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';

/// Dark-themed Profile screen for the ZETRA application.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color blueNeon = Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ── Profile Photo Header ──────────────────────────────────────
            const _ProfileHeader(blueNeon: blueNeon),

            // ── Wallet Balance Card ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
              child: _WalletCard(blueNeon: blueNeon),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Menu Options — scrollable so no overflow on small screens ─
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: AppRadius.lgBorder,
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.lgBorder,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        children: <Widget>[
                          _MenuOptionItem(
                            icon: Icons.credit_card_rounded,
                            title: AppLocalizations.of(context).paymentMethods,
                            neonColor: const Color(0xFF8B5CF6),
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.pin_drop_rounded,
                            title: AppLocalizations.of(context).savedStations,
                            neonColor: const Color(0xFF00FF66),
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.history_rounded,
                            title: AppLocalizations.of(context).chargingHistory,
                            neonColor: const Color(0xFFFF7F00),
                            onTap: () => context.push('/charging-history'),
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.receipt_long_rounded,
                            title: AppLocalizations.of(context).invoice,
                            neonColor: const Color(0xFFFF2D55),
                            onTap: () => context.push('/invoice'),
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.settings_rounded,
                            title: AppLocalizations.of(context).settings,
                            neonColor: const Color(0xFFFFD600),
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.help_outline_rounded,
                            title: AppLocalizations.of(context).helpSupport,
                            neonColor: const Color(0xFF00FFCC),
                            onTap: () {},
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Bottom Nav ────────────────────────────────────────────────
            const ZetraBottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  static Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Profile Header
// ────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final Color blueNeon;
  const _ProfileHeader({required this.blueNeon});

  @override
  Widget build(BuildContext context) {
    final double headerHeight =
        (MediaQuery.of(context).size.height * 0.28).clamp(160.0, 220.0);

    return Stack(
      children: <Widget>[
        Container(
          height: headerHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profile.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.15),
                  AppColors.scaffoldDark.withValues(alpha: 0.7),
                  AppColors.scaffoldDark,
                ],
                stops: const <double>[0, 0.4, 0.85, 1],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.xs,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi Karan! 👋',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: const <Shadow>[
                    Shadow(
                        color: Colors.black87,
                        offset: Offset(0, 1.5),
                        blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'karan.sharma@zetra.io',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.95),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.md,
          child: CustomPaint(
            painter: HexagonPainter(glowColor: blueNeon),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Icon(Icons.bolt_rounded, color: blueNeon, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Wallet Balance Card
// ────────────────────────────────────────────────────────────────────────────
class _WalletCard extends StatelessWidget {
  final Color blueNeon;
  const _WalletCard({required this.blueNeon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
            color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).walletBalance,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹ 600.00',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueNeon.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: blueNeon, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              elevation: 6,
              shadowColor: blueNeon.withValues(alpha: 0.3),
            ),
            onPressed: () {},
            child: Text(
              AppLocalizations.of(context).addMoney,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                shadows: <Shadow>[Shadow(color: blueNeon, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Menu Option Item
// ────────────────────────────────────────────────────────────────────────────
class _MenuOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color neonColor;
  final VoidCallback onTap;

  const _MenuOptionItem({
    required this.icon,
    required this.title,
    required this.neonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: neonColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
              color: neonColor.withValues(alpha: 0.3), width: 1.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: neonColor.withValues(alpha: 0.25),
                blurRadius: 10,
                spreadRadius: 1),
          ],
        ),
        child: Icon(icon, color: neonColor, size: 18),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 18,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Hexagon Badge Painter
// ────────────────────────────────────────────────────────────────────────────
class HexagonPainter extends CustomPainter {
  final Color glowColor;
  final double strokeWidth;

  HexagonPainter({required this.glowColor, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double padding = 6.0 + strokeWidth;
    final double radius = (math.min(w, h) / 2) - padding;

    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = -math.pi / 2 + (i * math.pi / 3);
      final double x = cx + radius * math.cos(angle);
      final double y = cy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 3.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));

    canvas.drawPath(
        path,
        Paint()
          ..color = glowColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }

  @override
  bool shouldRepaint(covariant HexagonPainter old) =>
      old.glowColor != glowColor || old.strokeWidth != strokeWidth;
}

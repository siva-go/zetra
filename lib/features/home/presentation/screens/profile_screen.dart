import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

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
          children: [
            // ── Profile Photo Header ──────────────────────────────────────
            _ProfileHeader(blueNeon: blueNeon),

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
                      width: 1,
                    ),
                    boxShadow: [
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
                      children: [
                        _MenuOptionItem(
                          icon: Icons.credit_card_rounded,
                          title: 'Payment Methods',
                          neonColor: const Color(0xFF8B5CF6),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _MenuOptionItem(
                          icon: Icons.pin_drop_rounded,
                          title: 'Saved Stations',
                          neonColor: const Color(0xFF00FF66),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _MenuOptionItem(
                          icon: Icons.history_rounded,
                          title: 'Charging History',
                          neonColor: const Color(0xFFFF7F00),
                          onTap: () => context.push('/charging-history'),
                        ),
                        _buildDivider(),
                        _MenuOptionItem(
                          icon: Icons.receipt_long_rounded,
                          title: 'Invoice',
                          neonColor: const Color(0xFFFF2D55),
                          onTap: () => context.push('/invoice'),
                        ),
                        _buildDivider(),
                        _MenuOptionItem(
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          neonColor: const Color(0xFFFFD600),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _MenuOptionItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
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
            const ZetraBottomNavBar(currentIndex: 3),
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
      children: [
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
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.15),
                  AppColors.scaffoldDark.withValues(alpha: 0.7),
                  AppColors.scaffoldDark,
                ],
                stops: const [0.0, 0.4, 0.85, 1.0],
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
            children: [
              Text(
                'Hi Karan! 👋',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: const [
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
            painter: HexagonPainter(glowColor: blueNeon, strokeWidth: 2.0),
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
            color: AppColors.border.withValues(alpha: 0.6), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet Balance',
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
              '+ Add Money',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                shadows: [Shadow(color: blueNeon, blurRadius: 4)],
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
          boxShadow: [
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
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final padding = 6.0 + strokeWidth;
    final radius = (math.min(w, h) / 2) - padding;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + (i * math.pi / 3);
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
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

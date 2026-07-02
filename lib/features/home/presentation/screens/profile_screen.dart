import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

/// Dark-themed Profile screen for the ZETRA application.
/// Displays user info, balance card, and glowing neon menu navigations.
/// Fully responsive and adaptive to fit in a single screen without scrolling.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color blueNeon = Color(0xFF00E5FF); // Blue/Cyan neon color

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;

            // Adapt heights and spacing to screen size
            final headerHeight = (screenHeight * 0.32).clamp(180.0, 240.0);
            final verticalSpacing = screenHeight < 700 ? AppSpacing.xs : AppSpacing.md;
            final elementPadding = screenHeight < 700 ? AppSpacing.xs : AppSpacing.sm;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Profile Photo Header with Overlaid Text ──────────────
                Stack(
                  children: [
                    // Profile picture asset
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
                    // Dark gradient overlay
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
                    // Overlaid Text Info
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
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1.5),
                                  blurRadius: 4,
                                ),
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
                              shadows: const [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1.0),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Top-left BLUE neon hexagon badge
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.md,
                      child: CustomPaint(
                        painter: HexagonPainter(
                          glowColor: blueNeon, // Blue neon color
                          strokeWidth: 2.0,
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: blueNeon,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: verticalSpacing),

                // ── Wallet Balance Card ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Container(
                    padding: EdgeInsets.all(elementPadding),
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
                              side: const BorderSide(color: blueNeon, width: 1.5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            elevation: 6,
                            shadowColor: blueNeon.withValues(alpha: 0.3),
                          ),
                          onPressed: () {
                            // Add Money logic placeholder
                          },
                          child: Text(
                            '+ Add Money',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              shadows: const [
                                Shadow(color: blueNeon, blurRadius: 4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: verticalSpacing),

                // ── Menu List Options Card ───────────────────────────────
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _MenuOptionItem(
                            icon: Icons.credit_card_rounded,
                            title: 'Payment Methods',
                            neonColor: const Color(0xFF8B5CF6), // Purple
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.pin_drop_rounded,
                            title: 'Saved Stations',
                            neonColor: const Color(0xFF00FF66), // Green
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.history_rounded,
                            title: 'Charging History',
                            neonColor: const Color(0xFFFF7F00), // Orange
                            onTap: () => context.go('/charging-history'),
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.settings_rounded,
                            title: 'Settings',
                            neonColor: const Color(0xFFFFD600), // Neon Yellow Settings
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _MenuOptionItem(
                            icon: Icons.help_outline_rounded,
                            title: 'Help & Support',
                            neonColor: const Color(0xFF00E5FF), // Cyan
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: verticalSpacing),

                // Bottom navigation footer
                ZetraBottomNavBar(
                  currentIndex: 3, // Profile tab is index 3
                  onTap: (index) {
                    if (index == 0) context.go('/home');
                    if (index == 2) context.go('/charging-history');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Divider(
        color: AppColors.divider,
        height: 1,
      ),
    );
  }
}

/// Circular leading icon list tile with neon glow border & shadow.
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
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: neonColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: neonColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: neonColor.withValues(alpha: 0.25),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: neonColor,
          size: 18,
        ),
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

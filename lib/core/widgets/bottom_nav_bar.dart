import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';

/// Bottom navigation bar for the ZETRA app.
/// Matches the design mockup with Home, Scan QR, Sessions, Profile tabs.
class ZetraBottomNavBar extends StatelessWidget {

  final int currentIndex;
  final ValueChanged<int>? onTap;

  const ZetraBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? AppColors.navBackground : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border.withValues(alpha: 0.5) : AppColors.borderLight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5
              )
            )
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: currentIndex == 0,
                    isDark: isDark,
                    onTap: () => onTap?.call(0)
                  ),
                  if (currentIndex == 1)
                    _ActiveScanHexagon(onTap: () => onTap?.call(1))
                  else
                    _NavItem(
                      icon: Icons.qr_code_scanner_outlined,
                      activeIcon: Icons.qr_code_scanner,
                      label: 'Scan QR',
                      isActive: false,
                      isDark: isDark,
                      onTap: () => onTap?.call(1)
                    ),
                  _NavItem(
                    icon: Icons.assignment_outlined,
                    activeIcon: Icons.assignment,
                    label: 'Sessions',
                    isActive: currentIndex == 2,
                    isDark: isDark,
                    onTap: () => onTap?.call(2)
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isActive: currentIndex == 3,
                    isDark: isDark,
                    onTap: () => onTap?.call(3)
                  )
                ]
              )
            )
          )
        ),
      ],
    );

  }

}

class _ActiveScanHexagon extends StatelessWidget {
  final VoidCallback onTap;

  const _ActiveScanHexagon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, -6),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipPath(
                clipper: _HexagonClipper(),
                child: Container(
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.blackColor,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Scan QR',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _NavItem extends StatelessWidget {

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.isDark,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {

    final Color activeColor = isDark ? AppColors.whiteColor : AppColors.primary;
    final Color inactiveColor = isDark ? AppColors.navInactive : AppColors.textSecondaryLight;
    final Color color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: color,
            size: 24
          ),
          const SizedBox(
              height: AppSpacing.xs
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400
            )
          )
        ]
      )
    );

  }

}
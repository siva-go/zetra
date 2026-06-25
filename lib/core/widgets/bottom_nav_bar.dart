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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(
                alpha: 0.5
            ),
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
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap?.call(0)
              ),
              _NavItem(
                icon: Icons.qr_code_scanner_outlined,
                activeIcon: Icons.qr_code_scanner,
                label: 'Scan QR',
                isActive: currentIndex == 1,
                onTap: () => onTap?.call(1)
              ),
              _NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: 'Sessions',
                isActive: currentIndex == 2,
                onTap: () => onTap?.call(2)
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap?.call(3)
              )
            ]
          )
        )
      )
    );

  }

}

class _NavItem extends StatelessWidget {

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {

    final color = isActive ? AppColors.whiteColor : AppColors.navInactive;

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
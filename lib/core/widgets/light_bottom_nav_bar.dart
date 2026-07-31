import 'package:flutter/material.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/app/themes/light/app_light_colors.dart';

/// Light-theme bottom navigation bar for Notification and Plug-In screens.
class ZetraLightBottomNavBar extends StatelessWidget {

  final int currentIndex;
  final ValueChanged<int>? onTap;

  const ZetraLightBottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: AppLightColors.navBackground,
        border: const Border(
          top: BorderSide(
            color: AppLightColors.border
          )
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF000000).withValues(
                alpha: 0.05
            ),
            blurRadius: 8,
            offset: const Offset(0, -2)
          )
        ]
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _LightNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap?.call(0)
              ),
              _LightNavItem(
                icon: Icons.qr_code_scanner_outlined,
                activeIcon: Icons.qr_code_scanner_rounded,
                label: 'Scan QR',
                isActive: currentIndex == 1,
                onTap: () => onTap?.call(1)
              ),
              _LightNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentIndex == 2,
                onTap: () => onTap?.call(2)
              )
            ]
          )
        )
      )
    );

  }

}

class _LightNavItem extends StatelessWidget {

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _LightNavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {

    final Color color = isActive ? AppLightColors.navActive : AppLightColors.navInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isActive ? activeIcon : icon,
            color: color,
            size: 24
          ),
          const SizedBox(
              height: AppSpacing.xxs
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
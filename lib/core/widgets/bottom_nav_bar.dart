import 'package:flutter/material.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_spacing.dart';
import '../../app/themes/app_typography.dart';

/// Bottom navigation bar for the ZETRA app.
/// Matches the design mockup with Home, Scan QR, Sessions, Profile tabs.
class ZetraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const ZetraBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
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
                onTap: () => onTap?.call(0),
              ),
              _NavItem(
                icon: Icons.qr_code_scanner_outlined,
                activeIcon: Icons.qr_code_scanner,
                label: 'Scan QR',
                isActive: currentIndex == 1,
                onTap: () => onTap?.call(1),
              ),
              _NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: 'Sessions',
                isActive: currentIndex == 2,
                onTap: () => onTap?.call(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap?.call(3),
              ),
            ],
          ),
        ),
      ),
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
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF00E5FF); // Neon cyan active indicator
    final color = isActive ? activeColor : AppColors.navInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: isActive
                ? CustomPaint(
                    painter: HexagonPainter(glowColor: activeColor),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Icon(
                        activeIcon,
                        color: activeColor,
                        size: 22,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw a vertical pointy-topped hexagon with neon shadow glow.
class HexagonPainter extends CustomPainter {
  final Color glowColor;
  final double strokeWidth;

  HexagonPainter({
    required this.glowColor,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Glowing neon shadow
    final shadowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final path = _getHexagonPath(size);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  Path _getHexagonPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    final padX = strokeWidth + 1.0;
    final padY = strokeWidth + 1.0;
    final left = padX;
    final right = w - padX;
    final top = padY;
    final bottom = h - padY;

    final centerX = w / 2;
    final height25 = (bottom - top) * 0.25;

    path.moveTo(centerX, top);
    path.lineTo(right, top + height25);
    path.lineTo(right, bottom - height25);
    path.lineTo(centerX, bottom);
    path.lineTo(left, bottom - height25);
    path.lineTo(left, top + height25);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant HexagonPainter oldDelegate) =>
      oldDelegate.glowColor != glowColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../app/themes/app_spacing.dart';

/// A mini circular progress gauge widget used inside the metrics panel.
class MiniCircularGauge extends StatelessWidget {
  final double percentage; // value between 0.0 and 1.0
  final String value;
  final String label;
  final String unit;
  final Color activeColor;

  const MiniCircularGauge({
    super.key,
    required this.percentage,
    required this.value,
    required this.label,
    required this.unit,
    this.activeColor = AppColors.chargingRed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label at the top — small & muted, never ellipsis
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Circular Arc with value in center
        SizedBox(
          width: 76,
          height: 76,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MiniGaugePainter(
                    percentage: percentage,
                    activeColor: activeColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: AppTypography.statValue.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Unit — below the circle, highlighted in neon theme color
        if (unit.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              unit,
              style: AppTypography.statUnit.copyWith(
                fontSize: 12,
                color: activeColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniGaugePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;

  const _MiniGaugePainter({
    required this.percentage,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const strokeWidth = 5.5;

    // 270° arc starting at 135°
    const startAngle = 135 * (math.pi / 180);
    const totalSweep = 270 * (math.pi / 180);

    // Track
    final trackPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, totalSweep, false, trackPaint);

    // Active neon arc
    if (percentage > 0) {
      final sweepAngle = totalSweep * percentage;

      // 1. Outer Soft Glow
      final glowPaint1 = Paint()
        ..color = activeColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint1);

      // 2. Intense Mid-Glow
      final glowPaint2 = Paint()
        ..color = activeColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 3.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint2);

      // 3. Main Neon Tube
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);

      // 4. White Glass Core
      final corePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.3
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.activeColor != activeColor;
  }
}

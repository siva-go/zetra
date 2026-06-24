import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../app/themes/app_spacing.dart';

/// A premium circular gauge showing the State of Charge (SOC) percentage.
class SocGauge extends StatelessWidget {
  final double percentage; // value between 0.0 and 1.0
  final Color activeColor;
  final Color trackColor;

  const SocGauge({
    super.key,
    required this.percentage,
    this.activeColor = AppColors.chargingRed,
    this.trackColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Arc
          Positioned.fill(
            child: CustomPaint(
              painter: _SocGaugePainter(
                percentage: percentage,
                activeColor: activeColor,
                trackColor: trackColor,
              ),
            ),
          ),
          
          // Inside Gauge Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SOC',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${(percentage * 100).toInt()}',
                    style: AppTypography.socPercentage.copyWith(
                      fontSize: 62,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    '%',
                    style: AppTypography.socPercentage.copyWith(
                      fontSize: 26,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.electric_bolt_rounded,
                    color: activeColor,
                    size: 32,
                    shadows: [
                      Shadow(
                        color: activeColor.withValues(alpha: 0.8),
                        blurRadius: 12.0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocGaugePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color trackColor;

  const _SocGaugePainter({
    required this.percentage,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    const strokeWidth = 12.0;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // We start from 12 o'clock (-pi/2)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * percentage;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (percentage > 0) {
      // 1. Outer Soft Wide Glow
      final glowPaint1 = Paint()
        ..color = activeColor.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 18.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint1);

      // 2. Intense Mid-Glow
      final glowPaint2 = Paint()
        ..color = activeColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint2);

      // 3. Main Neon Tube (Saturated)
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);

      // 4. Glass Core / Hot Core (Bright white glittering center line)
      final corePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.35 // thin bright white core
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SocGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveLiquidPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final Color glowColor;
  final double fillLevel;

  WaveLiquidPainter({
    required this.animationValue,
    required this.color,
    required this.glowColor,
    required this.fillLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = size.height * (0.62 - fillLevel * 0.45); // Liquid rises with SOC

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.95),
          color,
          glowColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, baseHeight - 80, size.width, 120));

    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final path = Path();
    final waveHeight = 18.0;

    path.moveTo(0, baseHeight);

    for (double x = 0; x <= size.width; x += 4) {
      final y = baseHeight +
          math.sin((x / 35) + animationValue * 7) * waveHeight +
          math.sin((x / 18) + animationValue * 4) * (waveHeight * 0.6);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw glow first
    canvas.drawPath(path, glowPaint);
    // Draw main liquid
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveLiquidPainter oldDelegate) => true;
}
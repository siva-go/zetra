import 'package:flutter/material.dart';

import '../../app/themes/app_radius.dart';
import '../../app/themes/app_spacing.dart';
import '../../app/themes/app_typography.dart';

/// A "Slide to Stop Charging" interactive slider button.
/// The thumb slides from left to right to trigger the action.
class SlideToStopButton extends StatefulWidget {
  final Color themeColor;
  final VoidCallback? onSlideComplete;
  final String label;

  const SlideToStopButton({
    super.key,
    required this.themeColor,
    this.onSlideComplete,
    this.label = 'Slide to Stop Charging',
  });

  @override
  State<SlideToStopButton> createState() => _SlideToStopButtonState();
}

class _SlideToStopButtonState extends State<SlideToStopButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        const thumbSize = 52.0;
        final maxDrag = maxWidth - thumbSize - AppSpacing.sm * 2;

        final baseColor = widget.themeColor;
        final darkColor = Color.lerp(baseColor, Colors.black, 0.7) ?? baseColor;
        final midColor = Color.lerp(baseColor, Colors.black, 0.1) ?? baseColor;

        final thumbLight = Color.lerp(baseColor, Colors.white, 0.3) ?? baseColor;
        final thumbDark = baseColor;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkColor, midColor, darkColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: AppRadius.roundBorder,
            border: Border.all(
              color: baseColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // ── Center Label Text ──
              Center(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Text(
                      widget.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white.withValues(
                          alpha: (0.7 + (_shimmerController.value * 0.3)).clamp(0.0, 1.0),
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    );
                  },
                ),
              ),

              // ── Single chevron on the right end ──
              Positioned(
                right: 20,
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withValues(
                        alpha: (0.4 + (_shimmerController.value * 0.4)).clamp(0.0, 1.0),
                      ),
                      size: 24,
                    );
                  },
                ),
              ),

              // ── Draggable Thumb ──
              Positioned(
                left: AppSpacing.sm + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition =
                          (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition > maxDrag * 0.8) {
                      widget.onSlideComplete?.call();
                    }
                    setState(() {
                      _dragPosition = 0.0;
                    });
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [thumbLight, thumbDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: baseColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


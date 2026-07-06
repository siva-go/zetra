import 'package:flutter/material.dart';

import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';

class SlideToStopButton extends StatefulWidget {

  final Color themeColor;
  final VoidCallback? onSlideComplete;
  final String label;

  const SlideToStopButton({
    super.key,
    required this.themeColor,
    this.onSlideComplete,
    this.label = 'Slide to Stop Charging'
  });

  @override
  State<SlideToStopButton> createState() => _SlideToStopButtonState();
}

class _SlideToStopButtonState extends State<SlideToStopButton> with SingleTickerProviderStateMixin {

  double _dragPosition = 0;
  late AnimationController _shimmerController;

  @override
  void initState() {

    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 2000
      )
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
      builder: (BuildContext context, BoxConstraints constraints) {

        final double maxWidth = constraints.maxWidth;
        const double thumbSize = 52;
        final double maxDrag = maxWidth - thumbSize - AppSpacing.sm * 2;
        final Color baseColor = widget.themeColor;
        final Color darkColor = Color.lerp(baseColor, Colors.black, 0.7) ?? baseColor;
        final Color midColor = Color.lerp(baseColor, Colors.black, 0.1) ?? baseColor;
        final Color thumbLight = Color.lerp(baseColor, Colors.white, 0.3) ?? baseColor;
        final Color thumbDark = baseColor;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[darkColor, midColor, darkColor]
            ),
            borderRadius: AppRadius.roundBorder,
            border: Border.all(
              color: baseColor.withValues(
                  alpha: 0.25
              )
            )
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              // ── Center Label Text ──
              Center(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (BuildContext context, Widget? child) {

                    return Text(
                      widget.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white.withValues(
                          alpha: (0.7 + (_shimmerController.value * 0.3)).clamp(0.0, 1.0)
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5
                      )
                    );

                  }
                )
              ),
              // ── Single chevron on the right end ──
              Positioned(
                right: 20,
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (BuildContext context, Widget? child) {

                    return Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withValues(
                        alpha: (0.4 + (_shimmerController.value * 0.4)).clamp(0.0, 1.0)
                      ),
                      size: 24
                    );

                  }
                )
              ),
              // ── Draggable Thumb ──
              Positioned(
                left: AppSpacing.sm + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {

                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                    });

                  },
                  onHorizontalDragEnd: (DragEndDetails details) {

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
                        colors: <Color>[thumbLight, thumbDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      ),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: baseColor.withValues(
                              alpha: 0.4
                          ),
                          blurRadius: 10,
                          spreadRadius: 1
                        )
                      ]
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22
                          )
                        ),
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22
                          )
                        ),
                        Align(
                          widthFactor: 0.35,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 22
                          )
                        )
                      ]
                    )
                  )
                )
              )
            ]
          )
        );

      }
    );

  }

}
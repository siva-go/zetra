import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/charging/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_event.dart';

/// Screen shown after the vehicle is successfully connected to a charger.
/// Displays an illustration of the car/charger connection, a success checkmark,
/// and a "Let's Charge" call-to-action button.
class ChargeLinkScreen extends StatefulWidget {
  const ChargeLinkScreen({super.key});

  @override
  State<ChargeLinkScreen> createState() => _ChargeLinkScreenState();
}

class _ChargeLinkScreenState extends State<ChargeLinkScreen> with TickerProviderStateMixin {

  // ── Animations (nullable to avoid LateInitializationError) ─────────────────
  AnimationController? _checkController;
  Animation<double>? _checkScale;
  Animation<double>? _checkOpacity;
  AnimationController? _waveController;
  AnimationController? _confettiController;
  AnimationController? _glowController;
  // ── Confetti dots — small pops only over car region (right portion) ─────────
  final List<_ConfettiDot> _dots = _generateDots();
  static List<_ConfettiDot> _generateDots() {

    final math.Random rand = math.Random(42);
    final List<Color> colors = <Color>[
      const Color(0xFF2EFE58), // green
      const Color(0xFFFF1744), // red
      const Color(0xFF2979FF), // blue
      const Color(0xFFFFD600), // yellow
      const Color(0xFFE040FB), // purple
      const Color(0xFF00E5FF) // cyan
    ];
    // 20 small dots, x in [0.40, 1.0] — only over the car region
    return List<_ConfettiDot>.generate(20, (int i) {

      return _ConfettiDot(
        x: 0.40 + rand.nextDouble() * 0.60,
        y: rand.nextDouble(),
        size: 3.0 + rand.nextDouble() * 3.0, // smaller pops (3–6 px)
        color: colors[rand.nextInt(colors.length)],
        speed: 0.3 + rand.nextDouble() * 0.7,
        phase: rand.nextDouble() * math.pi * 2
      );

    });

  }

  @override
  void initState() {

    super.initState();

    // Check-mark pop-in
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 700
      )
    );
    _checkScale = CurvedAnimation(
        parent: _checkController!,
        curve: Curves.elasticOut
    );
    _checkOpacity = CurvedAnimation(
        parent: _checkController!,
        curve: Curves.easeIn
    );
    Future<dynamic>.delayed(const Duration(
        milliseconds: 200
    ), () {

      if (mounted) {

        _checkController?.forward();

      }

    });

    // Waveform oscillation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1200
      )
    )..repeat(
        reverse: true
    );

    // Confetti drift
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 6
      )
    )..repeat();

    // Ground glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1800
      ),
    )..repeat(
        reverse: true
    );

  }

  @override
  void dispose() {

    _checkController?.dispose();
    _waveController?.dispose();
    _confettiController?.dispose();
    _glowController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    // Illustration block height: generous so car + checkmark both fit
    final double illH = size.height * 0.40;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Top Bar with Back Arrow ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border.withValues(
                              alpha: 0.5
                          )
                        )
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.whiteColor,
                        size: 20
                      )
                    )
                  )
                ]
              )
            ),
            // ── Illustration Stack ─────────────────────────────────────────────────────
            // Draw order (back to front):
            //   1. Green ground glow (bottom)
            //   2. Green neon line
            //   3. Station (behind the car, slightly left)
            //   4. Car (front, centre-right)
            //   5. Confetti (only over car region)
            //   6. Checkmark badge (above car)
            SizedBox(
              height: illH,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  // ── 1. Green neon ground glow — full-width bottom band ───────
                  if (_glowController != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                        animation: _glowController!,
                        builder: (BuildContext context, Widget? child) => Container(
                          height: illH * 0.32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: <Color>[
                                const Color(0xFF00FF6A).withValues(
                                  alpha: 0.28 + 0.12 * (_glowController?.value ?? 0.0)
                                ),
                                const Color(0xFF00FF6A).withValues(
                                    alpha: 0.06
                                ),
                                Colors.transparent
                              ],
                              stops: const <double>[0, 0.5, 1]
                            )
                          )
                        )
                      )
                    ),
                  // // ── 2. Green neon line at the very bottom ────────────────
                  // Positioned(
                  //   bottom: 4,
                  //   left: 0,
                  //   right: 0,
                  //   child: Opacity(
                  //     opacity: 0.95,
                  //     child: Image.asset(
                  //       'assets/images/green_line.png',
                  //       width: size.width,
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //   ),
                  // ),

                  // // ── 3. Station — behind the car, left-of-centre ────────────
                  // Positioned(
                  //   left: size.width * 0.06,
                  //   bottom: 18,
                  //   height: illH * 0.58,
                  //   child: Image.asset(
                  //     'assets/images/station.png',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  // ── 4. Car — in front, centre to right ───────────────────
                  Positioned(
                    left: size.width * 0.18,
                    right: 0,
                    bottom: 20,
                    height: illH * 0.75,
                    child: Image.asset(
                      'assets/images/car_link.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight
                    )
                  ),
                  // ── 5. Confetti — small pops only over the car region ───────
                  if (_confettiController != null)
                    Positioned.fill(
                      child: ClipRect(
                        child: AnimatedBuilder(
                          animation: _confettiController!,
                          builder: (BuildContext context, Widget? child) => CustomPaint(
                            painter: _ConfettiPainter(
                              dots: _dots,
                              progress: _confettiController!.value,
                              canvasWidth: size.width
                            )
                          )
                        )
                      )
                    ),
                  // ── 6. Checkmark badge — above the car ───────────────────
                  if (_checkScale != null && _checkOpacity != null)
                    Positioned(
                      right: size.width * 0.20,
                      top: illH * 0.01,
                      child: ScaleTransition(
                        scale: _checkScale!,
                        child: FadeTransition(
                          opacity: _checkOpacity!,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: <Color>[
                                  Color(0xFF1BFF6A),
                                  Color(0xFF00C853)
                                ],
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.chargingGreenGlow.withValues(
                                      alpha: 0.70
                                  ),
                                  blurRadius: 36,
                                  spreadRadius: 8
                                )
                              ]
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.whiteColor,
                              size: 46
                            )
                          )
                        )
                      )
                    )
                ]
              )
            ),
            const SizedBox(
                height: AppSpacing.md
            ),
            // ── "Power Link Established! ⚡" ────────────────────────────────────
            ShaderMask(
              shaderCallback: (Rect bounds) => const LinearGradient(
                colors: <Color>[Color(0xFF69F0AE), Color(0xFF2EFE58)],
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Text(
                AppLocalizations.of(context).powerLinkEstablished,
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.whiteColor,
                  height: 1.25
                )
              )
            ),
            const SizedBox(
                height: AppSpacing.xs
            ),
            Text(
              AppLocalizations.of(context).vehicleConnectedSuccess,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14
              )
            ),
            const SizedBox(
                height: AppSpacing.sm
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg
              ),
              child: SizedBox(
                height: 44,
                child: _waveController != null ? AnimatedBuilder(
                  animation: _waveController!,
                  builder: (BuildContext context, Widget? child) => CustomPaint(
                    size: const Size(double.infinity, 44),
                    painter: _WaveformPainter(
                      progress: _waveController!.value,
                      color: const Color(0xFF2979FF)
                    )
                  )
                ) : const SizedBox.shrink()
              )
            ),
            const Spacer(),
            // ── "Let's Charge" button ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg
              ).copyWith(
                  bottom: AppSpacing.lg
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFF7B2FF7), Color(0xFF4A90E2)]
                    ),
                    borderRadius: AppRadius.roundBorder,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF7B2FF7).withValues(
                            alpha: 0.4
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8)
                      )
                    ]
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.roundBorder
                      )
                    ),
                    onPressed: () {

                      context.read<ChargingBloc>().add(StartCharging());
                      context.go('/charging');

                    },
                    child: Text(
                      AppLocalizations.of(context).letsCharge,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4
                      )
                    )
                  )
                )
              )
            )
          ]
        )
      )
    );

  }

}

class _ConfettiDot {

  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double phase;

  const _ConfettiDot({required this.x, required this.y, required this.size, required this.color, required this.speed, required this.phase});

}

class _ConfettiPainter extends CustomPainter {

  final List<_ConfettiDot> dots;
  final double progress;
  final double canvasWidth;

  const _ConfettiPainter({required this.dots, required this.progress, required this.canvasWidth});

  @override
  void paint(Canvas canvas, Size size) {

    for (final _ConfettiDot dot in dots) {

      final double t = (progress * dot.speed + dot.phase / (math.pi * 2)) % 1.0;
      final double dy = t * size.height * 0.08;
      final double dx = math.sin(t * math.pi * 2 + dot.phase) * 5.0;
      final Paint paint = Paint()
        ..color = dot.color.withValues(
            alpha: 0.90
        )
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(dot.x * size.width + dx, dot.y * size.height + dy),
        dot.size / 2,
        paint
      );

    }

  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

class _WaveformPainter extends CustomPainter {

  final double progress;
  final Color color;

  const _WaveformPainter({required this.progress, required this.color});

  static const int _barCount = 48;

  @override
  void paint(Canvas canvas, Size size) {

    final double barWidth = size.width / _barCount;
    final double centerY = size.height / 2;

    for (int i = 0; i < _barCount; i++) {

      final double fraction = i / (_barCount - 1);
      final double envelope = math.sin(fraction * math.pi);
      final double phase = fraction * math.pi * 4 + progress * math.pi * 2;
      final double heightFactor = 0.20 + 0.80 * envelope * (0.45 + 0.55 * math.sin(phase));
      final double barHeight = size.height * heightFactor;
      final double x = i * barWidth + barWidth / 2;
      final double alpha = 0.55 + 0.45 * envelope;
      final Paint paint = Paint()
        ..color = color.withValues(
            alpha: alpha
        )
        ..strokeWidth = barWidth * 0.85 // wide enough — no gap
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint
      );

    }

  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.progress != progress || old.color != color;

}
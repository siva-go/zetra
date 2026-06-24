import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_typography.dart';
import '../../presentation/bloc/charging_bloc.dart';
import '../../presentation/bloc/charging_event.dart';

/// Screen shown after the vehicle is successfully connected to a charger.
/// Displays an illustration of the car/charger connection, a success checkmark,
/// and a "Let's Charge" call-to-action button.
class ChargeLinkScreen extends StatefulWidget {
  const ChargeLinkScreen({super.key});

  @override
  State<ChargeLinkScreen> createState() => _ChargeLinkScreenState();
}

class _ChargeLinkScreenState extends State<ChargeLinkScreen>
    with TickerProviderStateMixin {
  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _checkController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;

  late AnimationController _waveController;
  late AnimationController _confettiController;

  // ── Confetti dots ──────────────────────────────────────────────────────────
  final List<_ConfettiDot> _dots = _generateDots();

  static List<_ConfettiDot> _generateDots() {
    final rand = math.Random(42);
    final colors = [
      const Color(0xFF2EFE58), // green
      const Color(0xFFFF1744), // red
      const Color(0xFF2979FF), // blue
      const Color(0xFFFFD600), // yellow
      const Color(0xFFE040FB), // purple
      const Color(0xFF00E5FF), // cyan
    ];
    return List.generate(80, (i) {
      return _ConfettiDot(
        x: rand.nextDouble(),
        y: rand.nextDouble(), // full screen height — showers over car area too
        size: 4.0 + rand.nextDouble() * 7.0,
        color: colors[rand.nextInt(colors.length)],
        speed: 0.3 + rand.nextDouble() * 0.7,
        phase: rand.nextDouble() * math.pi * 2,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // Check-mark pop-in
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkScale = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _checkOpacity = CurvedAnimation(parent: _checkController, curve: Curves.easeIn);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _checkController.forward();
    });

    // Waveform oscillation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Confetti drift
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _waveController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Confetti dots layer ──────────────────────────────────────────
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(size.width, size.height),
                  painter: _ConfettiPainter(
                    dots: _dots,
                    progress: _confettiController.value,
                  ),
                );
              },
            ),

            // ── Main content ────────────────────────────────────────────────
            Column(
              children: [
                const SizedBox(height: AppSpacing.sm),

                // ── Green checkmark badge ────────────────────────────────────
                ScaleTransition(
                  scale: _checkScale,
                  child: FadeTransition(
                    opacity: _checkOpacity,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFF1BFF6A),
                            Color(0xFF00C853),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.chargingGreenGlow.withValues(alpha: 0.55),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Illustration Stack (station, car, and green line) ───────
                SizedBox(
                  height: size.height * 0.35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Green line / Neon circle base
                      Positioned(
                        bottom: 0,
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        child: Center(
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              'assets/images/green_line.png',
                              width: size.width * 0.85,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      // 2. Charging station on the left
                      Positioned(
                        left: size.width * 0.1,
                        bottom: 12,
                        height: size.height * 0.28,
                        child: Image.asset(
                          'assets/images/station.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      // 3. EV Car on the right
                      Positioned(
                        right: size.width * 0.08,
                        bottom: 30,
                        height: size.height * 0.22,
                        child: Image.asset(
                          'assets/images/car_link_image.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── "Power Link Established! ⚡" ─────────────────────────────
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF69F0AE),
                      Color(0xFF2EFE58),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Power Link\nEstablished! ⚡',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white, // masked by ShaderMask
                      height: 1.25,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                // ── Subtitle ─────────────────────────────────────────────────
                Text(
                  'Vehicle connected successfully.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // ── Waveform animation ────────────────────────────────────────
                SizedBox(
                  height: 36,
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: const Size(double.infinity, 36),
                        painter: _WaveformPainter(
                          progress: _waveController.value,
                          color: AppColors.chargingGreenGlow,
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // ── "Let's Charge" button ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ).copyWith(bottom: AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7B2FF7),
                            Color(0xFF4A90E2),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: AppRadius.roundBorder,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2FF7).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.roundBorder,
                          ),
                        ),
                        onPressed: () {
                          // Start the charging simulation and navigate
                          context.read<ChargingBloc>().add(StartCharging());
                          context.go('/charging');
                        },
                        child: Text(
                          "Let's Charge",
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Confetti dot model ─────────────────────────────────────────────────────────
class _ConfettiDot {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double phase;

  const _ConfettiDot({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.phase,
  });
}

// ── Confetti painter ───────────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiDot> dots;
  final double progress;

  const _ConfettiPainter({required this.dots, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in dots) {
      final t = (progress * dot.speed + dot.phase / (math.pi * 2)) % 1.0;
      final dy = t * size.height * 0.08; // gentle drift
      final dx = math.sin(t * math.pi * 2 + dot.phase) * 6.0;
      final paint = Paint()
        ..color = dot.color.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(dot.x * size.width + dx, dot.y * size.height + dy),
        dot.size / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// ── Waveform painter ───────────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _WaveformPainter({required this.progress, required this.color});

  static const _barCount = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final barWidth = size.width / (_barCount * 2 - 1);
    final centerY = size.height / 2;

    for (int i = 0; i < _barCount; i++) {
      final fraction = i / (_barCount - 1);
      // Envelope: tall in the middle, short at edges
      final envelope = math.sin(fraction * math.pi);
      // Animate heights with a phase offset per bar
      final phase = fraction * math.pi * 4 + progress * math.pi * 2;
      final heightFactor = (0.25 + 0.75 * envelope * (0.5 + 0.5 * math.sin(phase)));
      final barHeight = size.height * heightFactor;

      final x = i * barWidth * 2 + barWidth / 2;
      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.progress != progress || old.color != color;
}

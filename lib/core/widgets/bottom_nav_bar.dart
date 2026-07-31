import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:zetra/app/themes/app_colors.dart';

class RiveAsset {

  final String artboard;
  final String stateMachineName;
  final String title;

  const RiveAsset(this.artboard, {required this.stateMachineName, required this.title});

}

/// Navigation items (excluding the center QR FAB).
/// Indices 0-3 map to nav slots: left-two and right-two slots.
const List<RiveAsset> bottomNavs = <RiveAsset>[
  RiveAsset('HOME', stateMachineName: 'HOME_interactivity', title: 'Home'),
  RiveAsset('SEARCH', stateMachineName: 'SEARCH_Interactivity', title: 'Search'),
  RiveAsset('USER', stateMachineName: 'USER_Interactivity', title: 'Profile'),
  RiveAsset('BELL', stateMachineName: 'BELL_Interactivity', title: 'Alerts')
];

/// Routes for each nav index (4 side items + 1 center QR).
const List<String> _navRoutes = <String>[
  '/home',
  '/scan-qr',
  '/profile',
  '/notifications'
];

const String _qrRoute = '/scan-qr';

/// Premium animated bottom navigation bar using Rive icons.
/// The centre slot is a raised animated QR-scan FAB button.
class ZetraBottomNavBar extends StatefulWidget {

  final int currentIndex;

  const ZetraBottomNavBar({super.key, this.currentIndex = 0});

  @override
  State<ZetraBottomNavBar> createState() => _ZetraBottomNavBarState();
}

class _ZetraBottomNavBarState extends State<ZetraBottomNavBar> with TickerProviderStateMixin {

  late final AnimationController _bgController;
  // QR FAB animations
  late final AnimationController _pulseController;
  late final AnimationController _scanController;
  late final AnimationController _rotateController;
  late final Animation<double> _pulse1;
  late final Animation<double> _pulse2;
  late final Animation<double> _scanLine;
  /// Per-instance controller + input references.
  final List<StateMachineController?> _riveControllers = List<StateMachineController?>.filled(bottomNavs.length, null);
  final List<SMIBool?> _riveInputs =
  List<SMIBool?>.filled(bottomNavs.length, null);

  @override
  void initState() {

    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 4
      )
    )..repeat(
        reverse: true
    );

    // Pulse rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 2000
      )
    )..repeat();

    _pulse1 = Tween<double>(
        begin: 0,
        end: 1
    ).animate(
      CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeOut
      )
    );

    _pulse2 = Tween<double>(
        begin: 0,
        end: 1
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.4, 1, curve: Curves.easeOut)
      )
    );

    // Scan line sweep
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1800
      )
    )..repeat(
        reverse: true
    );

    _scanLine = Tween<double>(
        begin: 0,
        end: 1
    ).animate(
      CurvedAnimation(
          parent: _scanController,
          curve: Curves.easeInOut
      )
    );

    // Corner bracket slow rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 8
      )
    )..repeat();

  }

  @override
  void dispose() {

    _bgController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    _rotateController.dispose();

    for (final StateMachineController? c in _riveControllers) {

      c?.dispose();

    }

    super.dispose();

  }

  void _onRiveInit(Artboard artboard, int index) {

    final StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      bottomNavs[index].stateMachineName
    );

    if (controller != null) {

      artboard.addController(controller);
      _riveControllers[index] = controller;
      _riveInputs[index] = controller.findSMI('active') as SMIBool?;

      if (_activeNavIndex == index) {

        _riveInputs[index]?.change(true);

      }

    }

  }

  /// Maps widget.currentIndex to the 4-item side nav index.
  /// currentIndex 0-3 → side nav items; currentIndex 4 = QR FAB active.
  int get _activeNavIndex => widget.currentIndex < 4 ? widget.currentIndex : -1;

  @override
  void didUpdateWidget(covariant ZetraBottomNavBar oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {

      final int newIdx = _activeNavIndex;
      final int oldIdx = oldWidget.currentIndex < 4 ? oldWidget.currentIndex : -1;

      if (newIdx >= 0) {

        _riveInputs[newIdx]?.change(true);

      }

      if (oldIdx >= 0) {

        _riveInputs[oldIdx]?.change(false);

      }

    }

  }

  void _handleTap(int index) {

    _riveInputs[index]?.change(true);
    Future<void>.delayed(const Duration(
        milliseconds: 800
    ), () {

      if (_activeNavIndex != index && mounted) {

        _riveInputs[index]?.change(false);

      }

    });

    if (_activeNavIndex == index) {

      return;

    }

    final String route = _navRoutes[index];

    if (index == 0) {

      context.go('/home');

    } else {

      context.push(route);

    }

  }

  void _handleQrTap() {

    context.push(_qrRoute);

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF080C14) : AppColors.whiteColor;
    final Color borderColor = isDark ? const Color(0xFF00E5FF).withValues(
        alpha: 0.2
    ) : AppColors.borderLight;

    return SizedBox(
      height: 96, // taller to accommodate the raised FAB
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // ── Nav Bar background ───────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                    top: BorderSide(
                        color: borderColor
                    )
                ),
                boxShadow: isDark ? <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(
                        alpha: 0.12
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, -5)
                  )
                ] : const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2)
                  )
                ]
              ),
              child: SafeArea(
                top: false,
                child: AnimatedBuilder(
                  animation: _bgController,
                  builder: (BuildContext ctx, _) {

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8
                      ),
                      decoration: BoxDecoration(
                        gradient: isDark ? LinearGradient(
                          colors: <Color>[
                            const Color(0xFF00E5FF).withValues(
                                alpha: 0.01 + 0.04 * _bgController.value
                            ),
                            const Color(0xFF8B5CF6).withValues(
                                alpha: 0.06 - 0.04 * _bgController.value
                            ),
                            const Color(0xFF00E5FF).withValues(
                                alpha: 0.01 + 0.04 * _bgController.value
                            )
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                        ) : null
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          // Left two items
                          _buildRiveNavItem(0, isDark),
                          _buildRiveNavItem(1, isDark),
                          // Centre placeholder (space for FAB)
                          const SizedBox(
                              width: 64
                          ),
                          // Right two items
                          _buildRiveNavItem(2, isDark),
                          _buildRiveNavItem(3, isDark)
                        ]
                      )
                    );

                  }
                )
              )
            )
          ),
          // ── Centre QR FAB ────────────────────────────────────────────
          Positioned(
            top: 0,
            child: _QrFabButton(
              isDark: isDark,
              onTap: _handleQrTap,
              pulseAnim: _pulse1,
              pulse2Anim: _pulse2,
              scanAnim: _scanLine,
              rotateAnim: _rotateController
            )
          )
        ]
      )
    );

  }

  Widget _buildRiveNavItem(int index, bool isDark) {
    final bool isActive = _activeNavIndex == index;
    final Color activeColor = isDark ? const Color(0xFF00E5FF) : AppColors.primary;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Active backdrop circle
            AnimatedOpacity(
              duration: const Duration(
                  milliseconds: 300
              ),
              opacity: isActive ? 1.0 : 0.0,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor.withValues(
                      alpha: 0.15
                  ),
                  boxShadow: isDark ? <BoxShadow>[
                    BoxShadow(
                      color: activeColor.withValues(
                          alpha: 0.4
                      ),
                      blurRadius: 14,
                      spreadRadius: 2
                    )
                  ] : const <BoxShadow>[]
                )
              )
            ),
            // Rive animated icon — floats up when active
            AnimatedPositioned(
              duration: const Duration(
                  milliseconds: 400
              ),
              curve: Curves.elasticOut,
              top: isActive ? 4 : 11,
              bottom: isActive ? 14 : 11,
              left: 8,
              right: 8,
              child: Opacity(
                opacity: (isActive || isDark) ? 1.0 : 0.7,
                child: isDark
                    ? RiveAnimation.asset(
                        'assets/RiveAssets/icons.riv',
                        artboard: bottomNavs[index].artboard,
                        onInit: (Artboard artboard) => _onRiveInit(artboard, index),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isActive ? AppColors.primary : AppColors.textPrimaryLight,
                          BlendMode.srcIn,
                        ),
                        child: RiveAnimation.asset(
                          'assets/RiveAssets/icons.riv',
                          artboard: bottomNavs[index].artboard,
                          onInit: (Artboard artboard) => _onRiveInit(artboard, index),
                        ),
                      ),
              )
            ),
            // Dot indicator at bottom
            AnimatedPositioned(
              duration: const Duration(
                  milliseconds: 350
              ),
              curve: Curves.easeOutCubic,
              bottom: isActive ? 6 : -8,
              child: AnimatedOpacity(
                duration: const Duration(
                    milliseconds: 200
                ),
                opacity: isActive ? 1.0 : 0.0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                    boxShadow: isDark ? <BoxShadow>[
                      BoxShadow(
                        color: activeColor,
                        blurRadius: 6,
                        spreadRadius: 1
                      )
                    ] : const <BoxShadow>[]
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

// ── Animated QR Scan FAB ─────────────────────────────────────────────────────

class _QrFabButton extends StatelessWidget {

  final bool isDark;
  final VoidCallback onTap;
  final Animation<double> pulseAnim;
  final Animation<double> pulse2Anim;
  final Animation<double> scanAnim;
  final AnimationController rotateAnim;

  const _QrFabButton({required this.isDark, required this.onTap, required this.pulseAnim, required this.pulse2Anim, required this.scanAnim, required this.rotateAnim});

  @override
  Widget build(BuildContext context) {

    const Color qrGreen = Color(0xFF00E5FF);
    const Color qrGlow = Color(0xFF69F0AE);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        height: 72,
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[pulseAnim, scanAnim, rotateAnim]),
          builder: (BuildContext ctx, Widget? child) {

            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // ── Outer pulse ring 1
                if (isDark)
                  Transform.scale(
                    scale: 0.9 + 0.5 * pulseAnim.value,
                    child: Opacity(
                      opacity: (1.0 - pulseAnim.value) * 0.5,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: qrGreen.withValues(
                                alpha: 0.6
                            ),
                            width: 1.5
                          )
                        )
                      )
                    )
                  ),
                // ── Outer pulse ring 2 (offset)
                if (isDark)
                  Transform.scale(
                    scale: 0.9 + 0.5 * pulse2Anim.value,
                    child: Opacity(
                      opacity: (1.0 - pulse2Anim.value) * 0.35,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: qrGlow.withValues(
                                alpha: 0.5
                            )
                          )
                        )
                      )
                    )
                  ),
                // ── Main FAB circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFF00E5FF), Color(0xFF00897B)]
                    ),
                    boxShadow: isDark ? <BoxShadow>[
                      const BoxShadow(
                        color: Color(0xFF00E5FF),
                        blurRadius: 18
                      ),
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withValues(
                            alpha: 0.3
                        ),
                        blurRadius: 32,
                        spreadRadius: 4
                      )
                    ] : <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF00897B).withValues(
                            alpha: 0.35
                        ),
                        blurRadius: 16,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // Scan line sweep inside the button
                        Positioned(
                          top: 10 + 28 * scanAnim.value,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  AppColors.whiteColor.withValues(
                                      alpha: 0
                                  ),
                                  AppColors.whiteColor.withValues(
                                      alpha: 0.9
                                  ),
                                  AppColors.whiteColor.withValues(
                                      alpha: 0
                                  )
                                ]
                              )
                            )
                          )
                        ),
                        // QR icon with slow rotation
                        Transform.rotate(
                          angle: rotateAnim.value * 2 * math.pi * 0.05,
                          child: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: AppColors.whiteColor,
                            size: 30
                          )
                        )
                      ]
                    )
                  )
                ),
                // ── Rotating corner brackets
                Transform.rotate(
                  angle: rotateAnim.value * 2 * math.pi * 0.08,
                  child: CustomPaint(
                    size: const Size(68, 68),
                    painter: _CornerBracketsPainter(
                      color: qrGreen.withValues(
                          alpha: 0.6
                      )
                    )
                  )
                )
              ]
            );

          }
        )
      )
    );

  }

}

// ── Corner brackets painter ───────────────────────────────────────────────────

class _CornerBracketsPainter extends CustomPainter {

  final Color color;

  const _CornerBracketsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const double margin = 4;
    const double bracketLen = 10;

    // We draw 4 corner L-shapes at 45° rotated corners of a rounded square.
    final List<Offset> corners = <Offset>[
      const Offset(margin, margin),             // top-left
      Offset(size.width - margin, margin), // top-right
      Offset(size.width - margin, size.height - margin), // bottom-right
      Offset(margin, size.height - margin) // bottom-left
    ];

    // Directions for each corner bracket: (right/left, down/up)
    final List<List<Offset>> dirs = <List<Offset>>[
      <Offset>[const Offset(1, 0), const Offset(0, 1)],  // top-left
      <Offset>[const Offset(-1, 0), const Offset(0, 1)], // top-right
      <Offset>[const Offset(-1, 0), const Offset(0, -1)],// bottom-right
      <Offset>[const Offset(1, 0), const Offset(0, -1)] // bottom-left
    ];

    for (int i = 0; i < 4; i++) {

      final Offset c = corners[i];
      final Offset dx = dirs[i][0];
      final Offset dy = dirs[i][1];

      // Horizontal arm
      canvas.drawLine(
        c,
        c + dx * bracketLen,
        paint,
      );
      // Vertical arm
      canvas.drawLine(
        c,
        c + dy * bracketLen,
        paint
      );

    }

  }

  @override
  bool shouldRepaint(_CornerBracketsPainter oldDelegate) => oldDelegate.color != color;

}
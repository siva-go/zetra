import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:zetra/app/themes/app_colors.dart';

/// Model representing a Rive asset for a navigation item.
class RiveAsset {
  final String artboard;
  final String stateMachineName;
  final String title;

  const RiveAsset(this.artboard, {
    required this.stateMachineName,
    required this.title,
  });
}

/// Navigation items: Home, Scan QR, Charging, Profile, Notifications.
const List<RiveAsset> bottomNavs = <RiveAsset>[
  RiveAsset('HOME',   stateMachineName: 'HOME_interactivity',   title: 'Home'),
  RiveAsset('SEARCH', stateMachineName: 'SEARCH_Interactivity', title: 'Scan QR'),
  RiveAsset('TIMER',  stateMachineName: 'TIMER_Interactivity',  title: 'Charging'),
  RiveAsset('USER',   stateMachineName: 'USER_Interactivity',   title: 'Profile'),
  RiveAsset('BELL',   stateMachineName: 'BELL_Interactivity',   title: 'Notifications'),
];

/// Routes for each nav index.
const List<String> _navRoutes = <String>[
  '/home',
  '/scan-qr',
  '/plug-in',
  '/profile',
  '/notifications',
];

/// Premium animated bottom navigation bar using Rive icons.
class ZetraBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const ZetraBottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<ZetraBottomNavBar> createState() => _ZetraBottomNavBarState();
}

class _ZetraBottomNavBarState extends State<ZetraBottomNavBar>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;

  /// Per-instance controller + input references — not stored globally.
  final List<StateMachineController?> _riveControllers =
      List<StateMachineController?>.filled(bottomNavs.length, null);
  final List<SMIBool?> _riveInputs =
      List<SMIBool?>.filled(bottomNavs.length, null);

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    // Dispose all Rive controllers to prevent memory leaks.
    for (final StateMachineController? c in _riveControllers) {
      c?.dispose();
    }
    super.dispose();
  }

  void _onRiveInit(Artboard artboard, int index) {
    final StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      bottomNavs[index].stateMachineName,
    );
    if (controller != null) {
      artboard.addController(controller);
      _riveControllers[index] = controller;
      _riveInputs[index] = controller.findSMI('active') as SMIBool?;
      if (widget.currentIndex == index) {
        _riveInputs[index]?.change(true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant ZetraBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _riveInputs[widget.currentIndex]?.change(true);
      _riveInputs[oldWidget.currentIndex]?.change(false);
    }
  }

  void _handleTap(int index) {
    // Trigger Rive animation.
    _riveInputs[index]?.change(true);
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (widget.currentIndex != index && mounted) {
        _riveInputs[index]?.change(false);
      }
    });

    if (widget.currentIndex == index) return; // already on this tab

    final String route = _navRoutes[index];
    if (route.isEmpty) return; // no route (e.g. Scan QR placeholder)

    if (index == 0) {
      context.go('/home');
    } else {
      context.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDark ? const Color(0xFF080C14) : AppColors.whiteColor;
    final Color borderColor = isDark
        ? const Color(0xFF00E5FF).withValues(alpha: 0.2)
        : AppColors.borderLight;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1.0)),
        boxShadow: isDark
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ]
            : const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _bgController,
          builder: (BuildContext context, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        colors: <Color>[
                          const Color(0xFF00E5FF).withValues(
                              alpha: 0.01 + 0.04 * _bgController.value),
                          const Color(0xFF8B5CF6).withValues(
                              alpha: 0.06 - 0.04 * _bgController.value),
                          const Color(0xFF00E5FF).withValues(
                              alpha: 0.01 + 0.04 * _bgController.value),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(
                  bottomNavs.length,
                  (int index) => _buildRiveNavItem(index, isDark),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRiveNavItem(int index, bool isDark) {
    final bool isActive = widget.currentIndex == index;
    const Color activeColor = Color(0xFF00E5FF);

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Neon active backdrop circle
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isActive ? 1.0 : 0.0,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor.withValues(alpha: 0.15),
                  boxShadow: isDark
                      ? <BoxShadow>[
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.4),
                            blurRadius: 14,
                            spreadRadius: 2,
                          )
                        ]
                      : const <BoxShadow>[],
                ),
              ),
            ),
            // Rive animated icon — floats up when active
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              top: isActive ? 4 : 11,
              bottom: isActive ? 14 : 11,
              left: 8,
              right: 8,
              child: Opacity(
                opacity: (isActive || isDark) ? 1.0 : 0.55,
                child: RiveAnimation.asset(
                  'assets/RiveAssets/icons.riv',
                  artboard: bottomNavs[index].artboard,
                  onInit: (Artboard artboard) => _onRiveInit(artboard, index),
                ),
              ),
            ),
            // Tiny neon dot indicator at bottom
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              bottom: isActive ? 6 : -8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1.0 : 0.0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? <BoxShadow>[
                            BoxShadow(
                              color: activeColor,
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ]
                        : const <BoxShadow>[],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

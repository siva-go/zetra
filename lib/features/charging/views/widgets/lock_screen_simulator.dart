import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/features/charging/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_event.dart';
import 'package:zetra/features/charging/bloc/charging_state.dart';
import 'package:zetra/features/charging/views/widgets/live_activity_widget.dart';

class LockScreenSimulator extends StatefulWidget {
  const LockScreenSimulator({super.key});

  @override
  State<LockScreenSimulator> createState() => _LockScreenSimulatorState();
}

class _LockScreenSimulatorState extends State<LockScreenSimulator> {

  bool isWidgetDarkMode = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<ChargingBloc, ChargingState>(
        builder: (BuildContext context, ChargingState state) {

          final int socPercent = (state.soc * 100).toInt();

          return Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0F1E36),
                      Color(0xFF070B12)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                )
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: CustomPaint(
                    painter: WavePainter()
                  )
                )
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.whiteColor
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton.icon(
                      onPressed: () {

                        setState(() {
                          isWidgetDarkMode = !isWidgetDarkMode;
                        });

                      },
                      icon: Icon(
                        isWidgetDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        color: AppColors.whiteColor,
                        size: 16
                      ),
                      label: Text(
                        isWidgetDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12
                        )
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      )
                    )
                  ]
                )
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                            Icons.bolt, color: Color(0xFF00FFC2), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '$socPercent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Time & Date ──
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    const Text(
                      '09:41',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 82,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tuesday, September 12',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Lock Screen Live Activity Widget ──
              Positioned(
                left: 20,
                right: 20,
                bottom: 120,
                child: LiveActivityWidget(
                  soc: state.soc,
                  timeRemainingMins: state.timeRemaining.inMinutes,
                  speedKw: state.chargingSpeed,
                  costRm: state.cost,
                  isDarkMode: isWidgetDarkMode,
                  onStopTap: () {
                    context.read<ChargingBloc>().add(StopCharging());
                    // Go back after stop action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Charging Session Stopped!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              // ── Bottom Quick Actions (Flashlight / Camera / Home Indicator) ──
              Positioned(
                bottom: 40,
                left: 36,
                right: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Flashlight
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flashlight_on_rounded, color: Colors.white, size: 22),
                    ),
                    // Camera
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),

              // Home Indicator Swipe Bar
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 140,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Background Wave Painter for Lock Screen Wallpaper
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    final Path path2 = Path();
    path2.moveTo(0, size.height * 0.45);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.3,
      size.width,
      size.height * 0.6,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/themes/app_colors.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/slide_to_stop_button.dart';
import '../../../../core/components/app_dialog.dart';
import '../widgets/soc_gauge.dart';
import '../widgets/mini_circular_gauge.dart';
import '../widgets/charger_info_row.dart';
import '../bloc/charging_bloc.dart';
import '../bloc/charging_event.dart';
import '../bloc/charging_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingBloc, ChargingState>(
      builder: (context, state) {
        // Determine theme color based on current SOC for premium visual feedback
        Color themeColor;
        if (state.soc < 0.2) {
          themeColor = AppColors.chargingRedGlow;
        } else if (state.soc < 0.8) {
          themeColor = AppColors.chargingOrangeGlow;
        } else {
          themeColor = AppColors.chargingGreenGlow;
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldDark,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header / Active Status ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
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
                              color: AppColors.border.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'CHARGING SESSION',
                            style: AppTypography.labelSmall.copyWith(
                              letterSpacing: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state.status == ChargingStatus.charging
                                      ? themeColor
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                state.status == ChargingStatus.charging
                                    ? 'Active Charging'
                                    : state.status == ChargingStatus.completed
                                        ? 'Charging Completed'
                                        : 'Session Paused',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
                        onPressed: () {
                          AppDialog.show(
                            context: context,
                            title: 'Station Info',
                            content: 'Charger: Super DC-94\nLocation: Sector 4 EV Hub\nNetwork: Zetra Power\nStatus: Online',
                            primaryButtonText: 'OK',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Center Gauge (SOC) ──
                Center(
                  child: SocGauge(
                    percentage: state.soc,
                    activeColor: themeColor,
                  ),
                ),

                const Spacer(),

                // ── Metrics Grid (Mini Circular Gauges) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MiniCircularGauge(
                        percentage: (state.chargingSpeed / 150.0).clamp(0.0, 1.0),
                        value: state.chargingSpeed.toString(),
                        label: 'SPEED',
                        unit: 'kW',
                        activeColor: themeColor,
                      ),
                      MiniCircularGauge(
                        percentage: (state.energyDelivered / 85.0).clamp(0.0, 1.0),
                        value: state.energyDelivered.toString(),
                        label: 'ENERGY',
                        unit: 'kWh',
                        activeColor: themeColor,
                      ),
                      MiniCircularGauge(
                        percentage: (state.timeRemaining.inMinutes / 60.0).clamp(0.0, 1.0),
                        value: state.timeRemaining.inMinutes.toString(),
                        label: 'REMAINING',
                        unit: 'min',
                        activeColor: themeColor,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Charger details ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: ChargerInfoRow(
                    chargerType: 'DC Fast Charge',
                    powerValue: '150 kW',
                    connectorType: 'CCS Type 2',
                    temperature: '${state.batteryTemp}°C',
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Slide to Stop Action ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: SlideToStopButton(
                    themeColor: themeColor,
                    label: state.status == ChargingStatus.completed
                        ? 'Slide to Finish'
                        : 'Slide to Stop Charging',
                    onSlideComplete: () {
                      context.read<ChargingBloc>().add(StopCharging());

                      // Show summary dialog
                      AppDialog.show(
                        context: context,
                        title: 'Session Summary',
                        content: 'Charging session stopped successfully.\n\n'
                            '• Final Charge: ${(state.soc * 100).toInt()}%\n'
                            '• Energy Delivered: ${state.energyDelivered} kWh\n'
                            '• Elapsed Time: ${state.elapsedTime.inMinutes}m ${state.elapsedTime.inSeconds % 60}s\n'
                            '• Average Temp: ${state.batteryTemp}°C',
                        primaryButtonText: 'Finish',
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: AppColors.chargingGreenGlow,
                        onPrimaryPressed: () {
                          // Dismiss dialog
                          Navigator.of(context).pop();
                          // Reset charging and navigate back
                          context.read<ChargingBloc>().add(ResetCharging());
                          context.go('/home');
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Navigation Bar ──
                const ZetraBottomNavBar(currentIndex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}

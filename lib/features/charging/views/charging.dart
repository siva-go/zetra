import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/components/app_dialog.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/core/widgets/slide_to_stop_button.dart';
import 'package:zetra/features/charging/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_event.dart';
import 'package:zetra/features/charging/bloc/charging_state.dart';
import 'package:zetra/features/charging/views/widgets/charger_info_row.dart';
import 'package:zetra/features/charging/views/widgets/mini_circular_gauge.dart';
import 'package:zetra/features/charging/views/widgets/soc_gauge.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ChargingBloc, ChargingState>(
      builder: (BuildContext context, ChargingState state) {

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
              children: <Widget>[
                // ── Header / Active Status ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).chargingSessionSession,
                            style: AppTypography.labelSmall.copyWith(
                              letterSpacing: 1.5,
                              color: AppColors.textSecondary
                            )
                          ),
                          const SizedBox(
                              height: 4
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state.status == ChargingStatus.charging ? themeColor : AppColors.textSecondary
                                )
                              ),
                              const SizedBox(
                                  width: AppSpacing.xs
                              ),
                              Text(
                                state.status == ChargingStatus.charging ? AppLocalizations.of(context).activeCharging : state.status == ChargingStatus.completed ? AppLocalizations.of(context).chargingCompletedStatus : AppLocalizations.of(context).sessionPaused,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          )
                        ]
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.whiteColor
                        ),
                        onPressed: () {

                          AppDialog.show(
                            context: context,
                            title: AppLocalizations.of(context).stationInfo,
                            content: AppLocalizations.of(context).stationInfoDetails,
                            primaryButtonText: AppLocalizations.of(context).ok
                          );

                        }
                      )
                    ]
                  )
                ),
                const Spacer(),
                // ── Center Gauge (SOC) ──
                Center(
                  child: SocGauge(
                    percentage: state.soc,
                    activeColor: themeColor
                  )
                ),
                const Spacer(),
                // ── Metrics Grid (Mini Circular Gauges) ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MiniCircularGauge(
                        percentage: (state.chargingSpeed / 150.0).clamp(0.0, 1.0),
                        value: state.chargingSpeed.toString(),
                        label: AppLocalizations.of(context).speed,
                        unit: 'kW',
                        activeColor: themeColor
                      ),
                      MiniCircularGauge(
                        percentage: (state.energyDelivered / 85.0).clamp(0.0, 1.0),
                        value: state.energyDelivered.toString(),
                        label: AppLocalizations.of(context).energy,
                        unit: 'kWh',
                        activeColor: themeColor
                      ),
                      MiniCircularGauge(
                        percentage: (state.timeRemaining.inMinutes / 60.0).clamp(0.0, 1.0),
                        value: state.timeRemaining.inMinutes.toString(),
                        label: AppLocalizations.of(context).remaining,
                        unit: 'min',
                        activeColor: themeColor
                      )
                    ]
                  )
                ),
                const Spacer(),
                // ── Charger details ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md
                  ),
                  child: ChargerInfoRow(
                    chargerType: AppLocalizations.of(context).dcFastCharge,
                    powerValue: '150 kW',
                    connectorType: AppLocalizations.of(context).ccsType2,
                    temperature: '${state.batteryTemp}°C'
                  )
                ),
                const SizedBox(
                    height: AppSpacing.md
                ),
                // ── Slide to Stop Action ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md
                  ),
                  child: SlideToStopButton(
                    themeColor: themeColor,
                    label: state.status == ChargingStatus.completed ? AppLocalizations.of(context).slideToFinish : AppLocalizations.of(context).slideToStopCharging,
                    onSlideComplete: () {

                      context.read<ChargingBloc>().add(StopCharging());

                      // Show summary dialog
                      AppDialog.show(
                        context: context,
                        title: AppLocalizations.of(context).sessionSummary,
                        content: AppLocalizations.of(context).sessionSummaryDetails(
                          (state.soc * 100).toInt().toString(),
                          state.energyDelivered.toString(),
                          state.elapsedTime.inMinutes.toString(),
                          (state.elapsedTime.inSeconds % 60).toString(),
                          state.batteryTemp.toString()
                        ),
                        primaryButtonText: AppLocalizations.of(context).finish,
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: AppColors.chargingGreenGlow,
                        onPrimaryPressed: () {

                          // Dismiss dialog
                          Navigator.of(context).pop();
                          // Reset charging and navigate back
                          context.read<ChargingBloc>().add(ResetCharging());
                          context.go('/home');

                        }
                      );

                    }
                  )
                ),
                const SizedBox(
                    height: AppSpacing.md
                ),
                // ── Navigation Bar ──
                const ZetraBottomNavBar(
                    
                )
              ]
            )
          )
        );

      }
    );

  }

}
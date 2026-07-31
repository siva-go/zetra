import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/components/app_card.dart';
import 'package:zetra/core/components/primary_button.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/charging/bloc/plugin_bloc.dart';
import 'package:zetra/features/charging/bloc/plugin_event.dart';
import 'package:zetra/features/charging/bloc/plugin_state.dart';

/// Screen that prompts the user to plug in their EV.
/// Simulates the connection steps sequentially:
/// 1. Session Initiated (completed)
/// 2. Payment Successful (completed)
/// 3. Waiting for Plug-In (active) -> transitions to completed
/// 4. Vehicle Connected (pending) -> active -> completed
/// 5. Charging Autostart (pending) -> active -> completed
class PlugInScreen extends StatefulWidget {
  const PlugInScreen({super.key});

  @override
  State<PlugInScreen> createState() => _PlugInScreenState();
}

class _PlugInScreenState extends State<PlugInScreen> {

  @override
  void initState() {

    super.initState();
    // Ensure state is clean when arriving on this screen
    context.read<PlugInBloc>().add(ResetPlugin());

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: BlocListener<PlugInBloc, PlugInState>(
          listenWhen: (PlugInState previous, PlugInState current) => previous.status != current.status,
          listener: (BuildContext context, PlugInState state) {

            if (state.status == PluginStatus.completed) {

              // Smooth auto-navigation to charge-link page when simulation finishes
              context.go('/charge-link');

            }

          },
          child: Column(
            children: <Widget>[
              // ── Top Bar with Back Arrow ───────────────────────────────────
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
              // ── Header / Station Info ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).chargingAt,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5
                      )
                    ),
                    const SizedBox(
                        height: AppSpacing.xxs
                    ),
                    Text(
                      'ZETRA GreenCharge Hub',
                      style: AppTypography.labelLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.whiteColor
                      )
                    ),
                    const SizedBox(
                        height: AppSpacing.xxs
                    ),
                    Text(
                      AppLocalizations.of(context).orderId,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ]
                )
              ),
              const SizedBox(
                  height: AppSpacing.md
              ),
              // ── Main Content Card ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md
                  ),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // ── Central Image (Square, occupied fully, neon border) ──
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.lgBorder,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: const Color(0xFF00E5FF).withValues(
                                      alpha: 0.25
                                  ), // Neon cyan glow
                                  blurRadius: 18,
                                  spreadRadius: 2
                                ),
                                BoxShadow(
                                  color: const Color(0xFF7B2FF7).withValues(
                                      alpha: 0.15
                                  ), // Muted brand purple glow overlay
                                  blurRadius: 25,
                                  spreadRadius: 1
                                )
                              ],
                              border: Border.all(
                                color: const Color(0xFF00E5FF).withValues(
                                    alpha: 0.5
                                ), // Electric Cyan border
                                width: 1.5
                              )
                            ),
                            child: ClipRRect(
                              borderRadius: AppRadius.lgBorder,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  'assets/images/plug_in.png',
                                  fit: BoxFit.cover
                                )
                              )
                            )
                          ),
                          const SizedBox(
                              height: AppSpacing.md
                          ),
                          // ── Title & Description ──
                          Text(
                            AppLocalizations.of(context).waitingForPlugIn,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor
                            )
                          ),
                          const SizedBox(
                              height: AppSpacing.xs
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm
                            ),
                            child: Text(
                              AppLocalizations.of(context).connectHighSpeedPlug,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4
                              )
                            )
                          ),
                          const SizedBox(
                              height: AppSpacing.md
                          ),
                          const Divider(
                              color: AppColors.divider,
                              height: 1
                          ),
                          const SizedBox(
                              height: AppSpacing.sm
                          ),
                          // ── Checklist Steps ──
                          BlocBuilder<PlugInBloc, PlugInState>(
                            builder: (BuildContext context, PlugInState state) {

                              return Column(
                                children: <Widget>[
                                  _StepRow(
                                    title: AppLocalizations.of(context).sessionInitiated,
                                    status: state.sessionInitiated
                                  ),
                                  _StepRow(
                                    title: AppLocalizations.of(context).paymentSuccessful,
                                    status: state.paymentSuccessful
                                  ),
                                  _StepRow(
                                    title: AppLocalizations.of(context).waitingForPlugIn,
                                    status: state.waitingForPlugIn
                                  ),
                                  _StepRow(
                                    title: AppLocalizations.of(context).vehicleConnected,
                                    status: state.vehicleConnected
                                  ),
                                  _StepRow(
                                    title: AppLocalizations.of(context).chargingAutostart,
                                    status: state.chargingAutostart,
                                    leftIconOverride: Icons.electric_bolt_rounded
                                  )
                                ]
                              );

                            }
                          )
                        ]
                      )
                    )
                  )
                )
              ),
              const SizedBox(
                  height: AppSpacing.md
              ),
              // ── Action Button ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg
                ).copyWith(
                    bottom: AppSpacing.lg
                ),
                child: BlocBuilder<PlugInBloc, PlugInState>(
                  builder: (BuildContext context, PlugInState state) {

                    final bool isConnecting = state.status == PluginStatus.connecting;
                    final bool isCompleted = state.status == PluginStatus.completed;

                    String btnText = AppLocalizations.of(context).letsCharge;

                    if (isConnecting) {

                      btnText = AppLocalizations.of(context).establishingConnection;

                    }

                    if (isCompleted) {

                      btnText = AppLocalizations.of(context).connected;

                    }

                    return PrimaryButton(
                      text: btnText,
                      isLoading: isConnecting,
                      onPressed: (isConnecting || isCompleted) ? null : () {

                        context.read<PlugInBloc>().add(StartConnectionSimulation());

                      }
                    );

                  }
                )
              )
            ]
          )
        )
      )
    );

  }

}

class _StepRow extends StatelessWidget {

  final String title;
  final PlugInItemStatus status;
  final IconData? leftIconOverride;

  const _StepRow({required this.title, required this.status, this.leftIconOverride});

  @override
  Widget build(BuildContext context) {

    final Color textColor;
    final Widget badge;

    switch (status) {

      case PlugInItemStatus.completed:
        textColor = AppColors.success;
        badge = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.success,
                width: 2
            )
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.success,
            size: 14
          )
        );
        break;

      case PlugInItemStatus.active:
        textColor = const Color(0xFF7B2FF7);
        badge = Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF7B2FF7),
                width: 2
            )
          ),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF7B2FF7)
            )
          )
        );
        break;

      case PlugInItemStatus.pending:
        textColor = AppColors.textSecondary;
        badge = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.textTertiary,
                width: 2
            )
          )
        );
        break;

    }

    final Widget leftWidget;

    if (leftIconOverride != null && status != PlugInItemStatus.completed) {

      leftWidget = Icon(
        leftIconOverride,
        color: status == PlugInItemStatus.active ? const Color(0xFF7B2FF7) : AppColors.textSecondary,
        size: 22
      );

    } else {

      leftWidget = badge;

    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs
      ),
      child: Row(
        children: <Widget>[
          leftWidget,
          const SizedBox(
              width: AppSpacing.sm
          ),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: status == PlugInItemStatus.active ? FontWeight.bold : FontWeight.w500
              )
            )
          ),
          badge
        ]
      )
    );

  }

}
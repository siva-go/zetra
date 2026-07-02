import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/themes/app_radius.dart';
import '../../../../app/themes/app_spacing.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../app/themes/light/app_light_colors.dart';
import '../../../../app/themes/light/app_light_shadows.dart';
import '../../../../core/widgets/light_bottom_nav_bar.dart';
import '../bloc/plugin_bloc.dart';
import '../bloc/plugin_event.dart';
import '../bloc/plugin_state.dart';

/// Light-themed Plug-In screen.
/// Matches the reference mockup — white scaffold, light card surface,
/// subtle shadows, and muted neon accents using [AppLightColors].
class PlugInScreenLight extends StatefulWidget {
  const PlugInScreenLight({super.key});

  @override
  State<PlugInScreenLight> createState() => _PlugInScreenLightState();
}

class _PlugInScreenLightState extends State<PlugInScreenLight> {
  @override
  void initState() {
    super.initState();
    context.read<PlugInBloc>().add(ResetPlugin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightColors.scaffold,
      body: SafeArea(
        child: BlocListener<PlugInBloc, PlugInState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == PluginStatus.completed) {
              context.go('/charge-link');
            }
          },
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),

              // ── Header / Station Info ──────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    Text(
                      'Charging at',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppLightColors.chargingGreen,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'GreenCharge Hub',
                      style: AppTypography.labelLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppLightColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'ORDER ID: #GC458796',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppLightColors.textSecondary,
                        fontSize: 12,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Main Content Card ──────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppLightColors.card,
                      borderRadius: AppRadius.lgBorder,
                      border: Border.all(color: AppLightColors.border),
                      boxShadow: AppLightShadows.card,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Image (square, cyan border, soft glow) ──
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.lgBorder,
                              boxShadow: AppLightShadows.imageFrame,
                              border: Border.all(
                                color: const Color(0xFF0099CC)
                                    .withValues(alpha: 0.45),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: AppRadius.lgBorder,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(
                                  'assets/images/plug_in.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // ── Title & Subtitle ──────────────────────────
                          Text(
                            'Waiting for Plug-In',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppLightColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm),
                            child: Text(
                              'Please connect the premium high-speed plug to your vehicle.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppLightColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.md),
                          Divider(
                              color: AppLightColors.divider, height: 1),
                          const SizedBox(height: AppSpacing.sm),

                          // ── Checklist Steps ───────────────────────────
                          BlocBuilder<PlugInBloc, PlugInState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  _LightStepRow(
                                    title: 'Session Initiated',
                                    status: state.sessionInitiated,
                                  ),
                                  _LightStepRow(
                                    title: 'Payment Successful',
                                    status: state.paymentSuccessful,
                                  ),
                                  _LightStepRow(
                                    title: 'Waiting for Plug-In',
                                    status: state.waitingForPlugIn,
                                  ),
                                  _LightStepRow(
                                    title: 'Vehicle Connected',
                                    status: state.vehicleConnected,
                                  ),
                                  _LightStepRow(
                                    title: 'Charging Autostart',
                                    status: state.chargingAutostart,
                                    leftIconOverride:
                                        Icons.electric_bolt_rounded,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Action Button ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
                    .copyWith(bottom: AppSpacing.lg),
                child: BlocBuilder<PlugInBloc, PlugInState>(
                  builder: (context, state) {
                    final bool isConnecting =
                        state.status == PluginStatus.connecting;
                    final bool isCompleted =
                        state.status == PluginStatus.completed;

                    String btnText = 'Simulate Plug-In';
                    if (isConnecting) btnText = 'Establishing Connection...';
                    if (isCompleted) btnText = 'Connected';

                    return _LightPrimaryButton(
                      text: btnText,
                      isLoading: isConnecting,
                      onPressed: (isConnecting || isCompleted)
                          ? null
                          : () => context
                              .read<PlugInBloc>()
                              .add(StartConnectionSimulation()),
                    );
                  },
                ),
              ),

              // ── Bottom Nav ─────────────────────────────────────────────
              ZetraLightBottomNavBar(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 0) context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step Row (light) ──────────────────────────────────────────────────────────
class _LightStepRow extends StatelessWidget {
  final String title;
  final PlugInItemStatus status;
  final IconData? leftIconOverride;

  const _LightStepRow({
    required this.title,
    required this.status,
    this.leftIconOverride,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    final Widget badge;

    switch (status) {
      case PlugInItemStatus.completed:
        textColor = AppLightColors.chargingGreen;
        badge = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppLightColors.chargingGreen, width: 2),
          ),
          child: Icon(Icons.check_rounded,
              color: AppLightColors.chargingGreen, size: 13),
        );
        break;

      case PlugInItemStatus.active:
        textColor = AppLightColors.accent;
        badge = Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: AppLightColors.accent, width: 2),
          ),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppLightColors.accent,
            ),
          ),
        );
        break;

      case PlugInItemStatus.pending:
        textColor = AppLightColors.textSecondary;
        badge = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppLightColors.textTertiary, width: 1.5),
          ),
        );
        break;
    }

    final Widget leftWidget;
    if (leftIconOverride != null &&
        status != PlugInItemStatus.completed) {
      leftWidget = Icon(
        leftIconOverride,
        color: status == PlugInItemStatus.active
            ? AppLightColors.accent
            : AppLightColors.textTertiary,
        size: 22,
      );
    } else {
      leftWidget = badge;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          leftWidget,
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: status == PlugInItemStatus.active
                    ? FontWeight.bold
                    : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          badge,
        ],
      ),
    );
  }
}

// ── Light Primary Button ──────────────────────────────────────────────────────
class _LightPrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LightPrimaryButton({
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                colors: [
                  AppLightColors.buttonGradientStart,
                  AppLightColors.buttonGradientEnd,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isEnabled ? null : AppLightColors.border,
        borderRadius: AppRadius.roundBorder,
        boxShadow: isEnabled ? AppLightShadows.button : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: AppRadius.roundBorder),
          padding: EdgeInsets.zero,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: AppTypography.labelLarge.copyWith(
                  color: isEnabled
                      ? Colors.white
                      : AppLightColors.textTertiary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

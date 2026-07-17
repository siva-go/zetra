import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/l10n/app_localizations.dart';

class PaymentStatus extends StatelessWidget {

  final bool isSuccess;
  final double amount;
  final double newBalance;

  const PaymentStatus({super.key, required this.isSuccess, required this.amount, required this.newBalance});

  @override
  Widget build(BuildContext context) {

    return _PaymentStatusView(
      isSuccess: isSuccess,
      amount: amount,
      newBalance: newBalance
    );

  }

}

class _PaymentStatusView extends StatefulWidget {

  final bool isSuccess;
  final double amount;
  final double newBalance;

  const _PaymentStatusView({required this.isSuccess, required this.amount, required this.newBalance});

  @override
  State<_PaymentStatusView> createState() => _PaymentStatusViewState();

}

class _PaymentStatusViewState extends State<_PaymentStatusView> with TickerProviderStateMixin {

  late final AnimationController _iconController;
  late final AnimationController _confettiController;
  late final AnimationController _pulseController;

  @override
  void initState() {

    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 700
      )
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1500
      )
    )..repeat(
        reverse: true
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 3000
      )
    );

    if (widget.isSuccess) {

      HapticFeedback.heavyImpact();

      Future<void>.delayed(const Duration(
          milliseconds: 300
      ), () {

        if (mounted) {

          _confettiController.forward();

        }

      });

    } else {

      HapticFeedback.vibrate();

    }

  }

  @override
  void dispose() {

    _iconController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppColors.navBackground,
      systemNavigationBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      body: Stack(
        children: <Widget>[
          if (widget.isSuccess)
            _ConfettiLayer(
                controller: _confettiController
            ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24.w
              ),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  _buildStatusIcon(isDark),
                  SizedBox(
                      height: 28.h
                  ),
                  _buildTitle(isDark),
                  SizedBox(
                      height: 6.h
                  ),
                  Text(
                      '₹ ${widget.amount.toStringAsFixed(2)}',
                      style: AppTypography.h2.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
                      )
                  ),
                  SizedBox(
                      height: 8.h
                  ),
                  _buildSubtitle(isDark),
                  SizedBox(
                      height: 36.h
                  ),
                  _buildAmountCard(isDark),
                  SizedBox(
                      height: 16.h
                  ),
                  if (widget.isSuccess) _buildBalanceRow(isDark),
                  const Spacer(),
                  _buildActionButtons(isDark),
                  SizedBox(
                      height: 36.h
                  )
                ]
              )
            )
          )
        ]
      )
    );

  }

  Widget _buildStatusIcon(bool isDark) {

    final Color glowColor = widget.isSuccess ? AppColors.primary : AppColors.chargingRed;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (BuildContext context, Widget? child) {

        return Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                glowColor.withValues(
                  alpha: 0.22 + _pulseController.value * 0.1
                ),
                glowColor.withValues(
                    alpha: 0.03
                )
              ]
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: glowColor.withValues(
                  alpha: 0.28 + _pulseController.value * 0.2
                ),
                blurRadius: 30 + _pulseController.value * 18,
                spreadRadius: 4
              )
            ]
          ),
          child: child
        );

      },
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _iconController,
          curve: Curves.elasticOut
        ),
        child: Container(
          margin: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isSuccess ? AppColors.primary : AppColors.chargingRed,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.isSuccess ? AppColors.primary.withValues(
                    alpha: 0.6
                ) : AppColors.chargingRed.withValues(
                    alpha: 0.6
                ),
                blurRadius: 22,
                spreadRadius: 2
              )
            ]
          ),
          child: Icon(
            widget.isSuccess ? Icons.check_rounded : Icons.close_rounded,
            color: AppColors.blackColor,
            size: 36.sp
          )
        )
      ),
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 200.ms
    );

  }

  Widget _buildTitle(bool isDark) {

    return Text(
      widget.isSuccess ? AppLocalizations.of(context).paymentSuccessful : AppLocalizations.of(context).paymentFailed,
      style: AppTypography.bodyMedium.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          height: 1.5
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 350.ms
    ).slideY(
        begin: 0.2
    );

  }

  Widget _buildSubtitle(bool isDark) {

    return Text(
      widget.isSuccess ? AppLocalizations.of(context).addedToWallet : AppLocalizations.of(context).paymentFailedSubtitle,
      textAlign: TextAlign.center,
      style: AppTypography.bodyMedium.copyWith(
        fontSize: 14.sp,
        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
        height: 1.5
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 400.ms
    ).slideY(
        begin: 0.2
    );

  }

  Widget _buildAmountCard(bool isDark) {

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 28.h,
          horizontal: 24.w
      ),
      child: Column(
        children: <Widget>[
          if (!widget.isSuccess) ...<Widget>[
            SizedBox(
                height: 10.h
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 5.h
              ),
              decoration: BoxDecoration(
                color: AppColors.chargingRed.withValues(
                    alpha: 0.12
                ),
                borderRadius: AppRadius.roundBorder,
                border: Border.all(
                  color: AppColors.chargingRed.withValues(
                      alpha: 0.4
                  )
                )
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.chargingRed,
                    size: 13
                  ),
                  SizedBox(
                      width: 5.w
                  ),
                  Text(
                    AppLocalizations.of(context).transactionDeclined,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.sp,
                      color: AppColors.chargingRed,
                      fontWeight: FontWeight.w600
                    )
                  )
                ]
              )
            )
          ]
        ]
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 450.ms
    ).scale(
      begin: const Offset(0.95, 0.95),
      curve: Curves.easeOutCubic
    );

  }

  Widget _buildBalanceRow(bool isDark) {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 14.h
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.whiteColor,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.borderLight
        )
      ),
      child: Row(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).currentBalance,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight
            )
          ),
          const Spacer(),
          Text(
            '₹ ${widget.newBalance.toStringAsFixed(2)}',
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
            )
          ),
          SizedBox(
              width: 4.w
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
            size: 18
          )
        ]
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 500.ms
    ).slideY(
        begin: 0.15
    );

  }

  Widget _buildActionButtons(bool isDark) {

    if (widget.isSuccess) {

      return _buildBackToHomeButton();

    }

    return Column(
      children: <Widget>[
        _buildRetryButton(),
        SizedBox(
            height: 12.h
        ),
        _buildBackToHomeButton()
      ]
    );

  }

  Widget _buildBackToHomeButton() {

    return GestureDetector(
      onTap: () {

        HapticFeedback.mediumImpact();
        context.go('/wallet');

      },
      child: Container(
        width: double.infinity,
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgBorder,
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF8B5CF6), Color(0xFF6D28D9)]
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(
                  alpha: 0.4
              ),
              blurRadius: 18,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: Text(
          AppLocalizations.of(context).backToHome,
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor
          )
        )
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 560.ms
    ).slideY(
        begin: 0.2
    );

  }

  Widget _buildRetryButton() {

    return GestureDetector(
      onTap: () {

        HapticFeedback.selectionClick();
        context.pop();

      },
      child: Container(
        width: double.infinity,
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgBorder,
          gradient: const LinearGradient(
            colors: <Color>[
              AppColors.chargingRed,
              AppColors.chargingRedGlow
            ]
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.chargingRed.withValues(
                  alpha: 0.4
              ),
              blurRadius: 18,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.refresh_rounded,
              color: AppColors.whiteColor,
              size: 18
            ),
            SizedBox(
                width: 8.w
            ),
            Text(
              AppLocalizations.of(context).tryAgain,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor
              )
            )
          ]
        )
      )
    ).animate().fadeIn(
        duration: 500.ms,
        delay: 510.ms
    ).slideY(
        begin: 0.2
    );

  }

}

class _ConfettiLayer extends StatelessWidget {

  final AnimationController controller;

  const _ConfettiLayer({required this.controller});

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {

        return CustomPaint(
          painter: _ConfettiPainter(
              progress: controller.value
          ),
          child: const SizedBox.expand()
        );

      }
    );

  }

}

class _ConfettiPainter extends CustomPainter {

  final double progress;

  static const List<Color> _colors = <Color>[
    Color(0xFF00C853),
    Color(0xFF5AC8FA),
    Color(0xFFFF073A),
    Color(0xFFFFD713),
    Color(0xFF8B5CF6),
    Color(0xFFFF9500),
    Color(0xFFFF2D92)
  ];

  const _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {

    if (progress <= 0) {

      return;

    }

    final math.Random rng = math.Random(42);

    for (int i = 0; i < 70; i++) {

      final double startX = rng.nextDouble() * size.width;
      final double delay = rng.nextDouble() * 0.4;
      final double speed = 0.4 + rng.nextDouble() * 0.6;
      final double t = ((progress - delay) / speed).clamp(0.0, 1.0);

      if (t <= 0) {

        continue;

      }

      final double x = startX + math.sin(t * math.pi * 2 + i) * 35;
      final double y = -20 + t * (size.height + 80);
      final Color color = _colors[i % _colors.length];
      final double particleSize = 4 + rng.nextDouble() * 7;
      final double angle = t * math.pi * 5 + i;
      final double alpha = (1 - t * 0.6).clamp(0.0, 1.0);

      final Paint paint = Paint()..color = color.withValues(
          alpha: alpha
      )..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      if (i % 3 == 0) {

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particleSize,
            height: particleSize * 0.5
          ),
          paint
        );

      } else if (i % 3 == 1) {

        canvas.drawCircle(Offset.zero, particleSize * 0.5, paint);

      } else {

        final Path path = Path()
          ..moveTo(0, -particleSize * 0.5)
          ..lineTo(particleSize * 0.4, particleSize * 0.5)
          ..lineTo(-particleSize * 0.4, particleSize * 0.5)
          ..close();
        canvas.drawPath(path, paint);

      }

      canvas.restore();

    }

  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;

}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/authentication/bloc/auth_state.dart';

class LoginOtp extends StatefulWidget {

  final String phone;

  const LoginOtp({super.key, required this.phone});

  @override
  State<LoginOtp> createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> with TickerProviderStateMixin {

  final List<TextEditingController> _controllers = List<TextEditingController>.generate(6, (int _) => TextEditingController());
  final List<FocusNode> _focusNodes = List<FocusNode>.generate(6, (int _) => FocusNode());
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {

    super.initState();

    context.read<AuthBloc>().add(StartOtpTimer());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 3
      )
    )..repeat(
        reverse: true
    );

    _pulseAnim = Tween<double>(
        begin: 0.8,
        end: 1
    ).animate(
      CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut
      )
    );

  }

  @override
  void dispose() {

    _pulseController.dispose();

    for (final TextEditingController controller in _controllers) {

      controller.dispose();

    }

    for (final FocusNode node in _focusNodes) {

      node.dispose();

    }

    super.dispose();

  }

  void _onOtpDigitChanged(int index, String value) {

    context.read<AuthBloc>().add(OtpDigitChanged(index, value));

    if (value.isNotEmpty) {

      if (index < 5) {

        _focusNodes[index + 1].requestFocus();

      } else {

        _focusNodes[index].unfocus();
        context.read<AuthBloc>().add(VerifyOtp());

      }

    } else {

      if (index > 0) {

        _focusNodes[index - 1].requestFocus();

      }

    }

  }

  void _resendOtp() {

    context.read<AuthBloc>().add(ResendOtp());

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color inputBg = isDark ? const Color(0xFF0F1321) : const Color(0xFFF1F3F9);

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _buildBackground(isDark, size)
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpacing.sm,
                        top: AppSpacing.sm
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: textPrimary,
                        size: 22
                      ),
                      onPressed: () => context.pop()
                    )
                  )
                ),
                Expanded(
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (BuildContext context, AuthState state) {

                      if (state.status == AuthStatus.verified) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OTP Verified Successfully!'),
                            backgroundColor: AppColors.primary,
                            duration: Duration(
                                seconds: 1
                            )
                          )
                        );

                        context.go('/charge-link');

                      } else if (state.otpDigits.every((String d) => d.isEmpty)) {

                        for (final TextEditingController controller in _controllers) {

                          controller.clear();

                        }

                      }

                    },
                    builder: (BuildContext context, AuthState state) {

                      final String timerString = 'Resend OTP in 00:${state.timerSeconds.toString().padLeft(2, '0')}';

                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height: size.height * 0.02
                            ),
                            Text(
                              'Verify OTP',
                              style: AppTypography.subtitle1.copyWith(
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                                fontSize: 26.sp
                              )
                            ).animate(
                                key: const ValueKey<String>('otp_title_anim')
                            ).fade(
                                duration: 150.ms
                            ),
                            SizedBox(
                                height: 10.sp
                            ),
                            Text(
                              'Enter the 6-digit code sent to\n${widget.phone}',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: textSecondary,
                                height: 1.5,
                                fontSize: 13.sp
                              )
                            ).animate(
                                key: const ValueKey<String>('otp_subtitle_anim')
                            ).fade(
                                duration: 150.ms
                            ),
                            SizedBox(
                                height: 46.sp
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List<Widget>.generate(6, (int index) {

                                final bool hasText = state.otpDigits[index].isNotEmpty;

                                return SizedBox(
                                  width: (MediaQuery.of(context).size.width - AppSpacing.lg * 2 - 40 - 10) / 6,
                                  height: 56,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: inputBg,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: hasText ? AppColors.primary : borderColor,
                                        width: 1.5
                                      ),
                                      boxShadow: hasText && isDark ? <BoxShadow>[
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                              alpha: 0.15
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 1
                                        )
                                      ] : null
                                    ),
                                    alignment: Alignment.center,
                                    child: state.status == AuthStatus.verifyingOtp ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)
                                      )
                                    ) : TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        contentPadding: EdgeInsets.zero
                                      ),
                                      onChanged: (String val) {

                                        _onOtpDigitChanged(index, val);

                                      }
                                    )
                                  )
                                );

                              })
                            ).animate(
                                key: const ValueKey<String>('otp_fields_anim')
                            ).fade(
                                duration: 200.ms
                            ),
                            SizedBox(
                                height: 18.sp
                            ),
                            Center(
                              child: state.timerSeconds > 0 ? Text(
                                timerString,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp
                                )
                              ) : TextButton(
                                onPressed: _resendOtp,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary
                                ),
                                child: Text(
                                  'Resend OTP',
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textSecondary,
                                    fontSize: 13.sp
                                  )
                                )
                              )
                            ).animate(
                                key: const ValueKey<String>('otp_timer_anim')
                            ).fade(
                                duration: 200.ms
                            ),
                            SizedBox(
                                height: size.height * 0.01
                            ),
                            Center(
                              child: Container(
                                height: 380.h,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                      image: AssetImage('assets/images/verify_otp.png')
                                  )
                                )
                              )
                            ).animate(
                                key: const ValueKey<String>('otp_shield_anim')
                            ).fade(
                                duration: 250.ms
                            ),
                            const SizedBox(
                                height: AppSpacing.lg
                            )
                          ]
                        )
                      );

                    }
                  )
                )
              ]
            )
          )
        ]
      )
    );

  }

  Widget _buildBackground(bool isDark, Size size) {

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF0A0E17),
                Color(0xFF0D1120),
                Color(0xFF0A0E17)
              ]
            ) : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFFF0F4FF),
                Color(0xFFF8F9FD),
                Color(0xFFEEF1FB)
              ]
            )
          )
        ),
        Positioned(
          top: -size.height * 0.1,
          left: -size.width * 0.2,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (BuildContext _, Widget? __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      AppColors.primary.withValues(
                          alpha: isDark ? 0.12 : 0.06
                      ),
                      Colors.transparent
                    ]
                  )
                )
              )
            )
          )
        ),
        Positioned(
          bottom: size.height * 0.05,
          right: -size.width * 0.2,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (BuildContext _, Widget? __) => Transform.scale(
              scale: 1.2 - (_pulseAnim.value - 0.8),
              child: Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      const Color(0xFF7B2FF7).withValues(
                          alpha: isDark ? 0.15 : 0.07
                      ),
                      Colors.transparent
                    ]
                  )
                )
              )
            )
          )
        )
      ]
    );

  }

}
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_spacing.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/authentication/bloc/auth_state.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {

  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {

    super.initState();

    final String currentPhone = context.read<AuthBloc>().state.phone;
    _phoneController.text = currentPhone;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 3
      ),
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

    _phoneController.dispose();
    _pulseController.dispose();
    super.dispose();

  }

  void _onPhoneChanged(String value) {

    context.read<AuthBloc>().add(PhoneChanged(value));

  }

  void _submit() {

    if (_formKey.currentState?.validate() ?? false) {

      HapticFeedback.lightImpact();
      context.read<AuthBloc>().add(SendOtp());

    }

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {

          if (state.status == AuthStatus.otpSent) {

            context.push('/otp?phone=%2B91%20${state.phone}');

          } else if (state.status == AuthStatus.error) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.redAccent
              )
            );

          }

        },
        builder: (BuildContext context, AuthState state) {

          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: _buildBackground(isDark, size)
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildHeroSection(isDark, size, keyboardOpen)
                    ),
                    _buildInputCard(isDark, state)
                  ]
                )
              )
            ]
          );

        }
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
                      AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06),
                      Colors.transparent
                    ]
                  )
                )
              )
            )
          )
        ),
        Positioned(
          bottom: size.height * 0.18,
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
                      const Color(0xFF7B2FF7).withValues(alpha: isDark ? 0.15 : 0.07),
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

  Widget _buildHeroSection(bool isDark, Size size, bool keyboardOpen) {

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: AppSpacing.lh
          ),
          Column(
            children: <Widget>[
              ShaderMask(
                shaderCallback: (Rect bounds) => const LinearGradient(
                  colors: <Color>[Color(0xFF00C853), Color(0xFF2EFE58)]
                ).createShader(bounds),
                child: Text(
                  'ZETRA',
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 48.sp,
                    letterSpacing: 10,
                    color: AppColors.whiteColor,
                    height: 1
                  )
                )
              ),
              SizedBox(
                  height: 4.h
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 28,
                    height: 1,
                    color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight
                  ),
                  SizedBox(
                      width: 6.w
                  ),
                  Text(
                    'EV CHARGING NETWORK',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  SizedBox(
                      width: 6.w
                  ),
                  Container(
                    width: 28,
                    height: 1,
                    color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight,
                  )
                ]
              )
            ]
          ).animate()
          .fade(
              duration: 700.ms
          ).slideY(
              begin: -0.15,
              end: 0,
              curve: Curves.easeOutCubic
          ),
          if (!keyboardOpen) ...<Widget>[
            SizedBox(
                height: AppSpacing.lh
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (isDark)
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (BuildContext _, Widget? __) => Container(
                        width: size.width * 0.7,
                        height: size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                  alpha: 0.18 * _pulseAnim.value
                              ),
                              blurRadius: 60,
                              spreadRadius: 10
                            )
                          ]
                        )
                      )
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 7.w
                    ),
                    child: Image.asset(
                        'assets/images/neon_green.png',
                      fit: BoxFit.contain,
                      height: size.height * 0.45
                    )
                  )
                ]
              )
            ).animate().fade(
                delay: 200.ms,
                duration: 800.ms
            ).scale(
                begin: const Offset(0.92, 0.92),
                curve: Curves.easeOutCubic
            )
          ]
        ]
      )
    );

  }

  Widget _buildInputCard(bool isDark, AuthState state) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color inputBg = isDark ? const Color(0xFF141927) : const Color(0xFFFFFFFF);
    final Color inputFocusGlow = state.isPhoneValid ? AppColors.primary.withValues(
        alpha: isDark ? 0.25 : 0.15
    ) : Colors.transparent;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF141927).withValues(
                alpha: 0.95
            ) : AppColors.whiteColor.withValues(
                alpha: 0.92
            ),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32)
            ),
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.whiteColor.withValues(
                    alpha: 0.08
                ) : AppColors.blackColor.withValues(
                    alpha: 0.06
                )
              )
            )
          ),
          padding: EdgeInsets.fromLTRB(AppSpacing.mw, AppSpacing.lh, AppSpacing.mw, AppSpacing.lh),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.whiteColor.withValues(
                          alpha: 0.15
                      ) : AppColors.blackColor.withValues(
                          alpha: 0.1
                      ),
                      borderRadius: BorderRadius.circular(100)
                    )
                  )
                ),
                SizedBox(
                    height: AppSpacing.mw
                ),
                Text(
                  'Welcome Back 👋',
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    height: 1.2
                  )
                ),
                SizedBox(
                    height: 4.sp
                ),
                Text(
                  'Enter your phone number to continue',
                  style: AppTypography.bodyMedium.copyWith(
                    color: textSecondary,
                    fontSize: 12.sp
                  )
                ),
                SizedBox(
                    height: AppSpacing.mw
                ),
                AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 280
                  ),
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: AppRadius.mdBorder,
                    border: Border.all(
                      color: state.isPhoneValid ? AppColors.primary : borderColor,
                      width: state.isPhoneValid ? 1.8 : 1.2
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: inputFocusGlow,
                        blurRadius: 16,
                        spreadRadius: 1
                      )
                    ]
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 14
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E2540) : const Color(0xFFF1F3F9),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                                '🇮🇳',
                                style: TextStyle(
                                    fontSize: 15.sp
                                )
                            ),
                            SizedBox(
                                width: 6.w
                            ),
                            Text(
                              '+91',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                                color: textPrimary
                              )
                            )
                          ]
                        )
                      ),
                      SizedBox(
                          width: 11.sp
                      ),
                      Container(
                        width: 1,
                        height: 22,
                        color: borderColor
                      ),
                      SizedBox(
                          width: 11.sp
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          onChanged: _onPhoneChanged,
                          style: AppTypography.bodyLarge.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            fontSize: 16
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: '98765 43210',
                            hintStyle: AppTypography.bodyLarge.copyWith(
                              color: isDark ? AppColors.textHint : AppColors.textHintLight,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                              fontSize: 15
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.sp
                            )
                          ),
                          validator: (String? value) {

                            if (value == null || value.isEmpty) {

                              return 'Please enter your phone number';

                            }

                            if (value.trim().length != 10) {

                              return 'Phone number must be 10 digits';

                            }

                            return null;

                          }
                        )
                      ),
                      AnimatedOpacity(
                        opacity: state.isPhoneValid ? 1 : 0,
                        duration: const Duration(
                            milliseconds: 200
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 14
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                            size: 20
                          )
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(
                    height: AppSpacing.md
                ),
                SizedBox(
                  height: 54,
                  child: AnimatedContainer(
                    duration: const Duration(
                        milliseconds: 280
                    ),
                    decoration: BoxDecoration(
                      gradient: state.isPhoneValid ? const LinearGradient(
                        colors: <Color>[
                          Color(0xFF7B2FF7),
                          Color(0xFF4A90E2)
                        ]
                      ) : null,
                      color: state.isPhoneValid ? null : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                      borderRadius: AppRadius.roundBorder,
                      boxShadow: state.isPhoneValid ? <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF7B2FF7).withValues(
                              alpha: isDark ? 0.45 : 0.3
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 8)
                        )
                      ] : null
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.roundBorder
                        )
                      ),
                      onPressed: state.isPhoneValid && state.status != AuthStatus.sendingOtp ? _submit : null,
                      child: state.status == AuthStatus.sendingOtp ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor)
                        )
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Get OTP',
                            style: AppTypography.labelLarge.copyWith(
                              color: state.isPhoneValid ? AppColors.whiteColor : (isDark ? AppColors.textTertiary : AppColors.textTertiaryLight),
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            )
                          ),
                          if (state.isPhoneValid) ...<Widget>[
                            const SizedBox(
                                width: 8
                            ),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.whiteColor,
                              size: 18
                            )
                          ]
                        ]
                      )
                    )
                  )
                ),
                SizedBox(
                    height: AppSpacing.sh
                ),
                Center(
                  child: Text(
                    'By continuing you agree to our Terms & Privacy Policy',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10.sp,
                      color: isDark ? AppColors.textTertiary : AppColors.textTertiaryLight
                    ),
                    textAlign: TextAlign.center
                  )
                ),
                const SizedBox(
                    height: AppSpacing.xs
                )
              ]
            )
          )
        )
      )
    ).animate().fade(
        delay: 300.ms,
        duration: 600.ms
    ).slideY(
        begin: 0.12,
        end: 0,
        curve: Curves.easeOutCubic
    );

  }

}
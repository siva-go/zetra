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
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/authentication/bloc/auth_state.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {

    super.initState();
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

    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pulseController.dispose();
    super.dispose();

  }

  void _submit() {

    if (_formKey.currentState?.validate() ?? false) {

      HapticFeedback.lightImpact();
      
      // Prepend +91 as required by backend register API
      final String formattedPhone = '+91${_phoneController.text.trim()}';

      context.read<AuthBloc>().add(
        SignUpSubmitted(
          fullName: _nameController.text.trim(),
          phone: formattedPhone,
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          password: _passwordController.text
        )
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {

          if (state.status == AuthStatus.registered) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).userRegisteredSuccess),
                backgroundColor: Colors.green
              )
            );

            context.go('/login');

          } else if (state.status == AuthStatus.error) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? AppLocalizations.of(context).registrationFailed),
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
                    _buildAppBar(isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height: 10.h
                            ),
                            _buildHeroSection(isDark),
                            SizedBox(
                                height: 20.h
                            ),
                            _buildInputCard(isDark, state)
                          ]
                        )
                      )
                    )
                  ]
                )
              )
            ]
          );

        }
      )
    );

  }

  Widget _buildAppBar(bool isDark) {

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm.sp,
          vertical: 8.h
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
              size: 22
            ),
            onPressed: () => context.pop()
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
        )
      ]
    );

  }

  Widget _buildHeroSection(bool isDark) {

    return Column(
      children: <Widget>[
        ShaderMask(
          shaderCallback: (Rect bounds) => const LinearGradient(
            colors: <Color>[Color(0xFF00C853), Color(0xFF2EFE58)]
          ).createShader(bounds),
          child: Text(
            'ZETRA',
            style: AppTypography.h3.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 36.sp,
              letterSpacing: 8,
              color: AppColors.whiteColor,
              height: 1
            )
          )
        ),
        SizedBox(
            height: 6.h
        ),
        Text(
          AppLocalizations.of(context).createDriverAccount,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10.sp,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
            letterSpacing: 2,
            fontWeight: FontWeight.w700
          )
        )
      ].animate().fade(
          duration: 500.ms
      ).slideY(
          begin: -0.1,
          end: 0
      )
    );

  }

  Widget _buildInputCard(bool isDark, AuthState state) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color borderColor = isDark ? const Color(0xFF2EFE58).withValues(alpha: 0.3) : const Color(0xFF2EFE58).withValues(alpha: 0.5);
    final Color inputBg = isDark ? const Color(0xFF141927) : const Color(0xFFFFFFFF);

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
          padding: EdgeInsets.fromLTRB(AppSpacing.mw, AppSpacing.mw, AppSpacing.mw, AppSpacing.lh),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).joinZetraNetwork,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: textPrimary
                      )
                    ),
                    const Icon(
                      Icons.ev_station_rounded,
                      color: Color(0xFF2EFE58),
                      size: 24,
                      shadows: <Shadow>[
                        Shadow(
                          color: Color(0xFF2EFE58),
                          blurRadius: 12
                        )
                      ]
                    )
                  ]
                ),
                SizedBox(
                    height: 4.h
                ),
                Text(
                  AppLocalizations.of(context).fillDetailsToGetStarted,
                  style: AppTypography.bodyMedium.copyWith(
                    color: textSecondary,
                    fontSize: 12.sp
                  )
                ),
                SizedBox(
                    height: 20.h
                ),
                // Name Input
                _buildLabel(AppLocalizations.of(context).fullName, isDark),
                _buildTextField(
                  controller: _nameController,
                  hintText: AppLocalizations.of(context).fullNameHint,
                  icon: Icons.person_outline_rounded,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  isDark: isDark,
                  validator: (String? value) {

                    if (value == null || value.trim().isEmpty) {

                      return AppLocalizations.of(context).fullNameValidation;

                    }

                    return null;

                  }
                ),
                SizedBox(
                    height: 16.h
                ),
                // Phone Input
                _buildLabel(AppLocalizations.of(context).phoneNumber, isDark),
                _buildPhoneField(inputBg, borderColor, textPrimary, isDark),
                SizedBox(
                    height: 16.h
                ),
                 // Email Input
                _buildLabel(AppLocalizations.of(context).emailAddressOptional, isDark),
                _buildTextField(
                  controller: _emailController,
                  hintText: AppLocalizations.of(context).emailHint,
                  icon: Icons.mail_outline_rounded,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {

                    if (value != null && value.trim().isNotEmpty) {

                      final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegExp.hasMatch(value.trim())) {

                        return AppLocalizations.of(context).emailValidation;

                      }

                    }

                    return null;

                  }
                ),
                SizedBox(
                    height: 16.h
                ),
                // Password Input
                _buildLabel(AppLocalizations.of(context).password, isDark),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  inputBg: inputBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  isDark: isDark,
                  obscureText: !state.isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: textSecondary,
                      size: 20
                    ),
                    onPressed: () {

                      context.read<AuthBloc>().add(TogglePasswordVisibility());

                    }
                  ),
                  validator: (String? value) {

                    if (value == null || value.isEmpty) {

                      return AppLocalizations.of(context).passwordValidationEmpty;

                    }

                    if (value.length < 6) {

                      return AppLocalizations.of(context).passwordValidationLength;

                    }

                    return null;

                  }
                ),
                SizedBox(
                    height: 24.h
                ),
                // Submit Button
                SizedBox(
                  height: 54,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF7B2FF7), Color(0xFF4A90E2)],
                      ),
                      borderRadius: AppRadius.roundBorder,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF7B2FF7).withValues(
                              alpha: isDark ? 0.45 : 0.3
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 8)
                        )
                      ]
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.roundBorder
                        )
                      ),
                      onPressed: state.status == AuthStatus.sendingOtp ? null : _submit,
                      child: state.status == AuthStatus.sendingOtp ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor)
                        )
                      ) : Text(
                        AppLocalizations.of(context).signUp,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5
                        )
                      )
                    )
                  )
                )
              ]
            )
          )
        )
      )
    ).animate().fade(
        delay: 200.ms,
        duration: 500.ms
    ).slideY(
        begin: 0.1,
        end: 0
    );

  }

  Widget _buildLabel(String text, bool isDark) {

    return Padding(
      padding: EdgeInsets.only(
          bottom: 6.h,
          left: 4.w
      ),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          fontSize: 11.sp
        )
      )
    );

  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, required Color inputBg, required Color borderColor, required Color textPrimary, required bool isDark, bool obscureText = false, Widget? suffixIcon, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600
      ),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: inputBg,
        prefixIcon: Icon(
            icon, color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
            size: 20
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.textHint : AppColors.textHintLight,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(
              color: borderColor,
              width: 1.2
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(
              color: borderColor,
              width: 1.2
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: const BorderSide(
              color: Color(0xFF2EFE58),
              width: 1.5
          )
        )
      )
    );

  }

  Widget _buildPhoneField(Color inputBg, Color borderColor, Color textPrimary, bool isDark) {

    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      style: AppTypography.bodyMedium.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (String? value) {

        if (value == null || value.isEmpty) {

          return 'Please enter your phone number';

        }

        if (value.trim().length != 10) {

          return 'Phone number must be 10 digits';

        }

        return null;

      },
      decoration: InputDecoration(
        filled: true,
        fillColor: inputBg,
        counterText: '',
        prefixIcon: Container(
          width: 70.w,
          margin: EdgeInsets.only(
              right: 8.w
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 8.w
              ),
              Text(
                  '🇮🇳',
                  style: TextStyle(
                      fontSize: 15.sp
                  )
              ),
              SizedBox(
                  width: 4.w
              ),
              Text(
                '+91',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textPrimary
                )
              )
            ]
          )
        ),
        hintText: '1234',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.textHint : AppColors.textHintLight,
          fontWeight: FontWeight.w400,
          letterSpacing: 1
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 14.h
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(
              color: borderColor,
              width: 1.2
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(
              color: borderColor,
              width: 1.2
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: const BorderSide(
              color: Color(0xFF2EFE58),
              width: 1.5
          )
        )
      )
    );

  }

}
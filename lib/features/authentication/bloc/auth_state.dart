import 'package:flutter/foundation.dart';

enum AuthStatus { initial, sendingOtp, otpSent, verifyingOtp, verified, error, registered, authenticated, unauthenticated }

@immutable
class AuthState {

  final String phone;
  final bool isPhoneValid;
  final List<String> otpDigits;
  final int timerSeconds;
  final AuthStatus status;
  final bool isPasswordVisible;
  final String? errorMessage;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    required this.phone,
    required this.isPhoneValid,
    required this.otpDigits,
    required this.timerSeconds,
    required this.status,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.accessToken,
    this.refreshToken
  });

  factory AuthState.initial() {

    return AuthState(
      phone: '',
      isPhoneValid: false,
      otpDigits: List<String>.filled(6, ''),
      timerSeconds: 30,
      status: AuthStatus.initial
    );

  }

  AuthState copyWith({String? phone, bool? isPhoneValid, List<String>? otpDigits, int? timerSeconds, AuthStatus? status, bool? isPasswordVisible, String? errorMessage, String? accessToken, String? refreshToken}) {

    return AuthState(
      phone: phone ?? this.phone,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      otpDigits: otpDigits ?? this.otpDigits,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken
    );

  }

}
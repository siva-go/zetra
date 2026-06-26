import 'package:flutter/foundation.dart';

enum AuthStatus { initial, sendingOtp, otpSent, verifyingOtp, verified, error }

@immutable
class AuthState {

  final String phone;
  final bool isPhoneValid;
  final List<String> otpDigits;
  final int timerSeconds;
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    required this.phone,
    required this.isPhoneValid,
    required this.otpDigits,
    required this.timerSeconds,
    required this.status,
    this.errorMessage
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

  AuthState copyWith({String? phone, bool? isPhoneValid, List<String>? otpDigits, int? timerSeconds, AuthStatus? status, String? errorMessage}) {

    return AuthState(
      phone: phone ?? this.phone,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      otpDigits: otpDigits ?? this.otpDigits,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
    );

  }

}
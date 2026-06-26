import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/authentication/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  Timer? _timer;

  AuthBloc() : super(AuthState.initial()) {
    on<PhoneChanged>(_onPhoneChanged);
    on<SendOtp>(_onSendOtp);
    on<OtpDigitChanged>(_onOtpDigitChanged);
    on<VerifyOtp>(_onVerifyOtp);
    on<StartOtpTimer>(_onStartOtpTimer);
    on<TickOtpTimer>(_onTickOtpTimer);
    on<ResendOtp>(_onResendOtp);
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<AuthState> emit) {

    final String cleanPhone = event.phone.trim();
    final bool isValid = cleanPhone.length == 10 && RegExp(r'^\d+$').hasMatch(cleanPhone);

    emit(state.copyWith(
      phone: cleanPhone,
      isPhoneValid: isValid,
      status: AuthStatus.initial
    ));

  }

  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {

    if (!state.isPhoneValid) {

      return;

    }
    emit(state.copyWith(
        status: AuthStatus.sendingOtp
    ));

    await Future<void>.delayed(const Duration(
        milliseconds: 800
    ));

    emit(state.copyWith(
      status: AuthStatus.otpSent,
      otpDigits: List<String>.filled(6, '')
    ));

  }

  void _onOtpDigitChanged(OtpDigitChanged event, Emitter<AuthState> emit) {

    final List<String> newDigits = List<String>.from(state.otpDigits);

    if (event.index >= 0 && event.index < 6) {

      newDigits[event.index] = event.digit;

    }

    emit(state.copyWith(
      otpDigits: newDigits,
    ));

  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {

    final String otp = state.otpDigits.join();

    if (otp.length != 6) {

      return;

    }

    emit(state.copyWith(
        status: AuthStatus.verifyingOtp
    ));

    await Future<void>.delayed(const Duration(
        milliseconds: 800
    ));

    emit(state.copyWith(
        status: AuthStatus.verified
    ));

  }

  void _onStartOtpTimer(StartOtpTimer event, Emitter<AuthState> emit) {

    _timer?.cancel();

    emit(state.copyWith(
      timerSeconds: 30,
      status: AuthStatus.initial
    ));

    _timer = Timer.periodic(const Duration(
        seconds: 1
    ), (Timer timer) {

      add(TickOtpTimer());

    });

  }

  void _onTickOtpTimer(TickOtpTimer event, Emitter<AuthState> emit) {

    if (state.timerSeconds > 0) {

      emit(state.copyWith(
          timerSeconds: state.timerSeconds - 1
      ));

    } else {

      _timer?.cancel();

    }

  }

  void _onResendOtp(ResendOtp event, Emitter<AuthState> emit) {

    _timer?.cancel();

    emit(state.copyWith(
      timerSeconds: 30,
      otpDigits: List<String>.filled(6, '')
    ));

    _timer = Timer.periodic(const Duration(
        seconds: 1
    ), (Timer timer) {

      add(TickOtpTimer());

    });

  }

  @override
  Future<void> close() {

    _timer?.cancel();
    return super.close();

  }

}
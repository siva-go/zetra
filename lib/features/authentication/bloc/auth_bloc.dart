import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/storage/secure_storage.dart';
import 'package:zetra/features/authentication/bloc/auth_event.dart';
import 'package:zetra/features/authentication/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  Timer? _timer;

  AuthBloc(this._apiClient, this._secureStorage) : super(AuthState.initial()) {
    on<PhoneChanged>(_onPhoneChanged);
    on<SendOtp>(_onSendOtp);
    on<OtpDigitChanged>(_onOtpDigitChanged);
    on<VerifyOtp>(_onVerifyOtp);
    on<StartOtpTimer>(_onStartOtpTimer);
    on<TickOtpTimer>(_onTickOtpTimer);
    on<ResendOtp>(_onResendOtp);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<AuthState> emit) {

    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible
    ));

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

    try {

      final Response<dynamic> response = await _apiClient.dio.post(
        'https://zetra-production.up.railway.app/api/v1/auth/login',
        data: <String, dynamic>{
          'email': 'driver@example.com',
          'phone': state.phone,
          'password': 'correct-horse-battery-staple'
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        final Map<String, dynamic> data = response.data as Map<String, dynamic>;

        emit(state.copyWith(
          status: AuthStatus.otpSent,
          otpDigits: List<String>.filled(6, ''),
          accessToken: data['accessToken'] as String?,
          refreshToken: data['refreshToken'] as String?
        ));

      } else {

        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid phone number or credentials'
        ));

      }

    } on DioException catch (e) {

      String errMsg = 'Invalid phone number or credentials';

      try {

        final dynamic responseData = e.response?.data;
        Map<dynamic, dynamic>? dataMap;

        if (responseData is Map) {

          dataMap = responseData;

        } else if (responseData is String && responseData.isNotEmpty) {

          final dynamic decoded = jsonDecode(responseData);

          if (decoded is Map) {

            dataMap = decoded;

          }

        }

        if (dataMap != null) {

          errMsg = dataMap['message']?.toString() ?? errMsg;

        }

      } catch (_) {

        // Parsing failed, keep default errMsg

      }

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: errMsg
      ));

    } catch (e) {

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred'
      ));

    }

  }

  Future<void> _onSignUpSubmitted(SignUpSubmitted event, Emitter<AuthState> emit) async {

    emit(state.copyWith(
      status: AuthStatus.sendingOtp,
      phone: event.phone
    ));

    try {

      final Response<dynamic> response = await _apiClient.dio.post(
        'https://zetra-production.up.railway.app/api/v1/auth/register',
        data: <String, dynamic>{
          'email': event.email,
          'phone': event.phone,
          'password': event.password,
          'fullName': event.fullName
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        emit(state.copyWith(
          status: AuthStatus.registered
        ));

      } else {

        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed'
        ));

      }

    } on DioException catch (e) {

      String errMsg = 'Registration failed';

      try {

        final dynamic responseData = e.response?.data;
        Map<dynamic, dynamic>? dataMap;

        if (responseData is Map) {

          dataMap = responseData;

        } else if (responseData is String && responseData.isNotEmpty) {

          final dynamic decoded = jsonDecode(responseData);

          if (decoded is Map) {

            dataMap = decoded;

          }

        }

        if (e.response?.statusCode == 409 || (dataMap?['message']?.toString().toLowerCase().contains('already exists') ?? false)) {

          errMsg = 'User already exists. Please login.';

        } else if (dataMap != null) {

          errMsg = dataMap['message']?.toString() ?? errMsg;

        }

      } catch (_) {

        // Parsing failed, keep default errMsg

      }

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: errMsg
      ));

    } catch (e) {

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}'
      ));

    }

  }

  void _onOtpDigitChanged(OtpDigitChanged event, Emitter<AuthState> emit) {

    final List<String> newDigits = List<String>.from(state.otpDigits);

    if (event.index >= 0 && event.index < 6) {

      newDigits[event.index] = event.digit;

    }

    emit(state.copyWith(
      otpDigits: newDigits
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

    if (otp == '123456') {

      if (state.accessToken != null) {

        await _secureStorage.saveAccessToken(state.accessToken!);

      }

      if (state.refreshToken != null) {

        await _secureStorage.saveRefreshToken(state.refreshToken!);

      }

      emit(state.copyWith(
          status: AuthStatus.verified
      ));

    } else {

      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP'
      ));

    }

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

  Future<void> _onResendOtp(ResendOtp event, Emitter<AuthState> emit) async {

    _timer?.cancel();

    emit(state.copyWith(
      timerSeconds: 30,
      otpDigits: List<String>.filled(6, ''),
      status: AuthStatus.sendingOtp,
    ));

    _timer = Timer.periodic(const Duration(
        seconds: 1
    ), (Timer timer) {

      add(TickOtpTimer());

    });

    try {

      final Response<dynamic> response = await _apiClient.dio.post(
        'https://zetra-production.up.railway.app/api/v1/auth/login',
        data: <String, dynamic>{
          'email': 'driver@example.com',
          'phone': state.phone,
          'password': 'correct-horse-battery-staple'
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        emit(state.copyWith(
          status: AuthStatus.otpSent,
          accessToken: data['accessToken'] as String?,
          refreshToken: data['refreshToken'] as String?
        ));

      } else {

        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid phone number or credentials'
        ));

      }

    } on DioException catch (e) {

      String errMsg = 'Invalid phone number or credentials';

      try {

        final dynamic responseData = e.response?.data;
        Map<dynamic, dynamic>? dataMap;

        if (responseData is Map) {

          dataMap = responseData;

        } else if (responseData is String && responseData.isNotEmpty) {

          final dynamic decoded = jsonDecode(responseData);

          if (decoded is Map) {

            dataMap = decoded;

          }

        }

        if (dataMap != null) {

          errMsg = dataMap['message']?.toString() ?? errMsg;

        }

      } catch (_) {

        // Parsing failed, keep default errMsg

      }

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: errMsg
      ));

    } catch (e) {

      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred'
      ));

    }

  }

  @override
  Future<void> close() {

    _timer?.cancel();
    return super.close();

  }

}
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {}

class PhoneChanged extends AuthEvent {

  final String phone;
  PhoneChanged(this.phone);

}

class SendOtp extends AuthEvent {}

class OtpDigitChanged extends AuthEvent {

  final int index;
  final String digit;
  OtpDigitChanged(this.index, this.digit);

}

class VerifyOtp extends AuthEvent {}

class StartOtpTimer extends AuthEvent {}

class TickOtpTimer extends AuthEvent {}

class ResendOtp extends AuthEvent {}
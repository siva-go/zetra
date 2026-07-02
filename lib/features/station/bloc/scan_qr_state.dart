import 'package:flutter/foundation.dart';

enum ScanQrStatus { initial, scanning, detected, processing, success, error }

@immutable
class ScanQrState {
  final ScanQrStatus status;
  final bool isFlashOn;
  final String? scannedCode;
  final String? errorMessage;

  const ScanQrState({
    required this.status,
    required this.isFlashOn,
    this.scannedCode,
    this.errorMessage,
  });

  factory ScanQrState.initial() {
    return const ScanQrState(
      status: ScanQrStatus.initial,
      isFlashOn: false,
    );
  }

  ScanQrState copyWith({
    ScanQrStatus? status,
    bool? isFlashOn,
    String? scannedCode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScanQrState(
      status: status ?? this.status,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      scannedCode: scannedCode ?? this.scannedCode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

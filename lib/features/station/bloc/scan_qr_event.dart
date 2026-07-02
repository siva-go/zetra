import 'package:flutter/foundation.dart';

@immutable
abstract class ScanQrEvent {
  const ScanQrEvent();
}

class ScanQrInitialized extends ScanQrEvent {
  const ScanQrInitialized();
}

class QrCodeDetected extends ScanQrEvent {
  final String code;
  const QrCodeDetected(this.code);
}

class EnterManualIdTapped extends ScanQrEvent {
  const EnterManualIdTapped();
}

class FlashlightToggled extends ScanQrEvent {
  const FlashlightToggled();
}

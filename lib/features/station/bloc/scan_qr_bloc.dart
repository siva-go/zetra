import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/station/bloc/scan_qr_event.dart';
import 'package:zetra/features/station/bloc/scan_qr_state.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  ScanQrBloc() : super(ScanQrState.initial()) {
    on<ScanQrInitialized>(_onInitialized);
    on<QrCodeDetected>(_onQrCodeDetected);
    on<EnterManualIdTapped>(_onEnterManualIdTapped);
    on<FlashlightToggled>(_onFlashlightToggled);
  }

  void _onInitialized(ScanQrInitialized event, Emitter<ScanQrState> emit) {
    emit(state.copyWith(status: ScanQrStatus.scanning));
  }

  void _onQrCodeDetected(QrCodeDetected event, Emitter<ScanQrState> emit) async {
    // Only process if we are currently scanning
    if (state.status != ScanQrStatus.scanning) return;

    emit(state.copyWith(
      status: ScanQrStatus.processing,
      scannedCode: event.code,
    ));

    // Simulate API verification
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // Assume success for demo
    emit(state.copyWith(status: ScanQrStatus.success));
  }

  void _onEnterManualIdTapped(EnterManualIdTapped event, Emitter<ScanQrState> emit) {
    // Just reset any error and keep scanning state if needed
    // In a real app, this might navigate or show a bottom sheet, handled in the UI listener
    emit(state.copyWith(clearError: true));
  }

  void _onFlashlightToggled(FlashlightToggled event, Emitter<ScanQrState> emit) {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }
}

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

    emit(state.copyWith(
        status: ScanQrStatus.scanning
    ));

  }

  Future<void> _onQrCodeDetected(QrCodeDetected event, Emitter<ScanQrState> emit) async {

    if (state.status != ScanQrStatus.scanning) {

      return;

    }

    emit(state.copyWith(
      status: ScanQrStatus.processing,
      scannedCode: event.code,
    ));

    await Future<void>.delayed(const Duration(
        milliseconds: 1000
    ));

    emit(state.copyWith(
        status: ScanQrStatus.success
    ));

  }

  void _onEnterManualIdTapped(EnterManualIdTapped event, Emitter<ScanQrState> emit) {

    emit(state.copyWith(
      status: ScanQrStatus.scanning,
      clearError: true
    ));

  }

  void _onFlashlightToggled(FlashlightToggled event, Emitter<ScanQrState> emit) {

    emit(state.copyWith(
        isFlashOn: !state.isFlashOn
    ));

  }

}
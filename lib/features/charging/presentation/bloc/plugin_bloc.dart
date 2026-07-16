import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'plugin_event.dart';
import 'plugin_state.dart';

class PlugInBloc extends Bloc<PlugInEvent, PlugInState> {
  Timer? _timer;

  PlugInBloc() : super(PlugInState.initial()) {
    on<StartConnectionSimulation>(_onStartConnectionSimulation);
    on<SetVehicleConnected>(_onSetVehicleConnected);
    on<SetChargingAutostart>(_onSetChargingAutostart);
    on<SetPlugInCompleted>(_onSetPlugInCompleted);
    on<ResetPlugin>(_onResetPlugin);
  }

  void _onStartConnectionSimulation(
      StartConnectionSimulation event, Emitter<PlugInState> emit) {
    if (state.status != PluginStatus.initial) return;

    _timer?.cancel();

    // 1. Mark 'Waiting for Plug-In' as completed, make 'Vehicle Connected' active.
    emit(state.copyWith(
      status: PluginStatus.connecting,
      waitingForPlugIn: PlugInItemStatus.completed,
      vehicleConnected: PlugInItemStatus.active,
    ));

    // Schedule next step transition in 1.2 seconds
    _timer = Timer(const Duration(milliseconds: 1200), () {
      add(SetVehicleConnected());
    });
  }

  void _onSetVehicleConnected(
      SetVehicleConnected event, Emitter<PlugInState> emit) {
    if (state.status != PluginStatus.connecting) return;

    // 2. Mark 'Vehicle Connected' as completed, make 'Charging Autostart' active.
    emit(state.copyWith(
      vehicleConnected: PlugInItemStatus.completed,
      chargingAutostart: PlugInItemStatus.active,
    ));

    // Schedule next step transition in 1.2 seconds
    _timer = Timer(const Duration(milliseconds: 1200), () {
      add(SetChargingAutostart());
    });
  }

  void _onSetChargingAutostart(
      SetChargingAutostart event, Emitter<PlugInState> emit) {
    if (state.status != PluginStatus.connecting) return;

    // 3. Mark 'Charging Autostart' as completed.
    emit(state.copyWith(
      chargingAutostart: PlugInItemStatus.completed,
    ));

    // Schedule final completion in 1 second
    _timer = Timer(const Duration(milliseconds: 1000), () {
      add(SetPlugInCompleted());
    });
  }

  void _onSetPlugInCompleted(
      SetPlugInCompleted event, Emitter<PlugInState> emit) {
    emit(state.copyWith(
      status: PluginStatus.completed,
    ));
  }

  void _onResetPlugin(ResetPlugin event, Emitter<PlugInState> emit) {
    _timer?.cancel();
    emit(PlugInState.initial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

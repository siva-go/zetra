import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'charging_event.dart';
import 'charging_state.dart';

class ChargingBloc extends Bloc<ChargingEvent, ChargingState> {
  Timer? _ticker;
  final Random _random = Random();

  ChargingBloc() : super(ChargingState.initial()) {
    on<StartCharging>(_onStartCharging);
    on<TickCharging>(_onTickCharging);
    on<StopCharging>(_onStopCharging);
    on<ResetCharging>(_onResetCharging);
  }

  void _onStartCharging(StartCharging event, Emitter<ChargingState> emit) {
    if (state.status == ChargingStatus.charging) return;

    _ticker?.cancel();
    emit(state.copyWith(
      status: ChargingStatus.charging,
      chargingSpeed: 82.5, // Initial active charging speed
    ));

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TickCharging());
    });
  }

  void _onTickCharging(TickCharging event, Emitter<ChargingState> emit) {
    if (state.status != ChargingStatus.charging) {
      _ticker?.cancel();
      return;
    }

    final currentSoc = state.soc + 0.005; // Increase by 0.5% per tick for realistic smooth demo
    if (currentSoc >= 1.0) {
      _ticker?.cancel();
      emit(state.copyWith(
        status: ChargingStatus.completed,
        soc: 1.0,
        chargingSpeed: 0.0,
        timeRemaining: Duration.zero,
      ));
      return;
    }

    // Dynamic metrics simulation
    final speedFluctuation = (currentSoc > 0.8) 
        ? -1.5 - _random.nextDouble() * 1.5 // Taper speed above 80%
        : (_random.nextDouble() * 4.0 - 2.0); // Small fluctuation
    final newSpeed = max(11.0, state.chargingSpeed + speedFluctuation);
    
    final newEnergy = state.energyDelivered + (newSpeed / 3600); // simulated kWh added
    
    // Time remaining drops proportionally as SOC increases
    final totalMinutesLeft = max(0, (38 * (1.0 - currentSoc) / 0.55).toInt());
    final newTimeRemaining = Duration(minutes: totalMinutesLeft);
    
    final newElapsedTime = state.elapsedTime + const Duration(seconds: 1);
    
    // Temperature rises slightly during charging
    final newTemp = min(42.0, state.batteryTemp + 0.01);

    emit(state.copyWith(
      soc: currentSoc,
      chargingSpeed: double.parse(newSpeed.toStringAsFixed(1)),
      energyDelivered: double.parse(newEnergy.toStringAsFixed(2)),
      timeRemaining: newTimeRemaining,
      elapsedTime: newElapsedTime,
      batteryTemp: double.parse(newTemp.toStringAsFixed(1)),
    ));
  }

  void _onStopCharging(StopCharging event, Emitter<ChargingState> emit) {
    _ticker?.cancel();
    emit(state.copyWith(
      status: ChargingStatus.stopped,
      chargingSpeed: 0.0,
    ));
  }

  void _onResetCharging(ResetCharging event, Emitter<ChargingState> emit) {
    _ticker?.cancel();
    emit(ChargingState.initial());
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/services/live_activity_service.dart';
import 'package:zetra/features/charging/bloc/charging_event.dart';
import 'package:zetra/features/charging/bloc/charging_state.dart';

class ChargingBloc extends Bloc<ChargingEvent, ChargingState> {

  Timer? _ticker;
  final Random _random = Random();

  ChargingBloc() : super(ChargingState.initial()) {
    on<StartCharging>(_onStartCharging);
    on<TickCharging>(_onTickCharging);
    on<StopCharging>(_onStopCharging);
    on<ResetCharging>(_onResetCharging);
    // Initialize platform callback for notification action clicks
    LiveActivityService.instance.init(
      onStopRequested: () {

        add(StopCharging());

      }
    );
  }

  void _onStartCharging(StartCharging event, Emitter<ChargingState> emit) {

    if (state.status == ChargingStatus.charging) {

      return;

    }

    _ticker?.cancel();

    const double initialSpeed = 82.5;
    const double initialCost = 0;

    emit(state.copyWith(
      status: ChargingStatus.charging,
      chargingSpeed: initialSpeed,
      cost: initialCost
    ));

    LiveActivityService.instance.start(
      soc: state.soc,
      timeRemainingMins: state.timeRemaining.inMinutes,
      speedKw: initialSpeed,
      costRm: initialCost
    );

    _ticker = Timer.periodic(const Duration(
        seconds: 1
    ), (Timer timer) {

      add(TickCharging());

    });

  }

  void _onTickCharging(TickCharging event, Emitter<ChargingState> emit) {

    if (state.status != ChargingStatus.charging) {

      _ticker?.cancel();
      return;

    }

    final double currentSoc = state.soc + 0.005; // Increase by 0.5% per tick for realistic smooth demo

    if (currentSoc >= 1.0) {

      _ticker?.cancel();
      emit(state.copyWith(
        status: ChargingStatus.completed,
        soc: 1,
        chargingSpeed: 0,
        timeRemaining: Duration.zero
      ));

      LiveActivityService.instance.stop();

      return;

    }

    // Dynamic metrics simulation
    final double speedFluctuation = (currentSoc > 0.8) ? -1.5 - _random.nextDouble() * 1.5 // Taper speed above 80%
        : (_random.nextDouble() * 4.0 - 2.0); // Small fluctuation
    final double newSpeed = max(11, state.chargingSpeed + speedFluctuation);
    final double newEnergy = state.energyDelivered + (newSpeed / 3600); // simulated kWh added
    // Time remaining drops proportionally as SOC increases
    final int totalMinutesLeft = max(0, (38 * (1.0 - currentSoc) / 0.55).toInt());
    final Duration newTimeRemaining = Duration(
        minutes: totalMinutesLeft
    );
    final Duration newElapsedTime = state.elapsedTime + const Duration(
        seconds: 1
    );
    // Temperature rises slightly during charging
    final double newTemp = min(42, state.batteryTemp + 0.01);
    
    // cost calculated dynamically
    final double newCost = double.parse((newEnergy * 1.25).toStringAsFixed(2));

    emit(state.copyWith(
      soc: currentSoc,
      chargingSpeed: double.parse(newSpeed.toStringAsFixed(1)),
      energyDelivered: double.parse(newEnergy.toStringAsFixed(2)),
      timeRemaining: newTimeRemaining,
      elapsedTime: newElapsedTime,
      batteryTemp: double.parse(newTemp.toStringAsFixed(1)),
      cost: newCost
    ));

    LiveActivityService.instance.update(
      soc: currentSoc,
      timeRemainingMins: totalMinutesLeft,
      speedKw: double.parse(newSpeed.toStringAsFixed(1)),
      costRm: newCost
    );

  }

  void _onStopCharging(StopCharging event, Emitter<ChargingState> emit) {

    _ticker?.cancel();

    emit(state.copyWith(
      status: ChargingStatus.stopped,
      chargingSpeed: 0
    ));

    LiveActivityService.instance.stop();

  }

  void _onResetCharging(ResetCharging event, Emitter<ChargingState> emit) {

    _ticker?.cancel();
    emit(ChargingState.initial());

    LiveActivityService.instance.stop();

  }

  @override
  Future<void> close() {

    _ticker?.cancel();
    return super.close();

  }

}
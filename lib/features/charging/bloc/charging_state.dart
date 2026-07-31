import 'package:flutter/foundation.dart';

enum ChargingStatus { initial, charging, stopped, completed }

@immutable
class ChargingState {

  final ChargingStatus status;
  final double soc; // State of Charge percentage (0.0 to 1.0)
  final double chargingSpeed; // kW (e.g. 85.2)
  final double energyDelivered; // kWh
  final Duration timeRemaining;
  final Duration elapsedTime;
  final double batteryTemp; // °C
  final double cost; // RM cost
  final bool isDarkMode;

  const ChargingState({
    required this.status,
    required this.soc,
    required this.chargingSpeed,
    required this.energyDelivered,
    required this.timeRemaining,
    required this.elapsedTime,
    required this.batteryTemp,
    required this.cost,
    required this.isDarkMode
  });

  factory ChargingState.initial() {

    return const ChargingState(
      status: ChargingStatus.initial,
      soc: 0.45, // start from 45% as in mockup / design requirements
      chargingSpeed: 0,
      energyDelivered: 0,
      timeRemaining: Duration(
          minutes: 38
      ),
      elapsedTime: Duration.zero,
      batteryTemp: 29.5,
      cost: 0,
      isDarkMode: true
    );

  }

  ChargingState copyWith({ChargingStatus? status, double? soc, double? chargingSpeed, double? energyDelivered, Duration? timeRemaining, Duration? elapsedTime, double? batteryTemp, double? cost, bool? isDarkMode}) {

    return ChargingState(
      status: status ?? this.status,
      soc: soc ?? this.soc,
      chargingSpeed: chargingSpeed ?? this.chargingSpeed,
      energyDelivered: energyDelivered ?? this.energyDelivered,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      batteryTemp: batteryTemp ?? this.batteryTemp,
      cost: cost ?? this.cost,
      isDarkMode: isDarkMode ?? this.isDarkMode
    );

  }

}
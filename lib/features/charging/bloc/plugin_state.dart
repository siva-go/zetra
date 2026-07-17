import 'package:flutter/foundation.dart';

enum PluginStatus { initial, connecting, completed }

enum PlugInItemStatus { pending, active, completed }

@immutable
class PlugInState {

  final PluginStatus status;
  final PlugInItemStatus sessionInitiated;
  final PlugInItemStatus paymentSuccessful;
  final PlugInItemStatus waitingForPlugIn;
  final PlugInItemStatus vehicleConnected;
  final PlugInItemStatus chargingAutostart;

  const PlugInState({
    required this.status,
    required this.sessionInitiated,
    required this.paymentSuccessful,
    required this.waitingForPlugIn,
    required this.vehicleConnected,
    required this.chargingAutostart
  });

  factory PlugInState.initial() {

    return const PlugInState(
      status: PluginStatus.initial,
      sessionInitiated: PlugInItemStatus.completed,
      paymentSuccessful: PlugInItemStatus.completed,
      waitingForPlugIn: PlugInItemStatus.active,
      vehicleConnected: PlugInItemStatus.pending,
      chargingAutostart: PlugInItemStatus.pending
    );

  }

  PlugInState copyWith({PluginStatus? status, PlugInItemStatus? sessionInitiated, PlugInItemStatus? paymentSuccessful, PlugInItemStatus? waitingForPlugIn, PlugInItemStatus? vehicleConnected, PlugInItemStatus? chargingAutostart}) {

    return PlugInState(
      status: status ?? this.status,
      sessionInitiated: sessionInitiated ?? this.sessionInitiated,
      paymentSuccessful: paymentSuccessful ?? this.paymentSuccessful,
      waitingForPlugIn: waitingForPlugIn ?? this.waitingForPlugIn,
      vehicleConnected: vehicleConnected ?? this.vehicleConnected,
      chargingAutostart: chargingAutostart ?? this.chargingAutostart
    );

  }

}
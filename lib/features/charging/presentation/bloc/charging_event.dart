import 'package:flutter/foundation.dart';

@immutable
abstract class ChargingEvent {}

class StartCharging extends ChargingEvent {}

class TickCharging extends ChargingEvent {}

class StopCharging extends ChargingEvent {}

class ResetCharging extends ChargingEvent {}

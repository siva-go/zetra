import 'package:flutter/foundation.dart';

@immutable
abstract class PlugInEvent {}

class StartConnectionSimulation extends PlugInEvent {}

class SetVehicleConnected extends PlugInEvent {}

class SetChargingAutostart extends PlugInEvent {}

class SetPlugInCompleted extends PlugInEvent {}

class ResetPlugin extends PlugInEvent {}
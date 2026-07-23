import 'package:flutter/foundation.dart';

@immutable
abstract class ChargingHistoryEvent {

  const ChargingHistoryEvent();

}

class LoadChargingHistory extends ChargingHistoryEvent {

  const LoadChargingHistory();

}

class FilterHistory extends ChargingHistoryEvent {

  final String filter;

  const FilterHistory(this.filter);

}
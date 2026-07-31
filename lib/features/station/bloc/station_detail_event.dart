import 'package:flutter/foundation.dart';

@immutable
abstract class StationDetailEvent {}

class FetchStationDetail extends StationDetailEvent {
  final String stationId;
  final double? userLat;
  final double? userLng;

  FetchStationDetail({
    required this.stationId,
    this.userLat,
    this.userLng,
  });
}

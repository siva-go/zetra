import 'package:flutter/foundation.dart';

@immutable
abstract class SearchStationEvent {}

class FetchStations extends SearchStationEvent {}

class SearchStationQueryChanged extends SearchStationEvent {

  final String query;

  SearchStationQueryChanged(this.query);

}
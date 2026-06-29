import 'package:flutter/foundation.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialized extends HomeEvent {}

class LocationRequested extends HomeEvent {}

class NearestStationDismissed extends HomeEvent {}

class NearestStationShown extends HomeEvent {}

class StationSelected extends HomeEvent {

  final String stationId;
  final String name;
  final String type;
  final double distanceKm;
  final int availableCount;

  StationSelected({
    required this.stationId,
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.availableCount
  });

}

class SearchQueryChanged extends HomeEvent {

  final String query;
  SearchQueryChanged(this.query);

}

class NavigationTabChanged extends HomeEvent {

  final int index;
  NavigationTabChanged(this.index);

}
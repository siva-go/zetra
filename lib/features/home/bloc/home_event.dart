import 'package:flutter/foundation.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialized extends HomeEvent {}

class LocationRequested extends HomeEvent {}

class NearestStationDismissed extends HomeEvent {}

class NearestStationShown extends HomeEvent {}

class SearchQueryChanged extends HomeEvent {

  final String query;
  SearchQueryChanged(this.query);

}

class NavigationTabChanged extends HomeEvent {

  final int index;
  NavigationTabChanged(this.index);

}
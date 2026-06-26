import 'package:flutter/foundation.dart';

enum HomeStatus { initial, loading, loaded, error }

@immutable
class HomeState {

  final HomeStatus status;
  final bool showNearestStation;
  final String searchQuery;
  final NearestStationData? nearestStation;
  final int currentNavIndex;

  const HomeState({
    required this.status,
    required this.showNearestStation,
    required this.searchQuery,
    required this.currentNavIndex,
    this.nearestStation
  });

  factory HomeState.initial() {

    return const HomeState(
      status: HomeStatus.initial,
      showNearestStation: true,
      searchQuery: '',
      currentNavIndex: 0,
      nearestStation: NearestStationData(
        name: 'ZETRA GreenCharge Hub',
        type: 'DC Fast 150kW',
        distanceKm: 2.1,
        availableCount: 8
      )
    );

  }

  HomeState copyWith({HomeStatus? status, bool? showNearestStation, String? searchQuery, NearestStationData? nearestStation, int? currentNavIndex}) {

    return HomeState(
      status: status ?? this.status,
      showNearestStation: showNearestStation ?? this.showNearestStation,
      searchQuery: searchQuery ?? this.searchQuery,
      nearestStation: nearestStation ?? this.nearestStation,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex
    );

  }

}

@immutable
class NearestStationData {

  final String name;
  final String type;
  final double distanceKm;
  final int availableCount;

  const NearestStationData({
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.availableCount
  });

}
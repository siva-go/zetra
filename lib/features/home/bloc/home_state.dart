import 'package:flutter/foundation.dart';

enum HomeStatus { initial, loading, loaded, error }

@immutable
class HomeState {

  final HomeStatus status;
  final bool showNearestStation;
  final String searchQuery;
  final NearestStationData? nearestStation;
  final int currentNavIndex;
  final String? selectedStationId;

  const HomeState({required this.status, required this.showNearestStation, required this.searchQuery, required this.currentNavIndex, this.nearestStation, this.selectedStationId});

  factory HomeState.initial() {

    return const HomeState(
      status: HomeStatus.initial,
      showNearestStation: true,
      searchQuery: '',
      currentNavIndex: 0,
      selectedStationId: 'Chennai',
      nearestStation: NearestStationData(
        id: 'Chennai',
        name: 'ZETRA Marina Hub',
        type: 'DC Fast 60kW',
        distanceKm: 3.4,
        availableCount: 4
      )
    );

  }

  HomeState copyWith({HomeStatus? status, bool? showNearestStation, String? searchQuery, NearestStationData? nearestStation, int? currentNavIndex, String? selectedStationId}) {

    return HomeState(
      status: status ?? this.status,
      showNearestStation: showNearestStation ?? this.showNearestStation,
      searchQuery: searchQuery ?? this.searchQuery,
      nearestStation: nearestStation ?? this.nearestStation,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      selectedStationId: selectedStationId ?? this.selectedStationId
    );

  }

}

@immutable
class NearestStationData {

  final String id;
  final String name;
  final String type;
  final double distanceKm;
  final int availableCount;

  const NearestStationData({
    required this.id,
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.availableCount
  });

}
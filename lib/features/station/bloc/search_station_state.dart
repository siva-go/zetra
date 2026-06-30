import 'package:flutter/foundation.dart';
import 'package:zetra/features/station/models/station_info.dart';

enum SearchStationStatus { initial, loading, loaded }

@immutable
class SearchStationState {

  final SearchStationStatus status;
  final String query;
  final List<StationInfo> stations;
  final List<StationInfo> filteredStations;

  const SearchStationState({
    required this.status,
    required this.query,
    required this.stations,
    required this.filteredStations
  });

  factory SearchStationState.initial(List<StationInfo> stations) {

    return SearchStationState(
      status: SearchStationStatus.loaded,
      query: '',
      stations: stations,
      filteredStations: stations
    );

  }

  SearchStationState copyWith({SearchStationStatus? status, String? query, List<StationInfo>? stations, List<StationInfo>? filteredStations}) {

    return SearchStationState(
      status: status ?? this.status,
      query: query ?? this.query,
      stations: stations ?? this.stations,
      filteredStations: filteredStations ?? this.filteredStations
    );

  }

}
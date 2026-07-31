import 'package:flutter/foundation.dart';
import 'package:zetra/features/station/models/station_info.dart';

enum SearchStationStatus { initial, loading, loaded, error }

@immutable
class SearchStationState {

  final SearchStationStatus status;
  final String query;
  final List<StationInfo> stations;
  final List<StationInfo> filteredStations;
  final String? errorMessage;

  const SearchStationState({
    required this.status,
    required this.query,
    required this.stations,
    required this.filteredStations,
    this.errorMessage,
  });

  factory SearchStationState.initial() {
    return const SearchStationState(
      status: SearchStationStatus.initial,
      query: '',
      stations: <StationInfo>[],
      filteredStations: <StationInfo>[],
    );
  }

  SearchStationState copyWith({
    SearchStationStatus? status,
    String? query,
    List<StationInfo>? stations,
    List<StationInfo>? filteredStations,
    String? errorMessage,
  }) {
    return SearchStationState(
      status: status ?? this.status,
      query: query ?? this.query,
      stations: stations ?? this.stations,
      filteredStations: filteredStations ?? this.filteredStations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

}
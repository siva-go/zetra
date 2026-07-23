import 'package:flutter/foundation.dart';
import 'package:zetra/features/charging/models/session_entry.dart';

enum ChargingHistoryStatus { initial, loading, success, failure }

@immutable
class ChargingHistoryState {

  final ChargingHistoryStatus status;
  final String selectedFilter;
  final List<SessionGroup> historyGroups;
  final List<String> filterOptions;

  const ChargingHistoryState({
    required this.status,
    required this.selectedFilter,
    required this.historyGroups,
    required this.filterOptions
  });

  factory ChargingHistoryState.initial() {

    return const ChargingHistoryState(
      status: ChargingHistoryStatus.initial,
      selectedFilter: 'This Month',
      historyGroups: <SessionGroup>[],
      filterOptions: <String>['This Month', 'Last Month', 'Last 3 Months', 'All Time']
    );

  }

  ChargingHistoryState copyWith({ChargingHistoryStatus? status, String? selectedFilter, List<SessionGroup>? historyGroups, List<String>? filterOptions}) {

    return ChargingHistoryState(
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      historyGroups: historyGroups ?? this.historyGroups,
      filterOptions: filterOptions ?? this.filterOptions
    );

  }

}
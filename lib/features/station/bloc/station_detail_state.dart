import 'package:flutter/foundation.dart';
import 'package:zetra/features/station/models/station_detail.dart';

enum StationDetailStatus { initial, loading, loaded, error }

@immutable
class StationDetailState {
  final StationDetailStatus status;
  final StationDetail? detail;
  final String? errorMessage;

  const StationDetailState({
    required this.status,
    this.detail,
    this.errorMessage,
  });

  factory StationDetailState.initial() {
    return const StationDetailState(status: StationDetailStatus.initial);
  }

  StationDetailState copyWith({
    StationDetailStatus? status,
    StationDetail? detail,
    String? errorMessage,
  }) {
    return StationDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/charging/bloc/charging_history_event.dart';
import 'package:zetra/features/charging/bloc/charging_history_state.dart';
import 'package:zetra/features/charging/models/charging_session_model.dart';
import 'package:zetra/features/charging/models/session_entry.dart';
import 'package:zetra/features/charging/repository/charging_repository.dart';

class ChargingHistoryBloc extends Bloc<ChargingHistoryEvent, ChargingHistoryState> {

  final ChargingRepository _repository;
  List<ChargingSessionModel> _allSessions = <ChargingSessionModel>[];

  ChargingHistoryBloc(this._repository) : super(ChargingHistoryState.initial()) {
    on<LoadChargingHistory>(_onLoadChargingHistory);
    on<FilterHistory>(_onFilterHistory);
  }

  Future<void> _onLoadChargingHistory(LoadChargingHistory event, Emitter<ChargingHistoryState> emit) async {

    emit(state.copyWith(
        status: ChargingHistoryStatus.loading
    ));

    final Result<ChargingSessionsPage> result = await _repository.fetchChargingSessions();

    if (result.isSuccess) {

      _allSessions = result.dataOrNull?.data ?? <ChargingSessionModel>[];
      final List<SessionGroup> groups = _groupSessions(_filterSessions(_allSessions, state.selectedFilter));

      emit(state.copyWith(
        status: ChargingHistoryStatus.success,
        historyGroups: groups
      ));

    } else {

      emit(state.copyWith(
        status: ChargingHistoryStatus.failure,
        historyGroups: <SessionGroup>[]
      ));

    }

  }

  void _onFilterHistory(FilterHistory event, Emitter<ChargingHistoryState> emit) {

    emit(state.copyWith(
      status: ChargingHistoryStatus.loading,
      selectedFilter: event.filter
    ));

    final List<SessionGroup> groups = _groupSessions(_filterSessions(_allSessions, event.filter));

    emit(state.copyWith(
      status: ChargingHistoryStatus.success,
      historyGroups: groups
    ));

  }

  List<ChargingSessionModel> _filterSessions(List<ChargingSessionModel> sessions, String filter) {

    final DateTime now = DateTime.now();
    final DateTime startOfThisMonth = DateTime(now.year, now.month);
    final DateTime startOfNextMonth = DateTime(now.year, now.month + 1);
    final DateTime startOfLastMonth = DateTime(now.year, now.month - 1);
    final DateTime startOfLast3Months = DateTime(now.year, now.month - 2);

    switch (filter) {

      case 'This Month':
        return sessions.where((ChargingSessionModel s) => s.startTime.isAfter(startOfThisMonth.subtract(const Duration(
            seconds: 1
        ))) && s.startTime.isBefore(startOfNextMonth)).toList();
      case 'Last Month':
        return sessions.where((ChargingSessionModel s) => s.startTime.isAfter(startOfLastMonth.subtract(const Duration(
            seconds: 1
        ))) && s.startTime.isBefore(startOfThisMonth)).toList();
      case 'Last 3 Months':
        return sessions.where((ChargingSessionModel s) => s.startTime.isAfter(startOfLast3Months.subtract(const Duration(
            seconds: 1
        )))).toList();
      case 'All Time':
      default:
        return sessions;

    }

  }

  List<SessionGroup> _groupSessions(List<ChargingSessionModel> sessions) {

    final Map<String, List<SessionEntry>> groupedMap = <String, List<SessionEntry>>{};
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');

    for (final ChargingSessionModel session in sessions) {

      final String dateStr = formatter.format(session.startTime);
      groupedMap.putIfAbsent(dateStr, () => <SessionEntry>[]);
      groupedMap[dateStr]!.add(session.toSessionEntry());

    }

    return groupedMap.entries.map((MapEntry<String, List<SessionEntry>> e) => SessionGroup(
        date: e.key,
        sessions: e.value
    )).toList();

  }

}
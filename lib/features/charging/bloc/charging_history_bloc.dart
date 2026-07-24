import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_history_event.dart';
import 'package:zetra/features/charging/bloc/charging_history_state.dart';
import 'package:zetra/features/charging/models/session_entry.dart';

class ChargingHistoryBloc extends Bloc<ChargingHistoryEvent, ChargingHistoryState> {

  ChargingHistoryBloc() : super(ChargingHistoryState.initial()) {
    on<LoadChargingHistory>(_onLoadChargingHistory);
    on<FilterHistory>(_onFilterHistory);
  }

  static const List<SessionGroup> _allMockHistory = <SessionGroup>[
    SessionGroup(
      date: 'May 26, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA GreenCharge Hub',
          energyKwh: '8.4 kWh',
          amountRupees: '₹ 120.00',
          duration: '00:42:15',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    ),
    SessionGroup(
      date: 'May 24, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA EcoPower Station',
          energyKwh: '10.2 kWh',
          amountRupees: '₹ 142.00',
          duration: '00:55:10',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    ),
    SessionGroup(
      date: 'May 22, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA Pulse Station – Ooty',
          energyKwh: '12.6 kWh',
          amountRupees: '₹ 168.00',
          duration: '01:02:33',
          iconColor: Color(0xFF00E5FF),
          icon: Icons.bolt_rounded
        )
      ]
    ),
    SessionGroup(
      date: 'May 18, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA GreenCharge Hub',
          energyKwh: '9.1 kWh',
          amountRupees: '₹ 128.00',
          duration: '00:47:22',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    ),
    // April 2024 (Last Month)
    SessionGroup(
      date: 'April 28, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA EcoPower Station',
          energyKwh: '11.5 kWh',
          amountRupees: '₹ 155.00',
          duration: '00:58:12',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    ),
    SessionGroup(
      date: 'April 15, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA Pulse Station – Ooty',
          energyKwh: '14.2 kWh',
          amountRupees: '₹ 190.00',
          duration: '01:10:05',
          iconColor: Color(0xFF00E5FF),
          icon: Icons.bolt_rounded
        )
      ]
    ),
    // March 2024 (Last 3 Months)
    SessionGroup(
      date: 'March 12, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA GreenCharge Hub',
          energyKwh: '7.8 kWh',
          amountRupees: '₹ 110.00',
          duration: '00:39:45',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    ),
    // Older (All Time)
    SessionGroup(
      date: 'January 05, 2024',
      sessions: <SessionEntry>[
        SessionEntry(
          stationName: 'ZETRA EcoPower Station',
          energyKwh: '9.8 kWh',
          amountRupees: '₹ 130.00',
          duration: '00:50:30',
          iconColor: Color(0xFF2EFE58),
          icon: Icons.ev_station_rounded
        )
      ]
    )
  ];

  void _onLoadChargingHistory(LoadChargingHistory event, Emitter<ChargingHistoryState> emit) {

    emit(state.copyWith(
        status: ChargingHistoryStatus.loading
    ));

    final List<SessionGroup> filtered = _getFilteredHistory(state.selectedFilter);

    emit(state.copyWith(
      status: ChargingHistoryStatus.success,
      historyGroups: filtered
    ));

  }

  void _onFilterHistory(FilterHistory event, Emitter<ChargingHistoryState> emit) {

    emit(state.copyWith(
      status: ChargingHistoryStatus.loading,
      selectedFilter: event.filter
    ));

    final List<SessionGroup> filtered = _getFilteredHistory(event.filter);

    emit(state.copyWith(
      status: ChargingHistoryStatus.success,
      historyGroups: filtered
    ));

  }

  List<SessionGroup> _getFilteredHistory(String filter) {

    switch (filter) {

      case 'This Month':
        return _allMockHistory.where((SessionGroup group) => group.date.contains('May')).toList();
      case 'Last Month':
        return _allMockHistory.where((SessionGroup group) => group.date.contains('April')).toList();
      case 'Last 3 Months':
        return _allMockHistory.where((SessionGroup group) => group.date.contains('May') || group.date.contains('April') || group.date.contains('March')).toList();
      case 'All Time':
      default:
        return _allMockHistory;

    }

  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_event.dart';
import 'package:zetra/features/station/bloc/search_station_state.dart';
import 'package:zetra/features/station/models/station_info.dart';

class SearchStationBloc extends Bloc<SearchStationEvent, SearchStationState> {

  SearchStationBloc() : super(SearchStationState.initial(_stations)) {
    on<SearchStationQueryChanged>(_onSearchStationQueryChanged);
  }

  static const List<StationInfo> _stations = <StationInfo>[
    StationInfo(
      id: 'ZGH',
      city: 'Chennai',
      name: 'GreenCharge Hub',
      type: 'DC Fast 150kW',
      distanceKm: 2.1,
      availableCount: 8,
      pricePerKwh: 18,
      connectorCount: 2,
      address: '123 Anna Salai, Chennai'
    ),
    StationInfo(
      id: 'ZES',
      city: 'Bengaluru',
      name: 'EcoPower Station',
      type: 'AC Type 2 7kW',
      distanceKm: 3.1,
      availableCount: 4,
      pricePerKwh: 12,
      connectorCount: 1,
      address: '45 MG Road, Bengaluru'
    ),
    StationInfo(
      id: 'ZPA',
      city: 'Mumbai',
      name: 'Pulse Station',
      type: 'DC Fast 150kW',
      distanceKm: 1.2,
      availableCount: 12,
      pricePerKwh: 15.5,
      connectorCount: 3,
      address: '78 Link Road, Andheri West, Mumbai'
    ),
    StationInfo(
      id: 'ZHH',
      city: 'Nagpur',
      name: 'Highway Hub',
      type: 'DC CCS2 250kW',
      distanceKm: 6.8,
      availableCount: 2,
      pricePerKwh: 20,
      connectorCount: 2,
      address: 'Sector 5, Wardha Road, Nagpur'
    )
  ];

  void _onSearchStationQueryChanged(SearchStationQueryChanged event, Emitter<SearchStationState> emit,) {

    final String query = event.query.trim().toLowerCase();

    final List<StationInfo> filtered = query.isEmpty ? _stations : _stations.where((StationInfo station) {

      return station.name.toLowerCase().contains(query) || station.city.toLowerCase().contains(query) || station.type.toLowerCase().contains(query);}).toList();

    emit(state.copyWith(
      query: event.query,
      filteredStations: filtered
    ));

  }

}
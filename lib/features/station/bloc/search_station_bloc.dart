import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/features/station/bloc/search_station_event.dart';
import 'package:zetra/features/station/bloc/search_station_state.dart';
import 'package:zetra/features/station/models/station_info.dart';

class SearchStationBloc extends Bloc<SearchStationEvent, SearchStationState> {

  final ApiClient _apiClient;

  static const List<StationInfo> _mockStations = <StationInfo>[
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

  SearchStationBloc(this._apiClient) : super(SearchStationState.initial()) {
    on<FetchStations>(_onFetchStations);
    on<SearchStationQueryChanged>(_onSearchStationQueryChanged);
  }

  Future<void> _onFetchStations(
    FetchStations event,
    Emitter<SearchStationState> emit,
  ) async {
    emit(state.copyWith(status: SearchStationStatus.loading));

    try {
      print('[ZETRA DEBUG] Fetching stations from endpoint: /stations');
      final Response<dynamic> response = await _apiClient.dio.get(
        '/stations',
        queryParameters: <String, dynamic>{
          'page': 1,
          'pageSize': 20,
        },
      );

      print('[ZETRA DEBUG] API Response Status Code: ${response.statusCode}');
      final dynamic responseData = response.data;
      print('[ZETRA DEBUG] API Raw Response Data: $responseData');
      List<dynamic> rawList = [];

      if (responseData is Map) {
        rawList = (responseData['data'] as List<dynamic>?) ??
                  (responseData['items'] as List<dynamic>?) ??
                  (responseData['stations'] as List<dynamic>?) ??
                  [];
      } else if (responseData is List) {
        rawList = responseData;
      } else if (responseData is String) {
        final decoded = jsonDecode(responseData);
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          rawList = (decoded['data'] as List<dynamic>?) ??
                    (decoded['items'] as List<dynamic>?) ??
                    (decoded['stations'] as List<dynamic>?) ??
                    [];
        }
      }

      print('[ZETRA DEBUG] Extracted raw list count: ${rawList.length}');
      final List<StationInfo> stations = rawList
          .whereType<Map<String, dynamic>>()
          .map(StationInfo.fromJson)
          .toList();

      print('[ZETRA DEBUG] Parsed StationInfo count: ${stations.length}');

      if (stations.isEmpty) {
        print('[ZETRA DEBUG] Parsed stations list is empty. Falling back to mock stations.');
        emit(state.copyWith(
          status: SearchStationStatus.loaded,
          stations: _mockStations,
          filteredStations: _mockStations,
        ));
      } else {
        print('[ZETRA DEBUG] Loaded real stations from backend successfully.');
        emit(state.copyWith(
          status: SearchStationStatus.loaded,
          stations: stations,
          filteredStations: stations,
        ));
      }
    } on DioException catch (e) {
      print('[ZETRA DEBUG] DioException caught: ${e.message}');
      print('[ZETRA DEBUG] DioException response code: ${e.response?.statusCode}');
      print('[ZETRA DEBUG] DioException response data: ${e.response?.data}');
      // Check if it is a tenant context or forbidden error (common for demo accounts)
      final dynamic data = e.response?.data;
      Map<String, dynamic>? dataMap;
      try {
        if (data is Map<String, dynamic>) {
          dataMap = data;
        } else if (data is String && data.isNotEmpty) {
          final decoded = jsonDecode(data);
          if (decoded is Map<String, dynamic>) dataMap = decoded;
        }
      } catch (_) {}

      final bool isForbiddenOrTenantError = e.response?.statusCode == 403 ||
          (dataMap?['code']?.toString() == 'auth.no_tenant_context') ||
          (dataMap?['message']?.toString().toLowerCase().contains('membership') ?? false);

      if (isForbiddenOrTenantError) {
        print('[ZETRA DEBUG] Forbidden/Tenant membership issue detected. Falling back to mock stations.');
        // Fallback to mock stations for demo users/unassigned organizations
        emit(state.copyWith(
          status: SearchStationStatus.loaded,
          stations: _mockStations,
          filteredStations: _mockStations,
        ));
      } else {
        String errMsg = 'Failed to load stations';
        if (dataMap != null) {
          errMsg = dataMap['message']?.toString() ?? errMsg;
        }
        print('[ZETRA DEBUG] Error loading stations (no fallback): $errMsg');
        emit(state.copyWith(
          status: SearchStationStatus.error,
          errorMessage: errMsg,
        ));
      }
    } catch (e) {
      print('[ZETRA DEBUG] Unexpected exception caught: $e');
      print('[ZETRA DEBUG] Falling back to mock stations.');
      // On general connection/client error, fallback to mock stations so the screen doesn't block the user
      emit(state.copyWith(
        status: SearchStationStatus.loaded,
        stations: _mockStations,
        filteredStations: _mockStations,
      ));
    }
  }

  void _onSearchStationQueryChanged(
    SearchStationQueryChanged event,
    Emitter<SearchStationState> emit,
  ) {
    final String query = event.query.trim().toLowerCase();
    final List<StationInfo> filtered = query.isEmpty
        ? state.stations
        : state.stations.where((StationInfo station) {
            return station.name.toLowerCase().contains(query) ||
                station.city.toLowerCase().contains(query) ||
                station.type.toLowerCase().contains(query) ||
                station.address.toLowerCase().contains(query);
          }).toList();

    emit(state.copyWith(
      query: event.query,
      filteredStations: filtered,
    ));
  }

}
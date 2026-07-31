import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/features/station/bloc/station_detail_event.dart';
import 'package:zetra/features/station/bloc/station_detail_state.dart';
import 'package:zetra/features/station/models/station_detail.dart';

class StationDetailBloc extends Bloc<StationDetailEvent, StationDetailState> {

  final ApiClient _apiClient;

  StationDetailBloc(this._apiClient) : super(StationDetailState.initial()) {
    on<FetchStationDetail>(_onFetchStationDetail);
  }

  Future<void> _onFetchStationDetail(
    FetchStationDetail event,
    Emitter<StationDetailState> emit,
  ) async {
    emit(state.copyWith(status: StationDetailStatus.loading));

    try {
      final Map<String, dynamic> queryParams = <String, dynamic>{};
      if (event.userLat != null && event.userLng != null) {
        queryParams['lat'] = event.userLat;
        queryParams['lng'] = event.userLng;
      }

      final String endpoint = '/discover/stations/${event.stationId}';
      print('[ZETRA DEBUG][StationDetailBloc] Fetching: $endpoint params=$queryParams');

      final Response<dynamic> response = await _apiClient.dio.get(
        endpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      print('[ZETRA DEBUG][StationDetailBloc] Status: ${response.statusCode}');
      print('[ZETRA DEBUG][StationDetailBloc] Raw data: ${response.data}');

      Map<String, dynamic>? dataMap;
      final dynamic raw = response.data;
      if (raw is Map<String, dynamic>) {
        dataMap = raw;
      } else if (raw is String && raw.isNotEmpty) {
        final dynamic decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) dataMap = decoded;
      }

      if (dataMap == null) {
        print('[ZETRA DEBUG][StationDetailBloc] Could not parse response as Map.');
        emit(state.copyWith(
          status: StationDetailStatus.error,
          errorMessage: 'Unexpected response from server.',
        ));
        return;
      }

      final StationDetail detail = StationDetail.fromJson(dataMap);
      print('[ZETRA DEBUG][StationDetailBloc] Parsed detail: id=${detail.id}, chargers=${detail.chargers.length}');

      emit(state.copyWith(
        status: StationDetailStatus.loaded,
        detail: detail,
      ));
    } on DioException catch (e) {
      print('[ZETRA DEBUG][StationDetailBloc] DioException: ${e.message}');
      print('[ZETRA DEBUG][StationDetailBloc] Response code: ${e.response?.statusCode}');
      print('[ZETRA DEBUG][StationDetailBloc] Response data: ${e.response?.data}');
      String errMsg = 'Failed to load station details';
      final dynamic data = e.response?.data;
      try {
        if (data is Map<String, dynamic>) {
          errMsg = data['message']?.toString() ?? errMsg;
        } else if (data is String) {
          final dynamic d = jsonDecode(data);
          if (d is Map<String, dynamic>) errMsg = d['message']?.toString() ?? errMsg;
        }
      } catch (_) {}
      emit(state.copyWith(
        status: StationDetailStatus.error,
        errorMessage: errMsg,
      ));
    } catch (e) {
      print('[ZETRA DEBUG][StationDetailBloc] Unexpected error: $e');
      emit(state.copyWith(
        status: StationDetailStatus.error,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }
}

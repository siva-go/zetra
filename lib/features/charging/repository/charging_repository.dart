import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/features/charging/models/charging_session_model.dart';

class ChargingRepository {

  final ApiClient _apiClient;

  ChargingRepository(this._apiClient);

  Future<Result<ChargingSessionsPage>> fetchChargingSessions({int page = 1, int pageSize = 20, String? status}) async {

    try {

      final Map<String, dynamic> queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize
      };

      if (status != null && status.isNotEmpty) {

        queryParams['status'] = status;

      }

      final Response<dynamic> response = await _apiClient.dio.get(
        '/charging-sessions',
        queryParameters: queryParams
      );

      debugPrint('DEBUG CHARGING SESSIONS RESPONSE: ${response.data}');

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic> : <String, dynamic>{'data': response.data};

      return Result<ChargingSessionsPage>.success(
        ChargingSessionsPage.fromJson(data)
      );

    } on Object catch (e) {

      debugPrint('DEBUG FETCH CHARGING SESSIONS ERROR: $e');
      return Result<ChargingSessionsPage>.failure(ErrorHandler.handle(e));

    }

  }

}
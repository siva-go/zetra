import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/core/errors/failure.dart';
import 'package:zetra/features/charging/models/charging_session_model.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';

class ChargingRepository {

  final ApiClient _apiClient;

  ChargingRepository(this._apiClient);

  Future<Result<ChargingSessionsPage>> fetchChargingSessions({int page = 1, int pageSize = 20, String? status}) async {

    try {

      final Map<String, dynamic> queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize
      };

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

  Future<Result<InvoiceDetailModel>> fetchLatestInvoice() async {

    try {

      // Fetch driver's recent charging sessions to retrieve latest invoice
      final Result<ChargingSessionsPage> sessionsRes = await fetchChargingSessions(
        pageSize: 10
      );

      if (sessionsRes.isSuccess && sessionsRes.dataOrNull != null) {

        final ChargingSessionsPage page = sessionsRes.dataOrNull!;

        if (page.data.isNotEmpty) {

          final ChargingSessionModel session = page.data.first;

          if (session.invoiceId != null && session.invoiceId!.isNotEmpty) {

            final Result<InvoiceDetailModel> invDetailRes = await fetchInvoiceDetail(session.invoiceId!);

            if (invDetailRes.isSuccess) {
              return invDetailRes;
            }

          }

          // Build invoice detail directly from session object
          return Result<InvoiceDetailModel>.success(
            InvoiceDetailModel.fromSession(session)
          );

        }

      }

      return Result<InvoiceDetailModel>.failure(
        const NotFoundFailure(message: 'No completed charging session invoice found.')
      );

    } on Object catch (e) {

      debugPrint('DEBUG FETCH LATEST INVOICE ERROR: $e');
      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

  Future<Result<InvoiceDetailModel>> fetchInvoiceDetail(String invoiceId) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/organizations/current/invoices/$invoiceId'
      );

      debugPrint('DEBUG FETCH INVOICE RESPONSE: ${response.data}');

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{'data': response.data};

      return Result<InvoiceDetailModel>.success(
        InvoiceDetailModel.fromJson(data)
      );

    } on Object catch (e) {

      debugPrint('DEBUG FETCH INVOICE ERROR: $e');
      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/core/errors/failure.dart';
import 'package:zetra/features/charging/models/charging_session_model.dart';
import 'package:zetra/features/charging/models/invoice_model.dart';

class InvoiceRepository {

  final ApiClient _apiClient;

  InvoiceRepository(this._apiClient);

  /// Fetch list of invoices from GET /organizations/current/invoices
  /// Falls back to charging sessions if the driver role is not authorized for tenant invoices.
  Future<Result<List<InvoiceListItemModel>>> fetchInvoices({
    int page = 1,
    int pageSize = 25,
    String? status,
    String? search,
  }) async {

    try {

      final Map<String, dynamic> queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final Response<dynamic> response = await _apiClient.dio.get(
        '/organizations/current/invoices',
        queryParameters: queryParams,
      );

      final List<dynamic> listData = response.data is List<dynamic>
          ? response.data as List<dynamic>
          : (response.data is Map<String, dynamic> && response.data['data'] is List<dynamic>
              ? response.data['data'] as List<dynamic>
              : <dynamic>[]);

      final List<InvoiceListItemModel> invoices = listData
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> json) => InvoiceListItemModel.fromJson(json))
          .toList();

      return Result<List<InvoiceListItemModel>>.success(invoices);

    } on DioException catch (dioEx) {

      // If driver is forbidden (403 role_required), gracefully pull settled sessions
      if (dioEx.response?.statusCode == 403) {
        debugPrint('DEBUG INVOICES: 403 role required. Falling back to charging sessions.');
        return _fetchInvoicesFromSessions(page: page, pageSize: pageSize);
      }

      return Result<List<InvoiceListItemModel>>.failure(ErrorHandler.handle(dioEx));

    } on Object catch (e) {

      debugPrint('DEBUG FETCH INVOICES ERROR: $e');
      return Result<List<InvoiceListItemModel>>.failure(ErrorHandler.handle(e));

    }

  }

  /// Get a single invoice with full GST breakdown: GET /organizations/current/invoices/{id}
  Future<Result<InvoiceDetailModel>> fetchInvoiceDetail(String invoiceId) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/organizations/current/invoices/$invoiceId',
      );

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{'data': response.data};

      return Result<InvoiceDetailModel>.success(
        InvoiceDetailModel.fromJson(data),
      );

    } on DioException catch (dioEx) {

      // If 403 or 404, check if the ID corresponds to a driver session
      if (dioEx.response?.statusCode == 403 || dioEx.response?.statusCode == 404) {
        return _fetchInvoiceDetailFromSessions(invoiceId);
      }

      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(dioEx));

    } on Object catch (e) {

      debugPrint('DEBUG FETCH INVOICE DETAIL ERROR: $e');
      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

  /// Fetch the latest invoice for the user
  Future<Result<InvoiceDetailModel>> fetchLatestInvoice() async {

    try {

      // First attempt: official invoice register
      final Result<List<InvoiceListItemModel>> listRes = await fetchInvoices(
        pageSize: 1,
      );

      if (listRes.isSuccess && listRes.dataOrNull != null && listRes.dataOrNull!.isNotEmpty) {

        final InvoiceListItemModel firstItem = listRes.dataOrNull!.first;
        final Result<InvoiceDetailModel> detailRes = await fetchInvoiceDetail(firstItem.id);

        if (detailRes.isSuccess && detailRes.dataOrNull != null) {
          return detailRes;
        }

      }

      // Second attempt: retrieve latest charging session
      final Response<dynamic> sessionResp = await _apiClient.dio.get(
        '/charging-sessions',
        queryParameters: <String, dynamic>{
          'page': 1,
          'pageSize': 1,
        },
      );

      final Map<String, dynamic> respData = sessionResp.data is Map<String, dynamic>
          ? sessionResp.data as Map<String, dynamic>
          : <String, dynamic>{};

      final List<dynamic> sessionsList = respData['data'] is List<dynamic>
          ? respData['data'] as List<dynamic>
          : <dynamic>[];

      if (sessionsList.isNotEmpty) {

        final dynamic firstSessionRaw = sessionsList.first;
        if (firstSessionRaw is Map<String, dynamic>) {

          final ChargingSessionModel session = ChargingSessionModel.fromJson(firstSessionRaw);

          if (session.invoiceId != null && session.invoiceId!.isNotEmpty) {
            final Result<InvoiceDetailModel> invRes = await fetchInvoiceDetail(session.invoiceId!);
            if (invRes.isSuccess) {
              return invRes;
            }
          }

          return Result<InvoiceDetailModel>.success(
            InvoiceDetailModel.fromSession(session),
          );

        }

      }

      return Result<InvoiceDetailModel>.failure(
        const NotFoundFailure(message: 'No completed charging session invoice found.'),
      );

    } on Object catch (e) {

      debugPrint('DEBUG FETCH LATEST INVOICE ERROR: $e');
      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

  /// Download runtime generated invoice PDF: GET /organizations/current/invoices/{id}/pdf
  Future<Result<String>> downloadInvoicePdf(String invoiceId) async {

    try {

      final Response<List<int>> response = await _apiClient.dio.get<List<int>>(
        '/organizations/current/invoices/$invoiceId/pdf',
        queryParameters: <String, dynamic>{
          'download': true,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.data == null || response.data!.isEmpty) {
        return Result<String>.failure(
          const ServerFailure(message: 'Invoice PDF could not be generated by the server.'),
        );
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/invoice_${invoiceId.substring(0, invoiceId.length > 8 ? 8 : invoiceId.length)}.pdf';
      final File file = File(filePath);
      await file.writeAsBytes(Uint8List.fromList(response.data!));

      debugPrint('DEBUG PDF SAVED: $filePath');
      return Result<String>.success(filePath);

    } on Object catch (e) {

      debugPrint('DEBUG DOWNLOAD INVOICE PDF ERROR: $e');
      return Result<String>.failure(ErrorHandler.handle(e));

    }

  }

  /// Generate an invoice from a completed session: POST /organizations/current/invoices
  Future<Result<InvoiceDetailModel>> generateInvoice(String sessionId) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.post(
        '/organizations/current/invoices',
        data: <String, dynamic>{
          'sessionId': sessionId,
        },
      );

      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{'data': response.data};

      return Result<InvoiceDetailModel>.success(
        InvoiceDetailModel.fromJson(data),
      );

    } on Object catch (e) {

      debugPrint('DEBUG GENERATE INVOICE ERROR: $e');
      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

  // --- Private Helpers ---

  Future<Result<List<InvoiceListItemModel>>> _fetchInvoicesFromSessions({
    int page = 1,
    int pageSize = 25,
  }) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/charging-sessions',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );

      final Map<String, dynamic> map = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      final List<dynamic> list = map['data'] is List<dynamic>
          ? map['data'] as List<dynamic>
          : <dynamic>[];

      final List<InvoiceListItemModel> invoices = list
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> json) => ChargingSessionModel.fromJson(json))
          .map((ChargingSessionModel session) => InvoiceListItemModel.fromSession(session))
          .toList();

      return Result<List<InvoiceListItemModel>>.success(invoices);

    } on Object catch (e) {

      return Result<List<InvoiceListItemModel>>.failure(ErrorHandler.handle(e));

    }

  }

  Future<Result<InvoiceDetailModel>> _fetchInvoiceDetailFromSessions(String id) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/charging-sessions',
        queryParameters: <String, dynamic>{
          'page': 1,
          'pageSize': 50,
        },
      );

      final Map<String, dynamic> map = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      final List<dynamic> list = map['data'] is List<dynamic>
          ? map['data'] as List<dynamic>
          : <dynamic>[];

      for (final dynamic item in list) {
        if (item is Map<String, dynamic>) {
          final ChargingSessionModel session = ChargingSessionModel.fromJson(item);
          if (session.id == id || session.invoiceId == id) {
            return Result<InvoiceDetailModel>.success(
              InvoiceDetailModel.fromSession(session),
            );
          }
        }
      }

      return Result<InvoiceDetailModel>.failure(
        const NotFoundFailure(message: 'Invoice not found.'),
      );

    } on Object catch (e) {

      return Result<InvoiceDetailModel>.failure(ErrorHandler.handle(e));

    }

  }

}

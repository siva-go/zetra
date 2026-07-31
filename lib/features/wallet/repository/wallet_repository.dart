import 'package:dio/dio.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/features/wallet/models/wallet_model.dart';

class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<Result<WalletModel>> fetchWallet() async {
    try {
      final Response<dynamic> response = await _apiClient.dio.get('/wallet/me');
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return Result<WalletModel>.success(WalletModel.fromJson(data));
    } on Object catch (e) {
      return Result<WalletModel>.failure(ErrorHandler.handle(e));
    }
  }

  Future<Result<WalletTransactionsPage>> fetchTransactions({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Response<dynamic> response = await _apiClient.dio.get(
        '/wallet/transactions',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize,
        },
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return Result<WalletTransactionsPage>.success(WalletTransactionsPage.fromJson(data));
    } on Object catch (e) {
      return Result<WalletTransactionsPage>.failure(ErrorHandler.handle(e));
    }
  }

  Future<Result<TopupResponseModel>> initiateTopup({
    required int amountPaise,
    required String idempotencyKey,
  }) async {
    try {
      final Response<dynamic> response = await _apiClient.dio.post(
        '/wallet/topup',
        data: <String, dynamic>{
          'amountPaise': amountPaise,
          'idempotencyKey': idempotencyKey,
        },
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return Result<TopupResponseModel>.success(TopupResponseModel.fromJson(data));
    } on Object catch (e) {
      return Result<TopupResponseModel>.failure(ErrorHandler.handle(e));
    }
  }

  Future<Result<WalletModel>> redeemVoucher(String code) async {
    try {
      final Response<dynamic> response = await _apiClient.dio.post(
        '/wallet/redeem',
        data: <String, dynamic>{
          'code': code,
        },
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return Result<WalletModel>.success(WalletModel.fromJson(data));
    } on Object catch (e) {
      return Result<WalletModel>.failure(ErrorHandler.handle(e));
    }
  }

  Future<Result<void>> verifyTopup(String paymentId) async {
    try {
      await _apiClient.dio.post('/payments/topups/$paymentId/verify');
      return Result<void>.success(null);
    } on Object catch (e) {
      return Result<void>.failure(ErrorHandler.handle(e));
    }
  }
}

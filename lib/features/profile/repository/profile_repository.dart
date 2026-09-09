import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/core/errors/error_handler.dart';
import 'package:zetra/features/profile/models/driver_vehicle_model.dart';
import 'package:zetra/features/profile/models/user_profile_model.dart';

class ProfileRepository {

  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<Result<UserProfileModel>> fetchUserProfile() async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get('/users/me');

      final dynamic resData = response.data;
      final Map<String, dynamic> data = resData is Map<String, dynamic> ? (resData['data'] is Map<String, dynamic>
              ? resData['data'] as Map<String, dynamic> : resData) : <String, dynamic>{};

      return Result<UserProfileModel>.success(UserProfileModel.fromJson(data));

    } on Object catch (e) {

      debugPrint('ProfileRepository.fetchUserProfile error: $e');
      return Result<UserProfileModel>.failure(ErrorHandler.handle(e));

    }

  }

  Future<Result<UserProfileModel>> updateUserProfile({String? fullName, String? email, String? phone}) async {

    try {

      final Map<String, dynamic> body = <String, dynamic>{};

      if (fullName != null && fullName.trim().isNotEmpty) {

        body['fullName'] = fullName.trim();

      }

      if (email != null && email.trim().isNotEmpty) {

        body['email'] = email.trim();

      }

      if (phone != null && phone.trim().isNotEmpty) {

        body['phone'] = phone.trim();

      }

      final Response<dynamic> response = await _apiClient.dio.patch(
        '/users/me',
        data: body
      );

      final dynamic resData = response.data;
      final Map<String, dynamic> data = resData is Map<String, dynamic> ? (resData['data'] is Map<String, dynamic>
              ? resData['data'] as Map<String, dynamic> : resData) : <String, dynamic>{};

      return Result<UserProfileModel>.success(UserProfileModel.fromJson(data));

    } on Object catch (e) {

      debugPrint('ProfileRepository.updateUserProfile error: $e');
      return Result<UserProfileModel>.failure(ErrorHandler.handle(e));

    }

  }

  Future<Result<VehiclesPage>> fetchDriverVehicles({int page = 1, int pageSize = 20}) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/users/me/vehicles',
        queryParameters: <String, dynamic>{
          'page': page,
          'pageSize': pageSize
        }
      );

      final dynamic resData = response.data;
      final Map<String, dynamic> data = resData is Map<String, dynamic> ? resData : <String, dynamic>{'data': <dynamic>[]};

      return Result<VehiclesPage>.success(VehiclesPage.fromJson(data));

    } on Object catch (e) {

      debugPrint('ProfileRepository.fetchDriverVehicles error: $e');
      return Result<VehiclesPage>.failure(ErrorHandler.handle(e));

    }

  }

  Future<Result<DriverVehicleModel>> fetchVehicleDetail(String vehicleId) async {

    try {

      final Response<dynamic> response = await _apiClient.dio.get(
        '/users/me/vehicles/$vehicleId'
      );

      final dynamic resData = response.data;
      final Map<String, dynamic> data = resData is Map<String, dynamic> ? (resData['data'] is Map<String, dynamic>
              ? resData['data'] as Map<String, dynamic> : resData) : <String, dynamic>{};

      return Result<DriverVehicleModel>.success(DriverVehicleModel.fromJson(data));

    } on Object catch (e) {

      debugPrint('ProfileRepository.fetchVehicleDetail error: $e');
      return Result<DriverVehicleModel>.failure(ErrorHandler.handle(e));

    }

  }

}
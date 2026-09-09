import 'package:flutter/foundation.dart';

@immutable
class DriverVehicleModel {

  final String id;
  final String vehicleNumber;
  final String? nickname;
  final String? brand;
  final String? vehicleModel;
  final String status;

  const DriverVehicleModel({
    required this.id,
    required this.vehicleNumber,
    this.nickname,
    this.brand,
    this.vehicleModel,
    this.status = 'ACTIVE'
  });

  String get displayTitle {

    if (nickname != null && nickname!.trim().isNotEmpty) {

      return nickname!.trim();

    }

    final StringBuffer sb = StringBuffer();

    if (brand != null && brand!.isNotEmpty) {

      sb.write(brand);

    }

    if (vehicleModel != null && vehicleModel!.isNotEmpty) {

      if (sb.isNotEmpty) {

        sb.write(' ');

      }

      sb.write(vehicleModel);

    }

    if (sb.isNotEmpty) {

      return sb.toString();

    }

    return vehicleNumber;

  }

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) {

    return DriverVehicleModel(
      id: json['id']?.toString() ?? '',
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      nickname: json['nickname']?.toString(),
      brand: json['brand']?.toString(),
      vehicleModel: json['vehicleModel']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE'
    );

  }

  Map<String, dynamic> toJson() {

    return <String, dynamic>{
      'id': id,
      'vehicleNumber': vehicleNumber,
      'nickname': nickname,
      'brand': brand,
      'vehicleModel': vehicleModel,
      'status': status
    };

  }

}

@immutable
class VehiclesPage {

  final List<DriverVehicleModel> data;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  const VehiclesPage({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages
  });

  factory VehiclesPage.fromJson(Map<String, dynamic> json) {

    final List<dynamic>? list = json['data'] as List<dynamic>?;
    final List<DriverVehicleModel> items = list != null ? list
        .whereType<Map<String, dynamic>>().map(DriverVehicleModel.fromJson).toList() : <DriverVehicleModel>[];

    final Map<String, dynamic>? meta = json['pagination'] as Map<String, dynamic>?;

    return VehiclesPage(
      data: items,
      page: (meta?['page'] as num?)?.toInt() ?? 1,
      pageSize: (meta?['pageSize'] as num?)?.toInt() ?? 20,
      total: (meta?['total'] as num?)?.toInt() ?? items.length,
      totalPages: (meta?['totalPages'] as num?)?.toInt() ?? 1
    );

  }

  const VehiclesPage.empty(): data = const <DriverVehicleModel>[], page = 1, pageSize = 20, total = 0, totalPages = 1;

}
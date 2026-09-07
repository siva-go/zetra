import 'package:flutter/material.dart';
import 'package:zetra/features/charging/models/session_entry.dart';

class ChargingSessionModel {

  final String id;
  final String? invoiceId;
  final String? userId;
  final String? stationId;
  final String? stationName;
  final String status;
  final double energyConsumedKwh;
  final int totalCostPaise;
  final double totalCost;
  final int durationSeconds;
  final DateTime startTime;
  final DateTime? endTime;

  const ChargingSessionModel({
    required this.id,
    this.invoiceId,
    this.userId,
    this.stationId,
    this.stationName,
    required this.status,
    required this.energyConsumedKwh,
    required this.totalCostPaise,
    required this.totalCost,
    required this.durationSeconds,
    required this.startTime,
    this.endTime
  });

  factory ChargingSessionModel.fromJson(Map<String, dynamic> rawJson) {

    final Map<String, dynamic> json = (rawJson.containsKey('data') && rawJson['data'] is Map<String, dynamic>)
            ? rawJson['data'] as Map<String, dynamic> : rawJson;

    double energy = 0;

    if (json['energyDeliveredWh'] is num) {

      energy = (json['energyDeliveredWh'] as num) / 1000.0;

    } else if (json['energyConsumedKwh'] is num) {

      energy = (json['energyConsumedKwh'] as num).toDouble();

    } else if (json['energyKwh'] is num) {

      energy = (json['energyKwh'] as num).toDouble();

    } else if (json['energyConsumed'] is num) {

      energy = (json['energyConsumed'] as num).toDouble();

    }

    int costPaise = 0;

    if (json['finalAmountPaise'] is num) {

      costPaise = (json['finalAmountPaise'] as num).toInt();

    } else if (json['totalCostPaise'] is num) {

      costPaise = (json['totalCostPaise'] as num).toInt();

    } else if (json['costPaise'] is num) {

      costPaise = (json['costPaise'] as num).toInt();

    } else if (json['amountPaise'] is num) {

      costPaise = (json['amountPaise'] as num).toInt();

    }

    double cost = 0;

    if (json['finalCost'] is num) {

      cost = (json['finalCost'] as num).toDouble();

    } else if (json['totalCost'] is num) {

      cost = (json['totalCost'] as num).toDouble();

    } else if (json['amount'] is num) {

      cost = (json['amount'] as num).toDouble();

    } else if (costPaise > 0) {

      cost = costPaise / 100.0;

    }

    if (costPaise == 0 && cost > 0) {

      costPaise = (cost * 100).round();

    }

    int duration = 0;

    if (json['durationSeconds'] is num) {

      duration = (json['durationSeconds'] as num).toInt();

    } else if (json['duration'] is num) {

      duration = (json['duration'] as num).toInt();

    }

    DateTime start = DateTime.now();

    if (json['startedAt'] != null) {

      start = DateTime.tryParse(json['startedAt'].toString()) ?? DateTime.now();

    } else if (json['startTime'] != null) {

      start = DateTime.tryParse(json['startTime'].toString()) ?? DateTime.now();

    } else if (json['createdAt'] != null) {

      start = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();

    }

    DateTime? end;

    if (json['stoppedAt'] != null) {

      end = DateTime.tryParse(json['stoppedAt'].toString());

    } else if (json['endTime'] != null) {

      end = DateTime.tryParse(json['endTime'].toString());

    }

    final String station = json['stationName']?.toString() ?? json['station']?['name']?.toString() ??
        json['station']?.toString() ?? 'ZETRA Charging Hub';

    final String? invId = json['invoiceId']?.toString() ?? json['invoice']?['id']?.toString();

    return ChargingSessionModel(
      id: json['id']?.toString() ?? '',
      invoiceId: invId,
      userId: json['userId']?.toString(),
      stationId: json['stationId']?.toString(),
      stationName: station,
      status: json['status']?.toString() ?? 'STOPPED',
      energyConsumedKwh: energy,
      totalCostPaise: costPaise,
      totalCost: cost,
      durationSeconds: duration,
      startTime: start,
      endTime: end
    );

  }

  String get formattedDuration {

    final int hours = durationSeconds ~/ 3600;
    final int minutes = (durationSeconds % 3600) ~/ 60;
    final int seconds = durationSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  }

  SessionEntry toSessionEntry() {

    return SessionEntry(
      id: invoiceId ?? id,
      stationName: stationName ?? 'ZETRA Charging Hub',
      energyKwh: '${energyConsumedKwh.toStringAsFixed(1)} kWh',
      amountRupees: '₹ ${totalCost.toStringAsFixed(2)}',
      duration: formattedDuration,
      iconColor: status.toUpperCase() == 'COMPLETED' ? const Color(0xFF2EFE58) : const Color(0xFF00E5FF),
      icon: Icons.ev_station_rounded
    );

  }

}

class ChargingSessionsPage {

  final List<ChargingSessionModel> data;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const ChargingSessionsPage({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore
  });

  factory ChargingSessionsPage.fromJson(Map<String, dynamic> rawJson) {

    final List<dynamic> listData = rawJson['data'] is List
        ? rawJson['data'] as List<dynamic> : (rawJson['items'] is List
            ? rawJson['items'] as List<dynamic> : (rawJson['sessions'] is List
                ? rawJson['sessions'] as List<dynamic> : <dynamic>[]));

    final List<ChargingSessionModel> sessions = listData.map((dynamic item) => ChargingSessionModel.fromJson(item as Map<String, dynamic>)).toList();

    final Map<String, dynamic>? meta = rawJson['meta'] as Map<String, dynamic>?;
    final int totalCount = meta?['total'] ?? rawJson['total'] ?? sessions.length;
    final int currentPage = meta?['page'] ?? rawJson['page'] ?? 1;
    final int size = meta?['pageSize'] ?? rawJson['pageSize'] ?? 20;

    return ChargingSessionsPage(
      data: sessions,
      total: totalCount,
      page: currentPage,
      pageSize: size,
      hasMore: (currentPage * size) < totalCount
    );

  }

}
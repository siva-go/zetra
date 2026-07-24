import 'package:flutter/foundation.dart';

@immutable
class StationInfo {

  final String id;
  final String city;
  final String name;
  final String type;
  final double distanceKm;
  final int availableCount;
  final double pricePerKwh;
  final int connectorCount;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? status;

  const StationInfo({
    required this.id,
    required this.city,
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.availableCount,
    required this.pricePerKwh,
    required this.connectorCount,
    required this.address,
    this.latitude,
    this.longitude,
    this.status
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) {

    // Parse location: may be a nested object or top-level lat/lng
    double lat = 0;
    double lng = 0;

    if (json['location'] is Map) {

      final Map<String, dynamic> loc = json['location'] as Map<String, dynamic>;
      lat = (loc['latitude'] as num?)?.toDouble() ?? 0;
      lng = (loc['longitude'] as num?)?.toDouble() ?? 0;

    } else {

      lat = (json['latitude'] as num?)?.toDouble() ?? 0;
      lng = (json['longitude'] as num?)?.toDouble() ?? 0;

    }

    // Parse connectors list for type, count, price
    String connectorType = 'AC';
    int connectorCount = 0;
    double pricePerKwh = 0;

    if (json['totalConnectors'] != null) {

      connectorCount = (json['totalConnectors'] as num).toInt();

    }
    
    if (json['pricePerKwh'] != null) {

      pricePerKwh = (json['pricePerKwh'] as num).toDouble();

    } else if (json['price_per_kwh'] != null) {

      pricePerKwh = (json['price_per_kwh'] as num).toDouble();

    }

    if (json['connectors'] is List) {

      final List<dynamic> connectors = json['connectors'] as List<dynamic>;

      if (connectorCount == 0) {

        connectorCount = connectors.length;

      }

      if (connectors.isNotEmpty) {

        final Map<String, dynamic> first = connectors.first as Map<String, dynamic>;
        connectorType = first['type']?.toString() ?? first['connectorType']?.toString() ?? 'AC';

        if (pricePerKwh == 0) {

          pricePerKwh = (first['pricePerKwh'] as num?)?.toDouble() ?? (first['price_per_kwh'] as num?)?.toDouble() ?? 0;

        }

      }

    }

    // Available connectors
    int available = 0;

    if (json['availableConnectors'] != null) {

      available = (json['availableConnectors'] as num).toInt();

    } else if (json['available'] != null) {

      available = (json['available'] as num).toInt();

    } else {

      available = connectorCount;

    }

    // Address / city
    final String address = json['address']?.toString() ?? json['street']?.toString() ?? '';
    final String city = json['city']?.toString() ?? json['location']?['city']?.toString() ?? '';

    return StationInfo(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Station',
      city: city,
      type: json['type']?.toString() ?? connectorType,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ??
                  (json['distance'] as num?)?.toDouble() ?? 0,
      availableCount: available,
      pricePerKwh: pricePerKwh,
      connectorCount: connectorCount,
      address: address,
      latitude: lat != 0 ? lat : null,
      longitude: lng != 0 ? lng : null,
      status: json['status']?.toString()
    );

  }

}
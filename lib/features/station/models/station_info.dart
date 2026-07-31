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
    this.status,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    print('[ZETRA DEBUG][StationInfo.fromJson] Raw JSON keys: ${json.keys.toList()}');
    print('[ZETRA DEBUG][StationInfo.fromJson] Full raw JSON: $json');

    // Parse location: may be a nested object or top-level lat/lng
    double lat = 0;
    double lng = 0;
    if (json['location'] is Map) {
      final Map<String, dynamic> loc = json['location'] as Map<String, dynamic>;
      lat = (loc['latitude'] as num?)?.toDouble() ?? 0;
      lng = (loc['longitude'] as num?)?.toDouble() ?? 0;
      print('[ZETRA DEBUG][StationInfo.fromJson] Location from nested object -> lat=$lat, lng=$lng');
    } else {
      lat = (json['latitude'] as num?)?.toDouble() ?? 0;
      lng = (json['longitude'] as num?)?.toDouble() ?? 0;
      print('[ZETRA DEBUG][StationInfo.fromJson] Location from top-level fields -> lat=$lat, lng=$lng');
    }

    // Parse connectors list for type, count, price
    String connectorType = 'AC';
    int connectorCount = 0;
    double pricePerKwh = 0;
    if (json['totalConnectors'] != null) {
      connectorCount = (json['totalConnectors'] as num).toInt();
      print('[ZETRA DEBUG][StationInfo.fromJson] totalConnectors from json["totalConnectors"]: $connectorCount');
    }

    if (json['pricePerKwh'] != null) {
      pricePerKwh = (json['pricePerKwh'] as num).toDouble();
      print('[ZETRA DEBUG][StationInfo.fromJson] pricePerKwh from json["pricePerKwh"]: $pricePerKwh');
    } else if (json['price_per_kwh'] != null) {
      pricePerKwh = (json['price_per_kwh'] as num).toDouble();
      print('[ZETRA DEBUG][StationInfo.fromJson] pricePerKwh from json["price_per_kwh"]: $pricePerKwh');
    }

    if (json['connectors'] is List) {
      final List<dynamic> connectors = json['connectors'] as List<dynamic>;
      print('[ZETRA DEBUG][StationInfo.fromJson] connectors list length: ${connectors.length}');
      print('[ZETRA DEBUG][StationInfo.fromJson] connectors raw: $connectors');
      if (connectorCount == 0) {
        connectorCount = connectors.length;
        print('[ZETRA DEBUG][StationInfo.fromJson] connectorCount set from connectors.length: $connectorCount');
      }
      if (connectors.isNotEmpty) {
        final Map<String, dynamic> first = connectors.first as Map<String, dynamic>;
        connectorType = first['type']?.toString() ?? first['connectorType']?.toString() ?? 'AC';
        print('[ZETRA DEBUG][StationInfo.fromJson] connectorType from first connector: $connectorType');
        if (pricePerKwh == 0) {
          pricePerKwh = (first['pricePerKwh'] as num?)?.toDouble() ??
                        (first['price_per_kwh'] as num?)?.toDouble() ?? 0;
          print('[ZETRA DEBUG][StationInfo.fromJson] pricePerKwh from first connector: $pricePerKwh');
        }
      }
    } else {
      print('[ZETRA DEBUG][StationInfo.fromJson] No "connectors" list found in JSON (key absent or not a list).');
    }

    // Available connectors
    int available = 0;
    if (json['availableConnectors'] != null) {
      available = (json['availableConnectors'] as num).toInt();
      print('[ZETRA DEBUG][StationInfo.fromJson] availableCount from json["availableConnectors"]: $available');
    } else if (json['available'] != null) {
      available = (json['available'] as num).toInt();
      print('[ZETRA DEBUG][StationInfo.fromJson] availableCount from json["available"]: $available');
    } else {
      available = connectorCount;
      print('[ZETRA DEBUG][StationInfo.fromJson] availableCount not found, defaulting to connectorCount: $available');
    }

    // Address / city
    final String address = json['address']?.toString() ??
        json['street']?.toString() ?? '';
    final String city = json['city']?.toString() ??
        json['location']?['city']?.toString() ?? '';
    print('[ZETRA DEBUG][StationInfo.fromJson] address="$address", city="$city"');

    final String parsedId = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final String parsedName = json['name']?.toString() ?? 'Station';
    final String parsedType = json['type']?.toString() ?? connectorType;
    final double parsedDistance = (json['distanceKm'] as num?)?.toDouble() ??
                                  (json['distance'] as num?)?.toDouble() ?? 0;
    final String? parsedStatus = json['status']?.toString();

    print('[ZETRA DEBUG][StationInfo.fromJson] Parsed fields summary:');
    print('  id=$parsedId, name=$parsedName, city=$city, type=$parsedType');
    print('  distanceKm=$parsedDistance, availableCount=$available, connectorCount=$connectorCount');
    print('  pricePerKwh=$pricePerKwh, address=$address');
    print('  latitude=${lat != 0 ? lat : null}, longitude=${lng != 0 ? lng : null}, status=$parsedStatus');

    return StationInfo(
      id: parsedId,
      name: parsedName,
      city: city,
      type: parsedType,
      distanceKm: parsedDistance,
      availableCount: available,
      pricePerKwh: pricePerKwh,
      connectorCount: connectorCount,
      address: address,
      latitude: lat != 0 ? lat : null,
      longitude: lng != 0 ? lng : null,
      status: parsedStatus,
    );
  }

}
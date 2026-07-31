import 'package:flutter/foundation.dart';

// ── Connector inside a charger ────────────────────────────────────────────────

@immutable
class ChargerConnector {
  final int connectorId;
  final String type;
  final double? maxPowerKw;
  final String status;
  final bool isAvailable;

  const ChargerConnector({
    required this.connectorId,
    required this.type,
    required this.maxPowerKw,
    required this.status,
    required this.isAvailable,
  });

  factory ChargerConnector.fromJson(Map<String, dynamic> json) {
    return ChargerConnector(
      connectorId: (json['connectorId'] as num?)?.toInt() ?? 0,
      type: json['type']?.toString() ?? 'UNKNOWN',
      maxPowerKw: (json['maxPowerKw'] as num?)?.toDouble(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}

// ── Charger (chargepoint) inside a station ─────────────────────────────────────

@immutable
class Charger {
  final String id;
  final String chargePointId;
  final String? name;
  final String status;
  final List<ChargerConnector> connectors;

  const Charger({
    required this.id,
    required this.chargePointId,
    this.name,
    required this.status,
    required this.connectors,
  });

  factory Charger.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawConnectors =
        json['connectors'] is List ? json['connectors'] as List<dynamic> : <dynamic>[];
    return Charger(
      id: json['id']?.toString() ?? '',
      chargePointId: json['chargePointId']?.toString() ?? '',
      name: json['name']?.toString(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      connectors: rawConnectors
          .whereType<Map<String, dynamic>>()
          .map(ChargerConnector.fromJson)
          .toList(),
    );
  }

  int get availableCount => connectors.where((c) => c.isAvailable).length;
  bool get isOnline => status.toUpperCase() == 'ONLINE';
}

// ── Full station detail response ───────────────────────────────────────────────

@immutable
class StationDetail {
  final String id;
  final String name;
  final String address;
  final String city;
  final String region;
  final String country;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int availableConnectors;
  final int totalConnectors;
  final List<String> amenities;
  final List<Charger> chargers;

  const StationDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.availableConnectors,
    required this.totalConnectors,
    required this.amenities,
    required this.chargers,
  });

  factory StationDetail.fromJson(Map<String, dynamic> json) {
    print('[ZETRA DEBUG][StationDetail.fromJson] Raw JSON keys: ${json.keys.toList()}');
    print('[ZETRA DEBUG][StationDetail.fromJson] Full raw JSON: $json');

    final List<dynamic> rawChargers =
        json['chargers'] is List ? json['chargers'] as List<dynamic> : <dynamic>[];
    final List<dynamic> rawAmenities =
        json['amenities'] is List ? json['amenities'] as List<dynamic> : <dynamic>[];

    final List<Charger> chargers = rawChargers
        .whereType<Map<String, dynamic>>()
        .map(Charger.fromJson)
        .toList();

    print('[ZETRA DEBUG][StationDetail.fromJson] Parsed ${chargers.length} charger(s)');
    for (final Charger c in chargers) {
      print('  chargePointId="${c.chargePointId}" status="${c.status}" connectors=${c.connectors.length}');
    }

    return StationDetail(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Station',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      availableConnectors: (json['availableConnectors'] as num?)?.toInt() ?? 0,
      totalConnectors: (json['totalConnectors'] as num?)?.toInt() ?? 0,
      amenities: rawAmenities.map((e) => e.toString()).toList(),
      chargers: chargers,
    );
  }
}

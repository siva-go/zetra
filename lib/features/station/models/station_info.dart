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
  });

}
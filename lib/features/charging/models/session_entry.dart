import 'package:flutter/material.dart';

/// Represents one past charging session entry in the history list.
class SessionEntry {

  final String? id;
  final String stationName;
  final String energyKwh;
  final String amountRupees;
  final String duration; // HH:MM:SS
  final Color iconColor;
  final IconData icon;

  const SessionEntry({
    this.id,
    required this.stationName,
    required this.energyKwh,
    required this.amountRupees,
    required this.duration,
    required this.iconColor,
    required this.icon
  });

}

/// A date-keyed group of session entries.
class SessionGroup {

  final String date; // e.g. "May 26, 2024"
  final List<SessionEntry> sessions;

  const SessionGroup({required this.date, required this.sessions});

}
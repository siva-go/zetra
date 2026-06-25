/// ZETRA Core — DateTime Extensions
extension ZetraDateTimeExtension on DateTime {
  /// Returns a human-readable elapsed duration string (e.g. "2h 34m").
  String toElapsedString(Duration elapsed) {
    final h = elapsed.inHours;
    final m = elapsed.inMinutes % 60;
    final s = elapsed.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  /// Returns a short date label, e.g. "25 Jun 2026".
  String toReadableDate() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Returns a time label, e.g. "14:35".
  String toReadableTime() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Full readable timestamp: "25 Jun 2026, 14:35".
  String toReadableDateTime() => '${toReadableDate()}, ${toReadableTime()}';

  /// Returns `true` if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

/// Duration extensions.
extension ZetraDurationExtension on Duration {
  /// "38m 12s" or "1h 2m 5s".
  String toReadable() {
    final h = inHours;
    final m = inMinutes % 60;
    final s = inSeconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  /// "38:12" mm:ss format.
  String toMmSs() {
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

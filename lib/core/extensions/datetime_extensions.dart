extension ZetraDateTimeExtension on DateTime {

  String toElapsedString(Duration elapsed) {

    final int h = elapsed.inHours;
    final int m = elapsed.inMinutes % 60;
    final int s = elapsed.inSeconds % 60;

    if (h > 0) {

      return '${h}h ${m}m';

    }

    if (m > 0) {

      return '${m}m ${s}s';

    }

    return '${s}s';

  }

  /// Returns a short date label, e.g. "25 Jun 2026".
  String toReadableDate() {

    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '$day ${months[month - 1]} $year';

  }

  /// Returns a time label, e.g. "14:35".
  String toReadableTime() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Full readable timestamp: "25 Jun 2026, 14:35".
  String toReadableDateTime() => '${toReadableDate()}, ${toReadableTime()}';

  /// Returns `true` if this date is today.
  bool get isToday {

    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;

  }

}

/// Duration extensions.
extension ZetraDurationExtension on Duration {

  /// "38m 12s" or "1h 2m 5s".
  String toReadable() {

    final int h = inHours;
    final int m = inMinutes % 60;
    final int s = inSeconds % 60;

    if (h > 0) {

      return '${h}h ${m}m ${s}s';

    }

    if (m > 0) {

      return '${m}m ${s}s';

    }

    return '${s}s';

  }

  /// "38:12" mm:ss format.
  String toMmSs() {

    final String m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final String s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';

  }

}
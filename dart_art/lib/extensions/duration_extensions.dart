/// Extension methods on [Duration] for human-readable formatting.
///
/// ```dart
/// print(Duration(minutes: 90).toHuman());            // "1 hour 30 minutes"
/// print(Duration(hours: 3).toHuman(short: true));    // "3h"
/// print(Duration(seconds: 45).toHuman());            // "45 seconds"
/// ```
extension DurationExtensions on Duration {
  /// Returns a human-readable representation of this [Duration].
  ///
  /// When [short] is `false` (default), outputs full unit names with proper
  /// pluralization:
  /// ```dart
  /// Duration(hours: 2, minutes: 5).toHuman();  // "2 hours 5 minutes"
  /// Duration(seconds: 45).toHuman();            // "45 seconds"
  /// ```
  ///
  /// When [short] is `true`, outputs compact abbreviations:
  /// ```dart
  /// Duration(hours: 2, minutes: 5).toHuman(short: true);  // "2h 5m"
  /// Duration(seconds: 45).toHuman(short: true);            // "45s"
  /// ```
  ///
  /// Zero-valued units are omitted. A zero duration returns "0 seconds" / "0s".
  ///
  /// The largest unit included (in descending order) is:
  /// days → hours → minutes → seconds → milliseconds.
  String toHuman({bool short = false}) {
    if (inMicroseconds == 0) return short ? '0s' : '0 seconds';

    var remaining = inMicroseconds;
    final parts = <String>[];

    void addPart(int value, String long, String longPlural, String short_) {
      if (value == 0) return;
      final label = short ? '$value$short_' : (value == 1 ? '$value $long' : '$value $longPlural');
      parts.add(label);
    }

    // Days.
    final days = remaining ~/ _microsecondsPerDay;
    remaining -= days * _microsecondsPerDay;
    addPart(days, 'day', 'days', 'd');

    // Hours.
    final hours = remaining ~/ _microsecondsPerHour;
    remaining -= hours * _microsecondsPerHour;
    addPart(hours, 'hour', 'hours', 'h');

    // Minutes.
    final minutes = remaining ~/ _microsecondsPerMinute;
    remaining -= minutes * _microsecondsPerMinute;
    addPart(minutes, 'minute', 'minutes', 'm');

    // Seconds.
    final seconds = remaining ~/ _microsecondsPerSecond;
    remaining -= seconds * _microsecondsPerSecond;
    addPart(seconds, 'second', 'seconds', 's');

    // Milliseconds.
    final ms = remaining ~/ _microsecondsPerMillisecond;
    addPart(ms, 'millisecond', 'milliseconds', 'ms');

    return parts.join(' ');
  }

  static const int _microsecondsPerMillisecond = 1000;
  static const int _microsecondsPerSecond = 1000 * _microsecondsPerMillisecond;
  static const int _microsecondsPerMinute = 60 * _microsecondsPerSecond;
  static const int _microsecondsPerHour = 60 * _microsecondsPerMinute;
  static const int _microsecondsPerDay = 24 * _microsecondsPerHour;
}

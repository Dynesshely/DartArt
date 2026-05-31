/// Utilities for safely handling timestamps beyond the 32-bit epoch range.
///
/// [Timestamp] provides conversion between [DateTime] and safe millisecond
/// representations, handling rollover for dates that would overflow a 32-bit
/// signed integer when expressed as milliseconds since the Unix epoch.
class Timestamp {
  /// Returns the safe milliseconds-since-epoch representation of [dateTime].
  ///
  /// This delegates to [TimestampExtension.safeMillisecondsSinceEpoch].
  int getSafeTimestamp(DateTime dateTime) {
    return dateTime.safeMillisecondsSinceEpoch;
  }

  /// The maximum [DateTime] that can be safely represented.
  ///
  /// Equal to `DateTime.utc(207871, 8, 1, 23, 45, 13, 265152, 0)`.
  static DateTime maxDateTime = DateTime.utc(207871, 8, 1, 23, 45, 13, 265152, 0);

  /// Converts a safe milliseconds-since-epoch value back into a [DateTime].
  ///
  /// The [milliseconds] value may exceed the 32-bit signed integer range.
  /// It is resolved relative to the appropriate time period (epoch cycle),
  /// using [current] to determine which period the timestamp belongs to.
  ///
  /// [current] defaults to `DateTime.now().toUtc()` if not provided.
  ///
  /// Throws [ArgumentError] if [milliseconds] exceeds the safe range defined
  /// by [maxDateTime].
  static DateTime fromSafeMillisecondsSinceEpoch(int milliseconds, {DateTime? current}) {
    if (milliseconds > maxDateTime.safeMillisecondsSinceEpoch) {
      throw ArgumentError("The milliseconds value $milliseconds exceeds the maximum safe timestamp.");
    }

    current ??= DateTime.now().toUtc();
    var baseEpoch = DateTime.utc(1970, 1, 1);
    var periodLeft = baseEpoch;
    var periodRight = baseEpoch.add(Duration(milliseconds: 0x7fffffff));
    while ((current > periodLeft && current <= periodRight) == false) {
      periodLeft = periodRight;
      periodRight = periodRight.add(Duration(milliseconds: 0x7fffffff));
    }
    return DateTime.fromMillisecondsSinceEpoch(milliseconds) + periodLeft.difference(baseEpoch);
  }
}

/// Extension methods on [DateTime] providing operator overloads and safe
/// timestamp conversion.
///
/// ```dart
/// final now = DateTime.now();
/// final later = now + Duration(hours: 1);
/// print(later > now); // true
///
/// final safeMs = now.safeMillisecondsSinceEpoch;
/// ```
extension TimestampExtension on DateTime {
  /// Whether this [DateTime] is strictly after [other].
  bool operator >(DateTime other) => isAfter(other);

  /// Whether this [DateTime] is strictly before [other].
  bool operator <(DateTime other) => isBefore(other);

  /// Whether this [DateTime] is at or after [other].
  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);

  /// Whether this [DateTime] is at or before [other].
  bool operator <=(DateTime other) => isBefore(other) || isAtSameMomentAs(other);

  /// Returns a new [DateTime] offset by [duration].
  DateTime operator +(Duration duration) => add(duration);

  /// Returns a new [DateTime] offset backward by [duration].
  DateTime operator -(Duration duration) => subtract(duration);

  /// Milliseconds since the Unix epoch, adjusted to avoid negative values.
  ///
  /// If [millisecondsSinceEpoch] is negative (pre-1970 dates), `0x7fffffff`
  /// is added to wrap it into a safe positive range. This allows representing
  /// dates before 1970 in systems that cannot handle negative timestamps.
  int get safeMillisecondsSinceEpoch {
    return millisecondsSinceEpoch < 0 ? millisecondsSinceEpoch + 0x7fffffff : millisecondsSinceEpoch;
  }
}

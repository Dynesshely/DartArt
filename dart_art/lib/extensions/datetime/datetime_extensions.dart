/// Extension methods on [DateTime] for common date queries and manipulations
/// that the Dart SDK leaves to third-party packages.
///
/// ```dart
/// final now = DateTime.now();
/// print(now.isToday);             // true
/// print(now.startOfDay);          // DateTime with time set to 00:00:00
/// print(now.daysUntil(other));    // int number of days
/// ```
extension DateTimeExtensions on DateTime {
  // ── Time-of-day boundaries ──────────────────────────────────────────────

  /// A new [DateTime] at the start of this day (00:00:00.000) in the same
  /// timezone.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15, 14, 30).startOfDay;
  /// // DateTime(2025, 6, 15, 0, 0, 0, 0)
  /// ```
  DateTime get startOfDay => DateTime(year, month, day);

  /// A new [DateTime] at the end of this day (23:59:59.999) in the same
  /// timezone.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15, 14, 30).endOfDay;
  /// // DateTime(2025, 6, 15, 23, 59, 59, 999)
  /// ```
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // ── Relative day checks ─────────────────────────────────────────────────

  /// Whether this [DateTime] falls on today (same year, month, and day as
  /// [DateTime.now]).
  bool get isToday => _isSameDay(DateTime.now());

  /// Whether this [DateTime] falls on the day before today.
  bool get isYesterday => _isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  /// Whether this [DateTime] falls on the day after today.
  bool get isTomorrow => _isSameDay(DateTime.now().add(const Duration(days: 1)));

  /// Whether this [DateTime] falls on a Saturday or Sunday.
  ///
  /// Uses [weekday] where `DateTime.monday` = 1 through `DateTime.sunday` = 7.
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Whether this [DateTime] falls on a weekday (Monday–Friday).
  bool get isWeekday => !isWeekend;

  // ── Day comparison ──────────────────────────────────────────────────────

  /// Whether this [DateTime] and [other] represent the same calendar day
  /// (ignoring time).
  ///
  /// ```dart
  /// final a = DateTime(2025, 6, 15, 9, 0);
  /// final b = DateTime(2025, 6, 15, 23, 0);
  /// a.isSameDay(b); // true
  /// ```
  bool isSameDay(DateTime other) => _isSameDay(other);

  // ── Day difference ──────────────────────────────────────────────────────

  /// Returns the number of calendar days between this date and [other].
  ///
  /// The result is positive when [other] is after this date, negative when
  /// before. Only the date portion is considered (time is ignored).
  ///
  /// ```dart
  /// DateTime(2025, 6, 10).daysUntil(DateTime(2025, 6, 15)); // 5
  /// DateTime(2025, 6, 15).daysUntil(DateTime(2025, 6, 10)); // -5
  /// ```
  int daysUntil(DateTime other) {
    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);
    return b.difference(a).inDays;
  }

  // ── Age ─────────────────────────────────────────────────────────────────

  /// Calculates the number of full years between this date and [now].
  ///
  /// This is the typical "age" calculation: how many birthdays have passed
  /// between this date and the reference date.
  ///
  /// [now] defaults to the current date (from [DateTime.now]).
  ///
  /// ```dart
  /// final birthDate = DateTime(2000, 1, 15);
  /// // If today is 2025-06-01: age → 25
  /// ```
  int age({DateTime? now}) {
    now ??= DateTime.now();
    final age = now.year - year;
    // Adjust if the birthday hasn't occurred yet this year.
    if (now.month < month || (now.month == month && now.day < day)) {
      return age - 1;
    }
    return age;
  }

  /// The first day of the month that contains this date.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15).startOfMonth; // DateTime(2025, 6, 1)
  /// ```
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// The last day of the month that contains this date.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15).endOfMonth; // DateTime(2025, 6, 30)
  /// ```
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// The first day of the year that contains this date.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15).startOfYear; // DateTime(2025, 1, 1)
  /// ```
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// The last day of the year that contains this date.
  ///
  /// ```dart
  /// DateTime(2025, 6, 15).endOfYear; // DateTime(2025, 12, 31)
  /// ```
  DateTime get endOfYear => DateTime(year, 13, 0);

  // ── Internal ────────────────────────────────────────────────────────────

  bool _isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

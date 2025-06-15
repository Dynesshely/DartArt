class Timestamp {
  int getSafeTimestamp(DateTime dateTime) {
    return dateTime.safeMillisecondsSinceEpoch;
  }

  static DateTime maxDateTime = DateTime.utc(207871, 8, 1, 23, 45, 13, 265152, 0);

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

extension TimestampExtension on DateTime {
  bool operator >(DateTime other) => isAfter(other);

  bool operator <(DateTime other) => isBefore(other);

  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);

  bool operator <=(DateTime other) => isBefore(other) || isAtSameMomentAs(other);

  DateTime operator +(Duration duration) => add(duration);

  DateTime operator -(Duration duration) => subtract(duration);

  int get safeMillisecondsSinceEpoch {
    return millisecondsSinceEpoch < 0 ? millisecondsSinceEpoch + 0x7fffffff : millisecondsSinceEpoch;
  }
}

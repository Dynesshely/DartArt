/// Extension methods on [num] for human-readable formatting.
///
/// ```dart
/// print(1234.toCompact());     // "1.2K"
/// print(1234567.toCompact());  // "1.2M"
/// print(3.toOrdinal());        // "3rd"
/// print(0.1234.toPercent());   // "12.34%"
/// ```
extension NumberExtensions on num {
  /// Returns a compact, human-readable representation of this number.
  ///
  /// The number is scaled by powers of 1000 and suffixed with a unit letter
  /// (K, M, B, T for thousand, million, billion, trillion).
  ///
  /// [digits] controls the number of fractional digits (default: 1).
  ///
  /// ```dart
  /// 1234.toCompact();          // "1.2K"
  /// 1234567.toCompact();       // "1.2M"
  /// 999.toCompact();           // "999"
  /// (-1500).toCompact();       // "-1.5K"
  /// 1500.toCompact(digits: 2); // "1.50K"
  /// ```
  String toCompact({int digits = 1}) {
    if (this == 0) return '0';
    final negative = this < 0;
    var value = negative ? -this : this;
    const suffixes = ['', 'K', 'M', 'B', 'T'];
    var index = 0;

    while (value >= 1000 && index < suffixes.length - 1) {
      value /= 1000;
      index++;
    }

    if (index == 0) {
      return '${negative ? '-' : ''}${value.toStringAsFixed(0)}';
    }

    return '${negative ? '-' : ''}${value.toStringAsFixed(digits)}${suffixes[index]}';
  }

  /// Returns the ordinal representation of this integer.
  ///
  /// ```dart
  /// 1.toOrdinal();   // "1st"
  /// 2.toOrdinal();   // "2nd"
  /// 3.toOrdinal();   // "3rd"
  /// 4.toOrdinal();   // "4th"
  /// 11.toOrdinal();  // "11th"
  /// 21.toOrdinal();  // "21st"
  /// 1012.toOrdinal(); // "1012th"
  /// ```
  String toOrdinal() {
    final n = truncateToDouble().toInt();
    final tens = n % 100;
    if (tens >= 11 && tens <= 13) return '${n}th';

    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// Formats this number as a percentage string.
  ///
  /// The input is interpreted as a ratio (e.g. 0.1234 → 12.34%).
  ///
  /// [digits] controls the number of fractional digits (default: 2).
  /// If [multiply] is `true` (default), the value is multiplied by 100.
  ///
  /// ```dart
  /// 0.1234.toPercent();            // "12.34%"
  /// 12.34.toPercent(multiply: false); // "12.34%"
  /// 0.5.toPercent(digits: 0);      // "50%"
  /// ```
  String toPercent({int digits = 2, bool multiply = true}) {
    final value = multiply ? this * 100 : this;
    return '${value.toStringAsFixed(digits)}%';
  }
}

// Dart imports:
import 'dart:math';

// Project imports:
import 'package:dart_art/units/standards/binary_size_convention_standard.dart';

/// Represents a data size in bytes and provides human-readable formatting.
///
/// [BinarySize] converts raw byte counts into formatted strings like "1.00 KiB"
/// and can parse such strings back into byte values.
///
/// Three byte-size standards are supported via [standard]:
/// - [BinarySizeIecStandard] (default): binary prefixes (KiB, MiB, GiB, …),
///   where 1 KiB = 1024 B.
/// - [BinarySizeJedecStandard]: binary values with SI-named units (KB, MB, GB, …),
///   where 1 KB = 1024 B.
/// - [BinarySizeSiStandard]: decimal prefixes (kB, MB, GB, …),
///   where 1 kB = 1000 B.
///
/// Arithmetic and comparison operators are overloaded on [bytesCount], using
/// [BigInt] to avoid precision loss.
///
/// ```dart
/// final size = BinarySize()..bytesCount = BigInt.from(1536);
/// print(size.displayText); // "1.50 KiB" (with default IEC standard)
///
/// // Parse a human-readable string back.
/// final parsed = BinarySize.parse('3.25 GiB');
/// print(parsed!.bytesCount); // BigInt 3489660928
/// ```
class BinarySize {
  /// The byte-size convention standard used for formatting and parsing.
  ///
  /// Defaults to [BinarySizeIecStandard].
  late BinarySizeConventionStandard standard = BinarySizeIecStandard();

  /// The raw byte count represented by this [BinarySize].
  ///
  /// Defaults to `BigInt.from(0)`.
  late BigInt bytesCount = BigInt.from(0);

  /// A human-readable representation of this byte size.
  ///
  /// The format depends on the active [standard]:
  ///
  /// | Standard | Example         |
  /// |----------|-----------------|
  /// | IEC      | 1.00 KiB        |
  /// | JEDEC    | 1.00 KB         |
  /// | SI       | 1.00 kB         |
  ///
  /// Units range from B (bytes) through ZiB / ZB (zebibytes).
  String get displayText => (() {
        var lvB = BigInt.from(1);
        var lvKB = lvB * standard.getLevelBase();
        var lvMB = lvKB * standard.getLevelBase();
        var lvGB = lvMB * standard.getLevelBase();
        var lvTB = lvGB * standard.getLevelBase();
        var lvPB = lvTB * standard.getLevelBase();
        var lvEB = lvPB * standard.getLevelBase();
        var lvZB = lvEB * standard.getLevelBase();

        var iecIdentity = standard is BinarySizeIecStandard ? 'i' : '';

        if (bytesCount < lvKB) return '$bytesCount B';

        if (bytesCount < lvMB) return '${(bytesCount / lvKB).toStringAsFixed(2)} K${iecIdentity}B';

        if (bytesCount < lvGB) return '${(bytesCount / lvMB).toStringAsFixed(2)} M${iecIdentity}B';

        if (bytesCount < lvTB) return '${(bytesCount / lvGB).toStringAsFixed(2)} G${iecIdentity}B';

        if (bytesCount < lvPB) return '${(bytesCount / lvTB).toStringAsFixed(2)} T${iecIdentity}B';

        if (bytesCount < lvEB) return '${(bytesCount / lvPB).toStringAsFixed(2)} P${iecIdentity}B';

        if (bytesCount < lvZB) return '${(bytesCount / lvEB).toStringAsFixed(2)} E${iecIdentity}B';

        return '${(bytesCount / lvZB).toStringAsFixed(2)} Z${iecIdentity}B';
      })();

  /// Parses a human-readable size string into a [BinarySize] object.
  ///
  /// The string may contain an integer part, an optional fractional part, and
  /// a unit suffix. Examples of valid inputs:
  /// - `"344 B"`
  /// - `"1.00 KiB"`
  /// - `"3.25 GiB"`
  /// - `"7.5 MB"`
  ///
  /// **Standard detection:**
  /// - If the unit contains an `i` (e.g. KiB, MiB), the IEC standard is used.
  /// - Otherwise, [fallbackStandard] is used (defaults to [BinarySizeSiStandard]).
  ///
  /// Returns `null` if the input string does not match the expected format.
  ///
  /// ```dart
  /// final size = BinarySize.parse('3.25 GiB');
  /// print(size?.bytesCount);  // BigInt 3489660928
  /// print(size?.displayText); // "3.25 GiB"
  /// ```
  static BinarySize? parse(String size, {BinarySizeConventionStandard? fallbackStandard}) {
    BinarySize? result;

    fallbackStandard ??= BinarySizeSiStandard();

    var exp = RegExp(r'(\d+).?(\d*)\s*(B|Ki?B|Mi?B|Gi?B|Ti?B|Pi?B|Ei?B)', caseSensitive: false);

    if (exp.hasMatch(size)) {
      result = BinarySize();

      var match = exp.firstMatch(size);

      if (match == null) return null;

      var integer = match.group(1) ?? '';
      var left = match.group(2) ?? '';
      var unit = match.group(3) ?? '';

      var isIec = unit.toLowerCase().contains('i');

      result.standard = isIec ? BinarySizeIecStandard() : fallbackStandard;

      var diff = result.standard.getLevelBase();

      var scale = BigInt.from(1);

      switch (unit.toUpperCase().replaceAll('IB', 'B')) {
        case 'B':
          break;
        case 'KB':
          scale = diff;
          break;
        case 'MB':
          scale = diff * diff;
          break;
        case 'GB':
          scale = diff * diff * diff;
          break;
        case 'TB':
          scale = diff * diff * diff * diff;
          break;
        case 'PB':
          scale = diff * diff * diff * diff * diff;
          break;
        case 'EB':
          scale = diff * diff * diff * diff * diff * diff;
          break;
        default:
          break;
      }

      var p = 0;

      for (var i = integer.length - 1; i >= 0; --i, ++p) {
        var addon = BigInt.from(int.parse(integer[i]) * pow(10, p)) * scale;
        result.bytesCount += addon;
      }

      p = -1;

      for (var i = 0; i < left.length; ++i, --p) {
        var addon = BigInt.from(int.parse(left[i]) * pow(10, p)) * scale;
        result.bytesCount += addon;
      }

      if (unit.contains('b')) result.bytesCount = BigInt.from(result.bytesCount / BigInt.from(8));
    }

    return result;
  }

  /// Returns a new [BinarySize] whose [bytesCount] is the sum of this and
  /// [other]'s byte counts.
  BinarySize operator +(BinarySize other) => BinarySize()..bytesCount = bytesCount + other.bytesCount;

  /// Returns a new [BinarySize] whose [bytesCount] is the difference between
  /// this and [other]'s byte counts.
  BinarySize operator -(BinarySize other) => BinarySize()..bytesCount = bytesCount - other.bytesCount;

  /// Returns a new [BinarySize] whose [bytesCount] is the product of this and
  /// [other]'s byte counts.
  BinarySize operator *(BinarySize other) => BinarySize()..bytesCount = bytesCount * other.bytesCount;

  /// Returns the ratio of this [bytesCount] to [other]'s [bytesCount] as a
  /// [double].
  double operator /(BinarySize other) => bytesCount / other.bytesCount;

  /// Whether this [bytesCount] is strictly less than [other]'s.
  bool operator <(BinarySize other) => bytesCount < other.bytesCount;

  /// Whether this [bytesCount] is less than or equal to [other]'s.
  bool operator <=(BinarySize other) => bytesCount <= other.bytesCount;

  /// Whether this [bytesCount] is strictly greater than [other]'s.
  bool operator >(BinarySize other) => bytesCount > other.bytesCount;

  /// Whether this [bytesCount] is greater than or equal to [other]'s.
  bool operator >=(BinarySize other) => bytesCount >= other.bytesCount;
}

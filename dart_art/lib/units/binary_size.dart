// Dart imports:
import 'dart:math';

// Project imports:
import 'package:dart_art/units/standards/binary_size_convention_standard.dart';

class BinarySize {
  late BinarySizeConventionStandard standard = BinarySizeIecStandard();

  late BigInt bytesCount = BigInt.from(0);

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

  /// Parse a text into a [BinarySize] object
  /// When unit contains 'i', it will be considered as IEC standard
  /// When unit contains no 'i', we will use [fallbackStandard] to determine the standard
  /// [fallbackStandard] in default is [BinarySizeSiStandard]
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

  BinarySize operator +(BinarySize other) => BinarySize()..bytesCount = bytesCount + other.bytesCount;

  BinarySize operator -(BinarySize other) => BinarySize()..bytesCount = bytesCount - other.bytesCount;

  BinarySize operator *(BinarySize other) => BinarySize()..bytesCount = bytesCount * other.bytesCount;

  double operator /(BinarySize other) => bytesCount / other.bytesCount;

  bool operator <(BinarySize other) => bytesCount < other.bytesCount;

  bool operator <=(BinarySize other) => bytesCount <= other.bytesCount;

  bool operator >(BinarySize other) => bytesCount > other.bytesCount;

  bool operator >=(BinarySize other) => bytesCount >= other.bytesCount;
}

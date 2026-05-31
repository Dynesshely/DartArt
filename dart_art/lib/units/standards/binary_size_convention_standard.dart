/// A data-length prefix with a [name], [symbol], and [value].
///
/// Used by [BinarySizeConventionStandard] to describe the prefixes for each
/// level of the size scale (e.g. "kibi", "Ki", 1024).
class DataLengthPrefix {
  /// Creates a [DataLengthPrefix] with the given [name], [symbol], and [value].
  const DataLengthPrefix({
    required this.name,
    required this.symbol,
    required this.value,
  });

  /// The full name of the prefix (e.g. "kibi", "mebi", "giga").
  final String name;

  /// The abbreviated symbol of the prefix (e.g. "Ki", "Mi", "G").
  final String symbol;

  /// The numeric value this prefix represents (e.g. 1024 for kibi, 1000 for kilo).
  final BigInt value;
}

/// Defines a convention standard for binary size representation.
///
/// Implementations include:
/// - [BinarySizeIecStandard]
/// - [BinarySizeJedecStandard]
/// - [BinarySizeSiStandard]
///
/// Each standard specifies:
/// - A base value returned by [getLevelBase] (1024 for binary, 1000 for decimal).
/// - An ordered list of [DataLengthPrefix] instances returned by [getPrefixes].
abstract class BinarySizeConventionStandard {
  /// Creates a [BinarySizeConventionStandard] with descriptive metadata.
  const BinarySizeConventionStandard({
    required this.name,
    required this.author,
    required this.conventionExample,
    required this.unitsExample,
  });

  /// The short name of this standard (e.g. "IEC", "JEDEC", "SI").
  final String name;

  /// The organization or system that authored this standard.
  final String author;

  /// A human-readable example of the conversion convention
  /// (e.g. "1.0 KiB = 1,024 B").
  final String conventionExample;

  /// A human-readable summary of the units used by this standard
  /// (e.g. "Binary - Kibibytes (KiB), Mebibytes (MiB), …").
  final String unitsExample;

  /// Returns the base value used to compute successive size levels.
  ///
  /// For binary-based standards this is 1024; for decimal-based it is 1000.
  BigInt getLevelBase();

  /// Returns the ordered list of prefixes from smallest to largest.
  List<DataLengthPrefix> getPrefixes();
}

/// The **IEC** (International Electrotechnical Commission) binary size standard.
///
/// Uses base **1024** with binary prefixes: KiB, MiB, GiB, TiB, PiB, EiB, ZiB, YiB.
///
/// **Example:** 1.0 KiB = 1,024 B.
///
/// This is the default standard used by [BinarySize].
class BinarySizeIecStandard extends BinarySizeConventionStandard {
  /// Creates an IEC standard instance.
  const BinarySizeIecStandard({
    super.name = 'IEC',
    super.author = 'International Electrotechnical Commission',
    super.conventionExample = '1.0 KiB = 1,024 B',
    super.unitsExample = 'Binary - Kibibytes (KiB), Mebibytes (MiB), Gibibytes(GiB)',
  });

  @override
  BigInt getLevelBase() => BigInt.from(1024);

  @override
  List<DataLengthPrefix> getPrefixes() => [
        DataLengthPrefix(name: 'kibi', symbol: 'Ki', value: BigInt.from(0x400)),
        DataLengthPrefix(name: 'mebi', symbol: 'Mi', value: BigInt.from(0x100000)),
        DataLengthPrefix(name: 'gibi', symbol: 'Gi', value: BigInt.from(0x40000000)),
        DataLengthPrefix(name: 'tebi', symbol: 'Ti', value: BigInt.from(0x10000000000)),
        DataLengthPrefix(name: 'pebi', symbol: 'Pi', value: BigInt.from(0x4000000000000)),
        DataLengthPrefix(name: 'exbi', symbol: 'Ei', value: BigInt.from(0x1000000000000000)),
        DataLengthPrefix(name: 'zebi', symbol: 'Zi', value: BigInt.parse('0x400000000000000000')),
        DataLengthPrefix(name: 'yobi', symbol: 'Yi', value: BigInt.parse('0x100000000000000000000')),
      ];
}

/// The **JEDEC** (Joint Electron Device Engineering Council) memory size standard.
///
/// Uses base **1024** but with SI-style unit names: KB, MB, GB, TB, …
/// This is the convention historically used by RAM and storage manufacturers.
///
/// **Example:** 1.0 KB = 1,024 B.
class BinarySizeJedecStandard extends BinarySizeConventionStandard {
  /// Creates a JEDEC standard instance.
  const BinarySizeJedecStandard({
    super.name = 'JEDEC',
    super.author = 'Joint Electron Device Engineering Council',
    super.conventionExample = '1.0 KB = 1,024 B',
    super.unitsExample = 'Binary - Kilobytes (KB), Megabytes (MB), Gigabytes(GB)',
  });

  @override
  BigInt getLevelBase() => BigInt.from(1024);

  @override
  List<DataLengthPrefix> getPrefixes() => [
        DataLengthPrefix(name: 'kilo', symbol: 'K', value: BigInt.from(1000)),
        DataLengthPrefix(name: 'mega', symbol: 'M', value: BigInt.from(1000000)),
        DataLengthPrefix(name: 'giga', symbol: 'G', value: BigInt.from(1000000000)),
        DataLengthPrefix(name: 'tera', symbol: 'T', value: BigInt.from(1000000000000)),
        DataLengthPrefix(name: 'peta', symbol: 'P', value: BigInt.from(1000000000000000)),
        DataLengthPrefix(name: 'exa', symbol: 'E', value: BigInt.from(1000000000000000000)),
        DataLengthPrefix(name: 'zetta', symbol: 'Z', value: BigInt.parse('1000000000000000000000')),
        DataLengthPrefix(name: 'yotta', symbol: 'Y', value: BigInt.parse('1000000000000000000000000')),
        DataLengthPrefix(name: 'ronna', symbol: 'R', value: BigInt.parse('1000000000000000000000000000')),
        DataLengthPrefix(name: 'quetta', symbol: 'Q', value: BigInt.parse('1000000000000000000000000000000')),
      ];
}

/// The **SI** (International System of Units / Metric) decimal size standard.
///
/// Uses base **1000** with decimal prefixes: kB, MB, GB, TB, …
///
/// **Example:** 1.0 kB = 1,000 B.
///
/// This is the default fallback standard used by [BinarySize.parse] when no
/// `i`-containing unit is detected.
class BinarySizeSiStandard extends BinarySizeConventionStandard {
  /// Creates an SI standard instance.
  const BinarySizeSiStandard({
    super.name = 'SI',
    super.author = 'Metric System',
    super.conventionExample = '1.0 kB = 1,000 B',
    super.unitsExample = 'Decimal - Kilobytes (kB), Megabytes (MB), Gigabytes(GB)',
  });

  @override
  BigInt getLevelBase() => BigInt.from(1000);

  @override
  List<DataLengthPrefix> getPrefixes() => [
        DataLengthPrefix(name: 'kilo', symbol: 'k', value: BigInt.from(1000)),
        DataLengthPrefix(name: 'mega', symbol: 'M', value: BigInt.from(1000000)),
        DataLengthPrefix(name: 'giga', symbol: 'G', value: BigInt.from(1000000000)),
        DataLengthPrefix(name: 'tera', symbol: 'T', value: BigInt.from(1000000000000)),
        DataLengthPrefix(name: 'peta', symbol: 'P', value: BigInt.from(1000000000000000)),
        DataLengthPrefix(name: 'exa', symbol: 'E', value: BigInt.from(1000000000000000000)),
        DataLengthPrefix(name: 'zetta', symbol: 'Z', value: BigInt.parse('1000000000000000000000')),
        DataLengthPrefix(name: 'yotta', symbol: 'Y', value: BigInt.parse('1000000000000000000000000')),
        DataLengthPrefix(name: 'ronna', symbol: 'R', value: BigInt.parse('1000000000000000000000000000')),
        DataLengthPrefix(name: 'quetta', symbol: 'Q', value: BigInt.parse('1000000000000000000000000000000')),
      ];
}

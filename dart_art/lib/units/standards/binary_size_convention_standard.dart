class DataLengthPrefix {
  const DataLengthPrefix({
    required this.name,
    required this.symbol,
    required this.value,
  });

  final String name;

  final String symbol;

  final BigInt value;
}

abstract class BinarySizeConventionStandard {
  const BinarySizeConventionStandard({
    required this.name,
    required this.author,
    required this.conventionExample,
    required this.unitsExample,
  });

  final String name;

  final String author;

  final String conventionExample;

  final String unitsExample;

  BigInt getLevelBase();

  List<DataLengthPrefix> getPrefixes();
}

class BinarySizeIecStandard extends BinarySizeConventionStandard {
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

class BinarySizeJedecStandard extends BinarySizeConventionStandard {
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

class BinarySizeSiStandard extends BinarySizeConventionStandard {
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

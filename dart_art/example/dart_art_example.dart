import 'package:dart_art/dart_art.dart';

void main() {
  // ── BinarySize ───────────────────────────────────────────────────────────
  final size = BinarySize()..bytesCount = BigInt.from(1536);
  print(size.displayText); // "1.50 KiB"

  final parsed = BinarySize.parse('3.25 GiB');
  print(parsed!.bytesCount); // 3489660928

  // ── String extensions ────────────────────────────────────────────────────
  print('  '.isBlank); // true
  print('hello world'.toCamelCase()); // helloWorld
  print('helloWorld'.toSnakeCase()); // hello_world
  print('café'.removeDiacritics()); // cafe
  print('Hello World'.truncate(8)); // Hello W…
  print('hello'.capitalize()); // Hello

  // ── Iterable extensions ──────────────────────────────────────────────────
  print([1, 2, 3, 4, 5].chunked(2)); // [[1, 2], [3, 4], [5]]
  print([1, 2, 3].intersperse(0)); // [1, 0, 2, 0, 3]
  print([1, 2, 3, 4].windowed(2)); // [[1, 2], [2, 3], [3, 4]]
  print([1, 2, 3].zip(['a', 'b'])); // [[1, 'a'], [2, 'b']]
  print([1, 2, 3].firstWhereOrNull((e) => e > 5)); // null
  final (p, f) = [1, 2, 3, 4].partition((e) => e.isOdd);
  print('$p | $f'); // [1, 3] | [2, 4]

  // ── DateTime extensions ──────────────────────────────────────────────────
  final now = DateTime.now();
  print(now.isToday); // true
  print(now.startOfDay); // today at 00:00:00
  print(now.endOfMonth); // last day of month
  print(now.isWeekend); // depends on day
  print(DateTime(2000, 1, 15).age()); // years since birth

  // ── Duration extensions ──────────────────────────────────────────────────
  print(Duration(hours: 2, minutes: 5).toHuman()); // 2 hours 5 minutes
  print(Duration(hours: 3).toHuman(short: true)); // 3h
  print(Duration(seconds: 45).toHuman()); // 45 seconds

  // ── Number extensions ────────────────────────────────────────────────────
  print(1234.toCompact()); // 1.2K
  print(3.toOrdinal()); // 3rd
  print(21.toOrdinal()); // 21st
  print(0.1234.toPercent()); // 12.34%

  // ── Map extensions ───────────────────────────────────────────────────────
  final json = {
    'user': {
      'name': 'Alice',
      'address': {'city': 'Paris', 'zip': 75001}
    }
  };
  print(json.getPath<String>('user.address.city')); // Paris
  print(json.tryString('key')); // null
  final merged = {
    'x': {'a': 1}
  }.deepMerge({
    'x': {'b': 2}
  });
  print(merged); // {x: {a: 1, b: 2}}

  // ── Result type ──────────────────────────────────────────────────────────
  final result = Result<String, String>.ok('success');
  switch (result) {
    case Ok(value: final v):
      print('Got: $v');
    case Err(error: final e):
      print('Error: $e');
  }
  print(result.unwrapOr('fallback')); // success
  print(result.map((v) => v.toUpperCase())); // Ok(SUCCESS)

  // ── Edit distance algorithms ─────────────────────────────────────────────
  final lev = Levenshtein();
  print(lev.getDistanceInfo(['kitten', 'sitting']).distance); // 3.0

  final dl = DamerauLevenshtein();
  print(dl.getDistanceInfo(['teh', 'the']).distance); // 1.0

  final jw = JaroWinkler();
  print(jw.getDistanceInfo(['Martha', 'Marhta']).distance); // ~0.039
}

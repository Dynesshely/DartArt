![banner](https://raw.githubusercontent.com/Dynesshely/DartArt/main/art/banner.png)

# Overview

`DartArt` is a collection of useful Dart utilities for all Dart developers — zero
runtime dependencies, pure Dart, works everywhere.

# Installation

With Flutter:
```shell
flutter pub add dart_art
```

With Dart:
```shell
dart pub add dart_art
```

Then import:
```dart
import 'package:dart_art/dart_art.dart';
```

# Features

## Extensions

### String

Blank checks, case conversions, truncation, and diacritic removal.

```dart
// Blank checks
'  '.isBlank;             // true
'hello'.isNotBlank;       // true
'  '.orNull();            // null

// Case conversions
'hello world'.toCamelCase();  // "helloWorld"
'hello world'.toPascalCase(); // "HelloWorld"
'helloWorld'.toSnakeCase();   // "hello_world"
'helloWorld'.toKebabCase();   // "hello-world"

// Capitalization
'hello'.capitalize();         // "Hello"
'Hello'.decapitalize();       // "hello"
'hello world'.toTitleCase();  // "Hello World"

// Truncation
'Hello World'.truncate(8);        // "Hello W…"
'Hello World'.truncate(8, '...'); // "Hello..."

// Diacritics
'café'.removeDiacritics();  // "cafe"
'naïve'.removeDiacritics(); // "naive"
```

### Iterable

Chunking, windowing, zipping, partitioning, and safe lookups.

```dart
// Chunking
[1, 2, 3, 4, 5].chunked(2);   // [[1, 2], [3, 4], [5]]

// Sliding window
[1, 2, 3, 4].windowed(3);     // [[1, 2, 3], [2, 3, 4]]

// Intersperse
[1, 2, 3].intersperse(0);     // [1, 0, 2, 0, 3]

// Distinct by key
users.distinctBy((u) => u.id);

// Zip two iterables
[1, 2, 3].zip(['a', 'b']);    // [[1, 'a'], [2, 'b']]

// Associate to map
['a', 'bb'].associate((s) => MapEntry(s, s.length)); // {'a': 1, 'bb': 2}

// Safe lookups
[1, 2, 3].firstWhereOrNull((e) => e > 5);  // null

// Partition
[1, 2, 3, 4].partition((e) => e.isOdd);    // ([1, 3], [2, 4])
```

### DateTime

Day boundaries, relative dates, age, and weekend checks.

```dart
final dt = DateTime(2025, 6, 15, 14, 30);

// Day boundaries
dt.startOfDay;          // 2025-06-15 00:00:00.000
dt.endOfDay;            // 2025-06-15 23:59:59.999
dt.startOfMonth;        // 2025-06-01
dt.endOfMonth;          // 2025-06-30
dt.startOfYear;         // 2025-01-01
dt.endOfYear;           // 2025-12-31

// Relative checks
DateTime.now().isToday;       // true
dt.isWeekend;                 // false (Sunday)
dt.isWeekday;                 // true

// Comparison
dt.isSameDay(other);          // true if same calendar day
dt.daysUntil(DateTime(2025, 6, 20)); // 5

// Age calculation
DateTime(2000, 6, 1).age();   // years since birth
```

### Duration

Human-readable formatting with proper pluralization.

```dart
// Long form
Duration(hours: 2, minutes: 5).toHuman();   // "2 hours 5 minutes"
Duration(seconds: 45).toHuman();             // "45 seconds"
Duration(minutes: 1).toHuman();              // "1 minute"
Duration().toHuman();                        // "0 seconds"

// Short form
Duration(hours: 3, minutes: 15).toHuman(short: true); // "3h 15m"
Duration(days: 2).toHuman(short: true);               // "2d"
```

### Number

Compact, ordinal, and percentage formatting.

```dart
// Compact
1234.toCompact();          // "1.2K"
1234567.toCompact();       // "1.2M"
999.toCompact();           // "999"
(-1500).toCompact();       // "-1.5K"

// Ordinal
1.toOrdinal();             // "1st"
2.toOrdinal();             // "2nd"
3.toOrdinal();             // "3rd"
11.toOrdinal();            // "11th"
21.toOrdinal();            // "21st"

// Percentage
0.1234.toPercent();        // "12.34%"
0.5.toPercent(digits: 0);  // "50%"
```

### Map

Dot-notation path access, type-safe extraction, and deep merging.

```dart
final json = {
  'user': {
    'name': 'Alice',
    'address': {'city': 'Paris', 'zip': 75001}
  }
};

// Dot-path navigation
json.getPath<String>('user.address.city');  // "Paris"
json.getPath<int>('user.address.zip');      // 75001
json.getPath('user.address.country');       // null

// Type-safe extraction
map.tryString('name');   // String?
map.tryInt('count');     // int?
map.tryBool('active');   // bool?
map.tryList<T>('items'); // List<T>?

// Deep merge
final a = {'x': 1, 'y': {'a': 1}};
final b = {'y': {'b': 2}, 'z': 3};
a.deepMerge(b); // {'x': 1, 'y': {'a': 1, 'b': 2}, 'z': 3}
```

### List (additional)

```dart
// mapWhere — filter by element, map by index
[10, 20, 30].mapWhere(
  (e) => e > 15,
  (i) => 'index $i',
); // ['index 1', 'index 2']
```

## Types

### Result\<T, E\>

Rust-style error handling with sealed class exhaustiveness (Dart 3.0+).

```dart
Result<String, Exception> fetchUser(int id) {
  try {
    final user = api.getUser(id);
    return Result.ok(user.name);
  } catch (e) {
    return Result.err(Exception('Failed: $e'));
  }
}

final result = fetchUser(42);

// Exhaustive switch
switch (result) {
  case Ok(value: final name): print('User: $name');
  case Err(error: final e):  print('Error: $e');
}

// Functional combinators
result.map((name) => name.toUpperCase());
result.unwrapOr('Unknown');
result.fold(
  (name) => 'Got $name',
  (err)  => 'Failed: $err',
);
```

## Units

### BinarySize

Human-readable byte formatting with IEC, JEDEC, and SI standards.

```dart
var size = BinarySize()..bytesCount = BigInt.from(1536);
print(size.displayText); // "1.50 KiB"

// Parse a human-readable string
final parsed = BinarySize.parse('3.25 GiB');
print(parsed!.bytesCount); // BigInt(3489660928)

// Arithmetic
final total = size + BinarySize()..bytesCount = BigInt.from(1024);

// Change standard
size.standard = BinarySizeSiStandard();
print(size.displayText); // "1.54 kB"
```

## Algorithms

### Levenshtein Distance

Minimum edit operations (insert, delete, substitute) between two strings.

```dart
final lev = Levenshtein();
final info = lev.getDistanceInfo(['kitten', 'sitting']);
print(info.distance); // 3.0
```

### Damerau-Levenshtein Distance

Adds adjacent transposition to standard Levenshtein.

```dart
final dl = DamerauLevenshtein();
final info = dl.getDistanceInfo(['teh', 'the']);
print(info.distance); // 1.0 (transposition)
```

### Jaro-Winkler Similarity

Optimized for short strings like personal names.

```dart
final jw = JaroWinkler();
final info = jw.getDistanceInfo(['Martha', 'Marhta']);
print(info.distance); // ≈ 0.039 (very similar)

final info2 = jw.getDistanceInfo(['Jones', 'Johnson']);
print(info2.distance); // ≈ 0.168
```

### LCS (Longest Common Subsequence)

```dart
final lcs = LCS();
final info = lcs.getDistanceInfo(['ABCBDAB', 'BDCABA']);
print(info.distance); // 4.0
```

# Contributors

[![Contributors](https://contrib.rocks/image?repo=Dynesshely/DartArt)](https://github.com/Dynesshely/DartArt/graphs/contributors)

# Star History

[![Star History Chart](https://starchart.cc/Dynesshely/DartArt.svg?variant=adaptive)](https://starchart.cc/Dynesshely/DartArt)

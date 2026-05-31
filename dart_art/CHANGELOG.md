## 0.2.1

- **Docs**: Updated example file with runnable samples covering all 11 modules.
- **Docs**: Removed stale `(unreleased)` marker from the 0.2.0 CHANGELOG entry.

## 0.2.0

### Extensions

- **StringExtensions**: Added `isBlank` / `isNotBlank`, `orNull`, case conversions
  (`toCamelCase`, `toPascalCase`, `toSnakeCase`, `toKebabCase`), `capitalize`,
  `decapitalize`, `toTitleCase`, `truncate`, and `removeDiacritics`.
- **IterableExtensions**: Added `chunked`, `windowed`, `intersperse`, `distinctBy`,
  `zip`, `associate`, `firstWhereOrNull`, `singleWhereOrNull`, and `partition`.
- **DateTimeExtensions**: Added `startOfDay` / `endOfDay`, `isToday` / `isYesterday` /
  `isTomorrow`, `isWeekend` / `isWeekday`, `isSameDay`, `daysUntil`, `age`,
  `startOfMonth` / `endOfMonth`, `startOfYear` / `endOfYear`.
- **NumberExtensions**: Added `toCompact` (1.2K, 3.5M, …), `toOrdinal` (1st, 2nd, 3rd, …),
  and `toPercent` (12.34%).
- **DurationExtensions**: Added `toHuman` with both long form ("2 hours 5 minutes") and
  short form ("2h 5m").
- **MapExtensions**: Added `getPath<T>` (dot-notation nested access), `tryGet` /
  `tryString` / `tryInt` / `tryDouble` / `tryBool` / `tryList` / `tryMap`
  (type-safe extraction), and `deepMerge` (recursive map merging).

### Types

- **Result<T, E>**: Rust-style sealed class for type-safe error handling with `Ok`
  and `Err` variants. Provides `unwrap`, `unwrapOr`, `unwrapOrElse`, `map`,
  `mapErr`, `fold`, `orElse`, and exhaustive `switch` support (Dart 3.0+).

### Algorithms

- **Levenshtein distance**: Edit distance with insertions, deletions, substitutions.
- **Damerau-Levenshtein distance**: Extends Levenshtein with adjacent transpositions.
- **Jaro-Winkler similarity**: Optimized for short strings (e.g. personal names).

### Internal

- **Chore**: Completed barrel export file — all public modules are now accessible
  via a single `import 'package:dart_art/dart_art.dart'`.
- **Docs**: Added comprehensive dartdoc comments to all public APIs across the
  entire package.

## 0.1.2

- **New Feature**: Added `mapWhere` extension method on `List`, which filters elements by a test function and maps the matched **indices** through a mapper.
- **Chore**: Added `import_sorter` as a dev dependency to keep imports sorted.
- **Chore**: Bumped `lints` dependency range to `>=3.0.0 <6.0.0`.

## 0.1.1

- **New Feature**: Introduced LCS (Longest Common Subsequence) algorithm for text distance computation, accessible at `package:dart_art/algorithm/text/distance/calculators/lcs.dart`.
  - Supports finding all longest common sub-sequences between two input strings.
  - Includes abstract `IDistanceCalculator` base class for future algorithm extensions.
- **Chore**: Migrated lint configuration to the latest recommended rules, adjusted line length settings.
- **Chore**: Bumped `lints` from 3.0.0 to 5.1.1.

## 0.1.0

Initial version.

- **New Feature**: `BinarySize` class for converting raw byte counts to human-readable format and vice versa.
  - Supports three byte-size standards: IEC (KiB, MiB, ...), JEDEC (KB, MB, ... but binary), and SI (kB, MB, ... decimal).
  - Overloaded arithmetic and comparison operators using `BigInt` for precision.

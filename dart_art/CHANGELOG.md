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

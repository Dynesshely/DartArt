/// Extension on [Map<int, List<String>>] that provides a human-readable
/// serialization for use in test assertions.
///
/// ```dart
/// final map = {4: ['BCBA', 'BDAB']};
/// print(map.assertable()); // "4: BCBA,BDAB;\n"
/// ```
///
/// Each entry is formatted as `key: sorted,values;` on its own line.
extension AssertableMapExtensions on Map<int, List<String>> {
  /// Returns a deterministic, human-readable string representation of this map.
  ///
  /// Values for each key are sorted alphabetically before joining, ensuring
  /// a consistent output regardless of insertion order. This makes it suitable
  /// for comparing expected vs. actual results in tests.
  String assertable() {
    return entries.map((entry) {
      var sorted = entry.value;
      sorted.sort((a, b) => a.compareTo(b));
      return '${entry.key}: ${sorted.join(',')};';
    }).join('\n');
  }
}

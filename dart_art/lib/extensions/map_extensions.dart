/// Extension methods on [Map] for safe nested value access and deep merging.
///
/// ```dart
/// final map = {'user': {'name': 'Alice', 'address': {'city': 'Paris'}}};
/// map.getPath<String>('user.address.city'); // 'Paris'
/// map.getPath('user.address.zip');          // null
/// ```
extension MapExtensions<K, V> on Map<K, V> {
  /// Navigates a dot-separated [path] into nested [Map]s and returns the
  /// value at the leaf.
  ///
  /// If any key along the path is absent or refers to a non-[Map] value,
  /// returns `null`.
  ///
  /// ```dart
  /// final json = {'a': {'b': {'c': 42}}};
  /// json.getPath<int>('a.b.c');    // 42
  /// json.getPath('a.b.x');         // null
  /// json.getPath('a.x.y');         // null
  /// ```
  T? getPath<T>(String path) {
    final keys = path.split('.');
    dynamic current = this;
    for (final key in keys) {
      if (current is! Map) return null;
      if (!current.containsKey(key)) return null;
      current = current[key];
    }
    return current is T ? current : null;
  }

  /// Type-safe typed accessor that returns the value for [key] if it is of
  /// type [T], otherwise `null`.
  T? tryGet<T>(K key) {
    final value = this[key];
    return value is T ? value : null;
  }

  /// Returns the [String] value for [key], or `null` if absent or not a
  /// [String].
  String? tryString(K key) => tryGet<String>(key);

  /// Returns the [int] value for [key], or `null` if absent or not an [int].
  int? tryInt(K key) => tryGet<int>(key);

  /// Returns the [double] value for [key], or `null` if absent or not a
  /// [double].
  double? tryDouble(K key) => tryGet<double>(key);

  /// Returns the [bool] value for [key], or `null` if absent or not a [bool].
  bool? tryBool(K key) => tryGet<bool>(key);

  /// Returns the [List<T>] value for [key], or `null` if absent or not a
  /// [List<T>].
  List<T>? tryList<T>(K key) {
    final value = this[key];
    if (value is! List) return null;
    try {
      return value.cast<T>();
    } catch (_) {
      return null;
    }
  }

  /// Returns the [Map<K2, V2>] value for [key], or `null` if absent or not a
  /// [Map<K2, V2>].
  Map<K2, V2>? tryMap<K2, V2>(K key) {
    final value = this[key];
    if (value is! Map) return null;
    try {
      return value.cast<K2, V2>();
    } catch (_) {
      return null;
    }
  }

  /// Recursively merges [other] into this map, returning a new [Map].
  ///
  /// For keys present in both maps with map values, the merge is recursive.
  /// For all other keys, [other]'s value takes precedence.
  ///
  /// ```dart
  /// final a = {'x': 1, 'y': {'a': 1}};
  /// final b = {'y': {'b': 2}, 'z': 3};
  /// a.deepMerge(b);
  /// // {'x': 1, 'y': {'a': 1, 'b': 2}, 'z': 3}
  /// ```
  Map<K, dynamic> deepMerge(Map<K, dynamic> other) {
    final result = <K, dynamic>{};
    for (final entry in entries) {
      result[entry.key] = entry.value;
    }
    for (final entry in other.entries) {
      if (result.containsKey(entry.key) && result[entry.key] is Map && entry.value is Map<dynamic, dynamic>) {
        result[entry.key] = (result[entry.key] as Map).deepMerge(entry.value as Map<dynamic, dynamic>);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

/// Extension methods on [Iterable] providing collection operations commonly
/// found in other languages but absent from the Dart SDK.
///
/// ```dart
/// final items = [1, 2, 3, 4, 5];
/// print(items.chunked(2));          // [[1, 2], [3, 4], [5]]
/// print(items.windowed(3));         // [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
/// print(items.intersperse(0));      // [1, 0, 2, 0, 3, 0, 4, 0, 5]
/// ```
extension IterableExtensions<T> on Iterable<T> {
  /// Splits this iterable into chunks of [size].
  ///
  /// The last chunk may have fewer elements than [size].
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].chunked(2);  // [[1, 2], [3, 4], [5]]
  /// ```
  Iterable<List<T>> chunked(int size) sync* {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be positive');
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final chunk = <T>[iterator.current];
      for (var i = 1; i < size && iterator.moveNext(); i++) {
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  /// Returns a sliding window view of [size] over this iterable.
  ///
  /// Each window is a list of [size] consecutive elements. Fewer windows than
  /// elements are returned (e.g. for `n` elements, `n - size + 1` windows).
  ///
  /// ```dart
  /// [1, 2, 3, 4].windowed(2);  // [[1, 2], [2, 3], [3, 4]]
  /// [1, 2, 3].windowed(4);     // [] (size exceeds length)
  /// ```
  Iterable<List<T>> windowed(int size) sync* {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be positive');
    final list = toList();
    if (list.length < size) return;
    for (var i = 0; i <= list.length - size; i++) {
      yield list.sublist(i, i + size);
    }
  }

  /// Returns an iterable with [separator] inserted between each pair of
  /// consecutive elements.
  ///
  /// ```dart
  /// [1, 2, 3].intersperse(0);  // [1, 0, 2, 0, 3]
  /// [].intersperse(0);         // []
  /// [5].intersperse(0);        // [5]
  /// ```
  Iterable<T> intersperse(T separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    yield iterator.current;
    while (iterator.moveNext()) {
      yield separator;
      yield iterator.current;
    }
  }

  /// Returns a new iterable containing only elements that are distinct by
  /// the value returned by [key].
  ///
  /// The first occurrence of each distinct key is kept; later duplicates are
  /// dropped.
  ///
  /// ```dart
  /// final users = [('Alice', 1), ('Bob', 2), ('AliceB', 1)];
  /// users.distinctBy((u) => u.$2);  // [('Alice', 1), ('Bob', 2)]
  /// ```
  Iterable<T> distinctBy<K>(K Function(T) key) sync* {
    final seen = <K>{};
    for (final element in this) {
      if (seen.add(key(element))) {
        yield element;
      }
    }
  }

  /// Zips this iterable with [other] into an iterable of [List]s of length 2.
  ///
  /// The resulting iterable has the length of the shorter input. Excess
  /// elements from the longer iterable are silently dropped.
  ///
  /// ```dart
  /// [1, 2, 3].zip(['a', 'b']);  // [[1, 'a'], [2, 'b']]
  /// ```
  Iterable<List<dynamic>> zip(Iterable<dynamic> other) sync* {
    final a = iterator;
    final b = other.iterator;
    while (a.moveNext() && b.moveNext()) {
      yield [a.current, b.current];
    }
  }

  /// Associates each element of this iterable into a [Map] by applying
  /// [transform] to produce a [MapEntry].
  ///
  /// ```dart
  /// ['alice', 'bob'].associate((s) => MapEntry(s, s.length));
  /// // {'alice': 5, 'bob': 3}
  /// ```
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T) transform) {
    final result = <K, V>{};
    for (final element in this) {
      final entry = transform(element);
      result[entry.key] = entry.value;
    }
    return result;
  }

  /// Returns the first element that satisfies [test], or `null` if none does.
  ///
  /// ```dart
  /// [1, 2, 3].firstWhereOrNull((e) => e > 5);  // null
  /// [1, 2, 3].firstWhereOrNull((e) => e > 2);  // 3
  /// ```
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the single element that satisfies [test], or `null` if none does.
  ///
  /// Throws [StateError] if more than one element satisfies [test].
  T? singleWhereOrNull(bool Function(T) test) {
    T? result;
    var found = false;
    for (final element in this) {
      if (test(element)) {
        if (found) throw StateError('More than one element matches test');
        result = element;
        found = true;
      }
    }
    return result;
  }

  /// Partitions this iterable into two lists: elements that satisfy [test]
  /// and those that do not.
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].partition((e) => e.isOdd);
  /// // ([1, 3, 5], [2, 4])
  /// ```
  (List<T>, List<T>) partition(bool Function(T) test) {
    final passed = <T>[];
    final failed = <T>[];
    for (final element in this) {
      if (test(element)) {
        passed.add(element);
      } else {
        failed.add(element);
      }
    }
    return (passed, failed);
  }
}

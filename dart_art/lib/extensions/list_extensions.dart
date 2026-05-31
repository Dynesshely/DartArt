/// Extension methods on [List] providing additional transformation utilities.
extension ListExtensions on List {
  /// Filters elements by [test], then maps the **index** of each matching
  /// element through [mapper].
  ///
  /// Unlike the built-in `where` followed by `map`, this method provides the
  /// element's **index** (not the element itself) to [mapper].
  ///
  /// ```dart
  /// final list = [10, 20, 30, 40, 50];
  /// final result = list.mapWhere(
  ///   (e) => e > 25,
  ///   (i) => 'index $i',
  /// );
  /// print(result); // ['index 2', 'index 3', 'index 4']
  /// ```
  ///
  /// [T] is the type of elements in the returned list.
  List<T> mapWhere<T>(bool Function(bool) test, T Function(int) mapper) {
    final result = <T>[];
    for (var i = 0; i < length; ++i) {
      if (test(this[i])) {
        result.add(mapper(i));
      }
    }
    return result;
  }
}

extension ListExtensions on List {
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

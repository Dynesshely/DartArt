extension AssertableMapExtensions on Map<int, List<String>> {
  String assertable() {
    return entries.map((entry) {
      var sorted = entry.value;
      sorted.sort((a, b) => a.compareTo(b));
      return '${entry.key}: ${sorted.join(',')};';
    }).join('\n');
  }
}

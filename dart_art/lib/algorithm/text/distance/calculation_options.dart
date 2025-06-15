class CalculationOptions {
  final LcsOptions? lcsOptions;

  CalculationOptions({required this.lcsOptions});

  static CalculationOptions defaultOne() {
    return CalculationOptions(lcsOptions: LcsOptions());
  }
}

class LcsOptions {
  bool containsOnlyLongestSubSequences = true;
}

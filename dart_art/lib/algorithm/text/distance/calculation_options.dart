/// Configuration options for distance calculations.
///
/// Wraps algorithm-specific options (currently only [lcsOptions] for the LCS
/// algorithm). Use [CalculationOptions.defaultOne] to obtain a sensible default
/// instance.
class CalculationOptions {
  /// Options specific to the LCS (Longest Common Subsequence) algorithm.
  ///
  /// May be `null` for distance calculators that do not use LCS.
  final LcsOptions? lcsOptions;

  /// Creates a [CalculationOptions] with the given [lcsOptions].
  CalculationOptions({required this.lcsOptions});

  /// Returns a default [CalculationOptions] with [LcsOptions] at their defaults.
  static CalculationOptions defaultOne() {
    return CalculationOptions(lcsOptions: LcsOptions());
  }
}

/// Options specific to the LCS (Longest Common Subsequence) algorithm.
class LcsOptions {
  /// When `true` (the default), only sub-sequences of the maximum found length
  /// are included in the result. When `false`, all found sub-sequences are
  /// returned regardless of length.
  bool containsOnlyLongestSubSequences = true;
}

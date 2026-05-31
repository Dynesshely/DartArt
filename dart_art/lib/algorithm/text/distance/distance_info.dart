/// Holds the result of a distance computation between input strings.
///
/// Returned by [IDistanceCalculator.getDistanceInfo].
class DistanceInfo {
  /// The original input strings that were compared.
  List<String>? originalInputs;

  /// The computed distance value. A value of `-1` indicates no computation
  /// has been performed.
  double distance = -1;

  /// Optional LCS-specific information when the distance was computed using
  /// the Longest Common Subsequence algorithm.
  LcsInfo? lcsInfo;
}

/// Holds the matched sub-sequences found by the LCS algorithm.
///
/// The [lcsMatchedSubSequences] map is keyed by sub-sequence length, with
/// values being the list of all sub-sequences of that length.
///
/// **Example:** When computing the distance between `"abbabbc"` and `"abbac"`,
/// the result will be:
/// ```text
/// 5, ['abbac']
/// 4, ['abba', 'abbc', 'bbac']
/// ...
/// ```
///
/// Only the longest sub-sequences are included when
/// [CalculationOptions.lcsOptions.containsOnlyLongestSubSequences] is `true`
/// (the default).
class LcsInfo {
  /// The matched sub-sequences from the LCS algorithm, keyed by length.
  ///
  /// Each key is the length of the sub-sequences in the corresponding value
  /// list. When [LcsOptions.containsOnlyLongestSubSequences] is `true`, only
  /// entries for the maximum length are included.
  Map<int, List<String>>? lcsMatchedSubSequences;
}

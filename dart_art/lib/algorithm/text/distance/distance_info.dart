class DistanceInfo {
  List<String>? originalInputs;

  double distance = -1;

  LcsInfo? lcsInfo;
}

class LcsInfo {
  /// The matched sub-sequences from LCS algorithm
  /// When calculate distance of `(abbabbc, abbac)`, the result will be:
  /// 5, ['abbac']
  /// 4, ['abba', 'abbc', 'bbac']
  /// ...
  ///
  /// Only longest sub-sequences will be added if you indicated
  Map<int, List<String>>? lcsMatchedSubSequences;
}

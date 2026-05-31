// Dart imports:
import 'dart:math';

// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

/// Computes the Longest Common Subsequence (LCS) distance between two strings.
///
/// The LCS algorithm finds all sub-sequences that appear in both input strings
/// in the same order (but not necessarily contiguously). The length of the
/// longest such sub-sequence is reported as the [DistanceInfo.distance].
///
/// This implementation uses a dynamic programming approach with an `O(m × n)`
/// matrix, with backtracking to enumerate all longest common sub-sequences.
///
/// ```dart
/// final lcs = LCS();
/// final info = lcs.getDistanceInfo(['ABCBDAB', 'BDCABA']);
/// print(info.distance); // 4
/// print(info.lcsInfo!.lcsMatchedSubSequences); // {4: ['BCBA', 'BDAB']}
/// ```
///
/// **Requirements:** Exactly two input strings must be provided. An
/// [ArgumentError] is thrown otherwise.
class LCS extends IDistanceCalculator {
  /// The length of the longer input string. Set during computation.
  late int width;

  /// The length of the shorter input string. Set during computation.
  late int height;

  @override
  DistanceInfo getDistanceInfo(List<String> inputs, {CalculationOptions? options}) {
    if (inputs.length != 2) {
      throw ArgumentError(
        "There should be only two inputs",
      );
    }

    options ??= CalculationOptions.defaultOne();

    var result = getLcsInfo(inputs[0], inputs[1]);

    return DistanceInfo()
      ..originalInputs = inputs
      ..distance = result.lcsMatchedSubSequences!.keys.first.toDouble()
      ..lcsInfo = result;
  }

  /// Computes the raw LCS information for the two strings [a] and [b].
  ///
  /// Returns an [LcsInfo] containing the matched sub-sequences keyed by
  /// their length. Only the longest sub-sequences are included (those whose
  /// length equals the first result found).
  LcsInfo getLcsInfo(String a, String b) {
    width = max(a.length, b.length);
    height = min(a.length, b.length);

    var sa = a.length > b.length ? b : a;
    var sb = a.length > b.length ? a : b;

    var calMatrix = List<List<int>>.generate(
      height + 1,
      (_) => List<int>.generate(width + 1, (_) => 0, growable: false),
      growable: false,
    );
    var dirMatrix = List<List<int>>.generate(
      height + 1,
      (_) => List<int>.generate(width + 1, (_) => 0, growable: false),
      growable: false,
    );

    var results = List<String>.empty(growable: true);

    void trace(int i, int m, int n) {
      if (m == 0 || n == 0) {
        return;
      }

      switch (dirMatrix[m][n]) {
        case 1:
          trace(i, m - 1, n - 1);
          results[i] += sa[m - 1];
          break;
        case 2:
          trace(i, m - 1, n);
          break;
        case 3:
          trace(i, m, n - 1);
          break;
      }
    }

    for (var i = 1; i <= height; ++i) {
      for (var j = 1; j <= width; ++j) {
        var same = sa[i - 1] == sb[j - 1];
        calMatrix[i][j] = (same ? calMatrix[i - 1][j - 1] + 1 : max(calMatrix[i][j - 1], calMatrix[i - 1][j]));
        dirMatrix[i][j] = same ? 1 : (calMatrix[i - 1][j] >= calMatrix[i][j - 1] ? 2 : 3);
      }
    }

    for (var i = 0; i < width; ++i) {
      results.add("");
    }

    for (int j = width; j >= 1; --j) {
      trace(width - j, height, width - (width - j));
    }

    var m = <String, int>{};
    for (var result in results) {
      if (result.length == results[0].length) {
        m[result] = 1;
      }
    }
    results.clear();
    for (var pair in m.entries) {
      if (pair.value == 1) {
        results.add(pair.key);
      }
    }

    return LcsInfo()
      ..lcsMatchedSubSequences = <int, List<String>>{
        results[0].length: results,
      };
  }
}

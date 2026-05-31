// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

/// Computes the **Damerau-Levenshtein edit distance** between two strings.
///
/// This extends the Levenshtein distance by allowing **adjacent character
/// transpositions** as a single operation (cost of 1) in addition to
/// insertions, deletions, and substitutions.
///
/// This is useful for human-typed text where adjacent-character swaps are a
/// common typo (e.g. "teh" ↔ "the").
///
/// ```dart
/// final dl = DamerauLevenshtein();
/// final info = dl.getDistanceInfo(['teh', 'the']);
/// print(info.distance); // 1 (adjacent transposition)
///
/// // Standard Levenshtein would give 2 (two substitutions).
/// ```
///
/// **Requirements:** Exactly two input strings. An [ArgumentError] is thrown
/// otherwise.
class DamerauLevenshtein extends IDistanceCalculator {
  @override
  DistanceInfo getDistanceInfo(List<String> inputs, {CalculationOptions? options}) {
    if (inputs.length != 2) {
      throw ArgumentError('There should be only two inputs');
    }
    final distance = _compute(inputs[0], inputs[1]);
    return DistanceInfo()
      ..originalInputs = inputs
      ..distance = distance.toDouble();
  }

  /// Computes the Damerau-Levenshtein distance between [a] and [b].
  int compute(String a, String b) => _compute(a, b);

  int _compute(String a, String b) {
    final m = a.length;
    final n = b.length;

    // Full matrix (need 3 rows back for transposition check).
    final d = List<List<int>>.generate(
      m + 1,
      (_) => List<int>.filled(n + 1, 0, growable: false),
      growable: false,
    );

    for (var i = 0; i <= m; i++) {
      d[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      d[0][j] = j;
    }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        d[i][j] = _min4(
          d[i - 1][j] + 1, // deletion
          d[i][j - 1] + 1, // insertion
          d[i - 1][j - 1] + cost, // substitution
        );

        // Check for adjacent transposition.
        if (i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]) {
          d[i][j] = d[i][j] < d[i - 2][j - 2] + cost ? d[i][j] : d[i - 2][j - 2] + cost;
        }
      }
    }

    return d[m][n];
  }

  static int _min4(int a, int b, int c) {
    if (a < b) return a < c ? a : c;
    return b < c ? b : c;
  }
}

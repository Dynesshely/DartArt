// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

/// Computes the **Levenshtein edit distance** between two strings.
///
/// The Levenshtein distance is the minimum number of single-character
/// **insertions**, **deletions**, or **substitutions** required to transform
/// one string into the other.
///
/// This implementation uses a space-optimized dynamic programming approach
/// with O(m × n) time and O(min(m, n)) space.
///
/// ```dart
/// final lev = Levenshtein();
/// final info = lev.getDistanceInfo(['kitten', 'sitting']);
/// print(info.distance); // 3
/// // kitten → sitten (substitution)
/// // sitten → sittin (substitution)
/// // sittin → sitting  (insertion)
/// ```
///
/// **Requirements:** Exactly two input strings. An [ArgumentError] is thrown
/// otherwise.
class Levenshtein extends IDistanceCalculator {
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

  /// Computes the Levenshtein distance between [a] and [b].
  int compute(String a, String b) => _compute(a, b);

  int _compute(String a, String b) {
    // Ensure b is the shorter string for space optimization.
    if (a.length < b.length) {
      final t = a;
      a = b;
      b = t;
    }
    final m = a.length;
    final n = b.length;

    var prev = List<int>.generate(n + 1, (i) => i, growable: false);
    var curr = List<int>.filled(n + 1, 0, growable: false);

    for (var i = 1; i <= m; i++) {
      curr[0] = i;
      for (var j = 1; j <= n; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        curr[j] = _min3(
          prev[j] + 1, // deletion
          curr[j - 1] + 1, // insertion
          prev[j - 1] + cost, // substitution
        );
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }

    return prev[n];
  }

  static int _min3(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);
}

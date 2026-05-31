// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

/// Computes the **Jaro-Winkler similarity** between two strings.
///
/// Jaro-Winkler is optimized for short strings such as personal names. It
/// gives higher scores to strings that share common prefixes, making it the
/// de-facto standard for record linkage (deduplication) tasks.
///
/// The result is normalized to a **distance** (dissimilarity) value, where
/// `0.0` means identical and higher values mean more dissimilar. This is
/// computed as `1.0 - similarity`.
///
/// ```dart
/// final jw = JaroWinkler();
/// final info = jw.getDistanceInfo(['Martha', 'Marhta']);
/// print(info.distance); // ≈ 0.039 (very close)
///
/// final info2 = jw.getDistanceInfo(['Jones', 'Johnson']);
/// print(info2.distance); // ≈ 0.168
/// ```
///
/// The [scalingFactor] controls how much the common prefix boosts the score
/// (default 0.1, as specified by Winkler).
///
/// **Requirements:** Exactly two input strings. An [ArgumentError] is thrown
/// otherwise.
class JaroWinkler extends IDistanceCalculator {
  /// The prefix scaling factor (default 0.1).
  ///
  /// Must be between 0 and 0.25. Higher values give more weight to common
  /// prefixes.
  final double scalingFactor;

  /// Creates a [JaroWinkler] calculator with the given [scalingFactor].
  ///
  /// [scalingFactor] defaults to 0.1 and must be in the range [0, 0.25].
  JaroWinkler({this.scalingFactor = 0.1}) {
    if (scalingFactor < 0 || scalingFactor > 0.25) {
      throw ArgumentError.value(
        scalingFactor,
        'scalingFactor',
        'must be between 0.0 and 0.25',
      );
    }
  }

  @override
  DistanceInfo getDistanceInfo(List<String> inputs, {CalculationOptions? options}) {
    if (inputs.length != 2) {
      throw ArgumentError('There should be only two inputs');
    }
    final similarity = _computeSimilarity(inputs[0], inputs[1]);
    return DistanceInfo()
      ..originalInputs = inputs
      ..distance = (1.0 - similarity).toDouble();
  }

  /// Computes the Jaro-Winkler similarity between [a] and [b].
  ///
  /// Returns a value between 0.0 (no similarity) and 1.0 (identical).
  double compute(String a, String b) => _computeSimilarity(a, b);

  double _computeSimilarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final m = _matchingCharacters(a, b);
    if (m == 0) return 0.0;

    final t = _transpositions(a, b) / 2.0;

    // Jaro similarity.
    final jaro = ((m / a.length) + (m / b.length) + ((m - t) / m)) / 3.0;

    // Common prefix length (up to 4).
    var l = 0;
    for (var i = 0; i < 4 && i < a.length && i < b.length; i++) {
      if (a[i] == b[i]) {
        l++;
      } else {
        break;
      }
    }

    // Jaro-Winkler similarity.
    return jaro + l * scalingFactor * (1.0 - jaro);
  }

  /// Counts the number of matching characters within
  /// ⌊max(|a|,|b|)/2⌋ - 1 distance.
  int _matchingCharacters(String a, String b) {
    final matchDistance = ((a.length > b.length ? a.length : b.length) ~/ 2) - 1;
    if (matchDistance < 0) return 0;

    final aMatches = List<bool>.filled(a.length, false, growable: false);
    final bMatches = List<bool>.filled(b.length, false, growable: false);

    var matches = 0;
    for (var i = 0; i < a.length; i++) {
      final start = i - matchDistance > 0 ? i - matchDistance : 0;
      final end = i + matchDistance + 1 < b.length ? i + matchDistance + 1 : b.length;

      for (var j = start; j < end; j++) {
        if (bMatches[j] || a[i] != b[j]) continue;
        aMatches[i] = true;
        bMatches[j] = true;
        matches++;
        break;
      }
    }

    return matches;
  }

  /// Counts the number of transpositions among matching characters.
  int _transpositions(String a, String b) {
    final matchDistance = ((a.length > b.length ? a.length : b.length) ~/ 2) - 1;
    if (matchDistance < 0) return 0;

    final aMatches = List<bool>.filled(a.length, false, growable: false);
    final bMatches = List<bool>.filled(b.length, false, growable: false);

    for (var i = 0; i < a.length; i++) {
      final start = i - matchDistance > 0 ? i - matchDistance : 0;
      final end = i + matchDistance + 1 < b.length ? i + matchDistance + 1 : b.length;

      for (var j = start; j < end; j++) {
        if (bMatches[j] || a[i] != b[j]) continue;
        aMatches[i] = true;
        bMatches[j] = true;
        break;
      }
    }

    var transpositions = 0;
    var k = 0;
    for (var i = 0; i < a.length; i++) {
      if (!aMatches[i]) continue;
      while (k < b.length && !bMatches[k]) {
        k++;
      }
      if (k < b.length && a[i] != b[k]) {
        transpositions++;
      }
      k++;
    }

    return transpositions;
  }
}

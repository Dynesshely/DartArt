// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

/// Abstract base class for distance calculators.
///
/// Implementations compute a distance metric between a list of input strings.
///
/// Currently known implementations:
/// - [LCS] — Longest Common Subsequence distance.
///
/// To add a new distance algorithm, extend this class and override
/// [getDistanceInfo].
class IDistanceCalculator {
  /// Computes the distance between the given [inputs].
  ///
  /// [inputs] is a list of strings to compare. The exact number of inputs
  /// required depends on the specific algorithm.
  ///
  /// [options] provides optional configuration for the computation.
  ///
  /// The base implementation returns an empty [DistanceInfo]. Subclasses must
  /// override this method to provide a meaningful result.
  DistanceInfo getDistanceInfo(List<String> inputs, {CalculationOptions? options}) {
    return DistanceInfo();
  }
}

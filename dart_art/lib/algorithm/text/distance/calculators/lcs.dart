// Dart imports:
import 'dart:math';

// Project imports:
import 'package:dart_art/algorithm/text/distance/calculation_options.dart';
import 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
import 'package:dart_art/algorithm/text/distance/distance_info.dart';

class LCS extends IDistanceCalculator {
  late int width;
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

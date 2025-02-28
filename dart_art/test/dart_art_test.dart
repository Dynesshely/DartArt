import 'package:dart_art/algorithm/text/distance/calculators/lcs.dart';
import 'package:dart_art/dart_art.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests for units', () {
    test('Text Calculation Test', () {
      var counts = [344, 1458, 16283, 242021, 3423423, 38321892, 342342342, 3423423423];

      var sizes = counts.map((e) => BinarySize()..bytesCount = BigInt.from(e)).toList();

      expect(sizes[0].displayText, '344 B');
      expect(sizes[1].displayText, '1.42 KiB');
      expect(sizes[2].displayText, '15.90 KiB');
      expect(sizes[3].displayText, '236.35 KiB');
      expect(sizes[4].displayText, '3.26 MiB');
      expect(sizes[5].displayText, '36.55 MiB');
      expect(sizes[6].displayText, '326.48 MiB');
      expect(sizes[7].displayText, '3.19 GiB');
    });

    test('Parse Test', () {
      var sizeTexts = [
        '344 B',
        '4.5 KB',
        '7.5 MB',
        '3.25 GiB',
      ];
      var answer = [
        BigInt.from(344),
        BigInt.from(4000),
        BigInt.from(7000000),
        BigInt.from(3221225472),
      ];

      var sizes = sizeTexts.map((e) => BinarySize.parse(e)).toList();

      for (var i = 0; i < sizes.length; ++i) {
        expect(sizes[i]!.bytesCount, answer[i]);
      }
    });
  });

  group('A set of tests for LCS algorithm', () {
    test('main test', () {
      var distanceInfo = LCS().getDistanceInfo(["ABCBDAB", "BDCABA"]);
      expect(4, distanceInfo.distance);
      var content = '';
      for (var pair in distanceInfo.lcsInfo!.lcsMatchedSubSequences!.entries) {
        content += ("\n+ ${pair.key}: ");
        for (var sequence in pair.value) {
          content += ("\n    - $sequence");
        }
      }
      print(content);
      var d1 = <int, List<String>>{
        4: ["BCBA", "BDAB"]
      }.assertable();
      var d2 = distanceInfo.lcsInfo!.lcsMatchedSubSequences!.assertable();
      print(d1);
      print(d2);
      assert(d1 == d2);
    });
  });
}

extension AssertableMapExtensions on Map<int, List<String>> {
  String assertable() {
    return entries.map((entry) {
      var sorted = entry.value;
      sorted.sort((a, b) => a.compareTo(b));
      return '${entry.key}: ${sorted.join(',')};';
    }).join('\n');
  }
}

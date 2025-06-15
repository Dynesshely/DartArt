import 'package:dart_art/algorithm/text/distance/calculators/lcs.dart';
import 'package:dart_art/test/assertable_map.dart';
import 'package:test/test.dart';

void main() {
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

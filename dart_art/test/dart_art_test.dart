import 'package:dart_art/dart_art.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('Text Calculation Test', () {
      var counts = [344, 1458, 16283, 242021, 3423423, 38321892, 342342342, 3423423423];

      var sizes = counts.map((e) => BinarySize()..bytesCount = e).toList();

      expect(sizes[0].displayText, '344 B');
      expect(sizes[1].displayText, '1.42 KB');
      expect(sizes[2].displayText, '15.90 KB');
      expect(sizes[3].displayText, '236.35 KB');
      expect(sizes[4].displayText, '3.26 MB');
      expect(sizes[5].displayText, '36.55 MB');
      expect(sizes[6].displayText, '326.48 MB');
      expect(sizes[7].displayText, '3.19 GB');
    });

    test('Parse Test', () {
      var sizeTexts = [
        '344 B',
        '4.5 KB',
        '7.5 MB',
        '3.25 GiB',
      ];
      var answer = [
        344,
        4608,
        7864320,
        3250000000,
      ];

      var sizes = sizeTexts.map((e) => BinarySize.parse(e)).toList();

      for (var i = 0; i < sizes.length; ++i) {
        expect(sizes[i]!.bytesCount, answer[i]);
      }
    });
  });
}

import 'package:dart_art/dart_art.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
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
}

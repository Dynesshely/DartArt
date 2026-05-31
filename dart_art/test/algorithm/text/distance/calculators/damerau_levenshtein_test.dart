import 'package:test/test.dart';

import 'package:dart_art/algorithm/text/distance/calculators/damerau_levenshtein.dart';

void main() {
  group('DamerauLevenshtein', () {
    late DamerauLevenshtein dl;

    setUp(() {
      dl = DamerauLevenshtein();
    });

    test('identical strings', () {
      final info = dl.getDistanceInfo(['hello', 'hello']);
      expect(info.distance, 0);
    });

    test('adjacent transposition', () {
      final info = dl.getDistanceInfo(['teh', 'the']);
      expect(info.distance, 1);
    });

    test('kitten → sitting (classic)', () {
      final info = dl.getDistanceInfo(['kitten', 'sitting']);
      expect(info.distance, 3);
    });

    test('empty strings', () {
      final info = dl.getDistanceInfo(['', 'abc']);
      expect(info.distance, 3);
    });

    test('both empty', () {
      final info = dl.getDistanceInfo(['', '']);
      expect(info.distance, 0);
    });

    test('compute method', () {
      expect(dl.compute('abc', 'acb'), 1);
      expect(dl.compute('abc', 'abc'), 0);
    });

    test('throws on non-two inputs', () {
      expect(() => dl.getDistanceInfo(['a']), throwsArgumentError);
    });
  });
}

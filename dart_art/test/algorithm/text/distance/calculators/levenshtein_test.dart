import 'package:test/test.dart';

import 'package:dart_art/algorithm/text/distance/calculators/levenshtein.dart';

void main() {
  group('Levenshtein', () {
    late Levenshtein lev;

    setUp(() {
      lev = Levenshtein();
    });

    test('identical strings', () {
      final info = lev.getDistanceInfo(['hello', 'hello']);
      expect(info.distance, 0);
    });

    test('kitten → sitting (classic example)', () {
      final info = lev.getDistanceInfo(['kitten', 'sitting']);
      expect(info.distance, 3);
    });

    test('empty strings', () {
      final info = lev.getDistanceInfo(['', 'abc']);
      expect(info.distance, 3);
      final info2 = lev.getDistanceInfo(['abc', '']);
      expect(info2.distance, 3);
    });

    test('both empty', () {
      final info = lev.getDistanceInfo(['', '']);
      expect(info.distance, 0);
    });

    test('substitutions', () {
      final info = lev.getDistanceInfo(['flaw', 'lawn']);
      expect(info.distance, 2);
    });

    test('compute method', () {
      expect(lev.compute('abc', 'abd'), 1);
      expect(lev.compute('abc', 'abc'), 0);
    });

    test('throws on non-two inputs', () {
      expect(() => lev.getDistanceInfo(['a']), throwsArgumentError);
      expect(() => lev.getDistanceInfo(['a', 'b', 'c']), throwsArgumentError);
    });
  });
}

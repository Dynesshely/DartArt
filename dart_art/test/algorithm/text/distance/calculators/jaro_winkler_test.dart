import 'package:test/test.dart';

import 'package:dart_art/algorithm/text/distance/calculators/jaro_winkler.dart';

void main() {
  group('JaroWinkler', () {
    late JaroWinkler jw;

    setUp(() {
      jw = JaroWinkler();
    });

    test('identical strings', () {
      final info = jw.getDistanceInfo(['hello', 'hello']);
      expect(info.distance, 0);
    });

    test('very similar (known example)', () {
      final info = jw.getDistanceInfo(['Martha', 'Marhta']);
      expect(info.distance, closeTo(0.039, 0.01));
    });

    test('moderately different', () {
      final info = jw.getDistanceInfo(['Jones', 'Johnson']);
      expect(info.distance, closeTo(0.168, 0.02));
    });

    test('completely different', () {
      final info = jw.getDistanceInfo(['abc', 'xyz']);
      expect(info.distance, 1.0);
    });

    test('empty strings', () {
      final info = jw.getDistanceInfo(['', 'abc']);
      expect(info.distance, 1.0);
    });

    test('both empty (identical)', () {
      final info = jw.getDistanceInfo(['', '']);
      // Two empty strings are identical → distance 0.
      expect(info.distance, 0.0);
    });

    test('common prefix boosts similarity', () {
      final jwHighPrefix = JaroWinkler(scalingFactor: 0.25);
      final infoLow = jw.getDistanceInfo(['abcdef', 'abcxyz']);
      final infoHigh = jwHighPrefix.getDistanceInfo(['abcdef', 'abcxyz']);
      // Higher scaling factor should make them appear more similar (lower distance).
      expect(infoHigh.distance, lessThan(infoLow.distance));
    });

    test('compute method', () {
      expect(jw.compute('Martha', 'Marhta'), closeTo(0.961, 0.01));
      expect(jw.compute('hello', 'hello'), 1.0);
    });

    test('throws on non-two inputs', () {
      expect(() => jw.getDistanceInfo(['a']), throwsArgumentError);
    });

    test('throws on invalid scalingFactor', () {
      expect(() => JaroWinkler(scalingFactor: -0.1), throwsArgumentError);
      expect(() => JaroWinkler(scalingFactor: 0.5), throwsArgumentError);
    });
  });
}

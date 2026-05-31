import 'package:test/test.dart';

import 'package:dart_art/extensions/number_extensions.dart';

void main() {
  group('NumberExtensions', () {
    group('toCompact', () {
      test('less than 1000', () {
        expect(999.toCompact(), '999');
      });

      test('thousands', () {
        expect(1234.toCompact(), '1.2K');
        expect(1500.toCompact(), '1.5K');
      });

      test('millions', () {
        expect(1234567.toCompact(), '1.2M');
      });

      test('billions', () {
        expect(1234567890.toCompact(), '1.2B');
      });

      test('zero', () {
        expect(0.toCompact(), '0');
      });

      test('negative', () {
        expect((-1500).toCompact(), '-1.5K');
      });

      test('custom digits', () {
        expect(1500.toCompact(digits: 2), '1.50K');
      });
    });

    group('toOrdinal', () {
      test('1st variations', () {
        expect(1.toOrdinal(), '1st');
        expect(21.toOrdinal(), '21st');
        expect(101.toOrdinal(), '101st');
      });

      test('2nd variations', () {
        expect(2.toOrdinal(), '2nd');
        expect(22.toOrdinal(), '22nd');
      });

      test('3rd variations', () {
        expect(3.toOrdinal(), '3rd');
        expect(23.toOrdinal(), '23rd');
      });

      test('teen exceptions', () {
        expect(11.toOrdinal(), '11th');
        expect(12.toOrdinal(), '12th');
        expect(13.toOrdinal(), '13th');
        expect(111.toOrdinal(), '111th');
        expect(1013.toOrdinal(), '1013th');
      });

      test('other', () {
        expect(4.toOrdinal(), '4th');
        expect(9.toOrdinal(), '9th');
        expect(10.toOrdinal(), '10th');
        expect(20.toOrdinal(), '20th');
      });
    });

    group('toPercent', () {
      test('ratio to percent', () {
        expect(0.1234.toPercent(), '12.34%');
        expect(0.5.toPercent(), '50.00%');
      });

      test('without multiply', () {
        expect(12.34.toPercent(multiply: false), '12.34%');
      });

      test('custom digits', () {
        expect(0.5.toPercent(digits: 0), '50%');
        expect(0.1234.toPercent(digits: 1), '12.3%');
      });
    });
  });
}

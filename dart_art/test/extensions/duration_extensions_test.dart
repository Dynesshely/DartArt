import 'package:test/test.dart';

import 'package:dart_art/extensions/duration_extensions.dart';

void main() {
  group('DurationExtensions', () {
    group('toHuman long form', () {
      test('zero', () {
        expect(Duration().toHuman(), '0 seconds');
      });

      test('seconds only', () {
        expect(Duration(seconds: 45).toHuman(), '45 seconds');
      });

      test('one second', () {
        expect(Duration(seconds: 1).toHuman(), '1 second');
      });

      test('minutes and seconds', () {
        expect(Duration(minutes: 5, seconds: 30).toHuman(), '5 minutes 30 seconds');
      });

      test('one minute', () {
        expect(Duration(minutes: 1).toHuman(), '1 minute');
      });

      test('hours only', () {
        expect(Duration(hours: 2).toHuman(), '2 hours');
      });

      test('hours and minutes', () {
        expect(Duration(hours: 2, minutes: 5).toHuman(), '2 hours 5 minutes');
      });

      test('days', () {
        expect(Duration(days: 3, hours: 12).toHuman(), '3 days 12 hours');
      });

      test('milliseconds', () {
        expect(Duration(milliseconds: 500).toHuman(), '500 milliseconds');
      });
    });

    group('toHuman short form', () {
      test('zero', () {
        expect(Duration().toHuman(short: true), '0s');
      });

      test('seconds', () {
        expect(Duration(seconds: 45).toHuman(short: true), '45s');
      });

      test('minutes and seconds', () {
        expect(Duration(minutes: 5, seconds: 30).toHuman(short: true), '5m 30s');
      });

      test('hours and minutes', () {
        expect(Duration(hours: 3, minutes: 15).toHuman(short: true), '3h 15m');
      });

      test('days', () {
        expect(Duration(days: 2, hours: 6).toHuman(short: true), '2d 6h');
      });
    });
  });
}

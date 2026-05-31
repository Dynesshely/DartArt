import 'package:test/test.dart';

import 'package:dart_art/extensions/datetime/datetime_extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    group('startOfDay / endOfDay', () {
      test('startOfDay resets time', () {
        final dt = DateTime(2025, 6, 15, 14, 30, 45, 123);
        final start = dt.startOfDay;
        expect(start.year, 2025);
        expect(start.month, 6);
        expect(start.day, 15);
        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
        expect(start.millisecond, 0);
        expect(start.microsecond, 0);
      });

      test('endOfDay sets to 23:59:59.999', () {
        final dt = DateTime(2025, 6, 15, 14, 30);
        final end = dt.endOfDay;
        expect(end.hour, 23);
        expect(end.minute, 59);
        expect(end.second, 59);
        expect(end.millisecond, 999);
      });
    });

    group('relative day checks', () {
      test('isToday', () {
        expect(DateTime.now().isToday, isTrue);
      });

      test('isYesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, isTrue);
      });

      test('isTomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isTomorrow, isTrue);
      });

      test('isNotYesterday', () {
        expect(DateTime.now().isYesterday, isFalse);
      });
    });

    group('isWeekend / isWeekday', () {
      test('Saturday is weekend', () {
        final saturday = DateTime(2025, 5, 31); // A Saturday
        expect(saturday.isWeekend, isTrue);
        expect(saturday.isWeekday, isFalse);
      });

      test('Sunday is weekend', () {
        final sunday = DateTime(2025, 6, 1); // A Sunday
        expect(sunday.isWeekend, isTrue);
        expect(sunday.isWeekday, isFalse);
      });

      test('Monday is weekday', () {
        final monday = DateTime(2025, 6, 2); // A Monday
        expect(monday.isWeekend, isFalse);
        expect(monday.isWeekday, isTrue);
      });
    });

    group('isSameDay', () {
      test('same day different time', () {
        final a = DateTime(2025, 6, 15, 9, 0);
        final b = DateTime(2025, 6, 15, 23, 59);
        expect(a.isSameDay(b), isTrue);
      });

      test('different day', () {
        final a = DateTime(2025, 6, 15);
        final b = DateTime(2025, 6, 16);
        expect(a.isSameDay(b), isFalse);
      });
    });

    group('daysUntil', () {
      test('positive', () {
        final a = DateTime(2025, 6, 10);
        final b = DateTime(2025, 6, 15);
        expect(a.daysUntil(b), 5);
      });

      test('negative', () {
        final a = DateTime(2025, 6, 15);
        final b = DateTime(2025, 6, 10);
        expect(a.daysUntil(b), -5);
      });

      test('same day', () {
        final a = DateTime(2025, 6, 15);
        final b = DateTime(2025, 6, 15);
        expect(a.daysUntil(b), 0);
      });

      test('across months', () {
        final a = DateTime(2025, 5, 31);
        final b = DateTime(2025, 6, 2);
        expect(a.daysUntil(b), 2);
      });
    });

    group('age', () {
      test('birthday passed this year', () {
        final birth = DateTime(2000, 1, 15);
        final now = DateTime(2025, 6, 1);
        expect(birth.age(now: now), 25);
      });

      test('birthday not yet this year', () {
        final birth = DateTime(2000, 12, 1);
        final now = DateTime(2025, 6, 1);
        expect(birth.age(now: now), 24);
      });

      test('birthday today', () {
        final birth = DateTime(2000, 6, 1);
        final now = DateTime(2025, 6, 1);
        expect(birth.age(now: now), 25);
      });
    });

    group('startOfMonth / endOfMonth', () {
      test('startOfMonth', () {
        final dt = DateTime(2025, 6, 15);
        final start = dt.startOfMonth;
        expect(start.year, 2025);
        expect(start.month, 6);
        expect(start.day, 1);
      });

      test('endOfMonth June', () {
        final dt = DateTime(2025, 6, 15);
        final end = dt.endOfMonth;
        expect(end.day, 30);
      });

      test('endOfMonth January', () {
        final dt = DateTime(2025, 1, 15);
        final end = dt.endOfMonth;
        expect(end.day, 31);
      });
    });

    group('startOfYear / endOfYear', () {
      test('startOfYear', () {
        final dt = DateTime(2025, 6, 15);
        final start = dt.startOfYear;
        expect(start.month, 1);
        expect(start.day, 1);
      });

      test('endOfYear', () {
        final dt = DateTime(2025, 6, 15);
        final end = dt.endOfYear;
        expect(end.month, 12);
        expect(end.day, 31);
      });
    });
  });
}

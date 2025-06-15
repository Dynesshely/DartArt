// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:dart_art/extensions/datetime/timestamp.dart';

void timestampGrowingTest({bool inCsvFormat = false, bool inTest = true}) {
  if (!inCsvFormat && !inTest) {
    var overflow = DateTime.utc(292473178 * 10, 1, 1, 0, 0, 0, 0, 0);
    print("Overflow date of int64 milliseconds timestamp test: ${overflow.toIso8601String()}");
  }

  var start = DateTime.fromMillisecondsSinceEpoch(0);
  // var end2 = Timestamp.fromSafeMillisecondsSinceEpoch(0x7fffffffffffffff - 10);
  // if (!inCsvFormat) {
  //   print("Safe overflow date of int64 milliseconds timestamp test: ${end2.toIso8601String()}");
  // }
  var end = DateTime.utc(200000, 1, 1);
  // var end = DateTime.fromMillisecondsSinceEpoch(0x7fffffffffffffff - 10).add(const Duration(days: 365 * 1000000));
  var current = DateTime.fromMillisecondsSinceEpoch(1);

  if (!inCsvFormat && !inTest) {
    print("You are going to test the growing of DateTime from ${start.toIso8601String()} to ${end.toIso8601String()}");
  }

  while (current > start && current < end) {
    if (!inTest) {
      if (inCsvFormat) {
        print("${current.millisecondsSinceEpoch},${current.safeMillisecondsSinceEpoch},${current.toIso8601String()}");
      } else {
        print(">>> ${current.millisecondsSinceEpoch} ${current.toIso8601String()}");
        print(">>> ${current.safeMillisecondsSinceEpoch}");
      }
    }
    current = current.add(const Duration(days: 365000));
  }
}

void main() {
  // timestampGrowingTest(inCsvFormat: true);

  group('Tests for Timestamp extension on DateTime', () {
    test('Growing test', () => timestampGrowingTest());
  });
}

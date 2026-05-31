import 'package:test/test.dart';

import 'package:dart_art/types/result.dart';

void main() {
  group('Result', () {
    group('Ok', () {
      test('isOk / isErr', () {
        final result = Result<int, String>.ok(42);
        expect(result.isOk, isTrue);
        expect(result.isErr, isFalse);
      });

      test('okOrNull / errOrNull', () {
        final result = Result<int, String>.ok(42);
        expect(result.okOrNull, 42);
        expect(result.errOrNull, isNull);
      });

      test('unwrap', () {
        expect(Result<int, String>.ok(42).unwrap(), 42);
      });

      test('unwrapOr', () {
        expect(Result<int, String>.ok(42).unwrapOr(0), 42);
        expect(Result<int, String>.err('bad').unwrapOr(42), 42);
      });

      test('unwrapOrElse', () {
        expect(
          Result<int, String>.ok(42).unwrapOrElse((e) => e.length),
          42,
        );
        expect(
          Result<int, String>.err('bad').unwrapOrElse((e) => e.length),
          3,
        );
      });

      test('map', () {
        final result = Result<int, String>.ok(2).map((x) => x * 10);
        expect(result.unwrap(), 20);
      });

      test('mapErr on Ok is no-op', () {
        final result = Result<int, String>.ok(42).mapErr((e) => Exception(e));
        expect(result.unwrap(), 42);
      });

      test('fold', () {
        final result = Result<int, String>.ok(42).fold(
          (v) => 'ok: $v',
          (e) => 'err: $e',
        );
        expect(result, 'ok: 42');
      });

      test('orElse on Ok returns self', () {
        final result = Result<int, String>.ok(42).orElse(
          (e) => Result<int, String>.ok(0),
        );
        expect(result.unwrap(), 42);
      });

      test('toString', () {
        expect(Result<int, String>.ok(42).toString(), 'Ok(42)');
      });

      test('equality', () {
        expect(Result<int, String>.ok(42), Result<int, String>.ok(42));
        expect(Result<int, String>.ok(42), isNot(Result<int, String>.ok(43)));
      });

      test('sealed class switch', () {
        final result = Result<String, int>.ok('success');
        final output = switch (result) {
          Ok(value: final v) => v,
          Err(error: final e) => e.toString(),
        };
        expect(output, 'success');
      });
    });

    group('Err', () {
      test('isOk / isErr', () {
        final result = Result<int, String>.err('oops');
        expect(result.isOk, isFalse);
        expect(result.isErr, isTrue);
      });

      test('okOrNull / errOrNull', () {
        final result = Result<int, String>.err('oops');
        expect(result.okOrNull, isNull);
        expect(result.errOrNull, 'oops');
      });

      test('unwrap throws', () {
        expect(() => Result<int, String>.err('bad').unwrap(), throwsA(isA<ResultException>()));
      });

      test('unwrapOr', () {
        expect(Result<int, String>.err('bad').unwrapOr(0), 0);
      });

      test('map on Err is no-op', () {
        final result = Result<int, String>.err('bad').map((x) => x * 10);
        expect(result.isErr, isTrue);
        expect(result.errOrNull, 'bad');
      });

      test('mapErr', () {
        final result = Result<int, String>.err('bad').mapErr((e) => Exception(e));
        expect(result.isErr, isTrue);
        expect(result.errOrNull, isA<Exception>());
      });

      test('fold', () {
        final result = Result<int, String>.err('bad').fold(
          (v) => 'ok: $v',
          (e) => 'err: $e',
        );
        expect(result, 'err: bad');
      });

      test('orElse', () {
        final result = Result<int, String>.err('oops').orElse(
          (e) => Result<int, String>.ok(e.length),
        );
        expect(result.unwrap(), 4);
      });

      test('toString', () {
        expect(Result<int, String>.err('bad').toString(), 'Err(bad)');
      });

      test('equality', () {
        expect(Result<int, String>.err('bad'), Result<int, String>.err('bad'));
        expect(Result<int, String>.err('bad'), isNot(Result<int, String>.err('good')));
      });

      test('sealed class switch', () {
        final result = Result<String, int>.err(404);
        final output = switch (result) {
          Ok(value: final v) => v,
          Err(error: final e) => 'Error $e',
        };
        expect(output, 'Error 404');
      });
    });
  });
}

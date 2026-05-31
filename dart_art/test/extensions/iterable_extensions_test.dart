import 'package:test/test.dart';

import 'package:dart_art/extensions/iterable_extensions.dart';

void main() {
  group('IterableExtensions', () {
    group('chunked', () {
      test('even chunks', () {
        final result = [1, 2, 3, 4].chunked(2).toList();
        expect(result, [
          [1, 2],
          [3, 4],
        ]);
      });

      test('uneven last chunk', () {
        final result = [1, 2, 3, 4, 5].chunked(2).toList();
        expect(result, [
          [1, 2],
          [3, 4],
          [5],
        ]);
      });

      test('single chunk', () {
        final result = [1, 2, 3].chunked(10).toList();
        expect(result, [
          [1, 2, 3],
        ]);
      });

      test('empty iterable', () {
        expect([].chunked(2).toList(), []);
      });

      test('throws on non-positive size', () {
        expect(() => [1].chunked(0).toList(), throwsArgumentError);
        expect(() => [1].chunked(-1).toList(), throwsArgumentError);
      });

      test('size 1', () {
        final result = [1, 2, 3].chunked(1).toList();
        expect(result, [
          [1],
          [2],
          [3],
        ]);
      });
    });

    group('windowed', () {
      test('size 2', () {
        final result = [1, 2, 3, 4].windowed(2).toList();
        expect(result, [
          [1, 2],
          [2, 3],
          [3, 4],
        ]);
      });

      test('size 3', () {
        final result = [1, 2, 3, 4].windowed(3).toList();
        expect(result, [
          [1, 2, 3],
          [2, 3, 4],
        ]);
      });

      test('size exceeds length', () {
        expect([1, 2].windowed(4).toList(), []);
      });

      test('empty iterable', () {
        expect([].windowed(2).toList(), []);
      });

      test('throws on non-positive size', () {
        expect(() => [1].windowed(0).toList(), throwsArgumentError);
      });
    });

    group('intersperse', () {
      test('between elements', () {
        final result = [1, 2, 3].intersperse(0).toList();
        expect(result, [1, 0, 2, 0, 3]);
      });

      test('single element', () {
        expect([5].intersperse(0).toList(), [5]);
      });

      test('empty', () {
        expect([].intersperse(0).toList(), []);
      });
    });

    group('distinctBy', () {
      test('by key', () {
        final result = [
          (1, 'a'),
          (2, 'b'),
          (1, 'c'),
        ].distinctBy((t) => t.$1).toList();
        expect(result.length, 2);
        expect(result[0], (1, 'a'));
        expect(result[1], (2, 'b'));
      });

      test('by identity', () {
        final result = [1, 2, 1, 3, 2].distinctBy((x) => x).toList();
        expect(result, [1, 2, 3]);
      });
    });

    group('zip', () {
      test('equal length', () {
        final result = [1, 2, 3].zip(['a', 'b', 'c']).toList();
        expect(result, [
          [1, 'a'],
          [2, 'b'],
          [3, 'c'],
        ]);
      });

      test('first shorter', () {
        final result = [1].zip(['a', 'b']).toList();
        expect(result, [
          [1, 'a'],
        ]);
      });

      test('second shorter', () {
        final result = [1, 2, 3].zip(['a']).toList();
        expect(result, [
          [1, 'a'],
        ]);
      });
    });

    group('associate', () {
      test('to map', () {
        final result = ['a', 'bb', 'ccc'].associate((s) => MapEntry(s, s.length));
        expect(result, {'a': 1, 'bb': 2, 'ccc': 3});
      });
    });

    group('firstWhereOrNull', () {
      test('found', () {
        expect([1, 2, 3].firstWhereOrNull((e) => e > 2), 3);
      });

      test('not found', () {
        expect([1, 2, 3].firstWhereOrNull((e) => e > 5), isNull);
      });

      test('empty', () {
        expect(<int>[].firstWhereOrNull((e) => true), isNull);
      });
    });

    group('singleWhereOrNull', () {
      test('one match', () {
        expect([1, 2, 3].singleWhereOrNull((e) => e == 2), 2);
      });

      test('no match', () {
        expect([1, 2, 3].singleWhereOrNull((e) => e > 5), isNull);
      });

      test('more than one match throws', () {
        expect(() => [1, 2, 3].singleWhereOrNull((e) => e > 0), throwsStateError);
      });
    });

    group('partition', () {
      test('splits by predicate', () {
        final (passed, failed) = [1, 2, 3, 4, 5].partition((e) => e.isOdd);
        expect(passed, [1, 3, 5]);
        expect(failed, [2, 4]);
      });

      test('all pass', () {
        final (passed, failed) = [2, 4, 6].partition((e) => e.isEven);
        expect(passed, [2, 4, 6]);
        expect(failed, []);
      });

      test('all fail', () {
        final (passed, failed) = [1, 3, 5].partition((e) => e.isEven);
        expect(passed, []);
        expect(failed, [1, 3, 5]);
      });
    });
  });
}

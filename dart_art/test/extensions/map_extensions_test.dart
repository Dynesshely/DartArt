import 'package:test/test.dart';

import 'package:dart_art/extensions/map_extensions.dart';

void main() {
  group('MapExtensions', () {
    group('getPath', () {
      final map = {
        'user': {
          'name': 'Alice',
          'address': {
            'city': 'Paris',
            'zip': 75001,
          },
        },
        'count': 42,
      };

      test('nested string value', () {
        expect(map.getPath<String>('user.address.city'), 'Paris');
      });

      test('nested int value', () {
        expect(map.getPath<int>('user.address.zip'), 75001);
      });

      test('missing path returns null', () {
        expect(map.getPath('user.address.country'), isNull);
      });

      test('broken path returns null', () {
        expect(map.getPath('user.name.first'), isNull);
      });

      test('wrong type returns null', () {
        expect(map.getPath<String>('count'), isNull);
      });

      test('single key', () {
        expect(map.getPath<int>('count'), 42);
      });
    });

    group('tryGet', () {
      final map = {'string': 'hello', 'int': 42, 'double': 3.14, 'bool': true};

      test('tryString', () {
        expect(map.tryString('string'), 'hello');
        expect(map.tryString('int'), isNull);
      });

      test('tryInt', () {
        expect(map.tryInt('int'), 42);
        expect(map.tryInt('string'), isNull);
      });

      test('tryDouble', () {
        expect(map.tryDouble('double'), 3.14);
        expect(map.tryDouble('int'), isNull);
      });

      test('tryBool', () {
        expect(map.tryBool('bool'), isTrue);
        expect(map.tryBool('int'), isNull);
      });

      test('missing key', () {
        expect(map.tryString('missing'), isNull);
      });
    });

    group('tryList', () {
      final map = {
        'list': [1, 2, 3],
        'string': 'hello'
      };

      test('valid list', () {
        expect(map.tryList<int>('list'), [1, 2, 3]);
      });

      test('not a list', () {
        expect(map.tryList<int>('string'), isNull);
      });

      test('missing key', () {
        expect(map.tryList<int>('missing'), isNull);
      });
    });

    group('tryMap', () {
      final map = {
        'nested': {'a': 1},
        'string': 'hello'
      };

      test('valid map', () {
        expect(map.tryMap<String, int>('nested'), {'a': 1});
      });

      test('not a map', () {
        expect(map.tryMap<String, int>('string'), isNull);
      });
    });

    group('deepMerge', () {
      test('non-overlapping keys', () {
        final a = {'x': 1};
        final b = {'y': 2};
        expect(a.deepMerge(b), {'x': 1, 'y': 2});
      });

      test('b overrides a for non-map values', () {
        final a = {'x': 1};
        final b = {'x': 2};
        expect(a.deepMerge(b), {'x': 2});
      });

      test('recursive merge for nested maps', () {
        final a = {
          'x': {'a': 1}
        };
        final b = {
          'x': {'b': 2}
        };
        expect(a.deepMerge(b), {
          'x': {'a': 1, 'b': 2},
        });
      });

      test('combined', () {
        final a = {
          'k1': 1,
          'k2': {'a': 1}
        };
        final b = {
          'k2': {'b': 2},
          'k3': 3
        };
        expect(a.deepMerge(b), {
          'k1': 1,
          'k2': {'a': 1, 'b': 2},
          'k3': 3,
        });
      });
    });
  });
}

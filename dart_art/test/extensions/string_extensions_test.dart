import 'package:test/test.dart';

import 'package:dart_art/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    group('isBlank / isNotBlank', () {
      test('empty string', () {
        expect(''.isBlank, isTrue);
        expect(''.isNotBlank, isFalse);
      });

      test('whitespace only', () {
        expect('   '.isBlank, isTrue);
        expect('  \n\t '.isBlank, isTrue);
      });

      test('with content', () {
        expect('hello'.isBlank, isFalse);
        expect(' hello '.isBlank, isFalse);
      });
    });

    group('orNull', () {
      test('blank returns null', () {
        expect(''.orNull(), isNull);
        expect('  '.orNull(), isNull);
      });

      test('non-blank returns self', () {
        expect('hello'.orNull(), equals('hello'));
      });
    });

    group('case conversions', () {
      test('toCamelCase', () {
        expect('hello world'.toCamelCase(), 'helloWorld');
        expect('hello_world'.toCamelCase(), 'helloWorld');
        expect('hello-world'.toCamelCase(), 'helloWorld');
        expect('Hello World'.toCamelCase(), 'helloWorld');
      });

      test('toPascalCase', () {
        expect('hello world'.toPascalCase(), 'HelloWorld');
        expect('hello_world'.toPascalCase(), 'HelloWorld');
      });

      test('toSnakeCase', () {
        expect('helloWorld'.toSnakeCase(), 'hello_world');
        expect('Hello World'.toSnakeCase(), 'hello_world');
        expect('hello-world'.toSnakeCase(), 'hello_world');
      });

      test('toKebabCase', () {
        expect('helloWorld'.toKebabCase(), 'hello-world');
        expect('Hello World'.toKebabCase(), 'hello-world');
        expect('hello_world'.toKebabCase(), 'hello-world');
      });
    });

    group('capitalize / decapitalize', () {
      test('capitalize', () {
        expect('hello'.capitalize(), 'Hello');
        expect(''.capitalize(), '');
        expect('h'.capitalize(), 'H');
        expect('Hello'.capitalize(), 'Hello');
      });

      test('decapitalize', () {
        expect('Hello'.decapitalize(), 'hello');
        expect(''.decapitalize(), '');
      });
    });

    group('toTitleCase', () {
      test('simple', () {
        expect('hello world'.toTitleCase(), 'Hello World');
        expect('HELLO WORLD'.toTitleCase(), 'Hello World');
        expect('hello_world'.toTitleCase(), 'Hello World');
      });
    });

    group('truncate', () {
      test('no truncation needed', () {
        expect('Hello'.truncate(10), 'Hello');
      });

      test('truncates with default suffix', () {
        final result = 'Hello World'.truncate(8);
        expect(result.length, lessThanOrEqualTo(8));
        expect(result, endsWith('…'));
      });

      test('truncates with custom suffix', () {
        final result = 'Hello World'.truncate(8, suffix: '...');
        expect(result.length, lessThanOrEqualTo(8));
        expect(result, endsWith('...'));
      });

      test('exact max length', () {
        expect('Hello'.truncate(5), 'Hello');
      });
    });

    group('removeDiacritics', () {
      test('removes common diacritics', () {
        expect('café'.removeDiacritics(), 'cafe');
        expect('naïve'.removeDiacritics(), 'naive');
        expect('Åmål'.removeDiacritics(), 'Amal');
      });

      test('no diacritics', () {
        expect('hello'.removeDiacritics(), 'hello');
      });

      test('non-Latin characters pass through', () {
        expect('ハロー'.removeDiacritics(), 'ハロー');
        expect('你好'.removeDiacritics(), '你好');
      });
    });
  });
}

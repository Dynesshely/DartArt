/// Extension methods on [String] providing common text utilities absent from
/// the Dart SDK.
///
/// ```dart
/// final text = '  hello world  ';
/// print(text.isBlank);       // false
/// print(text.toTitleCase()); // "Hello World"
/// print(text.toSnakeCase()); // "hello_world"
/// ```
extension StringExtensions on String {
  // ── Blank / Empty checks ────────────────────────────────────────────────

  /// Whether this string is empty or consists solely of whitespace characters.
  ///
  /// ```dart
  /// ''.isBlank;          // true
  /// '   '.isBlank;       // true
  /// '\n\t'.isBlank;      // true
  /// 'hello'.isBlank;     // false
  /// ```
  bool get isBlank => trim().isEmpty;

  /// Whether this string contains at least one non-whitespace character.
  ///
  /// ```dart
  /// ''.isNotBlank;       // false
  /// '   '.isNotBlank;    // false
  /// 'hello'.isNotBlank;  // true
  /// ```
  bool get isNotBlank => !isBlank;

  /// Returns `null` if this string [isBlank], otherwise returns the string
  /// itself. Useful for converting blank strings to `null` in forms.
  ///
  /// ```dart
  /// ''.orNull();         // null
  /// '  '.orNull();       // null
  /// 'hello'.orNull();    // 'hello'
  /// ```
  String? orNull() => isBlank ? null : this;

  // ── Case conversions ───────────────────────────────────────────────────

  /// Converts this string to `camelCase`.
  ///
  /// ```dart
  /// 'hello world'.toCamelCase();       // "helloWorld"
  /// 'hello_world'.toCamelCase();       // "helloWorld"
  /// 'hello-world'.toCamelCase();       // "helloWorld"
  /// 'XMLHttpRequest'.toCamelCase();    // "xmlHttpRequest"
  /// ```
  String toCamelCase() {
    final words = _splitWords();
    if (words.isEmpty) return '';
    return words.first.toLowerCase() + words.skip(1).map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join();
  }

  /// Converts this string to `PascalCase`.
  ///
  /// ```dart
  /// 'hello world'.toPascalCase();      // "HelloWorld"
  /// 'hello_world'.toPascalCase();      // "HelloWorld"
  /// ```
  String toPascalCase() {
    final words = _splitWords();
    return words.map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join();
  }

  /// Converts this string to `snake_case`.
  ///
  /// ```dart
  /// 'helloWorld'.toSnakeCase();        // "hello_world"
  /// 'Hello World'.toSnakeCase();       // "hello_world"
  /// 'hello-world'.toSnakeCase();       // "hello_world"
  /// ```
  String toSnakeCase() => _splitWords().map((w) => w.toLowerCase()).join('_');

  /// Converts this string to `kebab-case`.
  ///
  /// ```dart
  /// 'helloWorld'.toKebabCase();        // "hello-world"
  /// 'Hello World'.toKebabCase();       // "hello-world"
  /// 'hello_world'.toKebabCase();       // "hello-world"
  /// ```
  String toKebabCase() => _splitWords().map((w) => w.toLowerCase()).join('-');

  // ── Capitalization ──────────────────────────────────────────────────────

  /// Returns a copy of this string with the first character uppercased.
  ///
  /// ```dart
  /// 'hello'.capitalize();     // "Hello"
  /// ''.capitalize();          // ""
  /// 'h'.capitalize();         // "H"
  /// ```
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Returns a copy of this string with the first character lowercased.
  ///
  /// ```dart
  /// 'Hello'.decapitalize();   // "hello"
  /// ''.decapitalize();        // ""
  /// ```
  String decapitalize() {
    if (isEmpty) return '';
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  /// Converts this string to Title Case.
  ///
  /// ```dart
  /// 'hello world'.toTitleCase();     // "Hello World"
  /// 'HELLO WORLD'.toTitleCase();     // "Hello World"
  /// 'hello_world'.toTitleCase();     // "Hello World"
  /// ```
  String toTitleCase() => _splitWords().map((w) => w.capitalize()).join(' ');

  // ── Truncation ──────────────────────────────────────────────────────────

  /// Truncates this string to at most [maxLength] characters.
  ///
  /// If the string exceeds [maxLength], it is cut and [suffix] is appended
  /// (defaults to `"…"`). The returned string's total length will be at most
  /// `maxLength` (suffix length is counted).
  ///
  /// If [maxLength] is less than or equal to [suffix]'s length, only the
  /// suffix is returned.
  ///
  /// ```dart
  /// 'Hello World'.truncate(8);           // "Hello W…"
  /// 'Hello World'.truncate(12);          // "Hello World" (no change)
  /// 'Hello World'.truncate(8, '...');    // "Hello..."
  /// ```
  String truncate(int maxLength, {String suffix = '…'}) {
    if (length <= maxLength) return this;
    if (maxLength <= suffix.length) return suffix;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  // ── Diacritics ──────────────────────────────────────────────────────────

  /// Returns a copy of this string with common diacritical marks removed.
  ///
  /// ```dart
  /// 'café'.removeDiacritics();           // "cafe"
  /// 'naïve'.removeDiacritics();          // "naive"
  /// 'Åmål'.removeDiacritics();           // "Amal"
  /// 'ハロー'.removeDiacritics();          // "ハロー" (non-Latin unaffected)
  /// ```
  String removeDiacritics() {
    const diacritics = {
      'À': 'A',
      'Á': 'A',
      'Â': 'A',
      'Ã': 'A',
      'Ä': 'A',
      'Å': 'A',
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'å': 'a',
      'È': 'E',
      'É': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'Ì': 'I',
      'Í': 'I',
      'Î': 'I',
      'Ï': 'I',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'Ò': 'O',
      'Ó': 'O',
      'Ô': 'O',
      'Õ': 'O',
      'Ö': 'O',
      'Ø': 'O',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ø': 'o',
      'Ù': 'U',
      'Ú': 'U',
      'Û': 'U',
      'Ü': 'U',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'Ý': 'Y',
      'ý': 'y',
      'ÿ': 'y',
      'Ç': 'C',
      'ç': 'c',
      'Ñ': 'N',
      'ñ': 'n',
      'Š': 'S',
      'š': 's',
      'Ž': 'Z',
      'ž': 'z',
      'Æ': 'AE',
      'æ': 'ae',
      'Œ': 'OE',
      'œ': 'oe',
      'ß': 'ss',
    };
    return split('').map((char) => diacritics[char] ?? char).join();
  }

  // ── Internal ────────────────────────────────────────────────────────────

  /// Splits this string into words, detecting boundaries at:
  /// - Whitespace / underscore / hyphen
  /// - CamelCase transitions
  /// - Acronym boundaries (e.g. `XMLHttpRequest` → `XML`, `Http`, `Request`)
  List<String> _splitWords() {
    // Replace separators with spaces
    final normalized = replaceAll(RegExp(r'[-_\s]+'), ' ');

    // Split at camelCase boundaries:
    //   "helloWorld"        → "hello World"
    //   "XMLHttpRequest"    → "XML Http Request"
    final result = <String>[];
    var current = '';
    for (var i = 0; i < normalized.length; i++) {
      final char = normalized[i];
      if (char == ' ') {
        if (current.isNotEmpty) {
          result.add(current);
          current = '';
        }
        continue;
      }
      if (current.isEmpty) {
        current = char;
        continue;
      }
      final prevUpper = current[current.length - 1] == current[current.length - 1].toUpperCase();
      final charUpper = char == char.toUpperCase();
      final charIsLetter = char.toUpperCase() != char.toLowerCase();

      if (charIsLetter && prevUpper && !charUpper && current.length > 1) {
        // "XMLH" + "ttp" → move leading uppercase chars (except last) to prev word
        // We're at the second lowercase letter after an uppercase sequence
        // E.g. "HTTPRe" → we need to split "HTTP" from "Re"
        var splitPos = current.length - 1;
        while (splitPos > 0 && current[splitPos - 1] == current[splitPos - 1].toUpperCase()) {
          splitPos--;
        }
        if (splitPos > 0 && splitPos < current.length) {
          result.add(current.substring(0, splitPos));
          current = current.substring(splitPos) + char;
          continue;
        }
      }
      if (charIsLetter && !prevUpper && charUpper) {
        // Start of a new word: "hello" + "World"
        result.add(current);
        current = char;
        continue;
      }
      current += char;
    }
    if (current.isNotEmpty) result.add(current);
    return result;
  }
}

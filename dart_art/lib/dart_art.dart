/// A collection of useful Dart utilities for all Dart developers.
///
/// ## Extensions
/// - [StringExtensions]: Blank checks, case conversions, truncation, diacritics.
/// - [IterableExtensions]: chunked, windowed, distinctBy, zip, associate, partition.
/// - [ListExtensions]: mapWhere — filter and map by index.
/// - [DateTimeExtensions]: isToday, isWeekend, age, startOfDay, daysUntil.
/// - [TimestampExtension]: Operator overloads and safe timestamp conversion.
/// - [NumberExtensions]: toCompact, toOrdinal, toPercent.
/// - [DurationExtensions]: toHuman — human-readable duration formatting.
/// - [MapExtensions]: deepMerge, getPath, tryGet, typed extraction (tryString, etc.).
///
/// ## Types
/// - [Result<T, E>]: Rust-style error handling with [Ok] and [Err] variants.
///
/// ## Units
/// - [BinarySize]: Human-readable byte size formatting with support for
///   IEC, JEDEC, and SI standards.
///
/// ## Algorithms
/// - [LCS]: Longest Common Subsequence.
/// - [Levenshtein]: Levenshtein edit distance (insertion, deletion, substitution).
/// - [DamerauLevenshtein]: Damerau-Levenshtein distance (adds transposition).
/// - [JaroWinkler]: Jaro-Winkler similarity (optimized for short strings).
library;

// Algorithms
export 'package:dart_art/algorithm/text/distance/calculation_options.dart';
export 'package:dart_art/algorithm/text/distance/calculators/damerau_levenshtein.dart';
export 'package:dart_art/algorithm/text/distance/calculators/jaro_winkler.dart';
export 'package:dart_art/algorithm/text/distance/calculators/lcs.dart';
export 'package:dart_art/algorithm/text/distance/calculators/levenshtein.dart';
export 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
export 'package:dart_art/algorithm/text/distance/distance_info.dart';

// Extensions
export 'package:dart_art/extensions/datetime/datetime_extensions.dart';
export 'package:dart_art/extensions/datetime/timestamp.dart';
export 'package:dart_art/extensions/duration_extensions.dart';
export 'package:dart_art/extensions/iterable_extensions.dart';
export 'package:dart_art/extensions/list_extensions.dart';
export 'package:dart_art/extensions/map_extensions.dart';
export 'package:dart_art/extensions/number_extensions.dart';
export 'package:dart_art/extensions/string_extensions.dart';

// Types
export 'package:dart_art/types/result.dart';

// Units
export 'package:dart_art/units/binary_size.dart';
export 'package:dart_art/units/standards/binary_size_convention_standard.dart';

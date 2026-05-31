/// A collection of useful Dart utilities for all Dart developers.
///
/// This library provides:
/// - [BinarySize]: Human-readable byte size formatting with support for
///   IEC, JEDEC, and SI standards.
/// - [LCS]: Longest Common Subsequence algorithm for text distance computation.
/// - [Timestamp] / [TimestampExtension]: Safe timestamp handling and
///   operator overloads for [DateTime].
/// - [ListExtensions]: Additional extension methods on [List], such as
///   [ListExtensions.mapWhere].
library;

export 'package:dart_art/algorithm/text/distance/calculation_options.dart';
export 'package:dart_art/algorithm/text/distance/calculators/lcs.dart';
export 'package:dart_art/algorithm/text/distance/distance_calculator.dart';
export 'package:dart_art/algorithm/text/distance/distance_info.dart';
export 'package:dart_art/extensions/datetime/timestamp.dart';
export 'package:dart_art/extensions/list_extensions.dart';
export 'package:dart_art/units/binary_size.dart';
export 'package:dart_art/units/standards/binary_size_convention_standard.dart';

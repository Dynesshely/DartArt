/// A type-safe alternative to throwing exceptions, inspired by Rust's
/// `Result<T, E>`.
///
/// [Result] represents one of two states:
/// - [Ok] — success, wrapping a value of type [T].
/// - [Err] — failure, wrapping an error of type [E].
///
/// Because [Result] is a [sealed] class, exhaustive pattern matching with
/// `switch` is available (Dart 3.0+):
///
/// ```dart
/// final result = fetchUser(id);
/// switch (result) {
///   case Ok(value: final user): print('Got $user');
///   case Err(error: final e):  print('Failed: $e');
/// }
/// ```
///
/// [T] is the success value type; [E] must extend [Object] (including
/// [Exception], [String], or custom error classes).
sealed class Result<T, E extends Object> {
  const Result._();

  /// Creates a successful [Result] wrapping [value].
  const factory Result.ok(T value) = Ok<T, E>;

  /// Creates a failed [Result] wrapping [error].
  const factory Result.err(E error) = Err<T, E>;

  /// Whether this is an [Ok] result.
  bool get isOk => this is Ok<T, E>;

  /// Whether this is an [Err] result.
  bool get isErr => this is Err<T, E>;

  /// Returns the success value if this is [Ok], otherwise `null`.
  ///
  /// ```dart
  /// Result.ok(42).okOrNull;  // 42
  /// Result.err('bad').okOrNull; // null
  /// ```
  T? get okOrNull => isOk ? (this as Ok<T, E>).value : null;

  /// Returns the error value if this is [Err], otherwise `null`.
  ///
  /// ```dart
  /// Result.err('bad').errOrNull; // 'bad'
  /// Result.ok(42).errOrNull;     // null
  /// ```
  E? get errOrNull => isErr ? (this as Err<T, E>).error : null;

  /// Returns the success value if this is [Ok], otherwise returns [defaultValue].
  ///
  /// ```dart
  /// Result.err('bad').unwrapOr(42); // 42
  /// ```
  T unwrapOr(T defaultValue) => isOk ? (this as Ok<T, E>).value : defaultValue;

  /// Returns the success value if this is [Ok], otherwise computes a fallback
  /// using [onErr].
  ///
  /// ```dart
  /// Result.err('bad').unwrapOrElse((e) => e.length); // 3
  /// ```
  T unwrapOrElse(T Function(E error) onErr) => isOk ? (this as Ok<T, E>).value : onErr((this as Err<T, E>).error);

  /// Returns the success value, or throws a [ResultException] if this is [Err].
  ///
  /// ```dart
  /// Result.ok(42).unwrap();     // 42
  /// Result.err('bad').unwrap(); // throws ResultException
  /// ```
  T unwrap() {
    if (isOk) return (this as Ok<T, E>).value;
    throw ResultException((this as Err<T, E>).error);
  }

  /// Transforms the success value with [f] if this is [Ok].
  ///
  /// ```dart
  /// Result.ok(2).map((x) => x * 10); // Ok(20)
  /// Result.err('bad').map((x) => x * 10); // Err('bad')
  /// ```
  Result<R, E> map<R>(R Function(T value) f) {
    if (isOk) return Result.ok(f((this as Ok<T, E>).value));
    return Result.err((this as Err<T, E>).error);
  }

  /// Transforms the error value with [f] if this is [Err].
  ///
  /// ```dart
  /// Result.err('bad').mapErr((e) => Exception(e)); // Err(Exception('bad'))
  /// ```
  Result<T, F> mapErr<F extends Object>(F Function(E error) f) {
    if (isErr) return Result.err(f((this as Err<T, E>).error));
    return Result.ok((this as Ok<T, E>).value);
  }

  /// Collapses the result with [onOk] or [onErr], producing a single value of
  /// type [R].
  ///
  /// ```dart
  /// result.fold(
  ///   (user) => 'User: $user',
  ///   (err)  => 'Error: $err',
  /// );
  /// ```
  R fold<R>(R Function(T value) onOk, R Function(E error) onErr) {
    if (isOk) return onOk((this as Ok<T, E>).value);
    return onErr((this as Err<T, E>).error);
  }

  /// Returns the success value if this is [Ok], otherwise the result of
  /// calling [f] on the error.
  ///
  /// ```dart
  /// Result.err('oops').orElse((e) => Result.ok('fallback')); // Ok('fallback')
  /// ```
  Result<T, F> orElse<F extends Object>(Result<T, F> Function(E error) f) {
    if (isOk) return Result.ok((this as Ok<T, E>).value);
    return f((this as Err<T, E>).error);
  }

  @override
  String toString() => fold((v) => 'Ok($v)', (e) => 'Err($e)');
}

/// The success variant of [Result].
class Ok<T, E extends Object> extends Result<T, E> {
  final T value;

  const Ok(this.value) : super._();

  @override
  bool operator ==(Object other) => other is Ok<T, E> && other.value == value;

  @override
  int get hashCode => Object.hash('Ok', value);
}

/// The error variant of [Result].
class Err<T, E extends Object> extends Result<T, E> {
  final E error;

  const Err(this.error) : super._();

  @override
  bool operator ==(Object other) => other is Err<T, E> && other.error == error;

  @override
  int get hashCode => Object.hash('Err', error);
}

/// Thrown by [Result.unwrap] when called on an [Err].
class ResultException<E extends Object> implements Exception {
  final E error;

  const ResultException(this.error);

  @override
  String toString() => 'ResultException: $error';
}

sealed class Result<S> {

  const Result();

  factory Result.success(S data) = Success<S>;
  factory Result.failure(dynamic failure) = Failure<S>;

  /// Returns `true` when this is a [Success].
  bool get isSuccess => this is Success<S>;
  /// Returns `true` when this is a [Failure].
  bool get isFailure => this is Failure<S>;

  /// Returns the success value or `null`.
  S? get dataOrNull => switch (this) {
    Success<S>(:final S data) => data,
    Failure<S>() => null
  };

  /// Returns the failure or `null`.
  dynamic get failureOrNull => switch (this) {
    Success<S>() => null,
    Failure<S>(:final dynamic failure) => failure,
  };

  /// Executes [onSuccess] or [onFailure] and returns the result.
  T fold<T>({required T Function(S data) onSuccess, required T Function(dynamic failure) onFailure}) => switch (this) {
    Success<S>(:final S data) => onSuccess(data),
    Failure<S>(:final dynamic failure) => onFailure(failure)
  };

}

/// Successful result carrying a value of type [S].
final class Success<S> extends Result<S> {
  const Success(this.data);
  final S data;
}

/// Failed result carrying a [Failure].
final class Failure<S> extends Result<S> {
  const Failure(this.failure);
  final dynamic failure;
}
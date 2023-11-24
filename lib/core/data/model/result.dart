class Result<T> {
  Result._(this.data);

  factory Result.success(T? data) = _Success<T>;

  factory Result.failure({String? errorMessage, T? data}) = _Failure<T>;

  factory Result.loading() = _Loading<T>;

  bool get isSuccess => this is _Success<T>;
  bool get isLoading => this is _Loading<T>;
  bool get isFailure => this is _Failure<T?>;

  final T? data;

  // Getter method to access the error message
  String? get errorMessage {
    if (isFailure) {
      return (this as _Failure).errorMessage;
    }
    return null;
  }
}

class _Success<T> extends Result<T> {
  _Success(super.data) : super._();
}

class _Loading<T> extends Result<T> {
  _Loading() : super._(null);
}

class _Failure<T> extends Result<T> {
  _Failure({this.errorMessage, T? data}) : super._(data);

  @override
  final String? errorMessage;
}

import 'result.dart';
export 'result.dart';


class Resource<T> {
  final Result state;
  final T? data;
  final String? message;
  final int? statusCode;
  final String? errorCode;
  final dynamic err;

  const Resource({
    required this.state,
    this.data,
    this.message,
    this.statusCode,
    this.errorCode,
    this.err,
  });

  const Resource.initial({this.data})
      : state = Result.initial,
        message = null,
        statusCode = null,
        errorCode = null,
        err = null;

  const Resource.success(this.data)
      : state = Result.success,
        message = null,
        statusCode = null,
        errorCode = null,
        err = null;

  const Resource.error(
    this.message,
    this.statusCode, {
    this.errorCode,
    this.err,
  })  : state = Result.error,
        data = null;

  const Resource.loading({this.data})
      : state = Result.loading,
        message = null,
        statusCode = null,
        errorCode = null,
        err = null;

  Resource<T> copyWith({
    Result? state,
    T? data,
    String? message,
    int? statusCode,
    String? errorCode,
    dynamic err,
  }) {
    return Resource(
      state: state ?? this.state,
      data: data ?? this.data,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      errorCode: errorCode ?? this.errorCode,
      err: err ?? this.err,
    );
  }

  Resource<O> parse<O>(O Function(T origin) parser) {
    if (state == Result.initial) {
      return Resource<O>.initial();
    }

    if (state == Result.loading) {
      return Resource<O>.loading();
    }

    if (state == Result.error) {
      return Resource<O>.error(
        message,
        statusCode,
        errorCode: errorCode,
        err: err,
      );
    }

    final rawData = data;
    if (rawData == null) {
      if (null is O) {
        return Resource<O>.success(null as O);
      }
      return Resource<O>.error(
        "Data is null",
        statusCode,
        errorCode: errorCode,
        err: err,
      );
    }

    try {
      final parsed = parser(rawData);
      return Resource<O>.success(parsed);
    } catch (e) {
      return Resource<O>.error(
        e.toString(),
        statusCode,
        errorCode: errorCode,
        err: e,
      );
    }
  }

  bool get isInitial => state == Result.initial;
  bool get isLoading => state == Result.loading;
  bool get isSuccess => state == Result.success;
  bool get isError => state == Result.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Resource &&
        other.state == state &&
        other.data == data &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode => Object.hash(
        state,
        data,
        message,
        statusCode,
        errorCode,
      );
}

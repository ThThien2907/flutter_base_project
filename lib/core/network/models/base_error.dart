class BaseError {
  const BaseError({this.raw});

  final dynamic raw;

  factory BaseError.fromJson(Map<String, dynamic> json) => BaseError(raw: json);
}

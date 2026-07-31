/// ZETRA Core — API Response Wrapper
///
/// Standardised envelope matching the Zetra backend contract:
/// ```json
/// { "status": "success", "message": "OK", "data": { ... }, "code": 200 }
/// ```
class ApiResponse<T> {
  const ApiResponse({
    required this.status,
    required this.message,
    required this.code,
    this.data,
  });

  final String status;
  final String message;
  final int code;
  final T? data;

  bool get isSuccess => status == 'success' || (code >= 200 && code < 300);

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'code': code,
      if (data != null) 'data': toJsonT(data),
    };
  }

  @override
  String toString() =>
      'ApiResponse(status: $status, code: $code, message: $message)';
}

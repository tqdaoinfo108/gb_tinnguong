/// Wrapper chuẩn cho API response.
/// Mọi response từ server đều được parse qua class này.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  bool get isSuccess => success && data != null;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final Map<String, List<String>>? errors;

  ApiResponse({this.data, this.message, required this.success, this.errors});

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(data: data, message: message, success: true);
  }

  factory ApiResponse.error(
    String message, {
    Map<String, List<String>>? errors,
  }) {
    return ApiResponse(message: message, success: false, errors: errors);
  }
}

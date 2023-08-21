// The response class is used to return data from the API

class ApiResponse<T> {
  T? data;
  int status;
  String message;
  bool ok;

  ApiResponse({
    this.data,
    required this.status,
    required this.message,
    this.ok = true,
  });
}

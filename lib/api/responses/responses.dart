// The response class is used to return data from the API

import 'package:dio/dio.dart' as diolib;

class Response {
  bool timedOut = false;
  diolib.Response? response;

  Response({this.response, this.timedOut = false});
}

class ApiResponse<T> extends Response {
  T? data;
  int status;
  String message;
  bool ok;

  ApiResponse({
    this.data,
    required this.status,
    required this.message,
    this.ok = true,
    super.timedOut = false,
    super.response,
  });

  static ApiResponse fromResponse(diolib.Response response) {
    return ApiResponse(
      data: response.data.toString(),
      status: response.statusCode!,
      message: response.data["message"],
      ok: response.statusCode! == 200,
      response: response,
      timedOut: response.statusCode == 408,
    );
  }
}

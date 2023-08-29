// The response class is used to return data from the API

import 'package:dio/dio.dart' as diolib;

// Represents a response from an API request
class Response {
  // Indicates if the request timed out
  bool timedOut = false;

  // The actual Dio response object
  diolib.Response? response;

  // Constructor to initialize the response object
  Response({this.response, this.timedOut = false});
}

// Represents a structured API response with data and status information
class ApiResponse<T> extends Response {
  // The data received from the API
  T? data;

  // The HTTP status code of the response
  int status;

  // A message associated with the response
  String message;

  // Indicates if the response is considered successful (HTTP 200)
  bool ok;

  // Constructor to initialize the ApiResponse object
  ApiResponse({
    this.data,
    required this.status,
    required this.message,
    this.ok = true,
    super.timedOut = false,
    super.response,
  });

  // Factory method to create an ApiResponse from a Dio response
  static ApiResponse fromResponse(diolib.Response response) {
    return ApiResponse(
      data: response.data.toString(), // Extract response data as string
      status: response.statusCode!, // Extract HTTP status code
      message: response.data["message"], // Extract message from response data
      ok: response.statusCode! == 200, // Check if HTTP status is 200
      response: response, // Store the Dio response object
      timedOut: response.statusCode == 408, // Check if request timed out (HTTP 408)
    );
  }
}
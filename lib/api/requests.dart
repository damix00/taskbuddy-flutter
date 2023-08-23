import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class Requests {
  static Future<http.Response?> fetchEndpoint(String endpoint,
      {dynamic data, Map? headers}) async {
    try {
      final response = await http
          .post(Uri.parse(endpoint), body: json.encode(data).toString(), headers: {
        'Content-Type': 'application/json',
      });
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<ApiResponse> buildAccountResponse(String endpoint,
      {dynamic data, Map? headers}) async {
    final response =
        await fetchEndpoint(endpoint, data: data, headers: headers);

    if (response == null) {
      return ApiResponse(
          status: 500, message: 'Something went wrong', ok: false);
    }

    print(response.body);

    // final json = jsonDecode(response.body);

    // if (response.statusCode != 200) {
    //   return ApiResponse(
    //       status: response.statusCode, message: json.message, ok: false);
    // }

    // return ApiResponse(
    //     status: 200,
    //     message: json.message,
    //     ok: true,
    //     data: AccountResponse.fromJson(json));

    return ApiResponse(status: 500, message: 'Something went wrong', ok: false);
  }
}

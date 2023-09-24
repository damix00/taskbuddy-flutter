import 'package:taskbuddy/api/responses/responses.dart';
import 'package:dio/dio.dart' as diolib;

final dio = diolib.Dio();

class Requests {
  static Future<Response?> fetchEndpoint(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, String>? headers,
      Map<String, dynamic>? files,
      String method = 'GET',
      Duration timeout = const Duration(seconds: 20)}) async {
    try {
      bool timedOut = false;

      var addedHeaders = {"Content-Type": "application/json"};
      if (headers != null) {
        addedHeaders.addAll(headers);
      }

      if (files != null && data != null) {
        data.addEntries(files.entries);
      }

      diolib.FormData formData = diolib.FormData.fromMap(data ?? {});

      final response = await dio
          .request(
        endpoint,
        options: diolib.Options(
          method: method.toUpperCase(),
          headers: addedHeaders,
          contentType: 'application/json',
        ),
        data: formData,
      )
          .timeout(timeout, onTimeout: () {
        timedOut = true;
        return diolib.Response(
            requestOptions: diolib.RequestOptions(
              method: method.toUpperCase(),
            ),
            statusCode: 408);
      });

      return Response(
        response: response,
        timedOut: timedOut,
      );
    } catch (e) {
      if (e is diolib.DioException) {
        return Response(
          response: e.response,
          timedOut: false,
        );
      }
      return null;
    }
  }
}

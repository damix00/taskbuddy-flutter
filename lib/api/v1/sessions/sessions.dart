import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/api/responses/sessions/session_response.dart';
import 'package:taskbuddy/utils/utils.dart';

class Sessions {
  Future<ApiResponse<SessionResponse?>> create(
    String token,
    {
      List<int> tags = const [],
      int urgency = UrgencyType.ALL,
      int location = LocationType.ALL,
      int type = SessionType.ALL,
      double? lat,
      double? lon,
      int? minPrice,
      int? maxPrice,
    }
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/sessions",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      },
      data: {
        'tags': Utils.listToString(tags),
        'urgency': urgency,
        'location': location,
        'type': type,
        'lat': lat,
        'lon': lon,
        'min_price': minPrice,
        'max_price': maxPrice,
      }
    );

    if (response == null) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return ApiResponse(status: 500, message: "", ok: false);
    }

    return ApiResponse(
      status: response.response!.statusCode!,
      message: 'OK',
      ok: response.response!.statusCode! == 200,
      data: SessionResponse.fromJson(response.response!.data['session']),
      response: response.response,
    );
  }

  Future<List<PostResultsResponse>> getPosts(
    String token,
    int sessionId
  ) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/sessions/$sessionId/posts",
      method: "GET",
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    return (response.response!.data['posts'] as List).map((e) => PostResultsResponse.fromJson(e)).toList();
  }
}
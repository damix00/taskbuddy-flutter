import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/api/responses/posts/post_tags_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';

class Posts {
  Future<ApiResponse<PostTagsResponse?>> tags() async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/tags",
      method: "GET",
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
      data: PostTagsResponse.fromJson(response.response!.data),
      response: response.response,
    );
  }

  Future<ApiResponse<PostResponse?>> createPost(String token, {
    required PostType jobType,
    required String title,
    required String description,
    required double locationLat,
    required double locationLon,
    required String locationName,
    required bool isRemote,
    required bool isUrgent,
    required double price,
    required DateTime startDate,
    required DateTime endDate,
    required List<int> tags,
    required List<String> media,
  }) async {
  }
}
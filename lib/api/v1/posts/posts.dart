import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/posts/post_tags_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

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
}
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/api/responses/posts/post_tags_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:dio/dio.dart' as diolib;
import 'package:taskbuddy/utils/utils.dart';

final dio = diolib.Dio();

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
    double? locationLat,
    double? locationLon,
    String? locationName,
    required bool isRemote,
    required bool isUrgent,
    required double suggestionRadius,
    required double price,
    required DateTime startDate,
    required DateTime endDate,
    required List<int> tags,
    required List<XFile> media,
  }) async {
    var files = <String, dynamic>{};

    for (int i = 0; i < media.length; i++) {
      files[i.toString()] = await diolib.MultipartFile.fromFile(
        media[i].path,
        filename: media[i].path.split('/').last,
        // contentType:
      );
    }

    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts",
      method: "POST",
      data: {
        'job_type': jobType.index,
        'title': title,
        'description': description,
        'location_lat': locationLat,
        'location_lon': locationLon,
        'location_name': locationName,
        'is_remote': isRemote,
        'is_urgent': isUrgent,
        'suggestion_radius': suggestionRadius,
        'price': price,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'tags': Utils.listToString(tags.map((e) => e.toString()).toList()),
      },
      files: files,
      headers: {
        "Authorization": "Bearer $token",
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
      data: PostResponse.fromJson(response.response!.data["post"]),
      response: response.response,
    );
  }

  Future<bool> deletePost(String token, String postUuid) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/${Uri.encodeComponent(postUuid)}",
      method: "DELETE",
      headers: {
        "Authorization": "Bearer $token",
      }
    );

    if (response == null) {
      return false;
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return false;
    }

    return true;
  }
}
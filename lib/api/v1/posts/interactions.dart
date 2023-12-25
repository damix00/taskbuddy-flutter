import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

class PostInteractionsApi {
  Future<bool> likePost(String token, String postUuid) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/${Uri.encodeComponent(postUuid)}/interactions/like",
      method: "PUT",
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

  Future<bool> unlikePost(String token, String postUuid) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/${Uri.encodeComponent(postUuid)}/interactions/like",
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

  Future<bool> bookmarkPost(String token, String postUuid) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/${Uri.encodeComponent(postUuid)}/interactions/bookmark",
      method: "PUT",
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

  Future<bool> unbookmarkPost(String token, String postUuid) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/posts/${Uri.encodeComponent(postUuid)}/interactions/bookmark",
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
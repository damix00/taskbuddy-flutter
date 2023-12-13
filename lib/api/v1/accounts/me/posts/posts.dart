import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';

class MyPostsRoute {
  Future<List<PostResponse>> get(String token, {int offset = 0}) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/posts?offset=$offset",
      method: "GET",
      headers: {
        'Authorization': "Bearer ${token}",
      }
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    var posts = <PostResponse>[];

    for (var post in response.response!.data["posts"]) {
      posts.add(PostResponse.fromJson(post));
    }

    return posts;
  }
}
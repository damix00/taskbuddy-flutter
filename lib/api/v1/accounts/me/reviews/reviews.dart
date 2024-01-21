import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';

class Reviews {
  Future<List<ReviewResponse>> get(String token, {int offset = 0, int type = 0}) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/reviews?offset=$offset&type=$type",
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

    var posts = <ReviewResponse>[];

    for (var post in response.response!.data["reviews"]) {
      posts.add(ReviewResponse.fromJson(post));
    }

    return posts;
  }
}
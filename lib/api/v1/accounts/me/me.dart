import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/v1/accounts/me/posts/posts.dart';
import 'package:taskbuddy/api/v1/accounts/me/profile/profile.dart';

class MeRoute {
  ProfileRoute get profile => ProfileRoute();
  MyPostsRoute get posts => MyPostsRoute();

  Future<bool> updateFCMToken(String authToken, String fcmToken) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/fcm",
      method: "PATCH",
      headers: {
        "Authorization": "Bearer $authToken",
      },
      data: {
        "fcm_token": fcmToken
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
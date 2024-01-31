import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/v1/accounts/me/posts/posts.dart';
import 'package:taskbuddy/api/v1/accounts/me/profile/profile.dart';
import 'package:taskbuddy/api/v1/accounts/me/reviews/reviews.dart';
import 'package:taskbuddy/api/v1/accounts/me/security/forgot_password.dart';

class MeRoute {
  ProfileRoute get profile => ProfileRoute();
  MyPostsRoute get posts => MyPostsRoute();
  Reviews get reviews => Reviews();
  ForgotPassword get forgotPassword => ForgotPassword();

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

  Future<bool> logout(String token) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/logout",
      method: "POST",
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response == null) {
      return false;
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<List<PublicAccountResponse>> getBlockedUsers(String authToken, {
    int offset = 0,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/blocked?offset=$offset",
      method: "GET",
      headers: {
        "Authorization": "Bearer $authToken",
      },
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    List<PublicAccountResponse> blockedUsers = [];

    for (var blockedUser in response.response!.data["accounts"]) {
      blockedUsers.add(PublicAccountResponse.fromJson(blockedUser));
    }

    return blockedUsers;
  }

  Future<List<PublicAccountResponse>> getFriends(String authToken, {
    int offset = 0,
  }) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/friends?offset=$offset",
      method: "GET",
      headers: {
        "Authorization": "Bearer $authToken",
      },
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    List<PublicAccountResponse> friends = [];

    for (var friend in response.response!.data["friends"]) {
      friends.add(PublicAccountResponse.fromJson(friend));
    }

    return friends;
  }

  Future<List<int>> getInterests(String token, {
    int offset = 0
  }) async {
        var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/interests?offset=$offset",
      method: "GET",
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    List<int> interests = [];

    for (var id in response.response!.data["interests"]) {
      interests.add(int.parse(id.toString()));
    }

    return interests;
  }

  Future<bool> deleteInterest(String token, int id) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/interests/$id",
      method: "DELETE",
      headers: {
        "Authorization": "Bearer $token",
      },
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
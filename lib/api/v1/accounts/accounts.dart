import 'dart:io';

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/account/account_response.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';
import 'package:taskbuddy/api/v1/accounts/check_existence.dart';
import 'package:dio/dio.dart' as diolib;
import 'package:taskbuddy/api/v1/accounts/me/me.dart';
import 'package:taskbuddy/api/v1/accounts/verification/verification.dart';

final dio = diolib.Dio();

// Class for handling account-related operations
class Accounts {
  CheckExistence get checkExistence => CheckExistence();
  Verification get verification => Verification();
  MeRoute get meRoute => MeRoute();

  // Placeholder method for retrieving user account details
  Future<ApiResponse<AccountResponse?>> me(String token) {
    return AccountResponse.buildAccountResponse(
        '${ApiOptions.path}/accounts/me',
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
  }

  // Method for user login
  Future<ApiResponse<AccountResponse?>> login(
      String email, String password) async {
    // Construct and return an ApiResponse by calling buildAccountResponse
    return (await AccountResponse.buildAccountResponse(
        '${ApiOptions.path}/accounts/login',
        method: 'POST',
        data: {
          'email': email,
          'password': password,
        }));
  }

  Future<ApiResponse<AccountResponse?>> create({
    required String email,
    required String username,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String password,
    String bio = "",
    File? profilePicture,
  }) async {
    String filename =
        profilePicture != null ? profilePicture.path.split('/').last : "";

    Map<String, dynamic> files = {};

    if (profilePicture != null) {
      files = {
        'profile_picture': await diolib.MultipartFile.fromFile(
            profilePicture.path,
            filename: filename),
      };
    }

    return (await AccountResponse.buildAccountResponse(
        '${ApiOptions.path}/accounts/create',
        method: 'POST',
        data: {
          'email': email,
          'username': username,
          'phone_number': phoneNumber,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'bio': bio,
          'profile_picture': filename,
        },
        files: files));
  }

  Future<ApiResponse<List<PublicAccountResponse>?>> search(String token, {
    required String query,
    int offset = 0,
  }) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/search?query=${Uri.encodeComponent(query)}&offset=${Uri.encodeComponent(offset.toString())}&type=user",
        method: "GET",
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
        data: (response.response!.data["users"] as List).map((e) => PublicAccountResponse.fromJson(e)).toList(),
        response: response.response,
      );
    }
    catch (e) {
      return ApiResponse(status: 500, message: "", ok: false);
    }
  }

  Future<bool> follow(String token, String uuid) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(uuid)}/follow",
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
    catch (e) {
      return false;
    }
  }

  Future<bool> unfollow(String token, String uuid) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(uuid)}/follow",
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
    catch (e) {
      return false;
    }
  }

  Future<bool> block(String token, String uuid) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(uuid)}/block",
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
    catch (e) {
      return false;
    }
  }

  Future<bool> unblock(String token, String uuid) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(uuid)}/block",
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
    catch (e) {
      return false;
    }
  }

  Future<ApiResponse<PublicAccountResponse?>> fetchAccount(String token, String uuid) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(uuid)}",
        method: "GET",
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
        data: PublicAccountResponse.fromJson(response.response!.data["user"]),
        response: response.response,
      );
    }
    catch (e) {
      return ApiResponse(status: 500, message: "", ok: false);
    }
  }

  Future<List<PostResponse>> getUserPosts(String token, String UUID, {int offset = 0}) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/${Uri.encodeComponent(UUID)}/posts?offset=$offset",
      method: "GET",
      headers: {
        'Authorization': "Bearer $token",
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

  Future<List<ReviewResponse>> getUserReviews(String token, String UUID, {int offset = 0, int type = 0}) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/${Uri.encodeComponent(UUID)}/reviews?offset=$offset&type=$type",
      method: "GET",
      headers: {
        'Authorization': "Bearer $token",
      }
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    var tmpReviews = <ReviewResponse>[];

    for (var review in response.response!.data["written"]) {
      tmpReviews.add(ReviewResponse.fromJson(review));
    }

    for (var review in response.response!.data["received"]) {
      tmpReviews.add(ReviewResponse.fromJson(review));
    }

    // Remove duplicates by UUID
    List<String> uuids = [];
    List<ReviewResponse> reviews = [];

    for (var review in tmpReviews) {
      if (!uuids.contains(review.UUID)) {
        uuids.add(review.UUID);
        reviews.add(review);
      }
    }

    return reviews;
  }

  Future<bool> report(String token, String UUID, String reason) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/${Uri.encodeComponent(UUID)}/report",
        method: "POST",
        headers: {
          "Authorization": "Bearer $token",
        },
        data: {
          "reason": reason,
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
    catch (e) {
      return false;
    }
  }
}

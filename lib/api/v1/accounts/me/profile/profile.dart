import 'dart:io';

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:dio/dio.dart' as diolib;

final dio = diolib.Dio();

class ProfileRoute {
  Future<ApiResponse<AccountResponse?>> update(String token, {
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    num? lat,
    num? lon,
    String? locationText,
    bool? isPrivate,
    bool? removeProfilePicture,
    File? profilePicture
  }) async {
      String filename =
        profilePicture != null ? profilePicture.path.split('/').last : "";

    Map<String, dynamic> files = {};

    if (profilePicture != null) {
      files = {
        'profile_picture': await diolib.MultipartFile.fromFile(profilePicture.path, filename: filename),
      };
    }

    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/me/profile",
        method: "PATCH",
        headers: {
          'Authorization': 'Bearer $token',
        },
        data: {
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'bio': bio,
          'location_lat': lat,
          'location_lon': lon,
          'location_text': locationText,
          'is_private': isPrivate,
          'remove_profile_picture': removeProfilePicture,
        },
        files: files,
      );

      if (response == null) {
        return ApiResponse(status: 500, message: "", ok: false);
      }

      if (response.timedOut || response.response?.statusCode != 200) {
        return ApiResponse(status: response.response?.statusCode ?? 500, message: "Internal server error", ok: false);
      }

      var json = response.response!.data;

      return ApiResponse(
        status: response.response!.statusCode!,
        message: 'W',
        ok: true,
        response: response.response!,
        data: AccountResponse.fromJson(json),
      );
    }
    catch (e) {
      return ApiResponse(status: 500, message: "", ok: false);
    }
  }
}
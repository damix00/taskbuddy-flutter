import 'dart:io';

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/profile_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:dio/dio.dart' as diolib;

final dio = diolib.Dio();

class ProfileRoute {
  Future<ApiResponse<ProfileResponse?>> update(String token, {
    String? firstName,
    String? lastName,
    String? bio,
    num? lat,
    num? lon,
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
          'first_name': firstName,
          'last_name': lastName,
          'bio': bio,
          'location_lat': lat,
          'location_lon': lon,
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

      print(json);
      print(response.response!.statusCode);

      return ApiResponse(
        status: response.response?.statusCode ?? 500,
        message: json['message'],
        ok: json['ok'],
        response: response.response,
        data: ProfileResponse.fromJson(json['data']),
      );
    }
    catch (e) {
      return ApiResponse(status: 500, message: "", ok: false);
    }
  }
}
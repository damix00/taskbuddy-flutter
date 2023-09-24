import 'dart:io';

import 'package:http/http.dart';
import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';
import 'package:taskbuddy/api/v1/accounts/check_existence.dart';
import 'package:dio/dio.dart' as diolib;

final dio = diolib.Dio();

// Class for handling account-related operations
class Accounts {
  CheckExistence get checkExistence => CheckExistence();

  // Placeholder method for retrieving user account details
  void me() {
    throw UnimplementedError();
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
}

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/account/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class ForgotPassword {
  Future<bool> sendCode(String email) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/forgot-password/send",
      method: "POST",
      data: {
        "email": email
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

  Future<ApiResponse<AccountResponse?>> resetPassword(String email, String otp, String password) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/forgot-password/reset",
      method: "POST",
      data: {
        "email": email,
        "code": otp,
        "password": password
      }
    );

    if (response == null) {
      return ApiResponse(status: 500, message: 'Request timed out', ok: false, timedOut: true);
    }

    if (response.timedOut) {
      return ApiResponse(status: 500, message: 'Request timed out', ok: false, timedOut: true);
    }

    if (response.response?.statusCode != 200) {
      return ApiResponse(
        status: response.response!.statusCode ?? 500,
        message: response.response!.data?["message"] ?? '',
        ok: false
      );
    }

    return ApiResponse(
      status: 200,
      message: "OK",
      ok: true,
      data: AccountResponse.fromJson(response.response!.data),
      response: response.response,
      timedOut: response.timedOut
    );
  }
}

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

class PhoneVerification {
  Future<bool> send(String token) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/verification/phone/send",
        headers: {
          "Authorization": "Bearer $token"
        }
      );

      if (response != null) {
        return response.response!.statusCode == 200;
      }

      return false;
    }

    catch (e) {
      return false;
    }
  }

  Future<bool> verify(String token, String code) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/verification/phone/verify?code=${Uri.encodeComponent(code)}",
        method: 'POST',
        headers: {
          "Authorization": "Bearer $token"
        }
      );

      if (response != null) {
        return response.response!.statusCode == 200;
      }

      return false;
    }

    catch (e) {
      return false;
    }
  }
}
import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

enum PhoneVerificationChannel {
  sms,
  call
}

class PhoneVerification {
  Future<bool> sendCode(String token, PhoneVerificationChannel channel) async {
    try {
      var response = await Requests.fetchEndpoint(
        "${ApiOptions.path}/accounts/verification/phone/${channel == PhoneVerificationChannel.sms ? 'send' : 'call'}",
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

  Future<bool> send(String token) {
    return sendCode(token, PhoneVerificationChannel.sms);
  }

  Future<bool> call(String token) {
    return sendCode(token, PhoneVerificationChannel.call);
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
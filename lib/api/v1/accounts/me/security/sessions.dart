import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/account/login_response.dart';

class LoginSessions {
  Future<List<LoginResponse>> getSessions(String token) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/sessions",
      method: "GET",
      headers: {
        "Authorization": "Bearer $token"
      }
    );

    if (response == null) {
      return [];
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return [];
    }

    var sessions = <LoginResponse>[];

    for (var post in response.response!.data["logins"]) {
      sessions.add(LoginResponse.fromJson(post));
    }

    return sessions;
  }

  Future<bool> deleteSession(String token, int id) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/sessions/$id",
      method: "DELETE",
      headers: {
        "Authorization": "Bearer $token"
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

  Future<bool> logoutAll(String token) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/sessions/logout-all",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
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

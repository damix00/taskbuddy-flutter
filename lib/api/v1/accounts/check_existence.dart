import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

class CheckExistence {
  Future<bool> _request(String endpoint) async {
    var res = await Requests.fetchEndpoint(endpoint, method: 'GET');

    if (res == null) return true; // assume taken

    if (res.response!.statusCode! >= 500) return true; // assume taken

    return res.response!.statusCode != 200;
  }

  Future<bool> email(String email) async {
    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?email=${Uri.encodeComponent(email)}'));
  }

  Future<bool> username(String username) async {
    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?username=${Uri.encodeComponent(username)}'));
  }
}

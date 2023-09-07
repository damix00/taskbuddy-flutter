import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/existence_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class CheckExistence {
  Future<ExistenceResponse> _request(
      String endpoint, Duration? fakeDuration) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var res = await Requests.fetchEndpoint(endpoint, method: 'GET');

    if (fakeDuration != null &&
        DateTime.now().millisecondsSinceEpoch - time <
            fakeDuration.inMilliseconds) {
      // Add a fake delay
      // This is to prevent the UI from flashing
      await Future.delayed(Duration(
          milliseconds: fakeDuration.inMilliseconds -
              (DateTime.now().millisecondsSinceEpoch - time)));
    }

    if (res!.response!.statusCode == 200) {
      return ExistenceResponse.fromJson(res.response!.data);
    }

    return ExistenceResponse(error: ErrorType.serverError);
  }

  Future<ExistenceResponse> email(String email, {Duration? fakeDelay}) async {
    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?email=${Uri.encodeComponent(email)}',
        fakeDelay));
  }

  Future<ExistenceResponse> username(String username,
      {Duration? fakeDelay}) async {
    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?username=${Uri.encodeComponent(username)}',
        fakeDelay));
  }

  Future<ExistenceResponse> phoneNumber(String phoneNumber,
      {Duration? fakeDelay}) async {
    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?phoneNumber=${Uri.encodeComponent(phoneNumber)}',
        fakeDelay));
  }

  Future<ExistenceResponse> custom(Map<String, String> data,
      {Duration? fakeDelay}) async {
    var query = '';

    data.forEach((key, value) {
      query += '$key=${Uri.encodeComponent(value.toString())}&';
    });

    return (await _request(
        '${ApiOptions.path}/accounts/check-existence?$query', fakeDelay));
  }
}

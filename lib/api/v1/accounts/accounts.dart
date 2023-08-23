import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';

class Accounts {
  void me() {
    throw UnimplementedError();
  }

  Future<bool> login(String email, String password) async {
    return (await Requests.buildAccountResponse(
            '${ApiOptions.path}/accounts/login'))
        .ok;
  }
}

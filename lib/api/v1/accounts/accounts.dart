import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

class Accounts {
  void me() {
    throw UnimplementedError();
  }

  Future<ApiResponse<AccountResponse?>> login(
      String email, String password) async {
    return (await AccountResponse.buildAccountResponse(
        '${ApiOptions.path}/accounts/login',
        method: 'POST',
        data: {
          'email': email,
          'password': password,
        }));
  }
}

import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/responses.dart';

// Class for handling account-related operations
class Accounts {
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
}

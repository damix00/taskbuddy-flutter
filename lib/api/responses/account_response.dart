import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/responses/responses.dart';

// Represents user information received from the server response
class AccountResponseUser {
  final String uuid;
  final String email;
  final String username;
  final String phoneNumber;
  final DateTime lastLogin;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime createdAt;

  AccountResponseUser({
    required this.uuid,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.lastLogin,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
  });

  // Factory method to create an AccountResponseUser from JSON data
  factory AccountResponseUser.fromJson(Map<String, dynamic> json) {
    return AccountResponseUser(
      uuid: json['uuid'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      lastLogin: DateTime.parse(json['last_login']),
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Represents required actions (like verification) from the server response
class AccountResponseRequiredActions {
  final bool verifyPhoneNumber;
  final bool verifyEmail;

  AccountResponseRequiredActions({
    required this.verifyPhoneNumber,
    required this.verifyEmail,
  });

  // Factory method to create an AccountResponseRequiredActions from JSON data
  factory AccountResponseRequiredActions.fromJson(Map<String, dynamic> json) {
    return AccountResponseRequiredActions(
      verifyPhoneNumber: json['verify_phone_number'],
      verifyEmail: json['verify_email'],
    );
  }

  String toJson() {
    return '{"verify_phone_number": $verifyPhoneNumber, "verify_email": $verifyEmail}';
  }
}

// Represents the entire response from the server including user data and actions
class AccountResponse {
  final AccountResponseUser user;
  final AccountResponseRequiredActions requiredActions;
  final String token;

  AccountResponse({
    required this.user,
    required this.requiredActions,
    required this.token,
  });

  // Factory method to create an AccountResponse from JSON data
  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      user: AccountResponseUser.fromJson(json['user']),
      requiredActions:
          AccountResponseRequiredActions.fromJson(json['required_actions']),
      token: json['token'],
    );
  }

  // Static method to build an ApiResponse<AccountResponse?>
  static Future<ApiResponse<AccountResponse?>> buildAccountResponse(
      String endpoint,
      {dynamic data,
      Map<String, String>? headers,
      String method = "GET"}) async {
    // Fetch the response using the Requests class
    final response = await Requests.fetchEndpoint(
        endpoint, data: data, headers: headers, method: method);

    // Handle various response scenarios and construct ApiResponse
    if (response == null) {
      return ApiResponse(
          status: 500, message: 'Something went wrong', ok: false);
    }

    if (response.timedOut) {
      return ApiResponse(
          status: 408, message: 'Request timed out', ok: false, timedOut: true);
    }

    final json = response.response!.data;

    if (response.response!.statusCode != 200) {
      return ApiResponse(
          status: response.response!.statusCode ?? 500,
          message: json["message"],
          ok: false);
    }

    return ApiResponse(
        status: 200,
        message: json["message"],
        ok: true,
        data: AccountResponse.fromJson(json),
        response: response.response,
        timedOut: response.timedOut);
  }
}

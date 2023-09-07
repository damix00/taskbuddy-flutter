import 'package:taskbuddy/api/responses/responses.dart';

class ExistenceResponse {
  final bool? username;
  final bool? email;
  final bool? phoneNumber;

  final ErrorType? error;

  ExistenceResponse({this.username, this.email, this.phoneNumber, this.error});

  factory ExistenceResponse.fromJson(Map<String, dynamic>? json) {
    return ExistenceResponse(
      username: json?['username'],
      email: json?['email'],
      phoneNumber: json?['phoneNumber'],
      error: null,
    );
  }
}

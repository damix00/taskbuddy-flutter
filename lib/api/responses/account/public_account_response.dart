import 'package:taskbuddy/api/responses/account/profile_response.dart';

class PublicAccountResponse {
  final ProfileResponse profile;
  final String UUID;
  final String username;
  final String firstName;
  final String lastName;
  final bool hasPremium;
  final bool verified;
  final bool isFollowing;

  PublicAccountResponse({
    required this.profile,
    required this.UUID,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.hasPremium,
    required this.verified,
    required this.isFollowing,
  });

  // Factory method to create a PublicAccountResponse from JSON data
  factory PublicAccountResponse.fromJson(Map<String, dynamic> json) {
    return PublicAccountResponse(
      profile: ProfileResponse.fromJson(json['profile']),
      UUID: json['uuid'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      hasPremium: json['has_premium'] ?? false,
      verified: json['verified'] ?? false,
      isFollowing: json['is_following'] ?? false,
    );
  }
}
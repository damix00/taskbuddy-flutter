import 'package:taskbuddy/api/responses/account/profile_response.dart';

class PublicAccountResponse {
  ProfileResponse profile;
  String UUID;
  String username;
  String firstName;
  String lastName;
  bool hasPremium;
  bool verified;
  bool isFollowing;
  bool isMe;

  PublicAccountResponse({
    required this.profile,
    required this.UUID,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.hasPremium,
    required this.verified,
    required this.isFollowing,
    required this.isMe,
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
      isMe: json['is_me'] ?? false,
    );
  }
}